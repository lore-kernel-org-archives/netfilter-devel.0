From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_nat_mangle_udp_packet problems
Date: Fri, 06 May 2005 20:36:33 +0200
Message-ID: <427BB931.60709@trash.net>
References: <1115310771.1852.11.camel@www.l-chr.com.ar>	
	<427B9A38.2040602@trash.net>
	<1115404044.1847.19.camel@www.l-chr.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christian Hentschel <chentschel@arnet.com.ar>
In-Reply-To: <1115404044.1847.19.camel@www.l-chr.com.ar>
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

Christian Hentschel wrote:
> What i see in enlarge_skb() is that if packet is larger than 65536 it
> does as u said a copy.

No, it drops it if it gets this large. skb_copy_expand(), as it name
implies, copies the packet to a new one with more room.

> I see that enlarge_skb() does the "reload" of the pointer to pskb,
> pointing it to the enlarged skbuff. This is what u meant?
> 
>         kfree_skb(*pskb);
>         *pskb = nskb;
>         return 1;

Not really. What I meant is that if you have something like this before
the call to ip_nat_mangle_udp_packet():

struct udphdr *uh = (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;

then you need to reload the pointer after the call like this:

uh = (void *)(*pskb)->nh.iph + (*pskb)->nh.iph->ihl*4;

otherwise it might point to the old and already freed skb.

> what is happening is really obscure for me.

Just post your code if this doesn't help.

Regards
Patrick
