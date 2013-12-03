From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] add hash:ip,mark data type to ipset
Date: Tue, 3 Dec 2013 20:15:37 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1312032006500.32285@blackhole.kfki.hu>
References: <1383146590-4626-1-git-send-email-vytas.dauksa@smoothwall.net> <alpine.DEB.2.10.1311112106200.8236@blackhole.kfki.hu> <CACUMwTmRbK=tMMNhGe3BmhS4Fm76njtDPE=ez8TvO0HHBJ-bww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:41533 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab3LCTPk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:15:40 -0500
In-Reply-To: <CACUMwTmRbK=tMMNhGe3BmhS4Fm76njtDPE=ez8TvO0HHBJ-bww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hy Vytas,

On Wed, 20 Nov 2013, Vytas Dauksa wrote:

> The intended use is similar to the ip:port type, but for protocols which don't use
> a predictable port number. Instead of port number it matches a firewall mark
> determined by a layer 7 filtering program like opendpi, which will be called
> by an earlier iptables rule.

OK, I see.
 
> I wasn't sure if it's best to set mark on individual entry within a set or for
> whole set with or without mask.
> What are your views on it? For now it's set on individual entries without mask.

I think mark value and mask pair per element would be more useful and 
flexible than a mark value alone. The "mark" match uses value[/mask], so 
the same should be used here too.

There's one thing I spotted in your patch, in both *_uadt function:

+       e.mark = htonl(nla_get_u32(tb[IPSET_ATTR_MARK]));

The value is passed in network order back and forth, so it should be at 
both places:

+       e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
