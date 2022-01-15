Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5B1C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jan 2022 16:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbiAOQ5M (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiAOQ5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 11:57:12 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED7CC061574
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jan 2022 08:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Sk2Uh+byYIE3eNFufT0nBEWexHNXSZXe8tl0847nM0U=; b=bsSzIbhcLi6vjNW110Veb0pF5P
        /1wVou1sI//AmLY8ffmIoF1hXIlOjsBJX5hrVjGulF1pNuV16jQjqu/T7WgTs4OqY1MZX9ZYwh0uU
        wVeqcbx70GMTvoHjppCGbZuoHLjxXttCaq0D9mBA3WWIdAA3TLKpmOw1IRyQgLy127+YaUxt5PzxH
        FUBtXO3bZ4T4+M1YWBMaYJK7AiuYAqVYpaZVU/0Tgj9zo55hXds6Ln0oNq3tw+MGlTBJkXuPQ60sH
        pYFSBc/a3ljWEsWLUjUELqqjtaH8gKEbaMe4nG021tXjVZxSLj2QOQqUwEjrtW00KbVFVDyV9kyIf
        z6oNzBcQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n8mMV-008MIx-B8; Sat, 15 Jan 2022 16:57:07 +0000
Date:   Sat, 15 Jan 2022 16:57:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 08/11] src: add a helper that returns a payload
 dependency for a particular base
Message-ID: <YeL84lhx/hxfGAg3@azazel.net>
References: <20211221193657.430866-1-jeremy@azazel.net>
 <20211221193657.430866-9-jeremy@azazel.net>
 <YeL62HGr/mHp37pe@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/htbjhg396N/C9aP"
Content-Disposition: inline
In-Reply-To: <YeL62HGr/mHp37pe@strlen.de>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--/htbjhg396N/C9aP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-15, at 17:48:24 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Currently, with only one base and dependency stored this is
> > superfluous, but it will become more useful when the next commit
> > adds support for storing a payload for every base.
>
> > +	dep = payload_dependency_get(ctx, PROTO_BASE_NETWORK_HDR)->expr;
>
> This new helper can return NULL, would you mind reworking this to add
> error checks here?

Yup.

> I've applied all patches up to this one.

Thanks.

J.

--/htbjhg396N/C9aP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmHi/NsACgkQKYasCr3x
BA2I0xAAsl6quU92hz6ZZKGup4w7oIUsM4bA7wbCm+29B0Jf25ghyLOhTHBjuYyH
P11vP63aN6OmtRJT17M9X1GExjVDdrpto5/xj1MCKEHGFVrxYuk96M4VBqihFwQG
9t0qBSaRwEmGAXkodmfrU/z/kaGq1teuXDTCnmrWum0X6YB3igAXt9KrvyADAmH1
UH+NOTB/1UxRTZVK2uakqC9nXnqHhSjk/ZyROld2KPF3I2FliYyTMC/Mc4QZGRb4
bgWBtMdmjVprYlFjzsU7QjwgShI9Zyr22J5YmNvEOkih+AxyTfNW+4hjLcZAIquw
kOKhIS7LtiOQ4PFJo4CxQi0RPkdgzr2dfU06PZMhturkvrKQa2GRzqoiKBgL4xQ/
KXzB2pyK5qSltpuQQb/EKCNoBYrY29ca+sw547r/8HLJDoL53kuKQrp4fi4ld33N
ER3kGohRXUcSBv1NT21cGwOOpGa9LgvTUEfj37IIDjEqJxqhPJG+ICy8XAxXP1Qc
8eOlAonorR3itGV0MdBCMB3fBmvQBscjyIy38tOKDidYC+grhpfoW/LYYp/h1w4y
a+BS6s/96G1bSW+kj76dWQiSdFvABqeS5TP2RmSaSjRX01b20fhVNt3O/sEPTRhm
J/sOqs+ERdLhDMSG51P3q58sXtN+09kdJLiBvx5cRxP2Vln/05M=
=waU4
-----END PGP SIGNATURE-----

--/htbjhg396N/C9aP--
