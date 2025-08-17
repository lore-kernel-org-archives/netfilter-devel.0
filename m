Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013000.outbound.protection.outlook.com [40.107.44.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF1C1D61BB;
	Sun, 17 Aug 2025 09:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755422176; cv=fail; b=QrzsyxGXFQ8a5BY58i/syfxeaEY8x3B7/vUfrHNvXHKVWUDyRMh/8qgjF8PphU4dg20mt/Li6e98aiknqlXj2h8HLayO06VSDMGAv99CAL/rr0B/HBwW1idHa0s/qNeTD45rww4EbxXq/TS2pJ4865LORAOwkQWlX/23xQKmkRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755422176; c=relaxed/simple;
	bh=17fno8oLqAicFgXdQIHYc7SXPIO6ewx6cncYXbZ/krQ=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=KtYk2qHY9UWjJT06QnCkr22B4oQlYwxDYHBYGSOOFPWGw8Ug5G2f3xO4WY6QGFsMInZFdl8C64icsayXiu7BMnXe3UluDDdvG/ZGNJq4epuJ2zeW/f7rq9GeJC33miNh6gxe0WmoSimWKjMHAvqMdTCBgumi3Qrmf8MV9/e8LsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=ngIq4PgX; arc=fail smtp.client-ip=40.107.44.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="ngIq4PgX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MYGE0iX3Xp2gQBfPNXFrczj/4nvG+JDFGn/SDXpbqfewjeV7AolCw86hIFpCAshMrYffbPq14yltytjro6W6qKOOEGlZPvy1QqR1J1JN5VdmAn7NpV3COQWS2DpTeGCvdHZHWBYum7ZURxM8nQkfrIGncs0FyFiv71tet99wLTriu7PHtu44WLWsmzjEePnu+42VOQPltJVxIY90jkCDpgXFWjnydH693c4JeQzmJY6hoDP13v27RQLQcDph8MrEiOxQOapiN3JCtFD3h1IEpHztAO8s3Ynr2XMOY8XXVWwgVi9HSUT4e3xRHLISghO38KIag0qnIVx19ZO7zk89KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bcl4I29pvNAWU8ZCIzNLzWnheirigLyRhXab0USs52o=;
 b=e+jPJtR9E0gQ9ShwyRtSFWx4iaZF1MIHgczIuB+60ZjJ3MQsmqdvhyH/Zx9Yl+oLZK6XIm3IzTd5YyhvrTD1H33J36IFAy4mTTXjvPmzlgIgK31B2r6zhMVyF5I8w6QLD72VtMufPcp2YSC0Jnjo+mo/aEq8skVRP2FdYjyvO5EdJglow8iQIO3k3LaFSAgwdoX3aURzdgv1Mq98I3ru5XkBow0ZA7ac5EhngCKPGaq4k858qqMXCWvmCQuhy/p0vFGhKt/0M5xBw3ivFATgYr8m3YmlTsdjaIuglGvbltc/2Gl3om0xpqv3AHKna9DrRB2fugpr7juWPLCMZN6l4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bcl4I29pvNAWU8ZCIzNLzWnheirigLyRhXab0USs52o=;
 b=ngIq4PgX124y7o+9hQd2AVqRjsitBGfeceOhgXb9uhWkvj/bhhVdyWR9T0FjKxGsRtbntBNqHs46rqh045lWcLpBcUQF8tZFqKDE7Sg8JnkSOkJwmLGZOp9JmZr4Idu+VpHxO7dtiLfp5iL20C9F+E7kFYldemJgYVUWVPdNnDazoRo2ZmVqNeT1YXzCX6x8mDN5mSknWEa172sXhROK81gxjgF3ZDLfCsp/eoidwGJsQjtUZwYAHVCc7uZmRpjXa5XRU5ccE+s6OTaiLSn2z7q8FwDGW92RW1oFgO4kxXRWuYAIJSfGHMFUBpKj6UcnUWsfHmVU/AaX6RFzYWbfhA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TYZPR06MB6190.apcprd06.prod.outlook.com (2603:1096:400:33f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Sun, 17 Aug
 2025 09:16:11 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%5]) with mapi id 15.20.9031.021; Sun, 17 Aug 2025
 09:16:11 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
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
Cc: Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH] netfilter: ebtables: Use vmalloc_array() to improve code
Date: Sun, 17 Aug 2025 17:15:56 +0800
Message-Id: <20250817091556.80912-1-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0049.jpnprd01.prod.outlook.com
 (2603:1096:405:2::13) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TYZPR06MB6190:EE_
X-MS-Office365-Filtering-Correlation-Id: d53097ed-81e1-467c-df9d-08dddd6eb4f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|52116014|366016|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vm8ixvK5Y0JasGnVKV+tevF7kZSTPWdZKKnjftxLBEBiydCdX0//Na1SS3U/?=
 =?us-ascii?Q?GKIKLbf3UVDDxu/2A/35IfLh7NCAHqE6+ZGWkwsyxo5fOZfVbaXLoM4g1q+s?=
 =?us-ascii?Q?ZpxiNZ7OMBX18rfLBW0RK3RSUfQqS+XR+PakTYCnGT4RhttnHmSpWi4UnSVW?=
 =?us-ascii?Q?z5Kaz28sQfspK86Jqdn7nQ4nXo2dBHN6albu9jCsJHfHWaw2WtPGdNEj3Chi?=
 =?us-ascii?Q?DOoCtjJxYYOIGsoQNXmUnz/Hh6rt8wO+WNqfz7inQBa2HxPQWcmVH2JGbKl5?=
 =?us-ascii?Q?1hi80aQqxH3RxzujZR+blvwAdivvwIbzsKwyik/n+d4G/IhrenSAXW702aiJ?=
 =?us-ascii?Q?z5vJXDcB+nruHdVGSDLU6oqPIUz3OTTEbHHk2478Y4OxeMNZkAb9dZIbd4ZO?=
 =?us-ascii?Q?LeEgRfNvK/kFCVh4RsylDDmixs8OnU20qFfDOI+2qvoof4WHewhTKjqo8R7x?=
 =?us-ascii?Q?2Qw0JmGNqdp4Nn9sPaBfbwvfqoe/FEyXNFsIDVJMmXdZBfFBvREJHCQKV5ds?=
 =?us-ascii?Q?Ic3N5sJOjBM4WOhAvcuXVg+SRfOGfKxJxMrN15Dhh0kinhKZZLMbqtnTBVno?=
 =?us-ascii?Q?AxKpQ6yfDcBam+tktyafrnVcDxSa4w3vd/XSXXl9UZ2bnepcuWIyVXKx5eIM?=
 =?us-ascii?Q?BOTMyntenVYZnT6Wvi9OAYbIVoNm79MyTtCVx7VhzaaxNF6Mp2V/cWUEX2Ik?=
 =?us-ascii?Q?9OLomMMTFVBmzeDEGhv9cMY1ubYl01Cwe9pg/xA1AvMfTSGYTi6VNRkOHiXA?=
 =?us-ascii?Q?GENp/RKGMOtwpbsKy6JjZyOhMwCoXUs2x5wcJTSPT5b79sbxgZpjbCM0+KiU?=
 =?us-ascii?Q?dShODIScz+h1yJU1s8wBO/5mwAmMVMa8ACLj7Z+GYIkA2ORImzrv+5PTnsSl?=
 =?us-ascii?Q?hTge0GdGNYA/JVmFb3sPFQPLSLQAnFRI+0ovhcoR1s41WC+CKkYf6cW8O9nH?=
 =?us-ascii?Q?oZEVbuTBAVL7f9FX+sbxfUr2UVzRQJCSvk0sADwFEirz/pM7ElLChSfVfsBP?=
 =?us-ascii?Q?uqL3h+e68rjcNjLYvD/LXcPlcQ2fC1gw/o4NAzHzgg9WeVBQDKZxsShYsbUi?=
 =?us-ascii?Q?p/ED7r+8rWP2EtTB3U/OQO5HKzQH9rmokCAr1bo59qPYyDMFJHOf6+Z2huSP?=
 =?us-ascii?Q?ESYiUJjjlhD5jBFYMPIVpVGhH+kCiw4dd6Q7BS1GPqOpFZHI6K4J09VX1PuU?=
 =?us-ascii?Q?iBcHOa76ZUORqTLGBpFDPKAcK8TMdSRlfhsvP8BgdGLSWU7u6duocCPLdqiX?=
 =?us-ascii?Q?88JbKOUBqeRFL9svmho0JMrcDN9gG5p7u7k7gV78s4WPr2IUN9DoT7U8e7nw?=
 =?us-ascii?Q?ViUh287wiB1rklJc6pIpYZrM5+SxMWhSuIfOXrC+g4F26tJ04NWm7XzCvmhK?=
 =?us-ascii?Q?jFVYkEiJv7/0ozXdSAOROmiUjRyYFBLL7rbljbYB5dsr1rGmZEta34fCzkoo?=
 =?us-ascii?Q?86NQXZAde1M4H6NIsNVlN6pROynpdBs2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(52116014)(366016)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cre1FJCJAMbKO2kmNnVBMsT9fJMTcjFOw8edA5kWurm8xROMx9+8P4kQPicn?=
 =?us-ascii?Q?aaWn5CbYYohKtMxwAbbl90xLmaZZ3SB2CwthfEqbkQ9C1lkcpL+15DWGd9T+?=
 =?us-ascii?Q?OQM6WHfGDns+/RQZpevYajTCsksNnIcQ5EP+c0lodzcrD1Eokw9ySA15N902?=
 =?us-ascii?Q?JJ9j6jdTfVjbsxstr/kBh3vejgGN/2542nDY3apJqCt2OBJ2i+A1i5vcaKJm?=
 =?us-ascii?Q?JrWFSEwjnMm3/ohU+7pORsm5Ox78mfVUMB1tD4WP4+VdUJj92+nLejyBMcOH?=
 =?us-ascii?Q?bivwojrTt1oAqWxLgwWDR2FEc8ZJvxlJng5iUe/OHtSfZlZRNHzwLuWFTIVe?=
 =?us-ascii?Q?twFcOleGHgUTz6xMp3sVMDe1QQC0tzHaIbwV/dJq7eA63McaomSjqukeCFnH?=
 =?us-ascii?Q?43TzvelctW8MCLU2uyrv14qnOV1uMtLADMUNEFHOkdpRNEDy0bH4K2FTJHVJ?=
 =?us-ascii?Q?3frNb3eXytzK9Z7I/gq/2BpOwbTM4NkfkzrcAePNgzOdORjZkacSp2s40IhR?=
 =?us-ascii?Q?B5tXMKxmlR75JFbEGKfCtY1uCOj+F7eG3wpD07cvVb2v6zfVjZrki8WTBvtB?=
 =?us-ascii?Q?IDC33EviG7Peycy7E41gMAs7EHzUNjkEK0uLJB87TCQRRUROZC7oPphHmtui?=
 =?us-ascii?Q?4Z1GZKKqxpraRaYneJqnGOI7/XmawK+/DVna0aDrLA0zzQ4TP+SM/1XVuVFU?=
 =?us-ascii?Q?r97CxM2Po/U/Ela5bbTbJRe6ZVwrR51/qPfsZBL/aCf5340Yaa2hTHt2PPi2?=
 =?us-ascii?Q?fanFH5tHASLy7ltq5KanuNCIScRsm59XK+8pNXDcfleLDiepQLDMhJM23Psv?=
 =?us-ascii?Q?OQvPnDPUUsA1omohqneoQDaJJEscnpbb/bR59BIJFT1p/shx6YHwqST1e/lS?=
 =?us-ascii?Q?r+Zw06mE37aCcX86YmDMB6cdBrpg2HeLcpJC0C6BKXP65k6CuESuRvCbyVJw?=
 =?us-ascii?Q?BClr5DePmsT5FxvHGntu7EhhIF3WEpe/rgjbjtfofmRo7d31IRAn3gN3M2b/?=
 =?us-ascii?Q?GZaMzI8fNBjFw4AZNwdyEluG9rouv9tetF9c5aZqdlMLtxz4H9OePnrw9ay5?=
 =?us-ascii?Q?L+/xDbXLmzB2Cw8Pvxy3P+gVbICS8poeoiyv+aAaeyQriCBN1Mm/2+LqITOR?=
 =?us-ascii?Q?FoJHfCmzfXkZ0jDjrIe6DkveOlNRsSLZez9TmFxGBQa0Fao3aTRIpS6f+/HS?=
 =?us-ascii?Q?85rJelNQPUEaZIDLIbNpy0irA9Nav0Io7Op2dnE/kuAiJYoZ5m40Mvj/vJ23?=
 =?us-ascii?Q?veprCpoH9Ehow4WPsl3zxLMUjrh6Cs5UkSBHKfgtEJEBaZJcRR2xntJhtMI9?=
 =?us-ascii?Q?YMADPdSfdBAcV6F6gxBZt7QPLYnMxly9kOUVC3oo+6hWVGlPusosTKi/JkrY?=
 =?us-ascii?Q?JYqRY8moXQ7bL0RzD+t489NckzicgS7dWbbFsNeakXeFdKeva8pF8bxwa/nP?=
 =?us-ascii?Q?9Qh+zGOG5bnl/5H/NITR/6KtlE90gs5W6dDqz37euDixghOdpktH1eLXMp+K?=
 =?us-ascii?Q?e1sq9ucHni4N4zyykDmxTdFrG/j4r6a08bo+u5rhAGGkhsEYadH47jzSg34u?=
 =?us-ascii?Q?YFeR8kHXOpydGGqVAGGWSiei72owsqcVZfnq8d+s?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53097ed-81e1-467c-df9d-08dddd6eb4f2
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2025 09:16:11.0476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ThNfP0iFN7ySfwNMpzeMhPl4N/DKDAg5XMVle9QR+eVVzy8c76WYLyk701Kh3sdrBLpT52REeLVvDYkqYl06IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6190

Remove array_size() calls and replace vmalloc() with vmalloc_array() to
simplify the code.  vmalloc_array() is also optimized better, uses fewer
instructions, and handles overflow more concisely[1].

[1]: https://lore.kernel.org/lkml/abc66ec5-85a4-47e1-9759-2f60ab111971@vivo.com/
Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 net/bridge/netfilter/ebtables.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 3e67d4aff419..5697e3949a36 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -920,8 +920,8 @@ static int translate_table(struct net *net, const char *name,
 		 * if an error occurs
 		 */
 		newinfo->chainstack =
-			vmalloc(array_size(nr_cpu_ids,
-					   sizeof(*(newinfo->chainstack))));
+			vmalloc_array(nr_cpu_ids,
+				      sizeof(*(newinfo->chainstack)));
 		if (!newinfo->chainstack)
 			return -ENOMEM;
 		for_each_possible_cpu(i) {
@@ -938,7 +938,7 @@ static int translate_table(struct net *net, const char *name,
 			}
 		}
 
-		cl_s = vmalloc(array_size(udc_cnt, sizeof(*cl_s)));
+		cl_s = vmalloc_array(udc_cnt, sizeof(*cl_s));
 		if (!cl_s)
 			return -ENOMEM;
 		i = 0; /* the i'th udc */
@@ -1018,8 +1018,8 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 	 * the check on the size is done later, when we have the lock
 	 */
 	if (repl->num_counters) {
-		unsigned long size = repl->num_counters * sizeof(*counterstmp);
-		counterstmp = vmalloc(size);
+		counterstmp = vmalloc_array(repl->num_counters,
+					    sizeof(*counterstmp));
 		if (!counterstmp)
 			return -ENOMEM;
 	}
@@ -1386,7 +1386,7 @@ static int do_update_counters(struct net *net, const char *name,
 	if (num_counters == 0)
 		return -EINVAL;
 
-	tmp = vmalloc(array_size(num_counters, sizeof(*tmp)));
+	tmp = vmalloc_array(num_counters, sizeof(*tmp));
 	if (!tmp)
 		return -ENOMEM;
 
@@ -1526,7 +1526,7 @@ static int copy_counters_to_user(struct ebt_table *t,
 	if (num_counters != nentries)
 		return -EINVAL;
 
-	counterstmp = vmalloc(array_size(nentries, sizeof(*counterstmp)));
+	counterstmp = vmalloc_array(nentries, sizeof(*counterstmp));
 	if (!counterstmp)
 		return -ENOMEM;
 
-- 
2.34.1

