Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FE714A098;
	Wed, 14 Aug 2024 22:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723674054; cv=none; b=SK01PPGbkkbGOPwsYI6b5oBxlBBogPu3ufzuxx1uNON06MCfH/NlUpFQ2n/5W/TVPbx458a2R1/x2uFijLR8eNSuDoxbbavGYXclb8MwIdQM+49UB1i/CHSYopZnbrMA4OtMHgQG9P9oiwcFpn9f6CRCtalLL1wyw6nXx1qxpdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723674054; c=relaxed/simple;
	bh=ec7mfZCwAb08NgjKOdtsKyttWhuWfnMBkMzTHKyxvEA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dJN3SNno3ecRHYEGWtetidTF408FjpfY3lTLcYig9NaJeqvrXAB0PrvA4H4sa8KCZuZnOgGLwipzQgvkx9whdz46aPIrPLJRvobRMiq1SdguwdM3GFVe2w6C4v4f/AGZSbYkDpcLMefKzCAKyhSTtIbTspTfXnA21LbvAE83e3E=
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
Subject: [PATCH net 2/8] netfilter: nfnetlink: Initialise extack before use in ACKs
Date: Thu, 15 Aug 2024 00:20:36 +0200
Message-Id: <20240814222042.150590-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240814222042.150590-1-pablo@netfilter.org>
References: <20240814222042.150590-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Donald Hunter <donald.hunter@gmail.com>

Add missing extack initialisation when ACKing BATCH_BEGIN and BATCH_END.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abf660c7baf..932b3ddb34f1 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -427,8 +427,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	nfnl_unlock(subsys_id);
 
-	if (nlh->nlmsg_flags & NLM_F_ACK)
+	if (nlh->nlmsg_flags & NLM_F_ACK) {
+		memset(&extack, 0, sizeof(extack));
 		nfnl_err_add(&err_list, nlh, 0, &extack);
+	}
 
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
@@ -577,6 +579,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			ss->abort(net, oskb, NFNL_ABORT_NONE);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
 		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
+			memset(&extack, 0, sizeof(extack));
 			nfnl_err_add(&err_list, nlh, 0, &extack);
 		}
 	} else {
-- 
2.30.2

