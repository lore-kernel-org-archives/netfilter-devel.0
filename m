Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E92355381B;
	Thu,  5 Sep 2024 23:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725578977; cv=none; b=T4V/twR4azuau5zaPirwP7GSWcF5OieGlJ5JWYfofazaQUdXX/XfZCSiBX5bgAayWdJlbI5cQo0Z+VjtO+yYWMbfi2fx1HDWzrk5UxixwBD/kymjuDui6m9Vt//tIrXcUKyDG4gMEirWmICnD2Oa90VqLE9r5guBghZRT9K9Ogc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725578977; c=relaxed/simple;
	bh=w6edGVjCYjffqyhqPtJI9X8R2hUa3ntWHROQ3ZLDyVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pV8NW2s4gSStdJIMfV+tjv7aCfJnlyBUEzcld0UkrscbKiTQSP9vnGGOrI+fMhBlxwIT8ZG7K68D78vmX39d6fZw9otRC/f5E0tEMJXn77tiyHoyzJCw6XreWSJQQlD2uSLx5nVi2YbqNOD+HlA0A4mRCEeVTdyYqo+kDam4V9s=
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
Subject: [PATCH net-next 01/16] netfilter: ctnetlink: support CTA_FILTER for flush
Date: Fri,  6 Sep 2024 01:29:05 +0200
Message-Id: <20240905232920.5481-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240905232920.5481-1-pablo@netfilter.org>
References: <20240905232920.5481-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Changliang Wu <changliang.wu@smartx.com>

From cb8aa9a, we can use kernel side filtering for dump, but
this capability is not available for flush.

This Patch allows advanced filter with CTA_FILTER for flush

Performace
1048576 ct flows in total, delete 50,000 flows by origin src ip
3.06s -> dump all, compare and delete
584ms -> directly flush with filter

Signed-off-by: Changliang Wu <changliang.wu@smartx.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4cbf71d0786b..123e2e933e9b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1579,9 +1579,6 @@ static int ctnetlink_flush_conntrack(struct net *net,
 	};
 
 	if (ctnetlink_needs_filter(family, cda)) {
-		if (cda[CTA_FILTER])
-			return -EOPNOTSUPP;
-
 		filter = ctnetlink_alloc_filter(cda, family);
 		if (IS_ERR(filter))
 			return PTR_ERR(filter);
@@ -1610,14 +1607,14 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	if (cda[CTA_TUPLE_ORIG])
+	if (cda[CTA_TUPLE_ORIG] && !cda[CTA_FILTER])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_ORIG,
 					    family, &zone);
-	else if (cda[CTA_TUPLE_REPLY])
+	else if (cda[CTA_TUPLE_REPLY] && !cda[CTA_FILTER])
 		err = ctnetlink_parse_tuple(cda, &tuple, CTA_TUPLE_REPLY,
 					    family, &zone);
 	else {
-		u_int8_t u3 = info->nfmsg->version ? family : AF_UNSPEC;
+		u8 u3 = info->nfmsg->version || cda[CTA_FILTER] ? family : AF_UNSPEC;
 
 		return ctnetlink_flush_conntrack(info->net, cda,
 						 NETLINK_CB(skb).portid,
-- 
2.30.2

