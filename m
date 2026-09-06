Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013082.outbound.protection.outlook.com [52.103.46.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD6A3CBE9C;
	Sun,  6 Sep 2026 23:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.46.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788737862; cv=fail; b=A+B++cF1EvOhitEDOCson2wKtbw4okKdREijTBHChfDPHZwzc0gLCAJ9G6PGloHIasAB0iGlYWUq/25SwUbzfqpjxR6QlFCcDQe75pW4M5QVeToRIwHVTCaK+0IDIB/2lBhCpMwLyXc67rz74MkCl/VBBURH/uKXMObmytRv5F4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788737862; c=relaxed/simple;
	bh=awCZ83w6OZNncQEfRO8836apgWnUrQpsa1C0RRE2Dsg=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=B93ZfNp7EwnSEYGqgF+HfO0lmIG1JLAKgM59anmrhLu2l6bPGhFIK1nIHlYXXWvNA2/1jNvHHiySU0b030eXhQo79jfdQWXBwzvjDo4evpNDLHMa+AvX1YM85jeiWfBCnxu4LrAef7u2bgRWOO8rfCwKwaink+cmOwj/Cuingpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=LWA1GmnN; arc=fail smtp.client-ip=52.103.46.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="LWA1GmnN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ioA0S3eBd6EhGjMmybzGTO+IGyEN+J2G5LSMsKMxONf50hvF/GFG/waYxZCHDTY4mteHVvYpQuJLtKF/vZ5GErOkLfYYLkgvLlu//U0wEsinz4B9kR21MuVX1Jc1DpawkcItYZIvTTVEMlpG5kvftr4V1zrulqQxchQ3H+5BlJ04LgtkUbBQKwhY1M6VGKNsBqnwTFZridD1OD96r3bdZFxOspbVkj1/PHKVGZHmi2VLTAkm/HZWygtb9U3Sib3XPgXT60HMD9e6LJDMv94RBHOiSMNuRP0ioyZTkgQ2HkpByvPE8S3UXCpPjOgwn6gx2cF31SFspdUx/DKbKjQBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3iKQwQcJEbC5KAP8D1V0EFf9hns6pEHfzPyO9+lnx4=;
 b=sxtEt/oAMZFmft7+cvCvuvNdo209E2ftZ2QeDCj9jUX1A0qdkYP4jBW0AA+FYJxkbTKZjxHiQiWp20ejelGWu7xupJW/pXdn9KB5Sw6LfeMX8/vAfE4BcShuwltPQ75KcsJ1a7c3YsQxHWKlocaPOchbQbPexUmDqXulvNb1Nig0CjnSvHEtHD1bZwUBq6gAAyab026MiFQYaipui2XIlikAAVE7beW/Qf+hkWldnO7Ayp9S1j/M+z5FSz/VtvCjte8x+pWHFw1wEgb+9JUxUWtOTz4dE/0DT4jjTfeyjg5PJiEZQ7yzRz4FGTgIwRtWBg6WvYn2I1pNBhHm/l8Bhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3iKQwQcJEbC5KAP8D1V0EFf9hns6pEHfzPyO9+lnx4=;
 b=LWA1GmnNNW32rHZBCql6FuAg+t/0KNsC/fMbT+vOj45OSehZLDZ8PmGBC/60nzS1E47VaH9x0li3o75dYwfcB/RRMguAX2YanniF2cxUxvZzfnklt4UlzFp+yjqhP0ZC1PClHUjGeuuZ1jFaREsU645Fp/ofMocrGNuOPm7w97HukbKhjnfJeQqbdzT5HM/QhtrQ6VE5uYupvL157hoQ9IsA3j7Vw7BPz6gQyHh/C65KSVYIVdRB9byqkK3/gVLB88Z7Ce+gpgEGlc2Y6ShqSTrLsYlrysbBrI+N6eEodqn8WGc+W1MusAsYdoxDqM34HJ/MO+SJRqnmqUfSPjcPbw==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PAXP251MB0113.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 23:37:38 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 23:37:38 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: conntrack_amanda: fix port value truncation
Date: Mon,  7 Sep 2026 00:37:34 +0100
Message-ID:
 <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0184.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::9) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260906233734.87751-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PAXP251MB0113:EE_
X-MS-Office365-Filtering-Correlation-Id: 63af97c7-a4cc-4c6e-9c08-08df0c6fd5ee
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|5062599005|5072599009|15080799012|25010399006|51005399006|23021999003|25031999004|37011999003|19110799012|8060799015|12121999013|440099028|3412199025|26104999009|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NSjWokhXzRaPD5+8Z6lBsgNi2OqrijDefobjsN0bYK19rzvTsjkbaTj3W8we?=
 =?us-ascii?Q?oBJi2+DJybWUyLP9e6W5xbDbKuNoKRoUy8aaRnTuRSIfXVPyHBjVDVe2HJtK?=
 =?us-ascii?Q?lVtAiBpg/0W5MIigFyjK9VrCuU/74MKg+eULLA6EnZjMPvdaKA+mAPe5Q8+M?=
 =?us-ascii?Q?n7OHsqS5iIfT5SASECW1XadEESJ/Qr1v22kkRIK9k2kgSAKg3tNMazRbFFEr?=
 =?us-ascii?Q?m1+e0YCY4npmUEG0qr1yRLflUUHHVu8DZ6OJZpyx4u7laR2xUYFvrf0tZzDv?=
 =?us-ascii?Q?cipn2OaZq0C95Qm2WqtZyoUq2Lm6rxC6/c/DUONayBdGnZtkBPD7GuWLMxr+?=
 =?us-ascii?Q?R0Hx5EhaxvY6xPBvj/M8COe9UOpLqiVVe2sBt3Gr06d5+nKQhq489wIuxxPM?=
 =?us-ascii?Q?jdBoc+ZOeDeo+BTwD4iCJ+kUTzYujtTe+QLQEhOs1oHab53q6V8upC1n+kye?=
 =?us-ascii?Q?G740F14v+RrF1cYocosa6GGnqhF1d+6weaA7uwl02yhXtrM1pZ+FFjWKZib/?=
 =?us-ascii?Q?j9P/LJV2R5iM+9mGz4FVDqTMU6K+niBi1kc2Mni5Fw/2vd6maACAnQCThN9i?=
 =?us-ascii?Q?XKNiABPRaa07bd2JWNQf46F821FpDaMzc7x4vxlXXEi+XJ2HnPRtpxrTK/Gw?=
 =?us-ascii?Q?VbZdEFekLU3U28vjoeOF7IpV5jsJQmirYP5sY874ezr4sQ0ob0d/0L4+ZsNX?=
 =?us-ascii?Q?CNI1D+1zK3nlGGu1n5s6l3sUDvkH8IYt3UXA5jbGZqRKn3CTEdcp0ohMso8F?=
 =?us-ascii?Q?gvTNrVliiWU4E5oq+wtritLrySBfIHG1qdiYBjKLkEWZv4sMvEFhFE+XqgXD?=
 =?us-ascii?Q?aI2hBHsrJXw2JjpTMyyI0G8zZOR/lE48hz13uA5I9q/qAwtdvVHTfD/N41hM?=
 =?us-ascii?Q?81vprDwsf0lq5vxBN368Cs9cITwViWR34rdeAWJHwGS4r1iJAkK/iXrlDoc/?=
 =?us-ascii?Q?l0IjyOwLNnWpiNnclbQ9iWc+WzXCNPlp7+pXtn2r7J0WgoCMp+civZPARtn8?=
 =?us-ascii?Q?skiTOoD9pOw2HonHnJ/OksOmLpvgHQVE8g7iLoQ29pS1VJ2j8vIHJoxQtG6s?=
 =?us-ascii?Q?L1SDoTgzKYMe2Kf3XF4VizZQiiXjyJK8R6eNo0OofkN9rWmWapY=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uD4prMcZlLw/DDD4maObbNcDgezfeiVSymRl9m40y9Z1FihULAhi4DTMKiZ8?=
 =?us-ascii?Q?S84XRSGES+Qqoq/M+OC8HAZ2lSeW2FG4EgOI6tIuXZwfnwJI9RgkGiB7g82Y?=
 =?us-ascii?Q?g6XrcC6eba5TPh4iuN8+v9RgwNj9UonX/+QKscL4qvhXH/JhGqICAkNE+601?=
 =?us-ascii?Q?vLelwJrt3W1gQs9vl/0wKoafqFxgQsLm70Yi+axIsEfpe4g5BidjyPi2eATl?=
 =?us-ascii?Q?xaNSq5lTTGYKNWbtmlNRcGshfZEgEI0bP67rK7r5THp+EeqKxd8HubWk2NKM?=
 =?us-ascii?Q?zild3NLPrdamQUVI+5BSpcfBdf0+l0XPf/FNUHgIJ1R08O9mScEna/h+0f9m?=
 =?us-ascii?Q?nHhrW2TCEhfrgiRveByF1s8F265TNV6rdIplEcvpdL1d1uqf0MllD+UCC2Ne?=
 =?us-ascii?Q?LiJICp5iPxzO6w2NP706cTFcH0lIWnTZAjETEMVEL66+X4Q++cKZoy+NxKEa?=
 =?us-ascii?Q?Cn0cX5sqjoambsy1TUNN+61pLsWVJ6PGThkjd3oA1eOnYfDrXGpidKvNp9js?=
 =?us-ascii?Q?3LtRcovU0WDPE+x5iufjH0JuUFuIQX4hN4htDTfN0cVYFZwEvvOO8xjPVOSl?=
 =?us-ascii?Q?M633qXWWMwLV9LwPaDU6Plxn2prUx9z7hUw0SrkkiD7XlzkoSifqpVJEFlN+?=
 =?us-ascii?Q?c+vIssXCcb5Bds7SfdMwqd9JUUAUNc37LYqA1iqlcIqmGIwSV3EDLowMA3Ty?=
 =?us-ascii?Q?5HstlC6RyHxzPiQB3cIl7Q0LNLAnrRDbv8CKj1InSmibiAHTarpr510ttCIL?=
 =?us-ascii?Q?Muxx03z1aRS/aPqI9E3wgsctuP3jpI0M6rmWBeP/qcQhbRUPFxq04aOGHVR8?=
 =?us-ascii?Q?BAAOi+Lql8tn0I0iVYXWhijJDKx5h2uNYAqAJi6rFoNqG40lkUqbV+/W/irS?=
 =?us-ascii?Q?BUO7NK5QDsvZ5rG7jTIoElMH4c7moYB6FD/jjel2ON2Z6wc1GiKj627kpIw1?=
 =?us-ascii?Q?ARHUvitCGIEbwET9A7XxwiikJ3BRFRmG6nAwJA5TM7GakH7Fr6ALGOO1TamU?=
 =?us-ascii?Q?Te9NI8jaizdu/lTAXZtJ9j+2IY64aEt9nCowxHYzeTl0ZLZYSKcyHvVqE2BC?=
 =?us-ascii?Q?LiLYioEO7yqbL56BtmGzUrDSd9Y83FqRuwus2ft7qqp6Oc6hjexybM8Y1h4W?=
 =?us-ascii?Q?7CXbTWya78Ara4L0t4PqcS4sV4fOhxdezCdDVzHPDfWDzXhKf8APxLKGqKrn?=
 =?us-ascii?Q?zAtDcPrPgNXN4d4/VCyZTbd8YfiKV/VwX+ejYg3gamAdDfU7SOIsVHEQueqg?=
 =?us-ascii?Q?UY9IzJi05rzsVjh+mSRXtwj9uggli5ky15EiYSpgy/2b1I22nkKtJzj+eoxh?=
 =?us-ascii?Q?NNLaR5GtdIl+3GnFuAwzfePh8Fv1wGrC2MLBs9KT8PfMu2DjJYG3UvH8O9q2?=
 =?us-ascii?Q?QrN1mtTWm7snVmZteS9HmOCyB6y+4IUgI5EUtkXFNzVVH2CREGX2U3h5IJzo?=
 =?us-ascii?Q?1QuWW7jRMPyIcZ+XPl6d1gK8tVLwpjDF?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 63af97c7-a4cc-4c6e-9c08-08df0c6fd5ee
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 23:37:38.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP251MB0113

amanda_help() uses simple_strtoul() to parse the port number from
Amanda CONNECT replies, passing the result directly through htons()
into a __be16.  simple_strtoul() returns unsigned long, so values
above 65535 are silently truncated by the implicit conversion to u16
inside htons().

The existing check "port == 0 || len > 5" is insufficient: it
catches values that truncate to zero (e.g. 65536) and strings longer
than 5 digits, but misses values 65537-99999 whose u16 truncation is
non-zero.  For example, port 65537 becomes port 1, creating a
conntrack expectation for an unintended port.

Parse into an unsigned long and explicitly reject values above 65535
before the htons() conversion, mirroring the pattern used by the FTP
helper's get_port() and the recent IPVS FTP fix (commit
e625a9477d12).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 net/netfilter/nf_conntrack_amanda.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index 14ae660491f3..057cef7e2a7e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -91,6 +91,7 @@ static int amanda_help(struct sk_buff *skb,
 	char pbuf[sizeof("65535")], *tmp;
 	u16 len;
 	__be16 port;
+	unsigned long tmp_port;
 	int ret = NF_ACCEPT;
 	nf_nat_amanda_hook_fn *nf_nat_amanda;
 
@@ -132,10 +133,11 @@ static int amanda_help(struct sk_buff *skb,
 			break;
 		pbuf[len] = '\0';
 
-		port = htons(simple_strtoul(pbuf, &tmp, 10));
+		tmp_port = simple_strtoul(pbuf, &tmp, 10);
 		len = tmp - pbuf;
-		if (port == 0 || len > 5)
+		if (tmp_port == 0 || tmp_port > 65535 || len > 5)
 			break;
+		port = htons(tmp_port);
 
 		exp = nf_ct_expect_alloc(ct);
 		if (exp == NULL) {
-- 
2.43.0

