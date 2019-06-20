Return-Path: <SRS0=UCdS=UT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9F9C43613
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 14:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 848622084A
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jun 2019 14:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="QMlKdFnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732113AbfFTOQ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jun 2019 10:16:56 -0400
Received: from ozlabs.org ([203.11.71.1]:58517 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731773AbfFTOQz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jun 2019 10:16:55 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45V3m33SGhz9s5c;
        Fri, 21 Jun 2019 00:16:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561040212;
        bh=vdja2ap0jXe0YFwNWLNtjkfL4tYpQ+TI45RHxPMuGDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QMlKdFnJPWwbxgZeuxJtNM70ggOfFCt3hxwZ4u2jtIrWpIwb0kEPPrZbDLl7X/jBH
         UTMxcH18qH7moX9fxTJvNl9ktpZUYGMKE+owxy7xaPtCx+87feLBCTmjPURWavirib
         aX3C+26puhlHrakpxkDhVx92ZYgX3SaHlCT3nuKOjEDCZQqoiZrtJrSfJykiF0II5m
         BScYSmTd3FIM00yCv5gIRKOba5HZTyM6CabpgbVE3ivo8oGbpHKcIjMIZ052dNc8lY
         frM1Ps1MilvF8uyIBmttgFs/PImBZGOCJEVFiUalLLt1Bqi/Jyv5CBQMMn5IILXNuA
         sBs1GB5yYGzFw==
Date:   Fri, 21 Jun 2019 00:16:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: linux-next: build failure after merge of the netfilter-next
 tree
Message-ID: <20190621001649.4954df45@canb.auug.org.au>
In-Reply-To: <20190620135703.aiv62n6fhzf6wjwv@salvia>
References: <20190620234743.42e9d3e8@canb.auug.org.au>
        <20190620135703.aiv62n6fhzf6wjwv@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SZk4yP0hckaUr/ULND1Dk+/"; protocol="application/pgp-signature"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--Sig_/SZk4yP0hckaUr/ULND1Dk+/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

On Thu, 20 Jun 2019 15:57:03 +0200 Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/commit/=
?id=3D8527fa6cc68a489f735823e61b31ec6cb266274a

Good timing :-)

Thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/SZk4yP0hckaUr/ULND1Dk+/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0LlVEACgkQAVBC80lX
0GxrvAgAlz07KK18OGLbKh42QR1OTkWWQ7FThdF98Wn6qyXTzzQakCXjxoyXxKNM
9kl6fIkixj+WDn/UdVL8aq12x91e4RCwAiKzAbyG2SsCB9zPm65apUsWCnCFliCq
lRTwE5AGD5WLyDGxI/GD3VRv/qAZQrkq93rkeK12sh64HLXwqAtKzkpkd1tZnqxM
7Sv7ipWd7KxhsEE+z0xE7ocU19OXEaRSnZrx2GZCDt2QAyvcvyFOATlcXJyhnA18
vaXGzgks/zlO4YzeytYSYlnBih5bsaYVZGax4wbJlpuoZZ5CsR97MDaC4Mjj9d28
iQxZORJr+3JjRZ/PglH6IHGi0/oICQ==
=czsd
-----END PGP SIGNATURE-----

--Sig_/SZk4yP0hckaUr/ULND1Dk+/--
