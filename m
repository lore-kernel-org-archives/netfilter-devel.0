From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Faking ethernet source MAC in NF_IP_POST_ROUTING
Date: Thu, 24 Jun 2004 10:07:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406241002580.17474-100000@filer.marasystems.com>
References: <20040623161503.188c007f@mindrape>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phillip Whelan <pwhelan@exis.cl>
In-Reply-To: <20040623161503.188c007f@mindrape>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 23 Jun 2004, Phillip Whelan wrote:

> In NF_IP_POST_ROUTING, the skb->mac is not NULL, but skb->mac_len is 0.
> Directly modifying the skb->mac would just lead to memory corruption.  
> How would I modify the source MAC address? (Im inside
> NF_IP_POST_ROUTING). Can I access through a negative offset from
> skb->data? (net/ipv4/arp.c does this, I think).

You can't from netfilter. The MAC is added very very late in the packet 
sending process, after the NF_IP_POST_ROUTING hook.

What you maybe can do if ARP is your only concern is to run ARP in
userspace and send the replies using a raw socket.

But I honestly do not understand why you want to do this. The ARP address
is configurable (see the ip link command), and there even exists patches
to allow a single Ethernet to act as multiple virtual interfaces each with
their own MAC... (look for mac vlan, can be found from the same source as
the vlan patch)

Regards
Henrik
