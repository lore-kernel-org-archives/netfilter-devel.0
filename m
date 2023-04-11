Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7364AC77B6F
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Apr 2023 12:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjDKMVr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Apr 2023 08:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKMVq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Apr 2023 08:21:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283CD1717
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Apr 2023 05:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A95OOuO+RYMSDv5PfthlJ1l/OKE+gq3yuuWkL5Z10U0=; b=nAy3jTx0+L18adR3kgBXzdYfff
        /o0ix7GlkaAUt8BrTxNVTdKW2EQyIeqIk5Si/cmUByOa6Fg9oeRcgRvE0Y0wAX5DQBClh/Vbw04+C
        ZLhAX1HxcaTlCAtEpRXDjthxBL9RzB3B2AZXbp+DjsWqJ/rnrjDD2wiAq1a6OfX41l09SzGanUFHy
        hkbhU5Gu8iXqz97w0vJfgEzDn3lbZrRcIrGR5dGai1dnScPrC6ISmNBnbDezzkOdv3JHcz2kiLNrA
        6I9Jg3rL5uQthSZ/1+5xIZhBVcKoPhjnxsse34+VeOh1/kYfcbTojgIS1xCYSYKcLEP1jhXheui9l
        jjGQgVHw==;
Received: from host86-133-13-230.range86-133.btcentralplus.com ([86.133.13.230] helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pmD0I-009Mrl-4T; Tue, 11 Apr 2023 13:21:42 +0100
Date:   Tue, 11 Apr 2023 13:21:40 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables 8/8] test: py: add tests for shifted nat
 port-ranges
Message-ID: <20230411122140.GA1279805@celephais.dreamlands>
References: <20230305101418.2233910-1-jeremy@azazel.net>
 <20230305101418.2233910-9-jeremy@azazel.net>
 <20230324225904.GB17250@breakpoint.cc>
 <ZCCtjm1rgpa5Z+Sr@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3SohApoRAIdr4HJw"
Content-Disposition: inline
In-Reply-To: <ZCCtjm1rgpa5Z+Sr@salvia>
X-SA-Exim-Connect-IP: 86.133.13.230
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--3SohApoRAIdr4HJw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2023-03-26, at 22:39:42 +0200, Pablo Neira Ayuso wrote:
> Jeremy, may I suggest you pick up on the bitwise _SREG2 support?  I
> will post a v4 with small updates for ("mark statement support for
> non-constant expression") tomorrow. Probably you don't need the new
> AND and OR operations for this? Only the a new _SREG2 to specify that
> input comes from non-constant?

Just to clarify, do you want just the `_SREG2` infrastructure from the
last patch series but without the new bitwise ops?  That is to say it
would be possible to send two operands to the kernel in registers, but
no use would be made of it (yet).  Or are you proposing to update the
existing mask-and-xor ops to send right hand operands via registers?

J.

--3SohApoRAIdr4HJw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQ1UMwACgkQKYasCr3x
BA2zqBAAl5DywZQvFB9p+fAtYerDCuNfPF2tlsJbWNYdfIUi+xnFcPHXIKN+wbxU
N6iMp21a70jRt6rPfqEuMKvnm5pMkcTItZEE4CQ4zkbgjfUVZkuHWHtaseDPssc8
uFOpNQx56UkqBUOpLLVgNReQZh/ZHLV50Ab/RfVCS2xyMHe7zHV+IG/HbEgyz8Vy
LUrbxxbXHOop0d117CPAF3GISHbkp7imgvg0123QXG8sB6p1MMvPminCfN4S37p+
RY0FBMvR5CT3YdCc3xXoCmWnC8W3IKvBJnDZfipwbf0xFGBoGR9tD9d+bBGFw4uF
vHyGZMCbXRKx3PLw9N29vVCywFztlfo+4mJcSl73gFX3ULmyfqnNk9u3g575CMrG
vGgqT4VJGaT42x7UNBEryFkfI84+1vXRfmYzBgmIc5/gVFeQJufI/7YvI6ZiEoqp
7/fRNzBCg/4TzycqYPvWsBjS3vxAWdBKiP7R9j3s2kMo/eSwULenBllnMEWsG5iG
R3Q+4yLuQsdTVMnRVGzd/bxa2uzVLmfVkEtj8VpSuiL6C+lT8dUayqjzTgrwqLQC
PLNE2PpH1aVDPPg1OWljQuHtLoOaFlnvQkeNwcNClq794ciLvRTGy+ZnokBHh2+C
+u/GyX8cxXvmWbUS6UMjKVe8eUltDge8CcacO9Cry3jkFDxh7n4=
=PBfE
-----END PGP SIGNATURE-----

--3SohApoRAIdr4HJw--
