Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649FC175D3B;
	Mon, 12 Aug 2024 10:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723458537; cv=none; b=XtIIOxF9nyml0ECKzFAxHbK4goUXrH45dkKRCinoI8d9OMvzhwWEHLVJ3PfHrepZcMzjztGJymR8K0Q6kmBYf9FT99tTm2YORLyBkzEQabqehhwHhBowIgt2ONI4FUpSwPj2LfZq1pUDNFOgOBUfFAJPP/qVVNVixP9QeVxKa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723458537; c=relaxed/simple;
	bh=ElGiYqXiJrp01RBgtabzwbCx4aShR8NADDFQDTJrIws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DfDzTF3JIR+XWxFg1a+AJI6mGNvEBNQCnMSEw0bUYmFOpSTdRInKRO4SYCnUjCvHvS5qCMbdYxQJogtIGRsa4e1dD8VRjRknrGN8wqORTse/jLAH99dhF9zrUtkvASYjmsC8EG4JhKvPwMPUQVpW5U2lw2282kGQ8blGElgkw/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.4.x 1/3] netfilter: nf_tables: set element extended ACK reporting support
Date: Mon, 12 Aug 2024 12:28:46 +0200
Message-Id: <20240812102848.392437-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240812102848.392437-1-pablo@netfilter.org>
References: <20240812102848.392437-1-pablo@netfilter.org>
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
index ddbb0f4bff42..2915575739e2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4670,8 +4670,10 @@ static int nf_tables_getsetelem(struct net *net, struct sock *nlsk,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&ctx, set, attr);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			break;
+		}
 	}
 
 	return err;
@@ -5063,8 +5065,10 @@ static int nf_tables_newsetelem(struct net *net, struct sock *nlsk,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_add_set_elem(&ctx, set, attr, nlh->nlmsg_flags);
-		if (err < 0)
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, attr);
 			return err;
+		}
 	}
 
 	if (nft_net->validate_state == NFT_VALIDATE_DO)
@@ -5264,9 +5268,10 @@ static int nf_tables_delsetelem(struct net *net, struct sock *nlsk,
 
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

