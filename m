Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658C518D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 01:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727139826; cv=fail; b=tFHfJRZc0r6dRDuFJK7zi0mz7Ts4whwu8Fh0UAX8NZS6cnlbD57iktdABYKAipbmU2Jpde/nn/m7JSZy8rUDxeW09BbrE/C9fTSMayLjgkqF97l53mfR6EKsE7am9UHmuHs+wsSaEAxVEq4fw0KFo7xQvJhYPlupXw6RyGVt9Wg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727139826; c=relaxed/simple;
	bh=uNeqAHvl53yGYDs7i1g9YnGjkfHnrMmeCDE3bVT4s58=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=s/CcUdUHCOVbILCFzsL6TCh1lOnxi9vzrdjO4+hN7mrbLrGRaVnUmwbHmGDbN209l5D6z7mlZkK9vFWiIqonrDHuBZ2RbbN8ksyvxJv1yj96UC344VsDctz27aaALF3lWbwh2rbE6a7JQD1WRAdzryocQsbAB22KwkMlK0uSM0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ew+aiIpf; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ew+aiIpf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfUmKnVI6HKGd07tXeFtKUhvcFUYMqrRmGazVuSF4ycqjMINP05qKwjhY9yMqbrSrztY+1TJXy5ZK5pLvF9Kim+KkCiWg9O08laAmmh3STw3sbjVdeUxDRzfSmpKm+MqC+Ni5XosikbDxWoWaPzKMh3uwSLirPgVY1x3P9kG7ngMxxCBBtLGSOWsKIjtE7VdbO93VxMg4XvnvNqIVnHqcRvgebOZP9rT+tEbST5+WzGkmzs16puuWAJmcVvYOOgdoPXRPtJmajtNNiBbfxT0OgRCAqjTgIUfW16P/WOA2mXlk3GWBbyPkrs44v5e3iXRal3H/ZMu7Ek5HBKTSFsCFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MRFt6ToUGg0OIMxk80BenqspqW0pt8fN7rHqczUfkbA=;
 b=wy4M6q/lxu1tKW6P5MfN7cWgEQssF41yC3qwVErNkMtQuh4o45rACEytLolpH6Um6JCu1OhTnSsSoUwU4OK0mLoA+mru2n9m1F5msYLF5MrciC9pt2bS+b6IpBgxLyhMUPYa7eKUO1GW6y5zPcQWUHrbDlaDYFZgUeMc/OudIPFoAyQ9tdv7G5mHhIuLzJ5FQSOk7I0R0Ia4owcY8L5hRfnWbT7BIOMpQL6R2Ju6py298YRG5t1wtx5uG5KnC7CYzeMr7sZhKPqBo/SDvSO5+G1Ik+Acs2YCuNrs6i7CWqCANNtM7+ChrXIOt8C4Eb0IOFUC1duQ6so7dEwNIu1Hhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MRFt6ToUGg0OIMxk80BenqspqW0pt8fN7rHqczUfkbA=;
 b=ew+aiIpfbu15iZ3MTLyHST/4PZ6PmgpURj764jnYOf+eQrVkTzPkFlmd0nOZljQcIk9KG1977j3h90KYR3v5VLoZIvAHLLacam+WtqjWj3koYJHBq99FxMY28tHEc5mGjWrUBHKLz0gIxKCjj+fdU2YD1zfK1gPqWiv/0mf8AK1LIYQqTn5JYWtapMQDnAyzjSb4U2pw8mWw2ir2lplmMbu4PLhu39RWJs/oKhvjrfve86mYpN+G/JtmNoxeEAYElk6WmRXZmnNs+dkcYNJRKXYcZyYes9g09oK1KDK+hbySn0MsVc+oC6l3bxcHai9AIsa44j/1r2dtMRqy18XOZA==
Received: from SJ0P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:41b::8)
 by PH8PR12MB7445.namprd12.prod.outlook.com (2603:10b6:510:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Tue, 24 Sep
 2024 01:03:40 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:41b:cafe::7) by SJ0P220CA0021.outlook.office365.com
 (2603:10b6:a03:41b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.26 via Frontend
 Transport; Tue, 24 Sep 2024 01:03:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.15 via Frontend Transport; Tue, 24 Sep 2024 01:03:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 18:03:28 -0700
Received: from [10.19.211.37] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 18:03:26 -0700
Message-ID: <e12cd5f8-574c-4405-9e92-c1fac54053c6@nvidia.com>
Date: Tue, 24 Sep 2024 09:03:25 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ct hardware offload ignores RST packet
To: Florian Westphal <fw@strlen.de>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Ali Abdallah <aabdallah@suse.de>,
	<netfilter-devel@vger.kernel.org>
References: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
 <20240923100346.GA27491@breakpoint.cc>
 <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
 <20240923165115.GA9034@breakpoint.cc>
Content-Language: en-US
From: Chris Mi <cmi@nvidia.com>
In-Reply-To: <20240923165115.GA9034@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|PH8PR12MB7445:EE_
X-MS-Office365-Filtering-Correlation-Id: d6dd896a-6e17-46ab-cf5e-08dcdc34ba5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0NVcmx5eWZQS2wwbVYraFVrbThYajBOSXMvQnlSN0dZS2JrZ0U1ZXBqZVU1?=
 =?utf-8?B?ZTJxcjJ4RkNsOFU3TVJEeVl1ZVV4R3ZkcnAvSDdwVkh0OTBtZ1pHdkoxUHhP?=
 =?utf-8?B?Y0daSklTL2JVZDRXZkw2UjdIWUx1MStLakphSE9xTXBCS0I1MHBRR0puaWtk?=
 =?utf-8?B?Qng1R3JNR01pbTR0QkZmZTdMOVdCem9nWlVLSnZjVjdyNXpscTdOMi9rSExT?=
 =?utf-8?B?NEpuTVI4S2VjQ2RYbmUvN1Z3bDQ3cFZTVXorR2g4eEFub2xVcjJ2RTNhT0ZS?=
 =?utf-8?B?aU5VTERiVFhlM21PVnNjTXV6WkNQdzJzRVRobTJjZVZsTmQ3azkweWlLNi8z?=
 =?utf-8?B?UGhvSm1WT2RJeDR2WHo4SFFtVHoxMVlrd0sxLzgvejRrT0drVm5CV1NTVll1?=
 =?utf-8?B?SG1MbnhJSlBPc294U041V1JOS1NVZVlUOVZPR214R1JzT214d1ZITXM0dUxB?=
 =?utf-8?B?cVU2UHVlQnZMNy82RTd0MlNYTHJCeWlibXJHVUhjbWZKUStrMHl5TmQySVlp?=
 =?utf-8?B?eWVnSjNXR21EdHlLYjd0cXBxMFpQckdhT0xoa2d4WDE3YUkrUGdyazhjOWlJ?=
 =?utf-8?B?VkttYTFWMEpMMy9QVko3NDR1Sis4bHlma0tYTFljMnFuRGFZa1UxT1V2Y0Jj?=
 =?utf-8?B?N2RWNEJJTTRKM3ZxZnNZa1V6YUdodGc4d2paeExoRW55c2F1SEl3eTVWY3FF?=
 =?utf-8?B?TmJOUzN3ZUJ4WTdXeXl1QVhiNWVZVWZQZm01TDRucmI1YTU1VEh1dHlOZ3Fs?=
 =?utf-8?B?aUhodURXT0tCWElBMnNjK0ZmbXFORG1vOVpnUW52cHV0Z0VHdG5PdVA4Sk92?=
 =?utf-8?B?M0g2blBZT0prWG1PS1lXU2lhMjk4a1BvdUVVOGdyTTAwUzVjOWdOT3FMMEIy?=
 =?utf-8?B?WkZ0aWJVT3RlbU9QT1RRWlRTL2dKK0tPVmlvbWs1b0Frekpuck5tZE5FL1hT?=
 =?utf-8?B?bXQ2Q205VTNLcmtyc29hbGl2RjExMWZsNnFWa1lTcjE2b3FNUENwRE1HVUJY?=
 =?utf-8?B?N1pFeXFRblVadWpLT29VcHdBRW1TaCtXZHUyc2p0V3E0M3pIeHUyQVJQR0pl?=
 =?utf-8?B?aXBVSlpQYzFmSC9iTDhrQ2Z2TEVMMThtanliNnd4TFRUN2Z2Zis1RkhsYXdO?=
 =?utf-8?B?NlVMcnF6NXlXY2FkT2Q5VFRkaUF1VnJaOE9uT0tNVVNwbk1HaXIyS0R2NEVk?=
 =?utf-8?B?cVBRU3JwOFpyNXRTVUFRVDZQREFtbDRNT1ljR0l2YUlyL2ZRWmNDcGNIVTVp?=
 =?utf-8?B?UU91cXhFQldxTDl0YXg2dUdCeXZEV2JvcWJNenliTldsSkhldFhVbnhEOHU4?=
 =?utf-8?B?UVFiRWVoOC9EQU8rVTlrdWNGSld5WGNMbUJRRWFJNUV0NStFc0FuM3VtRXpV?=
 =?utf-8?B?Y3FCVzNEU3pvbm1OZ1lKVHZlSFBHeEduV2wwdzVGMXBKMlB0b0JLR2NiWHoz?=
 =?utf-8?B?RkV5RHZib0x0VnU2OUF2NXlPVFBWVmkyWFMzYkZ2UWpjcnQ2SGg5a1BPVHVh?=
 =?utf-8?B?WmdMMy92VHYrTDZHMG5MTmNzYnlJcnBUV0ozL01Nd2h0VC9wTkNXejRQN1NH?=
 =?utf-8?B?R1Bwd0c1U1pHVThWRXRHZnMzOU1LWDh1b0ZpUHljSk9JSkNuSUlkWjkrWW8v?=
 =?utf-8?B?cUc3Rk9CdmF3MlRJMi9Dd1lOZExTaDVKeGQrcmgzQVBkNC9pRHhCcDc1Y0py?=
 =?utf-8?B?a1EwNXoxWVB3ZDdtSXR5Qnc1cENsOU4xUEhnMXdISmkycVY3Wk1IK0JCWmsy?=
 =?utf-8?B?WkFEdTN3aStqdEptMWRHOVVISk9sbkRmTXFObkZRQjNYK3FMS0lzVmFIRk9V?=
 =?utf-8?B?RUMwb1RrY1Y5V3AwTjRYV1VwcTJWam9PMUpiTTRTRzlpYzFMYXpMRnRmUTF1?=
 =?utf-8?Q?kFnP8QeCynu3y?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 01:03:40.1819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6dd896a-6e17-46ab-cf5e-08dcdc34ba5b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7445

On 9/24/2024 12:51 AM, Florian Westphal wrote:
> Chris Mi <cmi@nvidia.com> wrote:
>>> nf_tcp_handle_invalid() here resolves the problem as well?
>>> Intent would be to reduce timeout but keep connecton state
>>> as-is.
>>>
>>> I don't think we should force customers to tweak sysctls to
>>> make expiry work as intended.
>>
>> It doesn't work. The if statement is not executed because the condition
>> is not met.
>>
>> [Mon Sep 23 18:41:59 2024] nf_tcp_handle_invalid: 756, last_dir: 0, dir: 0,
>> last_index: 3
> 
> How about relaxing nf_tcp_handle_invalid() to no longer check dir and
> last_index?

Yes, I did that. I removed the check. The timeout value is 1 day.
I remember it should be 5 days. Not sure what changed.

> 
> It already makes sure that timeout can only be reduced by such invalid
> fin/rst.
> 
> I.e. also get rid of else clause and extra indent level.
> 
>> Even if the if statement is executed, the timeout is still not changed.
> 
> Hmm, why not? Can you elaborate? Is the timeout already below 2 minutes?

As I mentioned above, the timeout is 1 day.

> If so, what is the exact expectation?
> 
> Could you propose a patch? As I said, I dislike tying this to sysctls.

Sure. I will add more debug log to understand the function
nf_tcp_handle_invalid() and propose a patch.
