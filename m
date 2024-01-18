Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB6A28E0D;
	Thu, 18 Jan 2024 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705594662; cv=none; b=bLzzf70kW0lpKh1ZBItGLAg+Z8FTm/7uQ4HMYPGoXwY44Fi454Oct9OAxu+KLYyZvuoi1/Zsbrb/oXL9HDlpxu+Z5ptrQEsk72wRHWnyHzuNJGMN06oJHBwRYEEpneFYtpxlyMSQWuPbCRpTnspKimxs865huE/BnJWdaqkax6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705594662; c=relaxed/simple;
	bh=v8brMQ+HpLj3Ea+P/82A97oHOrS/84rOO69N/UNUBUw=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=H+8w0zoOg0JoyxPyKj09m4Yr8j70H+aDUEPjtlBDA/UKoRJtdnkKojS/HAKSwHRdmtVM7Wez+JJLw3aJxLoD+oXMHy6L7q/YLgsMwAKpU6n3zunzLdUl/URLbRjckYv0WgntIpcm1DjJfUZCRWP7mO7P23clew+Suc+phWKk30I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 02/13] netfilter: nf_tables: validate .maxattr at expression registration
Date: Thu, 18 Jan 2024 17:17:15 +0100
Message-Id: <20240118161726.14838-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240118161726.14838-1-pablo@netfilter.org>
References: <20240118161726.14838-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nft_expr_info allows to store up to NFT_EXPR_MAXATTR (16)
attributes when parsing netlink attributes.

Rise a warning in case there is ever a nft expression whose .maxattr
goes beyond this number of expressions, in such case, struct nft_expr_info
needs to be updated.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a90a364f5be5..2548d7d56408 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2977,6 +2977,9 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (WARN_ON_ONCE(type->maxattr > NFT_EXPR_MAXATTR))
+		return -ENOMEM;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
-- 
2.30.2

