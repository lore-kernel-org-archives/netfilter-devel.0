From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 3/4] Add JSON Constant for to use the Json export
 function
Date: Thu, 06 Jun 2013 15:17:25 +0200
Message-ID: <20130606131725.18048.26908.stgit@Ph0enix>
References: <20130606131706.18048.11297.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: julien@linuxwall.info
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:54930 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3FFNRb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:17:31 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so2008444wes.39
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 06:17:30 -0700 (PDT)
In-Reply-To: <20130606131706.18048.11297.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 0 files changed

diff --git a/include/libnftables/table.h b/include/libnftables/table.h
index 658230c..19f322c 100644
--- a/include/libnftables/table.h
+++ b/include/libnftables/table.h
@@ -31,6 +31,7 @@ void nft_table_nlmsg_build_payload(struct nlmsghdr *nlh, const struct nft_table
 enum {
 	NFT_TABLE_O_DEFAULT	= 0,
 	NFT_TABLE_O_XML,
+	NFT_TABLE_O_JSON,
 };
 
 enum nft_table_parse_type {

