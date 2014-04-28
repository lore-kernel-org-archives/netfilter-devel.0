From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftnl PATCH] common: fix unconditional output of event wrapping
	stuff
Date: Mon, 28 Apr 2014 12:58:38 +0200
Message-ID: <20140428105837.18312.91126.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36678 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755128AbaD1K6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:58:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can't unconditionally print out these strings.

Before this patch, objects being printed will be treated as an 'unkown' event.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/common.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/common.c b/src/common.c
index 929f25d..52e5f0e 100644
--- a/src/common.c
+++ b/src/common.c
@@ -72,6 +72,9 @@ int nft_event_header_snprintf(char *buf, size_t size, uint32_t type,
 {
 	int ret = 0;
 
+	if (!(flags & NFT_OF_EVENT_ANY))
+		return 0;
+
 	switch (type) {
 	case NFT_OUTPUT_XML:
 		if (flags & NFT_OF_EVENT_NEW) {

