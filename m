From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 14 Jun 2004 04:22:31 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CD0BE7.3050802@trash.net>
References: <40CCECFF.9070907@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40CCECFF.9070907@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,

Pablo Neira wrote:
> Hi Patrick and everyone,
> 
> I added a new function to the current protocol helper API. It is called 
> before resolve_normal_ct, this could let us perform actions before 
> starting a new session/conntrack.
> 
> These actions could be:
> - check for malformed/unclean packets.
> - handle special packets like in ICMP.
> 
> This way, Jozsef could call unclean() here in his tcp-window-tracking 
> patch and we won't need to add protocol specific function to the core of 
> the conntrack system like icmp_error_track to handle special ICMP 
> messages. We could also check for unclean udp and icmp packets.

Nice, I like that ;)

> This function returns 0 if no error was found or an action (NF_*) if an 
> error/special action needs to be done to handle a message.
> 
> Three issues to consider:
> 
> - I copied and pasted icmp_error_track to ip_fw_compat.c since this 
> function is used there, I know that this implies replicating code but 
> since that backward compability will be drop someday, I consider that 
> it's not so serious.

Couldn't you use ip_ct_find_proto(IPPROTO_ICMP)->error() instead ?

> - I marked ip_ct_find_proto, ip_conntrack_find_get, invert_tuple and 
> get_tuple as extern in ip_conntrack_protocol.h for icmp. I think that we 
> could need them later to track protocols like AH/ESP which are 
> encapsulated, in that case we could call ip_ct_find_proto and the the 
> protocol helper functions for the protocol encapsulated. If this is the 
> correct way to do this, we will also need to review again the API if i'm 
> not wrong (add something like an offset to the header of the 
> encapsulated protocol).

invert_tuple and find_tuple probably should be prefixed with ip_ct_
then.

> - oh! I added udp checksum checking, well, I just stole that from 
> Joszef's tcp tracking code and rename things... I also read that email 
> that Martin sent to report the bug with checksum checking. So if you 
> consider that this patch is ok, I'll implement correctly checking for 
> malformed packets for udp and icmp :-) (in that case I will try again to 
> steal as much Joszef's code as possible :-))

This should be an extra patch.

> 
> Hope that I didn't break/miss anything, if so, please let me know.

Some more comments below.

Regards
Patrick

> 
> best regards,
> Pablo
> 
> 
> ------------------------------------------------------------------------
> 
> diff -u -r1.1.1.1 ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c	13 Jun 2004 22:47:49 -0000
> @@ -146,7 +146,7 @@
>  	return protocol->pkt_to_tuple(skb, dataoff, tuple);
>  }
>  
> -static int
> +int
>  invert_tuple(struct ip_conntrack_tuple *inverse,
>  	     const struct ip_conntrack_tuple *orig,
>  	     const struct ip_conntrack_protocol *protocol)
> @@ -495,83 +495,6 @@
>  	return h != NULL;
>  }
>  
> -/* Returns conntrack if it dealt with ICMP, and filled in skb fields */
> -struct ip_conntrack *
> -icmp_error_track(struct sk_buff *skb,
> -		 enum ip_conntrack_info *ctinfo,
> -		 unsigned int hooknum)
> -{
> -	struct ip_conntrack_tuple innertuple, origtuple;
> -	struct {
> -		struct icmphdr icmp;
> -		struct iphdr ip;
> -	} inside;
> -	struct ip_conntrack_protocol *innerproto;
> -	struct ip_conntrack_tuple_hash *h;
> -	int dataoff;
> -
> -	IP_NF_ASSERT(skb->nfct == NULL);
> -
> -	/* Not enough header? */
> -	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
> -		return NULL;
> -
> -	if (inside.icmp.type != ICMP_DEST_UNREACH
> -	    && inside.icmp.type != ICMP_SOURCE_QUENCH
> -	    && inside.icmp.type != ICMP_TIME_EXCEEDED
> -	    && inside.icmp.type != ICMP_PARAMETERPROB
> -	    && inside.icmp.type != ICMP_REDIRECT)
> -		return NULL;
> -
> -	/* Ignore ICMP's containing fragments (shouldn't happen) */
> -	if (inside.ip.frag_off & htons(IP_OFFSET)) {
> -		DEBUGP("icmp_error_track: fragment of proto %u\n",
> -		       inside.ip.protocol);
> -		return NULL;
> -	}
> -
> -	innerproto = ip_ct_find_proto(inside.ip.protocol);
> -	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
> -	/* Are they talking about one of our connections? */
> -	if (!get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
> -		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
> -		return NULL;
> -	}
> -
> -	/* Ordinarily, we'd expect the inverted tupleproto, but it's
> -	   been preserved inside the ICMP. */
> -	if (!invert_tuple(&innertuple, &origtuple, innerproto)) {
> -		DEBUGP("icmp_error_track: Can't invert tuple\n");
> -		return NULL;
> -	}
> -
> -	*ctinfo = IP_CT_RELATED;
> -
> -	h = ip_conntrack_find_get(&innertuple, NULL);
> -	if (!h) {
> -		/* Locally generated ICMPs will match inverted if they
> -		   haven't been SNAT'ed yet */
> -		/* FIXME: NAT code has to handle half-done double NAT --RR */
> -		if (hooknum == NF_IP_LOCAL_OUT)
> -			h = ip_conntrack_find_get(&origtuple, NULL);
> -
> -		if (!h) {
> -			DEBUGP("icmp_error_track: no match\n");
> -			return NULL;
> -		}
> -		/* Reverse direction from that found */
> -		if (DIRECTION(h) != IP_CT_DIR_REPLY)
> -			*ctinfo += IP_CT_IS_REPLY;
> -	} else {
> -		if (DIRECTION(h) == IP_CT_DIR_REPLY)
> -			*ctinfo += IP_CT_IS_REPLY;
> -	}
> -
> -	/* Update skb to refer to this connection */
> -	skb->nfct = &h->ctrack->infos[*ctinfo];
> -	return h->ctrack;
> -}
> -
>  /* There's a small race here where we may free a just-assured
>     connection.  Too bad: we're in trouble anyway. */
>  static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
> @@ -828,10 +751,9 @@
>  
>  	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
>  
> -	/* It may be an icmp error... */
> -	if ((*pskb)->nh.iph->protocol == IPPROTO_ICMP 
> -	    && icmp_error_track(*pskb, &ctinfo, hooknum))
> -		return NF_ACCEPT;
> +	/* It may be an special packet, error, unclean... */
> +	if ((ret = proto->error(*pskb, &ctinfo, hooknum)))

should check for != NF_ACCEPT here

> +		return ret;
>  
>  	if (!(ct = resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
>  		/* Not valid part of a connection */
> diff -u -r1.1.1.1 ip_conntrack_proto_generic.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_generic.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_generic.c	13 Jun 2004 22:54:47 -0000
> @@ -62,8 +62,15 @@
>  	return 1;
>  }
>  
> +static int
> +error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo, 
> +      unsigned int hooknum)
> +{
> +	return 0;
> +}
> +
>  struct ip_conntrack_protocol ip_conntrack_generic_protocol
>  = { { NULL, NULL }, 0, "unknown",
>      generic_pkt_to_tuple, generic_invert_tuple, generic_print_tuple,
> -    generic_print_conntrack, packet, new, NULL, NULL, NULL };
> +    generic_print_conntrack, packet, new, NULL, NULL, error, NULL };
>  
> diff -u -r1.1.1.1 ip_conntrack_proto_icmp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	13 Jun 2004 22:51:49 -0000
> @@ -12,6 +12,8 @@
>  #include <linux/netfilter.h>
>  #include <linux/in.h>
>  #include <linux/icmp.h>
> +#include <net/ip.h>
> +#include <linux/netfilter_ipv4/ip_conntrack.h>
>  #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
>  
>  unsigned long ip_ct_icmp_timeout = 30*HZ;
> @@ -122,7 +124,83 @@
>  	return 1;
>  }
>  
> +static int
> +icmp_error(struct sk_buff *skb,
> +		 enum ip_conntrack_info *ctinfo,
> +		 unsigned int hooknum)
> +{
> +	struct ip_conntrack_tuple innertuple, origtuple;
> +	struct {
> +		struct icmphdr icmp;
> +		struct iphdr ip;
> +	} inside;
> +	struct ip_conntrack_protocol *innerproto;
> +	struct ip_conntrack_tuple_hash *h;
> +	int dataoff;
> +
> +	IP_NF_ASSERT(skb->nfct == NULL);
> +
> +	/* Not enough header? */
> +	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
> +		return NF_ACCEPT;
> +
> +	if (inside.icmp.type != ICMP_DEST_UNREACH
> +	    && inside.icmp.type != ICMP_SOURCE_QUENCH
> +	    && inside.icmp.type != ICMP_TIME_EXCEEDED
> +	    && inside.icmp.type != ICMP_PARAMETERPROB
> +	    && inside.icmp.type != ICMP_REDIRECT)
> +		return 0;

while you're at it, change this to NF_ACCEPT please ;)

> +
> +	/* Ignore ICMP's containing fragments (shouldn't happen) */
> +	if (inside.ip.frag_off & htons(IP_OFFSET)) {
> +		DEBUGP("icmp_error_track: fragment of proto %u\n",
> +		       inside.ip.protocol);
> +		return NF_ACCEPT;
> +	}
> +
> +	innerproto = ip_ct_find_proto(inside.ip.protocol);
> +	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
> +	/* Are they talking about one of our connections? */
> +	if (!get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
> +		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
> +		return NF_ACCEPT;
> +	}
> +
> +	/* Ordinarily, we'd expect the inverted tupleproto, but it's
> +	   been preserved inside the ICMP. */
> +	if (!invert_tuple(&innertuple, &origtuple, innerproto)) {
> +		DEBUGP("icmp_error_track: Can't invert tuple\n");
> +		return NF_ACCEPT;
> +	}
> +
> +	*ctinfo = IP_CT_RELATED;
> +
> +	h = ip_conntrack_find_get(&innertuple, NULL);
> +	if (!h) {
> +		/* Locally generated ICMPs will match inverted if they
> +		   haven't been SNAT'ed yet */
> +		/* FIXME: NAT code has to handle half-done double NAT --RR */
> +		if (hooknum == NF_IP_LOCAL_OUT)
> +			h = ip_conntrack_find_get(&origtuple, NULL);
> +
> +		if (!h) {
> +			DEBUGP("icmp_error_track: no match\n");
> +			return 0;

this too

> +		}
> +		/* Reverse direction from that found */
> +		if (DIRECTION(h) != IP_CT_DIR_REPLY)
> +			*ctinfo += IP_CT_IS_REPLY;
> +	} else {
> +		if (DIRECTION(h) == IP_CT_DIR_REPLY)
> +			*ctinfo += IP_CT_IS_REPLY;
> +	}
> +
> +	/* Update skb to refer to this connection */
> +	skb->nfct = &h->ctrack->infos[*ctinfo];
> +	return NF_ACCEPT;
> +}
> +
>  struct ip_conntrack_protocol ip_conntrack_protocol_icmp
>  = { { NULL, NULL }, IPPROTO_ICMP, "icmp",
>      icmp_pkt_to_tuple, icmp_invert_tuple, icmp_print_tuple,
> -    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, NULL };
> +    icmp_print_conntrack, icmp_packet, icmp_new, NULL, NULL, icmp_error, NULL};
> diff -u -r1.1.1.1 ip_conntrack_proto_tcp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	13 Jun 2004 22:53:23 -0000
> @@ -266,7 +266,15 @@
>  	return between(exp->seq, ntohl(tcph.seq), ntohl(tcph.seq) + datalen);
>  }
>  
> +static int
> +tcp_error(struct sk_buff *skb,
> +	   enum ip_conntrack_info *ctinfo,
> +	   unsigned int hooknum)

please don't use newlines unless neccessarry .. looks like it would fit
in one line

> +{
> +	return 0;
> +}
> +
>  struct ip_conntrack_protocol ip_conntrack_protocol_tcp
>  = { { NULL, NULL }, IPPROTO_TCP, "tcp",
>      tcp_pkt_to_tuple, tcp_invert_tuple, tcp_print_tuple, tcp_print_conntrack,
> -    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, NULL };
> +    tcp_packet, tcp_new, NULL, tcp_exp_matches_pkt, tcp_error, NULL };
> diff -u -r1.1.1.1 ip_conntrack_proto_udp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c	13 Jun 2004 23:17:51 -0000
> @@ -12,8 +12,16 @@
>  #include <linux/netfilter.h>
>  #include <linux/in.h>
>  #include <linux/udp.h>
> +#include <asm/checksum.h>
>  #include <linux/netfilter_ipv4/ip_conntrack_protocol.h>
>  
> +#if 0
> +#define NET_RATELIMIT(foo)     (foo)
> +#else
> +#define NET_RATELIMIT(foo)     ((foo) && net_ratelimit())
> +#endif
> +
> +int ip_ct_udp_log_invalid = 1;
>  unsigned long ip_ct_udp_timeout = 30*HZ;
>  unsigned long ip_ct_udp_timeout_stream = 180*HZ;
>  
> @@ -80,7 +88,31 @@
>  	return 1;
>  }
>  
> +static int
> +udp_error(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
> +	  unsigned int hooknum)
> +{
> +	struct iphdr *iph = skb->nh.iph;
> +	unsigned int udplen = skb->len - iph->ihl * 4;
> +
> +	/* Checksum invalid?  Ignore. */
> +	/* FIXME: Source route IP option packets --RR */

UDP checksum may be zero (unset)

> +	if (csum_tcpudp_magic(iph->saddr, iph->daddr,
> +			      udplen, IPPROTO_UDP,
> +			      skb->ip_summed == CHECKSUM_HW 
> +			      	? skb->csum
> +			      	: skb_checksum(skb, iph->ihl*4, udplen, 0))) {
> +		if (NET_RATELIMIT(ip_ct_udp_log_invalid))
> +			nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
> +				  "ip_conntrack_udp: INVALID: "
> +				  "bad UDP checksum ");
> +		return NF_ACCEPT;
> +	}
> +
> +	return 0;
> +}
> +
>  struct ip_conntrack_protocol ip_conntrack_protocol_udp
>  = { { NULL, NULL }, IPPROTO_UDP, "udp",
>      udp_pkt_to_tuple, udp_invert_tuple, udp_print_tuple, udp_print_conntrack,
> -    udp_packet, udp_new, NULL, NULL, NULL };
> +    udp_packet, udp_new, NULL, NULL, udp_error, NULL };
> diff -u -r1.1.1.1 ip_fw_compat_masq.c
> --- a/net/ipv4/netfilter/ip_fw_compat_masq.c	11 May 2004 13:07:08 -0000	1.1.1.1
> +++ b/net/ipv4/netfilter/ip_fw_compat_masq.c	13 Jun 2004 23:25:21 -0000
> @@ -24,6 +24,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/module.h>
>  #include <net/route.h>
> +#include <net/ip.h>
>  
>  #define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
>  #define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
> @@ -41,6 +42,83 @@
>  #define DEBUGP(format, args...)
>  #endif
>  
> +/* Returns conntrack if it dealt with ICMP, and filled in skb fields */
> +struct ip_conntrack *
> +icmp_error_track(struct sk_buff *skb,
> +		 enum ip_conntrack_info *ctinfo,
> +		 unsigned int hooknum)
> +{
> +	struct ip_conntrack_tuple innertuple, origtuple;
> +	struct {
> +		struct icmphdr icmp;
> +		struct iphdr ip;
> +	} inside;
> +	struct ip_conntrack_protocol *innerproto;
> +	struct ip_conntrack_tuple_hash *h;
> +	int dataoff;
> +
> +	IP_NF_ASSERT(skb->nfct == NULL);
> +
> +	/* Not enough header? */
> +	if (skb_copy_bits(skb, skb->nh.iph->ihl*4, &inside, sizeof(inside))!=0)
> +		return NULL;
> +
> +	if (inside.icmp.type != ICMP_DEST_UNREACH
> +	    && inside.icmp.type != ICMP_SOURCE_QUENCH
> +	    && inside.icmp.type != ICMP_TIME_EXCEEDED
> +	    && inside.icmp.type != ICMP_PARAMETERPROB
> +	    && inside.icmp.type != ICMP_REDIRECT)
> +		return NULL;
> +
> +	/* Ignore ICMP's containing fragments (shouldn't happen) */
> +	if (inside.ip.frag_off & htons(IP_OFFSET)) {
> +		DEBUGP("icmp_error_track: fragment of proto %u\n",
> +		       inside.ip.protocol);
> +		return NULL;
> +	}
> +
> +	innerproto = ip_ct_find_proto(inside.ip.protocol);
> +	dataoff = skb->nh.iph->ihl*4 + sizeof(inside.icmp) + inside.ip.ihl*4;
> +	/* Are they talking about one of our connections? */
> +	if (!get_tuple(&inside.ip, skb, dataoff, &origtuple, innerproto)) {
> +		DEBUGP("icmp_error: ! get_tuple p=%u", inside.ip.protocol);
> +		return NULL;
> +	}
> +
> +	/* Ordinarily, we'd expect the inverted tupleproto, but it's
> +	   been preserved inside the ICMP. */
> +	if (!invert_tuple(&innertuple, &origtuple, innerproto)) {
> +		DEBUGP("icmp_error_track: Can't invert tuple\n");
> +		return NULL;
> +	}
> +
> +	*ctinfo = IP_CT_RELATED;
> +
> +	h = ip_conntrack_find_get(&innertuple, NULL);
> +	if (!h) {
> +		/* Locally generated ICMPs will match inverted if they
> +		   haven't been SNAT'ed yet */
> +		/* FIXME: NAT code has to handle half-done double NAT --RR */
> +		if (hooknum == NF_IP_LOCAL_OUT)
> +			h = ip_conntrack_find_get(&origtuple, NULL);
> +
> +		if (!h) {
> +			DEBUGP("icmp_error_track: no match\n");
> +			return NULL;
> +		}
> +		/* Reverse direction from that found */
> +		if (DIRECTION(h) != IP_CT_DIR_REPLY)
> +			*ctinfo += IP_CT_IS_REPLY;
> +	} else {
> +		if (DIRECTION(h) == IP_CT_DIR_REPLY)
> +			*ctinfo += IP_CT_IS_REPLY;
> +	}
> +
> +	/* Update skb to refer to this connection */
> +	skb->nfct = &h->ctrack->infos[*ctinfo];
> +	return h->ctrack;
> +}
> +
>  unsigned int
>  do_masquerade(struct sk_buff **pskb, const struct net_device *dev)
>  {
> diff -u -r1.1.1.1 ip_conntrack.h
> --- a/include/linux/netfilter_ipv4/ip_conntrack.h	11 May 2004 13:35:40 -0000	1.1.1.1
> +++ b/include/linux/netfilter_ipv4/ip_conntrack.h	13 Jun 2004 09:23:03 -0000
> @@ -264,6 +264,26 @@
>  ip_ct_selective_cleanup(int (*kill)(const struct ip_conntrack *i, void *data),
>  			void *data);
>  
> +extern struct ip_conntrack_protocol *
> +ip_ct_find_proto(u_int8_t protocol);
> +
> +extern int
> +get_tuple(const struct iphdr *iph,
> +	  const struct sk_buff *skb,
> +	  unsigned int dataoff,
> +	  struct ip_conntrack_tuple *tuple,
> +	  const struct ip_conntrack_protocol *protocol);
> +
> +extern int
> +invert_tuple(struct ip_conntrack_tuple *inverse,
> +	     const struct ip_conntrack_tuple *orig,
> +	     const struct ip_conntrack_protocol *protocol);
> +
> +/* Find a connection corresponding to a tuple. */
> +extern struct ip_conntrack_tuple_hash *
> +ip_conntrack_find_get(const struct ip_conntrack_tuple *tuple,
> +		      const struct ip_conntrack *ignored_conntrack);
> +
>  /* It's confirmed if it is, or has been in the hash table. */
>  static inline int is_confirmed(struct ip_conntrack *ct)
>  {
> diff -u -r1.1.1.1 ip_conntrack_protocol.h
> --- a/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	11 May 2004 13:35:39 -0000	1.1.1.1
> +++ b/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	13 Jun 2004 22:54:02 -0000
> @@ -50,6 +50,9 @@
>  	int (*exp_matches_pkt)(struct ip_conntrack_expect *exp,
>  			       const struct sk_buff *skb);
>  
> +	int (*error)(struct sk_buff *skb, enum ip_conntrack_info *ctinfo,
> +		     unsigned int hooknum);
> +
>  	/* Module (if any) which this is connected to. */
>  	struct module *me;
>  };
