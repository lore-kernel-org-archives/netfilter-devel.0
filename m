From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 11:01:21 +0100
Message-ID: <20120224100121.GB9127@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20120221145234.GB25826@1984>
 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
 <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
 <20120223154646.GA4790@1984>
 <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
 <20120224012449.GA7005@1984>
 <1330065863.15610.46.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40837 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756720Ab2BXKBX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:01:23 -0500
Content-Disposition: inline
In-Reply-To: <1330065863.15610.46.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 24, 2012 at 07:44:23AM +0100, Eric Dumazet wrote:
> Le vendredi 24 f=E9vrier 2012 =E0 02:24 +0100, Pablo Neira Ayuso a =E9=
crit :
>=20
> > BTW, nf_conntrack_alloc allocation can now be GFP_KERNEL.
> >=20
>=20
> Without looking at the code, I would say I doubt its doable ;)
>
> Input path is run from softirq handler.

This is ctnetlink, conntracks are always created from user context :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
