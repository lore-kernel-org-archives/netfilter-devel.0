Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2060.outbound.protection.outlook.com [40.107.255.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2960D63D;
	Mon, 26 Aug 2024 03:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.255.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643823; cv=fail; b=ppkfuGAnMbrcCYRM3XajmRjM1qYW67RXW0WBVRotag9WYGMal+8sOLXxBvh1SiXFToj/SQcFUr0YxL5KwCiMq39n2H7RZz+hHTad+Jn4ogWJ8+PpuhCUkRF4G2sgWHf1cSSPwzCmuOxpk04mMl5I5eQGzGu13oGqSHXS5mlOil0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643823; c=relaxed/simple;
	bh=IDfUZpuolrpGtoAQVSLc6s7JwWpprxnPH98xTULsb1I=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=BnGR1nPILGNFST6002I2W6sGgURsoFjJS2qk23q4mqYt24Z8WDcgHSjkt2cLY50CYwBI9kWA4CqSUlhy6BpvQJTR7wSceMsTrTOjCyCDFFFKR+EQsKy47W26t7Btz4yHIsoGRzvejfS1cx3rDquM5Zfz+DOVEiyXh0oOMZZPngo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=mEVQTHYU; arc=fail smtp.client-ip=40.107.255.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="mEVQTHYU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVtDILPr/vOOTeFglgscmO8oRv4ZarEq3XsPvJUto+bSrdweLUWRkqiownzYr8OMsVg6Bvv9ArpRBbZbfY+7a2gGdVwlPIKyVTBv/r/a5/55srJqivirbFvITs0TUOCVCNaXO5HuXWVTpF5+6CauyMdM5ojC5N9bFnoaFSZLUyJ+SAN2uBXJB/bY3F9Lz+6GN6YawptWKEio1UjM5Nn0RsGRk1a77jAn1mFBOOqi15sAnLf1ONp22sPvY0JSitFHXXnM2bGoJn5MNwtH2FWio6b4rZanrJqc00EG9DgQ9vjl16lNX7wxblRNxeTnsIyKgWU0T3seVNUmmpycXPD5eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fgRmxpZKj1DIlm79pMnh6mbofwI1l25XI13i8m+Og28=;
 b=sryU1lN/tHt8I6vejqsX8pZypw+KH9T4QEsesoki7gmx2vv/uqd549YW5YbLNUHZeqZAz6SF4cgXgou5BhkBsKWtE08PRyOYfwIl9I0vmB15x9oZ8ZQl0uCu3Ubu09u5iN9PKZCvrda3J0lbBunJJa/tws3ZFlQxhkpOOjE5jwZRUVqPNlz66BySAc3pEP9c7JH3wHDbVgMUmEyAOPcDdBv28t0FPKW7IIJNNAU37+x5sJM3dp8Q3hgqNr3y6qd9lBlBbGtfUiuHvk4NDqBVYccFcUoeTlKc2z61Jz8xASTYrdJf1hCyl5stthj+PDxsmXYJ1S92XPPuXCXSFqGjxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgRmxpZKj1DIlm79pMnh6mbofwI1l25XI13i8m+Og28=;
 b=mEVQTHYU9djXwWF+aYN+ir7BrqOSfSgDCsZgjyImOSd8AUFLpRgbTSGBxB9RCXzktNk3vSivYKIDF0ANnQ4b9DztWgD1RDH9Svw6V+lfoWnQV3fgOFFLpeIJaGUxKvlafcRHZF3A3rGNi6BeyN83fckrzP9BXyaQLedMUW7SWNneRPj/+HdsLEWdgS1PuJh1/ikFc8PRs1kVUH9RVbjPXIr/ASAn2jwQViLDwLnKPVNuPbR5d/g8wH69McsFLJpea3JgkTpAlIqpJFA8csRmqFGQACzTTMcIFyVrHoxFJP9W3hxn4XMODPtfBq3Dj/iF54Q6c/HYt8vNZmVXrXBbww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com (2603:1096:820:31::7)
 by SI6PR06MB7218.apcprd06.prod.outlook.com (2603:1096:4:24b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Mon, 26 Aug
 2024 03:43:37 +0000
Received: from KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1]) by KL1PR0601MB4113.apcprd06.prod.outlook.com
 ([fe80::7e85:dad0:3f7:78a1%4]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 03:43:37 +0000
From: Yan Zhen <yanzhen@vivo.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	roopa@nvidia.com,
	razor@blackwall.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	dsahern@kernel.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Yan Zhen <yanzhen@vivo.com>
Subject: [PATCH net-next v1] netfilter: Use kmemdup_array instead of kmemdup for multiple allocation
Date: Mon, 26 Aug 2024 11:41:36 +0800
Message-Id: <20240826034136.1791485-1-yanzhen@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:4:194::13) To KL1PR0601MB4113.apcprd06.prod.outlook.com
 (2603:1096:820:31::7)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR0601MB4113:EE_|SI6PR06MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d6094ea-25ca-4998-4b40-08dcc5814464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|52116014|1800799024|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0FqLaNbbgWUbBAMM3HoujyzgeSR1DhUJMInrH6rFdjSFHr/8gGE9OZEFy6JW?=
 =?us-ascii?Q?0N84CEaok+6w9HN1/C5YtsU63xedZglJ6/6zNjl3XuXiJBtncTjCFSzVCzro?=
 =?us-ascii?Q?Ty7BgARFIEXQ1movnPGr9X0J6hlr9vYjhhBegDqvNw/d4D4eY+Ybr57q48j4?=
 =?us-ascii?Q?3yJBwVL+oAcGBJT+pmzmcxCmuOHZr83ACwHIo8C2PlbywjHfwMaaNGolaw5/?=
 =?us-ascii?Q?o5jO2X/tcCumhgb57lMa7rt3uBQRIicpcTkfKP9i7D5Qy1PVr2TPlIwquFx7?=
 =?us-ascii?Q?UEITb4ytkwR76+F1ikvgXp6KJkm8Q9C0S/n50X0YuAFBBhw4KKgEoRfVKsEy?=
 =?us-ascii?Q?O4b2vza3CZR3RcEPmOsxO6yMP4Jf0LbMutOltlvukENiHqG3OWNx7Afg6XAR?=
 =?us-ascii?Q?72j25vKNYznp1+eWg7Yy7S1rabX/U0NlgAE65ZlHh1Itmta+D9R7ITLqxcMU?=
 =?us-ascii?Q?wH1m6Moe47p9dc43L+yzqZCBjRmx6cNv+2LenRDzr9dXJR7hJ1rYjQfp6Mwv?=
 =?us-ascii?Q?UdXc6PIBcGHCwKAbnwgpbUZJvXKzK4LwKMnbdqBDe+0qDRZakd4SADhxuRJr?=
 =?us-ascii?Q?u56SDbW1+xQdIxgquGGD4VCJpO9UvCmzsnheQkCaO+HUOff57qYEHPTL+i1h?=
 =?us-ascii?Q?vpd9uRy5rhPETwI/KickHKOT3jbGiC1dHVQ4Dl6ROrnrJI4pC0kTGk5/NjS7?=
 =?us-ascii?Q?V1mY/GZwVHldlRRQ7Y6Cym+vBLK3SDm8c2QPIwadvjx3hSGcsOldl0io1baF?=
 =?us-ascii?Q?j08Nmvb0iuFeVjvVjT2tvu4OB1BgFgAOHiE4iz0YD6ECevizMVsGYM5JkvQX?=
 =?us-ascii?Q?W1KIlkQZS3bLXK0gTQW1RasRHx3F+xXO1rZ0c6zNfxwU6t2fU+WN59LJLo53?=
 =?us-ascii?Q?K5lFqJqyAclDLov7ijFNURurRPeNzh2Vxur3Wj6e87/lGMcFPqS307Cm+Qb7?=
 =?us-ascii?Q?TVoNj2JWFrV8/D15wBTTnYxP4v+fApiJ3qupyJxMkKRA7fomyBWzDsSb2Gm8?=
 =?us-ascii?Q?p7duFYOnDklnAksUxniyi2gBMWMC14euhstKpVOIDsY5autq5pJdS2g+CU5o?=
 =?us-ascii?Q?H+mCdBX2kBDtI+/PswaFmfKRdLeV6y7eRC61qG2NNOaRb+XL0JUrDFaG/HF3?=
 =?us-ascii?Q?qCZjW+ukGZ8QOYUVlcV4xtVLPUOxeMRrNt1aYyvXn/wcFPnX+rV5EUSl+fle?=
 =?us-ascii?Q?s/fDEyz99xb7gMI22hffsWt89ER8hleA0410nAdkyj6vGlrWG+1+G/ifm1sG?=
 =?us-ascii?Q?91f0FQgadE13gBYwbFNzh6CB072yL/upHswPhABC96l57WYj39cnGEq19FMV?=
 =?us-ascii?Q?mLmnuSihNHDx3tZ5qLFYqkDOD/GHT53zk4gWEOSTCrYv2dfTf0acH7Agta51?=
 =?us-ascii?Q?qqWjMrLN7NmdBxEj6oa2+o1PE2Emb6pafeMM1KqnghrSI4sXQg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR0601MB4113.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(52116014)(1800799024)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QkTsT6En7Wsu2wZvH7KTgI4w/JgYCUpsfuLxAXPTdCLjselwNFrd+p+4Rs55?=
 =?us-ascii?Q?5pXs6kbUD6cjjt9WB7bLYo6US0k4rqSeS54F9LQGZOKGyI1dO8MzIcafIr3L?=
 =?us-ascii?Q?5kTfbGJd6JerhSjdJVyDdTVnAtgYqZ0uzmWFn4TuFoO+cOB3eBH3hUPm8kpu?=
 =?us-ascii?Q?4PrAzQ9P+/uSTkV3A8142JgFjZxu1HfICFaOav22HXBF/6REUXHsvw5fXvRG?=
 =?us-ascii?Q?8GadAqtOGE3o65SkD5/fpVq8/sbzfTvDIm0J+0FeR50e4AY6aTLU2niUbjIe?=
 =?us-ascii?Q?iHrMWvgyZSGmNc/D+DyEf+2uTJWbP33yZ8HKpvK0wbc/Fi2UHUAOqwYtg/F6?=
 =?us-ascii?Q?R+4Su3lOCIUGGBiI3Z7I9YtlykTwrZ3AnKIFk2g3ePuB9CypvRE0JRNH8Hpl?=
 =?us-ascii?Q?HwgE05FAq9hzOjpur2PSvo82rpHcP8pJMdGJZ7tA0lKpU3lwnIb0kd6IdidQ?=
 =?us-ascii?Q?+bxjXPQu3oDxmrG54mvu3agDGkgryCGZUYucI7RYr57Vc6lKcL6sIWUAOKU4?=
 =?us-ascii?Q?6WWFG2nE450UKlPZvlOLyKLFuS4klpt7RXKndp4JtAwVExUh3QrJnZV+lzc1?=
 =?us-ascii?Q?qmf+Lu2u8FC78cugple/Au4rWg6yzpWb+XZcLDQd0N4VSTeRxNsLE3ESCChX?=
 =?us-ascii?Q?3hj5vkvTi26oYfxMTc/JklFdQxnny0TIlC6gF1+4GH95jn+yTnPm/3R576JP?=
 =?us-ascii?Q?dI8fIC4oX2Bg/oAqLmVGj9XcfHPEn/3OMH4HKTFBpfk2dPyb/+322imkzs21?=
 =?us-ascii?Q?TfrvMx1nb9R0eqJeuW29625JoONJe2IQew24xGkhAqBehoWxljX3JNAlHcEm?=
 =?us-ascii?Q?iZpdvr2+ERiimP85sGPDDRjWPewztLn6p68Y4PQPqcMTxk5fSBqLfi0bjLEz?=
 =?us-ascii?Q?b4AuuIPmtjUHak4xyuuzOxoaPA9mcCDdQJt7gnrwX3KfEwSrCilKb/HBfyGy?=
 =?us-ascii?Q?klfE6Hx9zGDkXpJmCEI+e9RyCDMZAy1Sx1MckMFVIO2rHzFXnbiTcmZ7F3/u?=
 =?us-ascii?Q?v4wmR2GNoQdtkyYPD/7DqJgAhrTkmjPYvR5DumDxU2T4ZxgfzGgY5w/Q2XvP?=
 =?us-ascii?Q?s/wtUKz7hyV9a2G3q37HXF7llZ4+1PvSzFGuaPwEUhZjAyyid3/XlWLe1XZH?=
 =?us-ascii?Q?MOKRBgCYY+7p/qV2Pk7SLr8nwIfO+3C/9KFMJVPp1Fy8LUXyPB5+zoOwYT/D?=
 =?us-ascii?Q?SewGiwnz+WcSNSvgA6LsjVV2ObklmOwcpzd0QUsw3uqUPgQh+ChvRWOKgYvD?=
 =?us-ascii?Q?bZQ/4BXSo+whalhz74V+EsNb5UBXcVIZ2w8P7stBmoheliMlNa3iYbZFaApZ?=
 =?us-ascii?Q?MP4DQcUQ2IqrAEAkan9lNKC/GiItSnjaP7HsZ827RnHn5P/Vj3mJx9ogv3cp?=
 =?us-ascii?Q?mB1GjMj67lki5x2xnrWeNHuy7Q1wztVjiYfpfTT86Yp8yvGPHyaHZH7nNcAn?=
 =?us-ascii?Q?Q803AfjPqTecWcsvo7wclAlNcxi4bE2PCnlsmczEc9PwSu6sf2c2fDnSQsuE?=
 =?us-ascii?Q?6DecQl6VB+a3D9BdrvPdwO4kRgpK0i5FL6G+Ekh6Qwy3Wx0NFv79D1L0qHcF?=
 =?us-ascii?Q?t1Gogy/AtSOXIXolEFQNxXS7z3ru9Y2nMgudjUa5?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d6094ea-25ca-4998-4b40-08dcc5814464
X-MS-Exchange-CrossTenant-AuthSource: KL1PR0601MB4113.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2024 03:43:37.0058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +N9HWk5/up3KSwlrIsAXVyEEkQVZNHO7XcPATPil68MQWE1arzH/G4yT+ffghczSuTBu6IpNyenLG8Ps3MEFkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI6PR06MB7218

When we are allocating an array, using kmemdup_array() to take care about
multiplication and possible overflows.

Also it makes auditing the code easier.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
---
 net/bridge/netfilter/ebtables.c | 2 +-
 net/ipv4/netfilter/arp_tables.c | 2 +-
 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 net/netfilter/nf_nat_core.c     | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index cbd0e3586c3f..3e67d4aff419 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1256,7 +1256,7 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 		goto free_unlock;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		if (newinfo->nentries)
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 14365b20f1c5..4493a785c1ea 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1547,7 +1547,7 @@ int arpt_register_table(struct net *net,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fe89a056eb06..096bfef472b1 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1767,7 +1767,7 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 131f7bb2110d..7d5602950ae7 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1773,7 +1773,7 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 		goto out_free;
 	}
 
-	ops = kmemdup(template_ops, sizeof(*ops) * num_ops, GFP_KERNEL);
+	ops = kmemdup_array(template_ops, num_ops, sizeof(*ops), GFP_KERNEL);
 	if (!ops) {
 		ret = -ENOMEM;
 		goto out_free;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 016c816d91cb..6d8da6dddf99 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1104,7 +1104,7 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 	if (!nat_proto_net->nat_hook_ops) {
 		WARN_ON(nat_proto_net->users != 0);
 
-		nat_ops = kmemdup(orig_nat_ops, sizeof(*orig_nat_ops) * ops_count, GFP_KERNEL);
+		nat_ops = kmemdup_array(orig_nat_ops, ops_count, sizeof(*orig_nat_ops), GFP_KERNEL);
 		if (!nat_ops) {
 			mutex_unlock(&nf_nat_proto_mutex);
 			return -ENOMEM;
-- 
2.34.1

