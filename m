From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Possible problem with tcp-window-tracking
Date: Mon, 21 Jun 2004 21:12:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406212105040.1107-100000@blackhole.kfki.hu>
References: <1087843783.10514.5.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1087843783.10514.5.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

On Mon, 21 Jun 2004, Martin Josefsson wrote:

> I seem to have a small problem with the window-handling in
> tcp-window-tracking.

There has been a lot of traffic pumped trough the code but there can be
dark corners. Therefore we need active testers in wide variety of
environments.

> I see cases where it thinks ACK from my machine is over the upper bound
> and SEQ from the remote host is over the upper bound.
>
> I've seen it mostly on irc connections, in other words, long lived
> connections.
[...]
> Now I've started a tcpdump to see what really happens when it complains.
> Hopefully I'll have something more substantial that this report soon.

Yes, that is required to track down who's faulty where: log from the
kernel and a full tcpdump of the traffic. There is no need to capture
whole packets if diskspace is critical, full IP/TCP headers are
sufficient.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
