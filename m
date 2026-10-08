Received: from out28-50.mail.aliyun.com (out28-50.mail.aliyun.com [115.124.28.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50A527280A;
	Thu,  8 Oct 2026 03:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791429414; cv=none; b=a8PocpGDApWKdzXGGwREYOX9AgZ+knYdPxmD5wdoMuTBkqP0+J7tUN/OdJRZsxD1TqLgjQJa5bUcR+//xFkLrp98RyRlNgrDAakNZT5HItyIhGd5JkWPnvyL35+SjgFns8H4VkYToe/enCLodmqd/bJk77Ql+UB2d3vf+E4tJ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791429414; c=relaxed/simple;
	bh=5oQn9p0aYhf/qlZsRVnnDZXKe6Z7H5rk/GN70nUQwQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q4zIyyKs1TrqTGoFqmlK0+ze2FhN92UNkBlz89PurVaYxrAK4yHz/nN5jpYfjiOeHoe03CBNRhBFJRseKArkSRpDIVXrVy1MObrn8wXQrsaGiBB6C6pZN7/CEFQqM3Xa9dl3nm6zwsOKnB0rH3U338ylTExRg06WBBajC45vID0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=EjQoj/Lr; arc=none smtp.client-ip=115.124.28.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="EjQoj/Lr"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791429405; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=fdav0LrHtGdLGLCaHTnJ11uIlMF7U57oWCd+VKzUSWM=;
	b=EjQoj/LrzZks57auGSEwGnXsbDu2bgDblU0fm4F5TM9YTAq2nHQr3Efm1Seye9ZSos6nRP+z6pqQs3bCj21c6ZBUVTzw6Ay7hGuiyfieovZa+NuUiACJnpu0Z++1hgmyDzEHpHFXRV5XapCTyB5e8jNA1zIq4SVmvQApcCUPD8A=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07436739|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.222871-0.00778521-0.769344;FP=18311476887412018967|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037032089;MF=guozh23@xiaopeng.com;NM=1;PH=DS;RN=15;RT=15;SR=0;TI=SMTPD_---.jWTK8mo_1791427539;
Received: from localhost(mailfrom:guozh23@xiaopeng.com fp:SMTPD_---.jWTK8mo_1791427539 cluster:ay29)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 10:45:40 +0800
From: Guo Zihao <guozh23@xiaopeng.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net v2] netfilter: ebtables: ebt_802_3: check the LLC fields before reading them
Date: Thu,  8 Oct 2026 10:45:39 +0800
Message-ID: <20261008024539.4106699-1-guozh23@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ebt_802_3_mt() derives the frame pointer from skb_mac_header() and reads
the LLC fields through it without making sure that those bytes are
available at all. ebtables guarantees that the Ethernet header is linear,
but nothing between the receive path and this match pulls the LLC header,
so a frame that carries nothing past the 14-byte Ethernet header is read
past the linear area.

Also, ebt_802_3_mt() does not need to look at every LLC field for every
rule. A SAP-only rule reads only dsap and ssap, and a rule without any
SAP or TYPE constraint selects frames by their 802.3 length field alone,
which ebt_basic_match() has already handled. Reading the type field there
was wasted work and could not be checked against anything.

Go through skb_header_pointer() with the mac header offset, which handles
frames whose LLC header is not in the linear area, and require only the
bytes each rule actually examines:

 - no SAP or TYPE constraint: nothing to look at, match right away;
 - SAP-only rule: dsap/ssap, at machdr + 14..15;
 - TYPE rule: the whole union, at machdr + 14..23, which also covers the
   control byte that selects between the ui and ni views of the union.

A frame too short to hold the fields a rule examines now fails to match
that rule. The previous hotdrop approach was dropped because ebtables
legacy only honors hotdrop when every match of the rule so far has
matched, so returning false is the only behaviour both front-ends agree
on. Users who want truncated 802.3 frames dropped can match 802.3 alone.

Discovered by a static-analysis scan of net/; confirmed by code
inspection of the receive path and the ebtables core. Not triggered in
testing; no runtime report is available.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Liu Chao <liuc63@xiaopeng.com>
Signed-off-by: Guo Zihao <guozh23@xiaopeng.com>
---
 net/bridge/netfilter/ebt_802_3.c | 47 +++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 68c2519bd..1a67376d1 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -9,32 +9,59 @@
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
+	/* Without SAP or TYPE constraints the match only selects 802.3
+	 * frames, which ebt_basic_match() has already decided from the
+	 * ethertype/length field. Nothing in the LLC header is read.
+	 */
+	if (!(info->bitmask & (EBT_802_3_SAP | EBT_802_3_TYPE)))
+		return true;
+
+	/* Only the dsap/ssap pair is examined for a SAP-only rule; the
+	 * type field (and the control byte that selects between the ui
+	 * and ni views of the union) is needed for a TYPE rule alone.
+	 */
+	hlen = sizeof(_frame);
+	if (!(info->bitmask & EBT_802_3_TYPE))
+		hlen = offsetof(struct ebt_802_3_hdr, llc.ui.ctrl);
+
+	/* skb->data sits past the Ethernet header on the receive path, so
+	 * the frame starts at a negative offset from skb->data. Pass the
+	 * mac header offset so the check follows the frame wherever the
+	 * hook reset the mac header, and covers paged frames too. A frame
+	 * too short to hold the LLC fields simply does not match; users
+	 * who want such frames dropped can match 802.3 alone.
+	 */
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

