From: Wayne Schroeder <raz@positivenetworks.net>
Subject: Re: Problem when writing a custom target for PRE and POST routing.
Date: Mon, 25 Sep 2006 17:42:24 -0500
Message-ID: <45185B50.9020705@positivenetworks.net>
References: <45184BB7.8000102@positivenetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wayne Schroeder <raz@positivenetworks.net>
In-Reply-To: <45184BB7.8000102@positivenetworks.net>
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

I consulted with ipt_TCPMSS.c and saw that it didn't use h.th to get the
tcp header and instead just looked after the nh.iph data for the tcp
header (calculated from ihl) and modified it there.  I tried this, and
it worked perfectly.  Granted now I have some sanity code to write, but
it works.

It seems that sk_buff's h member, while being set, simply isn't valid in
PREROUTING.

Wayne


Wayne Schroeder wrote:
> I am working on a target module that will rewrite the source, dest, and
> mark of a packet.  A project I am doing cannot use the stateful nat for
> a few reasons.  I've accounted for correcting the ip, tcp, udp, and icmp
> checksums already (via calling of the ip_nat_cheat_check from
> ip_nat_core) and have verified that the sums are indeed correct when
> packets leave after being modified in POSTROUTING.  My problem seems to
> be on the return path in PREROUTING.
> 
> When my target is called in prerouting and the checksums on the packet
> are corrected -- it has the side effect of corrupting the destination ip
> in the packet.  The same code called in postrouting works flawlessly.  I
> have determined the destination address is getting corrupted by looking
> at -j LOG after my target is called in the prerouting chain in the
> mangle table.  I have included the chunk of code from the TCPMSS target
> that checks for cloned skbs -- so this is not an issue.  If I comment
> out my fixChecksums function, the destination address is NOT corrupted.
> 
> ------------
> static void fixChecksums(
>    struct sk_buff *skb,
>    u_int32_t oldData,
>    u_int32_t newData)
> {
>    /* ip checksum */
>    skb->nh.iph->check = ip_nat_cheat_check(~oldData, newData,
>       skb->nh.iph->check);
> 
>    switch (skb->nh.iph->protocol)
>    {
>       case IPPROTO_TCP:
> 
>          if (! skb->h.th)
>             break; /* bad */
> 
>          skb->h.th->check = ip_nat_cheat_check(~oldData, newData,
>             skb->h.th->check);
> 
>          break;
> 
>       case IPPROTO_UDP:
> 
>          if (! skb->h.uh)
>             break; /* bad */
> 
>          if (! skb->h.uh->check)
>             break;
> 
>          if (skb->h.uh->check)
>             skb->h.uh->check = ip_nat_cheat_check(~oldData, newData,
>                skb->h.uh->check);
> 
>          break;
> 
>       case IPPROTO_ICMP:
> 
>          if (! skb->h.icmph)
>             break; /* bad */
> 
>          skb->h.icmph->checksum = ip_nat_cheat_check(~oldData, newData,
>             skb->h.icmph->checksum);
> 
>          break;
>    }
> }
> 
> -------
> 
> 
> The function is called like so:
> 
>       fixChecksums(*pskb, (*pskb)->nh.iph->saddr, info->src.s_addr);
>       (*pskb)->nh.iph->saddr = info->src.s_addr;
> 
> The above is changing the SOURCE ip of the packet, yet when done in
> prerouting, it corrupts the dest ip if the fixChecksums is called.
> 
> It certianly seems as if there is a problem with the sk_buff I'm getting
> in the context of prerouting.  This is on a 2.4.32 kernel using iptables
> 1.2.11 userland.  I am using these kernel and userland versions to
> support existing deployed debian stable installs.
> 
> It's worth noting that only the first two bytes of the destination ip
> seem to be getting corrupted, while the source ip directly in front of
> it in the packet gets no corruption.  I'm really confused here.
> 
> Wayne
> 
> 
