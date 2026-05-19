Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81972BDC1C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 19:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220159; cv=none; b=Fqn0tCEQGprPSgeWc/D3UVmotC1XhBPUWLBWHtxmLV50lt1WmnmJceRLbJiMXdeONrDglkOCwndEfBRP/Y1DtJyzzNqmWA6v+nYQu4CdPHIDFwv6uxZrfFcM5rfexZDz0p+txIw0VGqssn/s4Y8wFjwp2/1UoOfk7NWgJsiHAWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220159; c=relaxed/simple;
	bh=GWXWA8myuJCwJcaE/V2WoJ4wLcWE25btSTnFSQ64xIY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eROSkDX17hsLLO8K9EMuZ8HWQSBwaaRiqe8JKh8vthKr8gpfP7dAi78qgMMPfZKPwUEed5cEVojczabLtEusJpiSd5/sw2YvzB94+6eOmzS2IDKJMyuhTevOJm+rBZ+dP2RFm6QPww8YvCTXlZQ8K268cKqmDQk3oub+fjdlm7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Bk39WAIS; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Bk39WAIS"
Received: from pps.filterd (m0528005.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64JFvB0s1599219;
	Tue, 19 May 2026 12:48:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2025-q2; bh=1SuOs57rPu4mm5C6KX
	h6OyzgCvEEzA1vR5CR1o0/8oo=; b=Bk39WAISNlkx/SxKb+jyZmJT2b8fED+3Hg
	YkC1yU/Pct7fyKExHzCfSwGiNcKzk3onqCB20eUKCBCBLi/JDyhCj3fFL2EfnOPn
	FZHKbsH6Lg2NE1PNrdQFSeN2ZxwCY45MrD3rgnp1FU4ae5O4SmGW7wtPcwLpqA3A
	AdPtK74lSJwNRkacOMQJdRUxznYNbArHogDhltoRe64cUwMwTZzrOJRdrcM0P35j
	9Kd5bDXCaMgllQAKeAXTeges4VSdrmpTDHGKxUywxnr3X5aMQI89WQE4ZFj+7duo
	X977kTXW4lFuCpRApIJ2I6tvS8bcDCW+6/KMSn7n8ZF+ivPChvuQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4e7a5hy5m6-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 19 May 2026 12:48:58 -0700 (PDT)
Received: from devbig003.atn7.facebook.com (2620:10d:c0a8:1b::2d) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.37; Tue, 19 May 2026 19:48:57 +0000
From: Chris Mason <clm@meta.com>
To: <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Pablo
 Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: synproxy: refresh tcphdr after skb_ensure_writable
Date: Tue, 19 May 2026 12:36:14 -0700
Message-ID: <20260519194841.63794-1-clm@meta.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=NqXhtcdJ c=1 sm=1 tr=0 ts=6a0cbeaa cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=jCddH8ec0KUNCymVuxII:22 a=VabnemYjAAAA:8 a=kbEqmvIW_NrQOt3gxasA:9
 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: rnlnTDEM1EZEBHLGQOOj4sdTSsxyh0vV
X-Proofpoint-ORIG-GUID: rnlnTDEM1EZEBHLGQOOj4sdTSsxyh0vV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDE5NyBTYWx0ZWRfX7mowEP8uMK/x
 ZIHpiV6BegWCdTfo8NVNx+D0RDH5nAJHqlaPCvE/Ey/ABf+w/hSvtKs0eZeAYFVEx6fPy6AdogN
 hP/K+MV2YVID2K0d36N6g8794LlwMbK7lq1XROaN7AULUIWffFyzr9BoBxdcMS17EUrvxgvffDK
 m6Q4ch3M4bNjtWVy38aaO0VBL+bDGaa/Gigdl0F5jKFDy4uzXFJYZw4pryV++Hmg3MNrWfGpVQR
 KUjfaUgn9jW5gf/zbRvkO2CHwjyvIbhsknVTBGKIEMFgjg1/wOgpZfiGjLzqpTa1z1Gz9wydpal
 L7Byvv8KDhgaxuOA7aH8GnBJeq7Y6tdsFF3s93cy68sZ9Qm5m2SQTIFNkr0wATRjnW89Y3OGYLN
 GNHCGZtaqEpiqru4PimQdf9lsfv6K2KhO2kCc8GIyDjIy3b2locElrDfVkcjtOu/oDhf56Aviu0
 IwwBY1GlxKwr+wEBPcQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_05,2026-05-18_01,2025-10-01_01

synproxy_tstamp_adjust() rewrites the TCP timestamp option in place
and then patches the TCP checksum via inet_proto_csum_replace4() on
the caller-supplied tcphdr pointer.  Both ipv4_synproxy_hook() and
ipv6_synproxy_hook() obtain that pointer with skb_header_pointer()
before calling in, so it may either alias skb->head directly or
point at the caller's on-stack _tcph buffer.

Between obtaining the pointer and using it, the function calls
skb_ensure_writable(skb, optend), which on a cloned or non-linear
skb invokes pskb_expand_head() and frees the old skb->head.  After
that point the cached th is stale:

    caller (ipv[46]_synproxy_hook)
      th = skb_header_pointer(skb, ..., &_tcph)
      synproxy_tstamp_adjust(skb, protoff, th, ...)
        skb_ensure_writable(skb, optend)
          pskb_expand_head()        /* kfree(old skb->head) */
        ...
        inet_proto_csum_replace4(&th->check, ...)
                                    /* writes into freed head, or
                                       into the caller's stack copy
                                       leaving the on-wire checksum
                                       stale */

The option bytes are written through skb->data and are fine; only
the checksum update goes through th and so lands in the wrong
place.  The result is either a write into freed slab memory or a
packet leaving with a checksum that does not match its payload.

Fix by re-deriving th from skb->data + protoff immediately after
skb_ensure_writable() succeeds, so the subsequent checksum update
targets the linear, writable header.

Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
Assisted-by: kres (claude-opus-4-7)
Signed-off-by: Chris Mason <clm@meta.com>
---
 net/netfilter/nf_synproxy_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 57f57e2fc80a..036c8586f49b 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -200,6 +200,8 @@ synproxy_tstamp_adjust(struct sk_buff *skb, unsigned int protoff,
 	if (skb_ensure_writable(skb, optend))
 		return 0;
 
+	th = (struct tcphdr *)(skb->data + protoff);
+
 	while (optoff < optend) {
 		unsigned char *op = skb->data + optoff;
 
-- 
2.52.0

