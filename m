From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v2 1/7] netfilter: ipset: Support comments for ipset
 entries in the core.
Date: Fri, 20 Sep 2013 23:19:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1309202250081.28758@blackhole.kfki.hu>
References: <1379665825-42563-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379665825-42563-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:44466 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3ITVTP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 17:19:15 -0400
In-Reply-To: <1379665825-42563-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 20 Sep 2013, Oliver wrote:

> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This adds the core support for having comments on ipset entries.
> 
> The comments are stored as standard null-terminated strings in
> dynamically allocated memory after being passed to the kernel. As a
> result of this, code has been added to the generic destroy function to
> iterate all extensions and call that extension's destroy task if the set
> has that extension activated, and if such a task is defined.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> ---
>  kernel/include/linux/netfilter/ipset/ip_set.h      | 32 ++++++++---
>  .../include/linux/netfilter/ipset/ip_set_comment.h | 65 ++++++++++++++++++++++
>  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |  4 ++
>  kernel/net/netfilter/ipset/ip_set_core.c           | 14 +++++
>  4 files changed, 107 insertions(+), 8 deletions(-)
>  create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h
> 
> diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
> index c687abb..aaa166b 100644
> --- a/kernel/include/linux/netfilter/ipset/ip_set.h
> +++ b/kernel/include/linux/netfilter/ipset/ip_set.h
> @@ -54,6 +54,8 @@ enum ip_set_extension {
>  	IPSET_EXT_TIMEOUT = (1 << IPSET_EXT_BIT_TIMEOUT),
>  	IPSET_EXT_BIT_COUNTER = 1,
>  	IPSET_EXT_COUNTER = (1 << IPSET_EXT_BIT_COUNTER),
> +	IPSET_EXT_BIT_COMMENT = 2,
> +	IPSET_EXT_COMMENT = (1 << IPSET_EXT_BIT_COMMENT),
>  	/* Mark set with an extension which needs to call destroy */
>  	IPSET_EXT_BIT_DESTROY = 7,
>  	IPSET_EXT_DESTROY = (1 << IPSET_EXT_BIT_DESTROY),
> @@ -61,11 +63,13 @@ enum ip_set_extension {
>  
>  #define SET_WITH_TIMEOUT(s)	((s)->extensions & IPSET_EXT_TIMEOUT)
>  #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
> +#define SET_WITH_COMMENT(s)	((s)->extensions & IPSET_EXT_COMMENT)
>  
>  /* Extension id, in size order */
>  enum ip_set_ext_id {
>  	IPSET_EXT_ID_COUNTER = 0,
>  	IPSET_EXT_ID_TIMEOUT,
> +	IPSET_EXT_ID_COMMENT,
>  	IPSET_EXT_ID_MAX,
>  };
>  
> @@ -86,6 +90,7 @@ struct ip_set_ext {
>  	u64 packets;
>  	u64 bytes;
>  	u32 timeout;
> +	char *comment;
>  };
>  
>  struct ip_set_counter {
> @@ -93,20 +98,19 @@ struct ip_set_counter {
>  	atomic64_t packets;
>  };
>  
> -struct ip_set;
> +struct ip_set_comment {
> +	char *str;
> +};
>  
> -static inline void
> -ip_set_ext_destroy(struct ip_set *set, void *data)
> -{
> -	/* Check that the extension is enabled for the set and
> -	 * call it's destroy function for its extension part in data.
> -	 */
> -}
> +struct ip_set;
>  
>  #define ext_timeout(e, s)	\
>  (unsigned long *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_TIMEOUT])
>  #define ext_counter(e, s)	\
>  (struct ip_set_counter *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_COUNTER])
> +#define ext_comment(e, s)	\
> +(struct ip_set_comment *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_COMMENT])
> +
>  
>  typedef int (*ipset_adtfn)(struct ip_set *set, void *value,
>  			   const struct ip_set_ext *ext,
> @@ -224,6 +228,17 @@ struct ip_set {
>  };
>  
>  static inline void
> +ip_set_ext_destroy(struct ip_set *set, void *data)
> +{
> +	/* Check that the extension is enabled for the set and
> +	 * call it's destroy function for its extension part in data.
> +	 */
> +	if (SET_WITH_COMMENT(set))
> +		ip_set_extensions[IPSET_EXT_ID_COMMENT].destroy(
> +			ext_comment(data, set));
> +}
> +
> +static inline void
>  ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
>  {
>  	atomic64_add((long long)bytes, &(counter)->bytes);
> @@ -426,6 +441,7 @@ bitmap_bytes(u32 a, u32 b)
>  }
>  
>  #include <linux/netfilter/ipset/ip_set_timeout.h>
> +#include <linux/netfilter/ipset/ip_set_comment.h>

You should have received an error at compiling: 
IP_SET_MAX_COMMENT_SIZE is defined both in 
uapi/linux/netfilter/ipset/ip_set.h and 
linux/netfilter/ipset/ip_set_comment.h.
  
>  #define IP_SET_INIT_KEXT(skb, opt, set)			\
>  	{ .bytes = (skb)->len, .packets = 1,		\
> diff --git a/kernel/include/linux/netfilter/ipset/ip_set_comment.h b/kernel/include/linux/netfilter/ipset/ip_set_comment.h
> new file mode 100644
> index 0000000..71dfe10
> --- /dev/null
> +++ b/kernel/include/linux/netfilter/ipset/ip_set_comment.h
> @@ -0,0 +1,65 @@
> +#ifndef _IP_SET_COMMENT_H
> +#define _IP_SET_COMMENT_H
> +
> +/* Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#define IP_SET_MAX_COMMENT_SIZE 255

Remove IP_SET_MAX_COMMENT_SIZE from this header file, it must be in
uapi/linux/netfilter/ipset/ip_set.h.

[IPSET_ATTR_COMMENT is also defined in another header file and this one 
depends on it.]

> +#ifdef __KERNEL__
> +
> +static inline char*
> +ip_set_comment_uget(struct nlattr *tb)
> +{
> +	return nla_data(tb);
> +}
> +
> +static inline void
> +ip_set_init_comment(struct ip_set_comment *comment,
> +		    const struct ip_set_ext *ext)
> +{
> +	size_t len = ext->comment ? strlen(ext->comment) : 0;
> +	if (!len)
> +		return;
> +	if (unlikely(len > IP_SET_MAX_COMMENT_SIZE))
> +		len = IP_SET_MAX_COMMENT_SIZE;
> +	if (unlikely(comment->str))
> +		kfree(comment->str);
> +	comment->str = kzalloc(len + 1, GFP_ATOMIC);
> +	if (unlikely(!comment->str)) {
> +		comment->str = kzalloc(len + 1, GFP_KERNEL);
> +		if (unlikely(!comment->str)) {
> +			comment->str = vzalloc(len + 1);
> +			if (unlikely(!comment->str))
> +				return;
> +		}
> +	}
> +	strlcpy(comment->str, ext->comment, len + 1);
> +}

This cascading of allocation attempts is simply too much. Also, we must 
use the flag GFP_ATOMIC, because we are holding the set lock (I didn't 
notice it previously, sorry). So please fall back to a single allocation 
with kzalloc and that's all (and keep the checking of it's result, of 
course).

Move the

     if (unlikely(comment->str))
             kfree(comment->str);

part before

     if (!len)
 	    return;

and extend it to

     if (unlikely(comment->str)) {
             kfree(comment->str);
	     comment->str = NULL;
     }

That way we support "deleting" just the comment part of an element (user 
can readd the element without comment). But therefore the "unlikely" part 
of the test should probably be removed.

> +
> +static inline bool
> +ip_set_put_comment(struct sk_buff *skb, struct ip_set_comment *comment)
> +{
> +	if (!comment->str)
> +		return NULL;
> +	return nla_put_string(skb, IPSET_ATTR_COMMENT, comment->str);
> +}

This function must be the type of "int" and so the first check return "0".
nla_put_string returns zero or -EMSGSIZE.

> +static inline void
> +ip_set_comment_free(struct ip_set_comment *comment)
> +{
> +	if (unlikely(!comment->str))
> +		return;
> +	if (unlikely(is_vmalloc_addr(comment->str)))
> +		vfree(comment->str);
> +	else
> +		kfree(comment->str);
> +	comment->str = NULL;

Restore the previous ip_set_comment_free version, without the vfree part.

> +
> +#endif
> +#endif
> diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> index 2b61ac4..f177d99 100644
> --- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
> +++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h

The definition of IP_SET_MAX_COMMENT_SIZE must come here.

> @@ -110,6 +110,7 @@ enum {
>  	IPSET_ATTR_IFACE,
>  	IPSET_ATTR_BYTES,
>  	IPSET_ATTR_PACKETS,
> +	IPSET_ATTR_COMMENT,
>  	__IPSET_ATTR_ADT_MAX,
>  };
>  #define IPSET_ATTR_ADT_MAX	(__IPSET_ATTR_ADT_MAX - 1)
> @@ -140,6 +141,7 @@ enum ipset_errno {
>  	IPSET_ERR_IPADDR_IPV4,
>  	IPSET_ERR_IPADDR_IPV6,
>  	IPSET_ERR_COUNTER,
> +	IPSET_ERR_COMMENT,
>  
>  	/* Type specific error codes */
>  	IPSET_ERR_TYPE_SPECIFIC = 4352,
> @@ -176,6 +178,8 @@ enum ipset_cadt_flags {
>  	IPSET_FLAG_NOMATCH	= (1 << IPSET_FLAG_BIT_NOMATCH),
>  	IPSET_FLAG_BIT_WITH_COUNTERS = 3,
>  	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
> +	IPSET_FLAG_BIT_WITH_COMMENT = 4,
> +	IPSET_FLAG_WITH_COMMENT = (1 << IPSET_FLAG_BIT_WITH_COMMENT),
>  	IPSET_FLAG_CADT_MAX	= 15,
>  };
>  
> diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
> index a2030ee..29ce622 100644
> --- a/kernel/net/netfilter/ipset/ip_set_core.c
> +++ b/kernel/net/netfilter/ipset/ip_set_core.c
> @@ -321,6 +321,7 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
>  }
>  EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
>  
> +typedef void (*destroyer)(void *);
>  /* ipset data extension types, in size order */
>  
>  const struct ip_set_ext_type ip_set_extensions[] = {
> @@ -335,6 +336,13 @@ const struct ip_set_ext_type ip_set_extensions[] = {
>  		.len	= sizeof(unsigned long),
>  		.align	= __alignof__(unsigned long),
>  	},
> +	[IPSET_EXT_ID_COMMENT] = {
> +		.type	 = IPSET_EXT_COMMENT | IPSET_EXT_DESTROY,
> +		.flag	 = IPSET_FLAG_WITH_COMMENT,
> +		.len	 = sizeof(struct ip_set_comment),
> +		.align	 = __alignof__(struct ip_set_comment),
> +		.destroy = (destroyer) ip_set_comment_free,
> +	},
>  };
>  EXPORT_SYMBOL_GPL(ip_set_extensions);
>  
> @@ -386,6 +394,12 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
>  			ext->packets = be64_to_cpu(nla_get_be64(
>  						   tb[IPSET_ATTR_PACKETS]));
>  	}
> +	if (tb[IPSET_ATTR_COMMENT]) {
> +		if (!(set->extensions & IPSET_EXT_COMMENT))
> +			return -IPSET_ERR_COMMENT;
> +		ext->comment = ip_set_comment_uget(tb[IPSET_ATTR_COMMENT]);
> +	}
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(ip_set_get_extensions);
> -- 
> 1.8.3.2

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
