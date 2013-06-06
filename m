From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 4/4] Add a constant for to put the JSON Version
Date: Thu, 06 Jun 2013 15:17:32 +0200
Message-ID: <20130606131732.18048.62882.stgit@Ph0enix>
References: <20130606131706.18048.11297.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: julien@linuxwall.info
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:58796 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3FFNRi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:17:38 -0400
Received: by mail-we0-f173.google.com with SMTP id x54so1194956wes.32
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 06:17:37 -0700 (PDT)
In-Reply-To: <20130606131706.18048.11297.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 0 files changed

diff --git a/src/internal.h b/src/internal.h
index 3ad5e89..0c5de21 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -20,6 +20,7 @@
 #define NFT_TABLE_XML_VERSION 0
 #define NFT_CHAIN_XML_VERSION 0
 #define NFT_RULE_XML_VERSION 0
+#define NFT_TABLE_JSON_VERSION 0
 
 struct expr_ops;
 

