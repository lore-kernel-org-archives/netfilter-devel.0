From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 1/4] Fix SQL field naming.
Date: Tue,  1 Apr 2008 01:09:47 +0200
Message-ID: <12070049902421-git-send-email-eric@inl.fr>
References: <1207004990315-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:41722 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751094AbYCaXJw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Mar 2008 19:09:52 -0400
In-Reply-To: <1207004990315-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

SQL fields were not correctly named from ulogd key.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 doc/mysql-ulogd2.sql |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
index 304173b..6368dc7 100644
--- a/doc/mysql-ulogd2.sql
+++ b/doc/mysql-ulogd2.sql
@@ -297,8 +297,8 @@ DROP VIEW IF EXISTS `conntrack`;
 CREATE SQL SECURITY INVOKER VIEW `conntrack` AS
 	SELECT _ct_id,
 	       oob_family,
-	       orig_ip_saddr AS orig_ip_saddr_raw,
-	       orig_ip_daddr AS orig_ip_daddr_raw,
+	       orig_ip_saddr AS orig_ip_saddr_bin,
+	       orig_ip_daddr AS orig_ip_daddr_bin,
 	       orig_ip_protocol,
 	       orig_l4_sport,
 	       orig_l4_dport,
-- 
1.5.2.5

