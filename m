From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 7/7] ipset: Add new userspace set revisions for comment
 support
Date: Mon, 23 Sep 2013 14:34:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309231430510.3776@blackhole.kfki.hu>
References: <1379876196-46929-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379876196-46929-7-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:53437 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab3IWMfB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:35:01 -0400
In-Reply-To: <1379876196-46929-7-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 22 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This introduces new revisions of all hash and bitmap ipsets to
> complement the comment functionality introduced into the kernel modules.
> 
> Currently all sets have a compile-time limit of 255 characters including
> \0. This can otherwise be arbitrarily modified.

Patch is applied, with a fix and a minor modifications:
 
> diff --git a/lib/ipset_bitmap_ipmac.c b/lib/ipset_bitmap_ipmac.c
> index 67217a9..084f2fc 100644
> --- a/lib/ipset_bitmap_ipmac.c
> +++ b/lib/ipset_bitmap_ipmac.c
> @@ -207,9 +207,127 @@ static struct ipset_type ipset_bitmap_ipmac1 = {
>  	.description = "counters support",
>  };
>  
> +/* Parse commandline arguments */
> +static const struct ipset_arg bitmap_ipmac_create_args2[] = {
> +	{ .name = { "range", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
> +	  .parse = ipset_parse_netrange,	.print = ipset_print_ip,
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
> +	/* Backward compatibility */
> +	{ .name = { "from", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
> +	  .parse = ipset_parse_single_ip,
> +	},
> +	{ .name = { "to", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP_TO,
> +	  .parse = ipset_parse_single_ip,
> +	},
> +	{ .name = { "network", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_IP,
> +	  .parse = ipset_parse_net,
> +	},
> +	{ },
> +};
> +
> +static const struct ipset_arg bitmap_ipmac_add_args2[] = {
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
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
> +	  .parse = ipset_parse_comment,		.print = ipset_print_comment,

Cut&paste error, corrected to IPSET_OTP_ADT_COMMENT.

> diff --git a/lib/ipset_hash_net.c b/lib/ipset_hash_net.c
> index a80d732..99ffc1f 100644
> --- a/lib/ipset_hash_net.c
> +++ b/lib/ipset_hash_net.c
> @@ -366,6 +366,150 @@ static struct ipset_type ipset_hash_net3 = {
>  	.description = "counters support",
>  };
>  
> +/* Parse commandline arguments */
> +static const struct ipset_arg hash_net_create_args4[] = {
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
> +	/* Ignored options: backward compatibilty */

Line above is moved after the comment option.

> +	{ .name = { "comment", NULL },
> +	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
> +	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
> +	},
> +	{ .name = { "probes", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PROBES,
> +	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
> +	},
> +	{ .name = { "resize", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_RESIZE,
> +	  .parse = ipset_parse_ignored,		.print = ipset_print_number,
> +	},
> +	{ },
> +};
> +

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
