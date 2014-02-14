From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/2] ipset: add forceadd userspace support for hash set
 types
Date: Fri, 14 Feb 2014 11:10:20 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402141032310.19460@blackhole.kfki.hu>
References: <1391261452-11266-1-git-send-email-johunt@akamai.com> <1391261452-11266-3-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:52610 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbaBNKKY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:10:24 -0500
In-Reply-To: <1391261452-11266-3-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 1 Feb 2014, Josh Hunt wrote:

> The userspace side of the forceadd changes.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  include/libipset/data.h         |    4 +-
>  include/libipset/linux_ip_set.h |    1 +
>  include/libipset/parse.h        |    3 +
>  lib/data.c                      |    8 ++
>  lib/debug.c                     |    1 +
>  lib/ipset_hash_ip.c             |  123 ++++++++++++++++++++++++++++
>  lib/ipset_hash_ipmark.c         |  142 ++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipport.c         |  147 ++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipportip.c       |  158 ++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipportnet.c      |  169 +++++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_net.c            |  119 +++++++++++++++++++++++++++
>  lib/ipset_hash_netiface.c       |  125 +++++++++++++++++++++++++++++
>  lib/ipset_hash_netnet.c         |  125 +++++++++++++++++++++++++++++
>  lib/ipset_hash_netport.c        |  132 ++++++++++++++++++++++++++++++
>  lib/ipset_hash_netportnet.c     |  149 ++++++++++++++++++++++++++++++++++
>  lib/parse.c                     |   21 +++++
>  lib/print.c                     |    4 +
>  lib/session.c                   |    4 +
>  src/ipset.8                     |    7 ++
>  19 files changed, 1441 insertions(+), 1 deletions(-)
> 
> diff --git a/include/libipset/data.h b/include/libipset/data.h
> index 3a26b1e..06ece1e 100644
> --- a/include/libipset/data.h
> +++ b/include/libipset/data.h
> @@ -36,6 +36,7 @@ enum ipset_opt {
>  	IPSET_OPT_PROBES,
>  	IPSET_OPT_RESIZE,
>  	IPSET_OPT_SIZE,
> +	IPSET_OPT_FORCEADD,
>  	/* Create-specific options, filled out by the kernel */
>  	IPSET_OPT_ELEMENTS,
>  	IPSET_OPT_REFERENCES,
> @@ -94,7 +95,8 @@ enum ipset_opt {
>  	| IPSET_FLAG(IPSET_OPT_RESIZE)	\
>  	| IPSET_FLAG(IPSET_OPT_SIZE)	\
>  	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
> -	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT))
> +	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)\
> +	| IPSET_FLAG(IPSET_OPT_FORCEADD))
>  
>  #define IPSET_ADT_FLAGS			\
>  	(IPSET_FLAG(IPSET_OPT_IP)	\
> diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
> index c2bae85..0e1478e 100644
> --- a/include/libipset/linux_ip_set.h
> +++ b/include/libipset/linux_ip_set.h
> @@ -95,6 +95,7 @@ enum {
>  	IPSET_ATTR_PROBES,
>  	IPSET_ATTR_RESIZE,
>  	IPSET_ATTR_SIZE,
> +	IPSET_ATTR_FORCEADD,
>  	/* Kernel-only */
>  	IPSET_ATTR_ELEMENTS,
>  	IPSET_ATTR_REFERENCES,

Please use "make update_includes", in order to sync linux_ip_set.h.

> diff --git a/include/libipset/parse.h b/include/libipset/parse.h
> index 55981f2..93af5c3 100644
> --- a/include/libipset/parse.h
> +++ b/include/libipset/parse.h
> @@ -103,6 +103,9 @@ extern int ipset_parse_elem(struct ipset_session *session,
>  extern int ipset_call_parser(struct ipset_session *session,
>  			     const struct ipset_arg *arg,
>  			     const char *str);
> +extern int ipset_parse_forceadd(struct ipset_session *session,
> +                               enum ipset_opt opt, const char *str);
> +

This is not needed, see below.

>  /* Compatibility parser functions */
>  extern int ipset_parse_iptimeout(struct ipset_session *session,
> diff --git a/lib/data.c b/lib/data.c
> index 48ec98a..a841d7f 100644
> --- a/lib/data.c
> +++ b/lib/data.c
> @@ -57,6 +57,7 @@ struct ipset_data {
>  			uint32_t markmask;
>  			uint32_t gc;
>  			uint32_t size;
> +			uint8_t forceadd;

We can get rid of this too.

>  			/* Filled out by kernel */
>  			uint32_t references;
>  			uint32_t elements;
> @@ -309,6 +310,10 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
>  	case IPSET_OPT_CREATE_COMMENT:
>  		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_COMMENT);
>  		break;
> +        case IPSET_OPT_FORCEADD:
> +		data->create.forceadd = *(const uint8_t *) value;
> +		break;
> +

Use cadt_flag_type_attr(), like just above in the 
IPSET_OPT_CREATE_COMMENT case.

>  	/* Create-specific options, filled out by the kernel */
>  	case IPSET_OPT_ELEMENTS:
>  		data->create.elements = *(const uint32_t *) value;
> @@ -481,6 +486,9 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
>  		return &data->create.resize;
>  	case IPSET_OPT_SIZE:
>  		return &data->create.size;
> +	case IPSET_OPT_FORCEADD:
> +		return &data->create.forceadd;
> +

Move the case to the bunch of the IPSET_OPT_CADT_FLAGS cases where just
cadt_flags is returned.

>  	/* Create-specific options, filled out by the kernel */
>  	case IPSET_OPT_ELEMENTS:
>  		return &data->create.elements;
> diff --git a/lib/debug.c b/lib/debug.c
> index 1240e22..14249e5 100644
> --- a/lib/debug.c
> +++ b/lib/debug.c
> @@ -46,6 +46,7 @@ static const struct ipset_attrname createattr2name[] = {
>  	[IPSET_ATTR_ELEMENTS]	= { .name = "ELEMENTS" },
>  	[IPSET_ATTR_REFERENCES]	= { .name = "REFERENCES" },
>  	[IPSET_ATTR_MEMSIZE]	= { .name = "MEMSIZE" },
> +	[IPSET_ATTR_FORCEADD]	= { .name = "FORCEADD" },
>  };

This can also be removed.

>  
>  static const struct ipset_attrname adtattr2name[] = {
> diff --git a/lib/ipset_hash_ip.c b/lib/ipset_hash_ip.c
> index 45185ec..cde0781 100644
> --- a/lib/ipset_hash_ip.c
> +++ b/lib/ipset_hash_ip.c
> @@ -383,10 +383,133 @@ static struct ipset_type ipset_hash_ip2 = {
>  	.description = "comment support",
>  };
>  
> +/* Parse commandline arguments */
> +static const struct ipset_arg hash_ip_create_args3[] = {
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
> +	{ .name = { "netmask", NULL },
> +	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_NETMASK,
> +	  .parse = ipset_parse_netmask,		.print = ipset_print_number,
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
> +	  .has_arg = IPSET_NO_ARG,              .opt = IPSET_OPT_FORCEADD,
> +	  .parse = ipset_parse_forceadd,        .print = ipset_print_number,
> +        },

Please use ipset_parse_flag and ipset_print_flag here and in all the new 
revisions of the hash types. Also, adjust LIBVERSION in Make_global.am 
because of the new flag.

[...]

> diff --git a/lib/parse.c b/lib/parse.c
> index f1c1f0e..1953e9e 100644
> --- a/lib/parse.c
> +++ b/lib/parse.c
> @@ -1988,3 +1988,24 @@ out:
>  	free(saved);
>  	return ret;
>  }
> +
> +/**
> + * ipset_parse_forceadd - parse forceadd set option
> + * @session: session structure
> + * @opt: option kind of the data
> + * @str: string to parse
> + *
> + * Parse forceadd arg
> + * The value is stored in the data blob of the session.
> + *
> + * Returns 0 on success or a negative error code.
> + */
> +int
> +ipset_parse_forceadd(struct ipset_session *session,
> +		enum ipset_opt opt, const char *str)
> +{
> +	uint8_t force = 1;
> +        assert(session);
> +
> +        return ipset_session_data_set(session, opt, &force);
> +}

The parser function can be removed.

> diff --git a/lib/print.c b/lib/print.c
> index f81c074..86dfa03 100644
> --- a/lib/print.c
> +++ b/lib/print.c
> @@ -903,6 +903,10 @@ ipset_print_data(char *buf, unsigned int len,
>  	case IPSET_OPT_SIZE:
>  		size = ipset_print_number(buf, len, data, opt, env);
>  		break;
> +	case IPSET_OPT_FORCEADD:
> +		size = snprintf(buf, len, "forceadd", NULL);
> +		break;
> +
>  	default:
>  		return -1;
>  	}

And this isn't needed either.

> diff --git a/lib/session.c b/lib/session.c
> index d2957a5..095cbec 100644
> --- a/lib/session.c
> +++ b/lib/session.c
> @@ -413,6 +413,10 @@ static const struct ipset_attr_policy create_attrs[] = {
>  		.type = MNL_TYPE_U32,
>  		.opt = IPSET_OPT_MEMSIZE,
>  	},
> +	[IPSET_ATTR_FORCEADD] = {
> +		.type = MNL_TYPE_U8,
> +		.opt = IPSET_OPT_FORCEADD,
> +	},
>  };

This can also be deleted.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
