Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8F93B6BE5
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 12:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787230676; cv=none; b=sePpNnjd2hFh/ReTsh+kvZ8qDGgtN82Y4PPS8qMoNwA/X1IM/a1JPpuQKbO7A43WNpTH5UFKXMeS424ub8UgAtuTst3qFedqf9PU1do/mJyA+z1ORusUFJ5JzNquyLtp3v11cEoHrbxqvMOFMVxj+xmLJ6vrnU/KdKfEmv0tvzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787230676; c=relaxed/simple;
	bh=0Q2VlChL289p95iHjUsaKwtmEg7ltHuz8YIkx7f4hGI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QqPn+vlVteHPcyXJHwF/uEo4azJJxnY79j/AXpjJTzYfnmwC6/LXm8PWxbTdEDNLChn9Rv9yOZtCVUY1Cu6/ySWjEpn5WVP+746x/mEzpqX6Psg7FGR1OOGrXlxboLr329geC+RtulUCNxXMSn98Yx4UhO0pbEk82w3RJTOJMo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: bc00c5de9c9611f19a56ed5b684f684d-20260820
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:aeaa8d93-aae8-4fbb-a034-36ffa210d7bd,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:aeaa8d93-aae8-4fbb-a034-36ffa210d7bd,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:93f400ec5cdb724551245e9be30be5c4,BulkI
	D:260820205747TR46NNG3,BulkQuantity:0,SF:10|66|78|102|127|136|865|898,TC:n
	il,Content:0|15|50,EDM:-3|-100,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: bc00c5de9c9611f19a56ed5b684f684d-20260820
X-User: sunshaojie@kylinos.cn
Received: from sunshaojie-pc [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sunshaojie@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1605514477; Thu, 20 Aug 2026 20:57:43 +0800
From: Shaojie Sun <sunshaojie@kylinos.cn>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shaojie Sun <sunshaojie@kylinos.cn>
Subject: [PATCH] netfilter: conntrack: fix nf_conntrack_expect_max default value in documentation
Date: Thu, 20 Aug 2026 20:57:18 +0800
Message-ID: <20260820125718.1027116-1-sunshaojie@kylinos.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The documentation for nf_conntrack_expect_max incorrectly states that the
default value is nf_conntrack_buckets / 256. However, the code in
nf_conntrack_expect_init() shows:

    nf_ct_expect_hsize = nf_conntrack_htable_size / 256;
    nf_ct_expect_max = nf_ct_expect_hsize * 4;

This means the default value is actually nf_conntrack_buckets / 64
(i.e. 4 times the hash table size, which defaults to
nf_conntrack_buckets / 256).

Fix the documentation to reflect the correct default value and add
explanation of the calculation.

Signed-off-by: Shaojie Sun <sunshaojie@kylinos.cn>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 35f889259fcd..77521253fe22 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -44,7 +44,8 @@ nf_conntrack_events - BOOLEAN
 
 nf_conntrack_expect_max - INTEGER
 	Maximum size of expectation table.  Default value is
-	nf_conntrack_buckets / 256. Minimum is 1.
+	nf_conntrack_buckets / 64 (i.e. 4 times the hash table size,
+	which defaults to nf_conntrack_buckets / 256). Minimum is 1.
 
 nf_conntrack_frag6_high_thresh - INTEGER
 	default 262144
-- 
2.50.1

