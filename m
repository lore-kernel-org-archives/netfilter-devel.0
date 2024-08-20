Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6C41BE228
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2024 22:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724192025; cv=none; b=iOBISt82jedSVpo1TjjPQQqgbPFCCFpjtquDnyk/m9uTv4L8asenjQWdLnpvp1pqdWJpU+jS6koTBNA4JJiQjVpiPBL1ESZdfEu5pxlwrDSog7vDibn4A1aC54yZlBjoVWAVgrrO9MITQN3CBfdVDHUyCGnWGbtyXWIQenWUeyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724192025; c=relaxed/simple;
	bh=icVLD/6IDnkO2o/Pz4Lw3NGyBOUfEhoTEFAy69isMqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etJ3HdwOVjC3tWzsRuBIlMhMHfZmZlq/DnmONE9p76i0uaQeMqmBBYDRV9TWHJ/xa6LffVuSvMga2ZteV2UKsuwnY00jRKxyuCchzUoDcsMLCx5JyUVShSFiiW0/UMAl2qq5BJ+RrwhdVnkx/Re4QObVTlJ7zje68/755w2OyCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sgX6d-0002Mi-Rw; Wed, 21 Aug 2024 00:13:35 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] src: mnl: prepare for listing all device netdev device hooks
Date: Wed, 21 Aug 2024 00:12:26 +0200
Message-ID: <20240820221230.7014-2-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <20240820221230.7014-1-fw@strlen.de>
References: <20240820221230.7014-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change output foramt slightly so device name is included for netdev
family.

% nft list hooks netdev device eth0
family netdev {
        hook ingress device eth0 {
                 0000000000 chain inet ingress in_public [nf_tables]
                 0000000000 chain netdev ingress in_public [nf_tables]
        }
        hook egress device eth0 {
                 0000000000 chain netdev ingress out_public [nf_tables]
        }
}

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index 3cacb47e7242..e585241d9395 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -45,6 +45,7 @@ struct basehook {
 	const char *hookfn;
 	const char *table;
 	const char *chain;
+	const char *devname;
 	int family;
 	int chain_family;
 	uint32_t num;
@@ -2179,9 +2180,24 @@ static void basehook_free(struct basehook *b)
 	free_const(b->hookfn);
 	free_const(b->chain);
 	free_const(b->table);
+	free_const(b->devname);
 	free(b);
 }
 
+static bool basehook_eq(const struct basehook *prev, const struct basehook *hook)
+{
+	if (prev->num != hook->num)
+		return false;
+
+	if (prev->devname != NULL && hook->devname != NULL)
+		return strcmp(prev->devname, hook->devname) == 0;
+
+	if (prev->devname == NULL && prev->devname == NULL)
+		return true;
+
+	return false;
+}
+
 static void basehook_list_add_tail(struct basehook *b, struct list_head *head)
 {
 	struct basehook *hook;
@@ -2310,6 +2326,7 @@ static int dump_nf_attr_bpf_cb(const struct nlattr *attr, void *data)
 
 struct dump_nf_hook_data {
 	struct list_head *hook_list;
+	const char *devname;
 	int family;
 };
 
@@ -2331,6 +2348,7 @@ static int dump_nf_hooks(const struct nlmsghdr *nlh, void *_data)
 
 	hook = basehook_alloc();
 	hook->prio = ntohl(mnl_attr_get_u32(tb[NFNLA_HOOK_PRIORITY]));
+	hook->devname = data->devname ? xstrdup(data->devname) : NULL;
 
 	if (tb[NFNLA_HOOK_FUNCTION_NAME])
 		hook->hookfn = xstrdup(mnl_attr_get_str(tb[NFNLA_HOOK_FUNCTION_NAME]));
@@ -2420,6 +2438,7 @@ static int __mnl_nft_dump_nf_hooks(struct netlink_ctx *ctx, uint8_t query_family
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct dump_nf_hook_data data = {
 		.hook_list	= hook_list,
+		.devname	= devname,
 		.family		= query_family,
 	};
 	struct nlmsghdr *nlh;
@@ -2459,7 +2478,7 @@ static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *h
 			continue;
 
 		if (prev) {
-			if (prev->num == hook->num) {
+			if (basehook_eq(prev, hook)) {
 				fprintf(fp, "\n");
 				same = true;
 			} else {
@@ -2472,8 +2491,12 @@ static void print_hooks(struct netlink_ctx *ctx, int family, struct list_head *h
 		prev = hook;
 
 		if (!same) {
-			fprintf(fp, "\thook %s {\n",
-				hooknum2str(family, hook->num));
+			if (hook->devname)
+				fprintf(fp, "\thook %s device %s {\n",
+					hooknum2str(family, hook->num), hook->devname);
+			else
+				fprintf(fp, "\thook %s {\n",
+					hooknum2str(family, hook->num));
 		}
 
 		prio = hook->prio;
-- 
2.44.2

