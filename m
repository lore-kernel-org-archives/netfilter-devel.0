Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABDA2D8DB9;
	Wed, 19 Nov 2025 03:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521299; cv=none; b=qwlJ3HlcYHWT6UO279Yi3bIfCOJQYCUWK2VJPrnTT7K7L5oZQM8wOU+E9T/znRM5tirEjqhlgX/S0EIrqJcZ92CQ6bt+jEm/qOIicIcb03CDv3Bd3OhwGaU5esdYQqY6mkOxlO/VHDcGzZCv/8yWgsSlVP2fIR2knd4JU9iRTk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521299; c=relaxed/simple;
	bh=2YDp8cfB+hfCFecaBj//V3DLS0FGXrkI5Xw5CVMRDpo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o9UY1bLVQ2ksVTDFuAW6dD3/WFozpFHO0EYRphNJO4xJ/XxWiCbfo1vw1RK+91br+RyUBtDcTWf8eBjWRejOj9joLUXhGYOByUZerEdYFtaS9UJ1zdIbtrZQjKdhqX3XsCYszGAmoRhJ7RjRqX/KFx8VWU7WQYMB6fiJtvlyjhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 097ba05cc4f411f0a38c85956e01ac42-20251119
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:738446a6-b2c9-4f89-958d-13a1b121e253,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:738446a6-b2c9-4f89-958d-13a1b121e253,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:ef4c4b91d06e56043c16bf6ff82b2e7e,BulkI
	D:251119110128SWWI5032,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|850,
	TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 097ba05cc4f411f0a38c85956e01ac42-20251119
X-User: zhaochenguang@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <zhaochenguang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1201661605; Wed, 19 Nov 2025 11:01:25 +0800
From: Chenguang Zhao <zhaochenguang@kylinos.cn>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: Chenguang Zhao <zhaochenguang@kylinos.cn>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v2] netfilter: conntrack: Add missing modification about data-race around ct->timeout
Date: Wed, 19 Nov 2025 11:01:19 +0800
Message-Id: <20251119030119.124117-1-zhaochenguang@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct nf_conn)->timeout can be read/written locklessly,
add READ_ONCE()/WRITE_ONCE() to prevent load/store tearing.

The patch 'commit 802a7dc5cf1b ("netfilter: conntrack: annotate
data-races around ct->timeout")'fixed it, but there was a
missing part that this patch completes it.

Fixes: 802a7dc5cf1b ("netfilter: conntrack: annotate data-races around ct->timeout")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 344f88295976..df4426adc9c8 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1297,7 +1297,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	/* Timeout is relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
-	ct->timeout += nfct_time_stamp;
+	WRITE_ONCE(ct->timeout, READ_ONCE(ct->timeout) + nfct_time_stamp);
 
 	__nf_conntrack_insert_prepare(ct);
 
-- 
2.25.1

