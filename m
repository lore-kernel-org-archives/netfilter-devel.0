Received: from out28-101.mail.aliyun.com (out28-101.mail.aliyun.com [115.124.28.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D6E442FB2;
	Mon, 12 Oct 2026 07:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791789903; cv=none; b=WXInO+inJmJLkyqi6wgR1htZrhOqrf85uFwUDEZBjYYlDqlAkDvnEQZ/lCY2fpeJQ50zng4NpBS4WpAM6uqNEcf8dWm7+oOrnUluKTDTagnFLr+0CvZ/Orf4xOF14eUEB+jPemxo0TP1ibEgting8gy1Oo5yjrObOzSbMGe2z70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791789903; c=relaxed/simple;
	bh=kTOFPMiyuUkUO4cfufsN/R9dXmoNxEfuqHo0ZT2QoeI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X59KPrl+FqKVv8miQlTDmr4c7xsBufaLEphCBFVttvBNta6UJyfFlXctzQWOQz922mzy+NeYuOeYzS18gPwxR6WbGlXlhnGLZxQtC0HzfwPKM5T7E5G/hqustSnYefUsjmWSMbogXloOfz30rAS2HWd6kq0eyRrwi9jjF7roGJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=cXzVOi7s; arc=none smtp.client-ip=115.124.28.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="cXzVOi7s"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791789891; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=LshFPcfkwOJuQoYOlgGdpQH8LbW80ejZatBz6kxl5tE=;
	b=cXzVOi7sGWMoNgS8A8jg1vyEnIql7+VNMS6ftTx9uSulxCZoKPv+5aAEZomeqnr97Ssc8WtnttgLT2ezGAPuJr5ksbR5VCDWuGKgtXAFgY/8jefONbDOjtjThzlPwhKHjiz4aRA9hyNpUzvr5Gb1gG5ZlWqGJe46QoH+zsKUSVI=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.0801817|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.103824-0.00585963-0.890316;FP=13726519755087547156|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033032062159;MF=guozh23@xiaopeng.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.jZxax0Z_1791789890;
Received: from localhost(mailfrom:guozh23@xiaopeng.com fp:SMTPD_---.jZxax0Z_1791789890 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 15:24:51 +0800
From: Guo Zihao <guozh23@xiaopeng.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 2/2] netfilter: ebtables: ebt_802_3: fix control format test and the ni type offset
Date: Mon, 12 Oct 2026 15:24:49 +0800
Message-ID: <20261012072449.3240201-2-guozh23@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two long-standing issues in the TYPE match:

 - The control format test is (ctrl & IS_UI), which is also true for an
   S or I format control field (0x01 or 0x02, both two-byte control
   fields), sending the comparison to the wrong view of the union.
   Test for the UI control field exactly, the way LLC_PDU_TYPE_IS_U()
   in include/net/llc_pdu.h does.

 - When the ni view is picked, struct hdr_ni has a padding byte after
   orig[3], so its type field sits at llc offset 8 while the type on
   the wire is at llc offset 7. Every S or I format frame the TYPE
   match compares has therefore been compared against a shifted type
   byte plus a payload byte. Read the type through
   get_unaligned_be16() at the wire offset instead of through the
   struct.

The uAPI struct cannot change because ebtables userspace shares it.

Signed-off-by: Guo Zihao <guozh23@xiaopeng.com>
---
 net/bridge/netfilter/ebt_802_3.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index fc49f7c7b..0b4b77dc2 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -9,6 +9,7 @@
  *
  */
 #include <linux/module.h>
+#include <linux/unaligned.h>
 #include <linux/stddef.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
@@ -46,8 +47,17 @@ ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	if (info->bitmask & EBT_802_3_TYPE) {
-		type = frame->llc.ui.ctrl & IS_UI ? frame->llc.ui.type :
-						    frame->llc.ni.type;
+		/* IS_UI is the exact UI control field; the S and I formats
+		 * carry two-byte controls, and their type sits at llc offset
+		 * 7 on the wire while the in-kernel hdr_ni has a padding
+		 * byte before its type field.
+		 */
+		if ((frame->llc.ui.ctrl & IS_UI) == IS_UI) {
+			type = frame->llc.ui.type;
+		} else {
+			type = get_unaligned_be16((__be16 *)((u8 *)frame +
+					offsetof(struct ebt_802_3_hdr, llc) + 7));
+		}
 		if (!(frame->llc.ui.dsap == CHECK_TYPE &&
 		      frame->llc.ui.ssap == CHECK_TYPE))
 			return false;
-- 
2.50.1

