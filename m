From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 2/2] ipset: add userspace support for forceadd
Date: Fri, 28 Feb 2014 22:46:02 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402282233120.5894@blackhole.kfki.hu>
References: <1393542286-20955-1-git-send-email-johunt@akamai.com> <1393542286-20955-3-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:49142 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaB1VqI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:46:08 -0500
In-Reply-To: <1393542286-20955-3-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 27 Feb 2014, Josh Hunt wrote:

> The userspace side of the forceadd changes.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  Make_global.am              |    2 +-
>  include/libipset/data.h     |    4 +-
>  lib/data.c                  |    6 ++
>  lib/ipset_hash_ip.c         |  123 +++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipmark.c     |  142 ++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipport.c     |  147 +++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipportip.c   |  158 ++++++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_ipportnet.c  |  169 +++++++++++++++++++++++++++++++++++++++++++
>  lib/ipset_hash_net.c        |  119 ++++++++++++++++++++++++++++++
>  lib/ipset_hash_netiface.c   |  125 ++++++++++++++++++++++++++++++++
>  lib/ipset_hash_netnet.c     |  125 ++++++++++++++++++++++++++++++++
>  lib/ipset_hash_netport.c    |  132 +++++++++++++++++++++++++++++++++
>  lib/ipset_hash_netportnet.c |  149 ++++++++++++++++++++++++++++++++++++++
>  src/ipset.8                 |    7 ++
>  14 files changed, 1406 insertions(+), 2 deletions(-)

I don't see include/libipset/linux_ip_set.h refreshed, so
please run "make update_includes".
 
> diff --git a/Make_global.am b/Make_global.am
> index f931618..1151714 100644
> --- a/Make_global.am
> +++ b/Make_global.am
> @@ -69,7 +69,7 @@
>  # interface. 
>  
>  #            curr:rev:age
> -LIBVERSION = 5:0:3
> +LIBVERSION = 6:0:1

As Pablo pointed out, it should be "6:0:4".
  
>  AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
>  	-I/usr/local/include
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
> diff --git a/lib/data.c b/lib/data.c
> index 48ec98a..9ff8e42 100644
> --- a/lib/data.c
> +++ b/lib/data.c
> @@ -309,6 +309,10 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
>  	case IPSET_OPT_CREATE_COMMENT:
>  		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_COMMENT);
>  		break;
> +        case IPSET_OPT_FORCEADD:
> +		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_FORCEADD);
> +		break;
> +

It looks like the extra leading whitespaces slipped in here too.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
