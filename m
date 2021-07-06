Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4562DC07E96
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 10:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD92619A1
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jul 2021 10:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhGFKGv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jul 2021 06:06:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53308 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbhGFKGu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jul 2021 06:06:50 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CA8C81FF46;
        Tue,  6 Jul 2021 10:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625565850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=13Mczg81HfNrHSPFM2tYI3k0D1IyUszCvu7ujyW/A28=;
        b=W5Oj507StYIMhQKYuozdiVIx1vbqEWynUUuNbyakJ14TXwCShmTE0z4SY0tgWenYs/8pHx
        vLsXRWobTYuAt8QMfusX+u+7mAzUJJXH4g3tKvu1+0Kw5GNKcjOleyBXSVHYUowl1Wv9S6
        p1ytsgh/POYypwLwBs2if6hu8bn1qhw=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 8310D13790;
        Tue,  6 Jul 2021 10:04:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id cAiFHZoq5GCgXAAAGKfGzw
        (envelope-from <ali.abdallah@suse.com>); Tue, 06 Jul 2021 10:04:10 +0000
Date:   Tue, 6 Jul 2021 12:04:10 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     aabdallah <aabdallah@suse.de>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: improve RST handling when tuple
 is re-used
Message-ID: <20210706100410.kxsjk23zpnwbynpw@Fryzen495>
References: <20210520105311.20745-1-fw@strlen.de>
 <7f02834fae6dde2d351650177375d004@suse.de>
 <20210705192349.GA16111@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qjor77q6nshhdy7w"
Content-Disposition: inline
In-Reply-To: <20210705192349.GA16111@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--qjor77q6nshhdy7w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.07.2021 21:23, Pablo Neira Ayuso wrote:
> Ok, I'm assuming that you're fine with Florian's proposal to address
> your issue then. I was actually waiting for your ACK.
>=20
> I'll place this patch:
>=20
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210520105311=
=2E20745-1-fw@strlen.de/

Thanks a lot!

Please also take into account the following patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210527071906.s=
7z72s7wsene5lib@Fryzen495/

which was already acked by Florian.

> Thanks

Many thanks.

--=20
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5


--qjor77q6nshhdy7w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEUaD0oMjPyY+ELqmouUVW+ByF0NUFAmDkKpcACgkQuUVW+ByF
0NUXGg/+KNBmeCCXakhv3Rjnb2lnctGyaPv2iADIT+zqTVQpGdok2d4YDZHidwn1
dpkVMjP5C8/H+1xLq2mATNyomICgZvWMuuttEYd5CelXkheUKiSLFVYP0BJaIJ5k
7aWZOSXNNRq7+QkcCrmNyKh4iwA0LZden6KIwNx/RSKQE06ZSOolfFpxaCXahfnM
0V1y/eIvZujbdW2dIDCyxdLNSWHa6zxHy6rQl2ukgGPGHnrQF/Zt3Z18a+0IiceS
FDepLdMQS2A/qkVwWGR93d4S3iKi7B0/3kEAZAzNEll0Eou5YDMUXYobZgq1tNN1
HdYoyotoRJLyaRBh04jsIJF2zRsa34a4/aKFULiewIwe+gtC4C9PCHhStVEc7yD0
GcFcevYpK+njd3LYT+FGPlotVk+LGQL4m7MrFS6zQMTJGfz0NaVVRZma5dYZpVTB
A3lkzU38uvwv4vBOqIjxTfRnNuWSsdTffMtEndHWafppbnjpLe6p2bOhsIPvt2lO
fa+uIIBuUkpZdO+5hSrOIbrAUiKzp09jvBrDxU/F+Ch2M6CPqfOn37jVl+AJil8r
iTTSSD+JT2y0JFt2SGagFkHtzTHN49d7Mhx6JrW5HjmHIjZnQbIiyaNX5FSFhBga
iKcJjcjw/hGImZxIekxeiyVtgHr7xkSYJWqmm6nHQKAEA1+Pv9E=
=PT3P
-----END PGP SIGNATURE-----

--qjor77q6nshhdy7w--
