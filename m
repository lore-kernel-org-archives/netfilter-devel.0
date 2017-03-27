From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 3/5] ipset: hash:ipport: netmask support
Date: Mon, 27 Mar 2017 22:12:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1703272209180.16553@blackhole.kfki.hu>
References: <1490121597-2140-1-git-send-email-johunt@akamai.com> <1490121597-2140-4-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:60931 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751716AbdC0UMc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 16:12:32 -0400
In-Reply-To: <1490121597-2140-4-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 21 Mar 2017, Josh Hunt wrote:

> Adds netmask support to hash:ipport sets.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  lib/ipset_hash_ipport.c | 194 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 194 insertions(+)
> 
> diff --git a/lib/ipset_hash_ipport.c b/lib/ipset_hash_ipport.c
> index 2166922..a2cf79e 100644
> --- a/lib/ipset_hash_ipport.c
> +++ b/lib/ipset_hash_ipport.c
> @@ -787,6 +787,199 @@ static struct ipset_type ipset_hash_ipport5 = {
>  	.description = "skbinfo support",
>  };
>  
> +/* Parse commandline arguments */
> +static const struct ipset_arg hash_ipport_create_args6[] = {
> +	{ .name = { "family", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
> +	  .parse = ipset_parse_family,		.print = ipset_print_family,
> +	},
> +	/* Alias: family inet */
> +	{ .name = { "-4", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
> +	  .parse = ipset_parse_family,
> +	},
> +	/* Alias: family inet6 */
> +	{ .name = { "-6", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
> +	  .parse = ipset_parse_family,
> +	},
> +	{ .name = { "hashsize", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
> +	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
> +	},
> +	{ .name = { "maxelem", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
> +	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
> +	},
> +	{ .name = { "timeout", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
> +	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
> +	},
> +	{ .name = { "counters", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ .name = { "comment", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ .name = { "forceadd", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FORCEADD,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ .name = { "skbinfo", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_SKBINFO,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ .name = { "netmask", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,       .opt = IPSET_OPT_NETMASK_MASK,
> +	  .parse = ipset_parse_netmask,         .print = ipset_print_netmask,

With the modified parser you can use IPSET_OPT_NETMASK here - and the same 
comment for the hash:ip,port type.

> +	},
> +	/* Backward compatibility */
> +	{ .name = { "probes", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
> +	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
> +	},
> +	{ .name = { "resize", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
> +	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
> +	},
> +	{ .name = { "from", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
> +	  .parse = ipset_parse_ignored,
> +	},
> +	{ .name = { "to", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
> +	  .parse = ipset_parse_ignored,
> +	},
> +	{ .name = { "network", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
> +	  .parse = ipset_parse_ignored,
> +	},
> +	{ },
> +};
> +
> +static const struct ipset_arg hash_ipport_add_args6[] = {
> +	{ .name = { "timeout", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
> +	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
> +	},
> +	{ .name = { "packets", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PACKETS,
> +	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
> +	},
> +	{ .name = { "bytes", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
> +	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
> +	},
> +	{ .name = { "comment", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_ADT_COMMENT,
> +	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
> +	},
> +	{ .name = { "skbmark", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SKBMARK,
> +	  .parse = ipset_parse_skbmark,		.print = ipset_print_skbmark,
> +	},
> +	{ .name = { "skbprio", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SKBPRIO,
> +	  .parse = ipset_parse_skbprio,		.print = ipset_print_skbprio,
> +	},
> +	{ .name = { "skbqueue", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_SKBQUEUE,
> +	  .parse = ipset_parse_uint16,		.print = ipset_print_number,
> +	},
> +	{ },
> +};
> +
> +static const char hash_ipport_usage6[] =
> +"create SETNAME hash:ip,port\n"
> +"		[family inet|inet6]\n"
> +"               [hashsize VALUE] [maxelem VALUE]\n"
> +"               [timeout VALUE] [counters] [comment]\n"
> +"		[forceadd] [skbinfo] [netmask CIDR or MASK]\n"
> +"add    SETNAME IP,PROTO:PORT [timeout VALUE]\n"
> +"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
> +"		[skbmark VALUE] [skbprio VALUE] [skbqueue VALUE]\n"
> +"del    SETNAME IP,PROTO:PORT\n"
> +"test   SETNAME IP,PROTO:PORT\n\n"
> +"where depending on the INET family\n"
> +"      IP is a valid IPv4 or IPv6 address (or hostname).\n"
> +"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
> +"      is supported for IPv4.\n"
> +"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
> +"      port range is supported both for IPv4 and IPv6.\n";
> +
> +static struct ipset_type ipset_hash_ipport6 = {
> +	.name = "hash:ip,port",
> +	.alias = { "ipporthash", NULL },
> +	.revision = 6,
> +	.family = NFPROTO_IPSET_IPV46,
> +	.dimension = IPSET_DIM_TWO,
> +	.elem = {
> +		[IPSET_DIM_ONE - 1] = {
> +			.parse = ipset_parse_ip4_single6,
> +			.print = ipset_print_ip,
> +			.opt = IPSET_OPT_IP
> +		},
> +		[IPSET_DIM_TWO - 1] = {
> +			.parse = ipset_parse_proto_port,
> +			.print = ipset_print_proto_port,
> +			.opt = IPSET_OPT_PORT
> +		},
> +	},
> +	.args = {
> +		[IPSET_CREATE] = hash_ipport_create_args6,
> +		[IPSET_ADD] = hash_ipport_add_args6,
> +	},
> +	.mandatory = {
> +		[IPSET_CREATE] = 0,
> +		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_PROTO)
> +			| IPSET_FLAG(IPSET_OPT_PORT),
> +		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_PROTO)
> +			| IPSET_FLAG(IPSET_OPT_PORT),
> +		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_PROTO)
> +			| IPSET_FLAG(IPSET_OPT_PORT),
> +	},
> +	.full = {
> +		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
> +			| IPSET_FLAG(IPSET_OPT_MAXELEM)
> +			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
> +			| IPSET_FLAG(IPSET_OPT_COUNTERS)
> +			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)
> +			| IPSET_FLAG(IPSET_OPT_FORCEADD)
> +			| IPSET_FLAG(IPSET_OPT_SKBINFO)
> +			| IPSET_FLAG(IPSET_OPT_NETMASK)
> +			| IPSET_FLAG(IPSET_OPT_NETMASK_MASK),
> +		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_IP_TO)
> +			| IPSET_FLAG(IPSET_OPT_PORT)
> +			| IPSET_FLAG(IPSET_OPT_PORT_TO)
> +			| IPSET_FLAG(IPSET_OPT_PROTO)
> +			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
> +			| IPSET_FLAG(IPSET_OPT_PACKETS)
> +			| IPSET_FLAG(IPSET_OPT_BYTES)
> +			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT)
> +			| IPSET_FLAG(IPSET_OPT_SKBMARK)
> +			| IPSET_FLAG(IPSET_OPT_SKBPRIO)
> +			| IPSET_FLAG(IPSET_OPT_SKBQUEUE),
> +		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_IP_TO)
> +			| IPSET_FLAG(IPSET_OPT_PORT)
> +			| IPSET_FLAG(IPSET_OPT_PORT_TO)
> +			| IPSET_FLAG(IPSET_OPT_PROTO),
> +		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
> +			| IPSET_FLAG(IPSET_OPT_PORT)
> +			| IPSET_FLAG(IPSET_OPT_PROTO),
> +	},
> +
> +	.usage = hash_ipport_usage6,
> +	.usagefn = ipset_port_usage,
> +	.description = "netmask support",
> +};
> +
>  void _init(void);
>  void _init(void)
>  {
> @@ -795,4 +988,5 @@ void _init(void)
>  	ipset_type_add(&ipset_hash_ipport3);
>  	ipset_type_add(&ipset_hash_ipport4);
>  	ipset_type_add(&ipset_hash_ipport5);
> +	ipset_type_add(&ipset_hash_ipport6);
>  }
> -- 
> 1.9.1

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
