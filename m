Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ADEC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236910AbiK2VMD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiK2VLl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:11:41 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6104D68686
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bhRgA0rGv0zNNc5D9kgnbWsiyoRcGZetS60UOdxkiGQ=; b=JJfmxrjkD2m79Cuc2s8mc65X7a
        uC8qM4iIpJ1QM1FbJmCvKQzosONhvbDsaQanft8BL7yETT+/WDj3iIWsey1QVqkGml5cgN92fIu2I
        kbCBOgx+7ATkUznLheqRl2y4J17KHPg6JbVf7vXTnAsB1v9weLyM4Pg2tYuLhpyqhzkyJ5OBjHjKS
        tygkYOJigEkNDY57pS9ChWZLdmbpPC9mW1J7WZxowRnP1Iz3JF4agRR7RF84kqGNk4jKxWu42U1OA
        BX8D22Cf1DYo94h+Y3IgqaMu9vsaaMX9Zvzo9J+xrMLxAu4K0OFo+hiXFaIjFyPOtdyq6svnWxZ1s
        l7M4HQ0A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p07t8-00DjG0-3a
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:11:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2] pgsql: correct `ulog2.ip_totlen` type
Date:   Tue, 29 Nov 2022 21:11:27 +0000
Message-Id: <20221129211127.246934-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The types of `ip_totlen` in the `ulog` view and the `INSERT_IP_PACKET_FULL`
function are `integer`, but the column in the `ulog2` table is `smallint`.  The
"total length" field of an IP packet is an unsigned 16-bit integer, whereas
`smallint` in PostgreSQL is a signed 16-bit integer type.  Change the type of
`ulog2.ip_totlen` to `integer`.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1556
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/pgsql-ulogd2-flat.sql | 2 +-
 doc/pgsql-ulogd2.sql      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/pgsql-ulogd2-flat.sql b/doc/pgsql-ulogd2-flat.sql
index 6cd2150cd96b..94c903795ede 100644
--- a/doc/pgsql-ulogd2-flat.sql
+++ b/doc/pgsql-ulogd2-flat.sql
@@ -43,7 +43,7 @@ CREATE TABLE ulog2 (
   ip_protocol smallint default NULL,
   ip_tos smallint default NULL,
   ip_ttl smallint default NULL,
-  ip_totlen smallint default NULL,
+  ip_totlen integer default NULL,
   ip_ihl smallint default NULL,
   ip_csum integer default NULL,
   ip_id integer default NULL,
diff --git a/doc/pgsql-ulogd2.sql b/doc/pgsql-ulogd2.sql
index 0e01ba4ba57d..edc81e760768 100644
--- a/doc/pgsql-ulogd2.sql
+++ b/doc/pgsql-ulogd2.sql
@@ -55,7 +55,7 @@ CREATE TABLE ulog2 (
   ip_protocol smallint default NULL,
   ip_tos smallint default NULL,
   ip_ttl smallint default NULL,
-  ip_totlen smallint default NULL,
+  ip_totlen integer default NULL,
   ip_ihl smallint default NULL,
   ip_csum integer default NULL,
   ip_id integer default NULL,
-- 
2.35.1

