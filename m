Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDA841D1E68
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785778; cv=none; b=ZwvC7Io1B7eR03eqYtCuVDaQmSDt6USJVKcqQKWZvSX4DB+9tevLdMtBoJtMkWR6hw3rjU78/cYdJcJOZTAe2AB4xaRyiEW9MwvvMLHSCgSAJK9RDaFBOllT7Jt+l/BNeq1DIMll9I+FWEisSeQcqINpO3aen18bX4Vnj6YHb9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785778; c=relaxed/simple;
	bh=RQ/vL190qJtOMX1ifH+OCfhXucvTzj1geBMUq++jscc=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V8H1VuR49e09kodevbZ8I0upAN677RjocSmi7Ga08K12va6RSvBsgaQuNeF/n+JyAa3z7C4Wek+8X8cDzO36SZ8eD6YPLomgHAY5MWrYL6M1J9p0mjQkvuDGd0wsED7kRd4ZhaeEaD+4OEbNTCGGwd77wCfLhjsWLYv/w5I++Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 3/4] rule: netlink attribute offset is uint32_t for struct nlerr_loc
Date: Thu, 24 Oct 2024 18:02:49 +0200
Message-Id: <20241024160250.871045-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241024160250.871045-1-pablo@netfilter.org>
References: <20241024160250.871045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The maximum netlink message length (nlh->nlmsg_len) is uint32_t, struct
nlerr_loc stores the offset to the netlink attribute which must be
uint32_t, not uint16_t.

While at it, remove check for zero netlink attribute offset in
nft_cmd_error() which should not ever happen, likely this check was
there to prevent the uint16_t offset overflow.

Fixes: f8aec603aa7e ("src: initial extended netlink error reporting")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: remove check for zero offset in nft_cmd_error().

 include/rule.h | 2 +-
 src/cmd.c      | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/rule.h b/include/rule.h
index a1628d82d275..3fcfa445d103 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -695,7 +695,7 @@ void monitor_free(struct monitor *m);
 #define NFT_NLATTR_LOC_MAX 32
 
 struct nlerr_loc {
-	uint16_t		offset;
+	uint32_t		offset;
 	const struct location	*location;
 };
 
diff --git a/src/cmd.c b/src/cmd.c
index 78a2aa3025ed..0c7a43edd73a 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -323,8 +323,6 @@ void nft_cmd_error(struct netlink_ctx *ctx, struct cmd *cmd,
 	uint32_t i;
 
 	for (i = 0; i < cmd->num_attrs; i++) {
-		if (!cmd->attr[i].offset)
-			break;
 		if (cmd->attr[i].offset == err->offset)
 			loc = cmd->attr[i].location;
 	}
-- 
2.30.2

