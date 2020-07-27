Return-Path: <SRS0=nQ4N=BG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA74C433EC
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 10:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE212078A
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 10:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="CyoIeA09"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgG0Kbr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 06:31:47 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52620 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgG0Kbq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 06:31:46 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BFbhK43LBzFf23
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 03:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1595845905; bh=4CZLS+MR/DVutLmA1ADPcGZ2JPZsk8SIVAPOjYWbD7Y=;
        h=From:To:Subject:Date:From;
        b=CyoIeA09/1yB5VJXAFnrNnqR22fwVLZM9DeuH4MIX4SPVHvjjY3SCTxWPskAqQx3u
         2piPvtUxY9p0mBxHWC9W9yaLs+Imvb1XZL1jQO7XAB73hy4UASH5XcHHQcyMLs/tXd
         Xy6DLDxAKPThvimcNHcpLIlZxfDVPXynaMxVQO4Y=
X-Riseup-User-ID: 934F5B3F162D9E5084D6BC55408720878F8B675D00A2C83F4493A854AA0B468C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4BFbhJ5wsHzJml0
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2020 03:31:44 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] examples: add support for NF_PROTO_INET family
Date:   Mon, 27 Jul 2020 12:31:08 +0200
Message-Id: <20200727103107.64358-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add missing support for "inet" family for a handful of examples where
applicable.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 examples/nft-chain-add.c           | 4 +++-
 examples/nft-chain-del.c           | 4 +++-
 examples/nft-chain-get.c           | 4 +++-
 examples/nft-ct-timeout-add.c      | 4 +++-
 examples/nft-flowtable-add.c       | 4 +++-
 examples/nft-flowtable-del.c       | 4 +++-
 examples/nft-flowtable-get.c       | 4 +++-
 examples/nft-map-add.c             | 2 ++
 examples/nft-obj-add.c             | 4 +++-
 examples/nft-obj-del.c             | 4 +++-
 examples/nft-obj-get.c             | 4 +++-
 examples/nft-rule-add.c            | 4 +++-
 examples/nft-rule-ct-helper-add.c  | 4 +++-
 examples/nft-rule-ct-timeout-add.c | 4 +++-
 examples/nft-rule-del.c            | 4 +++-
 examples/nft-rule-get.c            | 4 +++-
 examples/nft-set-add.c             | 4 +++-
 examples/nft-set-del.c             | 4 +++-
 examples/nft-set-elem-add.c        | 4 +++-
 examples/nft-set-elem-del.c        | 4 +++-
 examples/nft-set-elem-get.c        | 4 +++-
 examples/nft-set-get.c             | 4 +++-
 examples/nft-table-add.c           | 4 +++-
 examples/nft-table-del.c           | 4 +++-
 examples/nft-table-get.c           | 4 +++-
 examples/nft-table-upd.c           | 4 +++-
 26 files changed, 77 insertions(+), 25 deletions(-)

diff --git a/examples/nft-chain-add.c b/examples/nft-chain-add.c
index cde4c97..f711e09 100644
--- a/examples/nft-chain-add.c
+++ b/examples/nft-chain-add.c
@@ -79,12 +79,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-chain-del.c b/examples/nft-chain-del.c
index 9956009..bcc714e 100644
--- a/examples/nft-chain-del.c
+++ b/examples/nft-chain-del.c
@@ -56,12 +56,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-chain-get.c b/examples/nft-chain-get.c
index 4e3b3c1..8a6ef91 100644
--- a/examples/nft-chain-get.c
+++ b/examples/nft-chain-get.c
@@ -67,6 +67,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -74,7 +76,7 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "unspec") == 0)
 		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-ct-timeout-add.c b/examples/nft-ct-timeout-add.c
index 913290f..4c2052e 100644
--- a/examples/nft-ct-timeout-add.c
+++ b/examples/nft-ct-timeout-add.c
@@ -31,12 +31,14 @@ static struct nftnl_obj *obj_add_parse(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		return NULL;
 	}
 
diff --git a/examples/nft-flowtable-add.c b/examples/nft-flowtable-add.c
index f42d206..5ca62be 100644
--- a/examples/nft-flowtable-add.c
+++ b/examples/nft-flowtable-add.c
@@ -59,12 +59,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-flowtable-del.c b/examples/nft-flowtable-del.c
index 4866ea2..91e5d3a 100644
--- a/examples/nft-flowtable-del.c
+++ b/examples/nft-flowtable-del.c
@@ -45,12 +45,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-flowtable-get.c b/examples/nft-flowtable-get.c
index 0d92fff..38929f3 100644
--- a/examples/nft-flowtable-get.c
+++ b/examples/nft-flowtable-get.c
@@ -56,6 +56,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -63,7 +65,7 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "unspec") == 0)
 		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-map-add.c b/examples/nft-map-add.c
index d87d841..7c6eeb9 100644
--- a/examples/nft-map-add.c
+++ b/examples/nft-map-add.c
@@ -74,6 +74,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
diff --git a/examples/nft-obj-add.c b/examples/nft-obj-add.c
index 83941c4..f526b3c 100644
--- a/examples/nft-obj-add.c
+++ b/examples/nft-obj-add.c
@@ -27,12 +27,14 @@ static struct nftnl_obj *obj_add_parse(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		return NULL;
 	}
 
diff --git a/examples/nft-obj-del.c b/examples/nft-obj-del.c
index 0aa63c0..ae4f703 100644
--- a/examples/nft-obj-del.c
+++ b/examples/nft-obj-del.c
@@ -29,12 +29,14 @@ static struct nftnl_obj *obj_del_parse(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		return NULL;
 	}
 
diff --git a/examples/nft-obj-get.c b/examples/nft-obj-get.c
index 87be3b4..e560ed0 100644
--- a/examples/nft-obj-get.c
+++ b/examples/nft-obj-get.c
@@ -65,6 +65,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -72,7 +74,7 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "unspec") == 0)
 		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
index 9780515..77ee480 100644
--- a/examples/nft-rule-add.c
+++ b/examples/nft-rule-add.c
@@ -137,8 +137,10 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-rule-ct-helper-add.c b/examples/nft-rule-ct-helper-add.c
index 632cc5c..e0338a8 100644
--- a/examples/nft-rule-ct-helper-add.c
+++ b/examples/nft-rule-ct-helper-add.c
@@ -89,8 +89,10 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-rule-ct-timeout-add.c b/examples/nft-rule-ct-timeout-add.c
index d3f843e..d93cde1 100644
--- a/examples/nft-rule-ct-timeout-add.c
+++ b/examples/nft-rule-ct-timeout-add.c
@@ -89,8 +89,10 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-rule-del.c b/examples/nft-rule-del.c
index fee3011..035aaa2 100644
--- a/examples/nft-rule-del.c
+++ b/examples/nft-rule-del.c
@@ -48,12 +48,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-rule-get.c b/examples/nft-rule-get.c
index 8a980ef..8fb654f 100644
--- a/examples/nft-rule-get.c
+++ b/examples/nft-rule-get.c
@@ -91,6 +91,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -98,7 +100,7 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "unspec") == 0)
 		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-set-add.c b/examples/nft-set-add.c
index d8e3e4e..c9e249d 100644
--- a/examples/nft-set-add.c
+++ b/examples/nft-set-add.c
@@ -70,12 +70,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-set-del.c b/examples/nft-set-del.c
index 7f20e21..eafd5d7 100644
--- a/examples/nft-set-del.c
+++ b/examples/nft-set-del.c
@@ -46,12 +46,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-set-elem-add.c b/examples/nft-set-elem-add.c
index 438966f..4b8b37c 100644
--- a/examples/nft-set-elem-add.c
+++ b/examples/nft-set-elem-add.c
@@ -48,12 +48,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-set-elem-del.c b/examples/nft-set-elem-del.c
index 157fbcf..b569fea 100644
--- a/examples/nft-set-elem-del.c
+++ b/examples/nft-set-elem-del.c
@@ -48,12 +48,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-set-elem-get.c b/examples/nft-set-elem-get.c
index 778e40f..52cdd51 100644
--- a/examples/nft-set-elem-get.c
+++ b/examples/nft-set-elem-get.c
@@ -70,12 +70,14 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-set-get.c b/examples/nft-set-get.c
index bb33674..cbe3f85 100644
--- a/examples/nft-set-get.c
+++ b/examples/nft-set-get.c
@@ -70,6 +70,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -77,7 +79,7 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "unspec") == 0)
 		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-table-add.c b/examples/nft-table-add.c
index 4418a51..5b5c1dd 100644
--- a/examples/nft-table-add.c
+++ b/examples/nft-table-add.c
@@ -29,12 +29,14 @@ static struct nftnl_table *table_add_parse(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		return NULL;
 	}
 
diff --git a/examples/nft-table-del.c b/examples/nft-table-del.c
index aa1827d..3d78fd4 100644
--- a/examples/nft-table-del.c
+++ b/examples/nft-table-del.c
@@ -29,12 +29,14 @@ static struct nftnl_table *table_del_parse(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
 		family = NFPROTO_ARP;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp\n");
 		return NULL;
 	}
 
diff --git a/examples/nft-table-get.c b/examples/nft-table-get.c
index c0c8454..64fd66c 100644
--- a/examples/nft-table-get.c
+++ b/examples/nft-table-get.c
@@ -65,6 +65,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -72,7 +74,7 @@ int main(int argc, char *argv[])
 	else if (strcmp(argv[1], "unspec") == 0)
 		family = NFPROTO_UNSPEC;
 	else {
-		fprintf(stderr, "Unknown family: ip, ip6, bridge, arp, unspec\n");
+		fprintf(stderr, "Unknown family: ip, ip6, inet, bridge, arp, unspec\n");
 		exit(EXIT_FAILURE);
 	}
 
diff --git a/examples/nft-table-upd.c b/examples/nft-table-upd.c
index 1c7f9b3..663d09f 100644
--- a/examples/nft-table-upd.c
+++ b/examples/nft-table-upd.c
@@ -51,6 +51,8 @@ int main(int argc, char *argv[])
 		family = NFPROTO_IPV4;
 	else if (strcmp(argv[1], "ip6") == 0)
 		family = NFPROTO_IPV6;
+	else if (strcmp(argv[1], "inet") == 0)
+		family = NFPROTO_INET;
 	else if (strcmp(argv[1], "bridge") == 0)
 		family = NFPROTO_BRIDGE;
 	else if (strcmp(argv[1], "arp") == 0)
@@ -59,7 +61,7 @@ int main(int argc, char *argv[])
 		family = NFPROTO_NETDEV;
 	else {
 		fprintf(stderr,
-			"Unknown family: ip, ip6, bridge, arp, netdev\n");
+			"Unknown family: ip, ip6, inet, bridge, arp, netdev\n");
 		exit(EXIT_FAILURE);
 	}
 
-- 
2.27.0

