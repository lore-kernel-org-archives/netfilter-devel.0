From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: the connection is ESTABLISHED but UNREPLIED?What's up?
Date: Wed, 17 Aug 2005 11:59:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0508171154110.23501@tux.rsn.bth.se>
References: <1124269866.6032.1.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Hellwolf Misty <hellwolf@seu.edu.cn>
In-Reply-To: <1124269866.6032.1.camel@cocteau.hellwolf-misty.org>
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

On Wed, 17 Aug 2005, Hellwolf Misty wrote:

> I got this from /proc/net/ip_conntrack:
>
> tcp      6 425241 ESTABLISHED src=218.93.152.132 dst=61.178.246.98
> sport=58070 dport=80 packets=1 bytes=40 [UNREPLIED] src=61.178.246.98
> dst=218.93.152.132 sport=80 dport=58070 packets=0 bytes=0 mark=0 use=1
>
> But I don't understand why did it happen.

Most probably because of something called connection pickup where
ip_conntrack picks up connections that were already established by the two
peers. For example if you reboot the router, when it comes back up it sees
packets from connections that were established before it was rebooted,
then it adds them to conntrack with state ESTABLISHED, but if it only has
seen packets in one direction it's UNREPLIED as well.

It's not possible to turn this behaviour off in 2.4 without extra patches,
in 2.6 it's possible to turn off by echoing 0 to
/proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_loose

What's left to do in 2.6 is to add them with lower timeout until they have
been replied as well (more specifically, ip_conntrack_tcp_loose
number of packets has been seen in both directions)

/Martin
