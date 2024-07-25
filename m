Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2074.outbound.protection.outlook.com [40.107.212.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FD8224D2;
	Thu, 25 Jul 2024 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721913533; cv=fail; b=T1oMjACfgOuOgNKhTo7tPHn0suQ73WS77M9UO4qJAAsg24TFiWAcaUE5NyON7xLvF991CeFuZner6RRawAa+X8BmPgwyDPctFK/eOb1tbOTJtI0KNQfVLP3Tk59kNDJY7x0bn6IMm9ADL4gdxcpLNmSSAolstg8nMm6E3cK3ICw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721913533; c=relaxed/simple;
	bh=RIj00VnVstEK+lxpS/BXoSEBNRg1AeMEGTcR10s7k5M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QBF5WRBZEPAeCiPrZLJYJunZvcaAuA7kPmZlDULHUJpwondmhhS6xZZobxshdGjkXkLkpkagwJlOT/DzotQTjm6p3CvkKQVVBPXex9leXQfWaXrKtD025lyZhIZRHkYltM53WxH9cRuGUTlX1to6VJUTpUzs0OLa2ROokSt7UDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EogQx50/; arc=fail smtp.client-ip=40.107.212.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EogQx50/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xcskGvF38kozE+p5oiswAkdbcmx2BDUaJGV3OsJUjQ4RPaGb5VxbV8sauCb+ZHKWq1OXlYBfRKd1+AcCnKtLS20sk5062V/Kq2j2wh+EWieEab34DBUk+zeiCXiRh1/SjHDczHEfjyzEf7/LOk+XAd2NRRHTtjaWEjfOndX0kVoOAOBZEzcH7T1E4CDIMzKx09okWBtcUzYZRUBhGISyWHrZHWowVVuSNuHMsxt6ZQJoSiKJSNeV2bwp3VasnIw3WgAypLct6pfpMNKFJQWR7bYCQtCY1/mO2RAqjMfqBthY2zHUcUEP4pTBf2ttA3RYJPtFSGtwE+Hj4ABUkp3C8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNtOdNl+b/HhsOPxv1j7oWqlV9demS7KHTYmL+v+XMY=;
 b=H75jWanvnA8v2WTNB1wfOS3f9AAu0g87cXZqsL2Bn4y5hG79ZonYkc/PbnB1ayqy3UstTRENxIkgeKAG3b5WRShSZ+hMgwO7LjM92ZV6JS4tl2vgIJ5Huut0c9qseEPLwBn4hr//fZIgYfWM2z/jrRqk+rwu7TrqadWG1uPGZvMvHMdiBeCEaOVz3VSKS7tCjVDy700P+EKRoVhsnqaQRkbF8EZiY1ZLzZbvhoV0pwL7UrkLA18mBpKBom6Ik22mJZDZXvC8cubXSRWKtlaxK8U3fiyoKI+x//nj9KjJkRfrl/COT3dC6MjO9faLNSKdoekOm5udcpir9rkzkMgMfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNtOdNl+b/HhsOPxv1j7oWqlV9demS7KHTYmL+v+XMY=;
 b=EogQx50/KsF84dqN6M0ytnu20jPK3FJ4MjDz9DE+8onmZablvzqEG6qALn4BdmLoytoGxwkRXfbuzD97u59YnBu/oDnBdJlRTIFMNUN5MDTAvbpJQWf2q1SAd6opi0fKpMAwlc+OrK3ydNwAIT6iMFG8nuq1PFPqLadrSDnHip2X5Q0wtHvQjnZaPVmtMzHv/Wp9VNGF/VwhWptWtsNf6zhRGBkQFccRVbZOJxUbrEPvOaiw3FoGEGA2fE1h8x0CDvaw5jij7QSYrtF3/4+roU79BNRxoe0f3btaGx2gkut/Zg+4MVyPlzWr7Dj7uCiI1G9lnXiB9JcbwhRc5IjyRQ==
Received: from PH7P220CA0032.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::31)
 by LV8PR12MB9449.namprd12.prod.outlook.com (2603:10b6:408:204::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.28; Thu, 25 Jul
 2024 13:18:46 +0000
Received: from SJ5PEPF000001C9.namprd05.prod.outlook.com
 (2603:10b6:510:32b:cafe::cb) by PH7P220CA0032.outlook.office365.com
 (2603:10b6:510:32b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29 via Frontend
 Transport; Thu, 25 Jul 2024 13:18:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001C9.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.11 via Frontend Transport; Thu, 25 Jul 2024 13:18:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 25 Jul
 2024 06:18:32 -0700
Received: from dev-r-vrt-155.mtr.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 25 Jul 2024 06:18:28 -0700
From: Ido Schimmel <idosch@nvidia.com>
To: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <dsahern@kernel.org>, <gnault@redhat.com>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>, Ido Schimmel
	<idosch@nvidia.com>
Subject: [RFC PATCH net-next 2/3] netfilter: nft_fib: Mask upper DSCP bits before FIB lookup
Date: Thu, 25 Jul 2024 16:17:28 +0300
Message-ID: <20240725131729.1729103-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240725131729.1729103-1-idosch@nvidia.com>
References: <20240725131729.1729103-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001C9:EE_|LV8PR12MB9449:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f28b52-edaf-4934-7e2f-08dcacac5005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GvJH8CQVTENwSoqNisqwmIpy8MzoMNJlkyk9BjmH8ofHuD8w9Q2MxREIOKuJ?=
 =?us-ascii?Q?GM/bnWwhEh5DU/UPCT2YIm15GLTU1zRBuUf/HSFKSYSdUJE0EU5HZptKgH7z?=
 =?us-ascii?Q?Ld/+AzYwaS0sia2yLbUIMR7XpN18JLZ/l3tAYAoR2rI+DT2096LSAAeDPNrE?=
 =?us-ascii?Q?wvc02fprpfhVeF1uqiw1hU7w00zxpa1SweKh72J2UZU0GuBp8VWhxg7rmoF4?=
 =?us-ascii?Q?LYLw372HL8y8afexEN2t9JXdDbedwdPY9dLUygqfIvpWbUPF4ELOU+85ecpE?=
 =?us-ascii?Q?ZLQPbuffnCb7c0DSfqy+IHOLesJQQI4ld9kw/lWV6PPpwNQJaftDzZfo5BMe?=
 =?us-ascii?Q?3sgkr87DC1dZPXeYiyGJchTZqyHKTz3s+t4zEQAWlgW844tuwZfI/qn3rf1o?=
 =?us-ascii?Q?JMKIoievhzGjGfxuPYMJG6/1vP+7sv7Ac3bCMIOuMwf7vi/VPco1vsA9ylSR?=
 =?us-ascii?Q?b336xy17qMaEWWtGFww2cRo/fGXRWEFpZn9tpoLSsBedTlq6nlEaukfjXQn+?=
 =?us-ascii?Q?NQZSImC20QrCNF5x/CT2jA3m9MRe+2pvu53yUfPKlDbCJVmKtLXnTy7Za0Q4?=
 =?us-ascii?Q?Iks/shJx+LKBqqXZ8+vAzWLi4kcQXOcDrklVBjf/eemCcvTv2X8JYER2cq08?=
 =?us-ascii?Q?qGvO606uAtKphFtaixWvEG2TG/oCAnS5CkctCcJ5QO7hn6IYTPRrTZnmoiTQ?=
 =?us-ascii?Q?FbT+JNEcSSJHgikN7Tn/8j66N7Rmi6z56cklqsCn6NRLNJ/Uk2DfreDbV/nr?=
 =?us-ascii?Q?D8UkV1mIkowUAgYunzRC23G2lIkFOPrs5drvJSjw3czvpAkhldm9vaN9bGfy?=
 =?us-ascii?Q?nQLpLaMz+w8QmAmEsilaKV2pg7pXLI2dbCsMUZyfgy7vVulOIatcTWj3fD3U?=
 =?us-ascii?Q?IaMFgJfthZkJkDtSv2D8rKldyxrxCuC2KLLE5w4CoNki/fHp9hlr8b41ZJp1?=
 =?us-ascii?Q?VHdAmt75/3yaPppa4Tt8qsvz0R2k4E8HTCzimYTFOYmpb2mb/eQp44gDjv4p?=
 =?us-ascii?Q?+Q1cRX8yUYVVNV/mRvqU115uYsn4xqzoJ2D1WV5PYX6AtQuunMAU3NcFiXA+?=
 =?us-ascii?Q?oMMLcmHFR2b4xYMKEdjvLE4gfxvWZfuvDpwO4EMVPgz71R6/7O0hwbBRstoO?=
 =?us-ascii?Q?epzZggy1FrC0cafS64SUx6ekMGLaFs56gZwUp9ixq9zBkg1AaRcPZOlDCV+I?=
 =?us-ascii?Q?SlmNoea/SitAvhDEzxbcIJn4cN3X1tUx37CvyklS9Ig+dwKke2E9rUQw3afv?=
 =?us-ascii?Q?CADiMt+FBt/tSjmaZ7NNdjzvV9iVs8Cqv7tNI2Bo1tT3kpgnWJ2t6d3gFr5r?=
 =?us-ascii?Q?44o/HHtPHApOAGuc9W1BWQtXb7t/XRBbUlhfdgQ/5kdnbEaA2vGKvzKtM/5T?=
 =?us-ascii?Q?LMIyZczbrvaC7HKZ4WMunkt+V4LlYRk03CHyHgO9VozRoNKbB/Wdp0h8ywxu?=
 =?us-ascii?Q?PAmVMNJPngo7sH1C/c5Y5kv6lfMQL3B9?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2024 13:18:45.5407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f28b52-edaf-4934-7e2f-08dcacac5005
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001C9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9449

As part of its functionality, the nftables FIB expression module
performs a FIB lookup, but unlike other users of the FIB lookup API, it
does so without masking the upper DSCP bits. In particular, this differs
from the equivalent iptables match ("rpfilter") that does mask the upper
DSCP bits before the FIB lookup.

Align the module to other users of the FIB lookup API and mask the upper
DSCP bits using IPTOS_RT_MASK before the lookup.

No regressions in nft_fib.sh:

 # ./nft_fib.sh
 PASS: fib expression did not cause unwanted packet drops
 PASS: fib expression did drop packets for 1.1.1.1
 PASS: fib expression did drop packets for 1c3::c01d
 PASS: fib expression forward check with policy based routing

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 9eee535c64dd..df94bc28c3d7 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -22,8 +22,6 @@ static __be32 get_saddr(__be32 addr)
 	return addr;
 }
 
-#define DSCP_BITS     0xfc
-
 void nft_fib4_eval_type(const struct nft_expr *expr, struct nft_regs *regs,
 			const struct nft_pktinfo *pkt)
 {
@@ -110,7 +108,7 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (priv->flags & NFTA_FIB_F_MARK)
 		fl4.flowi4_mark = pkt->skb->mark;
 
-	fl4.flowi4_tos = iph->tos & DSCP_BITS;
+	fl4.flowi4_tos = iph->tos & IPTOS_RT_MASK;
 
 	if (priv->flags & NFTA_FIB_F_DADDR) {
 		fl4.daddr = iph->daddr;
-- 
2.45.1

