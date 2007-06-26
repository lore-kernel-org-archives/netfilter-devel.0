From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_u32 20070626 (iptables part)
Date: Tue, 26 Jun 2007 18:49:37 +0200
Message-ID: <468143A1.7020308@trash.net>
References: <1182849745.22167.13.camel@blas>
	<4680E3D7.6020401@netfilter.org>	<4680E5CC.8070807@trash.net>	<Pine.LNX.4.64.0706261423150.3137@fbirervta.pbzchgretzou.qr>	<46810B7A.5020609@trash.net>	<Pine.LNX.4.64.0706261511140.3137@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706261513100.3137@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706261513100.3137@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Index: iptables/extensions/.u32-test
> ===================================================================
> --- /dev/null
> +++ iptables/extensions/.u32-test
> @@ -0,0 +1,2 @@
> +#!/bin/sh
> +[ -f "$KERNEL_DIR/include/linux/netfilter/xt_u32.h" ] && echo u32
> Index: iptables/extensions/libip6t_u32.c
> ===================================================================
>   

Having to build against a kernel tree sucks, please add
the header and build unconditionally.


> +/* shared printing code */
> +static void u32_dump(const struct xt_u32 *data)
> +{
> +	const struct xt_u32_test *ct;
> +	unsigned int testind, i;
> +
> +	for (testind = 0; testind < data->ntests; ++testind) {
> +		ct = &data->tests[testind];
> +
> +		if (testind > 0)
> +			printf("&&");
> +
> +		printf("0x%x", ct->location[0].number);
> +		for (i = 1; i < ct->nnums; ++i) {
> +			switch (ct->location[i].nextop) {
> +			case XT_U32_AND:
> +				printf("&");
> +				break;
> +			case XT_U32_LEFTSH:
> +				printf("<<");
> +				break;
> +			case XT_U32_RIGHTSH:
> +				printf(">>");
> +				break;
> +			case XT_U32_AT:
> +				printf("@");
> +				break;
> +			}
> +			printf("0x%x", ct->location[i].number);
> +		}
> +
> +		printf("=");
> +		for (i = 0; i < ct->nvalues; ++i) {
> +			if (i > 0)
> +				printf(",");
> +			if (ct->value[i].min == ct->value[i].max)
> +				printf("0x%x", ct->value[i].min);
> +			else
> +				printf("0x%x:0x%x", ct->value[i].min,
> +				       ct->value[i].max);
> +		}
> +	}
> +	printf(" ");
> +}
> +
> +/* string_to_number is not quite what we need here ... */
> +static uint32_t parse_number(char **s, int pos)
> +{
> +	uint32_t number;
> +	char *end;
> +	errno = 0;
> +
> +	number = strtoul(*s, &end, 0);
> +	if (end == *s)
> +		exit_error(PARAMETER_PROBLEM,
> +			   "u32: at char %d: expected number", pos);
> +	if (errno)
> +		exit_error(PARAMETER_PROBLEM,
> +			   "u32: at char %d: error reading number", pos);
> +	*s = end;
> +	return number;
> +}
> +
> +/* Function which parses command options; returns true if it ate an option */
> +static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
> +		     const struct ip6t_entry *entry, unsigned int *nfcache,
> +		     struct ip6t_entry_match **match)
> +{
> +	struct xt_u32 *data = (void *)(*match)->data;
> +	unsigned int testind = 0, locind = 0, valind = 0;
> +	struct xt_u32_test *ct = &data->tests[testind]; /* current test */
> +	char *arg = argv[optind-1]; /* the argument string */
> +	char *start = arg;
> +	int state = 0;
> +
> +	if (c != '1')
> +		return 0;
> +
> +	data->invert = invert;
> +
> +	/*
> +	 * states:
> +	 * 0 = looking for numbers and operations,
> +	 * 1 = looking for ranges
> +	 */
> +	while (1) {
> +		/* read next operand/number or range */
> +		while (isspace(*arg))
> +			++arg;
> +
> +		if (*arg == '\0') {
> +			/* end of argument found */
> +			if (state == 0)
> +				exit_error(PARAMETER_PROBLEM,
> +					   "u32: input ended in location spec");
> +			if (valind == 0)
> +				exit_error(PARAMETER_PROBLEM,
> +					   "u32: test ended with no value spec");
> +
> +			ct->nnums    = locind;
> +			ct->nvalues  = valind;
> +			data->ntests = ++testind;
> +
> +			if (testind > XT_U32_MAXSIZE)
> +				exit_error(PARAMETER_PROBLEM,
> +				           "u32: at char %d: too many \"&&\"s",
> +				           arg - start);
> +			return 1;
> +		}
> +
> +		if (state == 0) {
> +			/*
> +			 * reading location: read a number if nothing read yet,
> +			 * otherwise either op number or = to end location spec
> +			 */
> +			if (*arg == '=') {
> +				if (locind == 0) {
> +					exit_error(PARAMETER_PROBLEM,
> +					           "u32: at char %d: "
> +					           "location spec missing",
> +					           arg - start);
> +				} else {
> +					++arg;
> +					state = 1;
> +				}
> +			} else {
> +				if (locind != 0) {
> +					/* need op before number */
> +					if (*arg == '&') {
> +						ct->location[locind].nextop = XT_U32_AND;
> +					} else if (*arg == '<') {
> +						if (*++arg != '<')
> +							exit_error(PARAMETER_PROBLEM,
> +								   "u32: at char %d: a second < expected", arg - start);
> +						ct->location[locind].nextop = XT_U32_LEFTSH;
> +					} else if (*arg == '>') {
> +						if (*++arg != '>')
> +							exit_error(PARAMETER_PROBLEM,
> +								   "u32: at char %d: a second > expected", arg - start);
> +						ct->location[locind].nextop = XT_U32_RIGHTSH;
> +					} else if (*arg == '@') {
> +						ct->location[locind].nextop = XT_U32_AT;
> +					} else {
> +						exit_error(PARAMETER_PROBLEM,
> +							"u32: at char %d: operator expected", arg - start);
> +					}
> +					++arg;
> +				}
> +				/* now a number; string_to_number skips white space? */
> +				ct->location[locind].number =
> +					parse_number(&arg, arg - start);
> +				if (++locind > XT_U32_MAXSIZE)
> +					exit_error(PARAMETER_PROBLEM,
> +						   "u32: at char %d: too many operators", arg - start);
> +			}
> +		} else {
> +			/*
> +			 * state 1 - reading values: read a range if nothing
> +			 * read yet, otherwise either ,range or && to end
> +			 * test spec
> +			 */
> +			if (*arg == '&') {
> +				if (*++arg != '&')
> +					exit_error(PARAMETER_PROBLEM,
> +						   "u32: at char %d: a second & was expected", arg - start);
> +				if (valind == 0) {
> +					exit_error(PARAMETER_PROBLEM,
> +						   "u32: at char %d: value spec missing", arg - start);
> +				} else {
> +					ct->nnums   = locind;
> +					ct->nvalues = valind;
> +					ct = &data->tests[++testind];
> +					if (testind > XT_U32_MAXSIZE)
> +						exit_error(PARAMETER_PROBLEM,
> +							   "u32: at char %d: too many \"&&\"s", arg - start);
> +					++arg;
> +					state  = 0;
> +					locind = 0;
> +					valind = 0;
> +				}
> +			} else { /* read value range */
> +				if (valind > 0) { /* need , before number */
> +					if (*arg != ',')
> +						exit_error(PARAMETER_PROBLEM,
> +							   "u32: at char %d: expected , or &&", arg - start);
> +					++arg;
> +				}
> +				ct->value[valind].min =
> +					parse_number(&arg, arg - start);
> +
> +				while (isspace(*arg))
> +					++arg;
> +
> +				if (*arg == ':') {
> +					++arg;
> +					ct->value[valind].max =
> +						parse_number(&arg, arg-start);
> +				} else {
> +					ct->value[valind].max =
> +						ct->value[valind].min;
> +				}
> +
> +				if (++valind > XT_U32_MAXSIZE)
> +					exit_error(PARAMETER_PROBLEM,
> +						   "u32: at char %d: too many \",\"s", arg - start);
>   

Thats not very understandable code. I hope I never have
to fix anything in there ..
