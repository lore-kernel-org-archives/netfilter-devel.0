Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E6DC77B7A
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 May 2023 03:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjEWDjU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 May 2023 23:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjEWDjT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 May 2023 23:39:19 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32DC90
        for <netfilter-devel@vger.kernel.org>; Mon, 22 May 2023 20:39:18 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-64d57cd373fso1742687b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 22 May 2023 20:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684813158; x=1687405158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfduLfzzALTs6djCg36DGWC8RWsqKCUao526gWmm09Y=;
        b=Ipf8MgpQ7iO2jgEM24LNBBUuKMWDXWvu6DqFbXL/X2zAwqTaqmBGBH4sP4fegpZ+mB
         gqc8pzvHLSDyXUPSNMerK10rVrAZaffWhTOD9j61LbpDfpKxNLjEg1Vif2jUXY2a1Aeq
         qtIgCU/Cfd8syZlW7kUXmEhjnnFMun+AkVmGWcwCbvdIOPB/rnpoLn1CrH/I8N7R0mSh
         +IjAY6p7HkIeLX5ZGK9PteGeEMxPtWN8w4IDkVBo93ThqMP700kDi1gs4m6mZL8H3bMZ
         8iL0OTMbvD9a3OhSxSK5ZaQelM3NJ4Ag7wMoeY2yBjYQ0wtWA8GvsEUbkSGxzlcDHlVG
         8VhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684813158; x=1687405158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PfduLfzzALTs6djCg36DGWC8RWsqKCUao526gWmm09Y=;
        b=BEjx+gkj3SvMHgmiQ9+3u9DJKortv3TUer/nKrCCoVtDja5J+h+Y3UIhoLkrlRPQGX
         tKAQKiyQp/TEqjEFnm4Iz3Ajr9g0SVGrNhWb05qDW0RvXGFrZIMtvAtVTVPR5M+OC/9l
         r0pImQR4KbuWCQbZ+ApIIG6FCsUuQJnn6wOye1eEuTujKKwKtRewzJzGYZ4Ks0UqwAv3
         mkYrQoR8CJOg35xt5GjeSiG8HYCdBokecOd5X0Wfeq6iuKWpBgDStKhE8dYQ4CegR23n
         /GSn+KSHsIZfzc/DwYpkrsUMUukhglH5WCwozMnim4vIGJxkZgzuGgefwjTfYXK1ZVep
         bb0A==
X-Gm-Message-State: AC+VfDxYSAoNMJOihUMmYfzkIV1OevaF9IwVg9PJYLmnvKF+znhmIkhx
        5Lo7FsiwLj9Fbx+edJKPAicZa60ZucQ=
X-Google-Smtp-Source: ACHHUZ7bL7pyaNP6+rP0HfdIyJIZupaJoIKRLRsYlxXmeGZyE9GyEqXHmCl5EFoD9WQ4OnC/RWJFqA==
X-Received: by 2002:a17:902:db86:b0:1a2:749:5f1a with SMTP id m6-20020a170902db8600b001a207495f1amr15425784pld.26.1684813158067;
        Mon, 22 May 2023 20:39:18 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-65.three.co.id. [180.214.232.65])
        by smtp.gmail.com with ESMTPSA id u5-20020a17090341c500b001aae909cfbbsm5555908ple.119.2023.05.22.20.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 20:39:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 1E2AD1069C6; Tue, 23 May 2023 10:39:15 +0700 (WIB)
Date:   Tue, 23 May 2023 10:39:14 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Cc:     "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: Re: New Linux kernel NetFilter flaw gives attackers root privileges
Message-ID: <ZGw1YnN6w8zhyPA6@debian.me>
References: <LSClKXeU0dZe8AaW7hr07tgKs3K_rte4VTbyw-3WKVu6f5XE1SCWqTPX75RlFMLHmAeic91tvkaXp0hKcmcE_-tAkmAaiAmUmSfibJzsq9k=@protonmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="28hfV/xOes+VnydE"
Content-Disposition: inline
In-Reply-To: <LSClKXeU0dZe8AaW7hr07tgKs3K_rte4VTbyw-3WKVu6f5XE1SCWqTPX75RlFMLHmAeic91tvkaXp0hKcmcE_-tAkmAaiAmUmSfibJzsq9k=@protonmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--28hfV/xOes+VnydE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 10, 2023 at 04:14:48PM +0000, Turritopsis Dohrnii Teo En Ming w=
rote:
> Article: New Linux kernel NetFilter flaw gives attackers root privileges
> Link: https://www.bleepingcomputer.com/news/security/new-linux-kernel-net=
filter-flaw-gives-attackers-root-privileges/

Should have been fixed in v6.3.2 and other recent stable kernels. Please
upgrade.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--28hfV/xOes+VnydE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZGw1XwAKCRD2uYlJVVFO
o2c8AP9em4ybczSlQzAt+993Z76VdTfnIf1Avqpyi8rjRfIkEQD/YB56IwvCy5ko
7psGuhb7215laWjQ+BJGXkq0UFYH7gE=
=eilT
-----END PGP SIGNATURE-----

--28hfV/xOes+VnydE--
