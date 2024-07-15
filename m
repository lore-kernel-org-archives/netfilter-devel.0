Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E0D1E89C
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2024 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721053263; cv=none; b=Bqwrjfz30bXrXhydTZlhFpv7WIQgK65zJl+R7LbusNJQSvgEqSUvzjn4yeDt+DZAO6TeGTAJM7rVnbVehXMRTrCTit59825Chfun+RgJjYian/YeoYo3C5mIHE3P94IkgEb2YfXbzbuPfclAs1rqauygJto1ahIkkXTDWpV9VZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721053263; c=relaxed/simple;
	bh=zfN/1D81JB+kjH4MAUoWqJsvjI7bq3ViIGBgK+Fa7qE=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=ivMLO6ZzF/xZ1buq9xZt6tO9wLjN0onXQ3K1FIff19pJjEhCfGFNG0kfrAO2RCd1tCk/W04VSaz2cUdqSsr14is8O/aOl8Iif2uDt9CVtdvTPWaG/iILqldddcEjTjYEhfEAueJko8u3MqfVwxc/rbcWj4vG9oi7h1EU0ysHqoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: ctnetlink: use helper function to calculate expect ID
Date: Mon, 15 Jul 2024 16:20:56 +0200
Message-Id: <20240715142056.44422-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Delete expectation path is missing a call to the nf_expect_get_id()
helper function to calculate the expectation ID, otherwise LSB of the
expectation object address is leaked to userspace.

Fixes: 3c79107631db ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3b846cbdc050..4cbf71d0786b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3420,7 +3420,8 @@ static int ctnetlink_del_expect(struct sk_buff *skb,
 
 		if (cda[CTA_EXPECT_ID]) {
 			__be32 id = nla_get_be32(cda[CTA_EXPECT_ID]);
-			if (ntohl(id) != (u32)(unsigned long)exp) {
+
+			if (id != nf_expect_get_id(exp)) {
 				nf_ct_expect_put(exp);
 				return -ENOENT;
 			}
-- 
2.30.2

