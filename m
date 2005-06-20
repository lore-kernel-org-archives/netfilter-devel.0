From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: SOLVED (was: Re: [PATCH] update raw patch in POM)
Date: Mon, 20 Jun 2005 13:01:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0506201259300.1602@blackhole.kfki.hu>
References: <42A57FC4.7010508@tac.ch> <42A5B144.3090005@tac.ch>
	<42A625DA.7090807@eurodev.net> <42A6AB19.2040106@tac.ch>
	<42A6E685.3060408@eurodev.net>
	<42AEF774.8060300@tac.ch> <42B67BEC.1090105@tac.ch>
	<42B69D68.3050507@tac.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
In-Reply-To: <42B69D68.3050507@tac.ch>
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

Hi Roberto,

On Mon, 20 Jun 2005, Roberto Nibali wrote:

> Looks like we have a winner:
>
> > Index: linux-2.4/net/ipv4/ip_output.c
> > ===================================================================
> > --- linux-2.4.orig/net/ipv4/ip_output.c	2005-06-08 00:16:54.000000000 +0200
> > +++ linux-2.4/net/ipv4/ip_output.c	2005-06-15 23:42:13.000000000 +0200
> > @@ -166,6 +166,8 @@
> >  	nf_debug_ip_finish_output2(skb);
> >  #endif /*CONFIG_NETFILTER_DEBUG*/
> >
> > +	nf_reset(skb);
> > +
> >  	if (hh) {
> >  		int hh_alen;
>
> This patch kind of did it. I cannot trigger the oops anymore (with the method
> described earlier in this thread) with this patch. It could be related to a
> recent fix that went in for 2.6.x kernel, by Patrick:
>
> https://lists.netfilter.org/pipermail/netfilter-devel/2005-March/018857.html

Please check out the thread
https://lists.netfilter.org/pipermail/netfilter-devel/2005-June/020019.html

There are problems with the pach above, alas :-(.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
