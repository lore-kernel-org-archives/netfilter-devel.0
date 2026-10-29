Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793279907;
	b=aEqyJ3SPp9J9VIAzUY3TT8KiCahc7YIbcpwZ+/5pP0+i/VTtupDNPUYPm6EYbFEAbece
	 eOKmqBY9h6PbH/sDOBu5huAGMtEAJrx4t79G48763c1RJ+ye4wY6aJuuqCWG1QeJboqjc
	 GJyf7+zobJ/BYia4Nvx3brC2u+w1/4YMAPdmanTJ+m37g5HaKQS46BUgvmj++7Tl/ukNI
	 Y8W4rMHxQ1dA7n0eWMv///V4FGPh+4vZ7efs3tQp1bhDuKoa9P5bP6Tyn0xiloPDclCY+
	 iw7TWzKkA/IQaQVg/UO+e9IpMhizS0vZBZvV164D9nUnyjkW2KHngfX5V5WW2+jBDGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793279907;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Authority-Analysis:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=2RMmUSzEiFh6e3RV4w1rSoq4IOtUsudgTKepGIytUGs=;
	b=TKfP5KnSgKamb8ErgpCTMUPeQN+f1UWqE+3H17jQOCq2GuCSGACECbJPgkJ77tWVFTue
	 mb8H26g86xYm/wqCRv1gGzCUjlNoL4d5xzudfhJEldVSQ/63gyMWwMjALXo/HjvtEWhCw
	 ffC+Iclq0VNL0+96i+dWlMxF1ryj3x0/GOTj6yqExKEW3vgx2S/W1HJuLb9kqVGZ5Jr3a
	 N5zBDyfKoveXyBfgdB0AXbpKru/dqNzzZB5C4sR/ULWNWbsI0ypy5C/Qhh0orlLMkFPYs
	 e0XUrINTahA3v4yiItuYQTyhYooiuJxtqQcRHAYQEudobEvFLfqiny45ZM3lu0fXjJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Bdxn+Zst;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Sds+RTdg;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09923606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09923606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Bdxn+Zst;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Sds+RTdg
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69TCeULb2762043
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:18:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=2RMmUSzEiFh6e3RV4w1rSo
	q4IOtUsudgTKepGIytUGs=; b=Bdxn+ZstBZ+4jMh4RWqkLWpQZRlbQykSCHrtCC
	RbpiigWILkktP8pl/A3DNp2yGb2pXp1oNWFtXBDSmO2Bgqtb3n2O/sjQJcJf6lvr
	hPVm8H86YZxZn7qOVUeGekG7GSzV8OmtyH+oMcH14mRg3I63/GvVHcPa//rOuz/W
	ZGazmdjUXvk8ekiX+vV7IgOC4Edb7lcTxP9e9O3iIUvVYI37iWFoJRlf8LEVKHet
	tvLF/NL6T2Kkonus9eK0siRqFL6Ym2WYW/u8muclVjkV98mnZbq1I+BF44chB0OC
	+AApJM4j0H/zcnELZfuhN7EI7VDC/SQjf/7gF7FhKuxRvKlQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hm31b0xp4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:18:26 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91b937ecbb4so42425296d6.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 06:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793279905; x=1793884705; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2RMmUSzEiFh6e3RV4w1rSoq4IOtUsudgTKepGIytUGs=;
        b=Sds+RTdg20Xsr7MTM2964a8QO3EW7Qu4Pv9VT1kdu0u+WMYDSusY/3a781H+s1WmX7
         2kokb3QKwI4lEQqtvubXmKu6tRBNHgK6eTkUqCiqWfwtwX1uAmnxL9/mHrTtCa/TS+U6
         NUbvhIL1FPYMkCyisXFmIsghic36CzgZ41ljNtLviPqT0+webgKg6IUC161e92/9LetV
         mo01JqLyAfTiOhSclRv/U34m5ivCqOUmMZpTtU0SX2f1otWBkk+NAbXshNiM9w+f5Ce3
         fw8WBgqyKoE6Iis0qFdBFROKE4zB+7byXa6LGN35n+3KyN1R2brp3MYhlEIqLx1M7RWS
         wgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793279905; x=1793884705;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2RMmUSzEiFh6e3RV4w1rSoq4IOtUsudgTKepGIytUGs=;
        b=PFkHfS1KfZq2kWrKGko4sOhpDTgYnQh3GrStvCXriZNZNdyJstjcKNUrS0TC/3Q7l9
         65ZcHay+0QAMHBbL+DkgcnEZ7dO3KjTBturJ+tLiyvUe4gdFAm6JW5T1uSrStsSF4ole
         y9rL0QWx32uCZ5wRjt/+6xhRGjAXqBqbFjCpWFtBSSnTiEKJK011+iNiQFxa4ENEPJ+4
         I99CPl02qj1CV/hFTwYnJpwFP6JJPNrYMtNbxCYNd0PQJnyid1XoXNIjMtVKlMoqsxfi
         r0lWxJxBWEtW/0J2C7gH1ZzIfJx1AKMqTvvofp3SN+5aWC5hWknuN4ebUla7ZBYS75cp
         zBFA==
X-Forwarded-Encrypted: i=1; AKwUvBylq9PZd5pdsCdKp+2qTWXQX81TMYTZvk1O6FlpQHZWUo7WGVDvICLtmf6VqGsh8tfM3XDsV8a4gymnbGgcpl4=@vger.kernel.org
X-Gm-Message-State: AFq9FYJW0iJjjaYjI9dZ1v8KzmU8W9BDJMCeEXFK13DneVs71xJ09w/e
	uRUrbe5KmP2tKNGiHDKUuefuwzZqAy2RJ+Q4lPFFIJSJlAlAqvsxswkxNApEK9SbePKyQZ1E1Q0
	l41E1Voin6XjAiRWbGQ4rTUJY0cj/Qh62XCQBM+EIePQ6hbgKKYKnuK6T/NNL6PPXDzwx6XLULv
	+SCxE=
X-Gm-Gg: AYBFou1HVCkiwGi1vZsddcJRM337MHwx0pTlatE7U6Gh3oti/H/Ydm74va1Meg+JI+G
	ZR8eq0kbz2gnyiDcY5SRtWXKV3oWjpc7I3THSfUgh5uBdyFLtXi+tc5WHmfqiKop46w/8gq7/cY
	DIVMjVR0gxnD36e4mSO405rEtplDONO2pYpHLaBmO3jKe1389knXyKDqBXK4JgvfiIzIUsOOXGa
	d8xECPrcZDBAuuULSPpBSzh8Vf9ppkx4fCbt397sRbyKzqLPoeKCmtUmuDx8HpADvpedwSYmdpn
	FascRJWNjmeYOsR9NLvcoogDIFvq52l2KX6owTORLcLGzu3yfF1vjmAmYMPn9DIdYHThLiogJxn
	uaB+NvfiDify3W57pXdr+LccC1z2F/myvYyXcsVaW3K9KarIMg+v3SMXxIGKsgBPZ7tnwgF5dFF
	M9QON/VLJS6I4OPezXBojxOw==
X-Received: by 2002:a05:620a:4453:b0:93e:4e27:359b with SMTP id af79cd13be357-94408a5f7e4mr854875185a.24.1793279904762;
        Thu, 29 Oct 2026 06:18:24 -0700 (PDT)
X-Received: by 2002:a05:620a:4453:b0:93e:4e27:359b with SMTP id af79cd13be357-94408a5f7e4mr854870585a.24.1793279904185;
        Thu, 29 Oct 2026 06:18:24 -0700 (PDT)
Received: from localhost (net-93-144-6-81.cust.dsl.teletu.it. [93.144.6.81])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a94f05e4e4sm82381625e9.3.2026.10.29.06.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:18:22 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Thu, 29 Oct 2026 14:18:04 +0100
Subject: [PATCH nf-next] net: airoha: update stats on flow deletion
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-airoha-ppe-flow-stats-v1-1-5cb0c5af35a2@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MwQqDMAyA4VeRnBdoyzZ0rzJ2yGaiAWlLU5wgv
 rvF43f4/x2Mi7LBq9uh8KqmKTb4Wwe/meLEqGMzBBee3oUBSUuaCXNmlCX90SpVw0G+94dnJz0
 RtDYXFt2u7xuiYOStwuc4TuY2X+JwAAAA
X-Change-ID: 20261029-airoha-ppe-flow-stats-9fb451e0f8aa
To: Lorenzo Bianconi <lorenzo@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc: nbd@nbd.name, netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDI5MDA1MSBTYWx0ZWRfX9XCm5pK05ATL
 CxOz4hWRrg+IZVAMlZRvwrjq1ybiWmJWamzYOt2zbwlKlK8YM6I/uz3ub55pS5cinAKbm91BEXh
 J4FSk/zPqQ0G1rZFDrwsap+DfnM/CzI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDI5MDA1MSBTYWx0ZWRfX8rbGvreaMmYO
 +VM0YX0/6s1a9QTsBqLGTPxcM4wJIG3moo0cN86K9qJts7BxHpNt+205RGw6D2X38sDaWHVphiy
 DWUQpHiIvHsp03rNpCJKxlYhQjqss7JmspscTt+R6QUEP2F2TUd78EyJQsnQBj4gMitoTYsI5JX
 lFD7o1G7DCewbdBFj5M0oVy+D//JaqrraKaz0aPvZ7lG6rglVncbMpaiaY/YEWZgKwlllZWpdkX
 k+oKZR4UxDUi7eI1KyfFNx9wZ8/J9cDS+IoQz6WhH4GM0yHbD90SCVCAe7ayeoBov9neyCpV/Tp
 Qhrm3lxbMVvNF9v7zn2vVk5i2sj0n/wBVRXyTi1/+rjBG7eSeC+Sv0WaBuT8STUibSdi7xxBVMj
 0S6g3wQWiag7hfH+efpNM97ReVRIzdzqo5nFUdMPuluMHowfAbqG9nqbVCQTlcoP5fel+oO4acS
 I/Nf0ZkFuWpVExL8mDw==
X-Authority-Analysis: v=2.4 cv=A8T5rKWG c=1 sm=1 tr=0 ts=6ae347a2 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=7fYLNvKHbgS61GKHX+yayQ==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=gWFirymUfySObOnEGkUA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: mjwEpeEpwkraEnYkav5Q9S342hdOkQUx
X-Proofpoint-ORIG-GUID: mjwEpeEpwkraEnYkav5Q9S342hdOkQUx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-29_04,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610290051

Update this driver to use the new approach to fetch stats on flow
deletion, introduced by ("netfilter: flowtable: retrieve stats on flow
deletion").

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 92611802801e..35750b61028b 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1285,6 +1285,23 @@ static int airoha_ppe_flow_offload_replace(struct airoha_eth *eth,
 	return err;
 }
 
+static void airoha_ppe_flow_update_stats(struct airoha_eth *eth,
+					 struct flow_cls_offload *f,
+					 struct airoha_flow_table_entry *e)
+{
+	u32 idle = airoha_ppe_entry_idle_time(eth->ppe, e);
+
+	f->stats.lastused = jiffies - idle * HZ;
+	if (e->hash != 0xffff) {
+		struct airoha_foe_stats64 stats = {};
+
+		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
+		f->stats.pkts += (stats.packets - e->stats.packets);
+		f->stats.bytes += (stats.bytes - e->stats.bytes);
+		e->stats = stats;
+	}
+}
+
 static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
 					   struct flow_cls_offload *f)
 {
@@ -1295,6 +1312,7 @@ static int airoha_ppe_flow_offload_destroy(struct airoha_eth *eth,
 	if (!e)
 		return -ENOENT;
 
+	airoha_ppe_flow_update_stats(eth, f, e);
 	airoha_ppe_foe_flow_remove_entry(eth->ppe, e);
 	rhashtable_remove_fast(&eth->flow_table, &e->node,
 			       airoha_flow_table_params);
@@ -1342,24 +1360,13 @@ static int airoha_ppe_flow_offload_stats(struct airoha_eth *eth,
 					 struct flow_cls_offload *f)
 {
 	struct airoha_flow_table_entry *e;
-	u32 idle;
 
 	e = rhashtable_lookup(&eth->flow_table, &f->cookie,
 			      airoha_flow_table_params);
 	if (!e)
 		return -ENOENT;
 
-	idle = airoha_ppe_entry_idle_time(eth->ppe, e);
-	f->stats.lastused = jiffies - idle * HZ;
-
-	if (e->hash != 0xffff) {
-		struct airoha_foe_stats64 stats = {};
-
-		airoha_ppe_foe_entry_get_stats(eth->ppe, e->hash, &stats);
-		f->stats.pkts += (stats.packets - e->stats.packets);
-		f->stats.bytes += (stats.bytes - e->stats.bytes);
-		e->stats = stats;
-	}
+	airoha_ppe_flow_update_stats(eth, f, e);
 
 	return 0;
 }

---
base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
change-id: 20261029-airoha-ppe-flow-stats-9fb451e0f8aa

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

