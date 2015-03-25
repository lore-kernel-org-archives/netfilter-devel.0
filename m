From: Simon Horman <horms@verge.net.au>
Subject: Re: #include <net/ip_vs.h> without CONFIG_IP_VS (error: 'struct net'
 has no member named 'ipvs')
Date: Wed, 25 Mar 2015 10:02:20 +0900
Message-ID: <20150325010220.GB1767@verge.net.au>
References: <CACna6rzvfCZfPrW5qSihJWPSTXzvz4WXkzk_GqqqBUpdxaDT=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	JunweiZhang <junwei.zhang@6wind.com>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Julian Anastasov <ja@ssi.bg>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:39112 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbbCYBCX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 21:02:23 -0400
Content-Disposition: inline
In-Reply-To: <CACna6rzvfCZfPrW5qSihJWPSTXzvz4WXkzk_GqqqBUpdxaDT=g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 24, 2015 at 07:02:25PM +0100, Rafa=C5=82 Mi=C5=82ecki wrote=
:
> Hello,
>=20
> In my out-of-tree code I used to include include/net/ip_vs.h just to
> make use of a trivial helper ip_vs_check_diff4. I wasn't really using
> anything from net/netfilter/ipvs/ip_vs*.c.
>=20
> Starting with kernel 3.11 I'm getting this error when compiling my mo=
dule:
> include/net/ip_vs.h: In function 'net_ipvs':
> include/net/ip_vs.h:35:12: error: 'struct net' has no member named 'i=
pvs'
>=20
> This is caused by the commit 8b4d14d8eb36874daf159d33dcccd4746a6f3189
> netns: exclude ipvs from struct net when IPVS disabled
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D8b4d14d8eb36874daf159d33dcccd4746a6f3189
>=20
> I was thinking that including any Linux header should be safe, no
> matter what kernel configuration is used. Am I correct about this?
>=20
> Should net_ipvs from include/net/ip_vs.h be fixed to e.g. return NULL
> if CONFIG_IP_VS isn't enabled?

That seems like a reasonable solution to me.

Would you care to propose a patch that notes the following:

=46ixes: 8b4d14d8eb368 ("netns: exclude ipvs from struct net when IPVS =
disabled")
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
