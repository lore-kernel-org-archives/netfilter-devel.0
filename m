Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020115.outbound.protection.outlook.com [52.101.150.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15497322B83
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2026 09:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580373; cv=fail; b=USzbHcdLEGCSwqHzLimeFKA0XmWVr6wQT8kCAtMgP3tDZ+B8+ukQDXipRDpn3pe8tJ98ADQOw1vGjQpHy3P4p9VnejQvTF4US+cAb4sd0jG5bfWgsxVhPq8eBXtoY+8NlskhcaPnQ1AmQ7YaaltDILW6k4mZU1zbqt3XpjSKBv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580373; c=relaxed/simple;
	bh=OX0t4fvDWmiV0QkEIMh9TXT7Lq0q6AK8L5rMGdAKOHU=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=cU+UCAZAKLGdwT9taJDR8vYjyApKYkpM912bFSviZGmNUBULcl3mf/HuVcrZNl5PJ1XW5dQzYywYO3J0715FzEKQ32z8JjWuIPBEoAqK2bjCKsWnbLXXyjtO5E5PJe8FnTyOR1u4cMOQ5ghHAkzkha+OrfE0orIO4StT0T+n5NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; arc=fail smtp.client-ip=52.101.150.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KlK4GH/eMG68R2XH61+AqHIqihYqKxd2B1aHYPVQCsTz8SFHslZIV/PQZ3w7PjII9MRhHrerSbL3ChPvLMj6gsFip/7m6VRFRYPcM5P1b5k9UxSgYv88yFqoy0OuMbXMyrZSu57EAwPwuRNL1yXv4ceY4QLLbWKheiuYEdeIz4919vg52V7BKEXd78BcVUkLmmdYHr1IUNy8D28lPX0BdDxvDGSX9W3ETOAnT/3wvetEr6s2snn/5FaA4d4RVPcc6hc9qhW+zTKFG904JVtHjz1rIpwl5ZahNemtv7V/DpYj7Z/iu0LSPoz6SXbNE620oe5yeTKWLveEWfrw++jG3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6W3sG/suNDzAk4dtkz3FVjzPzlYpsbMn+wZh55qf4w=;
 b=zR+ph01ErwV0uAwgmKjACtWOCAs9Edet1+0Igh2Yf0My6xnsZIqxKm9Va8MOKoR8cZOkGZa2/4azV+9VAvTpE3lQug/c/d7WPJaAL3JsK3oel4qhmz0AW8LI1dZROAty8TKFgVR6+KmDTA6Kw5pSlO5NLAPN8sn2hRajuNCImC7bM0qayAGaoJj5HRfZe82FPta1ICvcNeBGYfgxZETL+DS5+KG2rScePoY3pMSaN2pPMMwvvXKncziLe7YG3vnboxTixoy/hNwkO0+9kMeGEYzNu30fF+B1Rw48pZbvpLbxZvOvvM63Cc7Knwfl6dM0+oVTKdBFIyX5nMEb2/ehow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=heitbaum.com; dmarc=pass action=none header.from=heitbaum.com;
 dkim=pass header.d=heitbaum.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=heitbaum.com;
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:73::13) by
 SY7P282MB5676.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:2d0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.17; Fri, 20 Feb 2026 09:39:29 +0000
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f]) by SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 09:39:29 +0000
Date: Fri, 20 Feb 2026 09:39:15 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: netfilter-devel@vger.kernel.org
Cc: rudi@heitbaum.com
Subject: [PATCH 3/3 iptables] libxtables: fix discards 'const' qualifier
Message-ID: <aZgrw5yXNZIaRXfV@6f548583a531>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ME2PR01CA0077.ausprd01.prod.outlook.com
 (2603:10c6:201:2d::17) To SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:73::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYYP282MB0960:EE_|SY7P282MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: d8fe7301-7b7f-4d87-4bb7-08de7063f193
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wmtrV+DFMGKrz/ypUy3G/088xYJKVS8TINXPRIaTOFEzEZI/3MRXqJFsuAeA?=
 =?us-ascii?Q?GTb2GTcXLRZqAvqEDmgRjC/aVJJ4Ir5ayL9A7ijLWRzt/pT6QLjrg3gKE8zZ?=
 =?us-ascii?Q?LYupCKk1gOzcYUGxVJPqdidr+0JvoSb+g4Ig3KtZdHEOYGktDLkL2mIAB86z?=
 =?us-ascii?Q?JV2zt9TkYSTM8FyR1xC/EluSUKZfB696yseCrFvblqqvGjCKmQYtWk7hhJbm?=
 =?us-ascii?Q?vZiK5ymswheNZm3QmS/F/jNQjNv15iD7xF3nkeNL/RDLjr8Zp9mMxULJDcH+?=
 =?us-ascii?Q?Xlhx9YZKhwgI+pU5B9J6ACefJ14L8faz4zKtCTg69hv3PmA8Cz+poDgtyW3J?=
 =?us-ascii?Q?YS+j19yOXY5lrNST8ceJbZyGpJW+PBBP+JwIjLm/njFvhW+LHzHvS5Vlqzsy?=
 =?us-ascii?Q?Ul7XZ3GMl15NYYUqNHH5EDbjA0bnvAdD7d/6iVdPN4MB9v3VSw0JM+8YVV3b?=
 =?us-ascii?Q?0KjOQTgE4AQPNwPN/IHlmFJysF0X7ealxphY4uhNuAww5IN8CVgmZ98jtlzX?=
 =?us-ascii?Q?wjrX/YAVC6xtGn0/e81aatrXdJiRl5tuORJ1WEj2Oi/w3r7d1I2BeexpV4GW?=
 =?us-ascii?Q?SEkGgP4zhIZmHdY27g2SSCqX2WQ/DsBxGH8CuubiRwAV3eh2XuGhZZiX7B40?=
 =?us-ascii?Q?+N+HvtvwxQuNzfUMFFvRrwnQQ2qYv/INmvGVK5Kmq5hzcwXpb6NcGnqyl30e?=
 =?us-ascii?Q?zTjc+sHCU6o5bAP8mITsBmzBuNQGsL5jBJJYY2NGLO433mTq2L0Y4wckZwPD?=
 =?us-ascii?Q?hv/e1jrUswgvkLVv/EHeLFY9I+Blg4ve6kUfrHai4RUoNRy348zoznrfTrPh?=
 =?us-ascii?Q?+oECGfypl+oLNbTH45HbyWHrmycKOkYxrQlBmcXL3sAV20nTV7Mwh0U8MQLd?=
 =?us-ascii?Q?8eQsRlE+OWLNBDRGSZXHOxnIecksQJWdoz+mIG1jw/Mu/9LWczfy3mEaKZEH?=
 =?us-ascii?Q?4fYhr8wcI+7aifhAC0+3u5NWY4Z/UjniXB2WpfV+2+a/Efq8h/w8QqIcA6hl?=
 =?us-ascii?Q?fm7LO4IM3W0K15qD8FFyuEa08zJOnk8dqt0tUkfX4OlodwZ66ZHNBrC7Kn2x?=
 =?us-ascii?Q?qgcOcNIh/JCTcTYKwGqC5t5ORUMFxnoGcC5uakVxkE0xd2aDfZxDy+0CLMpt?=
 =?us-ascii?Q?aa3nVlDmIw7gMorn+WYAgK5aawBUUe5nXa7Yw8qeYhYzGP9ujqwz/e0fhhKg?=
 =?us-ascii?Q?zJO4ZW16vIFa1osIWOB383xhKhYQmgAuIcYsEugGaP8jwg9mFZxPHtn4lRhY?=
 =?us-ascii?Q?tldZa6V0RX3Cl40DwN1jgi90mI7+A77tqvKdtwsXFlpcn3WNfCjxtPJOjO8g?=
 =?us-ascii?Q?PG5zxgDCUUmQV0pVqfKVrjrOSKovfd2ouNEQxz5+qLWMJQqfHvnQKStO28ba?=
 =?us-ascii?Q?L7c1fP7IqLwT4dM88tgN8TFjKzfvMdL4JQ8z8VAki4qvtbsp/N/eRHskM+nv?=
 =?us-ascii?Q?/wrZi86JJ39ISJwj4lOGwgig6Vyg57uQCucSA2KMkbVLHxqZKKAof9TnymuK?=
 =?us-ascii?Q?ItzesMkTfxlHU4b+6oOOb2pSmTtZ9jb6gIrq9Hm8bTJmsn+bp5k4yM8dvdWb?=
 =?us-ascii?Q?DGvTCWkCa6qxMjDcK/Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DxZTGTe4Q9PWDzPaPs0cPHMrMDbWLKPdCk0oeTn7FKUaJsgXnbu9jp12eISP?=
 =?us-ascii?Q?Kbwe4CJcbz95nEEivy+WsbhgbX2uK7VnYMxZWJkxwLiJkkiq2V0NMb3jTgtu?=
 =?us-ascii?Q?9PKuSYait3lcqnpl/L8jRpBncPRJk29p8jsDXTLrj/o5uFDlo6WlD2w9NIcM?=
 =?us-ascii?Q?HKRs2BGwJ0UJApaVe9lrVq8wiy+u5713xDOp9dlRuvTl7zdnFOx5CzM4aF/r?=
 =?us-ascii?Q?1AGVIlvoWMSV+vuT23jNvd85Dh5Kc2bv6ullA69DcmnLzMHhixlWnXOPv15j?=
 =?us-ascii?Q?pV06vG8gxr82ig31hXl063vq1m9wAxQDV7l45inXm2ffqHq5qdXezbCjz6gF?=
 =?us-ascii?Q?5uoMwE4vB3rhopLN7jHzV8VQ5K57d7NWmpcQR79oVIIJoMhQdI2upnHGbFk+?=
 =?us-ascii?Q?sft+eh5M7sjTZqRKieXooXbAPVNAAyq2TYq3fDp3qWD2BP0ufnWnP77Pw4sk?=
 =?us-ascii?Q?q0uIQC4FgHZ07FAUIAgRoRehNnIQXcp1gqJISvXivrNzjpGeWJau09DfpL9y?=
 =?us-ascii?Q?/VQsW2LF37KmRftWs3fqW6galZ20AFVhnoaef/YJJu4qFZI1desoKrT6xugo?=
 =?us-ascii?Q?gBfNq53jK7PWFXl3dqdA2+5ElHTdkDl8D2YZFq3eE+FIzhDaUN7r8VmWyQMQ?=
 =?us-ascii?Q?5zQRlIcgQxl++xOrRrgEv63D5UsGvf8pI4zfR1uma4F342wpx0vWua8pso62?=
 =?us-ascii?Q?auWtb513WTC0G8IAuTdr2JkjHO7BnS/fgu1LfykqBHGmdQw1uQY3IsrT5XRJ?=
 =?us-ascii?Q?yyU7ky7YEjxn6NMKxgfLRwMirH56i9fuRUgbb2y+Y/CtQwzLyEvxDMs+4ylM?=
 =?us-ascii?Q?bDSe5HP9xsUI1fUbhBPNJPTBfQv9a8DS12qb22eZC11v4vPW1mjU0O+Sga/6?=
 =?us-ascii?Q?BMdJvL5PTWZ5+wPvY45JUB1BSCdQibTOGL5OxzAoBz2ZsHp2d6gECZWn+Bgf?=
 =?us-ascii?Q?+lmimLo4gMnpFbwTf3qOWmGtRHLROMU1cGECDfMmBJ6pK86ydGrJH3kignKs?=
 =?us-ascii?Q?KmF93b5Eiv9bgncmTtIF0Z98+Fp78tKW5YorNpsXT9pJyIf2jmbAAyiqMRcv?=
 =?us-ascii?Q?+zGIrwoqsmXEFxH/MLITmy/Sh/AEnC04/4ksIL2LWHzhJ7+CGFU/HMfH+GtE?=
 =?us-ascii?Q?JVpSwRWzA8GZY2c2skWENv+oU1NGtvNRNIHn09w4ZDIklsGcIF1kkTziZuNl?=
 =?us-ascii?Q?0pygE+JeM0tx4Y6ULSISzE3LA6hJpdOgh02eCyWJ++DZwbiKpWZbHP/tbWxl?=
 =?us-ascii?Q?pbnV+L+AtH+TEb1In46YNOM8igNd70hIRIlk5XjEWNuZdHtUCFN5dgThPmnk?=
 =?us-ascii?Q?YLZlC+8yarMRj1k80ZHKkWZGgLHGh+eIfHptmH//pgE3gc8B0pAaRf3UpH0Z?=
 =?us-ascii?Q?knvnsXh0ZKSFNW1WPEOVqv5rHLHEj6LUZdoDjWYJsXg/lVZitfa2hcRxuAR+?=
 =?us-ascii?Q?jn5D8gQXno61YbLJejBB2ZAjBRz02u/EHKrbX9BEox0va9g8XbM1cDKVhM4f?=
 =?us-ascii?Q?5hA2rooSWBa87e42KFMyoFSeLtSJvr6IaA1xoHGMqJHXwNLdOH13SmwGCjNa?=
 =?us-ascii?Q?s4f3b3gCzRw7L9wHKT9QG8vCL1NP+slUL8qyeG2zgIjkmU4oKrtZ0ovNrXfi?=
 =?us-ascii?Q?tw9hs8eZVNl2F3Xr+1VUHfHUf81D99iypYQNPkanMrcSaU6L37mTdYBeSMgO?=
 =?us-ascii?Q?RcAnQw5ett98W2M72nVHnrZc5dvoclNYnICuG+CwYi7+G9kB3ndtzasbndcK?=
 =?us-ascii?Q?ns2Roy05ow=3D=3D?=
X-OriginatorOrg: heitbaum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8fe7301-7b7f-4d87-4bb7-08de7063f193
X-MS-Exchange-CrossTenant-AuthSource: SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 09:39:29.1374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 35ffebb5-7282-4da6-8519-efab29b0108e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dTO/qv2L6oIjZoDtwY/ZV7TZ7VZSsVJwStFulzUIOlfQfy+IOITUGeVkWBYhYMxSVfO9hh9+FO9jOo8cJFzlWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY7P282MB5676

next is used as the return from strchr(loop) which is a const char.
Declare next as a const char * pointer for use addressing the warning.

Fixes:
    libxtables/xtables.c: In function 'xtables_ipparse_multiple':
    libxtables/xtables.c:1767:22: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     1767 |                 next = strchr(loop, ',');
          |                      ^
    libxtables/xtables.c: In function 'xtables_ip6parse_multiple':
    libxtables/xtables.c:2066:22: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     2066 |                 next = strchr(loop, ',');
          |                      ^

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
---
 libxtables/xtables.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index f872cc69..51706dc4 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1747,7 +1747,8 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
                               struct in_addr **maskpp, unsigned int *naddrs)
 {
 	struct in_addr *addrp;
-	char buf[256], *p, *next;
+	char buf[256], *p;
+	const char *next;
 	unsigned int len, i, j, n, count = 1;
 	const char *loop = name;
 
@@ -2046,7 +2047,8 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 {
 	static const struct in6_addr zero_addr;
 	struct in6_addr *addrp;
-	char buf[256], *p, *next;
+	char buf[256], *p;
+	const char *next;
 	unsigned int len, i, j, n, count = 1;
 	const char *loop = name;
 
-- 
2.51.0

