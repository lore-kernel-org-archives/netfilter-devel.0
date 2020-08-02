Return-Path: <SRS0=Ke5S=BM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B82C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 16:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9133820738
	for <netfilter-devel@archiver.kernel.org>; Sun,  2 Aug 2020 16:48:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ndWondyU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgHBQsz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 Aug 2020 12:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHBQsz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Aug 2020 12:48:55 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB32AC06174A
        for <netfilter-devel@vger.kernel.org>; Sun,  2 Aug 2020 09:48:54 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id q128so902319qkd.2
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Aug 2020 09:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=m/OkVFSdsc8rrMHcC6Ah5ui12yATXkj3wCUaz7wUmoc=;
        b=ndWondyU0tlc/vyWPCfoNnc69H/HRPLWTebgVhemtGL7cNLPYevOZA4dNAvMNDG9iQ
         Gd2oqUutToAkT5vS6/R1ue+r18ayfvihOnVPNILSwgr+oy2HZ4g2o7IwHTSlf5n+OWhH
         Gu4iDAXAieNZEOkhj06Lxpvd8eLz9Ecpl66sGdJ4Up1s8YYki9cFX9/39yKpo5cW0OLR
         wou559cIr15XgfQPv4NwYJGwDE7L29MrsXaEg6TPyxNZlmGUPKc9bf4KcebyE69mf+t7
         B0nVdxO5sq08z6nSgRzcm/qFFAQoE5znABff30Tlow3pRzWsmA1CJmaXZSNxs6fWXrkT
         yjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=m/OkVFSdsc8rrMHcC6Ah5ui12yATXkj3wCUaz7wUmoc=;
        b=SsyVj8z2Et0BgEJxIrCTRhhM3V4SBsjWImwehba16TYG6Rh+hjux3FUXqgah+b7aFG
         HYGyXfKuurzmVv+n+dsjRtLzQUa/7JJ/JBM6vw1KCxoIIg4skhbvDRiHnICyRPsyVtCH
         Hpck9zIY1a+J7wnZUHh8kucStp9uhYXWrjWZnVtrxviZO/DvyH4MTIBdWOSudpaWkihQ
         DCKf1fxl+Ftrg+h6C6ke8jj/JYHFPu6krN7TkjUP2RWMY0ukWAaHuqJc/PY0K/AsGSLR
         Hkr97mTW0QkjoGCQiM65X0vq44A5If0LaJzM942wh3+TOeYTDI1q3VZ0djxxbf8r07O1
         7Meg==
X-Gm-Message-State: AOAM5323s9xM8b+GZdkMsslmFbqGmUbH07CULHMlpWUweISAXHSagGGF
        jENreHWCvwBPO94yS/vgO5xTCb4Q9a8=
X-Google-Smtp-Source: ABdhPJwsuL2gvliroM2dr/QupFgUiih8hU2yl+XsPRySwwtlzpoFn+ZBuLAp9cZkqfpaneXE1PdglA==
X-Received: by 2002:a05:620a:153c:: with SMTP id n28mr13322877qkk.285.1596386933753;
        Sun, 02 Aug 2020 09:48:53 -0700 (PDT)
Received: from [127.0.0.1] ([66.115.173.166])
        by smtp.gmail.com with ESMTPSA id y9sm18717299qka.0.2020.08.02.09.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 09:48:52 -0700 (PDT)
Subject: Re: [PATCH nf] netfilter: nft_meta: fix iifgroup matching
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20200802012703.15135-1-fw@strlen.de>
 <20200802014923.GA22080@salvia>
From:   "Demi M. Obenour" <demiobenour@gmail.com>
Message-ID: <f3eddad5-b96c-28d3-d2c5-79960ddd6cd9@gmail.com>
Date:   Sun, 2 Aug 2020 12:48:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200802014923.GA22080@salvia>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VVoQi4SZOVOWxW2rXSir3FcmCFF6e8oEv"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VVoQi4SZOVOWxW2rXSir3FcmCFF6e8oEv
Content-Type: multipart/mixed; boundary="UMRl5sKNV4rxjS0xieYyX1MBxPXTpSTmV";
 protected-headers="v1"
From: "Demi M. Obenour" <demiobenour@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <f3eddad5-b96c-28d3-d2c5-79960ddd6cd9@gmail.com>
Subject: Re: [PATCH nf] netfilter: nft_meta: fix iifgroup matching
References: <20200802012703.15135-1-fw@strlen.de>
 <20200802014923.GA22080@salvia>
In-Reply-To: <20200802014923.GA22080@salvia>

--UMRl5sKNV4rxjS0xieYyX1MBxPXTpSTmV
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-01 21:49, Pablo Neira Ayuso wrote:
> On Sun, Aug 02, 2020 at 03:27:03AM +0200, Florian Westphal wrote:
>> iifgroup matching errounously checks the output interface.
>=20
> Applied, thanks.

Would you mind also marking this for backport to 5.7?

Thank you,

Demi


--UMRl5sKNV4rxjS0xieYyX1MBxPXTpSTmV--

--VVoQi4SZOVOWxW2rXSir3FcmCFF6e8oEv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAl8m7nIACgkQsoi1X/+c
IsFE/Q/+LDGzjFRUG+Q9ii3M2aIFyWH+6q/e5TeJysenFW+Dcl1W8/N3rllpv/lm
N2OWMULpyUWDBg23Lo642g1d1iv+MNBx4nn9FdP7xO2/YGGBuwjneAEDGsJKm/NL
Ta4qGuPhBK1UakHzGpZVDW4iKfhXA1VCohujE7IHTprnctyH7OHQMK75ZcR6QTWJ
4N+4jbBLCC1E2WNBddM46hiEM0DDEbMrhqValpp8U+Ph/keBf+ez7Id93R3oqAZc
WoEQwl7zLOy0ib+G41kFhIKp7ntDR9BDUDs0h6zn/J9rUbI0tgyhNLraK2zY8dZV
dEV3Kt2CY60cmrN6sYOMkpLSXSAZVkld0ZB6VVGHIfNHP8QfRh2Jh4A3uoYOIWPJ
LjM3pw8rXcrvQQGOp2cArtEbpUAHU8ODGiNRBpuxmv0Xfed7pww9HzP5d8Jlu40d
wYtBfYcvzyQ2g63ZHIoWjTIOJ1GouHI3zQS0n1dijBlEkGiH+NdVJoME2Ep/ONwH
iSMgXz5DW05cTWaTI/uuf0GKE8pPI40ALHALFMttFymdaX7PkkmcuKDeaVPcBjn5
gakx2g10lvZbSd0BiQJOmiWbY5lajUIIXGP7J82Sbw0XX58nS2K2+kY1o9A1CV8w
81Xfpv6Wn2upA9isVmElcUBw6/poyAqUakC4wcLv9Zv/tMwV9+M=
=KEV4
-----END PGP SIGNATURE-----

--VVoQi4SZOVOWxW2rXSir3FcmCFF6e8oEv--
