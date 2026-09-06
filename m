Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazolkn19013073.outbound.protection.outlook.com [52.103.35.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510E39902B;
	Sun,  6 Sep 2026 23:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.35.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788737855; cv=fail; b=A9h7XGv6JQ9pWkSMt11EuoOJSdzIVYKzd/RgYwTDntuTU62k+mrmYgOYDiRUcI5DJll4VQ5FqeWiEIsqHlW3fUbL77MA8lH07sRrt8CFpMcBHugt+2mHRUHQfIJ1umDVTeU/hvfmZV0+NMaAH8tb7bInolVJbNemS/0q9u01lg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788737855; c=relaxed/simple;
	bh=bRb2G84hQ55ufyF9LQfikJaAqYA6RRoJ2qUNQSrMRYU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=luZlKS5F4tpmZUtZ1IA+fqCmh9qpsCxuTfIaXyOzhq8T1ViW1AYxy+mXMyqJxOxOu+1gxuBG042d/GwYNOSIh0XaNZnljVHQbHSnfbjkwFMbBNRf/YMBQDt6bg9ZXIZ+m9kAaoNMCNj8mzd8rwf47I24hFHz0EjdUMvBmXOTyfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=DkOP+DMQ; arc=fail smtp.client-ip=52.103.35.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="DkOP+DMQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2B5RZhBtwhqYH7tHgXuJC9eVBgcZfqFO0mtAY9IT0VAOSbmt8Ankbpi9c4IS4Sq7jXWOY+nPBBfPkfBRe1qs0+Ul5r1Kr1A889NyfOSWT90NrYBkWL+x/JfcPn3Gjef/8cDmzveYDfoKw8b4oHX4lH3RISzTeBmZu4zewrZLgJ3GD2szIQ15/YWFAxctnj9mW3vfMBctHNtHefvdqwHkhYwkPQxNLVbvRSLVFGfpLwup5+xcAyBBWnZM2TnwuWmQTRmPU3n0TcV4f49ynzUpQl3dNGUVwMOY7v61gSL1xxDtNM+VzBrq0H98UeBzqdm0/qkUg1vUEEqZ6Iv7ScLHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WpVsCU/Yl8Ai1jWAZHTzljpDBJw/lCI0Gf/NeA9XKE=;
 b=ZewK64kVGb+Amlj3VkjYGST2VubovCYPFSW1Lz/Mjsk0ykWE2oEfwIYQcMCkHPJj2XDJm60IzGaKn/LHu2n9pp/InOEmAzje9qZf1eG6n/sVEKAswR4lqnfrxZt1+HnfJG3acR0+x417S7jvcb4dFO9FzseB7ioEY3eQzg5E4CXF0t8g8X+CthCvcgHZI/hW0CSZD8QKBF0DDU4wzxZTNP4W93bcK7n13euYzZciCP/jSgnqukIdR8I8x2XCNk72hti/Y/+KEnOOsFjLQLYqSaODWHBG/pspn5La73R6Ngw1GjIiZKl6P5Xqkes74O7M6dyV52eU7pogFmfTJaRdoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WpVsCU/Yl8Ai1jWAZHTzljpDBJw/lCI0Gf/NeA9XKE=;
 b=DkOP+DMQiqT2x3PsvWeuOJ9cjYxku+Vp11m/QtGskv0qT0vhN/ctIMjiphZTCPPEH8menfo6VeI+Sycb7vrxSTEFtVXWulK1po+YdQfWkYrf1nh9KqquILQ2p73V8TmDLs6ajxPcjqV4v0sMrzkQxfsr9/+2HmNiT3LvH3ONCOioNGptXIYidp/Evn2csVPHqJptIhgah0wyOcjh+m248lqtyJZSfPiqetNmc42YRdKN60KYVwS1hucDQrNe/YBIjt65JTdF+8rWddH5ZudYdIgxO9BXB3B+MQwb5QCEXYYfReCwnlTrmN4EHjcL8dBODs8XZZ+zA77gFNTKjdR4vg==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by PAXP251MB0113.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:200::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Sun, 6 Sep
 2026 23:37:31 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Sun, 6 Sep 2026
 23:37:31 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: conntrack_irc: fix port value truncation in parse_dcc()
Date: Mon,  7 Sep 2026 00:37:26 +0100
Message-ID:
 <AS8P251MB0001B81958B28F762352EF3DC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::15) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260906233727.87740-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|PAXP251MB0113:EE_
X-MS-Office365-Filtering-Correlation-Id: a6e95e2b-18c9-4bb7-288c-08df0c6fd1af
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|5062599005|5072599009|4140399003|15080799012|25010399006|23021999003|25031999004|37011999003|19110799012|8060799015|41001999006|12121999013|440099028|3412199025|26104999009|52005399003|40105399003|2607281247196008;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mYJ+fusD7X954+qc8gds9O2UH+V4lW4V/8llxShM4L3dgfaaPbd61agM0eDV?=
 =?us-ascii?Q?uKg82aEptzE9ev89uHNwRm4qlSdoUqMQ41YfmISzNTYIQgU+2Fo5ZsOYQ16Y?=
 =?us-ascii?Q?VrzaKfPaYp5R8yPOIzQveN51c0YCeSD/BGMy35FMz/0k37vRktd4+BzWxiXQ?=
 =?us-ascii?Q?DCZbow3+MjZRLa8cJum0F33omNyqy+3QUPSgOy6Vi+x5Mlta7ShJD6QUI4/C?=
 =?us-ascii?Q?sdQpg9vkoHS7dWjIpn5KHht22GzxmAhjtPsx83py7Nf5ONSGtMxtXortg1Lk?=
 =?us-ascii?Q?uyKlP1aDlLxxzyqyn9DOn4+QzNIPGTUDmb72cQoUIKMBv5j3whI/ZiTkfdv+?=
 =?us-ascii?Q?qtQ6h5aNQ8VaYZPN54aSrPlNN5KqM0W2MyhvUH7EoHOckOnHWKB70jmBvwdT?=
 =?us-ascii?Q?TtSFHQY3lU2m2OT8LpLNS4HS1dOaPfaK5FNbrR6I5guFmr8Bh+XGMqGEDRtY?=
 =?us-ascii?Q?7L1ZvHPWWMX6ptIALf8LkMJw4uQAHZ7LzuqmwBjzrl6IKHIAr5dlJNZI4cI8?=
 =?us-ascii?Q?W1QYcGkeawBNvJEAeAisQLjJ5JrEM+UYfgbf7fRPf/srqpw+BKrKSzOPqMK4?=
 =?us-ascii?Q?TSGN8862UbpzYMYRnSPLJ6D2qLiq5KLgjmvliy8+Or+3l7doK/qPthRU8JUB?=
 =?us-ascii?Q?Pnr90eiqcJGJQQHkKovBNW3uKd0lpHwWrK+OyscTaTiOn9O8l6Kq0twle6/V?=
 =?us-ascii?Q?CqZkUVz/oBgfiaL4yKYlgF5+GHQbJ+pTDzVqhbkh8D/znoKWltvRbfkeqFEs?=
 =?us-ascii?Q?FUzhAi2WkSv7Q1k+xUGzieiVsyOmgaWpT7rHDknUo7aCAjo54rdUL2WP2d50?=
 =?us-ascii?Q?lp1lLjDqX+/Fro+bFxASZjeVYyX7FV05B0P3fIPUksoQIVYugL/+aFkhATS+?=
 =?us-ascii?Q?UyFkqPRc6IBYab5CsHCSIk+Nfdo7tR/lfkn+KUa22tF7lyyE6RrXDuCZG8ig?=
 =?us-ascii?Q?YDZ4t2KIIaGCCrh94cxn7NQvhH4BBNnGd3Gg9Si/+SAwyg8RZblK/mMELa9V?=
 =?us-ascii?Q?qp/wi5JQGK7FtWxzNJE5MoE8WAnJuAIPsm6HrDhPIokJO/aMNebvfB1bblqr?=
 =?us-ascii?Q?0nGrxFWUjb/cOUmz8ISiJbCbJ14FyAadcnqRzbEZ6kBvgDHLpvEjUGHYXp8I?=
 =?us-ascii?Q?Jvr9z0Fvw2cw?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J8O4xtpNolHx7yIkCKGkefI+6fEcggtNPcyYFkv9AofFeJ5P97nZn51odH5t?=
 =?us-ascii?Q?V8wXtIQdnZO9ICMhW3zvs8stu8gt2SC2eae40Ksqu8ZmaVrVMQZjrAX8f3hl?=
 =?us-ascii?Q?2vIDpO1HA5cuysH/L7JYQGFKG7CugQSX6uKae1BjqeP85Aq2XZC6D3FybjjY?=
 =?us-ascii?Q?qysWY9QL0hv2rASzXHvLPo/RMCMqEQ2/z0CHF5PDVoVwDgTLsi9FKgh1Ht7u?=
 =?us-ascii?Q?r8jjKc3uIwHvX+pKsR7pdbVxu3W8gWjvInW8CT+w3Fks5mOulTzhSmfXbpk9?=
 =?us-ascii?Q?7Yp30m8dxFEG9T7dufG/TkRu7fmVETuW/NVqcScrO0GN6KFkC/ErEJNWlSdK?=
 =?us-ascii?Q?vR37ac2Spc8BsnjGAXjnl+xqgYSGtgyyuNikU6V38tV4cBxO5Ce0la3lEAt5?=
 =?us-ascii?Q?MnefE985CDxKkTcOK8no46tTY4DwnuNt0cTuFardqqp3Go6R4xXByW4q+Ocj?=
 =?us-ascii?Q?B6rvWG6f/v93X9hK9d/i2x9h5go9pKhZn9SOQb3/xlx3xrKoWe9+i+ImnCfc?=
 =?us-ascii?Q?legS9lc6nFfoB218EiQ9VxPJ8EkjlBmctv5nLHPoFXjJpK/HS/v6v301eM0i?=
 =?us-ascii?Q?ps6X1lDNu1849HSJTxYYM+fXSyiPxU02EcU9yjoI6ZvAaa5+nSzpE0z0cbXc?=
 =?us-ascii?Q?kAV6HbJ/25z/ARSo6KqAgQhCbOZVYrIQINMZEX0tobc7IG0wDGRtWtdRHkYH?=
 =?us-ascii?Q?p0s5uezvpcinzmeLqlDLvQOPuw7Vr0Zx2del7qyjBLUrgEy3rl5oCPOmzC5P?=
 =?us-ascii?Q?uIGKUO5VFmsTzHJ3O3w00dnYtJ0GMJUnywVgBqcAmtC22wbBFwJy5Y1zYpfc?=
 =?us-ascii?Q?H3l7qkzRrn4WamU+Hij1iGHOs3kywo3oaZkud3PDywqwK8VpqeEE1carIgeO?=
 =?us-ascii?Q?LV15+JTlj6XOQ8GPHumUHDSjoEs1RXHEvbHOrzUL9jM+GpEdGzkyA+CvuRkD?=
 =?us-ascii?Q?A53dOmOjU2APjVxhHDf0V09uLmSxg8jMUnkUHhuMifWG/a5Tu79LEgekU1jr?=
 =?us-ascii?Q?WE98uyIs+JtSPIlqYMxV97VEsH6RfpavnUsFna1DIInOPkLmdBklzTFozJ7w?=
 =?us-ascii?Q?E/qG+ZrX3Bf9kfRD/GG4o17p0596VCOpo0f926VXtzQPW7Evgo+9GDUs0c/w?=
 =?us-ascii?Q?woaFU5EXl1V1aN+np8FdTj+Y/0cAMww9M8zFuwvoEdcv9HSlnnShVvpsFDr9?=
 =?us-ascii?Q?mqPweucxoMkQf3yxmakrGGqgomJcvdME9OdTF/3WoaK5I8CvznCEDZUKYOmy?=
 =?us-ascii?Q?ySHb0LY32a8lY3jnfTGqwDKTc9i+vltuADn8kZxV23Nv88kYUDI2bhF7Iaq4?=
 =?us-ascii?Q?s9qVklRy4++7zRtQNM309w6dojyJ3P5jTDTkRmw5+ZPtstZwQfLLDsCEYaDD?=
 =?us-ascii?Q?JxUIEewMGqFvnZgbyZoF/32CLmVM2r2oC6uYavBKnEpboGAQfzga2mPGBrSZ?=
 =?us-ascii?Q?a+MhnAOkOrdq9++FVnfMR4H1IbR9wHt/?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: a6e95e2b-18c9-4bb7-288c-08df0c6fd1af
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2026 23:37:31.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXP251MB0113

parse_dcc() uses simple_strtoul() to parse the port number from DCC
commands, storing the result directly in a u16.  simple_strtoul()
returns unsigned long, so values above 65535 are silently truncated.
For example, a DCC command with port "65537" is parsed as port 1,
bypassing the dcc_port == 0 rejection check and creating a conntrack
expectation for an unintended port.

The nf_conntrack_ftp helper had the same class of defect and was fixed
by using a wider accumulator with a range check (get_port checks
tmp_port > 65535).  The ipvs ftp helper was similarly fixed in commit
e625a9477d12 ("ipvs: fix integer overflow in ftp helper port/address
parsing").  Apply the same pattern here: parse into an unsigned long,
reject values above 65535, and only then assign to the u16.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 net/netfilter/nf_conntrack_irc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 92360963757a..8321f12dbf15 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -64,6 +64,7 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		     u_int16_t *port, char **ad_beg_p, char **ad_end_p)
 {
 	char *tmp;
+	unsigned long tmp_port;
 
 	/* at least 12: "AAAAAAAA P\1\n" */
 	while (*data++ != ' ')
@@ -88,7 +89,10 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		data++;
 	}
 
-	*port = simple_strtoul(data, &data, 10);
+	tmp_port = simple_strtoul(data, &data, 10);
+	if (tmp_port > 65535)
+		return -1;
+	*port = tmp_port;
 	*ad_end_p = data;
 
 	return 0;
-- 
2.43.0

