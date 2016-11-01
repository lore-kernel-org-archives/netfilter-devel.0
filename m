From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 05/22] netfilter: ipset: Split extensions into separate
 files
Date: Tue, 1 Nov 2016 20:20:30 +0100
Message-ID: <20161101192030.GE18827@salvia>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1477255075-15255-6-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52686 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753370AbcKATUg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:20:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91204168383
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:20:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7ADBCDA849
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:20:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AF1CDA84D
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:20:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477255075-15255-6-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Oct 23, 2016 at 10:37:38PM +0200, Jozsef Kadlecsik wrote:
> Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.
> 
> Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/ipset/ip_set.h         | 95 +-------------------------
>  include/linux/netfilter/ipset/ip_set_counter.h | 75 ++++++++++++++++++++
>  include/linux/netfilter/ipset/ip_set_skbinfo.h | 46 +++++++++++++
>  3 files changed, 123 insertions(+), 93 deletions(-)
>  create mode 100644 include/linux/netfilter/ipset/ip_set_counter.h
>  create mode 100644 include/linux/netfilter/ipset/ip_set_skbinfo.h
> 
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index 7802621..b5bd0fb3 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -292,99 +292,6 @@ struct ip_set {
>  	return nla_put_net32(skb, IPSET_ATTR_CADT_FLAGS, htonl(cadt_flags));
>  }
>  
> -static inline void
> -ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
> -{
> -	atomic64_add((long long)bytes, &(counter)->bytes);
> -}
> -
> -static inline void
> -ip_set_add_packets(u64 packets, struct ip_set_counter *counter)
> -{
> -	atomic64_add((long long)packets, &(counter)->packets);
> -}
> -
> -static inline u64
> -ip_set_get_bytes(const struct ip_set_counter *counter)
> -{
> -	return (u64)atomic64_read(&(counter)->bytes);
> -}
> -
> -static inline u64
> -ip_set_get_packets(const struct ip_set_counter *counter)
> -{
> -	return (u64)atomic64_read(&(counter)->packets);
> -}
> -
> -static inline void
> -ip_set_update_counter(struct ip_set_counter *counter,
> -		      const struct ip_set_ext *ext,
> -		      struct ip_set_ext *mext, u32 flags)
> -{
> -	if (ext->packets != ULLONG_MAX &&
> -	    !(flags & IPSET_FLAG_SKIP_COUNTER_UPDATE)) {
> -		ip_set_add_bytes(ext->bytes, counter);
> -		ip_set_add_packets(ext->packets, counter);
> -	}
> -	if (flags & IPSET_FLAG_MATCH_COUNTERS) {
> -		mext->packets = ip_set_get_packets(counter);
> -		mext->bytes = ip_set_get_bytes(counter);
> -	}
> -}
> -
> -static inline bool
> -ip_set_put_counter(struct sk_buff *skb, const struct ip_set_counter *counter)
> -{
> -	return nla_put_net64(skb, IPSET_ATTR_BYTES,
> -			     cpu_to_be64(ip_set_get_bytes(counter)),
> -			     IPSET_ATTR_PAD) ||
> -	       nla_put_net64(skb, IPSET_ATTR_PACKETS,
> -			     cpu_to_be64(ip_set_get_packets(counter)),
> -			     IPSET_ATTR_PAD);
> -}
> -
> -static inline void
> -ip_set_init_counter(struct ip_set_counter *counter,
> -		    const struct ip_set_ext *ext)
> -{
> -	if (ext->bytes != ULLONG_MAX)
> -		atomic64_set(&(counter)->bytes, (long long)(ext->bytes));
> -	if (ext->packets != ULLONG_MAX)
> -		atomic64_set(&(counter)->packets, (long long)(ext->packets));
> -}
> -
> -static inline void
> -ip_set_get_skbinfo(struct ip_set_skbinfo *skbinfo,
> -		   const struct ip_set_ext *ext,
> -		   struct ip_set_ext *mext, u32 flags)
> -{
> -	mext->skbinfo = *skbinfo;
> -}
> -
> -static inline bool
> -ip_set_put_skbinfo(struct sk_buff *skb, const struct ip_set_skbinfo *skbinfo)
> -{
> -	/* Send nonzero parameters only */
> -	return ((skbinfo->skbmark || skbinfo->skbmarkmask) &&
> -		nla_put_net64(skb, IPSET_ATTR_SKBMARK,
> -			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
> -					  skbinfo->skbmarkmask),
> -			      IPSET_ATTR_PAD)) ||
> -	       (skbinfo->skbprio &&
> -		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
> -			      cpu_to_be32(skbinfo->skbprio))) ||
> -	       (skbinfo->skbqueue &&
> -		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
> -			     cpu_to_be16(skbinfo->skbqueue)));
> -}
> -
> -static inline void
> -ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
> -		    const struct ip_set_ext *ext)
> -{
> -	*skbinfo = ext->skbinfo;
> -}
> -
>  /* Netlink CB args */
>  enum {
>  	IPSET_CB_NET = 0,	/* net namespace */
> @@ -539,6 +446,8 @@ static inline int nla_put_ipaddr6(struct sk_buff *skb, int type,
>  
>  #include <linux/netfilter/ipset/ip_set_timeout.h>
>  #include <linux/netfilter/ipset/ip_set_comment.h>
> +#include <linux/netfilter/ipset/ip_set_counter.h>
> +#include <linux/netfilter/ipset/ip_set_skbinfo.h>
>  
>  int
>  ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
> diff --git a/include/linux/netfilter/ipset/ip_set_counter.h b/include/linux/netfilter/ipset/ip_set_counter.h
> new file mode 100644
> index 0000000..2b5e784
> --- /dev/null
> +++ b/include/linux/netfilter/ipset/ip_set_counter.h
> @@ -0,0 +1,75 @@
> +#ifndef _IP_SET_COUNTER_H
> +#define _IP_SET_COUNTER_H
> +
> +/* Copyright (C) 2015 Sergey Popovich <popovich_sergei@mail.ua>

git annotate says these functions were done by you:

commit 34d666d489cf70c246ca99b2387741915c34b88c
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Apr 27 14:38:56 2013 +0200

    netfilter: ipset: Introduce the counter extension in the core

So I don't think we can credit Sergey as copyright owner just to move
functions into a header file.
