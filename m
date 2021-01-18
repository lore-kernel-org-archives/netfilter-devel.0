Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431F3C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jan 2021 04:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C8D20759
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Jan 2021 04:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729202AbhARE7T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Jan 2021 23:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhARE7Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Jan 2021 23:59:16 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803F7C061573
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Jan 2021 20:58:36 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p18so10175110pgm.11
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Jan 2021 20:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=+t+mqA5cOb04g4fNq5HlRyul1jeqMlLzyRmrQ/whLw4=;
        b=HrtO+3XXa26BcXOKTobwpMGpK6WLZMfU8MYpAi7i4TfH8S8SgSbNRKwdNO61J7q3Sd
         IjCUmWk3AOCbZDhlhyA7jPYkgTnuPbyaos5wtnlLKz/JOhTXL6NeuLnKggq50KlBhmqZ
         oCWDB50WajY/fzpNE9y2Www3ZiDzhmbrIJ1415o0LSDlPy4ruiB3gS1lveMA7jM6gZnK
         YWKYAy4Uzln8OQsU2JKG6ZcVJsAPev0ikELAE+RFGzsHScP6zvjkqMsAWX26QEsHR2JF
         TkD9CR474ETMVsCmzsG/2vcwD2TYoxzs8VR98x2BIDuYw7unsdtOjiuznQ3nlaf14VmY
         dvdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=+t+mqA5cOb04g4fNq5HlRyul1jeqMlLzyRmrQ/whLw4=;
        b=Td8zp0JgmnzjDiyuyReZGCr4+krW/0SRwijSNMD8pqslmIhZ8OTFlsXz6AOiPeE2mN
         NOtoMTepBToE4Sb/UyQ8lFVjM7VLIdo3eoieJYKy7DsuzVDFz/6txlM+Ow0a6l3ioRVE
         8DUfWy3qZ6TUux4uNgZ60Tiy4gVOcM4YesNQvsgzDXrxpw6o1MKZOduLJnkb4Sqy07Lt
         gY3nNO4/RdAZWjas+n2oMYLVYpDDCbWR5elz3LzIgqPoq67G1w3gK3GcAJkZivXuDdMZ
         1u935c9vw70c8at7lToRZHmCKODYHFzPpV6A4v5b7GUJGK8jGS9Vk08ZHUKXfKkNspdn
         GHfg==
X-Gm-Message-State: AOAM530mkwrciPi8LALECZ0geBIodsq0QAkTjch0Y+NzFqgalcF7sr1z
        cZfQFqdsV2FKTFGKJlYGST91p+E6B3yWlQ==
X-Google-Smtp-Source: ABdhPJyiArKQOxpbTSE+Mf/1j3Lu02aqiVz4Jknd26NvpQiatW3wUeccUPrQAiZwGr0JL2t9jgooLA==
X-Received: by 2002:a65:48cb:: with SMTP id o11mr23894611pgs.121.1610945915502;
        Sun, 17 Jan 2021 20:58:35 -0800 (PST)
Received: from hydrogen (ppp-58-8-225-119.revip2.asianet.co.th. [58.8.225.119])
        by smtp.gmail.com with ESMTPSA id bk18sm11424771pjb.41.2021.01.17.20.58.33
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 20:58:34 -0800 (PST)
Date:   Mon, 18 Jan 2021 11:58:30 +0700
From:   Neutron Soutmun <neo.neutron@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] ipset: fix print format warning
Message-ID: <YAUVdnEg6OMPsUet@hydrogen>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="39Ynzj21/GhNcsMs"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--39Ynzj21/GhNcsMs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Use PRIx64 for portablility over various architectures.
* The format string for the 64bit number printing is incorrect,
  the `%` sign is missing.
* The force types casting over the uint32_t and uint64_t are unnecessary
  which warned by the compiler on different architecture.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 lib/print.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/print.c b/lib/print.c
index 0d86a98..a7ffd81 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -431,10 +431,10 @@ ipset_print_hexnumber(char *buf, unsigned int len,
 				*(const uint16_t *) number);
 	else if (maxsize == sizeof(uint32_t))
 		return snprintf(buf, len, "0x%08"PRIx32,
-				(long unsigned) *(const uint32_t *) number);
+				*(const uint32_t *) number);
 	else if (maxsize == sizeof(uint64_t))
-		return snprintf(buf, len, "0x016lx",
-				(long long unsigned) *(const uint64_t *) number);
+		return snprintf(buf, len, "0x%016"PRIx64,
+				*(const uint64_t *) number);
 	else
 		assert(0);
 	return 0;
--
2.30.0

--39Ynzj21/GhNcsMs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE9TLaEOVj7oRECXehnQRwvabNxFcFAmAFFXYACgkQnQRwvabN
xFeipA/+LBm9JhA1gbuEN1W/pqPHsk/J3AEXGBgytMD7umhwIUeYY+7eIjkgi0dS
RjdCy27NCZadRRXJfcougj/BLuP7A9p8VHKWet2KCQ11i9ayeWhs5Int4/1Zxv4G
aTJbq4u+54rVPaVIu17JSfOAJOG9mzFiVXeo9IRudBw9ajAoP8T+IX01N16lcPLr
DjYbhEtlYXeUWmLUYDf3kxN62FTzphtbnd3EYMad0uqLVmD0oO/ybp/VOc26gQ7+
aYrGyDPCPsH4QJZ5FMa53d5X/xPJx+bf1fd811B8jgPZneCjOI4Ki5xy8+Ikwbv7
xjJ3xsbk6Ko6gCgsbBMCsqB1Rgk2zSgZB7D3U1ru5EdJjcB34jTI9m5Qr68lI01R
9rA74S5f+CNNWOFszTOAGWGMt3j/NcWzhcoPXSoJjfY1W8IjQHL/JpNnzRjSlSQw
H1iF2dBW6+GmNcfZbs2EX343S2tV6h69qJHj47eyZrO3oRcuGYosKyXgTsRNghcH
d8dmsdxC7ILl+elTa74Hmrs52U81LF5QET0bQHb2w5DculK1MYVs7mKF6TM2MLzl
HjK5L9LU3UiuyEC5D9Cv8i8y3fteiORzwCsuyCIuGvHVa8tXS+6jEITGZxmneVkb
gXLWrP0cdmaHp+UTHYKIeFDIKIwLgqBp92iL9+whQCogDh5CHCE=
=6N2k
-----END PGP SIGNATURE-----

--39Ynzj21/GhNcsMs--
