From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 07:44:23 +0100
Message-ID: <1330065863.15610.46.camel@edumazet-laptop>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
	 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
	 <20120221145234.GB25826@1984>
	 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
	 <20120223101250.GA3547@1984>
	 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
	 <20120223154646.GA4790@1984>
	 <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
	 <20120224012449.GA7005@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2BXGod (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 01:44:33 -0500
Received: by wgbdt10 with SMTP id dt10so1764419wgb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2012 22:44:32 -0800 (PST)
In-Reply-To: <20120224012449.GA7005@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 24 f=C3=A9vrier 2012 =C3=A0 02:24 +0100, Pablo Neira Ayuso =
a =C3=A9crit :

> BTW, nf_conntrack_alloc allocation can now be GFP_KERNEL.
>=20

Without looking at the code, I would say I doubt its doable ;)

Input path is run from softirq handler.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
