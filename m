From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: NetFilter unclean modue in 2.6.x kernels
Date: Mon, 24 Jan 2005 11:53:19 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501241135100.6574@blackhole.kfki.hu>
References: <200501220013.56429.sov.rbsec@gmail.com>
	<20050121233328.GU14460@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0501240922370.6574@blackhole.kfki.hu>
	<41F4CC3F.7070505@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, "Oleg V. Sapon" <sov.rbsec@gmail.com>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41F4CC3F.7070505@eurodev.net>
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

On Mon, 24 Jan 2005, Pablo Neira wrote:

> >The port I created verifies the checksums as well, relying on hardware
> >checksums when possible.
>
> Hm, the error API makes sure that we don't start a session in the
> connection tracking with unclean packets (since kernel 2.6.6). So
> something like:
>
> iptables -m state INVALID -j ULOG
>
> should be enough to log evil packets.
>
> The checkings aren't so strict as those that the unclean module used to
> do but with a couple of patches I could tighten that. Actually I
> remember a discussion with Jozsef about this. As far as I can remember
> he didn't like so much the idea of putting half of the unclean module there.

The routines behind the error API perform just the very minimum checkings
to make sure the packets can be processed by conntrack(/NAT) sanely. But
that is all they are required to do, therefore I'd oppone to move other
checkings from the unclean module to the error functions. The purpose of
the conntrack subsytems is to keep track of the connections as perfectly
as possible and nothing more. It must not implement filtering functions ,
because it's the task delegated to the filter(/raw) table.

Ideally, I'd like to see setups like:

- drop malformed (unclean) packets in the raw table, as early as
  possible, so they don't hit conntrack at all
- keep track of connections and doing so rely on the results of the
  unclean macth (if exists) to avoid double checkings
- mangle/nat/filter

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
