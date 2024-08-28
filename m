Received: from HK2PR02CU002.outbound.protection.outlook.com (mail-eastasiaazon11010047.outbound.protection.outlook.com [52.101.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AF416BE29;
	Wed, 28 Aug 2024 11:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724843234; cv=fail; b=hxUV3FDGTm67qZN5iTNU6rNfoxUe4Y2B91JfN4x1AuPUrjX+Lh8f3vqfYuFK0UGsXepDNiPheZlWuEeIvuIZmnt1vwFopb2I+c1v7QX8UtutcT9RKK2ZXsDEAiqH+T5DUYk4KYcvBEFKMuvogmQUUs6j43SUNxm0B6r3FG+nj1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724843234; c=relaxed/simple;
	bh=Gzw8yUu5KhYCCCR7kxL6kMowU6tyVh70ByYXGMvcmfA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=CHrgMMaXyPCvvhFvY9pvbi1QjPx5/qPM3z6wDkEC4VqxJ5ZZ9LfP9mlEd9q4Yh3zxaXkofMaJMsU8YCZcxJOV3pWpCC3iX+Hlz3R7+htlPJOphdA1TzYhLZKwUFAiNra6MFetPY9/2CS6eENKCkeoSO7/7d8roFh3TP3V1XBhDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=NSDzLuwW; arc=fail smtp.client-ip=52.101.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="NSDzLuwW"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NVFLGVegCrwbPkX7T0MlqzZSjadtc2jX5w+DJXW2kFpffHC6ZRi2z18oY8SGVYmBnCSHnO05pqK8uRFxBEZeqMKCiycZTcxyAVpgMCaQQoomJPevaTU9AvsndHr1Sy5+RleBL3olZK8L+r2dyWD/lFJR2FtQY5OlliZqF/eWILZGvScoC7LuTd+N429sULUl7S3hV5CfX//G6TYRpzk/WqJvFRahFb/uSckI3XnLqByD/zJyDSOWqI/7trIThSQH5PRCmqiN6TSwRe9D93NndcbF44cUqB+z8p5lIhKXYG28kTLoCMFTPErVf2ZK8xXXSsQH0MHMNvimelink9Vupg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n49bgZEkPQ9PBXh10xUtzvtiuIXZCFXL1EYrWBB9zZ0=;
 b=nUuQ5DLaMTgbIqIp2fUqKNeF8cWI5w+pWBF2J/PVz3QHd0/7LnqOjdxSrbHGul0f3+rdK+X1tzHP0r/9d+7Y0CfmlKlsWKVzo5UMXTKkZm/bqPXZyNcJqmNOuOKAm/P8chncA7EG78Et2fzIV28OL+ZasYyfqEhiTgrgn31dsyHnq1F8v8marumKub5qrqsU0nAN92Klyt8xb/7+4wzK1juiISCJajtU7R2WlWpAe5l0q1FCal7CJDbgQvIcM0900cQ/wGJ6h95A48Hdlz9wfYemmnZTi/GXttt2ZahkvoyHUivGO0fgCoA6detPtVBpfjJ4CUvGUhiijFvzRFB7Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n49bgZEkPQ9PBXh10xUtzvtiuIXZCFXL1EYrWBB9zZ0=;
 b=NSDzLuwWHgFfchOLvNv99st20F1rxFTyepiciFCYinBFD5mMamQL8liu0XBHevJS2lNea91VVDUj8tla+xOG5npbctbMcpchMc2fNWq8M80xfVHS5Dwlumggvq7ff1Qdob0yhcOTfbeLW2oeufh6nF6CRSmvwfmL7W3D+0JhOOmcygGjotbbSTLyGV2dyakSkhYjBrGyJeJgCHq8jfhDC5kBNOatVD7YOKYlJrCdv8Dgj44r6gIL9hMOSv0dgNrVduGEIxFKv1QB4/VU3eYjBnlM7BLU01Oplcw0Dr7p9SLL2m8FmuzOGeeRzVYrgBZ+aI3SRGRmtUnC5tJKesKBSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com (2603:1096:101:e3::16)
 by KL1PR06MB6258.apcprd06.prod.outlook.com (2603:1096:820:d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Wed, 28 Aug
 2024 11:07:09 +0000
Received: from SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce]) by SEZPR06MB5899.apcprd06.prod.outlook.com
 ([fe80::8bfc:f1ee:8923:77ce%3]) with mapi id 15.20.7897.027; Wed, 28 Aug 2024
 11:07:08 +0000
From: Shen Lichuan <shenlichuan@vivo.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	opensource.kernel@vivo.com,
	Shen Lichuan <shenlichuan@vivo.com>
Subject: [PATCH v1] netfilter: conntrack: Convert to use ERR_CAST()
Date: Wed, 28 Aug 2024 19:06:51 +0800
Message-Id: <20240828110651.56431-1-shenlichuan@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To SEZPR06MB5899.apcprd06.prod.outlook.com
 (2603:1096:101:e3::16)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5899:EE_|KL1PR06MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 4177cd84-5609-4239-dce2-08dcc7518e91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BLmhhPVhjTChL0P2QYFsvoP3RNuMEHH8GeQDYcGKqv0AIX0pvxV/tEURfHMf?=
 =?us-ascii?Q?dQdOWh/1YT28tffTQV9C9sY4Bso+GbvMmXlDQOeD472VlTcKEqw0TAwyfDD9?=
 =?us-ascii?Q?WNxlcu51kCfaGiqQQt+ng35x19jIqvaC6Za8c+XMisgCUSXGWqaiDh95McI3?=
 =?us-ascii?Q?FZEN/JAYCqud5Rh9JsmWyA97ggSoYn06xsKEG3XhMr2CneVNaucaWBRyXya5?=
 =?us-ascii?Q?3Za5hsKhCJzEE7dyO83dvA5I5voN5CtM9aBjgi2/OrR/UsmZx5nrwDWaSiTo?=
 =?us-ascii?Q?bp8+4q0I+nLNH8v+56CPe8VyYKN6fdk+Gwb3LwsucoxEzvwYKCdIe+rYYbUL?=
 =?us-ascii?Q?SDSzWGPnPhFzCz2TafpVB1y335zTjAIaU+lU4Uh3DXTjwYF5LDomkXfM0lre?=
 =?us-ascii?Q?8K9IiHxcNclBd2Gd9fgtYJp7Ovl1CwtbYEuMXU1O1MnQE34WTgxwWVG0BlQ6?=
 =?us-ascii?Q?bxvCI+S/CysrwUg7QQybirn+DY05wmCrKuB98D9Kal+vZYU3xhendRzwELD2?=
 =?us-ascii?Q?I0/dcDrRovBnP/VpxiOUI/dN4wgB2PNbXugl5hFYEO/xnjW7LOs6PFrFtI2d?=
 =?us-ascii?Q?eaywGvsrYmgQw2XQ5H/RNdn11qHt6TcJO8xRKaEs5nOY0BzwYCg8sEIiNeJM?=
 =?us-ascii?Q?06b2EK6Bb+o66Hz+viNoflOZZlJIZMW4maEytd8VZkM/JtUqb8x5z+k9bkaQ?=
 =?us-ascii?Q?JJKzp12UV9Y0PtVPKTOn+H8b9JgdtyzALHy5pBVlOugh+rCcw0O7PkSZWzOT?=
 =?us-ascii?Q?lgcxnRw1Ymz5GQsPWZkcAeNyUhjVmeCr65tI001qU2beegjvXr6xi7Eyiy6h?=
 =?us-ascii?Q?GxXIO3ASLaG/TcV6vItInULAm7K4ISQSz0KLi4IULgweBpNyIp+1iFEunoiD?=
 =?us-ascii?Q?NClt+HvgxR95pC2oUbUzZUa7V5OHHny23OPWqM7mRxFTsUNrXxNeAj7WPHkq?=
 =?us-ascii?Q?Qg3NIuy6HiQY5U2+uEo1Nm6qH6pP3cp3mePzd+y3FhMqK0LeVTkS/tly4thc?=
 =?us-ascii?Q?g291ldhy1oWL4VT9VNxaCJRzHzEl2AmXKAi/KdE+T1JfeeqXlHecvLvuW7PQ?=
 =?us-ascii?Q?+G3XnfcTPht+40RaHFepBUNV/W+EbrnCIHnOidXjLFzyJAbmgXSye1Towe8H?=
 =?us-ascii?Q?byyU3ykgrCEglXSFI3hhYWQq2jFlPJr1fFONn/sYdMnpx4qL6UP0lzqrm8/4?=
 =?us-ascii?Q?5mImWcskbks6149YUguQsSrYAefMdgmBXVOGPw2kRbo24NlHlnzm8O+tGI/V?=
 =?us-ascii?Q?Wv75Fx020hocHFTFYJ5CF3mVeMmCSh7lWNgpic7EbJ8S36C8xi/3zksNBEs5?=
 =?us-ascii?Q?JXp+i/DmwknQSKN8HSv2DB6rCBt8XgncJDZ/ApJUFPXTg7ZUWfeE5+iYvsUu?=
 =?us-ascii?Q?r0wcwZSUkH3NQ74XMywgrFM4tfskNohbjg/0zQDXa5d2l0TZWw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5899.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GXpyqXpaRGuMq4TmqembH02JSZwxujPnPBkOX+539zYv7LYHwRXVCr2TqTP0?=
 =?us-ascii?Q?kwrmRElTOMHaVV+8QFjBi7L38SbUMETYfrUeYwgRe43twxBxKg4dfparuQPS?=
 =?us-ascii?Q?qPhs+xSnARA0ZjIf676cI/fGzmBW3CFKyo1oNLN+nFy44RnjPztj3PPVIC9g?=
 =?us-ascii?Q?9+DXUFQks/2loljBydHaMrSKhAlWABfLW1nYnHkbjUf96u8Sf60l2Yru2xv2?=
 =?us-ascii?Q?yQDVcXz7F5Qpu0doN5n8RXm6+FZe6UXmX58u0VsDgP9qPNaVX0qM+YKmJzBu?=
 =?us-ascii?Q?zjdMqZQk+pj59NX7uTmD4r37G0oJpYJI9xYMHOsklMrBYrKzhmBwUpsf8aFP?=
 =?us-ascii?Q?C+wJ2P5/tpUaRDwUiJ8GQwm5VEJqOt8m4PkKLafg4hPWz7iTsC5aYJgWLJCs?=
 =?us-ascii?Q?dlLxvxKsolCv1+7RO56NYjQCGf46vtxbAeQlasxWff4jrFsM9qNQlElYSFxy?=
 =?us-ascii?Q?J+ZRDoEH2OKhZeipBl9NW7byRyIHHANO3LPu7YuNf2+h4yjbFvzBLePOdac5?=
 =?us-ascii?Q?vZ0xgMrjGOt0ahIZL9wNoZBEL1Pj5pYvXVvesWf9MoThBA0mV81y0D6YZhBy?=
 =?us-ascii?Q?qd+12/upXpYcyu5TsMqr8JSlvYl2ALeLUFeiyMbVTA6lbGJBrpPbbz4GIYYe?=
 =?us-ascii?Q?WVabS4j6l7tV7+pEq6+StRNMATil3VQN9zeS/vYuwdsjrjdTm1ElQRzaAvFX?=
 =?us-ascii?Q?Xpt5X7UEEWijZp1cTH0O7Cwr9zGz9/OiY6NAF/pOoX8EglHHrWdyVruo07zv?=
 =?us-ascii?Q?8gA0RugzyR7ofDJUssKQ4oO6YjNhkwuz0Q4GTthSmX1H45okdWD6YmGa2XIt?=
 =?us-ascii?Q?tywx7pFxZVYwl66nXpvkbKz8Ie8EWhDCc5v9nR4IyMN4ph6meaOfONI7ymhM?=
 =?us-ascii?Q?ZmOuNZCBygOSM38NIHeYeZ/EGdOk7oFckGev0D/JKkalLrVSanrchyzY5mW1?=
 =?us-ascii?Q?aAtNmnj5k6egQnxocjnicLpLArGVzDZI+YIpaYc/do+q+U5Oq6vXZi4wOWoQ?=
 =?us-ascii?Q?STCmEMkeUhDBmV6QSldBvedO0LWiijR4WjoB7yLiuU62XNWh0/nlDRHTxx8D?=
 =?us-ascii?Q?tQbHdMr/i6f91wX5/bHO2iMzCrmwTWeS3F6eVt5bMdVZ1RFt3viQAsMOUtir?=
 =?us-ascii?Q?hTm3VtWfzfF4Ndv0/Hb4PALV76I21KsrzImBBu62bSy0A51wr57RzcGhdkxR?=
 =?us-ascii?Q?+kCGjsukLd2lZrue6fBUEQq0GaaTZzd6ut1Yb3Y94iMmXIjxy0pUOdcVjwNM?=
 =?us-ascii?Q?g5nAKcg58e/iaAiCKfea72C9F255gTQEAkJD1aiDwh6QYb8Skg0TpUdfuqP4?=
 =?us-ascii?Q?Ll77Fwafo12dfaFrZXB3+B0aDtwnwEJ/9CrM/DWPGejhX5ea8fFaVltqtXz2?=
 =?us-ascii?Q?Gn24MiuwozPdllynoZp4HbVObMJcbh16nnKLomSW5/FV95PKcFtp+eAh5Dup?=
 =?us-ascii?Q?r7+YIQBoJYDZGZp46QjDgj3P0I2++UgMzOgf/7wYEmtcc3phLKIrEYOYmTIQ?=
 =?us-ascii?Q?zsROaxLIn7tE7+V4VbuYSEML+neymoVEH0xkN/R2pmlznHb/hdY/7TDjbEOT?=
 =?us-ascii?Q?e0upmhpoYMWbGYTUreQ+Wxc2E4c7/Y+mRoPJzvaX?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4177cd84-5609-4239-dce2-08dcc7518e91
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5899.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 11:07:08.1254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2b9jM4pVRzxLx3pkfEKeDejO8UsvVdP6su55o14zssS26iEol3FtK+1XMKK9nDphk8/VpjLG+OLEH3vUNNIwZg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6258

Use the ERR_CAST macro to clearly indicate that this is a pointer 
to an error value and that a type conversion was performed.

Signed-off-by: Shen Lichuan <shenlichuan@vivo.com>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 9384426ddc06..d3cb53b008f5 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1722,7 +1722,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	ct = __nf_conntrack_alloc(net, zone, tuple, &repl_tuple, GFP_ATOMIC,
 				  hash);
 	if (IS_ERR(ct))
-		return (struct nf_conntrack_tuple_hash *)ct;
+		return ERR_CAST(ct);
 
 	if (!nf_ct_add_synproxy(ct, tmpl)) {
 		nf_conntrack_free(ct);
-- 
2.17.1

