From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] ebtables: extend ebt_ip6 to allow matching on ipv6-icmp
 types/codes
Date: Sat, 18 Dec 2010 17:35:16 +0100
Message-ID: <4D0CE2C4.2050007@pandora.be>
References: <20101217162427.GA16467@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:53827 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0LRQkU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:40:20 -0500
In-Reply-To: <20101217162427.GA16467@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

This patch looks good. I'll apply it once the kernel patch is applied.

cheers,
Bart

On 17-12-10 17:24, Florian Westphal wrote:
> adds a --ip6-icmp-type option to match on ipv6-icmp types/codes.
> The ipv6-icmp name list was taken from iptables 1.4.9.
>
> Signed-off-by: Florian Westphal<fwestphal@astaro.com>
> ---
>   ebtables.8           |   11 +++
>   extensions/ebt_ip6.c |  227 +++++++++++++++++++++++++++++++++++++++++++++++++-
>   include/ebtables_u.h |    4 +
>   3 files changed, 240 insertions(+), 2 deletions(-)
>
> diff --git a/ebtables.8 b/ebtables.8
> index 957c445..6c7acf7 100644
> --- a/ebtables.8
> +++ b/ebtables.8
> @@ -700,6 +700,17 @@ If
>   The flag
>   .B --ip6-dport
>   is an alias for this option.
> +.TP
> +.BR "--ip6-icmp-type " "[!] {\fItype\fP[:\fItype\fP]/\fIcode\fP[:\fIcode\fP]|\fItypename\fP}"
> +Specify ipv6\-icmp type and code to match.
> +Ranges for both type and code are supported. Type and code are
> +separated by a slash. Valid numbers for type and range are 0 to 255.
> +To match a single type including all valid codes, symbolic names can
> +be used instead of numbers. The list of known type names is shown by the command
> +.nf
> +  ebtables \-\-help ip6
> +.fi
> +This option is only valid for \-\-ip6-prococol ipv6-icmp.
>   .SS limit
>   This module matches at a limited rate using a token bucket filter.
>   A rule using this extension will match until this limit is reached.
> diff --git a/extensions/ebt_ip6.c b/extensions/ebt_ip6.c
> index 5850523..9ab177d 100644
> --- a/extensions/ebt_ip6.c
> +++ b/extensions/ebt_ip6.c
> @@ -11,6 +11,9 @@
>    *
>    */
>
> +#include<errno.h>
> +#include<inttypes.h>
> +#include<limits.h>
>   #include<stdio.h>
>   #include<stdlib.h>
>   #include<string.h>
> @@ -27,8 +30,9 @@
>   #define IP_PROTO  '4'
>   #define IP_SPORT  '5'
>   #define IP_DPORT  '6'
> +#define IP_ICMP6  '7'
>
> -static struct option opts[] =
> +static const struct option opts[] =
>   {
>   	{ "ip6-source"           , required_argument, 0, IP_SOURCE },
>   	{ "ip6-src"              , required_argument, 0, IP_SOURCE },
> @@ -42,9 +46,55 @@ static struct option opts[] =
>   	{ "ip6-sport"            , required_argument, 0, IP_SPORT  },
>   	{ "ip6-destination-port" , required_argument, 0, IP_DPORT  },
>   	{ "ip6-dport"            , required_argument, 0, IP_DPORT  },
> +	{ "ip6-icmp-type"	 , required_argument, 0, IP_ICMP6  },
>   	{ 0 }
>   };
>
> +
> +struct icmpv6_names {
> +	const char *name;
> +	u_int8_t type;
> +	u_int8_t code_min, code_max;
> +};
> +
> +static const struct icmpv6_names icmpv6_codes[] = {
> +	{ "destination-unreachable", 1, 0, 0xFF },
> +	{ "no-route", 1, 0, 0 },
> +	{ "communication-prohibited", 1, 1, 1 },
> +	{ "address-unreachable", 1, 3, 3 },
> +	{ "port-unreachable", 1, 4, 4 },
> +
> +	{ "packet-too-big", 2, 0, 0xFF },
> +
> +	{ "time-exceeded", 3, 0, 0xFF },
> +	/* Alias */ { "ttl-exceeded", 3, 0, 0xFF },
> +	{ "ttl-zero-during-transit", 3, 0, 0 },
> +	{ "ttl-zero-during-reassembly", 3, 1, 1 },
> +
> +	{ "parameter-problem", 4, 0, 0xFF },
> +	{ "bad-header", 4, 0, 0 },
> +	{ "unknown-header-type", 4, 1, 1 },
> +	{ "unknown-option", 4, 2, 2 },
> +
> +	{ "echo-request", 128, 0, 0xFF },
> +	/* Alias */ { "ping", 128, 0, 0xFF },
> +
> +	{ "echo-reply", 129, 0, 0xFF },
> +	/* Alias */ { "pong", 129, 0, 0xFF },
> +
> +	{ "router-solicitation", 133, 0, 0xFF },
> +
> +	{ "router-advertisement", 134, 0, 0xFF },
> +
> +	{ "neighbour-solicitation", 135, 0, 0xFF },
> +	/* Alias */ { "neighbor-solicitation", 135, 0, 0xFF },
> +
> +	{ "neighbour-advertisement", 136, 0, 0xFF },
> +	/* Alias */ { "neighbor-advertisement", 136, 0, 0xFF },
> +
> +	{ "redirect", 137, 0, 0xFF },
> +};
> +
>   /* transform a protocol and service name into a port number */
>   static uint16_t parse_port(const char *protocol, const char *name)
>   {
> @@ -91,6 +141,97 @@ parse_port_range(const char *protocol, const char *portstring, uint16_t *ports)
>   	free(buffer);
>   }
>
> +static char*
> +parse_num(const char *str, long min, long max, long *num)
> +{
> +	char *end;
> +
> +	errno = 0;
> +	*num = strtol(str,&end, 10);
> +	if (errno&&  (*num == LONG_MIN || *num == LONG_MAX)) {
> +		ebt_print_error("Invalid number %s: %s", str, strerror(errno));
> +		return NULL;
> +	}
> +	if (min<= max) {
> +		if (*num>  max || *num<  min) {
> +			ebt_print_error("Value %ld out of range (%ld, %ld)", *num, min, max);
> +			return NULL;
> +		}
> +	}
> +	if (*num == 0&&  str == end)
> +		return NULL;
> +	return end;
> +}
> +
> +static char *
> +parse_range(const char *str, long min, long max, long num[])
> +{
> +	char *next;
> +
> +	next = parse_num(str, min, max, num);
> +	if (next == NULL)
> +		return NULL;
> +	if (next&&  *next == ':')
> +		next = parse_num(next+1, min, max,&num[1]);
> +	else
> +		num[1] = num[0];
> +	return next;
> +}
> +
> +static int
> +parse_icmpv6(const char *icmpv6type, uint8_t type[], uint8_t code[])
> +{
> +	static const unsigned int limit = ARRAY_SIZE(icmpv6_codes);
> +	unsigned int match = limit;
> +	unsigned int i;
> +	long number[2];
> +
> +	for (i = 0; i<  limit; i++) {
> +		if (strncasecmp(icmpv6_codes[i].name, icmpv6type, strlen(icmpv6type)))
> +			continue;
> +		if (match != limit)
> +			ebt_print_error("Ambiguous ICMPv6 type `%s':"
> +					" `%s' or `%s'?",
> +					icmpv6type, icmpv6_codes[match].name,
> +					icmpv6_codes[i].name);
> +		match = i;
> +	}
> +
> +	if (match<  limit) {
> +		type[0] = type[1] = icmpv6_codes[match].type;
> +		code[0] = icmpv6_codes[match].code_min;
> +		code[1] = icmpv6_codes[match].code_max;
> +	} else {
> +		char *next = parse_range(icmpv6type, 0, 255, number);
> +		if (!next) {
> +			ebt_print_error("Unknown ICMPv6 type `%s'",
> +							icmpv6type);
> +			return -1;
> +		}
> +		type[0] = (uint8_t) number[0];
> +		type[1] = (uint8_t) number[1];
> +		switch (*next) {
> +		case 0:
> +			code[0] = 0;
> +			code[1] = 255;
> +			return 0;
> +		case '/':
> +			next = parse_range(next+1, 0, 255, number);
> +			code[0] = (uint8_t) number[0];
> +			code[1] = (uint8_t) number[1];
> +			if (next == NULL)
> +				return -1;
> +			if (next&&  *next == 0)
> +				return 0;
> +		/* fallthrough */
> +		default:
> +			ebt_print_error("unknown character %c", *next);
> +			return -1;
> +		}
> +	}
> +	return 0;
> +}
> +
>   static void print_port_range(uint16_t *ports)
>   {
>   	if (ports[0] == ports[1])
> @@ -99,6 +240,58 @@ static void print_port_range(uint16_t *ports)
>   		printf("%d:%d ", ports[0], ports[1]);
>   }
>
> +static void print_icmp_code(uint8_t *code)
> +{
> +	if (code[0] == code[1])
> +		printf("/%"PRIu8 " ", code[0]);
> +	else
> +		printf("/%"PRIu8":%"PRIu8 " ", code[0], code[1]);
> +}
> +
> +static void print_icmp_type(uint8_t *type, uint8_t *code)
> +{
> +	unsigned int i;
> +
> +	if (type[0] != type[1]) {
> +		printf("%"PRIu8 ":%" PRIu8, type[0], type[1]);
> +		print_icmp_code(code);
> +		return;
> +	}
> +
> +	for (i = 0; i<  ARRAY_SIZE(icmpv6_codes); i++) {
> +		if (icmpv6_codes[i].type != type[0])
> +			continue;
> +
> +		if (icmpv6_codes[i].code_min == code[0]&&
> +		    icmpv6_codes[i].code_max == code[1]) {
> +			printf("%s ", icmpv6_codes[i].name);
> +			return;
> +		}
> +	}
> +	printf("%"PRIu8, type[0]);
> +	print_icmp_code(code);
> +}
> +
> +static void print_icmpv6types(void)
> +{
> +	unsigned int i;
> +        printf("Valid ICMPv6 Types:");
> +
> +	for (i=0; i<  ARRAY_SIZE(icmpv6_codes); i++) {
> +		if (i&&  icmpv6_codes[i].type == icmpv6_codes[i-1].type) {
> +			if (icmpv6_codes[i].code_min == icmpv6_codes[i-1].code_min
> +			&&  (icmpv6_codes[i].code_max
> +			        == icmpv6_codes[i-1].code_max))
> +				printf(" (%s)", icmpv6_codes[i].name);
> +			else
> +				printf("\n   %s", icmpv6_codes[i].name);
> +		}
> +		else
> +			printf("\n%s", icmpv6_codes[i].name);
> +	}
> +	printf("\n");
> +}
> +
>   static void print_help()
>   {
>   	printf(
> @@ -108,7 +301,9 @@ static void print_help()
>   "--ip6-tclass [!] tclass        : ipv6 traffic class specification\n"
>   "--ip6-proto  [!] protocol      : ipv6 protocol specification\n"
>   "--ip6-sport  [!] port[:port]   : tcp/udp source port or port range\n"
> -"--ip6-dport  [!] port[:port]   : tcp/udp destination port or port range\n");
> +"--ip6-dport  [!] port[:port]   : tcp/udp destination port or port range\n"
> +"--ip6-icmp-type [!] type[[:type]/code[:code]] : ipv6-icmp type/code or type/code range\n");
> +print_icmpv6types();
>   }
>
>   static void init(struct ebt_entry_match *match)
> @@ -170,6 +365,15 @@ static int parse(int c, char **argv, int argc, const struct ebt_u_entry *entry,
>   			parse_port_range(NULL, optarg, ipinfo->dport);
>   		break;
>
> +	case IP_ICMP6:
> +		ebt_check_option2(flags, EBT_IP6_ICMP6);
> +		ipinfo->bitmask |= EBT_IP6_ICMP6;
> +		if (ebt_check_inverse2(optarg))
> +			ipinfo->invflags |= EBT_IP6_ICMP6;
> +		if (parse_icmpv6(optarg, ipinfo->icmpv6_type, ipinfo->icmpv6_code))
> +			return 0;
> +		break;
> +
>   	case IP_TCLASS:
>   		ebt_check_option2(flags, OPT_TCLASS);
>   		if (ebt_check_inverse2(optarg))
> @@ -223,6 +427,12 @@ static void final_check(const struct ebt_u_entry *entry,
>   		ebt_print_error("For port filtering the IP protocol must be "
>   				"either 6 (tcp), 17 (udp), 33 (dccp) or "
>   				"132 (sctp)");
> +	if ((ipinfo->bitmask&  EBT_IP6_ICMP6)&&
> +	  (!(ipinfo->bitmask&  EBT_IP6_PROTO) ||
> +	     ipinfo->invflags&  EBT_IP6_PROTO ||
> +	     ipinfo->protocol != IPPROTO_ICMPV6))
> +		ebt_print_error("For ipv6-icmp filtering the IP protocol must be "
> +				"58 (ipv6-icmp)");
>   }
>
>   static void print(const struct ebt_u_entry *entry,
> @@ -275,6 +485,12 @@ static void print(const struct ebt_u_entry *entry,
>   			printf("! ");
>   		print_port_range(ipinfo->dport);
>   	}
> +	if (ipinfo->bitmask&  EBT_IP6_ICMP6) {
> +		printf("--ip6-icmp-type ");
> +		if (ipinfo->invflags&  EBT_IP6_ICMP6)
> +			printf("! ");
> +		print_icmp_type(ipinfo->icmpv6_type, ipinfo->icmpv6_code);
> +	}
>   }
>
>   static int compare(const struct ebt_entry_match *m1,
> @@ -317,6 +533,13 @@ static int compare(const struct ebt_entry_match *m1,
>   		   ipinfo1->dport[1] != ipinfo2->dport[1])
>   			return 0;
>   	}
> +	if (ipinfo1->bitmask&  EBT_IP6_ICMP6) {
> +		if (ipinfo1->icmpv6_type[0] != ipinfo2->icmpv6_type[0] ||
> +		    ipinfo1->icmpv6_type[1] != ipinfo2->icmpv6_type[1] ||
> +		    ipinfo1->icmpv6_code[0] != ipinfo2->icmpv6_code[0] ||
> +		    ipinfo1->icmpv6_code[1] != ipinfo2->icmpv6_code[1])
> +			return 0;
> +	}
>   	return 1;
>   }
>
> diff --git a/include/ebtables_u.h b/include/ebtables_u.h
> index 910c213..c29476d 100644
> --- a/include/ebtables_u.h
> +++ b/include/ebtables_u.h
> @@ -376,4 +376,8 @@ extern int ebt_printstyle_mac;
>   #define PROC_SYS_MODPROBE "/proc/sys/kernel/modprobe"
>   #endif
>   #define ATOMIC_ENV_VARIABLE "EBTABLES_ATOMIC_FILE"
> +
> +#ifndef ARRAY_SIZE
> +# define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
> +#endif
>   #endif /* EBTABLES_U_H */


-- 
Bart De Schuymer
www.artinalgorithms.be

