Return-Path: <SRS0=QWtc=XC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19CEC43331
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 19:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FFA320854
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 19:17:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="cuGMRLQP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfIGTRH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Sep 2019 15:17:07 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43616 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbfIGTRH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Sep 2019 15:17:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=esO6nQYtt81+xRy1GsMViAAlCStz+KS0plh6tpK/A/g=; b=cuGMRLQP5j5CIPMCHIXdy6tEN2
        eFyO8DeAaD+vu820nBmC4myha/cPY7a72UvXM/bM/Pg2w8cSCCAZJCW5qS0tTcagRraq6lG0LMq6I
        W1D/SxIFxuUH3f8dlMf7bmHHRWKMw2+72V74Bt3hHLEz+f8GRQg0lIFLGWh34uY/smxYeIi6FUGIM
        3Nt88qc6RJDDmCfqNbCcIrr0QVhq9cKzXCttzbBMadkpoJPpv+2iLe/MIfnYIAGm6uiOadUfXC20g
        N9eYuNOOgauTv/Gq60xl9T0OAIkZsuh0JCZ6pQLctCyv0FVPKBDQt0+vEDZrtLzWCd3WmaaExnA8t
        yvhWQRWg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i6gCi-0002ov-C3; Sat, 07 Sep 2019 20:17:00 +0100
Date:   Sat, 7 Sep 2019 20:16:59 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 00/30] Add config option checks to netfilter
 headers.
Message-ID: <20190907191658.GA6508@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
 <20190904190535.7dslwytvpff567mt@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20190904190535.7dslwytvpff567mt@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-04, at 21:05:35 +0200, Pablo Neira Ayuso wrote:
> Thanks for working on this.

Happy to help.

> Could you squash a few of these patches to get a smaller patchset?

Absolutely.

> My suggestions:
>
> * Squash 01/30, 02/30 and 03/30, call this something like: "netfilter:
>   add missing include guard". Just document that the chunk for the
>   flowtable is fixing up a comment.

Will do.

> * For 04/30, since this is about SPDX, I would suggest you leave this
>   behind and we wait for someone to make a whole pass over the
>   netfilter headers to check for missing SPDX tags? Not a deal
>   breaker, you can keep it in this batch if you like.

Will drop it.  This was a bit speculative: I think I've got it right,
but, as you say, this may be one to leave to someone with more
expertise.

> * Squash 05/30, 06/30 and 07/30, call this I'd suggest: "netfilter:
>   fix coding style errors", document the stray semi-colons, the
>   Kconfig missing indent and the trailing whitespaces.

Will do.

> * Squash 09/30, 10/30, 11/30, 12/30 and 12/30. They all refer to
>   #include updates, could you squash and document these updates?

Will do.

> * 14/30, "netfilter: remove superfluous header" I'd suggest you rename
>   this to "netfilter: remove nf_conntrack_icmpv6.h header".

Will do.

> * 17/30 I don't think struct nf_bridge_frag_data qualifies for the
>   global netfilter.h header.

What about netfilter_bridge.h?

> * Please, squash 21/30 and 22/30.

Will do.

> * With 20/30 gets more ifdef pollution to optimize a case where kernel
>   is compiled without this trackers. I would prefer you keep this
>   back.
>
> * 24/30 nft_set_pktinfo_ipv6_validate() definition already
>   deals with this in the right way.
>
> * 25/30 nf_conntrack_zones_common.h only makes sense if NF_CONNTRACK
>   is enabled, I don't understand.
>
> * 27/30 identation is not correct, not using tabs.
>
> * 26/30 is adding more #ifdef CONFIG_NETFILTER to the netfilter.h
>   header. They make sense to make this new infra to compile headers,
>   but from developer perspective is confusing.
>
> * 30/30 very similar to 26/30...

As I mentioned in the cover-letter the idea behind my approach was to
config out as much code as possible: if header H is only required when
config C is enabled, then wrap it in an `#if IS_ENABLED(CONFIG_C)`.
However, you're clearly not keen, and, having had a poke around in other
headers that have been moved off the blacklist, I've come to the con-
clusion that it was the wrong way to go: we want less #ifdeffery, not
more.  Will rework this part of the series.

J.

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl10AiEACgkQ0Z7UzfnX
9sOG1w/9HAFIMx/1W7NoXCEiOyBbdgz6gesxgWT0q3vwjGTTNd0VIPpuJLoXFB86
6ZPYsu1Dq4UR5mQBFDdCPblJdgQjw5L+Vbm1CTkmmFacadjUnJGDnDTTROfoV2U7
7/fUzat9WA3oVtRgG4DVLelTk409jJO4U9zGWZ7NDpZLGa+8ifc11H4SMhBzssr8
6NX1kKMBMw0Q1kzJE1/KmzIy6hZ/a1ltM7xulh0KPdVWtETwfh65tTlYTP3x4AJq
z5/Q0u+PFGJU4+Jbel/vKLV7lcOsCga/g58WTGN8EgJUExd4ZtYU2FJUmoueKr/G
MP0RHg/RMZJtAulzps3RGyQYpgVUSZttk1Ml5R6T3vvmndLdyl5H+c9TYH17MY6Z
yRHlAYwzoSCFdeTpmkmMIo6QU4F6pXa4XaXYWQq/k90w9f5b+kbu8MWdruoGGA59
pG4u7NtAlcakde5+UiVl2sru81w3X8ItwO5LeYy51vAb2H4gvSjMCFqixsS6nhA3
IVa/YsKFJmG/KpJMgiGcHEA+RwKKk4+gAztWVBhJZmqGQMYYYyplgY7+i5QRtQXH
CqkGB+bunNRLv9x+ctIprbfF04luzrjkT4DbSTEi+wzRQn90X/rxCeIB4p7Pzjo/
P2aiVpWwXE/RIuEtqXGOStzCxl9jebpTki9e8ZhlIJUedrq9TQs=
=qHxY
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
