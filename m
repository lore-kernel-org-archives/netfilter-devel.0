Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.16
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794906834;
	b=PJT15iuuZq5U6xzl5EKf/CNfZ8wNLzAw9m7zqwJrlILsTrIB+OnJIoZ9JSnffiFKnK7m
	 5habFx+lfpKFAfQv+WScZ0YCcMXu/tDrP5Tml8CLZ2Ojv6iuhazrGGFOesUiWpZsuAGRa
	 8vrAblK6Roc9ok9vAzcEjQFeHIMd+6SY1b767ch9QqvSttJVoZFMBE2W6hH1Hd+wTt5PF
	 rNyMFN9TgzQxP0/gILBmpW4SyTI6v5ePM61P1r6nDMTo1ch2jHxKHwhTSWcjmifXH/F5O
	 /T4DH42TCQ4kOjN8cSiAkFzPXybuXhRXHde5wKMr7RN5MHD7hrghr3cFp9Y2GBz5big==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794906834;
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
	bh=dGxv60QBd42xTtPfK0bOripWCAeT+bdZiC3TzkgL9Sc=;
	b=Zk/TfHmsBRyRXANHxf8q2MsopW6xrvO2FWTzgmFNRosVBKj8uHh+8xT0NdkSKcVpAQ11
	 o4M6dpgpgdMBcIA6MYAZdiaXidEExPHTvewLKihRKRr+OUAcDWbqN1/mN6PLlgJZoNBI1
	 aDyhAZzk2jA3vops4cVUDoWr3O2x+WQYr8rY4YdfkGpdFJIfjqc5bjRd4VVCPyq5N0qPz
	 J+GMgvsCSBIN0iY7lFnEDV81chC7RJGa4riOmiXRjV1MXeEKqVA9xyWMdLH2pS6r7AlGT
	 0QEUu9QU9JlS25PohYxAigt/BEKsDScU619fPS6BSC5vb7yO1Tna6c7EIZbf4ezIHwg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=am7vjWBq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.16
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010016.outbound.protection.outlook.com [52.101.85.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D06606A32A;
	Tue, 17 Nov 2026 09:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5D06606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=am7vjWBq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gw8oZwXO09cNH2X2RGuB6sEJ+X/QmMiNHtGeFy7HUYRZD8UjE1XA5iUeBEbESXGWAq7jaqEQ9vqlVSC8DI8Mmpz/AFbuJxtQhGShoUYDp8oFaS4Xt1z4VtyzEMfWVWrzucgNIngKLYx7DlBN1a1XPFOhvPNeELKfllvF9JM73G+46gO7S5AHdSAxpIsShRTVXJcE9WIyMTsPNoiIoVTfh1EU/bHwqmE8jdIUY/pkCyO5gv1MDX7G441jfTuUO8+zwK5u3kjpo96JHsOuoYbK6+Lx5rvjQiN07xD8vjTXNDPeTfEAzlnPdQwLk96mr4EO5Ezsak8PLR4yQ6i0ATTpaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGxv60QBd42xTtPfK0bOripWCAeT+bdZiC3TzkgL9Sc=;
 b=jC8Cx2/vLFZZGp18ybsP4EEg4ZFAE8SrtA1gSeKDKQqY6ve15uwyg/odQtfRdNudhdL3MsFjP/zebztn8au55h6STLS32sKogyMVbFZe6wXBr25eWXpUbX2nN2yYnt+mtemBEhdFvTQ/dcQM2DdSL8rGZ3jogsUi4dVzCnbnU22pHlOSG0IbRQPZ2wg/I1hVXERDd3xRWGptzf0D5618SM7yF32BPerB0M6fj0PNRTAzWvCSotG1xcPGXernNLFenM2NpFL85hB++NeB3ir4UI/kJinom3rRlQ5mLuU6gXDIswHS9WTs03WFGt9ANDIbZgONtkFFL2t8a8XZW0Iq8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGxv60QBd42xTtPfK0bOripWCAeT+bdZiC3TzkgL9Sc=;
 b=am7vjWBqLZ3ejKl8sf/C50buxonxxq/0ygYVkKdNxGVCT5J9FXcWCyY9Ux0U36jPVsxwqzil24j1BNE0SNonVGmL7uOd1vDELVA/e2CTtMNN87VT/0wIt55GbR8nIr2koppyYvUdkCRdv1euFKM8k/27+IhBexNHBXuKjJPdHdWG50YZ/t0PDDCyt93tTqrR5Jw4Vm4xbUXy0lSMk8iNWn0LLH2ZhsBQrsFo5gBX7gM7ZhywGHOQFytVViqhyW1//VnX2/HF/IY7NIBdQIoGIDjdGmFij2XQo4iGZRLRBCUnTlfAV9Uyj+nsty9sxlGgzuylSxlFCI6ZTNA4kxEiBg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9407.namprd12.prod.outlook.com (2603:10b6:408:1f9::13)
 by LV1PR12MB484207.namprd12.prod.outlook.com (2603:10b6:408:512::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Tue, 17 Nov
 2026 09:13:50 +0000
Received: from LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96]) by LV8PR12MB9407.namprd12.prod.outlook.com
 ([fe80::208b:424e:47e9:8a96%4]) with mapi id 15.21.0615.009; Tue, 17 Nov 2026
 09:13:49 +0000
Date: Tue, 17 Nov 2026 11:13:40 +0200
From: Ido Schimmel <idosch@nvidia.com>
To: Leonard Lausen <leonard@lausen.nl>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 0/3] ipv6: Honor prefix suppression for FIB
 lookups and cached routes
Message-ID: <20261117091340.GA581197@shredder>
References: <20261116150132.9594-1-leonard@lausen.nl>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116150132.9594-1-leonard@lausen.nl>
X-ClientProxiedBy: TL2P290CA0002.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::12) To LV8PR12MB9407.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: LV8PR12MB9407:EE_|LV1PR12MB484207:EE_
X-MS-Office365-Filtering-Correlation-Id: 821d1b9f-64a8-4744-f8a5-08df448b1789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261022105027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	/Zx3en2jDr0xU8He14FXt/tvr0amPGI1vlFa7GOHpVdX3k0paiasTxr53IvDGzIhPh7ai2jKebQWq+Vl/HCwuuDbu5o0QkOAdxCIj0ikZ1+lTBoK8j8dgl+1ugcv45DdfIgmwZQ+vBgEt8ltayHrQlpj0dpblTy5rgiNuYyyrrM2OZn8hA99pgIvfKrJqQWcY584JavCBtel5MGCNWkOXH2a6EPbvGx4BbWAoDi9M2UcUXvy4reLGdW6Ry2DCkpVtlarXTx5W3TOUD0pnIeZgkjXOi2NgNk36Adj7R7hxQKPE9su4pbK7dra62mOeXFq5wzzdTapgsMNtcSRxov/vWjuR46RN946BAgeflPfuzFi44R0WifvKwqmmKziDsQ4hlEUCFvPHP9b0Jfk2ZGOy213ZyELRw8gqtdito52hnuz6vVqC7127U7yDYb5eHwY+WrbNZ4/fojMmyWEUe07C/Y8uzxW1JCG9hodPhELsPMY8EGhKIwbMEZ03nxfhazXvrCCVCjZdiWec9ttI8zuJFU5k3vpd41eXTVt+aZso1mX0MUyTGSnx7rAeru+dna/C2xUuItqt26IS0HNTk6WL3gKHUhmnhhX9wcyh2e6kZqoor3/7YsxfDmynXP75lIt+QF/LO8QzTFs+R/gJiFb03iqx5ZCpLmTzbII/CTdGVs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9407.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261022105027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OCHYypnLCHi568CXKYgNIGzkoAaz7iJcORDHymuSP7yHW4GqdSPyQIDYRjeL?=
 =?us-ascii?Q?XMT6ZXBaxRoDvHq1lZJa/5SwxE45Br7xon7Mt2zQTCv+BW3pcW5HhdWE7XIo?=
 =?us-ascii?Q?gjXtXf4w0X/azlmXAvynaswlwNmgTM1IjQUFnr6LAhitquP0hdise/FCwIAe?=
 =?us-ascii?Q?SDqsCxOj0nm+nwlOOFFdXC8ab9U99C1l0ylWvDX3jecuwU5ZbnkdoGBP+kV/?=
 =?us-ascii?Q?9fXKKztbIu94KrcyHkkhQ0+M7LB6u2wES8kbpTYCRoQM6SVIKTqqmYIc6aUi?=
 =?us-ascii?Q?vqp01SdOSxs6F49B67PKY5xFpli6TocUpeRxXi7MWlVGieg2ukpkVq0naZTL?=
 =?us-ascii?Q?vhi5uWYpFYbkN6xjVyK663JBYsWXW4ujoAEzpYviwCuEhGju0cfT9X1JzM/G?=
 =?us-ascii?Q?vNKee73rhVnyppdZSTtUx4LU+JV7jlqNrCwo/CYVzFwQ8PGu0RhJwhLZzJKe?=
 =?us-ascii?Q?NTsjWsdv9JR8Tf7UB9WbfqrHhkfP4OXlNNXq93FsZ3RvC1yP+0GJMC+OAyzU?=
 =?us-ascii?Q?FWrvMBZsDjok+2OXpB1XsYLyk5AuHHfqgD0VIfzftrQ2dEKcz8+bf84ZHYFF?=
 =?us-ascii?Q?WFA9WZ8OS72eGBXFM77yNHW6hT7e0sZOamwlCJ1KMKJ16t6tPYbSwukvJuRF?=
 =?us-ascii?Q?U1qeF7feiS2AJzwMhhJcg7MKBg6HMij1nfzFaK2RdkwoeZH0dYbS+E8MfKmk?=
 =?us-ascii?Q?h9sgFoVqs93MivZNsbupW3CyY2NTmmrjOTocVO1wLEYLVaLGmOed+PTK7qnp?=
 =?us-ascii?Q?ADFXHZMUzAQ3g5/6QBbxnuDFhhm1ulKzUumefRwweMKLhp0ujqFea6+eX/Iq?=
 =?us-ascii?Q?3ezQJPnejUQ1eNCUcYexXksHi19E2tF5JoFQXACANH+W7+teyYqJ59WfsZJ2?=
 =?us-ascii?Q?xeq6LBdI+2+2hLNTzn9a2AlACKL5qgZNV16CPaTAyn0QC9pJEet1GYuIW2nA?=
 =?us-ascii?Q?yTcduAhb3/TNFwPE0jzo94BaQl3xpc53EpUf5L7Q9MhmqCrnKJcgZ2rjJoUp?=
 =?us-ascii?Q?kOxm7z0c3lcnmPfiVeExMpKF6vDZCWMS5aQAn+Stp/+oHBuEb4RTpVRz2rlH?=
 =?us-ascii?Q?f/EBDzyipPN4hk2fXm38bDXg/NSgHZrVPTdbsnSDF6KQlMp/ni74PA6448Dh?=
 =?us-ascii?Q?1GCzTeYegP6ei1C9BH0kAJ4eYti3HZYr3XHeaL94ZXlw328UbD9n36dg0LK+?=
 =?us-ascii?Q?T60IqbDPLwtk0yRPiFA6W1SktihV6C/gGjyloopAnowti2e/9EuiX8JoloeR?=
 =?us-ascii?Q?yYYmvg7MWMIpKVNXwNsCTeU7F0mFsgxJeUsCCZPniPxfeDMd5nwbZ35snsvF?=
 =?us-ascii?Q?iRpMei5dw4OnKPob5wnXmhb9mggkEIOACIYMgCTsqdr/yv3yNXlOb1EUZxaZ?=
 =?us-ascii?Q?qFBa5czOECP6ddsoCE2gufTOVle/GQ+yBBm6pX9cM/pEcnQrlPMyZmUkgdSE?=
 =?us-ascii?Q?JI2vqBjE7pid57WSNiM/7Nw7XAZGH5jwgz0Owd1tdwXu6nREqwxRqNLzPIGu?=
 =?us-ascii?Q?HkJKUA8pyecGZk04EG77J0GmHjXY4m2IMXl8sHOET1JlmQL84oK8ZPZ3CFss?=
 =?us-ascii?Q?mIBvsMp3q3v4r3fPViZhvkFSbxmZyC9l8uorhXwDvyGIlzJdKAeL3LyDoExY?=
 =?us-ascii?Q?LTzxwdlRmP90lXl4C7WME+OcF9ZyX2EGxkQHXCjA0FBRaiLnkol2ALfUVKtj?=
 =?us-ascii?Q?1fT+Nuc/r6K2CD2eLjJMXRWvLws7+6rTkHhploCpPvMLjmJi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821d1b9f-64a8-4744-f8a5-08df448b1789
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9407.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2026 09:13:49.9138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HRUajHCHZNJD5UD2Q7nwrQeNHwvLSVJFr0ll2bB8iqHEmm6yt7wcZ9f7D6qPtZmz6JDpJf+RLS2bCf2nk98NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR12MB484207

On Mon, Nov 16, 2026 at 03:01:27PM +0000, Leonard Lausen wrote:
> Changes since v2:
> - Add the separate cached-exception fix and PMTU regression case.

Why?

I said (twice) that I will take care of it. It's not net material
(always broken) and should be routed via net-next. Please send v4
without the exception "fix" and the related test case.

Given you already have a patch for this, send it to net-next *after* the
fix is present there.
