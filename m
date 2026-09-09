Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011038.outbound.protection.outlook.com [52.103.39.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFFE48E0F4;
	Wed,  9 Sep 2026 23:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.39.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788996509; cv=fail; b=N7W2ERdOMY6U5HOIe7Eihl/C0z+OyMxCOeiyLwGqYO44hHzv7Mf/WOcP43vry4cUhd+K07X2bzQ1wOjbpKxYuiAys2U7msn86C+Ex5CeXstSqPprNwisoKaP3eFR27i+rQDliJNZAXWAbsA7gpEMCKQaj05yZYSKRysYQsgMbuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788996509; c=relaxed/simple;
	bh=lI6jzbZ4CCKBANcD/VZG95g0CJJi+xLMqRixDKCQY10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=La2fEzt3fq8c8GUGYNJ1E6cq5Ndf08R9zozw6KvhegnsNv++XEe9NZOaJWiYLhtARJJPt9ZmJ26j1RnKvBZg1rZVJz294OqcZGjyXeWvaG6H6U0YsFwh6gwz+0KU1CmGBqvPOogU/Ph09t1dPGxukqm3jxXA+TVNjxoxJ9xhQHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=jmq7HO77; arc=fail smtp.client-ip=52.103.39.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="jmq7HO77"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uFNy5Ziyr4sukjEbba9dlxlIt5TKG8erx6d6kwjo2XSD4aXPjZIHPCfEm+qFVPeB32giOhkxeV6Bn10ZnA3PR7ipXkeGX5zk8yigD1MbR+THhhbOAmAyagxBOBvpL2wEuulUI+MrgnpE7pW83MNjrCOH2U3t2mptAJPHqbdr8VO5HewZz9yf62vAP5d8F37o4/CLuI/fDzqczlV5xF3yxmWizlUp54cgWz5jTrmAC3msqRM9wyBlmSqtSwfth2UhSzeR+KIp+rp94lPlKGMlqA7RtFrmPffN3Zn+JmwPKUzZRxf+LFX3Tp2OBihc7DxtEEHfVCfyA1K4Gkv0neLrxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lI6jzbZ4CCKBANcD/VZG95g0CJJi+xLMqRixDKCQY10=;
 b=hw7Bl/wLAByUImj04UAUt8B3+FZvQVGpe4TCxrrGuaG9pXW0NKPETHcveY9CvTCrWQZCaTrDFe33wJnr+M05kJDKfG5wegIKUvl/3SNUp8QAsM65owH+EFg64xI0Uif/z6sWV6o20xthAATLKaNZ/oJeP/aB/9jYTDjHFzbNtt2PteMsIyjvUMaXS82ol/tvBYJc66DbcMIXOsHmMEx5m0AHcasHHcFZ7Xmzk5ycRxxjHUN8jhBP/fRlO7z7m22+drK9+JBcmhFL3R9EIKia5KqiyCVEPgLp1zZuYxhj52sq0UBPQIW89Anx8adjN4W1Fx44sYL+NO9zEC3ke1XP2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lI6jzbZ4CCKBANcD/VZG95g0CJJi+xLMqRixDKCQY10=;
 b=jmq7HO77Q6WwDPU0bE3Yn+DSmFsLpLfvlwI7k8jE0Hjs8FK5zUOoczfozxsXE7WJco7/+Sb6vNgJvwNCP8uBQkixr9+qsEFXq40QbJTCdcA4Us5Y1ji9EkddYj2CmYpxD9xudhcpG0RyvVfFCIxmoptjF6/F2ZqtoV4KlC/8gItMsEzLFCjz+5moT7HnbRfNemMGlq8z4T1J9IzT81NaOiO5r23CLDi9rg5HVkM4dHfkWiCy19bkhXWSztNsn5MFFX6qFzeO9XkwLA2LMPFaf+wudJsdf7h30Rq8o3Q5PpBCabC/DRrM4TjiTPwrGCTa/R/0OD0sGSopcC2YQuhtqQ==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by VI6PPFE5C97BA70.EURP251.PROD.OUTLOOK.COM (2603:10a6:808:1::16d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Wed, 9 Sep 2026
 23:28:23 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:28:23 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Florian Westphal <fw@strlen.de>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Chenguang Zhao <chenguang.zhao@linux.dev>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kuba@kernel.org,
	rc@rexion.ai
Subject: Re: [PATCH] netfilter: conntrack_amanda: fix port value truncation
Date: Thu, 10 Sep 2026 00:28:16 +0100
Message-ID:
 <AS8P251MB00016F264A917098FC362B48C8B02@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <aqFNnGrfB65odAFn@strlen.de>
References: <AS8P251MB0001CCFE2A0F40637E5A366CC8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <178894676277.219967.1844924383954861310@kernel.org> <aqFNnGrfB65odAFn@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0075.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::16) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260909232816.31044-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|VI6PPFE5C97BA70:EE_
X-MS-Office365-Filtering-Correlation-Id: b551c4f9-9f9b-4c35-32d2-08df0eca09fe
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|19110799012|15080799012|51005399006|8060799015|5072599009|6090799003|4140399003|25010399006|25031999004|23021999003|37011999003|55001999006|24021099003|26104999009|3412199025|440099028|4302099013|1602099012|40105399003|10035399007|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXJ2Z1hJK0xMQitMV1J0bzJqaTJIQVRnNkdzUFRiRWhKQzdQRDRuckNpRkhp?=
 =?utf-8?B?TVJRejkxbmlsUnFpMm80aWprSG9tbUFRa2ZHM24yRXlCdWRUUEZVcm9qR1h5?=
 =?utf-8?B?RmdQeTVyWUdsdDhSTTNISSs1bWRJNEszUFlxZHZmY0k4UzlIRnJ4b3VjOEsw?=
 =?utf-8?B?L2pjdEZQZ2c0b2w0a2dYaHMxbStLT21JbmsvL3QvblVtb0g0ZWhyRDRSNUR4?=
 =?utf-8?B?TXJkZk5KUGpPdE5mVGJHaHdHdk9rdUtJRzlsSDBaMlpHNUVoOUMwcUpEa1di?=
 =?utf-8?B?cTdwTlBiZkVkRDY5REdDYm0zcHdGV3M4blQ0VThBcldxM1JWMzZsWm4zN2g3?=
 =?utf-8?B?Wk5YaHU3bytjbUgwQ3dlRnU1ZnRvTWg2ZU9JS2lMcGpzYUFQMnVKVGRzRWZQ?=
 =?utf-8?B?VnpadmxVWDlXTHhydjUwZjU2MmFlallpRENuNjVJcGlhRlNWMjAwSFVNR3BJ?=
 =?utf-8?B?bUcxTTZEZ3BMRm1yZkdUMmlveUk3ZjZreDlsTWt2Y2hWajZKR2l3d2V3Wkxz?=
 =?utf-8?B?amE5TWtWMjg3eDMybkgyNGxNdngvQ0N3Wk1tQmpBTTY0TGZSZUs0ZlpzRjFV?=
 =?utf-8?B?UnR5ZWFBRHNBVnVJVHZUc0E2SmpRb0ttSFhNZFFKR1pzdlF5WVNqWXE3TlJu?=
 =?utf-8?B?cWh6enZtb3FWWHNGRnRud2NWK1lyNnNxcDM1QnNLR2kxejRpc3JXVk1xK0tG?=
 =?utf-8?B?dWpFQUYwdks3ODJORDRlQUZhb3A5Z2wxNWl2cXRaRVZHV1hvQXIydzdWU2M4?=
 =?utf-8?B?T1FtZktyY1lJdXV0emRLeWluMmJmUVJrWWFFMFV1TlZ2d040L2xoMDMzMkg5?=
 =?utf-8?B?VTk5cUx3SzRCaUNRaVRtSXZ4NXdwbzNVY3RHeExJaURRMi95ZGVDNmpBTmQw?=
 =?utf-8?B?ZU9HdFc5YUViTzVwRm9sMkI0eFlxWkNEczJzb1ZqZllmOXU1dWthOTVFYXE2?=
 =?utf-8?B?bEFiUFpMc0FCUURrcisvMVUvS3Ura3JOeG4vcWxOR3d0cVh5aDA1RWNFT3Ru?=
 =?utf-8?B?QkpNZkJudTlzeFVzL3FTLzAzZkRpY3RuNnFVa0Z2QWhiaGZ4SXRIandiV3ZE?=
 =?utf-8?B?OGpKdXNsVGl3VytVcUZKdTlDWnlVVmVZc2RHeFIzRURUQ2VBd3YwT1pXc1hX?=
 =?utf-8?B?N3VUR3dwa1piUzRUbmhBWHJhS1B5b1BzOFF3TElhVWlmR1NhZ0VGSmkzRXZY?=
 =?utf-8?B?a2pNQitZL1gzazNrd3JNQVFKRlNrQnJLQ1pSMWJSQUlGclhKOFpXcFpMb0RF?=
 =?utf-8?B?UWJISTFrTmZ6WEIwb2lnSTI1eURWdWJBZ3FXMXFrcnd3a1ZsaGZpT2EyZkRo?=
 =?utf-8?B?UUNQNTVTeUlSekJrVFhibTJaTW1WZDBHTGdhalBRNEZQWS85N2owUDFWbWE4?=
 =?utf-8?B?N1VXYlJMa2twTm1yQ1FNcHN2dGNadEtXTk5xcXVKVFZMWnlmaXo0clFCdy9j?=
 =?utf-8?B?OWN3c082aFRXUXRNL09TT2ZOMU5OSnJNa3laejcxOTFjM1BQa0xzRDR2eHRU?=
 =?utf-8?Q?F/UVUGjfR15j4X33wvmZDRxVs4l?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZE45QjAvaS95RGdzNDN5cFJ5T3Ayc05UUEF6ajhEcm9vSlFRTTRyL3NvVGtt?=
 =?utf-8?B?Z2JoQVZFZ2Y3YTFQUVE1L3hMaXg5RUNtdndSTGdmend1U29Ba0JUbHZ0ZXgr?=
 =?utf-8?B?N1ZDeElOZ29ZTHhqRGo0TldMalNDbEJUOFVLbktJckFSRk84b2NVeW4vaStU?=
 =?utf-8?B?djI3K205QnVVTHoxaG0zUWtQNVZhQ1ZjQkFidkNiMkMvYXVvM0lyRWo2QXRN?=
 =?utf-8?B?RUJVVjZhdWF4djZKVzdTL09CT1NnY2wyZXUzalA1Zzk3RVVDT3RhQjFFOTkz?=
 =?utf-8?B?UDBZYSswRW4yeGM5YkZBcGlMSXZleUwxR2JjUHpsNkM5TTR0amgwbDRwZm02?=
 =?utf-8?B?L01raVM0R012cXJRYVV3RFMzVU1wcDIwZUtLNkdtdWNMZEdCcHRGOWJaNnZL?=
 =?utf-8?B?aS9qL3F5RXRhdzRScm8vOGpZZDV3NjRtZkRmemt1eFdnbXlSVlNkNWVmbnFH?=
 =?utf-8?B?dlZsbTJadGlUMGdjS3JCUXJPa2lKSjY2ZmVPKzdkZi9IeXE4aWVnam95Mldx?=
 =?utf-8?B?ckhOck1MS3JkZVNaK2tmNkhLNnROaXBTTTVKalV0RXVrN3JnNmdlKzdqK1dh?=
 =?utf-8?B?N3RxY0h6YzEwbitHTzBEZHJBYkpYNDBqU2JEV0MzTDhNNVJJNzgzTHY4Rlor?=
 =?utf-8?B?eWl5RXNpQXcxYzlQT0NvUnpPMVZuMzlicyttaDVmL0xrMHNjSEwzY3dTOUk4?=
 =?utf-8?B?VEVycnBRa205RHl4d25NaUk4bTNaS2ZKcnI1c2x3MEFmR0k5clZmV21INmxR?=
 =?utf-8?B?bnNjVTN4K3JnU1lEM1BaTTIwUEhsaW1VbHkzTFg3WDh2OFNldDVGUmZHNWZt?=
 =?utf-8?B?TkplQjg4QkQ1NStqRDZ4K2tEV0FSc2VacmMydnRLNllMdDVBZ3hiajBNM1c4?=
 =?utf-8?B?M3JGcTBxMFErSEExeHdrTnZlcEhCSGlzTnNkcDBhVkpFV2loNWt1SlN6Z1lr?=
 =?utf-8?B?RnhZZjNIbW1NT2pLRHRsckxiUUVTeWYrcklDOUVPL0dPbGYzNnpsV1pHR09N?=
 =?utf-8?B?MVpqK3NOSFk5YXNoU2RlYm83QlJJLzNIem9WRXAwRk5xL25FQWduak9kN0RN?=
 =?utf-8?B?MndIT3pDMXUvRUNVTysrK2Vzb3pVbW1YOGVPaFkyZjFQS3BmZ3h3NVZJY1VH?=
 =?utf-8?B?TVhYeTl6RllkLzdSM3N4Q3c2TGN6NUp1emtNVHR4aE81V3oyK0FBa0liajMw?=
 =?utf-8?B?ZmNZRFR4blo2NndVUEdYaThkdVRPS2x5aHZ0UEt1VmxaUkxEQUZVdWVnbVhl?=
 =?utf-8?B?a3Z1T3VhUVRIb1lPRFQvWldpV1BGQkJrNGltL0dob29XaTJPdDU3b0czUUlp?=
 =?utf-8?B?UUFwQVlVQ2VESGFYdVZ3MnQ4WUtkcSttNzR6S3pHUDBQMkNTWVJjQ25oYWd5?=
 =?utf-8?B?MWRtRmtza0pIa2lHQzI5QnYrMFhta3hYd2NhZU92bmFnS1U2SXp2U09yc3oy?=
 =?utf-8?B?NlhWcFV3dHZVRHBxaXFLUDRxaU9jV0h5MVM4U1NJYytVdnpOSXBoT0ZVVDR2?=
 =?utf-8?B?WnlwMU9udlZYaFJ5UXFpMXJzRHZpTTlNT2VTYWJhcTQvZjkxRCs1T3lOTlpH?=
 =?utf-8?B?N0pXRWRsZVIrdFB6clpMQXB5VUd0dFBwbW44ME1ta3hGajM2aFQ2OWVYeHpM?=
 =?utf-8?B?aWwwZVVKeSsvR0FlRjUraVhHNzIzYzduOWNYQXdJNmp3V1hMSGNqQk41MGQz?=
 =?utf-8?B?SnlNR0JpVHkzYmVuckh4dHVVRDVDaGV1SXM3cGF6N1JRS3ZDVHRjUEtjcFcr?=
 =?utf-8?B?YW9Mc0Q2THRCY1pNd0FhOVV5MmwvTXBtTlZTaUFLZy9obzJMVGlSY0Q0NXFO?=
 =?utf-8?B?SXZIYjZhcWtjZVRLQUlORXk0RElubE9sd3VUOTY0SFJYOEI3NkdmU0w2UFNZ?=
 =?utf-8?B?QjZ6eldoNVJMcnh0TmNhSFJKNXZpcERPUHdzT3l1UDUvMHhReUtQNEpCMzZs?=
 =?utf-8?Q?mLRBTIMo8yy8+IDXhhmAQCS0QAbQsGyt?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: b551c4f9-9f9b-4c35-32d2-08df0eca09fe
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:28:22.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI6PPFE5C97BA70

On Wed, Sep 09, 2026 at 02:14:20PM +0200, Florian Westphal wrote:
> There is queued patch in the backlog that added a unified port parser
> for use by all helpers:
>
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20260503083220.630655-2-rc@rexion.ai/
>
> I think it would be good if the author of that series would rebase and
> resend a new version.

Yes, that seems a better overall solution. I will drop this patch for
now. If anything further is needed from me, happy to engage.

Kind Regards

Aamir A.
