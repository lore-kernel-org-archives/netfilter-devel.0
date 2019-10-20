Return-Path: <SRS0=p8+a=YN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3078CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Oct 2019 08:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37D7921835
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Oct 2019 08:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="YZJ3LsCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfJTIEc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:04:32 -0400
Received: from kadath.azazel.net ([81.187.231.250]:41156 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIEc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Oct 2019 04:04:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2SFj1qZWoUq2wHpmObvuTCOrpkE0eW2ZFu2tg4hP/18=; b=YZJ3LsCPMW2EhJwTEMzCsxsyl+
        AqP2frUjkNhMe2oE4Ea5eyCU/z3eRNzG0Ap3RtjO1krdbEfaGqHddTQnhspBc0FDRII3nJrNmwpb4
        4xp9NE+jHCbIqBm+kizfmvv1tugsio0GSgdkIkP2UpreBPI50CirRLrk+6K64hPPZrsIVHLClyQCP
        DxTYms5KCZh9dkXD61oMc605JnOah2CfngQSssxBu1+f11KPu9bfIHNprb64rw4IzAvMzb1gAhIMu
        MLbsLTDW9cuUUkVp+rYKFX2sK1rw9Ma8qj+L7XIQPX5+WPSwbie8JLS+JMP4BHhymQiMqbXCVw0zp
        Uto3AvoQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iM6CR-0000sp-1j; Sun, 20 Oct 2019 09:04:27 +0100
Date:   Sun, 20 Oct 2019 09:04:25 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Matt Olson <lkml@oceanconsulting.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: xtables-addons akmods Builds Failing on Linux Kernel 5.3.6 - Log
 Sample - xt_DHCPMAC.c
Message-ID: <20191020080425.GB5481@azazel.net>
References: <52b77b21-1d56-cc2d-7d65-35705ff86a2b@oceanconsulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <52b77b21-1d56-cc2d-7d65-35705ff86a2b@oceanconsulting.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2019-10-19, at 16:43:50 -0700, Matt Olson wrote:
> While troubleshooting why the xtables-addon module would not build, I
> ran across a specific build error that I thought may be useful for the
> maintainer.=C2=A0 The error appears to be
>
> [...]
> 2019/10/19 16:08:43 akmodsbuild: /tmp/akmodsbuild.A7wQddef/BUILD/xtables-=
addons-kmod-3.3/_kmod_build_5.3.6-200.fc30.x86_64/extensions/xt_DHCPMAC.c:9=
9:7:
> error: implicit declaration of function 'skb_make_writable'; did you
> mean 'skb_try_make_writable'? [-Werror=3Dimplicit-function-declaration]
> 2019/10/19 16:08:43 akmodsbuild: 99 |=C2=A0 if (!skb_make_writable(skb, 0=
))
> 2019/10/19 16:08:43 akmodsbuild: |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^~=
~~~~~~~~~~~~~~~
> 2019/10/19 16:08:43 akmodsbuild: |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sk=
b_try_make_writable
> [...]

This was fixed in 3.4:

  https://sourceforge.net/p/xtables-addons/xtables-addons/ci/b14728691d73fc=
907839c04b9dff7e2595498546/

J.

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2sFOkACgkQ0Z7UzfnX
9sMg1w/9ETx9NSyglSzL5u2PgjcTLg53C6GSiPgNolPr8kKQbZBCuuGYcYZJMMyG
l0EtKODSNRp+WwjP9OQA6vleu8U+kzwWbD1T+wvoi2lE580Q62BdpECqJN8oUjc7
81kqXG652S/fZiUsYN1u5+KxOzLdSeOjJy21EhRcASswOa5QLZjwHVYygfIALSFd
qntjj4AD9PNia5sUer9xvyPPAaMihQ3ROe4fshQCXAWlJf1n6+J7OsHvfVPi8e++
zzI5UPmkOtlznL9uwLJgzMhckEMSidPAeWof9v1Mr91N6NxT+VlN8b7aki7/hee0
6jIqR4jSKIlVhaejKuq83qWq9MMzaciyWBqE1z3PaRap5jpi6HhE4iBBQr9K9D7+
girxLy+Lk40UaD3HrTYUDHgwJeghsuuAydRUV+L7rte1OTeyo9gvH5bPwRotM+r1
AY9e5YFKVmCunK7h3vX70+6aLEkiuY5a1IbyDOfoKqxmfpzViJa7q8TSgVwjV13i
hErDLI5uiRVtnLgTM8VQt2bNR6LhIwr5yxS9kT5sHPQebbqV+iDQkGc1GSgdkaiN
6huvCjhaUAUK0WSw7knesJS90hgQFqRX9HhZADOn5DmjdpZs8EdBLEmeBiGTQqgn
Az1CwvHWvf67nSFWCz1AghTLnLe5uB5LkLZSRmZs+sInAFb0EdI=
=QD9k
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
