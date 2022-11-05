Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84D6C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  5 Nov 2022 16:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiKEQyW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 5 Nov 2022 12:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiKEQyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 5 Nov 2022 12:54:21 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB33D124
        for <netfilter-devel@vger.kernel.org>; Sat,  5 Nov 2022 09:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V8BRDRPBiUR0XJBsv9y1xATSJzI3LyWA39BJsM7z3Yg=; b=jsZ1B/gCraC1/xJe88DEEWkl6O
        lfHH52w52EYSvi/1MVWlL2zPqr7tflH7u0Y9W1Qg9ld66sRrXS22biEpb0VjSX7ihBblAual8NJ6W
        JOWESH2Dm/psfllnUm5+QXw8njh3ViRrSj30Bu11UEI4ZMKKL9l4GC6j0WA8uUpNamATnONK5lteY
        uxaDd+szFN7ICAIcMp/NmhZK6kA5MxLVGcLjLrPvhU5AU00s8XGw7WeEdh3O/lKQtHucyaZ5vxEmf
        rbojX5xuvzKAQ3IJSJ4+IKz+aDbYi0VB3eCiuiDCNFirPF1NGam/bCdraIX8yqgvl6RK251XI2eOa
        bX3f5KaQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1orMQx-008hSe-RN
        for netfilter-devel@vger.kernel.org; Sat, 05 Nov 2022 16:54:16 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2] doc: mysql: declare MAC protocol columns unsigned
Date:   Sat,  5 Nov 2022 16:54:02 +0000
Message-Id: <20221105165403.2355665-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By default, MySQL smallints are signed.  This causes problems inserting packets
for ethertypes above 0x7fff, such as IPv6 (0x86dd):

  MariaDB [ulogd]> SELECT INSERT_PACKET_FULL(...,'f4:7b:09:41:7a:71','f0:2f:74:4e:b2:f3',34525,0,NULL,NULL,NULL);
                                                                                         ^^^^^

which fails as follows:

  ERROR 1264 (22003): Out of range value for column 'mac_protocol' at row 1

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 doc/mysql-ulogd2-flat.sql | 2 +-
 doc/mysql-ulogd2.sql      | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/mysql-ulogd2-flat.sql b/doc/mysql-ulogd2-flat.sql
index d71608c65f7f..6d663f6e035d 100644
--- a/doc/mysql-ulogd2-flat.sql
+++ b/doc/mysql-ulogd2-flat.sql
@@ -51,7 +51,7 @@ CREATE TABLE `ulog2` (
   `raw_label` tinyint(3) unsigned default NULL,
   `mac_saddr_str` varchar(32) default NULL,
   `mac_daddr_str` varchar(32) default NULL,
-  `oob_protocol` smallint(5) default NULL,
+  `oob_protocol` smallint(5) unsigned default NULL,
   `raw_type` int(10) unsigned default NULL,
   `mac_str` varchar(255) default NULL,
   `tcp_sport` int(5) unsigned default NULL,
diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index c44f9a9db1e4..782f3689dc0b 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -84,7 +84,7 @@ CREATE TABLE `mac` (
   `_mac_id` bigint unsigned NOT NULL auto_increment,
   `mac_saddr` varchar(32) default NULL,
   `mac_daddr` varchar(32) default NULL,
-  `mac_protocol` smallint(5) default NULL,
+  `mac_protocol` smallint(5) unsigned default NULL,
   UNIQUE KEY `key_id` (`_mac_id`)
 ) ENGINE=INNODB;
 
@@ -681,7 +681,7 @@ delimiter $$
 CREATE FUNCTION INSERT_OR_SELECT_MAC(
 		`_saddr` varchar(32),
 		`_daddr` varchar(32),
-		`_protocol` smallint(5)
+		`_protocol` smallint(5) unsigned
 		) RETURNS bigint unsigned
 NOT DETERMINISTIC
 READS SQL DATA
@@ -764,7 +764,7 @@ CREATE FUNCTION INSERT_PACKET_FULL(
                 raw_header varchar(256),
 		mac_saddr varchar(32),
 		mac_daddr varchar(32),
-		mac_protocol smallint(5),
+		mac_protocol smallint(5) unsigned,
 		_label tinyint(4) unsigned,
 		sctp_sport smallint(5) unsigned,
 		sctp_dport smallint(5) unsigned,
-- 
2.35.1

