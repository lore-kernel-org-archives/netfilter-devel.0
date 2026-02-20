Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020129.outbound.protection.outlook.com [52.101.150.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D9B322B87
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2026 09:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580332; cv=fail; b=gRd4LPLa2RyPZSCX41VvTnF+X4CnwisUjCi3iLm2O6wXayAPNSFgSx/4HT0I7cX8KfXAnAjsZLzNUoBcDYZIzOfazJN86/zdPFCQj0gZkEdH7gMLkgw4Azj0OvDB7XXlY2cSm06fElSiWXNuY0Lc5+6oobTUolrCC3X+yw3CX9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580332; c=relaxed/simple;
	bh=seryKrUBIRnGQ1g90/w4bC+jKNLoJoTbNOH9JPn//7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=Fu5rwNYexqcgwQBuVfqfpsLfCOz+sjC6n6nmS26NCWmptbxu+QJEHc+kWF31WrJv3j8maubKdAjlhdH04L1riloGLRisQOSKsnN/vMOpP4JelQa3iRAG+p8PGr2QhC0Q5samZDbR7h3G4K/Dkk++LAtRfzOrbKtRVb6QyPK3ypU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; arc=fail smtp.client-ip=52.101.150.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGXbD5AkqrMep674xQdTRnK7+esjwRnFrfXU9zJKT3eUKhbGjUPohcGN5G95UbrJTq2w2CvDxCOtouuDluJ+zwtwV3EGATd2ctA9GJR/3HfbjF7vQRAMmFm8OKn8Kn0B12YyTpzU3N+8Md4Ux2pxZ4iNB6hbCTLjLh+CoKe0zcAompZm3/G48F0wAbjMwgL3mQi1ydF0UK+g/da/LTuMGENZrtBkwsJmOOV3rxaFTeb3ZH1vendfblsbABGvUnEMtzVaZfPCqrMYzK8x1phvn8peA+UhkjWNePFxaqQjSxlj5LV6qvm0XYmGoN1m91LTprrXQgsDHzrPIxCl66nNUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fYjWNXcfGE/44jE74VDCmHoI+xzl4r1A5RTPPr8Y4og=;
 b=C/il5TS1+gBTzfJnrzmeZ/WR4+S2//ehdCDM7s9c1pOcbKqvmcpPRfZxsrh1bTAuIfwGf6byQkYskwqB/PGLXsXzqssB0SziCL2vm4Th0/9Iuq0+T4r0Ub6QJjs7owhwrhGVJ1RWGkA3fTyxhyH+H56d+YsBgSPVREE0DzQv+4xhdAGtZIlqGTSzJJ+wCyxsyLJIgJl4FPuU1Bf8xzOrMfAOYDDLVvg9oc8GpVljr75eLnm6nXWtJ9MLbOe/f9H4t8uC4eb0UEO1rND79atlHIp+DKoyTAkTIdgTPSrIE2IQPZIjpFWO0iJrXZFIZZLdVfvAx9d7I8m1SNT9uw5ORg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=heitbaum.com; dmarc=pass action=none header.from=heitbaum.com;
 dkim=pass header.d=heitbaum.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=heitbaum.com;
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:73::13) by
 SY7P282MB5676.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:2d0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.17; Fri, 20 Feb 2026 09:38:48 +0000
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f]) by SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 09:38:48 +0000
Date: Fri, 20 Feb 2026 09:38:34 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: netfilter-devel@vger.kernel.org
Cc: rudi@heitbaum.com
Subject: [PATCH 2/3 iptables] libxt_sctp: fix discards 'const' qualifier
Message-ID: <aZgrmmEUEQ1L_Sjx@6f548583a531>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ME0P282CA0032.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:211::20) To SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:73::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYYP282MB0960:EE_|SY7P282MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: 44f5cc34-a9f0-4229-b0e1-08de7063d95d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K0qqCv2Fd2xE5Y+gQ8SJ2RFsxPYpVeKc0QsfEjCQGHhzi8lqR8EXr9HhvWhr?=
 =?us-ascii?Q?4ck5fQXAcDn2xViZ4n1ujQqdq7oI6omxLZxSru53/6t+JXvg3fBy2VhN1New?=
 =?us-ascii?Q?zunUxadFN0OfXu4mVbqLyYuwFCAcOZhmv/MkGakseMcQg/9QA3ZvFUWEwV7s?=
 =?us-ascii?Q?EaLIb1sasFWwkIWJSMA4nucRpI/K89eyAzUVGfGV53so+GUX2QSKWldP2YJv?=
 =?us-ascii?Q?+BoewjhslfRaSAlIDvAKasz81MdcAY6byikJKMnGJY7+CoJmA8qpYzzLCZMZ?=
 =?us-ascii?Q?H+F7DzEhn0XZU9EGe1nNqEPxKptTkDBrU9V/fvVdD+pw4CtQr7ByjVNxRDZx?=
 =?us-ascii?Q?UhWEz3J4RU3iCvX01fgflkqUou3ZNqO4CC4wtAL90msGx6HGyzcVmNCvfY7A?=
 =?us-ascii?Q?oFmay7RFPiOtEIsmQ4KQiw12Km7YeAKpUVeZSDCM/1iI3kv+9pp+aF1+o19E?=
 =?us-ascii?Q?THqU599C2MscvpVG/iBl6lruW5gZ/jqgSel9GEWsCH+HBGcgVBsWjdRXrFu9?=
 =?us-ascii?Q?WWQX156E4jsDxINTcExWSesbJeO7x4V1kgU0zVIM9Bb/xIHN6aP4xysimm9p?=
 =?us-ascii?Q?HvG8QAECFkmozvNduhdoJyd8/Tz3KUaK+L7zorbBboa0B5Fvyh4aEL+2KdmJ?=
 =?us-ascii?Q?QzYOaN7w8cS6wZeXG99rcjItOQ48xVZbXmHSdR2PNmkGEFP5Q/47PRUJwbis?=
 =?us-ascii?Q?z52VJU3aZv3Qr6mDitwI7NSw4DR0rCHSMD7OWuAzx+YqhojvDPxgwbZL0zV5?=
 =?us-ascii?Q?tOVW4nKgE5J5Cjea26QVIkUVRAP8A1U9+s5Ruk9KzXTaAOd1wFT70AIg4l7r?=
 =?us-ascii?Q?CNGIUmTUHTD2G/GAF7c25Ccpjejtc4jQtqzkt9lhxYCl5PStEUgDI7xyiTxG?=
 =?us-ascii?Q?mK1nzukcOFJH340QuHqQaApeaY/QEGLzr+0Y6nGZgksA8SVIZv/BGC7DbYDg?=
 =?us-ascii?Q?24W8QudVXLQdhmfoCuLAL4gesDwe8t4rUBYGwHvDg1jdOurHUurmPB8CvDag?=
 =?us-ascii?Q?V07CBsROf3N1/kIL02ufhZP0dLMifnkvheV101O7r2hnTo4RWBZzii5hdbwi?=
 =?us-ascii?Q?4FzmD55vwj8PdNw8E9v+lmg+opvfr/3hC7xqTPYO1I17cWycDSGjzP4BNXk8?=
 =?us-ascii?Q?ktH2GAXAJfbIGU8qGWmkGhWyn7YQyqbhkr5wA+jbpzKDvPXslFp4RQiFt4Q8?=
 =?us-ascii?Q?5eTqqxanik4p8bzcMm/ueOdmLHFtDN4NHRRixwWC1yVHuKr+kAig0wY5FGzK?=
 =?us-ascii?Q?y9cq+QJTNjsp5FAxGiVONBADxOV7FZdSMwCOftpt8ZSkI9fkYpCBF3fUlgDB?=
 =?us-ascii?Q?IIFzv3/vIJxMsQcciugcb1pxyht2xgPSS/fdedZpcU1tGEebR8Bw+BDJljMJ?=
 =?us-ascii?Q?LBPQSuyklinmxOdd8v3JGfNp/cNkNZWgIow0+bmXpTcH+Rgru+swRqCGtsaO?=
 =?us-ascii?Q?w5fSqCS1zhRdwKva7LYvpWUUwJ6OukxE7YMYQHA8FCrTXBjX+hhFTGC6q7Tn?=
 =?us-ascii?Q?AQ3RcyLtAHzyvuihC+vn+CV9McLSOF/7GVbd/VGayrRnsSZFn6Q2xe72pgXD?=
 =?us-ascii?Q?B1eCdoujv3ypbLHLD8A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?51OU4NwtaZE2em07De/wrkZFVqDMaYBdVJPP9hEzNYRH4tzGN/AU7OAERcNA?=
 =?us-ascii?Q?iGlPG9XNUldV611RHdp+9vZ9e42liZGVcitxJAnyvsO+qLrIx3VEtIbTcrSx?=
 =?us-ascii?Q?M6otOo9wggJDtbp6h3vulsCiEVgiUBgcumIXxeePAPMSj+ITHNSIX0Sd6wAg?=
 =?us-ascii?Q?Bg+QFgLFYc0B6/UuN0u4868RWPRFY2Ak8X1gK4iQfVJc6o0K6m+uQpBpH1Di?=
 =?us-ascii?Q?SzQicuWzrMpGdZb4dg//VZcwH2b979Lia95I9bAJ11svtV0PMCoyCeJlaJp9?=
 =?us-ascii?Q?hEjAFBZKgR2+gdGguvM71nAIFtOVI3KDbewpnUZRv+xigjIPrD5f5+ucUEdT?=
 =?us-ascii?Q?2GPDZ6YlweG44hVzFZjqxF34WGsrw+mRGcWW1YjSu+MhE5yeToFzJ1xW3GSm?=
 =?us-ascii?Q?GHsWbnbMEtR3UhdvRhNl+7kqSjfENDe5Z6avCjlMy4p7yHla+wbFLwAE3b4E?=
 =?us-ascii?Q?MoNq3iZDMBRqP/6zdE7AxGUgTzCaDQZAhGloJky7cOm2vmVc924W2Q86t0/k?=
 =?us-ascii?Q?ATqQR5sW3SoTri4fAV4Rdsmkn8y3NtrBLbkdFAK+S/MFyCCJkHRxogfmUq4N?=
 =?us-ascii?Q?lSLIzzBhJkYp5z1sozpNgZgxWjRKYx+zaLT7NlcRRvSeSLbe9YoNtesn6bDg?=
 =?us-ascii?Q?xeMBl0ftkb8s3ukW7Kg7n+jlAVaVtYmBZ7g9TM/7EjrSU9XXxvdbZmI0IGtm?=
 =?us-ascii?Q?Dp02iNZcXEYTPLOfhwHHIA28XWL0NZ8VGdRlyB55H3kJHAil2wg1Y1G9GqkC?=
 =?us-ascii?Q?ZCy1SmYGHAV47tQcYhCQBANAybjVa75nreU+h53zMi5wjFbzU5x+WcMVsyfB?=
 =?us-ascii?Q?N+NoelxX5zEMUX8ARcGpgPuFHagodgTGBwMLF+iouoJ15WiqmbnQSsdHA7nS?=
 =?us-ascii?Q?YMsoFUplX6wG5HGwsGNfaUJcoDml7JpYQzm7ZQInuLvuAqEygU4Hk/vKwVA1?=
 =?us-ascii?Q?/Gv9pYyH7X8gvRFOQe6bl2vbLPAWnJymyLp4EiecnYHz45+TBjyfHCC2UKvg?=
 =?us-ascii?Q?1qknWQvsidOcFZpWXeFaviRBZnOdEHUAxVkYwGn0YCDyW9NavZ44gc14ko7a?=
 =?us-ascii?Q?Tbyb6hJLEI+9kYtn29REwSHzZW+XTHR40EcwIEsaUmsexp3JDM7nHxH44KTD?=
 =?us-ascii?Q?RlS8yJobfF2vCYTRRIcFk4xtOQ/TdfUf59jDYickNuI9wTLlv4zVQcvkijQU?=
 =?us-ascii?Q?CHgw/eOrWZr01G4YhhQQTabNeJv8UF4D2qThmYMfGi9bcnJiwF8mDgrECbba?=
 =?us-ascii?Q?mGNdkYmmg/uwLhhciaJ/FGl5Dcc1Rtrmg47wAklWjWa++4xHzi+kofGeyv8E?=
 =?us-ascii?Q?luLhIO9Kah+4UDPHbF/5lgm76AywTBEzePAaKEQJpXQ2i8OfIViKehLozgBP?=
 =?us-ascii?Q?kftaXJg5WUJ4D1kW/MU+uUPLyc5Z4ukFO/aoqzMmNu4Ys/BAkHsRDaxd3xrZ?=
 =?us-ascii?Q?o5JMv9O/ykdj2hi+8vPgO8SWhPL7u/bXoA/qLwz4MuIfHUjc7s+FwICXO5ah?=
 =?us-ascii?Q?Gyy4yz3AIvr58DpkV0o5Q3aDRITi9MJNdjg9UDQ1EsJ8eTsagCdViU6LJfuk?=
 =?us-ascii?Q?G4fdQfZU1CFZbqbcr5nRPf+p1wWScxYcp8MA5yWQUTIeNVonLg71qCru8xH2?=
 =?us-ascii?Q?QIO8RgwMWss5OuiR0IIRlkz1is8YLjWO01X8JBWAlhtHVIkD9Qr780ZGX8ua?=
 =?us-ascii?Q?H9ypDIJlWXft9RlC9UWjebkKgblSxX01amu+2dQjyE0StQEwUv5+EXcjRcd+?=
 =?us-ascii?Q?OZgeXgCsZQ=3D=3D?=
X-OriginatorOrg: heitbaum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44f5cc34-a9f0-4229-b0e1-08de7063d95d
X-MS-Exchange-CrossTenant-AuthSource: SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 09:38:48.8450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 35ffebb5-7282-4da6-8519-efab29b0108e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y5Pf3093rucjb4UrKmg/M0B+DKymDqrzo3d7KYODEQBVpRzTFBmVj3LkOX5r8L6oxfMtNXCzdzCXF+5qhRzgrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY7P282MB5676

p is used as the return from strchr(sctp_chunk_names[i].valid_flags)
which is a const char. Declare p as a const char * pointer for use
addressing the warning.

Fixes:
    extensions/libxt_sctp.c: In function 'parse_sctp_chunk':
    extensions/libxt_sctp.c:211:40: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      211 |                                 if ((p = strchr(sctp_chunk_names[i].valid_flags,
          |                                        ^

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
---
 extensions/libxt_sctp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 6b002402..895a3e8a 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -205,7 +205,7 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 		if (chunk_flags) {
 			DEBUGP("Chunk flags %s\n", chunk_flags);
 			for (j = 0; j < strlen(chunk_flags); j++) {
-				char *p;
+				const char *p;
 				int bit;
 
 				if ((p = strchr(sctp_chunk_names[i].valid_flags, 
-- 
2.51.0

