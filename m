Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2120.outbound.protection.outlook.com [40.107.104.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A34E2747B
	for <netfilter-devel@vger.kernel.org>; Wed,  8 May 2024 10:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715163674; cv=fail; b=q7IbRniJFwG7zKyRdYVc1C3jPqUQVVmnjfTFylD6LQbWQA/QjiaFXYkyGVZSZfx2BcvU8yRUYPGuLNd/g3aWI2Vnsrq3T22YCZUqLvRoGREW3s/22SXC5CdEBiAiyioI4DaygKoVcbEViUarcJiTnuUlE9YFE+8uXsK14QKVBqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715163674; c=relaxed/simple;
	bh=No0HuQQT9/ILhHJNRft8VQKR5GREgqVTZ+SU0KalK1I=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=B6cVk4/iq7VTm9AfSMiS4M6FascasALBuot92g1V7q9VLMbExmcPdvMpZH6+cCc7hI6cFOfAxoLybIJXH837m6DqqXooPbflQqIIsGLJUgFErcCLqmHJ5yK3aC6y7GM7cfN3R8vSR0ts16MlygV3dsJcyxDcrw2N8UYGgbEBY80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=MeHerL9l; arc=fail smtp.client-ip=40.107.104.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="MeHerL9l"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRrEkomrSULIVRv1iz1+Pw/TmEuIHcU9Ql2e+q+ufR0f8voFLQF3Gu+phYSWn6qjNXV2C6hST1aNW3acqvI8j01yKJZvWrZ8ETuIidZdjwXiMKDX69X8Xv5eLbPcDa7q6ef8GmbOBDGdcmr65BefFPYNGYkZtpGL672/osuC5BmTqpFOWh46tuOhZR+6Rqrw4RpCJQh6KVfLyPrcJQD1/MKFNm36mJUgl4XARWsvZ5NbxcCsrot1Q2q0gUZCZzkaWdjnd/6wmeKu3Oq/plB4GLOakOgENxRJquCd2BM9YhL0n4QAfVeV/t/txvM4E7PZO75yILN/Ic66SsraNCvsew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=No0HuQQT9/ILhHJNRft8VQKR5GREgqVTZ+SU0KalK1I=;
 b=V5iLzX6YUWzN2LU4wbHggy0JUN1Ji9U9mrkPnsQX52gfRUzlORpQ+an1yYsnGCbVMtAZ2u0O40cLhLodt7XrM8E8c5ybjSiUIkMSCzrh5uDfI6tZq1BhDb03TJOr3DNkMXAYbGrwATmfIED6CGfsIfjlC8FDmWzli9JKt56Z7rQdSE9pGPSiIdVu9F3iPjkzcjSqjP2vh9o4sWZYsDHYSjJqiquEHBVfxMEMR4JZ1PxV9CfcgSs5/v0t2f2U52MHKc/uFe7idadIuLiTjxCJuLX83w3+CJ0/2OtzhoTYwSxg+bQ/dVFnA1V/1Rr+frIKfmLvsL8WPUY5P5JfpHMb1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=No0HuQQT9/ILhHJNRft8VQKR5GREgqVTZ+SU0KalK1I=;
 b=MeHerL9lqHqEhr79tWtO3iT9mwA6/7LTYzIsZ+SOY/6QQXzH6JRrYNyEn5QA02zOi170hXl83DML3HAJnjd+2QVmxFvOMDYTwcw2ksYe2I1lMsUKm6oIGD7ipMhkNoWEley0x/Rab+CYRnUo1e/v10B8jTA/6deYVf5GcXABNsk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by GV1PR05MB11537.eurprd05.prod.outlook.com (2603:10a6:150:1a4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Wed, 8 May
 2024 10:21:07 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 10:21:07 +0000
Date: Wed, 8 May 2024 12:21:03 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de, pablo@netfilter.org
Subject: Could not process rule: Cannot allocate memory
Message-ID: <qfqcb3jgkeovcelauadxyxyg65ps32nndcdutwcjg55wpzywkr@vzgi3sh2izrw>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::21) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|GV1PR05MB11537:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef87b35-bc98-49d4-a01e-08dc6f4892c6
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OE3utV0yvr12/if/m2dB3xSVTq1msdFEeAxP/gPQ2Ydm3V2Kofakk10o4xLp?=
 =?us-ascii?Q?8O2HyfAu/nVtBJ4FN/O/qPSeqdzbbiJqPIQqsPt+Y8NCVek1ssauFJgtXcb9?=
 =?us-ascii?Q?mu8+QMXTsRqJ9jLJSHxWTGZ/lZExhogzxRj5POP4/lrGCnccMTSc75Wj2p1Q?=
 =?us-ascii?Q?hzD/JfRyA1uPLftSYfuySDbA7GnzUGVzs45K+uNOEtiA28wV8IhglzLy/me2?=
 =?us-ascii?Q?4/Klgt5hD+5kEDvpzs5PO3x8FvrqYNaDbxo2DywYIRnrbKJHpVnlDbsHmuBr?=
 =?us-ascii?Q?tvwQoHmJ4PcnyefPicsJvfDCF4u4lMEkmZGJ3AYJmx7NDrrG3i5fBkKnc6LQ?=
 =?us-ascii?Q?m/bfGQtf0karz6QB+tTFR6o41Dj8SAG5yTQ76Oh4W4b21VaI6YRXZgYNTIH6?=
 =?us-ascii?Q?nrem06RDqbcmhCSh7UPy+B5wqet1tkohSLM9OQ6DagVZOL+f6a0h7p8ZYwxK?=
 =?us-ascii?Q?Dedmiw++XzDamjUXqwxaIzfsAW50oLFU1vF16k9pgVBFRuSjIIWfPuBqcjfz?=
 =?us-ascii?Q?JuKug3AqRfd7w05kX/QRaoXAt8V83J+TeK3I8pdgCnu/7b1vB/pl6YJrT4v4?=
 =?us-ascii?Q?sLY+nw8yKUGEsDl58IWa7R02EpCCYVI+V2Z8+xNgseb79dNEc5QQufZhSDKK?=
 =?us-ascii?Q?fJnkdDGCW+gRpHam+HnQRQVYypdA0Rcv93nqLwSJrNZaSmhUg3p3spW4J6Z7?=
 =?us-ascii?Q?RRHy9J40psa62PXEX/ar/gw6s5F8mEZUqsyS8PnGwLJ1zi8hWOacHp7UmhpX?=
 =?us-ascii?Q?UZ/Pr6aWVO3ek7LLXRCgRILyWsp/KYvEEviUp1J/RmE1PPuWiTDoFo81Ichc?=
 =?us-ascii?Q?f+tBX1ic+1IUULEGBcAmeKCzd5na1ZFwVY97mTUsnBPzPKA3W1LkdEdesE3w?=
 =?us-ascii?Q?o2qimiJ7H4pk78tZnMSkeXTvlMC9jyuVbHWphVZ5tRcMjNZbxt0YbyfmImWa?=
 =?us-ascii?Q?d1WI4OzCY0HHfHyzPaX2/8pVAc8kvhwfXNyvRY6fhaGAZ3l7oqiNatpegjB4?=
 =?us-ascii?Q?DWZITdyiKGiNQlHb7ADOxtYArZta3w7J5ApXD0y/e83GAX2SCvQqlALRdX2u?=
 =?us-ascii?Q?erzAWZdxOKt1chq9OmM1IrWHYSphKvMykRdRFSkvYoRL1ZFlgad/gLRizfz1?=
 =?us-ascii?Q?32SHJ4uHufm/uKhb52p65ibtg9P8G6onxm58KO7wT4mhjJ3LCGh4hTvHXb6L?=
 =?us-ascii?Q?kFUYesaNzVM+y3Y2emsguFXyDU8deB/w5QV8lAlsAkunnHw0MtJA1ZsNiduK?=
 =?us-ascii?Q?q6Cia6L75IL3SiGeRAYwpE08slOdYx+0OURLr9Mm9w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mxw4R6F5Q67mw4/6NfBgcP3JpHvC30sDi8HxjBXG5Klg/tqu1BjIoq4zzY80?=
 =?us-ascii?Q?sOKA2DYSeq3WCo6AC/1G1nqwwohyj1i4UlMXXkPTVOW6Lpm1kxQifvqKcC43?=
 =?us-ascii?Q?JBa9tDPbseF1FJtU/Qq8/Ht4mQCn5eNn4Y0mxAVoMSdEkVYYfEzYRUbAk/tY?=
 =?us-ascii?Q?w4lto8jXuBN7ztEJgzHaHzquGkizmxF7DpxbjO6ODXdUVmOznwH4ptBz0jYt?=
 =?us-ascii?Q?OGmOvoF59/TTgQr8dqO9NxNHOxQfgPfM7vpf+2f5Zgi9cYzP7KtOAFruKOVy?=
 =?us-ascii?Q?0oo92p0VYglXcmgHjftRQJcR9EBjFy9L/aj0Pi9w68JEJ8M7ka/GM8eIQT6v?=
 =?us-ascii?Q?aIES+DnndVO8qTbsuYn97unL7BnFvmhEVHFBYwVPeojQYjA/DmGLQoo39oXG?=
 =?us-ascii?Q?u4VV8uf+jUENoQat/9cWbHnt8+UAbH6OLjsqdWrwQXiKqzmbwrDSuVnh6FFO?=
 =?us-ascii?Q?6/gYs2/lsJajlI5E6ILxla2ynydKprrHjJtJxz/9wZxFOeOMCP+FnL3uE4R0?=
 =?us-ascii?Q?6SX85vfwGKlR6p01iEM1AP2bqr0beVOdB4iWhtoeRdPuDrQjG9Y+wZMe41kN?=
 =?us-ascii?Q?d/4TKkAWIreYtxvWWqTk6ss9iikgt2qnZ6k+5jdMkqZ7mA03UrNglWQRk00m?=
 =?us-ascii?Q?Ov07Tjd/X2VDbKYxcpjnQQ7nx7bvz1DKzMTavFma2FOy46vijRRXLVqBOC1j?=
 =?us-ascii?Q?gwhrj0iVZac03mrwllJuPS7AVbCGRSdxL7Pop9DCJW0y3jeVPgFZyaMRp6tJ?=
 =?us-ascii?Q?rcp0ojosX+N0hHL9QNMSpKt+VpEfGExZKnyw29lBeujysRPUsQ/SA6B8Ao8u?=
 =?us-ascii?Q?ECWo/iBx5Vs5Cs3hO9MbKtgi8XcH7/D4bhzDQztr58dEfeF3TZ0b7bB8U8xb?=
 =?us-ascii?Q?WyVwp7vq+BpSHuLSqBr0XAVmeiQRExCa0OVMlygtsdEbJU/gq8dvxjvF8aMM?=
 =?us-ascii?Q?qbaYnFSwOPRZLLymZc0ZwLxTJuV3UJh3s1EfjgGFACXdyNpzNawcfcYLKbGq?=
 =?us-ascii?Q?gv94D3o2hPLOq0n1tLv5MaCEKGpBPwGmYbMA9ifjc+PLfAJ9GDGJoH1RS5OD?=
 =?us-ascii?Q?pC6I88PBZEVIwG1StVji9lsPkftfIyeA2QoP2J+fQ4riP4j6jUHiNf5dUaiM?=
 =?us-ascii?Q?KZYHsRzs/VtnhWxfgSktkK8l305O3zgLzXQcVHqB1LKFAJ/PcFAAKkc1DvvV?=
 =?us-ascii?Q?xTs4p0s5oiJZfzIWhpteqeEx7BPYHpzVNCUWNjYBi7zxancIjSpr+d23p6i7?=
 =?us-ascii?Q?2MDEtBcK9N4zvKLTCnIQ9zFp4sa7F+ndI1vJxavmOUFuccPeIRFijludkIm+?=
 =?us-ascii?Q?4XAyU5HZxww37Pp+2TRJG7ggP+kgR62WhZObReG0Dan5LOS9gq/yzSiNh0gP?=
 =?us-ascii?Q?bHOraN9DUovV/kHzzAjg9JuALlqSdAlSdSeMlwJXFPUQ965eNU7jGlnycmXi?=
 =?us-ascii?Q?zl62Zvsry4u4eR3Sn0XPRFiqbAj0cqZzJTHDLPFbIkmOrUs7wQAQQHwCBI+J?=
 =?us-ascii?Q?kpEKergjzeCDjMq9r/goi/fFGixXN1uvcTSJduIZrtMMTuuXxlIafMOrdK1V?=
 =?us-ascii?Q?Dp8NC9LnPdKMvEYM1CNuFN31/rP3noocY52m17FcrwIzz4tXNnsi93RNth8i?=
 =?us-ascii?Q?Iw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef87b35-bc98-49d4-a01e-08dc6f4892c6
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 10:21:07.2303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O7tHriXkRw82xk73FgAIhTtKQyW9t8G0lOgku878gYTQiC33wrxmpey+y54CX++rLwp5hFGewB8bIMTodo5wCUlYJHHk1EflRNgyJz9XNww=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR05MB11537

Hi,

I am using nftables with geoip sets.
When I have larger sets in my ruleset and I want to atomically update the entire ruleset, I start with
destroy table inet filter and then continue with my new ruleset.

When the sets are larger I now always get an error:
./main.nft:13:1-26: Error: Could not process rule: Cannot allocate memory
destroy table inet filter
^^^^^^^^^^^^^^^^^^^^^^^^^^

along with the kernel message
percpu: allocation failed, size=16 align=8 atomic=1, atomic alloc failed, no space left

This also happens when I use delete instead of destroy.

This seems to be an issue with allocating atomic memory in the netfilter kernel code.
Does anyone have a hint what is going on and how to debug it or maybe a suggestion
for a patch?

Best and thanks
Sven

