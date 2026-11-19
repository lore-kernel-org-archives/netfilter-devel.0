Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795107493;
	b=lepz2dAhbcHsS2m3pL/3x6cQTDGdkY8etX1wDpNqW6syTP0Ihlv+zQMXmaopi6xXaO0L
	 3gC+qdPeez3n6+UkyxMH5/tb7Woq6qIZimz7RM9xkyTy+PiK7it/KjHklbVpsCsyZZnmT
	 rZsAWS1pO7OLNLZ7KbCyYN4WgdAjebVcIF0ar2oGEYVx/VNF4SvTfo0GN2SiK5d7il+0u
	 KjukwJEOK7RT7NUYBKEYLMH1PDLmC/cmaxD+R5W9Ghw4rA3dI+anuONWhCyicD17YJVI9
	 3Ie9Wsqu+NagyKPk2BiWtasTy/ILWrcU88MaWj9lJ+SW/vdFHhDXibkQgWnDEzleJrw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795107493;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=FoUWRqb3U0YwvxrrBVvLf1xmPXm3v4Rc1dAy/8DCzfk=;
	b=rcvqsBk5RFsCSZfVYTTiKqYFRNiHnTVyvGqW1F3FFobsVDWsN2EjGoPTNwJBwwvEp7sK
	 OTkbErBj8hJh7a7j70EaHEkBkRJaa+ktW2uxRibMEswRznMqBwyH3KyV8+9R0irzYcsgG
	 C9kc4osV/cnGQWrI71u9nfk0o59s6IJDj2A7i6fPK2+diX2Gi2+tvi25pzzUb0pPl/gxv
	 VrsfubWVMabO1bOvPnxEJGITJb7L9vHNIT2Yak6oEVQQc6QNLJPD2CF2ya3XnFMZHCAIk
	 9WVhvPPnJuqVZicLCy/OzDIOM9Y/vafvCq06A5QdJzyza/41Dy1hrFhegg0kd8AVHMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=it5A1bmK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.48
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010048.outbound.protection.outlook.com [52.101.46.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C486E606A324;
	Thu, 19 Nov 2026 16:58:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C486E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=it5A1bmK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jAymiXm65eQd40NGhpcElATeHwgNFX/Hh8wdowLBNTUF+Yr1VxZRJv5TeUGoBw8UvkZ38tGFITWrs4hYsgtX4b/Vj5xrIFIzAb7dCJS6bMCLVm2EyevMnzYTviaITeNtilutML4qlMMN99mMu9doMJKdZHFc7UbRARxEbkGygfI81AKQSJI4nghiv+ufqh1pnlVlHVwDirkoUTM96VOLSVqxqroqAAhcP/0cs4Cj9ijLK5pa+MEe/ziCJG61ciJ4NXlOXFrMYUox3H8halVO0WP4ShWRoS7suKWiSBXZUhHdCvoRTsjTuA2ZlpFQ7zoHqYY0CZAIfVFew/B6Lt8ULA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FoUWRqb3U0YwvxrrBVvLf1xmPXm3v4Rc1dAy/8DCzfk=;
 b=V0oymdLKWNwZacbZ2njpo3Mm/j8qRLJ42TLMscZPr1zBTpzj4JOl2H1leQJKkbDPcuHILyKI3k31gFcARMyBKAYF0ke3kCBuZl8WdEym+9L1pvuK9tv25O7hVvngcQojI1aq6AKu+JxBZEOd+tdhePLiaFYLsMbfRxrDNQtY7XS19/Nt6uvG6wMVQbeRK+MaO3x43zc3HdytXhTFXt7EPoN2b6RXSttqKSY7LuoT+aDgcXqw51YFKE+Dgp+b39dezXd0/kmZfVbLFZ4ScJ8SDFmR7Hn19GOtEFo/s0lv97MMfP63/ZP+OkJuGPBIz0WAeWT7i89sjTrltxK9UnzwrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FoUWRqb3U0YwvxrrBVvLf1xmPXm3v4Rc1dAy/8DCzfk=;
 b=it5A1bmKhepTIEJCNC/kJ6vFC4yM189W6unv5qhvw6ziT6MC9nHPAuMxLytmXj1lVs49Q3rCCoLk8+1Hs4s6bY5b2rTVk3QwsSxJ/QFmcff6CYq9JAT/wj9aG4LE/YZMy4aKfEE/CTcKOC17xYVdLBdM1kAGFaSGMUZBbldEPxhpV61igYqu8L+tYF+iXP1zrAzq5LPrUzyhYSx9c+r9dniQ/dEk8OGd0+yWawx3E26dkkk1aJb/nsPPGSoRHgV6+Dqcik5RjNlpoImsG0kI87RSd98JGyU5mcprJitWHBa0zjPv441uevSRu8tebmWOfZ+2BLZmzGOOcZV2T3tJBw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by CH8PR12MB9767.namprd12.prod.outlook.com (2603:10b6:610:275::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 16:58:08 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 16:58:07 +0000
Date: Thu, 19 Nov 2026 18:57:58 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: netdev-bot+sashiko@kernel.org
Cc: leonard@lausen.nl, netdev@vger.kernel.org, dsahern@kernel.org,
	davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org,
	fw@strlen.de, phil@nwl.cc, shuah@kernel.org, daniel@iogearbox.net,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 2/3] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <20261119165758.GA2050378@shredder>
References: <20261116150132.9594-3-leonard@lausen.nl>
 <179506821413.3136.16876288075711504414@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179506821413.3136.16876288075711504414@kernel.org>
X-ClientProxiedBy: TLZP290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:9::14) To LV8PR12MB9407.namprd12.prod.outlook.com
 (2603:10b6:408:1f9::13)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|CH8PR12MB9767:EE_
X-MS-Office365-Filtering-Correlation-Id: 84003902-8fe1-4faa-7b74-08df465e48cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|56012099006|261022105027099003|261021121427099003|261026121527099003|4143699003|11063799006|261026140227099003|10067099003|261022075727099003|261028144727099003|261102123227099003|22082099003|20052099010|18002099003|261009223027099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	imyHSdYKoauskLJsjBAaQfkrv6uDuir23+V85iG7FPIm2VO6/oW+TuV/7jOO7zKDldOu05hwgCsxlNV26notMQM02Kj33IfS/oAE78bWaTIWaAa5JIrc7igjgyphVAzpXrCQtS6QLOQqUbqw6gmwejKNpooX7bKmfX+fGx2JCcBSwhEaOkYClQvkcY0vln8jb+oxIgXbYBqsZUA70McuGaulRTrFYRAbYD7XdOVHzykfKXKWJmjIHI5yj8IcjlXD2C6Fwirs4E01cb5aRx2z/vVIXMVHVjN75I6QNmbDCf+HVWCHJYeulwRoLVn22YeTAOAf6FSW5bDo7+HwOYUiHwAe1M2wEMGTW2MGlgHqla059QU2altAv0JoyGfYKQP8Sjs24GmJObVraHPSL2Ukzhrw/EhVNVCSJ16wtKlSj5FRTwPVx2WnkzoF5A4UO7IuA2wUdepc58wG0Sxa5+gBvVg7cazj3eTzbIILzbA3hbJTL9+fNs7l6YF7zczZ3PhLKjqeKSlIXeLdBX68ipTLOlvqzTB8aRmNWE8gcQjQhmigHbGv3UEA2YcamWx8sC2Fnstbor006L7qFWzRej9tOUPrZrYIHYjvf7jUXzLofK6rsqjXl+By6xN8aLXGoF9/Wh9JcgvYy8OtbBPzWQgTi3S2bNZTJs36ip+CTFO8lH8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(4143699003)(11063799006)(261026140227099003)(10067099003)(261022075727099003)(261028144727099003)(261102123227099003)(22082099003)(20052099010)(18002099003)(261009223027099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWRIQnl6cStwK1RTK0pHK3NjTHNDRGpsUDhGZTc4V2ExOU1rQ0tFaU9Hektr?=
 =?utf-8?B?akJ6YTduRFZLRm85cUJlRDNTUUVJd2pXNUt3c2x4UmoyVUhzRmkxVG9rRjg0?=
 =?utf-8?B?NmVsLzR5ZnRVNTdhY1c4NklWcE5pc0wrS3VEMDRROTBNRTJKc25pckE3NHpY?=
 =?utf-8?B?cWYxZTAwYUMwZUdnRGdneVFJMVBvdXVXN0xZM0ZmWElkbndiVklvZjYyOVB4?=
 =?utf-8?B?a294Y21DOVhTY0NSVktZcFBTTm5oS1drRmFKbjdybFFsazlrbGEvcFE3ZC9S?=
 =?utf-8?B?WlJEVCt1dXdteTk3WTcxd0JvSmxUR3ZPSUl1NVpPYkFRR0Y2REJETGRSQUx6?=
 =?utf-8?B?WVFJTlAwOFFLai90akRLQ1hHWWZqWTYraWh4eEw1dXJxT0JabnI2RnZhRm5z?=
 =?utf-8?B?K2M3cExKblJrcysxR1RSaTEzbnlDa0ZiMWxyV1gwdVMvWWZZUm55ZHBZK2VX?=
 =?utf-8?B?LzdWdTNUbENrUHpsemZTN25sUFBnL0NjOEtHaExkYlgzYmI1SW53RHk1bUNH?=
 =?utf-8?B?MldVUm1GTTRzUDBiU1JveDdmNjhNMVRPM1JKdUNBbUZuenFSdThJNmVNd2FU?=
 =?utf-8?B?cUk1dEMrZ3VuZE92YzBMSW5RT1pkNTgwZER5aTh4c05LUjI3NzhzZ3dVU2Jp?=
 =?utf-8?B?R2hJYmU5NXlZdXZVWDBxWE11cjRkVlBCNzRudHFtd29NeUhJQld5M3dBVE9B?=
 =?utf-8?B?V0JnUHluZDhxMGhzaHVMRmZ5a2lhNWpGUFR2dXZEVk0wWGE0Sm1jTEpQZHp2?=
 =?utf-8?B?TUZ3dkgvaHBNSU5iODFFcTZFL3l6L3hYWHlMd1N0RmZyWEF6RXRWQlJ2MDlo?=
 =?utf-8?B?T2VKZEhuMjB0ZVh2OSs3VHFXRzExNmQrOXNLV0JDcFpzVFlZcUl0Qk1NRlBI?=
 =?utf-8?B?WWVCUU10V3lxaVVJU1FPeS9wc2lqM1Jaa0tqVE5WdWtjVlkzMmtHNnJnR3FF?=
 =?utf-8?B?TTZ1MldGbU1hMmxicU4zd1RCVUtVNmhJanJ6ZXM1QVQ3SEZaYTRMazZVWHFs?=
 =?utf-8?B?QzcxSmZsWW9RUGkwOEpjaFMyQ0E1QjhpMklGV3RmMjdOQWVqMnd6S2I2cnFw?=
 =?utf-8?B?QWhGUCszUTlaSW1YQ0ppUUFEb08xNFNsL2FzNXdaNUY5Mjc4a1lhWnc5dXhY?=
 =?utf-8?B?VUtZUmhHVGVsZU9zclRFbjRiTmtzM1JuV00ydGo3MWVaQVlGYVZCTk5KZnh4?=
 =?utf-8?B?WUhUczA4ZGZvYkpCRDBzaGJxYWZXT2Z0Uzlxc0ovemhUZ0hkZEhMMFJhbVAz?=
 =?utf-8?B?Qm5UWlBYWHBhRU41c29rVjBvMDJENWpZOStnQ1UyUENzU2NEc1E3RnZIVDZC?=
 =?utf-8?B?azJ1eG9BZG1rczBqZlVEbUFKWHIzVmJ0T0pjSCtTYVUxNklCLzVqYmI2aCsr?=
 =?utf-8?B?WGFtOGNBRVA0Y1ovOWJPeHJWSENjamRxSEtFUHFTL09hR3M4RWxKOWFyc2x6?=
 =?utf-8?B?ZytWdnAvcUNGRVhjSXEwMUZ2UTQ0NGdodHAzOTc5M2tOaElWYkZiNzZJRXhP?=
 =?utf-8?B?QWhzYlFyOWd2K2gyZDZuYzRWRVpTa3F5OG1MallIMklVcFBFZWJjbG80bWN2?=
 =?utf-8?B?N0xET0ZOSHA1bWpueUQrNjBjVXJucG5TS0M2MUw2QmsxVzZCL29uRWVSZHpx?=
 =?utf-8?B?YzQ4aUlaL01DME02Rkc5Z2ZQaFlIS3JSTEVYMXRRaW5aL1hJeTBzMGZVcTJt?=
 =?utf-8?B?T0JFZWhZS295SXFmWVRKMXpDRmtEd3R3YmxtMVhkcWRVcGtPTjNJTnlFQ1hP?=
 =?utf-8?B?RjlwdjdNNDJsL1BOT3luUUJ5R2trT0kxVnpxaTlydlVVSlR4WlNiTlhhc0ht?=
 =?utf-8?B?SUNmYVBhUWhHVXpxbUdteURKeUZreDlJU3F6czcwckdkK0xEb2E2eUY1YStW?=
 =?utf-8?B?VVV1cis1MkJrajJrYlVaZXQrY2VZRk5yamphOXJ6YWExMkd4N04rNkU2ZmhW?=
 =?utf-8?B?cDR3VUZ3dCtHWExhRjdzeDM5cm5WMGU5YzNscUJUd0RFZTFwenp2KzVHUEVq?=
 =?utf-8?B?aW9pQVhzNTZGemRKV051b0VRaVVZUmQwY085SXlteFQ3NllEUit5VlZWQ0N3?=
 =?utf-8?B?TDgzaCtuVHlqck1iK24yYVJGRDhCeHdvNjc4Mnl2bFhWT1ZwSkQ3NUlNSFZI?=
 =?utf-8?B?bTg1QWRDMVZ5U1p4Qk1PQmJrRThObksrUnBjUGU1T3piWFYvbTdyNW9tWUd4?=
 =?utf-8?B?RTRsemlzbTYycGt3aGNoUDYvd1VjNjhFYVFzakxMdnJYVnJuTWk1eDNnM2dU?=
 =?utf-8?B?UStNdFFPaWpzMEtwM1lCcmlBSk5vR29CZERBVi9XeE83S3JQbDN3eXN0cmJh?=
 =?utf-8?Q?cOsbMCDhF+EfV1MBHL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84003902-8fe1-4faa-7b74-08df465e48cc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 16:58:07.4977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wQJo4hOoeeuKJr01QTKdV62+pR+ZDzjIjdJA7TOp5l9gHnJy3wvQwPl0dU4P8X1SwJx2SMhEHKioi8EDhXpxnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9767

On Thu, Nov 19, 2026 at 06:03:34AM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The new RTF_REJECT exemption in fib6_rule_suppress() and the
>   commit message's reason for it ("Do not suppress such routes so that…
> - [Low] The commit message and Fixes: tag present this as a fix for the
>   nftables regression from commit 1c32b24c234b, but the code change has…
> 
> --
> 
> ipv6: Honor suppress_prefixlength in fib6_lookup()
> 
> This patch makes fib6_rule_suppress() honour suppress_prefixlength when
> the lookup goes through fib6_lookup(). That path uses
> fib6_rule_action_alt(), which never populates res->rt6. The new code
> compares the FIB entry prefix length against suppress_prefixlen, and it
> does not suppress results that carry RTF_REJECT.
> 
> Link: https://github.com/firewalld/firewalld/issues/1600
> 
> > Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
> 
> [Severity: Low]
> 
> This isn't a code bug, but should the changelog and Fixes: tag cover the
> other fib6_lookup() callers too?
> 
> The new branch in fib6_rule_suppress() runs for every fib6_lookup() call
> while custom IPv6 rules exist, not only for nft_fib6_lookup(). At least
> two other callers change behaviour.
> 
> The first is bpf_ipv6_fib_lookup() in net/core/filter.c. This is the
> bpf_fib_lookup() helper without BPF_FIB_LOOKUP_DIRECT:
> 
>     err = fib6_lookup(net, oif, &fl6, &res, strict);
> 
> The second is ip6_route_check_nh() in net/ipv6/route.c, which validates
> the gateway when a route is added:
> 
>     err = fib6_lookup(net, cfg->fc_ifindex, &fl6, &res, flags);
> 
> With a WireGuard-style "ip -6 rule add table main suppress_prefixlength 0",
> bpf_fib_lookup() now returns the VPN table route. Before this patch it
> returned the main table default route.
> 
> For the BPF helper, the missing suppression is older than 1c32b24c234b.
> The custom rules path of fib6_lookup() came from 138118ec96cb (2018). It
> was converted to fib6_result in effda4dd97e878 (2019).
> fib6_rule_action_alt() has never set res->rt6, so the old suppress code
> always returned false on this path.
> 
> The v3 notes say this message and Fixes tag were suggested in review.
> Even so, stable backports that follow the 1c32b24c234b tag won't reach
> older kernels where BPF users are affected.
> 
> Would it make sense to mention the BPF and route-add callers in the
> changelog? Should there also be a Fixes: tag for the older commit?
> 
> > diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
> > index 5e2a79a81bf35..2f43e4e48e0d0 100644
> > --- a/net/ipv6/fib6_rules.c
> > +++ b/net/ipv6/fib6_rules.c
> > @@ -288,6 +288,12 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_suppress(struct fib_rule *rule,
> >  	struct fib6_info *from;
> >  	int plen;
> >  
> > +	if (arg->lookup_ptr == fib6_table_lookup) {
> > +		/* fib6_table_lookup() returns 0 for reject routes. */
> > +		return !(res->fib6_flags & RTF_REJECT) &&
> > +		       res->f6i->fib6_dst.plen <= rule->suppress_prefixlen;
> > +	}
> 
> [Severity: Medium]
> 
> Is the RTF_REJECT exemption correct for RTN_THROW routes? The commit
> message says:
> 
>   Do not suppress such routes so that they continue to terminate the
>   lookup, as with ip6_route_output() and IPv4.
> 
> rtm_to_fib6_config() also sets RTF_REJECT on throw routes:
> 
> 	if (rtm->rtm_type == RTN_UNREACHABLE ||
> 	    rtm->rtm_type == RTN_BLACKHOLE ||
> 	    rtm->rtm_type == RTN_PROHIBIT ||
> 	    rtm->rtm_type == RTN_THROW)
> 		cfg->fc_flags |= RTF_REJECT;
> 
> A throw route doesn't end the lookup in ip6_route_output(). This is what
> __fib6_rule_action() does:
> 
> 		err = rt->dst.error;
> 		if (err != -EAGAIN)
> 			goto out;
> 
> fib6_prop[RTN_THROW] is -EAGAIN, so fib_rules_lookup() goes on to the
> next rule. IPv4 does the same through fib_props[RTN_THROW].error.
> 
> In the fib6_lookup() path, fib6_rule_action_alt() only checks for
> fib6_null_entry:
> 
> 	err = fib6_table_lookup(net, table, *oif, flp6, res, flags);
> 	if (!err && res->f6i != net->ipv6.fib6_null_entry)
> 		err = fib6_rule_saddr(net, rule, flags, flp6,
> 				      res->nh->fib_nh_dev);
> 	else
> 		err = -EAGAIN;
> 
> So a throw route gives err == 0. fib6_rule_suppress() then returns false
> because of RTF_REJECT, and the rule walk stops with the throw route as
> the result.
> 
> The callers then see:
> 
>   __nft_fib6_eval_type() returns RTN_THROW
>   nft_fib6_eval() returns without setting an oif
>   bpf_ipv6_fib_lookup() returns BPF_FIB_LKUP_RET_NOT_FWDED
>   ip6_route_check_nh() returns -EHOSTUNREACH
> 
> In the same case, ip6_route_output() would use a later rule. An nft fib
> rpfilter rule such as firewalld's "fib saddr . mark . iif oif missing
> drop" can then drop legitimate packets.
> 
> The lookup already stopped at throw routes before this patch, because the
> old suppress code always returned false here. For a throw route with
> plen <= suppress_prefixlen, though, ip6_route_output() moves on to the
> next rule. The new branch makes fib6_lookup() stop instead.
> 
> Would it be better for fib6_rule_action_alt() to return -EAGAIN when
> res->fib6_type == RTN_THROW, as __fib6_rule_action() does?

The patch under review doesn't introduce a regression for throw routes
(which I suspect are rarely used). fib6_rule_action_alt() never handled
them correctly and always returned 0 instead of -EAGAIN, unlike its
__fib6_rule_action() counterpart.

I can follow up with [1]. Regardless, I don't think we need to hold up
v4 because of this, as the patch is fixing an actual regression.

[1]
diff --git a/net/ipv6/fib6_rules.c b/net/ipv6/fib6_rules.c
index 0ffd7b47a046..adfaf2b8884c 100644
--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -191,7 +191,8 @@ static int fib6_rule_action_alt(struct fib_rule *rule, struct flowi *flp,
 
 	oif = (int *)arg->lookup_data;
 	err = fib6_table_lookup(net, table, *oif, flp6, res, flags);
-	if (!err && res->f6i != net->ipv6.fib6_null_entry)
+	if (!err && res->f6i != net->ipv6.fib6_null_entry &&
+	    res->fib6_type != RTN_THROW)
 		err = fib6_rule_saddr(net, rule, flags, flp6,
 				      res->nh->fib_nh_dev);
 	else

