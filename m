From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Help in netfilter kernel module
Date: Thu, 16 Oct 2003 09:25:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310160911240.6046-100000@filer.marasystems.com>
References: <20031016025527.23285.qmail@web13108.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?q?Daryl=20ong?= <yjong1977extramail@yahoo.com.sg>
In-Reply-To: <20031016025527.23285.qmail@web13108.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Oct 2003, Daryl ong wrote:

>    i am a new developer in this netfilter module.  i am developing a
> kernel module on a rehat linux 8 and using iptables v1.2.6a.  i came
> across a problem when i want to kfree_skb(skb).

> i have try to use NF_DROP to drop the packet if it doesnt match what i
> want to filter away.  But as netfilter currently didnt filter for
> PF_PACKET, my packet is able to go up to application layer.  So i
> intended to use kfree_skb but encounter the error.  Please tell me if
> there is any solutions.  Thank you.

If you want to drop a packet from netfilter you MUST NF_DROP it.  Freeing
it with kfree_skb won't help, and if done carelessly will really crash
things as the kernel expects the skb reference to be there.

I do not think you can filter PF_PACKET sockets using netfilter. These get 
the packet very early in the processing chain while netfilter operates 
at the IPv4/IPv6 layers.

In netfilter you can

a) Drop the packet via NF_DROP. This also terminates the session if you
are using conntrack.

b) Replace/modify the packet, making further processing see another
packet. See for example ipt_TCPMSS.c for a simple example of how to
replace a packet (this is a iptables module, but the same rules in how to
replace/modify a packet applies to a netfilter module)

c) Steal the packet, stopping further processing of this packet without 
terminating the session. (NF_STOLEN verdict)

In all three cases I think the original packet is still sent to PF_PACKET 
sockets for the reason outlined above.

Regards
Henrik
