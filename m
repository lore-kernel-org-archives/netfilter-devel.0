From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 2/2] Add implementation for to proof the JSON
 export function
Date: Fri, 07 Jun 2013 11:14:23 +0200
Message-ID: <20130607091423.13002.25109.stgit@Ph0enix>
References: <20130607091043.13002.66552.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:60229 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549Ab3FGJO0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:14:26 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so2826539wes.39
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jun 2013 02:14:24 -0700 (PDT)
Received: from [127.0.1.1] (85.136.70.56.dyn.user.ono.com. [85.136.70.56])
        by mx.google.com with ESMTPSA id fb9sm14206341wid.2.2013.06.07.02.14.23
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 07 Jun 2013 02:14:24 -0700 (PDT)
In-Reply-To: <20130607091043.13002.66552.stgit@Ph0enix>
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

