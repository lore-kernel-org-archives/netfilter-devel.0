Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476C0C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244040AbiAFVAQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbiAFVAQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:00:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CCAC061245
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fgJbugVlXZEsdIl48cvmhARBTU7RH5lkQ2hmcuGqt3c=; b=lX03w+zjkPS7px6awbtuC1jMaJ
        S8Q1Rj3HHH7l+SI5JMyIBabG0NWOm2QXnQxIrluOySkkHc6BLS5z+h8DZbmuP2LoyQeJdtttM5dNv
        uJpD2veH8P7eifo1m1QcanBs44xYSK1wiYmonmJJgufvqsByZb885hXqXO/Kbboss0zFTbB75OKa0
        i0CKlrxEYiR4KuORNsbz12QmzIN7Pon0mMVpikrSI0ozN4InMvhdCmJqqbpkaXg/uggd5v0wrxpEF
        Pv9chaW5UWeUdGLMYjLiTHyWgnroxqkp4Q+Ay7lqGJJEfZNjE4mmvndwyl8FuerMIHiYCIDuxZPgt
        p/GWj9MQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5Zrp-00H0JN-2J; Thu, 06 Jan 2022 21:00:13 +0000
Date:   Thu, 6 Jan 2022 21:00:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v4 00/32] Fixes for compiler warnings
Message-ID: <YddYW58sBFSs8S87@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
 <Ya6MyhseW80+w0FY@salvia>
 <YdM8BYK5U+CMU+ow@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gb6VBQ/I/O6cBuvo"
Content-Disposition: inline
In-Reply-To: <YdM8BYK5U+CMU+ow@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--gb6VBQ/I/O6cBuvo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-03, at 19:10:13 +0100, Pablo Neira Ayuso wrote:
> Anyway, after this update it's probably better to look at using
> pkg-config in the build system.

Thought I'd already done this.  Hadn't posted the patches.  Will do
that shortly.

J.

--gb6VBQ/I/O6cBuvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHXWFUACgkQKYasCr3x
BA1EtA//eii/TyJJqq6Ern97sy+ttz1hXSzSka+f123wrd1VMf/LJRn67ZUhh+6z
Mqe23ixt09m98no5rt0U0LUtyY96yNmtBOP34LH3oPP62ku1hDKLNMi4xWV6i48z
0j9VHzYzk8iNhnRMW8EY8Oy3lbrtbWXJ14bigHW91u/8gSSUHcUFxxaIhSbMi0OF
AnMe1Mi0Cidsgga6MUPjuQcH68wSoQqDhE0tkQ6Xg/Kl4m+8BGOQzZzA/pFU3CcE
yyJGsyGpONjiWED4XLAsoXF7tXn7/MN3qza8p0RwqmHKCZ/8B2wRs/+8gDx23vbF
hrf7ReXSo0qtsCQHMHZ1wvq0Bfrq3Y/9+ETmbjxWZNUGc1w+0IFsSJ7aIyraVxLC
s5rqIgSgQnFm5EeL0ZjWl49VBZnvfOJbTGJCdzYGhpnx0T+/BMaM4evXD1Uz5oo1
cP2OJy96er0QoDSKcyW89W5HP/zHIoVzxWIGOIu+ue+2ahVyFHCUqFnxUynavHlI
zPqGK9A/swAhpXb7N+W/DgKMS0dvelvrgblMpMRfDIJFXHr5521FXGXBzd43uk8A
W/nzP9ijRUr9gdF0cCJFfv6llndquolxwBDKlmuwcFqW00RDZmdmTuj835ikmsZB
xR2RxPGPvSg9etrLkTjpaaV6qJcsEZN1KHtyFNHfJTijf/oKmsw=
=AcX0
-----END PGP SIGNATURE-----

--gb6VBQ/I/O6cBuvo--
