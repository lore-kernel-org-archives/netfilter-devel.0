From: Amin Azez <azez@ufomechanic.net>
Subject: Re: ctnetlink: support for flow-based accounting
Date: Tue, 19 Apr 2005 14:24:39 +0100
Message-ID: <42650697.5020202@ufomechanic.net>
References: <20050416093432.GA15942@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050416093432.GA15942@sunbeam.de.gnumonks.org>
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

I tried this, and added in support for CTA_COUNTERS in conntrack(-tool) 
but I don't seem to get coherent values that relate to 
/proc/net/ip_conntrack.

I added debug to the module ip_conntrack_netlink.c in
ctnetlink_dump_counters:

printk("OP=%d OB=%d RP=%d RB=%d\n",
   ct->counters[IP_CT_DIR_ORIGINAL].packets,
   ct->counters[IP_CT_DIR_ORIGINAL].bytes,
   ct->counters[IP_CT_DIR_REPLY].packets,
   ct->counters[IP_CT_DIR_REPLY].bytes);

But the dmesg output at that point looks equally bogus:
OP=3426 OB=0 RP=254446 RB=0
OP=3427 OB=0 RP=254498 RB=0
OP=3428 OB=0 RP=254598 RB=0
OP=3428 OB=0 RP=254598 RB=0
OP=3429 OB=0 RP=254650 RB=0

This should correlate closely to /proc/net/ip_conntrack which shows:
tcp      6 431999 ESTABLISHED src=192.168.0.204 dst=192.168.0.131 
sport=39719 dport=22 packets=3453 bytes=256330 src=192.168.0.131 
dst=192.168.0.204 sport=22 dport=39719 packets=3631 bytes=836755

The originating packet count correlates closely, the reply packet count 
looks more like the originating byte count. This correlation holds over 
multiple examinations.

So I'm guessing we have some alignment or int32/int64 type problems in 
the structs here, although 
sizeof(ct->counters[IP_CT_DIR_ORIGINAL].packets) is 8 which seems right.

I'll keep looking. Also is there some unique conntrack id I can steal, 
or some safe systemtime/ip_conntrack combination I can use, to help 
track session information over conntrack events (as Wang also refers to: 
"There is problem to create whole sessions record from events. event
messages should carry necessary information for correlation")

Amin


Harald Welte wrote:
> Hi!
> 
> Just to let you know that I'm currently working on this.  I'll merge
> Pablo's latest ctnetlink changes into svn later today, and put my
> modifications for 'list-conntrack-and-zero-counters' on top of it.
> 
> I've also already modified the 'conntrack-tool' and libctnetlink to deal
> with the new message type.  
> 
> Pablo: I think we should put the contrack tool into svn.netfilter.org.
> You would get svn write access, of course.  The module name will be
> 'conntrack' ('iptables' also isn't called 'iptables-tool').
> 
> Cheers,
> 	Harald
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Index: linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack_netlink.h
> ===================================================================
> --- linux-2.6.12-rc2-ctnl.orig/include/linux/netfilter_ipv4/ip_conntrack_netlink.h	2005-04-15 18:40:44.000000000 +0200
> +++ linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack_netlink.h	2005-04-16 11:29:04.000000000 +0200
> @@ -8,13 +8,13 @@
>  /* TODO: Add more message types:
>   *
>   * 	o IPCTNL_MSG_UPDCONNTRACK, update conntracks
> - * 	o IPCTNL_MSG_DMPCONNTRACK, dump conntrack table
>   * 	o IPCTNL_MSG_FSHCONNTRACK, flush conntrack table
>   */
>  enum cntl_msg_types {
>  	IPCTNL_MSG_NEWCONNTRACK,
>  	IPCTNL_MSG_GETCONNTRACK,
>  	IPCTNL_MSG_DELCONNTRACK,
> +	IPCTNL_MSG_GETCT_CTRZERO,
>  
>  	IPCTNL_MSG_NEWEXPECT,
>  	IPCTNL_MSG_GETEXPECT,
> @@ -36,6 +36,7 @@
>  	CTA_HELPINFO,   /* [cta_help] Helper specific information. */
>  	CTA_TIMEOUT,    /* [unsigned long] timer */
>  	CTA_MARK,       /* [unsigned long] mark .*/
> +	CTA_COUNTERS,	/* [cta_counters] packet/byte counters */
>  	
>  	CTA_EXP_TUPLE,	/* [ip_conntrack_tuple] Expected tuple */
>  	CTA_EXP_MASK,	/* [ip_conntrack_tuple] Mask for EXP_TUPLE */
> @@ -65,6 +66,11 @@
>  	union ip_conntrack_expect_proto proto;
>  };
>  
> +struct cta_counters {
> +	struct ip_conntrack_counter orig;
> +	struct ip_conntrack_counter reply;
> +};
> +
>  /* ctnetlink multicast groups: reports any change of ctinfo,
>   * ctstatus, or protocol state change.
>   */
> Index: linux-2.6.12-rc2-ctnl/net/ipv4/netfilter/ip_conntrack_netlink.c
> ===================================================================
> --- linux-2.6.12-rc2-ctnl.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-04-15 18:40:44.000000000 +0200
> +++ linux-2.6.12-rc2-ctnl/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-04-16 11:27:06.000000000 +0200
> @@ -27,6 +27,7 @@
>  #include <linux/net.h>
>  #include <linux/fcntl.h>
>  #include <linux/skbuff.h>
> +#include <linux/errno.h>
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  #include <net/sock.h>
> @@ -53,7 +54,7 @@
>  
>  MODULE_LICENSE("GPL");
>  
> -static char __initdata ctversion[] = "0.50";
> +static char __initdata ctversion[] = "0.52";
>  
>  #if 0
>  #define DEBUGP printk
> @@ -131,11 +132,42 @@
>  	return -1;
>  }
>  
> +#ifdef CONFIG_IP_NF_CT_ACCT
> +static inline int
> +ctnetlink_dump_counters(struct sk_buff *skb, const struct ip_conntrack *ct)
> +{
> +	const struct ip_conntrack_counter *ctr;
> +	struct cta_counters cc;
> +
> +	ctr = &ct->counters[IP_CT_DIR_ORIGINAL];
> +	memcpy(&cc.orig, ctr, sizeof(cc.orig));
> +
> +	ctr = &ct->counters[IP_CT_DIR_REPLY];
> +	memcpy(&cc.reply, ctr, sizeof(cc.reply));
> +	
> +	NFA_PUT(skb, CTA_COUNTERS, sizeof(cc), &cc);
> +	return 0;
> +
> +nfattr_failure:
> +	return -1;
> +}
> +#else
> +#define ctnetlink_dump_counters(a, b) (0)
> +#endif
> +
> +#ifdef CONFIG_IP_NF_CONNTRACK_MARK
>  static inline int
>  ctnetlink_dump_mark(struct sk_buff *skb, const struct ip_conntrack *ct)
>  {
> +	NFA_PUT(skb, CTA_MARK, sizeof(unsigned long), &ct->mark);
>  	return 0;
> +
> +nfattr_failure:
> +	return -1;
>  }
> +#else
> +#define ctnetlink_dump_mark(a, b) (0)
> +#endif
>  
>  static int
>  ctnetlink_fill_info(struct sk_buff *skb, u32 pid, u32 seq,
> @@ -158,6 +190,7 @@
>  	if (ctnetlink_dump_tuples(skb, ct) < 0 ||
>  	    ctnetlink_dump_status(skb, ct) < 0 ||
>  	    ctnetlink_dump_timeout(skb, ct) < 0 ||
> +	    ctnetlink_dump_counters(skb, ct) < 0 ||
>  	    ctnetlink_dump_protoinfo(skb, ct) < 0 ||
>  	    ctnetlink_dump_helpinfo(skb, ct) < 0 ||
>  	    ctnetlink_dump_mark(skb, ct) < 0)
> @@ -277,6 +310,8 @@
>  	[CTA_PROTOINFO-1]	= sizeof(struct cta_proto),
>  	[CTA_HELPINFO-1]	= sizeof(struct cta_help),
>  	[CTA_TIMEOUT-1]		= sizeof(unsigned long),
> +	[CTA_MARK-1]		= sizeof(unsigned long),
> +	[CTA_COUNTERS-1]	= sizeof(struct cta_counters),
>  
>  	[CTA_EXP_TUPLE-1]	= sizeof(struct ip_conntrack_tuple),
>  	[CTA_EXP_MASK-1]	= sizeof(struct ip_conntrack_tuple),
> @@ -387,6 +422,45 @@
>  	return skb->len;
>  }
>  
> +#ifdef CONFIG_IP_NF_CT_ACCT
> +static int
> +ctnetlink_dump_table_w(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct ip_conntrack *ct = NULL;
> +	struct ip_conntrack_tuple_hash *h;
> +	struct list_head *i;
> +
> +	DEBUGP("entered %s, last bucket=%lu id=%lu\n", __FUNCTION__, 
> +			cb->args[0], cb->args[1]);
> +
> +	WRITE_LOCK(&ip_conntrack_lock);
> +	for (; cb->args[0] < ip_conntrack_htable_size; 
> +					cb->args[0]++, cb->args[1]=0) {
> +		list_for_each(i, &ip_conntrack_hash[cb->args[0]]) {
> +			h = (struct ip_conntrack_tuple_hash *) i;
> +			if (DIRECTION(h) != IP_CT_DIR_ORIGINAL)
> +				continue;
> +			ct = tuplehash_to_ctrack(h);
> +			if (ct->id <= cb->args[1])
> +				continue;
> +			if (ctnetlink_fill_info(skb, NETLINK_CB(cb->skb).pid,
> +		                        	cb->nlh->nlmsg_seq,
> +						IPCTNL_MSG_NEWCONNTRACK,
> +						1, ct) < 0)
> +				break;
> +			cb->args[1] = ct->id;
> +
> +			memset(&ct->counters, 0, sizeof(ct->counters));
> +		}
> +	}
> +	WRITE_UNLOCK(&ip_conntrack_lock);
> +
> +	DEBUGP("leaving, last bucket=%lu id=%lu\n", cb->args[0], cb->args[1]);
> +
> +	return skb->len;
> +}
> +#endif
> +
>  static int
>  ctnetlink_get_conntrack(struct sock *ctnl, struct sk_buff *skb, 
>  			struct nlmsghdr *nlh, int *errp)
> @@ -407,10 +481,22 @@
>  		if (msg->nfgen_family != AF_INET)
>  			return -EAFNOSUPPORT;
>  
> -		if ((*errp = netlink_dump_start(ctnl, skb, nlh,
> -		                                ctnetlink_dump_table,
> -		                                ctnetlink_done)) != 0)
> +		if (NFNL_MSG_TYPE(nlh->nlmsg_type) ==
> +					IPCTNL_MSG_GETCT_CTRZERO) {
> +#ifdef CONFIG_IP_NF_CT_ACCT
> +			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
> +						ctnetlink_dump_table_w,
> +						ctnetlink_done)) != 0)
> +				return -EINVAL;
> +#else
> +			return -ENOTSUPP;
> +#endif
> +		} else {
> +			if ((*errp = netlink_dump_start(ctnl, skb, nlh,
> +		      		                        ctnetlink_dump_table,
> +		                                	ctnetlink_done)) != 0)
>  			return -EINVAL;
> +		}
>  
>  		rlen = NLMSG_ALIGN(nlh->nlmsg_len);
>  		if (rlen > skb->len)
> @@ -722,7 +808,9 @@
>  	return err;
>  }
>  
> -/* EXPECT */
> +/*********************************************************************** 
> + * EXPECT 
> + ***********************************************************************/ 
>  
>  static inline int
>  ctnetlink_exp_dump_tuples(struct sk_buff *skb,
> @@ -1173,6 +1261,8 @@
>  	ctnl_subsys->cb[IPCTNL_MSG_DELCONNTRACK].cap_required = CAP_NET_ADMIN;
>  	ctnl_subsys->cb[IPCTNL_MSG_GETCONNTRACK].call = ctnetlink_get_conntrack;
>  	ctnl_subsys->cb[IPCTNL_MSG_GETCONNTRACK].cap_required = CAP_NET_ADMIN;
> +	ctnl_subsys->cb[IPCTNL_MSG_GETCT_CTRZERO].call =ctnetlink_get_conntrack;
> +	ctnl_subsys->cb[IPCTNL_MSG_GETCT_CTRZERO].cap_required = CAP_NET_ADMIN;
>  	ctnl_subsys->cb[IPCTNL_MSG_NEWEXPECT].call = ctnetlink_new_expect;
>  	ctnl_subsys->cb[IPCTNL_MSG_NEWEXPECT].cap_required = CAP_NET_ADMIN;
>  	ctnl_subsys->cb[IPCTNL_MSG_DELEXPECT].call = ctnetlink_del_expect;
> Index: linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack.h
> ===================================================================
> --- linux-2.6.12-rc2-ctnl.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-04-15 18:40:33.000000000 +0200
> +++ linux-2.6.12-rc2-ctnl/include/linux/netfilter_ipv4/ip_conntrack.h	2005-04-16 10:43:54.000000000 +0200
> @@ -153,6 +153,12 @@
>  	struct ip_ct_irc_master ct_irc_info;
>  };
>  
> +struct ip_conntrack_counter
> +{
> +	u_int64_t packets;
> +	u_int64_t bytes;
> +};
> +
>  #ifdef __KERNEL__
>  #ifdef CONFIG_IP_NF_NAT_NEEDED
>  #include <linux/netfilter_ipv4/ip_nat.h>
> @@ -174,12 +180,6 @@
>  #define IP_NF_ASSERT(x)
>  #endif
>  
> -struct ip_conntrack_counter
> -{
> -	u_int64_t packets;
> -	u_int64_t bytes;
> -};
> -
>  struct ip_conntrack_helper;
>  
>  struct ip_conntrack
