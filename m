From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] modification in current protocol helper API to handle
 error/unclean packets
Date: Mon, 21 Jun 2004 15:40:08 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0406211532380.31871-100000@blackhole.kfki.hu>
References: <20040621042046.GA17389@alpha.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040621042046.GA17389@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Willy,

On Mon, 21 Jun 2004, Willy Tarreau wrote:

> > This way, Jozsef could call unclean() here in his tcp-window-tracking
> > patch and we won't need to add protocol specific function to the core of
> > the conntrack system like icmp_error_track to handle special ICMP
> > messages. We could also check for unclean udp and icmp packets.
>
> There is something else I've been thinking about for a long time. In all
> my configs, I first match the packet against 'unclean' in the PREROUTING
> chain, and since I also use tcp_window-tracking, the check is performed
> twice (at least on TCP). Wouldn't it be interesting to put a flag somewhere
> on the packet being evaluated to mark it 'already checked', and that a few
> matches could set ? That way, we could avoid the same test being done twice.

The unclean match was removed from the 2.6 tree because nobody came up
with a configurable version with liberal default settings (hint, hint! :-)
Otherwise you're right and such optimization could easily be added.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
