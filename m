From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/4] Add implementation for to proof the JSON
 export function
Date: Thu, 06 Jun 2013 15:17:18 +0200
Message-ID: <20130606131718.18048.66723.stgit@Ph0enix>
References: <20130606131706.18048.11297.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: julien@linuxwall.info
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35562 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3FFNRY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:17:24 -0400
Received: by mail-wg0-f41.google.com with SMTP id k13so329596wgh.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 06:17:23 -0700 (PDT)
In-Reply-To: <20130606131706.18048.11297.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---
 examples/nft-table-get.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index b113636..0d7746c 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -59,6 +59,10 @@ int main(int argc, char *argv[])
 		type = NFT_TABLE_O_XML;
 		argv[argc-1] = NULL;
 		argc--;
+	}else if (strcmp(argv[argc-1], "json") == 0) {
+		type = NFT_TABLE_O_JSON;
+		argv[argc-1] = NULL;
+		argc--;
 	} else if (strcmp(argv[argc - 1], "default") == 0) {
 		argc--;
 	}

