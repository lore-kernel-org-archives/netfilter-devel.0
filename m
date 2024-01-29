Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7DB24B57
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706555148; cv=none; b=FStcSlyoUuG43/i+6xsrq5Tjy2LWwj37RPHIzDFL7MFkzy/AMnSvtjIWNxdF3wR6c8VSoxKFyTRx7BsyJoQd/dZr6Cb2ZrV6KhdfueOswWPEonUxtaZbm2BaFGyA01ODPMTdLnckFrD39lxaafeXSDOMxYJ9G6CuRjeRe05Ygwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706555148; c=relaxed/simple;
	bh=cH7jq5GvRT6X5v+HRP6H6WEeAi9Inh2m1L+NtIUOdus=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a9SLYjehPL+mPeZF0hUwaDeD86oi9PqusmtuoA5SWrB1wovCeG0HLYJzBRyuoW58Hl4Jff5KbBVHPzjr10/hCkSJ3RvmvxVrIMCas8R8+gTyzyEcYlqOEYLykmEE0wknuHXsqKW3yR9FUXY9uZ74KLNbv3/Kc897F1W0Nn6iyf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nft_ct: bail out if helper is not found for NFPROTO_{IPV4,IPV6}
Date: Mon, 29 Jan 2024 20:05:38 +0100
Message-Id: <20240129190538.147822-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, this assigns the NULL helper. Bail out from control plane path
if the kernel does not provide this helper.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 715a154f243c..6f7e49752bfa 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1077,6 +1077,8 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 
 		help4 = nf_conntrack_helper_try_module_get(name, family,
 							   priv->l4proto);
+		if (!help4)
+			return -ENOENT;
 		break;
 	case NFPROTO_IPV6:
 		if (ctx->family == NFPROTO_IPV4)
@@ -1084,6 +1086,8 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 
 		help6 = nf_conntrack_helper_try_module_get(name, family,
 							   priv->l4proto);
+		if (!help6)
+			return -ENOENT;
 		break;
 	case NFPROTO_NETDEV:
 	case NFPROTO_BRIDGE:
@@ -1092,15 +1096,14 @@ static int nft_ct_helper_obj_init(const struct nft_ctx *ctx,
 							   priv->l4proto);
 		help6 = nf_conntrack_helper_try_module_get(name, NFPROTO_IPV6,
 							   priv->l4proto);
+		/* && is intentional; only error if INET found neither ipv4 or ipv6 */
+		if (!help4 && !help6)
+			return -ENOENT;
 		break;
 	default:
 		return -EAFNOSUPPORT;
 	}
 
-	/* && is intentional; only error if INET found neither ipv4 or ipv6 */
-	if (!help4 && !help6)
-		return -ENOENT;
-
 	priv->helper4 = help4;
 	priv->helper6 = help6;
 
-- 
2.30.2

