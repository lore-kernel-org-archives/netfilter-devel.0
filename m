From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Fix RST handling in ip_conntrack_proto_tcp.c
Date: Sat, 1 Jan 2005 15:59:20 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501011551420.15783@blackhole.kfki.hu>
References: <1104511137.3821.20.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1104511137.3821.20.camel@tux.rsn.bth.se>
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

Hi Martin,

On Fri, 31 Dec 2004, Martin Josefsson wrote:

> Your latest patch contained a change to the RST handling.
> The change was that an RST is ignored if the previous packet was an ACK.
> This is happens all the time. I know it was intended as a fix for the
> SYN - ACK probe - RST sequence but it breaks normal usage. The problem
> is that connections that end with RST never get their state changed and
> are left in ESTABLISHED state with a large timeout.

Ouch!

> The patch below adds a check for
> !test_bit(IPS_ASSURED_BIT, &conntrack->status) so your change will only
> be active for unassured connections. Maybe you have a better idea for
> how to fix both cases.
>
> This patch has been tested by a user that reported the problem on irc
> and it fixes the problem for him. I'm also running it on a machine with
> lots of traffic and it fixes the problem for me as well.
>
> Please make sure something that fixes the problem is submitted fairly
> quickly.

I think your patch should  be submitted immediately. The introduced bug is
too bad to leave it linger on.

> <hint> A tcp-state/windowtracking testcase for nfsim would be great
> </hint> :)

Yep, I got Rusty's message as well :-) Time to dig out the initial tests
from the old cvs and convert them to nfsim with new cases added.

> --- linux-2.6.10-rc3-bk14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.orig	2004-12-30 19:48:33.000000000 +0100
> +++ linux-2.6.10-rc3-bk14/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-12-30 19:49:46.000000000 +0100
> @@ -906,7 +906,8 @@ static int tcp_packet(struct ip_conntrac
>  		if (index == TCP_RST_SET
>  		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
>  		         && conntrack->proto.tcp.last_index <= TCP_SYNACK_SET)
> -		        || conntrack->proto.tcp.last_index == TCP_ACK_SET)
> +		        || (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
> +			 && conntrack->proto.tcp.last_index == TCP_ACK_SET))
>  		    && after(ntohl(th->ack_seq),
>  		    	     conntrack->proto.tcp.last_seq)) {
>  			/* Ignore RST closing down invalid SYN or ACK
>

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
