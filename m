Return-Path: <SRS0=PEYv=TG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5950AC04A6B
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 May 2019 13:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B50A206A3
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 May 2019 13:08:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="X5o5thvU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfEFNIW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 May 2019 09:08:22 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:43675 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbfEFNIW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 May 2019 09:08:22 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44yNMk3gkdz9s9N;
        Mon,  6 May 2019 23:08:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1557148098;
        bh=G8r3qCd5HjzKUThew6yjTIbb6IoPOhqODEolin4V6Uc=;
        h=Date:From:To:Cc:Subject:From;
        b=X5o5thvUAr9nZKDdmhgpzCd7DuISdJStUy5EpE8JuLxMrf/n8nAv+NSQj/Cis5UAu
         6bdHnE0TcX1R6HYt+XrVumF3spOZDRpYPnXcTjBFRiBNTktuIxUTnFYqwks03S6vmx
         msFve+EfgIzxRnBrdZ5DwGDylcgkd7znRYMnt7x9/XK5YMTtEUEmpVD8x4+Pd1vtZM
         81WrxpRbuu0NY24zWyR0nKWT7z1Gdp6kQsm0yZhd9Rzbn4wUDDmSm/8VM+2ho3/0ME
         KANPsc4nRY0jHbAW+WHcVWNK1u4RMQKj/iCnhB/36UU2M0LgRq2YQazXmp6LFDXLqH
         5wJhxuQz6/jVQ==
Date:   Mon, 6 May 2019 23:08:15 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kristian Evensen <kristian.evensen@gmail.com>
Subject: linux-next: Fixes tag needs some work in the netfilter tree
Message-ID: <20190506230816.22452c4d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2dh7rGdDwXTz/NoDbDAJsn7"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/2dh7rGdDwXTz/NoDbDAJsn7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

n commit

  4ff6d55abba3 ("netfilter: ctnetlink: Resolve conntrack L3-protocol flush =
regression")

Fixes tag

  Fixes: 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter

has these problem(s):

  - Please do not split Fixes tags over more than one line.

--=20
Cheers,
Stephen Rothwell

--Sig_/2dh7rGdDwXTz/NoDbDAJsn7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlzQMcAACgkQAVBC80lX
0Gxu7AgAjLH7b+D21AAun/ybz1JFuzbsjqUZM2urJFjKvGkFqvqIZMR+BiQ3NaR7
RIKpUH3MUVVj1GrbA+eOCZiaWhL9yy59hZrLAdwJZO51NUdq1Z0Y+XuZaBEQjRR4
kgqHjbteAMiY5EzrN2P5V/AMXg+nhcCROEAnINc0UfJHIVSw4YOxfry32DleYWbE
ATfk0UL++vCIzF+FJE26g2zErza3vizazroIoUsQjdhkp2IaY6QrO0oewCx/pGpM
Fbtgry3PpQY25AdVJyhKyOEIlIILKNKWB6S5NazFHXJ6NJcxU+R6uE7OjWfOUIFm
3nBErmWA1Hh16rdIxL+f+CDKrYOrMg==
=mrha
-----END PGP SIGNATURE-----

--Sig_/2dh7rGdDwXTz/NoDbDAJsn7--
