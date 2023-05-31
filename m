Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D40C7EE32
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 08:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbjEaIFY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 04:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbjEaIFW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 04:05:22 -0400
Received: from mail.valdk.tel (mail.valdk.tel [185.177.150.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61894188
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 01:05:19 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id B0113B38E71
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 11:05:15 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valdikss.org.ru;
        s=msrv; t=1685520316; h=from:subject:date:message-id:to:mime-version:content-type:
         content-language; bh=h0oLSgcTyh1gvs/gUL4V0HiCSmrMA26CeHbsc0XBiC0=;
        b=0/UNqUK6//FZulXgixo2Xa+LeR/enCSp+awsaqWU+zc6wihCtn8oVfx54HEXhbOZOxw6iC
        uAB/DhVoYo0wCtVxnRqIKxia/rT6LtxYJttdtH3M+5IR5J0kG9lDiQLTxePBiKiVCKqS+h
        N5BCvnSz5yly7wUqe001SdrWDtQSVc5J37ooHHJWGcn3JQ90M5R7TlCg85MEF+SjBq8kOE
        grmpEpgtG4txRNRHN4PnuK3n8pvrxlWTG7ea26XpadMh1Hh9J1joWx9+kqN845g6r2vZrC
        1+SVNONjoabkflHEhlYCw1Um1FqFXPqVpEWPbDTafhJ2lfxPr2USZ+vXdfCPCA==
Message-ID: <aec130b2-acaf-83f2-2729-fd48dcb0a698@valdikss.org.ru>
Date:   Wed, 31 May 2023 11:05:14 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.5.0) Gecko/20100101,
 Thunderbird/78.5.0
Content-Language: en-US, ru-RU
To:     netfilter-devel@vger.kernel.org
From:   ValdikSS <iam@valdikss.org.ru>
Subject: String matcher "algo bm" broken in OUTPUT since 5.3.x
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------0kaOFkyK10m598rg3DdPJGg0"
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------0kaOFkyK10m598rg3DdPJGg0
Content-Type: multipart/mixed; boundary="------------C0uEquVvqWhvaQtzvBHi0HHI";
 protected-headers="v1"
From: ValdikSS <iam@valdikss.org.ru>
To: netfilter-devel@vger.kernel.org
Message-ID: <aec130b2-acaf-83f2-2729-fd48dcb0a698@valdikss.org.ru>
Subject: String matcher "algo bm" broken in OUTPUT since 5.3.x

--------------C0uEquVvqWhvaQtzvBHi0HHI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgbGlzdCwNCg0KU2luY2UgYXQgbGVhc3Qga2VybmVsIDUuMy54ICgyMDE5KSBhbmQgdXAg
dG8gY3VycmVudCA2LjIuMTUsIGlwdGFibGVzIC1tIA0Kc3RyaW5nIC0tYWxnbyBibSBkb2Vz
IG5vdCB3b3JrIHdoZW4gYWRkZWQgdG8gdGhlIE9VVFBVVCBjaGFpbi4NCg0KUXVpY2sgcmVw
cm9kdWNlciAoYWxnbyBibSwgZG9lcyBub3Qgd29yayBwcm9wZXJseSk6DQo+IA0KPiAjIGlw
dGFibGVzIC1JIE9VVFBVVCAtcCB0Y3AgLW0gc3RyaW5nIC0tYWxnbyBibSAtLXN0cmluZyAn
R0VUIC8nIC1qIERST1ANCj4gJCBjdXJsIC1zIGV4YW1wbGUuY29tIHwgaGVhZCAtbjMNCj4g
DQo+ICAgXl5eXiBjdXJsIGV4ZWN1dGVzIHN1Y2Nlc3NmdWxseQ0KDQoNClRoaXMgd29ya3Mg
KGFsZ28ga21wLCB3b3JrcyBwcm9wZXJseSk6DQo+ICMgaXB0YWJsZXMgLUkgT1VUUFVUIC1w
IHRjcCAtbSBzdHJpbmcgLS1hbGdvIGttcCAtLXN0cmluZyAnR0VUIC8nIC1qIERST1ANCj4g
JCBjdXJsIC1zIGV4YW1wbGUuY29tIHwgaGVhZCAtbg0KPiANCj4gICBeXl5eIGN1cmwgZG9l
cyBub3QgZXhlY3V0ZSBzdWNjZXNzZnVsbHkNCg0KDQpTZWU6DQpodHRwczovL2J1Z3ppbGxh
Lm5ldGZpbHRlci5vcmcvc2hvd19idWcuY2dpP2lkPTEzOTANCg==

--------------C0uEquVvqWhvaQtzvBHi0HHI--

--------------0kaOFkyK10m598rg3DdPJGg0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEMiogvXcpmS32v71gXNcgLu+I93IFAmR2/7oFAwAAAAAACgkQXNcgLu+I93Iv
uhAAsbMDpGbYjowkKtRB20gVJG/DDZpEoxVgzCRs7657i716Bt/iU8Cl91bnAJPQoAGtZauH7B3d
oRBSl0/y6c1BLA4hn6L4piCgUXiR1BjbrAmri5zTqHql6r4MYfinV2oFkrihe0Orx4904834x5LH
rgMNaA3A17pWaB4CqyK5r94M8dnw4Y0dcMOB78u0lVTFgMnX73jDdm4h3j0t8iSImIyPmY4aMJvG
+tiEHhK/bYfcT7MJxyITUZq3pz5OHjUe73tLHnwIZGjOgnnE24nudMnoiYXRU28svK9EvC/IsVK1
kszCQc7uHoz1YPSN+K87ZWxqZWVr0MJQm0281t+sQq5QkEl+eILCukF5Q41lSJAvBp+bhs+mmrCw
wiQTqauSBoh/Q+d+I2QkKqi/WPrhLivI7oIor0jCPu2Nf3KlEEDw82u1DD9L0FEVzvXJZZjoKut3
jFuRxRZEUd0iIm2FjH3Au49W7v9zAmOYlnAw8v0aiBS4AN3ddWstlYRG10PxDvbvIdFlwlGWUMAo
IKk+PSozkj6p/RU5fhXqX9VXv+uAZgA0WJDAudigUuorXXiKLdPAJYPPiNg3d37OaZCRdIHQRWb9
3SkcnchYRUZ0IgfJIP0wVQut//N4dc3H1ogh0DReBj1maTW8LWNdRGOEHIi1qjegkMly/P8yUbmc
kKA=
=EyoC
-----END PGP SIGNATURE-----

--------------0kaOFkyK10m598rg3DdPJGg0--
