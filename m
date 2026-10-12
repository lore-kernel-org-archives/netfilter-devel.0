Received: from out28-217.mail.aliyun.com (out28-217.mail.aliyun.com [115.124.28.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9876B44163B;
	Mon, 12 Oct 2026 07:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791789903; cv=none; b=Wz8Y1aWYBbvzlLMzfjYeC4DmJKWEPlTeNhASfmDqkdp8ljdE5YerzkURQf0MQxnZ6mtvngQMgA3OvtLXLn3qWz7tQ1wLE4EpG8x9//XZPkOFfjW0afk287AHx9i1Ds0tXWtdx0NwpKdhq3gH4lnSw1NjMPkWD60Ddx+ThoBOLMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791789903; c=relaxed/simple;
	bh=kKUosKXIiBd5QPEXvwo9vqNIWf8lGsQBxuD9XNAPhoc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QlMl7jAhLSe1e0vP7651XqsbebhxNhYIBAgCRdheomH8CRYpGu47TSQ4nl0zqo8N4K/N2761Txuibea2AvwuG3/Iuco7YnwNc1nY5MSyHuEaoaJ4mf33ZTe1EuN3Y5ZMye1lRrBcvKYKMdxJiHDx6MNmQVjuEFXvPC35AaXtHGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=qqJ8R+np; arc=none smtp.client-ip=115.124.28.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="qqJ8R+np"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791789891; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kKoPndCPLQyzcnNCFvhr3Dzxp5/DM//p58FJrLH7sQo=;
	b=qqJ8R+npaeNSyZ/AJv5B+adHpsaI39swF8vA0OErNCd7xlPkUPwL0/lvfsxbu4eWASh4/LBeQ8LNUjQccQdpQm4DjNuic55RvOHqS6KNnabOgaG3bFhK+8hQS/YpF8MPedSEyXs69v07GW41q6cIUrqg5K4DHwYaF8ohWZP5nNo=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07441201|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.269485-0.00692188-0.723593;FP=18347504515258780165|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033022149254;MF=guozh23@xiaopeng.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.jZxax.L_1791789889;
Received: from localhost(mailfrom:guozh23@xiaopeng.com fp:SMTPD_---.jZxax.L_1791789889 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 15:24:50 +0800
From: Guo Zihao <guozh23@xiaopeng.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 1/2] netfilter: ebtables: ebt_802_3: check the LLC fields before reading them
Date: Mon, 12 Oct 2026 15:24:48 +0800
Message-ID: <20261012072449.3240201-1-guozh23@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ebt_802_3_mt() takes the frame pointer from skb_mac_header() and reads
the LLC fields through it without making sure those bytes are there.
Nothing between the receive path and this match pulls the LLC header,
so a frame that carries nothing past the 14-byte Ethernet header is
read past the linear area.

The match also reads more of the LLC header than rules look at. A
SAP-only rule uses dsap/ssap; a rule without any SAP or TYPE constraint
matches 802.3 frames without touching the LLC header at all, just as it
did before this patch.

Require only the bytes each rule actually examines, and go through
skb_header_pointer() with the mac header offset so short frames fail
the match instead of being read past the linear area. A frame shorter
than the fields the rule looks at simply does not match that rule;
users who want such frames dropped can match 802.3 alone.

The match itself is not restricted to 802.3 frames: the ebtables
userspace tool pairs it with "-p Length", but the kernel does not
enforce that pairing and nft_compat does not run ebt_basic_match(),
so a SAP or TYPE rule can still see Ethernet II payload bytes,
bounds checks aside, same as before.

v2:
 - rework to skb_header_pointer() with a per-rule length instead of
   hotdrop, whose semantics differ between ebtables legacy and nftables
 - read only dsap/ssap for SAP-only rules

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
Signed-off-by: Guo Zihao <guozh23@xiaopeng.com>
---
 net/bridge/netfilter/ebt_802_3.c | 35 +++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 68c2519bd..fc49f7c7b 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -9,32 +9,47 @@
  *
  */
 #include <linux/module.h>
+#include <linux/stddef.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/skbuff.h>
 #include <uapi/linux/netfilter_bridge/ebt_802_3.h>
 
-static struct ebt_802_3_hdr *ebt_802_3_hdr(const struct sk_buff *skb)
-{
-	return (struct ebt_802_3_hdr *)skb_mac_header(skb);
-}
-
 static bool
 ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_802_3_info *info = par->matchinfo;
-	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
-	__be16 type = hdr->llc.ui.ctrl & IS_UI ? hdr->llc.ui.type : hdr->llc.ni.type;
+	struct ebt_802_3_hdr _frame;
+	const struct ebt_802_3_hdr *frame;
+	unsigned int hlen;
+	__be16 type;
+
+
+	if (!(info->bitmask & (EBT_802_3_SAP | EBT_802_3_TYPE)))
+		return true;
+
+
+	hlen = sizeof(_frame);
+	if (!(info->bitmask & EBT_802_3_TYPE))
+		hlen = offsetof(struct ebt_802_3_hdr, llc.ui.ctrl);
+
+
+	frame = skb_header_pointer(skb, skb_mac_offset(skb), hlen, &_frame);
+	if (!frame)
+		return false;
 
 	if (info->bitmask & EBT_802_3_SAP) {
-		if (NF_INVF(info, EBT_802_3_SAP, info->sap != hdr->llc.ui.ssap))
+		if (NF_INVF(info, EBT_802_3_SAP, info->sap != frame->llc.ui.ssap))
 			return false;
-		if (NF_INVF(info, EBT_802_3_SAP, info->sap != hdr->llc.ui.dsap))
+		if (NF_INVF(info, EBT_802_3_SAP, info->sap != frame->llc.ui.dsap))
 			return false;
 	}
 
 	if (info->bitmask & EBT_802_3_TYPE) {
-		if (!(hdr->llc.ui.dsap == CHECK_TYPE && hdr->llc.ui.ssap == CHECK_TYPE))
+		type = frame->llc.ui.ctrl & IS_UI ? frame->llc.ui.type :
+						    frame->llc.ni.type;
+		if (!(frame->llc.ui.dsap == CHECK_TYPE &&
+		      frame->llc.ui.ssap == CHECK_TYPE))
 			return false;
 		if (NF_INVF(info, EBT_802_3_TYPE, info->type != type))
 			return false;
-- 
2.50.1

