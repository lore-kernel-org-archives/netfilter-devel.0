From: Mario <netfilter@mail.bg>
Subject: Re: Faking ethernet source MAC in NF_IP_POST_ROUTING
Date: Mon, 28 Jun 2004 12:31:32 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406281231.33026.netfilter@mail.bg>
References: <20040623161503.188c007f@mindrape>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Phillip Whelan <pwhelan@exis.cl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040623161503.188c007f@mindrape>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wednesday 23 June 2004 19:15, Phillip Whelan wrote:
> Hello,
>
> Quote: (myself)
>   "I've been working lately on a netfilter hook extension which Rewrites
> outgoing ARP packets to spoof a host's MAC address."
>
> I already managed to solve a problem involving ARP replies automagically
> updating arp caches by modifying the arp payload's sender hw_addr. (or
> perhaps, the tha... whatever, it works).
>
> The kernel is now spoofing itself, etc... but, it still sends out packets
> with the real MAC address. This, of course confuses the end host to no
> ends.
>
> In NF_IP_POST_ROUTING, the skb->mac is not NULL, but skb->mac_len is 0.
> Directly modifying the skb->mac would just lead to memory corruption.
> How would I modify the source MAC address? (Im inside NF_IP_POST_ROUTING).
> Can I access through a negative offset from skb->data? (net/ipv4/arp.c does
> this, I think).


You can modify MAC address by using ebtables & bridge extentions.
Using ebtables on bridge device you can have multiple MACs and can do MAC SNAT 
or DNAT.iptables can't change MAC addresses because iptables is 
layer3.ebtables is layer2 and it can modify MACs.Try it! It works! Tested ;P~
You can use it also if you want to conflict huge ip classes...some ISPs are 
using this way to stop their clients using their local area networks if they 
are not paying.It can be useful in your case.
