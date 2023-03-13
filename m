Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE91FC61DA4
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Mar 2023 12:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCMMiO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Mar 2023 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCMMiN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2023 08:38:13 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2384BC67F
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2023 05:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=za4az5QABnpnPRUs2tfow5et6Jgp2NKamLXkLfVz0Vk=; b=CnVlvDi1GS49hK0s5udyI7nHOm
        MD51rw5w6MznauRnYmY4AF9LteW8VusZzNYvOoTxrzC3toQpyY8Pox3MM8axxVJt/i+gi+ovGRxy1
        n2rh4ShfBjALfLl1l7vRk8/tNzrGZPsaPoyrGsvhKiIgowSbmcHB7N4vhYheuL8Y6kZW4jfAy08we
        GDj5VO0QyTaSuHWDRpyEnlcADLDVDoazHv17HFLrj4PCFnxV8i9QJ9mQ7P0ERDtTnM7eR0z7NOI4Y
        +80BW/3CLHywFItfALCI6FiMy2JXc4aJIMR0wMTSdPapLqHsTp5XpRwS1UhoeIVr9IYStiukA6bpa
        lmj9jvrg==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbhRG-006nqp-9Y; Mon, 13 Mar 2023 12:38:06 +0000
Date:   Mon, 13 Mar 2023 12:38:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 0/9] Support for shifted port-ranges in NAT
Message-ID: <20230313123805.GJ226246@celephais.dreamlands>
References: <20230307233056.2681361-1-jeremy@azazel.net>
 <20230313114529.GA13787@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RwgbGIjGkqQkazFE"
Content-Disposition: inline
In-Reply-To: <20230313114529.GA13787@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--RwgbGIjGkqQkazFE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-13, at 12:45:29 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > Jeremy Sowden (9):
> >   netfilter: conntrack: fix typo
> >   netfilter: nat: fix indentation of function arguments
>=20
> These have been applied.

Thanks.

> Could you resend a series only consisting of:
>=20
> >   netfilter: nf_nat_redirect: use `struct nf_nat_range2` in ipv4 API
> >   netfilter: nft_masq: deduplicate eval call-backs
> >   netfilter: nft_redir: deduplicate eval call-backs
>=20
> These look ok for nf-next.  This way we won't block
> those patches until the "How to" wrt. shifted ranges are
> done.

Yup, no problem.

J.

--RwgbGIjGkqQkazFE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQPGSYACgkQKYasCr3x
BA0RoBAAwCJVhqLh0s8QgWpnl3aP7VnBhF3K7Aj49RLJvSuys3AuyFAidNE1xoto
Paw27qJoIurWxg6w3XxroM0y97hh860EJ3nQsoFPsDKIeTv5FmAH8BLc08GVglFH
d4kg6YpbiUYU4UU4vDlM+7VdKaOzrlgEbgnwZUwVnKzZLvn/VhTxcMa5HMEdfzPU
uju8YO3tLOntNhx6WwVtl4aiQJqzRkf7NAoILWwevgF+tZ25hcdNOTEbz1coeZr2
IaGWqedaGpunQ52+ByHfbzcCZNomadN7oDsP8TMlnQr4UkSut8SbxKRfw8dUUW2N
I1yWj34oZGknjwsIOi5uTCs5STrdrTznhSA/r4mQPhV14QvmtlsWkGB+gZpNVtgL
eMw+LZJziMcbXBTzJee0+jXvpWjp9otnuPPG4oVbEcwVEW8P/UcxY6lrSX5O79qE
BlaGyvx0Ex5bZwY/u5ikpmartjr3CIQsSiwi46zUIL1m/RSn/ybTml0yMcJX8vys
M4le7t269vTr9m1/RDbDSl+O2ZeehcdFyouXx3I7rQhDOGE1XwKT7mExG+tUMnO4
HZUEcCtrbTxwZueAP7yCmKO7mphFmxIUyJAIhm3zHk6pIWk8QZsbeisEJ2TbyCBG
dFoSQ+1Uu/yj8rzvKy2XBaAORWQi49RM7s0l/Ij/ciMYTV5RqWw=
=61tV
-----END PGP SIGNATURE-----

--RwgbGIjGkqQkazFE--
