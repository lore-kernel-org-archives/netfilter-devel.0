Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6805D242910
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 04:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782189481; cv=none; b=C58FA+cBSzs0xOhbajeCYoPLnT9R1nEf7p1mDZpWM2zAbncM5zd6IIGXXqT0tSVnz/PSO84gjY9SdqCaKk+bGmwh5Z3Qyqx0+OH7U6Q+Pj8TXlSvgLAtENOFRVrDxoRyGYVODDBPC0V5gZJhVhLUiTcKGJbT96y7T+qk7LpivUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782189481; c=relaxed/simple;
	bh=qXZWkoiCKLMim6HuotDbTAxE37cBnB1jTL7GYOnURYw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cVjfsuy4zHkoctFaVAgCrZBg5TfE9o8rOpVk7rlrI7qKDi5hZb5zZinp8GuGJeTlFMZv9lL5qm/Tx20MUVMszBM4OpbXctjTvKFdr/IJ/Kc3XVm/okG+R7lDR1DWfBHb+oKwaYGP5og3t4MJU0U+0U853Isd9NsYYb2xvbEcYzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=aqkN9Pgc; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="aqkN9Pgc"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0gVdn4058880
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 21:37:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=ews+WPnVhBPCu2gwg93x1h/
	MifYCkuKjgcweecLy8MQ=; b=aqkN9Pgc5OIEAb8A0pNQ1TpNxthB+nX3DgcfeB7
	WxGP9lh4BxI57a9sSUGF5sxdVY6B6N9/K5QW0FQD/lqDgFP9EPCup+EG3ySl359J
	UJA+Hm1YzGBpFYTOT7NHvoNW94bpX7Eog4tUPmF2sqOeHy5uB+mpthvK+ndhXreA
	epZnndm7ENOo3ePmbxsqU8UhGYuwkzYfQB+CAXgtLpQOZFiDZuSlupxPZhvYeXPv
	U2zTrepXLTLhb4tRlxKDzIa6iLq5iTUjBN2tdJGOZcF+U9qjmadrXtN3w9Q7+FIs
	InXmjq+OHszUPvFF54JqKG/Zggz6uOi1EwApINyZJQKabDQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ewr7hg79q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Jun 2026 21:37:59 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 22 Jun 2026 21:37:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 22 Jun 2026 21:37:58 -0700
Received: from rkannoth-OptiPlex-7090.. (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 3BA3F3F708D;
	Mon, 22 Jun 2026 21:37:57 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <netfilter-devel@vger.kernel.org>
CC: Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH] libmnl: add MNL_TYPE_UARR for devlink u64 array attributes
Date: Tue, 23 Jun 2026 10:07:55 +0530
Message-ID: <20260623043755.2435685-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAzNCBTYWx0ZWRfX0z0frqCEGuUs
 MEtTlWoftfXfm5+nJ0mLWu6uCUGJwvLhuAzw1R/AFXztH3JGc243IhTv26vG3Zwtq6eG42b6j5U
 5Z9QC/SDAIRVZUGo3SOJi5WkfP/v1Pz18+O5siL7rK52UCFtXNOoH8ZQNye1uYPvJHoDJfHyIqS
 MIRzamcfv1fC66dd+v+FkGh1JK9CrkJHjd28un3hmLmPUytt+UJVitT33XhN4PlxWkwQBSQ9JSV
 cBSogOX06nCCgao0rzqQjFrgXL9QgK4e8F6ks5zbGpvUNV40Rzl52QHFIDTWUc3Vsb2JvY8CcnF
 nUvuHL6cf9edDf3SJgvKpCz/9xwVtg9N8V3GJLUO3Eq1aU/KllWMIlOMdOFpRKLobGD0tWlYEuF
 6cMk7XIPuWC13ynS7BwGec6OgeyquzTJZDYa44dNUvUMunDcN992MSqyEmHOOxlX+LxqyxYzDHh
 JQA4B+1edinDwqOM8pw==
X-Proofpoint-ORIG-GUID: RFgaXTD8BhBtefMRl6BriJAO07sLSmkD
X-Authority-Analysis: v=2.4 cv=aJTAb79m c=1 sm=1 tr=0 ts=6a3a0da7 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=DFPYBk2NyuaHhO6lkNcA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAzNCBTYWx0ZWRfXwYR1gyJxgBjd
 mDYHJnf2RqJu9bVJnpAriQxZjCWU5ygNchRJyY3HfQYlhEhg+r42ruwLSMeJqA5Hk6+oUVgPrPU
 QChYF1mp0pEV5IOXq2fo9Vl/5VnUPk8=
X-Proofpoint-GUID: RFgaXTD8BhBtefMRl6BriJAO07sLSmkD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01

Add MNL_TYPE_UARR (129) to enum mnl_attr_data_type to match
DEVLINK_VAR_ATTR_TYPE_U64_ARRAY in the kernel. That type represents
devlink param values encoded as a nested list of u64 attributes in
DEVLINK_ATTR_PARAM_VALUE_DATA, allowing drivers and userspace to
exchange variable-length u64/u32 arrays (e.g. multi-value devlink params).

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
---
 include/libmnl/libmnl.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 0331da7..078d517 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -133,6 +133,7 @@ enum mnl_attr_data_type {
 	MNL_TYPE_NESTED_COMPAT,
 	MNL_TYPE_NUL_STRING,
 	MNL_TYPE_BINARY,
+	MNL_TYPE_UARR = 129,
 	MNL_TYPE_MAX,
 };
 
-- 
2.43.0

