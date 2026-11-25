Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795605611;
	b=euGJutsfH+MqEGl7eHSl4tDo92XhedojNFo+8JeFX5xz0sqlAM+E22qnL3bxl93cygvF
	 oC0C28igpa/I+zX4ZbNMgzJueysSLmZgzuybaJjN8Vw8LWPsgnYOssQrtYWrtDUVsgVB2
	 3KN+O+wbVlnUOBBW+VK2qJz3n8/udfkFyDZhpd90fIxvgD/8YuGqcZqm/ei2eEEaauPNn
	 W5WVXESv1/b4wjFBPLjE2dCo8wNoC3GUKfDLIory8a3atgLyq3o8XPTA8SVRfJIrRq64x
	 XtWtpH9KCXWHRwKRQurPLkBM8NhnVJUq8HmK3uTzmHaPQE71/kfaNQiOn4bPyCQx3BQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795605611;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=aoN3ZanzClKl98wNrtRw/d/oJc+Dwok65MLCYYFE88I=;
	b=nZomB9SyGMl3pGerHrDzq7tOKIzEiyVlBzq2D4oRpf3MqedxSOR6QySYEYn+HveNTNMf
	 lkVF6YbNId6soGvLisH6dGqCaX113LDelAIypgydhbMsqDWte79e+E9S7UKSm1rQnUGVo
	 zPnNE3nsGb4wsPVo29gOudDn0EXjxkj0vNcQMulSWYhQE7qdzmhf/yMgNsch7aKeJTIA8
	 7ph2m4WdxaCcy011lup2GOBWtYldhAzjVPs2iKyU+cmCPawsg2XMwarS6y5VslG2m7WRY
	 rBLuiBm0u64elVNtjB92a/yJpmf7/7vMPr7xlmoGA7Vp+FdD30BObLEMj/hmuzKdJog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Rk4cf7Bj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.16
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012016.outbound.protection.outlook.com [52.101.48.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872A7606A31E;
	Wed, 25 Nov 2026 11:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 872A7606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Rk4cf7Bj
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bmRAAjm8emQjQ2RhH7WoAePcj72gvSvz5HWoEHGSTQMqUOGFrawhonjlneUP1h+e+MDX9R7Fq237K6s4rdNemQDszxD6h4SBBQ72mF1cP4Kdwn185FxSPakk1/jItaQmtF4Y1wF3zj38JsQm/2z/eSHz3PM/MUGmfYbPZwShHy89JKqWtHvix1LlgwRsk6Gm0BEp178CoqB91hJAwZlfkPC9fe8Ypqhn/1IdS5FyV9TSA6muVxKwK2G8TOez0bbul8iAY29hv6YlpIyxIErVDG1Nv12RGzEvKJFmH/jvt4hXEt+yfX/DT0uZ/yBVWV9HAVua7Ddsdc8/c8tgsB2+Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoN3ZanzClKl98wNrtRw/d/oJc+Dwok65MLCYYFE88I=;
 b=vsaOug+OT8pMMWsQmJdYPfwWtP8wfi6yct5S2AI2sG5Con1vkw4r+wVFIzq0d1rNrQooP3B2kwD+IW4XBScMy8IiP/9xB2b4PbThW2IpaoM4QWrOK7yDf0xHHpDoreofceHUxsgLq13yRdxItw7nei4W1jpNQhyKM2t2Z+m4zEb8Fpv3Xojg7+AkepqD196zb95KaLZG7WcqrtJMoxUwIZJ8YpDrdwH/F7x1KfvudymZTPc3gDQUFcSq5AMf6g0uzLjrY7gyeaLJLr/eG/2C0Y6FPaBIzwEO7rCSVBnFLaxYh9e75MjYkpZ4RaM3EfzSljP8ZvwK7gThFY6b65931w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoN3ZanzClKl98wNrtRw/d/oJc+Dwok65MLCYYFE88I=;
 b=Rk4cf7Bjqr5eseaWo3gknXRBGjBvMKk943ut5frTNOIyKGgeFkS9yETYiv7F+x03YLHQd8XReWTmLELuTj2l+ct+v4n4F7YbMwS3ejSv6kgux/fHpuvfFCEjlEhOx9AkZqsbcIuONJxRp7lD7lqa9tlRJ8EwzkEiI6GGg5dudXqSjn2iXPc30zVUCa0G9E5yIOjzq1wux6LtTDQMEBIQ8wDHy3902rsV/BgqENmFy3LcuVv0PxuOqfXXF8I+Y+b032O698Ylxh1PuqpujmePFrJaA0B/CVinqm5g7mtCDrijVMEG8bUzrDXKqGBRqzd9fiSizZ4wjLQV6560EBLuZg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by SN7PR12MB7881.namprd12.prod.outlook.com (2603:10b6:806:34a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Wed, 25 Nov
 2026 11:20:05 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0662.001; Wed, 25 Nov 2026
 11:20:05 +0000
Date: Wed, 25 Nov 2026 13:19:57 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Leonard Lausen <leonard@lausen.nl>, kuba@kernel.org,
	netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>, Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
Message-ID: <20261125111957.GA127174@shredder>
References: <20261117110813.9894-2-leonard@lausen.nl>
 <20261124162628.GA3992049@shredder>
 <3e2585ec-00dc-4884-84be-51162a4d782a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e2585ec-00dc-4884-84be-51162a4d782a@redhat.com>
X-ClientProxiedBy: TL2P290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::19) To LV8PR12MB9407.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|SN7PR12MB7881:EE_
X-MS-Office365-Filtering-Correlation-Id: a25d1eae-76c8-4628-9291-08df4ae60e7a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|22082099003|18002099003|4143699003|56012099006|11063799006|261022105027099003|261022075727099003|261028144727099003|261026121527099003|261026140227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	jZt5PkI+vqaKVh/LkRbMGzLxAPBtPz4R54TeD8bDBjIQ/kRJRaNW2kEORRSLJYJ/1aW93cJtMh3EyCnBzkZ0m5Pe7XvDS/AORDc9YRcj3CJTZtLZQUKzWVc0hlLVKj/agv8y65mrrTdpNiPrdOQAipnj72aAAfg3ZwRxElkwpzPlFmqUhIYhY7jJMDZS2dKaDnF3ODNlxx9cKrKl4g9ogQ26TquCPH5gyOYAvbWQfTPA8g/zggdDt2srbssUstviDQfO53xx0rylkF4JZLc8rKH2cwGK3Gkt6x6ufT4HfAcJjOvtpOzRrvOChi06kucxvg/cpX0ouQbgFHsO8shvclK0KH9xRN9NTQtu/2hFfbnNFWh1GnsgAvFBFq8wqVEWjglYpmqPmU0KxfpXFnRC+SrLC4ZQ847aJ2qghZjacPpq84zU+3dYhZDg4SzLe1CN004Ua3Xhq3GKz5nTYpqfY3fNmCVnKL+AWrKrOQ1YgcTsphzBNBcNuwE/0E33lsZ4f+nSr3XpP7y2Vhcn7oPabeK2b+r9rpKv95LMvU99996i5TIlOOw0p0ygdyiR2uzeIinmic4dqrGL834pyKMOdqDGbTy2MWlw8BZ73VbLnOg5GUWHiB/K7/IsDi45cHc/IXiWGrFkQugKBlzhucZ91qvVjL0DdJ7xJza2Wiprypo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006)(261022105027099003)(261022075727099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rHnQZ2pHJ6DxBna/PFNCRWORBAcQtE9jZFDse++TqzInkeSkO8nIZ7lFpjGG?=
 =?us-ascii?Q?pC6xjYL/gLUCd10KhrybpT618akeVTtmWPKkMKUHa7FslgDoofhfulL9gmhJ?=
 =?us-ascii?Q?MazUsQfa0vmkai9HBXjynsHu7LwN2uiMP0cLYo74sNK1TcJQ3Q/k3BqgtW6+?=
 =?us-ascii?Q?ZheFrk2KH74bVmGcoP9iylcBpn4pb5o7rR7zTnNkNDGyf4ia+djC2VioWOuG?=
 =?us-ascii?Q?XctpcicV+5RRXpSR8R6iu8JESCAi4FZOSy8jn36dxoR6kRab34ia+iE1fkuG?=
 =?us-ascii?Q?bTKTgF/4WdWBBKX3W4E7EmhNelM5AGt2XQZj8YnFNhuWc9vRojUDyxtf6KFK?=
 =?us-ascii?Q?jhafWENQCnDsSmnChBIZNQ4Hbz5+gLJXntr/jNGyMGcYY22N0GiTpga1kM0b?=
 =?us-ascii?Q?Bz/ElQrtKzMcDkFciZA2Eg9JAutqif5i2BzYe+hELic3Y6eXRlTemr9QU3oy?=
 =?us-ascii?Q?Zhe3qwL4mNsJrMVje0ph8kNckugS2tDWaudviAC8JoRXcmjOatP0cMYLrk21?=
 =?us-ascii?Q?0pLV3nIZ5qycPl3gb3YOSTeIabvUy8V41ethiwCJ/wWgy2MeGO7F7OYl9eyQ?=
 =?us-ascii?Q?DRTtES1YmuNaELzWVkXMyVjhn7UituQ6NmhQiNeEHmL5IlyKpx1wI13TeH0h?=
 =?us-ascii?Q?navHRdmsGHqBTB1fWQcDe3231RSzoWGTG30UabU/MgvRcliSkTT2TFdN/4rx?=
 =?us-ascii?Q?9Yd55D+bYoS6Sb6NwXpqkrFLyE8EeEShR/zdD0hGRPumaGWeTAF3tdVSgqJQ?=
 =?us-ascii?Q?e4DQmxaOnrr0LOa9Kin1b+7vxsNC4xqk7CY5oMbNp2gI0VQtOuaKj+hXy/eV?=
 =?us-ascii?Q?UIa+QSkR7XmTmaaI02GF7CjENvVo9FAoz1pIuWw1Ef/WTnACzXquxEuQHymr?=
 =?us-ascii?Q?Kvwpsz9wNK2+Gn6YO5AKHX+WWjZRnZvD6x6UEdrw6KIWIT7m79L6aFNWeBSZ?=
 =?us-ascii?Q?ClhlybIPr+SCbVp0cxGyIFM6Gw7W5Wf+8w0Uephe0CFZlfYiqIP5Jjkit79r?=
 =?us-ascii?Q?R8hl5jeW+xBlQvd+jFDeWe6RHc0GiXbhn475Tmnb6ydvLJxUDbnBE/pFKGYA?=
 =?us-ascii?Q?3WPVWhKgwI/keqU04Y/h74ZS+0AuRQGnxWSIZlIayA4VDbB46t+i1eeVYFf6?=
 =?us-ascii?Q?SIJs6FPpgQf6hdjUiyxt7UYUydznFSSUrkfFk0ce3AewEPHC/e0UI1Wvuqsz?=
 =?us-ascii?Q?jJ3dXPQ6YEoZwviDmDK8T82IZOHGcpQnHixgUQECtlaOzZmnoCU1SYcKymra?=
 =?us-ascii?Q?cQ8Ga480PQvCUGJcrt/Ab7uwdDPsnyv5mw4Gm4qHJfhb7QOFauNSnF4jLisH?=
 =?us-ascii?Q?U62HDBRSIPrDdYLBKcsLB9nytCmYttnTW+0hXZ7TIPQ+x5oL16fOGTPEx4ZH?=
 =?us-ascii?Q?QM6LA1O5mpvnZ05Aalm0Ztt0Amci0fpTKmDOkKirkCx0y++IqOW5NZ8izOzj?=
 =?us-ascii?Q?wozvaCWb48wRRE0a9qm5psfRQO38XQizk7izuyJFtwMNRKFvAHEuaQ8TOnHP?=
 =?us-ascii?Q?57YrYkql520fpdmmprV4HgECVPHWJFNMISimoMFhkUEX6URui/hYuZoQKrOM?=
 =?us-ascii?Q?Tcnb+pHnDzXUoWL5PVvf7eHqafRsL9uFn2QGITy3pi+FAcmrPsCnBezkloFs?=
 =?us-ascii?Q?87yyLzojv/HVJj0BMJvqPTI3ABrTW6VwTU/3aeY1fkUiDt67O8kPWKZStSB4?=
 =?us-ascii?Q?yioaMbiTF2mLUWaXKf0TsLlR4Bl/W33J5IyTFXvUSVamqPzR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25d1eae-76c8-4628-9291-08df4ae60e7a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 11:20:05.8157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ITa3fC2SMJhNA4KnxxTqwUtYEaynhfyfweqEXebp26rN7xtgpoEs3P4MqmMqYFMvjt3eKwMeVppgLwEtrt9Amg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7881

On Wed, Nov 25, 2026 at 10:47:17AM +0100, Paolo Abeni wrote:
> On 11/24/26 17:26, Ido Schimmel wrote:
> > On Tue, Nov 17, 2026 at 11:08:10AM +0000, Leonard Lausen wrote:
> > > This revision removes the cached-exception patch and its PMTU test, as
> > > requested. The series fixes the nftables regression introduced by
> > > 1c32b24c234b and leaves dst-based prefix suppression unchanged. The
> > > cached-exception work is deferred to net-next after the fib6_lookup()
> > > fix is present there. Interface-group suppression also remains deferred.
> > > 
> > > Patch 1 makes fib6_lookup() honor suppress_prefixlength while preserving
> > > terminal reject results, including blackhole nexthop objects. Patch 2
> > > adds six checks to nft_fib.sh using its existing fixture.
> > 
> > Paolo / Jakub, do you know why this is marked as "Rejected" in
> > patchwork? What changes are requested?
> Thanks for the head-up.
> 
> I think Jakub changed the state, I'm unsure why. I'll re-evaluate
> this series ASAP (nowadays can't be very soon).

Sure, no rush, just wanted to make sure the patch doesn't fall between
the cracks.

Thanks!
