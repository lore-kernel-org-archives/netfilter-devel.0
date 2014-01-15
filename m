From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables PATCH] ct: fix missing NFT_CT_L3PROTOCOL in
	ctkey2str_array
Date: Wed, 15 Jan 2014 19:18:46 +0100
Message-ID: <20140115181846.25192.17850.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57099 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752525AbaAOSS5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:18:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Due to missing NFT_CT_L3PROTOCOL key in ctkey2str_array, a segfault is
produced when the str2ctkey() loop reaches that position, since strcmp()
will try to compare a NULL value.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/expr/ct.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/expr/ct.c b/src/expr/ct.c
index 97f9dcc..e960134 100644
--- a/src/expr/ct.c
+++ b/src/expr/ct.c
@@ -151,6 +151,7 @@ const char *ctkey2str_array[NFT_CT_MAX] = {
 	[NFT_CT_SECMARK]	= "secmark",
 	[NFT_CT_EXPIRATION]	= "expiration",
 	[NFT_CT_HELPER]		= "helper",
+	[NFT_CT_L3PROTOCOL]	= "l3protocol",
 	[NFT_CT_PROTOCOL]	= "protocol",
 	[NFT_CT_SRC]		= "src",
 	[NFT_CT_DST]		= "dst",

