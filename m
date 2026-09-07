Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazolkn19013081.outbound.protection.outlook.com [52.103.46.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850E072621;
	Mon,  7 Sep 2026 00:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.46.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788741119; cv=fail; b=Q4oj2cKg2PgnPw2WhL71dDyw2SrLXjDNsTV36twIa74d1qe2m3aa9OsQKoUKQscm3zTwZjUz8XAfXcxebVgRLhrsuA0+I9ftdFQE45Cw8CjarbFwUkdGUYZRz6s3yORWGXRcV1sw3TeLkE9rVZ1tUIAKAK3SIj+1VA/13zIDYdc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788741119; c=relaxed/simple;
	bh=ckYcY/ZOEYwuBZ3jRu60wQMnjnfigvaoE+qs4bf07ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Iyx3R6AeQG76M44AuRzEUnChiQvFcJ4w38Va5v/MWKueTOhaTC2V7OrUlh+jqtz8QNUj3Cq4pWq4QaZzCxGF+Sxv2c3g8b0mkvTjdWoGWTU1+wZK72yMHVii8i/G4ypWKNAW++ZTvgTd37JecsHW5vkiClFdXo+mG8JOd/eyhJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=XeFxnsFA; arc=fail smtp.client-ip=52.103.46.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="XeFxnsFA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgszYLj3IQSw37sgZY8lJuda1p69bXnZ5xRARZfPY8kbxOaqZb0/yga/CmR0CPB3+S/fsODamjBUrgkWgsIhxV6j/C7q1bO3CZDkWfqff6yneAiSCXJyaweBswB8bOCrdIbneodctClAHj/sy4O30Oq0XpgqiJMQTJIgC6KzuUV5l2UXHwfbHA+qBDhxx9au1qnctsklzaKPMS5FmjuMlH2k43bu7pPXo8jrvLmaqj+BiZLtuuWB4xH5KkgKSBRVu6yGk6DS+YpE0DdYf4AQJE0HSbLpHZTNoSrq079zu9hbXQSrGNPko/X1LFMV7OEvm8KeEdbJ4qdJbuCERX66ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71XfXnlSvwrABtSR4meuYwREzwLC7TcL/0GYhnUC3Rc=;
 b=cN/ByW5najhxaJxr9ZmkOndzY+la8rL1xYaFQfEidcndqtUfsX+Oc5SOaelUqIZ0z5ugRNF3rgamEw3v3+wlXQm3bGWryGoMEFrkEbMF50V4CFAe3vppXXT8cma1peXyIxVCx2Y3Hx6LVsmxXxqCQYYBKWAUPdBtdSM6RNiytsCXOf4HBpGrBHDBa+yVWI4fYpXpSedOsTQ6/Ey3oYTkgN7iiOTJzXZlbqmgJ8NeLF/vKQ8h8sScp9INRF9QmkqdBvWGHc0LL+28Txzs7S9cnJ/gy3SVgbPMTxKKeGRZq2jWJRLiNEABOQUccnhFY87R29E3zH64jMAIWZGvuVk2sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71XfXnlSvwrABtSR4meuYwREzwLC7TcL/0GYhnUC3Rc=;
 b=XeFxnsFA+QEOH0eR7s3hnsT1lRmu5+lUHs61gKYzu4hcEENLqqLHXuCeMoKkMzMzZThCiVzUaDXMITCVikadgA1VefU8p5vgjUFN77XniznV/1g0aQIpviffxwtOXbEGFF3G0/DSzMSxCqy14IpL7hUjMvUe5MFI6ksGiRDu8XQfA0QbClPR6IoYBRnryuUj4R7UA206pGAdV4RU/k2ffkJjG5I8vHtnK5T/rIe6h6EmeRbTIs88jAv4mr/xeC6krq+s9lGvqC8rodKQAOf+SfcIsmPTCg9LAzbn25Suq4gFT0QEpkh8xiENaZW5fwGVyjHY6QuDIjVfs5O8GzcYfg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PAXP251MB0446.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:276::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 00:31:55 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 00:31:55 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] netfilter: nf_conntrack_h323: fix OOB read in decode_enum()
Date: Mon,  7 Sep 2026 00:31:52 +0000
Message-ID:
 <AS8P251MB00011EEAA381DC17852BA37CC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0344.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::7) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907003152.467760-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PAXP251MB0446:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bb9060e-2805-4116-ae8c-08df0c776b6b
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|25010399006|55001999006|4140399003|41001999006|16051099003|5072599009|5062599005|19110799012|15080799012|23021999003|37011999003|25031999004|12121999013|8060799015|24021099003|51005399006|3412199025|440099028|26104999009|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oKfaeSTvs3FvLbGEKU5MGyrIW+ScUsGMEAhs1x/lWNE4951M3lyeirxm3s8O?=
 =?us-ascii?Q?0vEucuwU/GcA+u9CdZW6evtDLwPx9930VXN+uwvCrtvSVcXNFNZCA8DnmOeB?=
 =?us-ascii?Q?XSd7YYc4a3LjC5vSKH6KCO+ks97ZKU3hXcIDriEDOCuUf8Nuh4llHlvVooYu?=
 =?us-ascii?Q?zmESnU4nBx6HyuQurDVA7H68IkJxUTtPsl3oGWlez8zUQxwV5NXmzRHLeZul?=
 =?us-ascii?Q?3VWyoOmBGiyEmtsfxwwxoyWM38XRJLPfX9RFXM/lRo+nVsn2Hez5OSEEkJOS?=
 =?us-ascii?Q?FJZwGYMig+QHO7C2e+lIdpUef+X3u5SqX3n2iHe2DQvZ7Blmz6uEqbOa1vhf?=
 =?us-ascii?Q?ZuXJhZGMwdyl7dKCLa+Uizb8rcJ+TJ80nneP815CK71Arpch1gyhV1S+lw3j?=
 =?us-ascii?Q?hJeBKc1qVRhkMcpZGIZhp9owap17/RwMF5iMOERWwNNQIWNerVBQgj3JvLNL?=
 =?us-ascii?Q?GGU2cm1JkmrUMv5azUDopN0Hg7FoaLtL/KT8in/GkBD7t57ZjjBttpB2r56G?=
 =?us-ascii?Q?GDcRPCJHtKvp+mGqu5FcYsIBwLz35fT55GyDSlr6B/qTyDalwH4/oDHPyh0x?=
 =?us-ascii?Q?PxdV2Z81H+8zzYIpFE5/s2gambE0S2YRBhWjy0E1FUVaz3FGXKnBO4rQgZj3?=
 =?us-ascii?Q?u9PHo6bmCjeWsxamNmSEIWmFx7wZPRxpMu0ytHU8O4bCWUb6TWXuLdlSKKIY?=
 =?us-ascii?Q?BBcYoYQt/YQ1DjKZzg9neLfRPuC9AuDBJVyeYjFPguYf7S2z/M7FB+BLsumh?=
 =?us-ascii?Q?K7WmxZbjb+Bz01itYi/eCnv04eBOQpvEUiyuJ7DicIJXGddSXiKa2++9InAX?=
 =?us-ascii?Q?H+xcFHxlizNRzsznC8ejkQzEO0XfJzCwTLVEmWJ8qp/ce+fVewpzeEX2nsde?=
 =?us-ascii?Q?Vjyq+1+9n+wIuoUe7n3MC+L3EmjbDUtx8a2gDthQfhbQ4jSXTgJTu0p/qVyY?=
 =?us-ascii?Q?dgqDeeLe7NuJ37w0WpS9t4Eab2NEGlozcBbl81h2VCMGt5osuntoSJFWGljK?=
 =?us-ascii?Q?sut8Qe02eUGV6R9AWkICglRxMdbH7oN7RusCZD+aIPGZvLGDzjDXOm8kIgdY?=
 =?us-ascii?Q?Cbx5PEAwqC/sPPhnSU0351BZk9Kk03HvPArBZsNKZPC4a+zQfJ2HdgVZ4NZN?=
 =?us-ascii?Q?xzVrUTDUtEn7qpyCAwzLGBIULRWoyGYXOblnSj5JVDyb5w7boUfKXKfcfRy9?=
 =?us-ascii?Q?/LAAosaEcxfEHF/Q?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MGmDHc9yECUYFruODtaac8BCvgBdBgU6IGipUrePL6FZFLSjrIZbQ9gk/7tK?=
 =?us-ascii?Q?Ec7FeDvJSwu1KUQ+eqXRNtK2WpwFqvi2QU27NzKJ9k29FRnqm8E7DX8lg/rG?=
 =?us-ascii?Q?rz9Vr0EJQaP2y7KsJtIiL8+hqULaibtK0xfnLF9N1XuEzRwjv20iKgTkVwYr?=
 =?us-ascii?Q?2HLY3Z+NBkSDM+ygMDx8vLFJP9dbt0Ek/h0zOO6ikxPSEf/3mN26aKXRJ03a?=
 =?us-ascii?Q?jpwfxrrUGxOKhyBNlESbJmS04ollGNTgzlckCkfkCys5pH51g4IMdUZrCqsa?=
 =?us-ascii?Q?5WrsJbZ9borMLXipamV1RfA8SojeeE9Chw8MVbHXpUk0bzUTv0ssvQ4k+u0a?=
 =?us-ascii?Q?fgr0OGkJSfr6AFclfkDE0y8aCS0l6xI6LQ/44Hw13jAWDYi8SpxTY3gZcp8h?=
 =?us-ascii?Q?pqu/X6PmQXS0XSaMS0iAq6QWS+C+kE/VSa4KxjOa5jFzouWORHK535HP8Vr7?=
 =?us-ascii?Q?Gj5brYnyLiVz8gyX6RXCB7rAdo6d3OrUCGNhUKY7NUS0mERgopaWadRZ7Ccs?=
 =?us-ascii?Q?l9aKnfTMkhFjkxcF9ubV/qdIcF1V+k8Y5/52RZmvG926Zx5lvkdooAgn4EFK?=
 =?us-ascii?Q?eKke8v8VUL0GHFq4xAa44gSLI8vwOnqLOdvLcyWUyEOrHoAmg1GXm9nMceF6?=
 =?us-ascii?Q?jjTEtPn7B/UBM7+6p7W3/Vc1E1LwEkDTxeDSzd4VrSNcYg4n4rOb12lx+0Bx?=
 =?us-ascii?Q?DEGacSckrq/poHeq/vx7qnFAc8x/9bLEyi0Y+aD3OCHJ+HvlU6KgzzIfiMTM?=
 =?us-ascii?Q?5RjU3K3APTLYx6MvTlCyQ1H+ArxAQcy0wYhfvrpUMzT7dnJm+QkG+nK8yIdT?=
 =?us-ascii?Q?W77jSiQV/0O9ODgSI6YhNeF6wOHnrecKKM8JnLkD+e6MMLe0etdU3qS2gdBH?=
 =?us-ascii?Q?vLOdnH96KpVQrVxx0R+4exI/cydo9HmJuz/ulfe1Yr26CEYEcKR9lwWva9s7?=
 =?us-ascii?Q?2G6BiSHCliZH29Nc/cCEsSGOLhUKggZ83TTUUJUjChod9GYSaLNNKjLFhNtf?=
 =?us-ascii?Q?NBIKEL0PN4hJuJPKdsIYKPezECS8sIMKZm0HgTURzmj+aQaH6jxG6NJoiZqe?=
 =?us-ascii?Q?CDiGQ2DHINW2/MdbP2JCy+YtABwDnmzkwm2ouyeXXUXVCE1kHnldfZjElp6h?=
 =?us-ascii?Q?/ttAZw1mMtuu/Tm1wXEPWGsvGQrqaAvv+g0ke5Ladf2BmGK67t8rWM15MUUF?=
 =?us-ascii?Q?mfVYOmhwskOFsHmXdNerQohSXNu+a7Gr1FwTrUolJsfZ/4mAsU0wKKjyosgh?=
 =?us-ascii?Q?+OGENJaXbg0aUbaownKhwd0J84ssVuHd16AjtssRoNwxdHHxEGkSVFQtPMg3?=
 =?us-ascii?Q?sdsUf6j7XG5o9SWWpaCEqhXu9SB22LxrU585HXsizyljtKFnTLC5gQp+C1ri?=
 =?us-ascii?Q?qQpBys13UCfpH+G2VFsu3lMsRIJDMfRek73bhYr/ZoV5XYuVpg2+C4vOv9Yp?=
 =?us-ascii?Q?X4CGfYN5khVdDdqKp372HxqPxfgYZ7j6?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bb9060e-2805-4116-ae8c-08df0c776b6b
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 00:31:55.5762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP251MB0446

In decode_enum(), get_bit(bs) is called to read the extension marker
bit without first verifying that the bitstream has enough data
remaining. get_bit() dereferences bs->cur directly:

    unsigned int b = (*bs->cur) & (0x80 >> bs->bit);

When the bitstream is exhausted (bs->cur >= bs->end), this results in a
one-byte out-of-bounds read from the skb data area.

Both decode_seq() and decode_choice() correctly call
nf_h323_error_boundary(bs, 0, 1) before reading the extension bit via
get_bit(). decode_enum() is the only decoder that omits this check.

The bug is reachable when parsing a truncated H.323 message containing a
PER-encoded enumeration with the extension marker (such as the
screeningIndicator field), through port 1720 with the nf_conntrack_h323
helper active.

Add the missing nf_h323_error_boundary(bs, 0, 1) check before get_bit()
to match the pattern used in decode_seq() and decode_choice().

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Cc: stable@vger.kernel.org
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 6830c9da3507..ba6ce1f04e1e 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -363,6 +363,8 @@ static int decode_enum(struct bitstr *bs, const struct field_t *f,
 {
 	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
 
+	if (nf_h323_error_boundary(bs, 0, 1))
+		return H323_ERROR_BOUND;
 	if ((f->attr & EXT) && get_bit(bs)) {
 		INC_BITS(bs, 7);
 	} else {
-- 
2.43.0

