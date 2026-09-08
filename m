Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010023.outbound.protection.outlook.com [52.103.33.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964181FCFEF;
	Tue,  8 Sep 2026 02:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788833029; cv=fail; b=N1VksfU1wf4hPxiCVW7hnlVtS2/0r1O4TrAG9TpkJJqSFTwVfl1rnWJTrN4x8UJnLr2Wg9ytcQXi4/ExMT7ij2VZ5thvlkOxkjBHZLTjzZYPdWPIR7ytiYb8Kakl/b0/KDY++3CMzbvrM5PoHcTP6TDPZOo3np+9Q+D9fReLTBQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788833029; c=relaxed/simple;
	bh=YZtD9tOe7o2XzfD0owUzqEOsm+vLbjf+fesXznyOgRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=juYaDq9sHk0FqIEL1gn3hji3U5olxFyVQu6OI/aGDi9tSfJX4aUc4ENM6aRp/7Sb8Jrv5hrsyYmOjaOqmoqURKbOcJYWhXV4gZjWdGWWSUVu/ORSr4ZCo9kCw6W+9I0ybgZUEqlXk+lopPr9lsMdyzqvANWEFF47DDjDFe20pso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=lTIJWm5d; arc=fail smtp.client-ip=52.103.33.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="lTIJWm5d"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LfEvKOniL3iqujFKAlsXGIOoqTWZcqppuw+zOHXs353211S4oOGuY+6Yyvi+K1/tbkoq8+2jBIp6jUrHw4wQGaI89fPmmE6Kc59RRRTAQCn18jXCdY5iE6kEq+oLD5459cJTDILQJlnNYiNxfVJefMLeR3SuC4inZazIhkMLdMC17EHfQnCbOLElFHHS/Ycl7LFKGUznX2b/HhCm2XAP3ois8SCA8UQ2WEBPgC9PYJ3BmGo88j8Lg8PuVrxF4fU5Db7R8+HzuWv1fIN9cZDWSoHip6RgUtglReyy1KkxIYdwLgvnd9BCUKM5SgLDz1ThoRnCMmzcv454ALtI+z5qAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZtD9tOe7o2XzfD0owUzqEOsm+vLbjf+fesXznyOgRw=;
 b=XUDJyaP+ZqQeBHpT39WZEeKTN/wz+0euDDpQOWXvMAlYubCWn+dg32OvV0V03TMRbyWna5oxaqFUINh6OLXfIP7D5FzmugHVceQ9ElQpfNlWCXmSUvi7YuWCptl9XreXrcDvPCR1RqrjCfib1S/XhTaCpl2Y3QzwwGQJnEbiQ9K0R15D7St58iZZBOi7zk+mmEJ1SH6iH6k1soFTuLmCG+kr9+B0LEAuprdOQXv2nQPEoakcwQheu3gex4VcHu+1ohlv1C0T2qh3/EkrlkpPwHdaTmjMKKIdP7gemozxZDNozEdUJnFXtGF0P11N+CqchZNR2/jFAiPslplsztTqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZtD9tOe7o2XzfD0owUzqEOsm+vLbjf+fesXznyOgRw=;
 b=lTIJWm5d7eVl7dZ1Fe1wYTWgp5tAJ/OXX11GUGHRMm4XYloc7pOnutRiMMe8tcqmepayH7rQ2VdxynlDfmQLR/kCSRkRQ6yD8T6+/yCyH7+r5TqvfqgtpzWYnP6ccqianJHkDOKYLJ5LDsn/N/wbEOWba2CFMZQXJfB9fqeY0fTrNEEP1AFsBJKRmNeQd1cKOv+eKP2hzYso/gpK7b3rcTu7msPbyQrTnVfOHV2JusGoZf1pwpX3I2ghCW4sNOSKkmJZzQ7Op281HJIOxeA+2RjeIuxZ5FeqXcWWHb4NVc5r9ZRhVlJAS02yXEmRtdCF0ANFgLKvbNsV7hfM6XCIDA==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by GV1P251MB1179.EURP251.PROD.OUTLOOK.COM (2603:10a6:150:280::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:03:45 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:03:45 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Florian Westphal <fw@strlen.de>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack_irc: fix port value truncation in parse_dcc()
Date: Tue,  8 Sep 2026 03:03:42 +0100
Message-ID:
 <PAXP251MB0010D8326ADF7FDF11D23452C8B12@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <ap52kSh-U0VQ7z8P@strlen.de>
References: <AS8P251MB0001B81958B28F762352EF3DC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <ap52kSh-U0VQ7z8P@strlen.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0201.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::10) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260908020342.116333-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|GV1P251MB1179:EE_
X-MS-Office365-Filtering-Correlation-Id: 32fd8d36-bbcb-4ec2-04df-08df0d4d69ce
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|19110799012|12121999013|25031999004|2604032031799003|37011999003|15080799012|23021999003|51005399006|24021099003|55001999006|25010399006|5072599009|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mgsBSWJG06AsiFflsXlo8Gz5O+9m7XXAUt2So/KZ3dBKXMUm0etucseaoSdn?=
 =?us-ascii?Q?I50rpJcvKhJuY3DIcM03/bDMvaU7Gg+Dh0bOWfhNjMMIMPcUrCejas2TfoqT?=
 =?us-ascii?Q?tUc/WqnxUGvQS5oRYQcVqr/hyLWlQNo7Q+vcy3ptHm3HHNXALds8BmJ5atJC?=
 =?us-ascii?Q?Wtnt60V75RJ70aUWy8L78STS+ullQZR2ARGimfYPeWLo3U6/Dsr50HRTfI4C?=
 =?us-ascii?Q?1zI4qRbQSob0+WwcDvj3iGrc7KJTmBetN16DqRF1oI7dJQM3P0LdJ7lJpY1/?=
 =?us-ascii?Q?MVwVv48C/5fALmsiCUjjYDwI7Krs9o7Dhc2MFQgem+qkvPW4YcqYStRva8Ah?=
 =?us-ascii?Q?CQbBLtl02pOfqMEmC6MgfnXPSj/aw4ElFNbKUxySriWzUQ3ygosBCLV7mAxO?=
 =?us-ascii?Q?ter2gVKpt21zaTASc1huytRS9bLBUdJgE2gNCFhzXqykhrWpP74JUH7W0fsk?=
 =?us-ascii?Q?isEldrNoRNWBH1cxuogzYkGPwm+Omr0zZ8RIC3sBauzAghrz+MaFLPyVJg7u?=
 =?us-ascii?Q?HqJOrZlJISvjcirkbRf8yQ+TO8pExlsvRKWxd6eIRitlvpqjJbWobBKJjllG?=
 =?us-ascii?Q?3Vs9U2NuDsCnEMJmGpB2S09OyMUtfLnvcpPRAWedU9IT0ZWfACTuRpnvRAcA?=
 =?us-ascii?Q?v1QOCgRiueh+AByOUGtR2rYnKHDAQIORBoBXx8/0h+WlvyVYsuXjZlZhHxRT?=
 =?us-ascii?Q?f5fMNMMQ6IvPgaboYwlDAJ6mnX/oB8zA2YRhWSIZAgaiXvpmtKoRqZ/71uM6?=
 =?us-ascii?Q?o+dmPRu9ErM9LiqAfT7ibwsg1+D+L4mSkluJ0aU+lXCDG1u8kdkPrpw4l1IG?=
 =?us-ascii?Q?pJ7Iwos0EBMrityyN6RwSlsuiaxKmKv9cJZ3NzcNiTOQaTYhqc004hTs0uWx?=
 =?us-ascii?Q?TY5l7ki8g4c/1tzqbjlWG552A6wmSmX57SS4dHWwmczBu+H171aSV3rLOz8d?=
 =?us-ascii?Q?wG1y1ZOZJ36mWhFNbAdp88tgmosIQtgQBI6yrXhn/6lq1qJIg8Lr7Zdq1nMa?=
 =?us-ascii?Q?8JM2zZBAREjxpcGv1I28L+I83JoDioP+WC9KM2U1xrx4UCnmM1DA3TRbbEd/?=
 =?us-ascii?Q?XbMrmbun3FeNKPRveUE4uXr1/ghw6HmVGSO6rtaZ/3c3Gl0vxYPLJxq+80xk?=
 =?us-ascii?Q?5Rxzo1qzVRIV?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4s5KSLBx6Db6KrVgT2CfqFo7LjBYsirBU1A6+tqKjy6OpzkROEFk6medihbG?=
 =?us-ascii?Q?JeRcQjT4AQUaWZY3N+9PuJAdg528qohz+WmXjozV3gdnSkzPJGXEl/Jf4p5t?=
 =?us-ascii?Q?mqvV2FacMkG/DanzNNnk61w2R0gvOfh/XtGYII/+0lTqFGDTwboWEfKT/3+3?=
 =?us-ascii?Q?bKFOMcfrIioBJE/kWIsgFkhP6q4STfE3kIyncVBCR6IlesTagG6DYVYyO5wq?=
 =?us-ascii?Q?IQ2XvI++CWyQvvII8gRjMGPut1+/c5GR1aDGVsQpTLkKEPN4JLlX1qS6248L?=
 =?us-ascii?Q?ahNHcoVH0x8UwoXXSDVXZMXUt0gtG2IGYYr9h1uDcbGGz5XQcKuseirNXW/J?=
 =?us-ascii?Q?DNPlhwK1YPQhBM0TlgOh5BZZpEBPEI03DGEyko9b2YSIrDWRx1DPuZ0raX2t?=
 =?us-ascii?Q?PhdYyUYvG2Q4F6001rx4i6FYLzcq/uyWn4KH0OfGT+iFBUUk1ADWmfK9ov62?=
 =?us-ascii?Q?f57hYKugjkHu7DuUbWHjFeOfltxq9phtLTQ+cjZsU/c/gc2JpWhLW85g8Ktc?=
 =?us-ascii?Q?DpgoJLCfoDG9/AhSX0HBe6+Rkc+s5ndu404ecefuK77CSVKRVp2/t2SWUjq7?=
 =?us-ascii?Q?0vv4nKyFXaoGcYAFvHBwICqv02kDbdAragCuNQU//gSgN3l0Nf3V/s6zJKFu?=
 =?us-ascii?Q?SQ9JhVALezuwsmRFkbSaCceL02Sc8ZqL3Ktg09Ck4wtfymtKRFtNXLRKEkm0?=
 =?us-ascii?Q?McbPdRhdsaiJOMkXUKucn5c3s4xoyYgY+9HAR4JeAqFZO0li30m2D0gK6iFF?=
 =?us-ascii?Q?ER7/MdnO+bFK7mhDhDHS0x5iRpMSdW0bo3nU1c3HyisEvyb8cb7yDbhr8WNl?=
 =?us-ascii?Q?hc4WvcGuSN14atem7qdpQDgUFvzH39ic/57C1h7HSORJQJa6zseK7ej+6nZg?=
 =?us-ascii?Q?lb9VtyVYiKofB0AA0KKQfS1mHgWlsl9gc58NUl5tEeZGBse3e136h6A9nyj5?=
 =?us-ascii?Q?HaI35b7glim0oCRd1PNp2nv7x2gwqPrxohJe2lYvLxk/XCyksRoAlhONrqIz?=
 =?us-ascii?Q?BDcD9OUnJsjU2/IJ5JdknqCxfNdSo+u4HqYkIgaxOeqMt/wRtp2XIDfVgKYr?=
 =?us-ascii?Q?JbDQ8IMjexkaWZ2QnFQnHm0409bDFhaPWojR1VFS2MbdNlh1UAgWOkoiRler?=
 =?us-ascii?Q?vBgIpp+PVqsQI+TgZ7i7Yenz3FfFY/W2pHqRHbjCLoNG3dA+imtcNyi5yJMV?=
 =?us-ascii?Q?bDoD2QUP6YN6iblsHuccs3lBuQdQ8ZylcwV35MByQGfscr64BFBl3VH9kKlf?=
 =?us-ascii?Q?5Fk0ZU46Ah4k8U9RbjfLPGx7HSzXjS2zTthODBhNf1S3C1ceKVpsXOWalGPc?=
 =?us-ascii?Q?+m/oZSWxaR56MgwpWyIQuNm3qd6QVsIn/uUBzJmufo9sNChkfXLjlSkL3T7L?=
 =?us-ascii?Q?1shS4JU8+jvYFD36DKbyKbXmDmJgu8uwqPNto10iFQMTawgZ5vsUQvEcI2w/?=
 =?us-ascii?Q?kDWSlYLR+sMs/OBOoJ762Hfm9LZ8u7V5?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 32fd8d36-bbcb-4ec2-04df-08df0d4d69ce
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:03:45.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1P251MB1179

On Mon, Sep 07, 2026 at 10:32:17AM +0200, Florian Westphal wrote:
> Your other patch also rejects port == 0.
> Maybe also check and refuse for tmp_port < 1024 here.

Makes sense - the expectation is source-wildcarded and the DCC port is
the client's own listener, so a privileged port there is not something
the helper should open. v2 will reject tmp_port < 1024 || > 65535 and
drop the now-redundant dcc_port == 0 test in help() (or I can put the
floor there instead, so the forged-DCC warning still fires - your
preference). I will describe it as a behaviour change with your
Suggested-by rather than part of the truncation fix.

While respinning I noticed simple_strtoul() narrows to 32 bits before
the range check on 32-bit, so v2 will use simple_strtoull().

> This patch can be handled via nf-next, I think.

Will resend as [PATCH nf-next v2], without the stable Cc.

Kind Regards

Aamir A.
