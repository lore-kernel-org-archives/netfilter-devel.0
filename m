From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 21 Jun 2005 11:08:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506211100290.3687@blackhole.kfki.hu>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
	<20050621003441.GI8335@postel.suug.ch>
	<20050621003930.GJ8335@postel.suug.ch> <42B7B7D8.1050204@tac.ch>
	<42B7D6E9.5050703@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42B7D6E9.5050703@eurodev.net>
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

On Tue, 21 Jun 2005, Pablo Neira wrote:

> Roberto Nibali wrote:
> >>Almost forgot: the nf_reset() patch should "fix" this bug. "Fix"
> >>because it doesn't really fix it but rather hides this issue
> >>for a later possible revival.
> >
> > I thought so, however is there a clean fix which does not involve rewriting the
> > raw patch? I mean the unconditional nf_reset() is rather intrusive. What about
> > other netfilter extensions, they could have the same refcnt problem, couldn't they?
>
> I've started thinking that a better way to fix this would require to
> review current untracked logic.

At the very beginning NOTRACK worked by using a flag in nfcache. However
that required ugly conditions both in the conntrack and nat core.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
