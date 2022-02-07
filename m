Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDD1C43217
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Feb 2022 12:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355151AbiBGMkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Feb 2022 07:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385384AbiBGLbl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Feb 2022 06:31:41 -0500
X-Greylist: delayed 2591 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 03:30:14 PST
Received: from leucas.entrouvert.org (leucas.entrouvert.org [176.31.123.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD05C02B658
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Feb 2022 03:30:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=entrouvert.com; s=entrouvert; h=Subject:Content-Type:MIME-Version:
        Message-ID:Date:To:From:Sender:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jC90PO1reBSRFn8mSu/+BiX5P4vgPtXIo2goAnGGWYw=; b=JWm0C8PxvAX4OPj7rQqfPrv6/
        w/xmFuoBjUVctDTufivKrOZmzSi8mIfbElKbce/tm4zX/NoZU79pOKDzFY/P1WxkreEY2VVn5Yym8
        zpDXtSlvS02vYgJDhXmPFEFWo2WY7C7w2et/3zGHbISUHiCoDBJTfrAfB2+wPcUWulFuU=;
Received: from rock.pinaraf.info ([109.190.54.247] helo=entrouvert-pierred.localnet)
        by leucas.entrouvert.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pducroquet@entrouvert.com>)
        id 1nH1Xx-00008G-03
        for netfilter-devel@vger.kernel.org; Mon, 07 Feb 2022 11:47:01 +0100
From:   Pierre Ducroquet <pducroquet@entrouvert.com>
To:     netfilter-devel@vger.kernel.org
Date:   Mon, 07 Feb 2022 11:46:41 +0100
Message-ID: <17129011.jtLeUFmENV@entrouvert-pierred>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5958965.iR5QGJfuPA"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-SA-Exim-Connect-IP: 109.190.54.247
X-SA-Exim-Mail-From: pducroquet@entrouvert.com
Subject: [Patch] document nft statements undefine/redefine
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on leucas.entrouvert.org)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--nextPart5958965.iR5QGJfuPA
Content-Type: multipart/mixed; boundary="nextPart2760383.sXSQ4k5BsB"; protected-headers="v1"
Content-Transfer-Encoding: 7Bit
From: Pierre Ducroquet <pducroquet@entrouvert.com>
To: netfilter-devel@vger.kernel.org
Subject: [Patch] document nft statements undefine/redefine
Date: Mon, 07 Feb 2022 11:46:41 +0100
Message-ID: <17129011.jtLeUFmENV@entrouvert-pierred>

This is a multi-part message in MIME format.

--nextPart2760383.sXSQ4k5BsB
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi

I found out that two statements, undefine and redefine, have been added to the 
nft language a while ago (2018) but not documented then.
Cf. https://patchwork.ozlabs.org/project/netfilter-devel/patch/
3622208.jy4NlOniyd@voxel/

The attached patch adds a basic documentation of this feature.

Regards

 Pierre
--nextPart2760383.sXSQ4k5BsB
Content-Disposition: attachment; filename="0001-Document-the-undefine-and-redefine-syntax.patch"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-patch; charset="UTF-8"; name="0001-Document-the-undefine-and-redefine-syntax.patch"

From 81bd851db3e6bae98ac9385ecf404696346d91bf Mon Sep 17 00:00:00 2001
From: Pierre Ducroquet <pducroquet@entrouvert.com>
Date: Mon, 7 Feb 2022 10:48:11 +0100
Subject: [PATCH] Document the undefine and redefine syntax

---
 doc/nft.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/doc/nft.txt b/doc/nft.txt
index 7240deaa..f7a53ac9 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -170,17 +170,23 @@ SYMBOLIC VARIABLES
 ~~~~~~~~~~~~~~~~~~
 [verse]
 *define* 'variable' *=* 'expr'
+*undefine* 'variable'
+*redefine* 'variable' *=* 'expr'
 *$variable*
 
 Symbolic variables can be defined using the *define* statement. Variable
 references are expressions and can be used to initialize other variables. The scope
 of a definition is the current block and all blocks contained within.
+Symbolic variables can be undefined using the *undefine* statement, and modified
+using the *redefine* statement.
 
 .Using symbolic variables
 ---------------------------------------
 define int_if1 = eth0
 define int_if2 = eth1
 define int_ifs = { $int_if1, $int_if2 }
+redefine int_if2 = wlan0
+undefine int_if2
 
 filter input iif $int_ifs accept
 ---------------------------------------
-- 
2.34.1


--nextPart2760383.sXSQ4k5BsB--

--nextPart5958965.iR5QGJfuPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEbcO4NNOnlypyH7hOck7KPqdNerwFAmIA+JEACgkQck7KPqdN
eryUnwf/co5F3O+CrdT7lFdhfODEqTuiBo8n896hxWGSe00C9KAJNJ9iogBMIvx4
OtmBZn8PDBbZbODBlv7iqnje5aLqAigSGFKb17fj+QAaR8dK1Idcl7RS0hYrHjw6
mEH24mg6qPIJY7JRH/HaN0LIqJ/ZHRS4Ny4oK/zlnBfV2Byha5BJRsGuLuLWNyKk
tu+J3tEhBKtyuM7s48TpI8RiLa2D7v98fPuuGSwv30yW3d3mL1laGAX8EPbZHSmV
jscSEfHYtL4Ldtu8rSjjUTFCuYT6HGAYPDzXt/33YvGdkz3gR8QGtBVri1x8TAan
F1O8ZzHx7qMHRByqWgFET31HvUHIZA==
=/0KS
-----END PGP SIGNATURE-----

--nextPart5958965.iR5QGJfuPA--



