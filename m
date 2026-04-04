Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284C92F6904
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2026 10:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775297594; cv=none; b=JNwLAvZMeANbYmGuUsrGeb+qITLWEldRXszQfO6o/vnuNFiPSX+VcmpZ0yUynBEd130ZscsA7Ntb7erQlW7lv5F78KeWTc46gmUU45nKzL/kz/hfnWwuSCuCLi95UVaifLouiX5BMuuGI5CxyuNdNxwQTsL7Za9kEAxy1IQKKEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775297594; c=relaxed/simple;
	bh=ZrO5e1QVw9XDbYoZk9qRUVbp/U8W6JyaBDsAbkNnz/8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E7l0g/cEewYdsfTclGTLVm/KonUilmKuGOefv/hPGuq24LkpeQQWBTjuxIx8a+WtrrbA4eL/UbLR+Sk4YyqTiyl90LgJS+QedIQu93TOZJXO4JHF0ZRYYcJHuscPy0ixHKJfmncOFbbqNKGxqjXZJP8oJRs0CrecFv7W028zFow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3E1446079E; Sat, 04 Apr 2026 12:13:11 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: xt_socket: enable defrag after all other checks
Date: Sat,  4 Apr 2026 12:12:59 +0200
Message-ID: <20260404101303.19577-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Originally this did not matter because defag was enabled once per
namespace and only disabled again on netns dismantle.  When this got
changed I should have adjusted checkentry to not leve defrag enabled on
error.

Fixes: de8c12110a13 ("netfilter: disable defrag once its no longer needed")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Targetting nf-next because this isn't a regression per se.

 net/netfilter/xt_socket.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 76e01f292aaf..811e53bee408 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -168,52 +168,41 @@ static int socket_mt_enable_defrag(struct net *net, int family)
 static int socket_mt_v1_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo1 *info = (struct xt_socket_mtinfo1 *) par->matchinfo;
-	int err;
-
-	err = socket_mt_enable_defrag(par->net, par->family);
-	if (err)
-		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V1) {
 		pr_info_ratelimited("unknown flags 0x%x\n",
 				    info->flags & ~XT_SOCKET_FLAGS_V1);
 		return -EINVAL;
 	}
-	return 0;
+
+	return socket_mt_enable_defrag(par->net, par->family);
 }
 
 static int socket_mt_v2_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo2 *info = (struct xt_socket_mtinfo2 *) par->matchinfo;
-	int err;
-
-	err = socket_mt_enable_defrag(par->net, par->family);
-	if (err)
-		return err;
 
 	if (info->flags & ~XT_SOCKET_FLAGS_V2) {
 		pr_info_ratelimited("unknown flags 0x%x\n",
 				    info->flags & ~XT_SOCKET_FLAGS_V2);
 		return -EINVAL;
 	}
-	return 0;
+
+	return socket_mt_enable_defrag(par->net, par->family);
 }
 
 static int socket_mt_v3_check(const struct xt_mtchk_param *par)
 {
 	const struct xt_socket_mtinfo3 *info =
 				    (struct xt_socket_mtinfo3 *)par->matchinfo;
-	int err;
 
-	err = socket_mt_enable_defrag(par->net, par->family);
-	if (err)
-		return err;
 	if (info->flags & ~XT_SOCKET_FLAGS_V3) {
 		pr_info_ratelimited("unknown flags 0x%x\n",
 				    info->flags & ~XT_SOCKET_FLAGS_V3);
 		return -EINVAL;
 	}
-	return 0;
+
+	return socket_mt_enable_defrag(par->net, par->family);
 }
 
 static void socket_mt_destroy(const struct xt_mtdtor_param *par)
-- 
2.53.0

