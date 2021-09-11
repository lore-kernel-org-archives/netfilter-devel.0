Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4E92C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Sep 2021 11:01:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B1D61206
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Sep 2021 11:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhIKLCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Sep 2021 07:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbhIKLCR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Sep 2021 07:02:17 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FF3C061574
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Sep 2021 04:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a27NT9+dJDVLJ6ARKAJtJAXJ0Kbu+2qBXavCPvUsxLY=; b=aGKXGxonFBWs3i/Ep9CE6TfXGn
        O41nHUlNZfQjYzVwAYpRwgHcevhj9vwfeduqCfZGGattVfyZbAPycDqLmRw1roU5mFr1kPJKaNbs8
        ZmR36OmGgf/kvePHg0bRTjklTKA/9T6Z7wNNDzxIVB0l6w96D7A1w0+gola1GvWQ19PB1hJEnHhP7
        6nd3oJiAb360R3tdcYtkk7ib+vkfyoc9LeCijVg5e4D+7ElQHxy3H15541sUB/tqo4XpruvEtACnj
        Q5Nm/I3d9vHgBc3wDeEwWwjyuMcZ3UCw4xbUq1IoBTd6ys64wQcW/rbRgjaNuzSEWPkLizGNIgNxu
        8HmNON5A==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mP0kl-00E5dF-0i; Sat, 11 Sep 2021 12:00:59 +0100
Date:   Sat, 11 Sep 2021 12:00:57 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     kaskada@email.cz
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: module ipp2p (xtables) for ip6tables? No such file or
 directory...
Message-ID: <YTyMactVnbgb5rRP@azazel.net>
References: <Tj.aVNM.6d2PRLDYSwa.1XEziN@seznam.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gMZPGv83XdEON5JR"
Content-Disposition: inline
In-Reply-To: <Tj.aVNM.6d2PRLDYSwa.1XEziN@seznam.cz>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--gMZPGv83XdEON5JR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-09-11, at 00:24:23 +0200, kaskada@email.cz wrote:
> I`m trying to use this ip6tables rule (similar I`m used to use in
> iptables):
>
> ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT
>
> But I get only this error:
>
> ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such file or directory
> Try `ip6tables -h' or 'ip6tables --help' for more information.
>
> I`m running pkg-xtables-addons-debian-3.18-1 (compiled from sources)
> on Debian 10 and iptables variant works as expected:
> iptables -m ipp2p --help
> iptables v1.8.4
> Usage: iptables -[ACD] chain rule-specification [options]
> ...
>
> What am I doing wrong, please? Or it seems ip6tables are not supported
> by ipp2p module?

ipp2p is only implemented for IPv4.

J.

--gMZPGv83XdEON5JR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmE8jGkACgkQKYasCr3x
BA1yvA/9EXhuzOFbZs76s54q6bWYqwmFOwHdy0ijp3BPRVfc+oKEbsoq+YkQenL1
C1tNJWw0CAJY/FZdF+9S8ReDJlQA3H+JgmFxgmxGS9/9g8COh29dlD6LW+k0KoPS
qy9FcMS/kgsyOVImqQKUFTrFXi+obzNl652RUP4zTiLgHia9cKFk49iFTe5BXOOY
5TbK1e5BqxOaNOW0Sg+YkDHjlMbkpJShVAqc6MEBYEXVMreMuer7rOci9t36dc3J
UkRc6/S6srAKghZ5LXIEhjRRytDnTNdaCij983668oyRMtUFWnMkUkg4Z3J6cX4q
+zu3D5FNBKGX9vCZPMjZllAwGFnn32S6k5DCa+sH28atvYX9Z1UoOUHToBxvkHda
Hb+UyypxjzzgSsFL7lBcqKVh6ywFxUz6frFc7sS5qh4kJZT0IbMo/5kVCRsKBEMK
xa/yLD8DM0ISUTo8czfckTLrjLIxgqB+Jeyk7rhlLIIPh7Y4Ih9d9l3Gs3ASr5XF
jF61/ixazwFYImUaptKaQH/BLNOvmgmRR7il8Ujq2+ZYYWBxNXz/0eiCCRFXIQEb
JgkDiWxPqGDOn/lj4RWoysQ0bhfbZMZ1b2qh7F9HPulPMyv0iAYk4jkTEG8EQuKz
FUqVZWnfgksv875y8kMg66LwcmwFb2LEe6Vudeq0P92PXDzFpU4=
=e06d
-----END PGP SIGNATURE-----

--gMZPGv83XdEON5JR--
