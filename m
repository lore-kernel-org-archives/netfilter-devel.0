From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH 1/4] nft: add builtin_table pointer
Date: Wed, 17 Jul 2013 00:30:32 +0200
Message-ID: <20130716223032.13253.63927.stgit@nftables>
References: <20130716222925.13253.93123.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f171.google.com ([209.85.215.171]:42066 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3GVObt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:31:49 -0400
Received: by mail-ea0-f171.google.com with SMTP id m14so3904690eaj.30
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2013 07:31:48 -0700 (PDT)
Received: from [127.0.1.1] ([37.77.121.31])
        by mx.google.com with ESMTPSA id b7sm51125467eef.16.2013.07.22.07.31.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 22 Jul 2013 07:31:47 -0700 (PDT)
In-Reply-To: <20130716222925.13253.93123.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   20 ++------------------
 iptables/nft.h |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4d6a7a3..02c12f6 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -80,24 +80,7 @@ static int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	return 0;
 }
 
-#define FILTER		0
-#define MANGLE		1
-#define RAW		2
-#define SECURITY	3
-#define NAT		4
-#define TABLES_MAX	5
-
-struct builtin_chain {
-	const char *name;
-	const char *type;
-	uint32_t prio;
-	uint32_t hook;
-};
-
-static struct builtin_table {
-	const char *name;
-	struct builtin_chain chains[NF_INET_NUMHOOKS];
-} tables[TABLES_MAX] = {
+static struct builtin_table tables[TABLES_MAX] = {
 	[RAW] = {
 		.name	= "raw",
 		.chains = {
@@ -402,6 +385,7 @@ int nft_init(struct nft_handle *h)
 		return -1;
 	}
 	h->portid = mnl_socket_get_portid(h->nl);
+	h->tables = tables;
 
 	return 0;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 7a6351b..39ed7c0 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -4,6 +4,25 @@
 #include "xshared.h"
 #include "nft-shared.h"
 
+#define FILTER		0
+#define MANGLE		1
+#define RAW		2
+#define SECURITY	3
+#define NAT		4
+#define TABLES_MAX	5
+
+struct builtin_chain {
+	const char *name;
+	const char *type;
+	uint32_t prio;
+	uint32_t hook;
+};
+
+struct builtin_table {
+	const char *name;
+	struct builtin_chain chains[NF_INET_NUMHOOKS];
+};
+
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
@@ -11,6 +30,7 @@ struct nft_handle {
 	uint32_t		seq;
 	bool			commit;
 	struct nft_family_ops	*ops;
+	struct builtin_table	*tables;
 };
 
 int nft_init(struct nft_handle *h);

