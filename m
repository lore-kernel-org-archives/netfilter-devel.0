From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2] iptables: update gitignore list
Date: Thu, 20 Aug 2015 08:21:53 -0400
Message-ID: <1440073313-23936-1-git-send-email-vapier@gentoo.org>
References: <1440069182-21380-1-git-send-email-vapier@gentoo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:43262 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbbHTMVz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 08:21:55 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id C52B13409D7
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 12:21:54 +0000 (UTC)
In-Reply-To: <1440069182-21380-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 iptables/.gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/.gitignore b/iptables/.gitignore
index 6c0ade1..7438ad1 100644
--- a/iptables/.gitignore
+++ b/iptables/.gitignore
@@ -7,9 +7,12 @@
 /iptables-extensions.8
 /iptables-extensions.8.tmpl
 /iptables-save
+/iptables-save.8
 /iptables-restore
+/iptables-restore.8
 /iptables-static
 /iptables-xml
+/iptables-xml.1
 /xtables-multi
 /xtables-config-parser.c
 /xtables-config-parser.h
-- 
2.4.4

