From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [PATCH 2.6.10 1/1] netfilter: fix crash
 on	nat+icmp packets
Date: Wed, 02 Mar 2005 10:26:41 +0100
Message-ID: <422586D1.5000609@trash.net>
References: <Pine.LNX.4.61.0503011830590.31296@slash.mukesh.agrawals.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org,
	trivial@rustcorp.com.au, linux-kernel@vger.kernel.org
To: mukesh agrawal <mukesh@cs.cmu.edu>
In-Reply-To: <Pine.LNX.4.61.0503011830590.31296@slash.mukesh.agrawals.org>
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

mukesh agrawal wrote:

> The cause of the crash is that udp_manip_pkt reads *pskb into iph before 
> calling skb_ip_make_writable, and fails to update iph after the call. 
> Since skb_ip_make_writable may delete the original skb when it makes a 
> copy, a page fault may occur when udp_manip_pkt later dereferences iph.

This bug has already been fixed in 2.6.11-rc.

Regards
Patrick

> 
> diff -uprN linux-2.6.10.orig/net/ipv4/netfilter/ip_nat_proto_udp.c 
> linux-2.6.10.fixed/net/ipv4/netfilter/ip_nat_proto_udp.c
> --- linux-2.6.10.orig/net/ipv4/netfilter/ip_nat_proto_udp.c    
> 2004-12-24 16:34:01.000000000 -0500
> +++ linux-2.6.10.fixed/net/ipv4/netfilter/ip_nat_proto_udp.c    
> 2005-03-01 19:32:21.000000000 -0500
> @@ -95,6 +95,9 @@ udp_manip_pkt(struct sk_buff **pskb,
> 
>      if (!skb_ip_make_writable(pskb, hdroff + sizeof(hdr)))
>          return 0;
> +    /* skb_ip_make_writable may have copied the skb, and deleted
> +       the original */
> +    iph = (struct iphdr *)((*pskb)->data + iphdroff);
> 
>      hdr = (void *)(*pskb)->data + hdroff;
>      if (maniptype == IP_NAT_MANIP_SRC) {
> 
