module Totango
  class InvalidParamError < StandardError; end

  class ArgParser
    class <<self
      attr_reader :named_args

      def parse(args)
        new.tap do |parser|
          args.each do |arg, val|
            param = registered_args[arg]
            if param
              parser[param] = val
            else
              parser[arg] = val
            end
          end
        end
      end

      private

      def parses_arg(name, *aliases)
        aliases.unshift(name).each do |argname|
          registered_args[argname] = name
        end
      end

      def registered_args
        @__registered_args__ ||= {}
      end

      def register_named_arg!(name)
        @named_args ||= []
        @named_args << name
      end
    end

    parses_arg :sdr_a, :a, :act, :activity
    parses_arg :sdr_odn, :o, :org, :organization
    parses_arg :sdr_m, :m, :mod, :module
    parses_arg :sdr_u, :u, :user
    parses_arg :sdr_o, :ofid, :organization_foreign_id, :account_id
    parses_arg :sdr_ofid, :sf_account_id

    def to_params
      @params.collect do |arg, val|
        [arg, CGI.escape(val.to_s)].join("=")
      end.join("&")
    end

    def [](arg)
      @params[arg]
    end

    def []=(arg, val)
      @params ||= {}
      @params[arg] = val
    end
  end
end

