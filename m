Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD1EC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Dec 2021 10:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231537AbhLUKsG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Dec 2021 05:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbhLUKsF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Dec 2021 05:48:05 -0500
X-Greylist: delayed 451 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Dec 2021 02:48:05 PST
Received: from mail.tintel.eu (mail.tintel.eu [IPv6:2001:41d0:a:6e77:0:ff:fe5c:6a54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F646C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 02:48:05 -0800 (PST)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id 3EEA144753F7
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:40:28 +0100 (CET)
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id BKEMqy2VOpt9 for <netfilter-devel@vger.kernel.org>;
        Tue, 21 Dec 2021 11:40:27 +0100 (CET)
Received: from localhost (localhost [IPv6:::1])
        by mail.tintel.eu (Postfix) with ESMTP id DB33D4475416
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:40:27 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.tintel.eu DB33D4475416
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux-ipv6.be;
        s=502B7754-045F-11E5-BBC5-64595FD46BE8; t=1640083227;
        bh=56FCWqVgZ3FoklWl69nVAq4jQWXnNZTyxfNVBroQZDI=;
        h=From:To:Date:Message-Id:MIME-Version;
        b=DpKWVshR2psXDHPyUNwDpTsFVikOv/6ymwbR0+hTgL9QaeGxJxmWJiK3DKPBTIK51
         M3c7EueoIxR9cElDTK9IgHZ5Ri0asOkmQYQkQnjKzUdLa/2xFgXJvNx+FajWw+uHTR
         lcMMbDh4TWcj+DHEcQYCgI73xLUJ51wO28nmuASQ=
X-Virus-Scanned: amavisd-new at mail.tintel.eu
Received: from mail.tintel.eu ([IPv6:::1])
        by localhost (mail.tintel.eu [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id Cc8J5GvSv-hd for <netfilter-devel@vger.kernel.org>;
        Tue, 21 Dec 2021 11:40:27 +0100 (CET)
Received: from taz.sof.bg.adlevio.net (unknown [IPv6:2001:67c:21bc:20::10])
        by mail.tintel.eu (Postfix) with ESMTPS id 3AAB1443B97C
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Dec 2021 11:40:27 +0100 (CET)
From:   Stijn Tintel <stijn@linux-ipv6.be>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables] parser: allow quoted string in flowtable_expr_member
Date:   Tue, 21 Dec 2021 12:40:25 +0200
Message-Id: <20211221104025.2362302-1-stijn@linux-ipv6.be>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Rspamd-Queue-Id: 3AAB1443B97C
X-Rspamd-Pre-Result: action=no action;
        module=multimap;
        Matched map: IP_WHITELIST
X-Spamd-Result: default: False [0.00 / 15.00];
        ASN(0.00)[asn:200533, ipnet:2001:67c:21bc::/48, country:BG];
        IP_WHITELIST(0.00)[2001:67c:21bc:20::10]
X-Rspamd-Server: skulls
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Devices with interface names starting with a digit can not be configured
in flowtables. Trying to do so throws the following error:

Error: syntax error, unexpected number, expecting comma or '}'
devices =3D { eth0, 6in4-wan6 };

This is however a perfectly valid interface name. Solve the issue by
allowing the use of quoted strings.

Suggested-by: Jo-Philipp Wich <jo@mein.io>
Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
---
 src/parser_bison.y | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 16607bb7..1136ab91 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2151,7 +2151,14 @@ flowtable_list_expr	:	flowtable_expr_member
 			|	flowtable_list_expr	COMMA	opt_newline
 			;
=20
-flowtable_expr_member	:	STRING
+flowtable_expr_member	:	QUOTED_STRING
+			{
+				$$ =3D constant_expr_alloc(&@$, &string_type,
+							 BYTEORDER_HOST_ENDIAN,
+							 strlen($1) * BITS_PER_BYTE, $1);
+				xfree($1);
+			}
+			|	STRING
 			{
 				$$ =3D constant_expr_alloc(&@$, &string_type,
 							 BYTEORDER_HOST_ENDIAN,
--=20
2.32.0

