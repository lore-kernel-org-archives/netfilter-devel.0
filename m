From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes & 64bit counters
Date: Wed, 10 Jan 2007 14:36:08 +0100
Message-ID: <45A4EBC8.60304@trash.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net> <45660CD5.1090405@netfilter.org>
	<4566B6B6.4060808@trash.net>
	<Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <olenf@ans.pl>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> OK, maybe something like this can be accepted - no ifdefs, 64 bit
> counters unconditionally for both ip_conntrack/nf_conntrack. If someone
> needs to save memory it is IMHO better to simply disable accounting at all.


Or ideally have a runtime option. Something to keep in mind when
redesigning the nf_conntrack allocation scheme.

> [NETFILTER] Reimplementation of 64bit counters for bytes/packets accounting
> 
> Initially netfilter has had 64bit counters for conntrack-based
> accounting, but
> it was changed in 2.6.14 to save memory. Unfortunately in-kernel 64bit
> counters are
> still required, for example with "connbytes" extension.
> 
> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> 
> diff -Nur
> linux-2.6.19.1-orig/include/linux/netfilter/nf_conntrack_common.h
> linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nf_conntrack_common.h
> --- linux-2.6.19.1-orig/include/linux/netfilter/nf_conntrack_common.h   
> 2006-12-11 20:32:53.000000000 +0100
> +++
> linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nf_conntrack_common.h   
> 2006-12-22 21:15:10.000000000 +0100
> @@ -122,7 +122,7 @@
>      IPCT_NATINFO_BIT = 10,
>      IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
> 
> -    /* Counter highest bit has been set */
> +    /* Counter highest bit has been set - UNUSED */
>      IPCT_COUNTER_FILLING_BIT = 11,
>      IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),


No need to keep this.

> @@ -139,8 +139,8 @@
>  #ifdef __KERNEL__
>  struct ip_conntrack_counter
>  {
> -    u_int32_t packets;
> -    u_int32_t bytes;
> +    u_int64_t packets;
> +    u_int64_t bytes;
>  };
> 
>  struct ip_conntrack_stat
> diff -Nur
> linux-2.6.19.1-orig/include/linux/netfilter/nfnetlink_conntrack.h
> linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nfnetlink_conntrack.h
> --- linux-2.6.19.1-orig/include/linux/netfilter/nfnetlink_conntrack.h   
> 2006-12-11 20:32:53.000000000 +0100
> +++
> linux-2.6.19.1-64bitconntrack/include/linux/netfilter/nfnetlink_conntrack.h   
> 2006-12-22 21:15:26.000000000 +0100
> @@ -89,10 +89,10 @@
> 
>  enum ctattr_counters {
>      CTA_COUNTERS_UNSPEC,
> -    CTA_COUNTERS_PACKETS,        /* old 64bit counters */
> -    CTA_COUNTERS_BYTES,        /* old 64bit counters */
> -    CTA_COUNTERS32_PACKETS,
> -    CTA_COUNTERS32_BYTES,
> +    CTA_COUNTERS_PACKETS,        /* 64bit counters */
> +    CTA_COUNTERS_BYTES,        /* 64bit counters */
> +    CTA_COUNTERS32_PACKETS,        /* unused */
> +    CTA_COUNTERS32_BYTES,        /* unused */
>      __CTA_COUNTERS_MAX
>  };
>  #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
> diff -Nur linux-2.6.19.1-orig/net/ipv4/netfilter/ip_conntrack_core.c
> linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c
> --- linux-2.6.19.1-orig/net/ipv4/netfilter/ip_conntrack_core.c   
> 2006-12-11 20:32:53.000000000 +0100
> +++
> linux-2.6.19.1-64bitconntrack/net/ipv4/netfilter/ip_conntrack_core.c   
> 2006-12-22 21:13:35.000000000 +0100
> @@ -1148,9 +1148,6 @@
>          ct->counters[CTINFO2DIR(ctinfo)].packets++;
>          ct->counters[CTINFO2DIR(ctinfo)].bytes +=
>                          ntohs(skb->nh.iph->tot_len);
> -        if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
> -            || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
> -            event |= IPCT_COUNTER_FILLING;


This was actually broken before, since the counters are not
reset (they just overflow) an event was generated for every
packet until the overflow once they reached 2^31. Anyway,
I'm not sure how ulogd2 uses these counters, Harald, is it
necessary to receive period updates?
