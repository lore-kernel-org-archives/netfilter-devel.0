Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E4021EABDB
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785779; cv=none; b=E4e1eF4RqqFcaFDrxiWmFM/sKwgju3NtUnO7ILBjgHNuGK80K5gkWmqy9RU2SK7jVzhGVbZFIVCgalPXma6z9biAWWnk1mCoCWEitTiXMYKVWuus9YRBJHpVpbWqrazkKOqXR3VJieS+zlEiAndfEchbt3ztA9DiwqzZcxx/AZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785779; c=relaxed/simple;
	bh=PobYiVIDXZbWRVSyS9/4jLEUE0VpP86Xtfrhsbafd+M=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=T11r/NYN+cRbPJ1Cyy3gC2WwEpqvIwBP5683oV1mZ6tPRHVAcoO3adUirNqYCVUSq5bPyx+0nVZHLTaa1pwFHlYbSwf/XX9tBNcZE+8u69jws1poz5yaN0m9+G/c8K5xoUD01YP2aqEpvPcEtsMUsiPeC2pGvrhuj6C3qluYplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 1/4] mnl: rename to mnl_seqnum_alloc() to mnl_seqnum_inc()
Date: Thu, 24 Oct 2024 18:02:47 +0200
Message-Id: <20241024160250.871045-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rename mnl_seqnum_alloc() to mnl_seqnum_inc().

No functional change is intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/mnl.h     | 2 +-
 src/libnftables.c | 6 +++---
 src/mnl.c         | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/mnl.h b/include/mnl.h
index c9502f328f1c..7c465d4426c4 100644
--- a/include/mnl.h
+++ b/include/mnl.h
@@ -8,7 +8,7 @@
 
 struct mnl_socket *nft_mnl_socket_open(void);
 
-uint32_t mnl_seqnum_alloc(uint32_t *seqnum);
+uint32_t mnl_seqnum_inc(uint32_t *seqnum);
 uint32_t mnl_genid_get(struct netlink_ctx *ctx);
 
 struct mnl_err {
diff --git a/src/libnftables.c b/src/libnftables.c
index 2834c9922486..3550961d5d0e 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -37,9 +37,9 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (list_empty(cmds))
 		goto out;
 
-	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
+	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_inc(&seqnum));
 	list_for_each_entry(cmd, cmds, list) {
-		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
+		ctx.seqnum = cmd->seqnum = mnl_seqnum_inc(&seqnum);
 		ret = do_command(&ctx, cmd);
 		if (ret < 0) {
 			netlink_io_error(&ctx, &cmd->location,
@@ -50,7 +50,7 @@ static int nft_netlink(struct nft_ctx *nft,
 		num_cmds++;
 	}
 	if (!nft->check)
-		mnl_batch_end(ctx.batch, mnl_seqnum_alloc(&seqnum));
+		mnl_batch_end(ctx.batch, mnl_seqnum_inc(&seqnum));
 
 	if (!mnl_batch_ready(ctx.batch))
 		goto out;
diff --git a/src/mnl.c b/src/mnl.c
index db53a60b43cb..c1691da2e51b 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -70,7 +70,7 @@ struct mnl_socket *nft_mnl_socket_open(void)
 	return nf_sock;
 }
 
-uint32_t mnl_seqnum_alloc(unsigned int *seqnum)
+uint32_t mnl_seqnum_inc(unsigned int *seqnum)
 {
 	return (*seqnum)++;
 }
-- 
2.30.2

