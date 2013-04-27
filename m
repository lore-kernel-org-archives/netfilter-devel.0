From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 13/13] netfilter: ipset: set match: add support to match
 the counters
Date: Sat, 27 Apr 2013 19:33:48 +0200
Message-ID: <20130427173348.GA3298@localhost>
References: <1367067045-960-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1367067045-960-14-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38229 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3D0ReC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:34:02 -0400
Content-Disposition: inline
In-Reply-To: <1367067045-960-14-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Sat, Apr 27, 2013 at 02:50:45PM +0200, Jozsef Kadlecsik wrote:
> The new revision of the set match supports to match the counters
> and to suppress updating the counters at matching too.
>=20
> At the set:list types, the updating of the subcounters can be
> suppressed as well.
>=20
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/ipset/ip_set.h      |    9 +++-
>  include/uapi/linux/netfilter/ipset/ip_set.h |   31 ++++++++++--
>  include/uapi/linux/netfilter/xt_set.h       |    9 ++++
>  net/netfilter/ipset/ip_set_core.c           |    2 +-
>  net/netfilter/ipset/ip_set_list_set.c       |    8 ++-
>  net/netfilter/xt_set.c                      |   70 +++++++++++++++++=
++++++++++
>  6 files changed, 120 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/n=
etfilter/ipset/ip_set.h
> index 0f978eb..d80e275 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -76,7 +76,7 @@ struct ip_set;
> =20
>  typedef int (*ipset_adtfn)(struct ip_set *set, void *value,
>  			   const struct ip_set_ext *ext,
> -			   struct ip_set_ext *mext, u32 flags);
> +			   struct ip_set_ext *mext, u32 cmdflags);
> =20
>  /* Kernel API function options */
>  struct ip_set_adt_opt {
> @@ -217,10 +217,15 @@ ip_set_update_counter(struct ip_set_counter *co=
unter,
>  		      const struct ip_set_ext *ext,
>  		      struct ip_set_ext *mext, u32 flags)
>  {
> -	if (ext->packets !=3D ULLONG_MAX) {
> +	if (ext->packets !=3D ULLONG_MAX &&
> +	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
>  		ip_set_add_bytes(ext->bytes, counter);
>  		ip_set_add_packets(ext->packets, counter);
>  	}
> +	if (flags & IPSET_FLAG_MATCH_COUNTERS) {
> +		mext->packets =3D ip_set_get_packets(counter);
> +		mext->bytes =3D ip_set_get_bytes(counter);
> +	}
>  }
> =20
>  static inline bool
> diff --git a/include/uapi/linux/netfilter/ipset/ip_set.h b/include/ua=
pi/linux/netfilter/ipset/ip_set.h
> index ed45267..8024cdf 100644
> --- a/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/include/uapi/linux/netfilter/ipset/ip_set.h
> @@ -145,7 +145,7 @@ enum ipset_errno {
>  	IPSET_ERR_TYPE_SPECIFIC =3D 4352,
>  };
> =20
> -/* Flags at command level */
> +/* Flags at command level or match/target flags, lower half of cmdat=
trs*/
>  enum ipset_cmd_flags {
>  	IPSET_FLAG_BIT_EXIST	=3D 0,
>  	IPSET_FLAG_EXIST	=3D (1 << IPSET_FLAG_BIT_EXIST),
> @@ -153,10 +153,20 @@ enum ipset_cmd_flags {
>  	IPSET_FLAG_LIST_SETNAME	=3D (1 << IPSET_FLAG_BIT_LIST_SETNAME),
>  	IPSET_FLAG_BIT_LIST_HEADER =3D 2,
>  	IPSET_FLAG_LIST_HEADER	=3D (1 << IPSET_FLAG_BIT_LIST_HEADER),
> -	IPSET_FLAG_CMD_MAX =3D 15,	/* Lower half */
> +	IPSET_FLAG_BIT_SKIP_COUNTER_UPDATE =3D 3,
> +	IPSET_FLAG_SKIP_COUNTER_UPDATE =3D
> +		(1 << IPSET_FLAG_BIT_SKIP_COUNTER_UPDATE),
> +	IPSET_FLAG_BIT_SKIP_SUBCOUNTER_UPDATE =3D 4,
> +	IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE =3D
> +		(1 << IPSET_FLAG_BIT_SKIP_SUBCOUNTER_UPDATE),
> +	IPSET_FLAG_BIT_MATCH_COUNTERS =3D 5,
> +	IPSET_FLAG_MATCH_COUNTERS =3D (1 << IPSET_FLAG_BIT_MATCH_COUNTERS),
> +	IPSET_FLAG_BIT_RETURN_NOMATCH =3D 7,
> +	IPSET_FLAG_RETURN_NOMATCH =3D (1 << IPSET_FLAG_BIT_RETURN_NOMATCH),
> +	IPSET_FLAG_CMD_MAX =3D 15,
>  };
> =20
> -/* Flags at CADT attribute level */
> +/* Flags at CADT attribute level, upper half of cmdattrs */
>  enum ipset_cadt_flags {
>  	IPSET_FLAG_BIT_BEFORE	=3D 0,
>  	IPSET_FLAG_BEFORE	=3D (1 << IPSET_FLAG_BIT_BEFORE),
> @@ -166,7 +176,7 @@ enum ipset_cadt_flags {
>  	IPSET_FLAG_NOMATCH	=3D (1 << IPSET_FLAG_BIT_NOMATCH),
>  	IPSET_FLAG_BIT_WITH_COUNTERS =3D 3,
>  	IPSET_FLAG_WITH_COUNTERS =3D (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
> -	IPSET_FLAG_CADT_MAX	=3D 15,	/* Upper half */
> +	IPSET_FLAG_CADT_MAX	=3D 15,
>  };
> =20
>  /* Commands with settype-specific attributes */
> @@ -195,6 +205,7 @@ enum ip_set_dim {
>  	 * If changed, new revision of iptables match/target is required.
>  	 */
>  	IPSET_DIM_MAX =3D 6,
> +	/* Backward compatibility: set match revision 2 */
>  	IPSET_BIT_RETURN_NOMATCH =3D 7,
>  };
> =20
> @@ -207,6 +218,18 @@ enum ip_set_kopt {
>  	IPSET_RETURN_NOMATCH =3D (1 << IPSET_BIT_RETURN_NOMATCH),
>  };
> =20
> +enum {
> +	IPSET_COUNTER_NONE =3D 0,
> +	IPSET_COUNTER_EQ,
> +	IPSET_COUNTER_NE,
> +	IPSET_COUNTER_LT,
> +	IPSET_COUNTER_GT,
> +};
> +
> +struct ip_set_counter_match {
> +	__u8 op;
> +	__u64 value;
> +};
> =20
>  /* Interface to iptables/ip6tables */
> =20
> diff --git a/include/uapi/linux/netfilter/xt_set.h b/include/uapi/lin=
ux/netfilter/xt_set.h
> index e3a9978..964d3d4 100644
> --- a/include/uapi/linux/netfilter/xt_set.h
> +++ b/include/uapi/linux/netfilter/xt_set.h
> @@ -62,4 +62,13 @@ struct xt_set_info_target_v2 {
>  	__u32 timeout;
>  };
> =20
> +/* Revision 3 match */
> +
> +struct xt_set_info_match_v3 {
> +	struct xt_set_info match_set;
> +	struct ip_set_counter_match packets;
> +	struct ip_set_counter_match bytes;
> +	__u32 flags;
> +};
> +
>  #endif /*_XT_SET_H*/
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/=
ip_set_core.c
> index f6d878a..f771390 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -413,7 +413,7 @@ ip_set_test(ip_set_id_t index, const struct sk_bu=
ff *skb,
>  		ret =3D 1;
>  	} else {
>  		/* --return-nomatch: invert matched element */
> -		if ((opt->flags & IPSET_RETURN_NOMATCH) &&
> +		if ((opt->cmdflags & IPSET_FLAG_RETURN_NOMATCH) &&
>  		    (set->type->features & IPSET_TYPE_NOMATCH) &&
>  		    (ret > 0 || ret =3D=3D -ENOTEMPTY))
>  			ret =3D -ret;
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ip=
set/ip_set_list_set.c
> index c09022e..979b8c9 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -84,9 +84,13 @@ list_set_ktest(struct ip_set *set, const struct sk=
_buff *skb,
>  {
>  	struct list_set *map =3D set->data;
>  	struct set_elem *e;
> -	u32 i;
> +	u32 i, cmdflags =3D opt->cmdflags;
>  	int ret;
> =20
> +	/* Don't lookup sub-counters at all */
> +	opt->cmdflags &=3D ~IPSET_FLAG_MATCH_COUNTERS;
> +	if (opt->cmdflags & IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE)
> +		opt->cmdflags &=3D ~IPSET_FLAG_SKIP_COUNTER_UPDATE;
>  	for (i =3D 0; i < map->size; i++) {
>  		e =3D list_set_elem(map, i);
>  		if (e->id =3D=3D IPSET_INVALID_ID)
> @@ -99,7 +103,7 @@ list_set_ktest(struct ip_set *set, const struct sk=
_buff *skb,
>  			if (SET_WITH_COUNTER(set))
>  				ip_set_update_counter(ext_counter(e, map),
>  						      ext, &opt->ext,
> -						      opt->cmdflags);
> +						      cmdflags);
>  			return ret;
>  		}
>  	}
> diff --git a/net/netfilter/xt_set.c b/net/netfilter/xt_set.c
> index 636c519..5f41aef 100644
> --- a/net/netfilter/xt_set.c
> +++ b/net/netfilter/xt_set.c
> @@ -189,6 +189,9 @@ set_match_v1(const struct sk_buff *skb, struct xt=
_action_param *par)
>  	ADT_OPT(opt, par->family, info->match_set.dim,
>  		info->match_set.flags, 0, UINT_MAX);
> =20
> +	if (opt.flags & IPSET_RETURN_NOMATCH)
> +		opt.cmdflags |=3D IPSET_FLAG_RETURN_NOMATCH;
> +
>  	return match_set(info->match_set.index, skb, par, &opt,
>  			 info->match_set.flags & IPSET_INV_MATCH);
>  }
> @@ -317,6 +320,52 @@ set_target_v2(struct sk_buff *skb, const struct =
xt_action_param *par)
>  #define set_target_v2_checkentry	set_target_v1_checkentry
>  #define set_target_v2_destroy		set_target_v1_destroy
> =20
> +/* Revision 3 match */
> +
> +static bool
> +match_counter(u64 counter, const struct ip_set_counter_match *info)
> +{
> +	switch (info->op) {
> +	case IPSET_COUNTER_NONE:
> +		return true;
> +	case IPSET_COUNTER_EQ:
> +		return counter =3D=3D info->value;
> +	case IPSET_COUNTER_NE:
> +		return counter !=3D info->value;
> +	case IPSET_COUNTER_LT:
> +		return counter < info->value;
> +	case IPSET_COUNTER_GT:
> +		return counter > info->value;
> +	}
> +	return false;
> +}
> +
> +static bool
> +set_match_v3(const struct sk_buff *skb, CONST struct xt_action_param=
 *par)

net/netfilter/xt_set.c:344:41: error: unknown type name =E2=80=98CONST=E2=
=80=99
net/netfilter/xt_set.c:426:13: error: =E2=80=98set_match_v3=E2=80=99 un=
declared here (not in a function)
net/netfilter/xt_set.c:326:1: warning: =E2=80=98match_counter=E2=80=99 =
defined but not used [-Wunused-function]

=46ixed here, no need to resend.

But you'll will have to rebase your tree.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
