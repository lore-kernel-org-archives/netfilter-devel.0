From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Mon, 14 Dec 2015 22:21:26 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1512142220280.32166@blackhole.kfki.hu>
References: <566C0E75.6080800@familie-kuntze.de> <566c4622.936d810a.ece67.ffffdfc9@mx.google.com> <20151212232044.GE12854@breakpoint.cc> <566cae67.86f60d0a.f3ad2.2638@mx.google.com> <alpine.LSU.2.20.1512130032300.32038@nerf40.vanv.qr>
 <566cb640.46dc0d0a.5c3cc.287a@mx.google.com> <alpine.LSU.2.20.1512130124180.832@nerf40.vanv.qr> <566cbcbe.01ed0d0a.36f37.2c88@mx.google.com> <alpine.LSU.2.20.1512130135350.32160@nerf40.vanv.qr> <alpine.DEB.2.10.1512142140550.31836@blackhole.kfki.hu>
 <20151214205556.GA2927@salvia> <alpine.DEB.2.10.1512142215460.32166@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@inai.de>,
	=?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Noel Kuntze <noel@familie-kuntze.de>,
	=?ISO-8859-15?Q?Remzi_AKY=DCZ?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:37752 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbbLNVV1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 16:21:27 -0500
In-Reply-To: <alpine.DEB.2.10.1512142215460.32166@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 14 Dec 2015, Jozsef Kadlecsik wrote:

> On Mon, 14 Dec 2015, Pablo Neira Ayuso wrote:
> 
> > On Mon, Dec 14, 2015 at 09:47:31PM +0100, Jozsef Kadlecsik wrote:
> > > diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> > > index a355841..a1dfd23 100644
> > > --- a/net/ipv4/netfilter/Kconfig
> > > +++ b/net/ipv4/netfilter/Kconfig
> > > @@ -12,6 +12,7 @@ config NF_DEFRAG_IPV4
> > >  config NF_CONNTRACK_IPV4
> > >         tristate "IPv4 connection tracking support (required for NAT)"
> > >         depends on NF_CONNTRACK
> > > +       default NETFILTER_XT_MATCH_CONNTRACK
> > 
> > I know of some people already giving a try to compiling nftables only
> > kernels, I think this would create an unnecessary dependency.
> > 
> > >         default m if NETFILTER_ADVANCED=n
> > >         select NF_DEFRAG_IPV4
> > >         ---help---
> 
> It don't see why would it be a dependency for nftables only kernels. In 
> that case NETFILTER_XT_MATCH_CONNTRACK is set to "n", so the default would 
> be the same as currently and just right.

Hmmm, the default would remain the same but wouldn't be right for 
nftables...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
