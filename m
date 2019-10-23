Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A81C9CA9EB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 15:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419972086D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 15:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="QsCPmG7N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391026AbfJWP6d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 11:58:33 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44068 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390259AbfJWP6d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 11:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gxN6w4qs9iOY+VKqIaQYhtsdhg64EIoMs1ljLHC+TZ4=; b=QsCPmG7No0W7WlKj9p5gnBN+/Q
        FtE3EQo+dLcSykN71kD3qng8ZsH6LIxOomnfDaRaMVOHOZ3yfOLYa58Bc2NaI5krym/sa7ljCfcOJ
        DnvR9caS4TV1iHQbNpsb1E16e4/GeO9xgmd55/eQNr+FRqHwutTG3h4568m/CNndAuflQrPU3j7zz
        vLdQyheDj57iyO5CiCFJ0kqx5GzP/4quw2fs/pRwVgdUtXsXijQY0tl93efmAveKTTDi6WoEmNmpE
        9hQablo6ainsxfptSwU3UR3IxAiyfNRi0ZsN1WBqHcVATSRNvlOVPS2Wd9HOsCGkavpzd4ZPU3Pm4
        BlzW3QOw==;
Received: from pnakotus.dreamlands ([192.168.96.5] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iNJ1n-0000z2-NZ; Wed, 23 Oct 2019 16:58:27 +0100
Date:   Wed, 23 Oct 2019 16:58:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnfnetlink 1/1] src: Minimally resurrect doxygen
 documentation
Message-ID: <20191023155827.GA5267@azazel.net>
References: <20191014020223.21757-1-duncan_roe@optusnet.com.au>
 <20191014020223.21757-2-duncan_roe@optusnet.com.au>
 <20191023111346.4xoujsy6h2j7cv6y@salvia>
 <20191023151205.GA5848@dimstar.local.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20191023151205.GA5848@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.5
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-10-24, at 02:12:05 +1100, Duncan Roe wrote:
> Just this morning I was going to get back into libnetfilter_queue
> documentation, starting with the other 2 verdict helpers.
>
> But I ran into a conundrum with nfq_nlmsg_verdict_put_mark (the one I
> didn't use). It's a 1-liner (in src/nlmsg.c):
>
> > 56  mnl_attr_put_u32(nlh, NFQA_MARK, htonl(mark));
>
> But examples/nf-queue.c has an example to set the connmark which
> doesn't use nfq_nlmsg_verdict_put_mark()
>
> Instead it has this line:
>
> > 52  mnl_attr_put_u32(nlh, CTA_MARK, htonl(42));
>
> The trouble is, NFQA_MARK *is different from* CTA_MARK. NFQA_MARK is
> 3, while CTA_MARK is 8.
>
> At this point, I felt I did not understand the software well enough to
> be able to document it further. If you could shed some light on this
> apparent disrcepancy, it might restore my self-confidence sufficiently
> that I can continue documenting.

`NFQA_MARK` is used for setting the `nfmark`; `CTA_MARK` is used for
setting the `ctmark`.  Here are the relevant stanzas from the NF
Kconfig:

  config NETFILTER_XT_MARK
    tristate 'nfmark target and match support'
    default m if NETFILTER_ADVANCED=n
    ---help---
    This option adds the "MARK" target and "mark" match.

    Netfilter mark matching allows you to match packets based on the
    "nfmark" value in the packet.
    The target allows you to create rules in the "mangle" table which
    alter the netfilter mark (nfmark) field associated with the packet.

    Prior to routing, the nfmark can influence the routing method and
    can also be used by other subsystems to change their behavior.

  config NETFILTER_XT_CONNMARK
    tristate 'ctmark target and match support'
    depends on NF_CONNTRACK
    depends on NETFILTER_ADVANCED
    select NF_CONNTRACK_MARK
    ---help---
    This option adds the "CONNMARK" target and "connmark" match.

    Netfilter allows you to store a mark value per connection (a.k.a.
    ctmark), similarly to the packet mark (nfmark). Using this target
    and match, you can set and match on this mark.

`nfq_nlmsg_verdict_put_mark` sets an `nfmark` whereas the example is
setting a `ctmark`.

J.

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2weJYACgkQ0Z7UzfnX
9sMvKxAAwvGQdiPbuR+qUVvxfkv76XQVwAM87bzhfFKb0/RGYpjqhjz1VV2w+vBd
eanA1p6J0hNsFGbtvmcGYykL762aqtI7FZy7la+gjjW/6Wdrkmx+d6MRGmz+Z62o
sCPLyKKYqbpmjRUVQEZP8pEduU0TXHpbjgyHyQEGt1LqJqBgRDslb7V0wv/Bd8Ez
zbTHwJrtOlm41all1rxY03V9jBs55DsFFZ2FSq1YRZFr3cDxLQrUk6hml5OFB5GI
IEjcspScRy3nYoA35dnqO4M5z8mcCfg37Seh70DMuBgo8sEqSZGlZrTQBU4QW829
LJGNVCZ/F17r7ituFHIzwgBBikXl5e2ZJjWeEJTXUgHZ5TI8Hp4749/SNeUbRLtK
bf0u0thXkIBiGSJEaDVDIJ1jGV6sPilFNj8sxKWGyVQSq7sHtCpacIhxl3Gtq5Mf
OfZvLqohrE5UGUtmI62WFIVPwhNn1wTyUXnfG5aOW8v/AHa/2l1pZyl2VwX9I8Nk
6rOgZxA4S1zlsxS89sXogVKyocGzYDfsnfs+sUQ8J0oCXh+WXjP0smTQLWcDOx2O
kiqCaLBIlpC/UcgmgsGrL4o9HL0TZoTwwLdw5sarN9rpJ/4UhKMkRIkvLEaRWZzQ
R4r4lc0K2sMtQ4XofQoeqqIuMGkkr8eWwrbaFn3+tyUeetrzSbE=
=n5JW
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
