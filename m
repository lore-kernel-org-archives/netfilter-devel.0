From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 15:19:14 +0200
Message-ID: <4A097752.4030303@netfilter.org>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34528 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZELNT2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 09:19:28 -0400
In-Reply-To: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef!

First of all, this is clashing with seven big patches that I have here
including one to kill the notifier call chain :), I'm waiting for
Patrick to open nf-next-2.6 to send them all. I can send them now.

Jozsef Kadlecsik wrote:
> Hi Patrick and Pablo,
> 
> The patch adds support to control the in-kernel event generation.
> In practice we face two problems: we should support a fine-grained
> event generation in netfilter, in order to be able to catch and follow
> the different state changes. At the same time, for example for conntrack
> replication, a too fine-grained event generation can easily result in
> a high, unnecessary system load. BFP and/or userspace event filtering
> is not effective enough to avoid it: the resources are already burnt
> on building up the netlink messages.

Yes, some fine-grain filtering to avoid the message building would be
interesting, however, what you're proposing is not flexible enough for
two different applications that are interested in different events. Time
ago, I proposed a netlink unicast-based interface for ctnetlink similar
to nfnetlink_queue and the NFQUEUE target. Still, it needed yet another
table (at the end of postrouting) for something very specific.

> The patch solves the problem by adding the full power of iptables
> to select which traffic should generate events and by adding new
> options to the CONNMARK target to specify exactly which events should
> be generated for the selected traffic.
> 
> The downsize is that extra 16 bit required in the nf_conn structure to
> store the selected event flags.
> 
> The events were a little bit reorganized as well:
> 
> - IPCT_STATUS is split into IPCT_SEEN_REPLY and IPCT_ASSURED, to express
>   exactly the state change in conntrack
> - IPCT_PROTOINFO_VOLATILE renamed to IPCT_ICMP_PROTOINFO, mainly
>   to get a shorter name ;-)

In one of my patches here, I have simplified this by removing the
VOLATILE events which are not of any use.

> - IPCT_HELPINFO_VOLATILE, IPCT_NATINFO and IPCT_COUNTER_FILLING
>   are dropped

Yes, those are in my patches as well.

> - IPEXP_REFRESH and IPEXP_TIMEOUT are added to cover the expectation
>   events.

I like this. These are interesting since the ctnetlink expectation
subsystem is incomplete, but they should go in a different patch to
complete the expectation events.

> The single unresolved issue is backward incompatibility: should a module
> parameter or a sysctl flag be added to the patch to specify the old
> behaviour (i.e. generate events unconditionally)?

The main problem with this is that we may have different applications
with different needs. This must be something configurable from
user-space, not from the kernel.

> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/nf_conntrack_common.h  |   63 ++++++++++-------
>  include/linux/netfilter/xt_CONNMARK.h          |   10 +++-
>  include/net/netfilter/nf_conntrack.h           |    4 +
>  include/net/netfilter/nf_conntrack_ecache.h    |   14 +++-
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
>  net/netfilter/nf_conntrack_core.c              |    7 +--
>  net/netfilter/nf_conntrack_expect.c            |    1 +
>  net/netfilter/nf_conntrack_ftp.c               |    4 +-
>  net/netfilter/nf_conntrack_netlink.c           |   12 +++-
>  net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
>  net/netfilter/nf_conntrack_proto_sctp.c        |    2 +-
>  net/netfilter/nf_conntrack_proto_tcp.c         |    3 +-
>  net/netfilter/nf_conntrack_proto_udp.c         |    2 +-
>  net/netfilter/nf_conntrack_proto_udplite.c     |    2 +-
>  net/netfilter/nf_conntrack_sip.c               |    1 +
>  net/netfilter/xt_CONNMARK.c                    |   92 +++++++++++++++++++++++-
>  17 files changed, 172 insertions(+), 51 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
> index 885cbe2..41a74de 100644
> --- a/include/linux/netfilter/nf_conntrack_common.h
> +++ b/include/linux/netfilter/nf_conntrack_common.h
> @@ -94,19 +94,25 @@ enum ip_conntrack_events
>  	IPCT_REFRESH_BIT = 3,
>  	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
>  
> -	/* Status has changed */
> -	IPCT_STATUS_BIT = 4,
> -	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
> +	/* Assured bit is set */
> +	IPCT_ASSURED_BIT = 4,
> +	IPCT_ASSURED = (1 << IPCT_ASSURED_BIT),
>  
> -	/* Update of protocol info */
> +	/* Backward compatibility */
> +	IPCT_STATUS = IPCT_ASSURED,
> +
> +	/* Protocol state info */
>  	IPCT_PROTOINFO_BIT = 5,
>  	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
>  
> -	/* Volatile protocol info */
> -	IPCT_PROTOINFO_VOLATILE_BIT = 6,
> -	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
> +	/* ICMP(v6) protocol info */
> +	IPCT_ICMP_PROTOINFO_BIT = 6,
> +	IPCT_ICMP_PROTOINFO = (1 << IPCT_ICMP_PROTOINFO_BIT),
> +
> +	/* Backward compatibility */
> +	IPCT_PROTOINFO_VOLATILE = IPCT_ICMP_PROTOINFO,
>  
> -	/* New helper for conntrack */
> +	/* Helper for conntrack added/removed */
>  	IPCT_HELPER_BIT = 7,
>  	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
>  
> @@ -114,34 +120,41 @@ enum ip_conntrack_events
>  	IPCT_HELPINFO_BIT = 8,
>  	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
>  
> -	/* Volatile helper info */
> -	IPCT_HELPINFO_VOLATILE_BIT = 9,
> -	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
> -
> -	/* NAT info */
> -	IPCT_NATINFO_BIT = 10,
> -	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
> -
> -	/* Counter highest bit has been set, unused */
> -	IPCT_COUNTER_FILLING_BIT = 11,
> -	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
> +	/* Seen reply packet */
> +	IPCT_SEEN_REPLY_BIT = 9,
> +	IPCT_SEEN_REPLY = (1 << IPCT_SEEN_REPLY_BIT),
>  
>  	/* Mark is set */
> -	IPCT_MARK_BIT = 12,
> +	IPCT_MARK_BIT = 10,
>  	IPCT_MARK = (1 << IPCT_MARK_BIT),
>  
>  	/* NAT sequence adjustment */
> -	IPCT_NATSEQADJ_BIT = 13,
> +	IPCT_NATSEQADJ_BIT = 11,
>  	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
>  
>  	/* Secmark is set */
> -	IPCT_SECMARK_BIT = 14,
> +	IPCT_SECMARK_BIT = 12,
>  	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
> -};
> +	
> +	/* All conntrack event bits */
> +	IPCT_ALL_BIT = 13,
> +	IPCT_ALL = ((1 << IPCT_ALL_BIT) - 1),
>  
> -enum ip_conntrack_expect_events {
> -	IPEXP_NEW_BIT = 0,
> +	/* New expectation created */
> +	IPEXP_NEW_BIT = 13,
>  	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
> +
> +	/* Timer has been refreshed */
> +	IPEXP_REFRESH_BIT = 14,
> +	IPEXP_REFRESH = (1 << IPEXP_REFRESH_BIT),
> +
> +	/* Expectation timed out */
> +	IPEXP_TIMEOUT_BIT = 15,
> +	IPEXP_TIMEOUT = (1 << IPEXP_TIMEOUT_BIT),
> +
> +	/* All expectation event bits */
> +	IPEXP_ALL_BIT = 16,
> +	IPEXP_ALL = (((1 << IPEXP_ALL_BIT) - 1) & ~IPCT_ALL)
>  };
>  
>  #ifdef __KERNEL__
> diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
> index 7635c8f..0ecbc85 100644
> --- a/include/linux/netfilter/xt_CONNMARK.h
> +++ b/include/linux/netfilter/xt_CONNMARK.h
> @@ -15,7 +15,8 @@
>  enum {
>  	XT_CONNMARK_SET = 0,
>  	XT_CONNMARK_SAVE,
> -	XT_CONNMARK_RESTORE
> +	XT_CONNMARK_RESTORE,
> +	XT_CONNMARK_EVENT_ONLY
>  };
>  
>  struct xt_connmark_target_info {
> @@ -29,4 +30,11 @@ struct xt_connmark_tginfo1 {
>  	__u8 mode;
>  };
>  
> +struct xt_connmark_tginfo2 {
> +	__u32 ctmark, ctmask, nfmask;
> +	__u8 mode;
> +	__u8 events;
> +	__u16 eventmask;
> +};
> +
>  #endif /*_XT_CONNMARK_H_target*/
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index 6c3f964..bf8b156 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -117,6 +117,10 @@ struct nf_conn {
>  	u_int32_t secmark;
>  #endif
>  
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> +	u_int16_t eventmask;
> +#endif

In my patches I have added a per-ct event cache like this (but using the
conntrack extension infrastructure) to add reliable event reporting,
which is something that we also need for logging and synchronization.

BTW, I don't like using connmark for this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
