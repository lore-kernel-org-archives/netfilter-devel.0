Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4604916F830;
	Mon, 12 Aug 2024 10:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458472; cv=none; b=XxWiM8+HfvWa3B26xRZ5dnnC6/Et5b2RO53uUkA3IpN8bQksMat+oB8TH8gTPz+l7HyeexgRDkOLVlDjU6vlGX/n9fTsdF9nQSQvKKOT+NvdYIkeQkrXLiKB5b8j2qUw6IR/lTuuw6oydVoVLl860Yi3lqPuVrluLe2MjBF4/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458472; c=relaxed/simple;
	bh=Jq3JLVyj75cTcLQWBedzHo9C7GYkKCwZnfxNCnvBRSk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RSExUxZQD+zsFXlpK12rW6OxI8q7RG0g4xdqy3byPvpiqFUJNa7jf/YorDe9n1wO0a51m18eQcwYW9q0nCgRcqCN4F9A8Yd+svvyzGm3j0aYBI1j/4UzBWfHpBVyRPszPr6bd66EJMXAFDuZ1Yg5aTsSiFKKWu9Qawjubwvm/UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10.x 1/4] netfilter: nf_tables: set element extended ACK reporting support
Date: Mon, 12 Aug 2024 12:27:39 +0200
Message-Id: <20240812102742.388214-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102742.388214-1-pablo@netfilter.org>
References: <20240812102742.388214-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit b53c116642502b0c85ecef78bff4f826a7dd4145 upstream.

Report the element that causes problems via netlink extended ACK for set
element commands.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f4bbddfbbc24..0bc92edb7827 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5354,8 +5354,10 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 
 	return err;
@@ -5848,8 +5850,10 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			return err;
+		}
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -6058,9 +6062,10 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
-
+		}
 		set->ndeact++;
 	}
 	return err;
-- 
2.30.2

