From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 11:11:18 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1202241110180.14329@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu> <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu> <20120221145234.GB25826@1984> <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu> <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu> <20120223154646.GA4790@1984> <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu> <20120224012449.GA7005@1984> <1330065863.15610.46.camel@edumazet-laptop> <20120224100121.GB9127@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:43299 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab2BXKLU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:11:20 -0500
In-Reply-To: <20120224100121.GB9127@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 24 Feb 2012, Pablo Neira Ayuso wrote:

> On Fri, Feb 24, 2012 at 07:44:23AM +0100, Eric Dumazet wrote:
> > Le vendredi 24 f?vrier 2012 ? 02:24 +0100, Pablo Neira Ayuso a ?crit :
> > 
> > > BTW, nf_conntrack_alloc allocation can now be GFP_KERNEL.
> > 
> > Without looking at the code, I would say I doubt its doable ;)
> >
> > Input path is run from softirq handler.
> 
> This is ctnetlink, conntracks are always created from user context :)

I'm going to convert the gfp flags to GPP_KERNEL as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
