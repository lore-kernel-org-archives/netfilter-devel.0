Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858B8C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5733220748
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 14:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="DQ6qVbje"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgAPO74 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 09:59:56 -0500
Received: from kadath.azazel.net ([81.187.231.250]:40910 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgAPO74 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 09:59:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PV3rg730OLcqrqb4+xkJSLBrQPfu8KcYKvKs7H9+4BU=; b=DQ6qVbjetbI+2Aa2nSw4Zb/d5M
        ASDrGLTM1uULEkIJtA+Jp9QLhVsD0c6pH7FnX7lXcxp60EQkCqLgmoUzPezQrT5fb96u4ZaZaRj23
        vcMQ/DMfqLF74MEbo2QqFweuYWvt3P7ZAEF6lD0bG08VDOQEBo48E3/J/Cc45dkzzWVVtSdcyrviN
        qYAM3NYUpAmDjnqrDrXFzBArF175MEZSNIdTd70/mAl62bshkJMn3yzO7ujW2MuBS/7XmTQX9LD0+
        jVEKfgZ0si/dXi4Vu+gyG1MKoK3ROQlAnMcd5kISctQDzbEpWbwN/V3YRPZBXwTAHrT/L0iUCnqSL
        MOgv+LVQ==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1is6ck-0006ji-TP; Thu, 16 Jan 2020 14:59:54 +0000
Date:   Thu, 16 Jan 2020 14:59:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200116145954.GC18463@azazel.net>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116144833.jeshvfqvjpbl6fez@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="m51xatjYGsM+13rf"
Content-Disposition: inline
In-Reply-To: <20200116144833.jeshvfqvjpbl6fez@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--m51xatjYGsM+13rf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-16, at 15:48:33 +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 15, 2020 at 09:32:06PM +0000, Jeremy Sowden wrote:
> > The connmark xtables extension supports bit-shifts.  Add support for
> > shifts to nft_bitwise in order to allow nftables to do likewise,
> > e.g.:
> >
> >   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
> >   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
> >
> > Changes since v3:
> >
> >   * the length of shift values sent by nft may be less than
> >     sizeof(u32).
> >
> > Changes since v2:
> >
> >   * convert NFTA_BITWISE_DATA from u32 to nft_data;
> >   * add check that shift value is not too large;
> >   * use BITS_PER_TYPE to get the size of u32, rather than
> >     hard-coding it when evaluating shifts.
>
> Series applied, thanks.

Cheers. :) I'll update the userspace changes and send them out.

J.

--m51xatjYGsM+13rf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4gemcACgkQonv1GCHZ
79fvNAv/R4QeRfv4UHEJFaGiWVGPs3Ps7D95u4Z8yOW9AZMneicvgW1cV8Y+em5R
MnCB9hqrHQ/YYEq/Mk0GAfswU0FsGOkINREbia29AhcSaCjlfOOLhY8W0f8G6rR3
T4RVl4DLP6pm27lG65tIJbPGdzx8cdRY/ezU0CjeRAfyB06vfRzgtvJIVEwCEfHH
ZmhT3hx/UJxN8oQhQOFiaRt4uLd5L4TLIyWKSFdRtl5l722w8tL9cX4XpjIc/MEk
gWSxpbjTlLzXBjO0xaQ/p83dfmhgRoa35D8E0b9a6lKY1q3AqkZvPCijUmH2nK2j
UVjhpKMJqTMcyuHnCbiSAGJIi+0Graz4FKj+yCaXeYDPp6KY81CBps4bxu/qS2wh
b/qeEKSFuUcN+278O0n6DGnJEZYQnFWDX6c5KDl91/knsJbv9TCBdtbspInBtlsY
OD135HRo4Z121pLrgDgwz4SFVhRFUSw1VLfhpDtwMR54RADoxdEY0NUzAvkhwL8M
s4tYR931
=GiHU
-----END PGP SIGNATURE-----

--m51xatjYGsM+13rf--
