From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Thu, 16 Feb 2006 09:47:57 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43F438F5.8070607@trash.net>
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

On Thu, 16 Feb 2006, Patrick McHardy wrote:

> Harald Welte wrote:
> > On Mon, Feb 13, 2006 at 03:41:52AM +0100, Pablo Neira Ayuso wrote:
> >
> >>[NF_CONNTRACK] first conntrack ID must be 1 not 2
> >>
> >>The first conntrack ID must be 1. If a new conntrack is created, the
> >>general ID counter must be post-incremented instead pre-incremented
> >>since [ip|nf]_conntrack_next_id is initialized to 1. Same applies for
> >>expectations.
> >
> >
> > looks clean to me.  Interesting question though: Does it matter whether
> > we start with 1 or 2?  Am I missing something?
>
> Its irrelevant since the number doesn't have any meaning beyond beeing
> an identifier. Anyway, I'd prefer a patch that just removes the
> initialization to 1.

Couldn't the id be simply equal to the jiffies when creating the conntrack
entry? (And adding time_after/before when comparing ids, of course.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
