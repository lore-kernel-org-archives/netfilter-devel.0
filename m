Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 684DA16EBF0;
	Mon, 12 Aug 2024 10:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458296; cv=none; b=qQ8utJSnlvVtUw0tkI0QgZ0Nvt8SVUv69GWEQXQ2AE0NN8RtgIUp5xTqWJYf4oMF71irOA30Z2Y1gETDti0Amhk+X3PPJ8GfyIQU0zBGgDL1Y2/uZxQ1QWchPBHOuP0/8xQCQjUSdul+tQmfmb7aeIyk8UhMdX6c9y8hBN6kZsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458296; c=relaxed/simple;
	bh=nC0TqUnF4JRiMrMS7zXCW8UkPFbb94q5A0K07uoXVRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sCd03e8i/HO6ftMbWofLfc7gJJ0Z9NGmp0hlcoFsmkv5+u/UDfGMJATJXc8E+AOYEvUDMg0otMRELdMIduAmpXIIWdHqei6Rn3NFLKuw761pj6dpEFiGEKSsPfDmFBjMSEm19b/zSXM9IhIAy/nNSAjDSitSBC6SMctDakGElCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.15.x 1/5] netfilter: nf_tables: set element extended ACK reporting support
Date: Mon, 12 Aug 2024 12:24:42 +0200
Message-Id: <20240812102446.369777-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102446.369777-1-pablo@netfilter.org>
References: <20240812102446.369777-1-pablo@netfilter.org>
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
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6e4ce511f51b..95c28893002e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5769,8 +5769,10 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 
 	return err;
@@ -6589,8 +6591,10 @@ static int nf_tables_newsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, info->nlh->nlmsg_flags);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			return err;
+		}
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -6866,8 +6870,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 	return err;
 }
-- 
2.30.2

