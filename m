Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3194922126D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 12:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755693895; cv=none; b=kglcF7cB/8tuaGfO4/VO0NdlGy7pZESaGTmSMrjtkFvFbI2YRYNJ9K+QQCXl6muICMnn0yIlKMIgz6njHDH3b850+SyWE9Nnjv71vOKZ5p0vdqigeE61Q/orfJTt33Rphk9U+w+YyA3+b4nR0/xvCWAnQVaG/S7/PiScxXqH8HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755693895; c=relaxed/simple;
	bh=QF8etbJ6NpR72ej8/fDZhVQYt0GyA3wJuXLKgTWZ6G0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tfd1vXLd+9ELXNjZjIZXNmxt7qtVUYwUDEtEnYYpJowxImoW/RNffBd8s90jasH97GDT2jsUhb+Ys5q6PZhTOfli8GE/9qXGyZQOzzGklj0P1MyprIs4HOgN9/gziXhv4/vvE+M3dGteE5l0YEuUZ4h0dtp5OZCO8QQKqlIH5xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 19BEA601EB; Wed, 20 Aug 2025 14:44:52 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] mnl: silence compiler warning
Date: Wed, 20 Aug 2025 14:44:43 +0200
Message-ID: <20250820124447.31695-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

gcc 14.3.0 reports this:

src/mnl.c: In function 'mnl_nft_chain_add':
src/mnl.c:916:25: warning: 'nest' may be used uninitialized [-Wmaybe-uninitialized]
  916 |                         mnl_attr_nest_end(nlh, nest);

I guess its because compiler can't know that the conditions cannot change
in-between and assumes nest_end() can be called without nest_start().

Fixes: 01277922fede ("src: ensure chain policy evaluation when specified")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/mnl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index ceb43b06690c..6684029606e5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -890,7 +890,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 	nftnl_chain_nlmsg_build_payload(nlh, nlc);
 
 	if (cmd->chain && cmd->chain->flags & CHAIN_F_BASECHAIN) {
-		struct nlattr *nest;
+		struct nlattr *nest = NULL;
 
 		if (cmd->chain->type.str) {
 			cmd_add_loc(cmd, nlh, &cmd->chain->type.loc);
@@ -911,8 +911,7 @@ int mnl_nft_chain_add(struct netlink_ctx *ctx, struct cmd *cmd,
 		if (cmd->chain && cmd->chain->dev_expr)
 			mnl_nft_chain_devs_build(nlh, cmd);
 
-		if (cmd->chain->type.str ||
-		    (cmd->chain && cmd->chain->dev_expr))
+		if (nest)
 			mnl_attr_nest_end(nlh, nest);
 	}
 
-- 
2.49.1

