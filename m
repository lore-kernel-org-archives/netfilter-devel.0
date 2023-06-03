Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4401C77B73
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Jun 2023 10:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjFCKI4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Jun 2023 06:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjFCKIz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Jun 2023 06:08:55 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDF41A6
        for <netfilter-devel@vger.kernel.org>; Sat,  3 Jun 2023 03:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s3OIG4tbWnOZTM3rhQP0PRtONdmsyJdIb49G/9yPbY0=; b=irDZ+Y0x4x4iLV3XKa1kBwZsQ3
        JjnK6AxAdv7Y6d23vjI/d4ehGp8s8gnnkXI2uuGlzFKiFtniJnJK9aYVEqcFBJuPt7lxy6KluMtNy
        G/nqoeUFLIgtTzU9PnK1ExARV44n805pBvOxfI1Ww9Jdpx2cO47oTfQeTe+7mOBCF+NfsSl5Y/QVG
        2guobxo4Qu+vAForOAADAa7DiX/8YnY+VJfGWD8sXQ5olX7k86xn09+eoTDVVhKaHU4DK3L4PIlqu
        XrCGAXfsru2KePJ2OMr+o7Jknp4xBo2bFZc0Fbv2OYyMRk6BB3kYrEhY1cypZL9dC2YCkd0KUzp+2
        /Y38NW9Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q5OBp-00EjS0-0c; Sat, 03 Jun 2023 11:08:53 +0100
Date:   Sat, 3 Jun 2023 11:08:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables v2] exthdr: add boolean DCCP option matching
Message-ID: <20230603100851.GG187342@celephais.dreamlands>
References: <20230411204534.14871-1-jeremy@azazel.net>
 <ZHp5T9pWQ3u2Fugg@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kGpxvRWasGRyB0kv"
Content-Disposition: inline
In-Reply-To: <ZHp5T9pWQ3u2Fugg@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--kGpxvRWasGRyB0kv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-06-03, at 01:20:47 +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 11, 2023 at 09:45:34PM +0100, Jeremy Sowden wrote:
> > Iptables supports the matching of DCCP packets based on the presence
> > or absence of DCCP options.  Extend exthdr expressions to add this
> > functionality to nftables.
>=20
> Applied, thanks.
>=20
> Not related to this patch: there is 'ip options' and 'tcp option',
> probably enhance parser to allow for 'ip option' to address this
> inconsistency in the syntax?

Sure.

J.

--kGpxvRWasGRyB0kv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmR7ETMACgkQKYasCr3x
BA0fBA//eCgIodUd0W5f1eR2odaxOwwxOjV4+PGrvXT+DEUIGmwwK2yAqi0AvQTa
se+f1TQDLrr6MGyrPc8lNwXDR4VhKrQJuxjkAUrinUSmYrWI1KhDOxNKfob7w1KQ
B/4roaD9rZ3xkWubNDSzODlQ5mfzYnPZH1SWnrBMGo2qpQHESbA5ER4/AEZEAJGv
ksVQOwJji8HV+qsZNndcViWqIdZ41WVZbaUvs35Blgkt7yimVy3ldhfYwfBywPGB
A5LR4vJ4nRt8hKLsK0oPoYmouS3rD4iGd9ReOq2mCs+Qh03PY8J7chhKmGNLib1w
asrXgTZEPSNZD7SiKRMUxVl4bcQzcmRZiqMCtTKsdhM5BjXxmOgStTNK67sKPBH0
Hgh624Y+cFI2WIXr+xX2UFkh7HUdIk6zGVRFJXtcj/BKoeJ+66Awg8aqsZUWoCUI
X04NPRVxldLwu4d5qoaF2PqqPv25F6dPn543wI/zwm48vhMvDRu+fBgKfXGkE+zA
oYzcvksbKIX+tyl03NSLdaXcTPOm7A14qiOaenimcMF1bkWs3rFIkXi7vGapJV3s
EZk/TZDe1YNAtNszD26OqKXjiOmxhmWLVCMU5wdv5oQ4glHIOHL5B2+hkj00Bxh2
Xn/ITAY4qXi3jkpo/bbfDoTb6AEFXq8DjVKYTEYOvsRt06f4OJE=
=DRgq
-----END PGP SIGNATURE-----

--kGpxvRWasGRyB0kv--
