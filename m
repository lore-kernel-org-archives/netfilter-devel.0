Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D97A191F99
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2024 11:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724931121; cv=none; b=KeBRiRoI3A4m8htY3PJVECC717hy8n/ajvdcJEb51/VZcrkcII03DU3XGX1dEP74mSh1zLVAZHf61rkjL0kVn6a3ggvvXo/oY0tVPW/fcPI/26mb9f8Me1EMzI5OpSQ1fHR04xtNtjncZrTVIxj2qUwSIEfm8AAC1F0NegJCAIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724931121; c=relaxed/simple;
	bh=kslY2IlgHraG2AcJZGwYcto6ogTjyWdWeSoZS+8EKfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CX7vfoyOQ3Ey8bxZyf+yLlGwZR7kKyMjuI3Sl2FN7Xma8KX6xTwTgmP/E/+sSZc/4BU/luKvFBtqHGoOFeEM7A4uwbr4zJXej46rHlbrjetvEeVtmPzOiXlw4FJKsP69mOHqFjaGr5KmqV1Mlcx64rIQo4anc47SUfGODvpJ9Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: eric@garver.life
Subject: [PATCH nft 2/5] cache: clean up evaluate_cache_del()
Date: Thu, 29 Aug 2024 13:31:50 +0200
Message-Id: <20240829113153.1553089-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240829113153.1553089-1-pablo@netfilter.org>
References: <20240829113153.1553089-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move NFT_CACHE_TABLE flag to default case to disentangle this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/cache.c b/src/cache.c
index 8cddabdb7b98..bed98bb71655 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -77,6 +77,7 @@ static unsigned int evaluate_cache_del(struct cmd *cmd, unsigned int flags)
 			 NFT_CACHE_SETELEM_MAYBE;
 		break;
 	default:
+		flags = NFT_CACHE_TABLE;
 		break;
 	}
 
@@ -500,8 +501,6 @@ int nft_cache_evaluate(struct nft_ctx *nft, struct list_head *cmds,
 			break;
 		case CMD_DELETE:
 		case CMD_DESTROY:
-			flags |= NFT_CACHE_TABLE;
-
 			flags = evaluate_cache_del(cmd, flags);
 			break;
 		case CMD_GET:
-- 
2.30.2

