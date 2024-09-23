Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576FB2747D
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Sep 2024 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727106480; cv=fail; b=RpbMXNNqtgM481nF4i7QiDPwYnapluzBWKhqQHg3yh0fBlGZRXnfWyegfFG7YGFLrDG+Xy7ov3X/m7SNECIawRUzgasws54+iT1Ea3cX9SQwwf3E1BC2Edlc3EINDoWJQT7oSbcvfCvCaMhHjvvd2KApNQWdB6gGeqpkJcIwFlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727106480; c=relaxed/simple;
	bh=zeOV78bGJEpJ2E48wdhtKWdw+i8XMzOtGtYYJ1QatOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=rS8bPUUA2JfBRuHyy53j2zXAYxoJUU1LJ1un2KPZsINWSPnSLGkTqSMTFTmSElLvQva4u61XlnXXoc+7652KAyYTTr94dXdYSNDkQCL9Dm1TGHWkZFBh/YFXkDCrEzl0Lz96z84mZJYIXZFbMa1+qLQRvhkDC+dvzDG/1Q1l1cE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MiGMyoUm; arc=fail smtp.client-ip=40.107.237.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MiGMyoUm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jypWgB0kIDZT6UwVr7q/sB+TQzE0l8kktikTTGeq0J5IGFo3aAUjlqpuEBGcUM0+qK9XM2CBhK6wB7wB3qfi5MXyHo5w5pk012ZkNPxj6EOlam3r2d+smWtPc1dcGEMxqq/E14xBMUX/XSwlGZjmv7fdf7IhROTJivWs73OLv6BKIKsRYlfbBouv1PHkgNrKjUkssltTb5Baj33X64i3lBU5n8YO3QEk849jfKo+ww2No1Z/LYIDmpbHjPHom6bzOtcf1r6WC+CCuA+ij0Zdi5YqZJfaz+VsEGzvIwxHJrPmjDWJY1bTr22HM0POKA3Cb3/lbwlSpRuH4sOGKNURDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rijJNk5Bo8rkgqm868ENgo5G4ktZclk27zWQpZLojBw=;
 b=ix1xEfL9T9FKY16nHyWfHoeZBrqriojZnUJoWkJ0izGkxAIMk66ybnh8Z5MgJAHlSvOfbesQEAYiQSJ934pwPLdmMwylHj9lpGBEU+GcY/KbkWXJdUImom3yvf5BAySMI7pg4N2jels54AQFc/H1c7uwg00tV/j2jngG9F0AaAKaxeSufWy+alSD7ZgM3KBaz9IutI7h+lfiKO5nczsmNSlaGpsdnSc7Gpu17/iaRnEyZSUj0jxFUV4l6uKKm1t+0lgyKhZpiJqE0Scvg7NwiFwYmrajXvvcKu03QuDHRntJox7TOYkbPEtyEi1JKyfsSerLvzvlGk2kWnmQZDhKZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=strlen.de smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rijJNk5Bo8rkgqm868ENgo5G4ktZclk27zWQpZLojBw=;
 b=MiGMyoUmdKrtlXg/Gbd8nCXUE7ERVru/KsR490xGbeXp153APxiqeOYeDOe21prESLB75k+JhOe0iTLPfAByThVct5Ju9qg4z/l7G97JEPvMpXYXT0ibfFqn086jOfrL+pRZPcTmmWD91XIu64VI/yOd4/ST8qEry81QoHJDVB8j/W/mJaozL4HVbVd2jW0p0LxRo+CSU31Yt0ayylStC7fTDCSj/ESwM8mRcNrsZbJoaHju7tOWvX9JNYKWEEvqx2UvUprUkj2+pYP8VMNfFj0DtjIFcYyX35BCT+D4pgEuadCiMhqCjuY5iXipO/xvqQcQcylZn4ixtFYXvLOjiQ==
Received: from BN0PR07CA0015.namprd07.prod.outlook.com (2603:10b6:408:141::30)
 by SJ2PR12MB8740.namprd12.prod.outlook.com (2603:10b6:a03:53f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 15:47:53 +0000
Received: from BL6PEPF0001AB54.namprd02.prod.outlook.com
 (2603:10b6:408:141:cafe::5c) by BN0PR07CA0015.outlook.office365.com
 (2603:10b6:408:141::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Mon, 23 Sep 2024 15:47:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL6PEPF0001AB54.mail.protection.outlook.com (10.167.241.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Mon, 23 Sep 2024 15:47:52 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 08:47:35 -0700
Received: from [10.19.211.37] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 08:47:33 -0700
Message-ID: <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
Date: Mon, 23 Sep 2024 23:47:31 +0800
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
Content-Language: en-US
From: Chris Mi <cmi@nvidia.com>
In-Reply-To: <20240923100346.GA27491@breakpoint.cc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB54:EE_|SJ2PR12MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: 665e227b-1d0a-40e6-5f12-08dcdbe71569
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SjAwKy9iajRQM2paK2E0eXlxc3JBSVFOaXZoWThERW5XWnp1emY0M1FBUE1u?=
 =?utf-8?B?Sk8yeDdWSkV4Ukt2LzZJTmgyd0MxdnVkOHBJS095aXVIVEM4YXBYK2RBRTdT?=
 =?utf-8?B?b3hSZmpsREhJYXdMUTE4eDFoVUx6Z3pGRENlL1h4VitISTVjS1BxQlJaQ3J5?=
 =?utf-8?B?bm01YVptMnJVcGQzK3hQaE43RzZwWGtIbnlTbXBYUFF5RHZmd1NveHZWTlFo?=
 =?utf-8?B?SGwvTXFpUU0rQ0JwelF4ajlPN01paWx2U3hIUzFxV0czTWEyRndnVzIvWlNk?=
 =?utf-8?B?Z2RIeXFrQURVNzhmVVBRdXF6eUJHb3FVUTdpMFZWQ2k3WUIyREhPcXZ4VEh1?=
 =?utf-8?B?dWVPVTR2ZGh1YkNpbUhScFY1ZCtPbUpnQXJtbjh6aU85M1VzdXN6a3FEcE1w?=
 =?utf-8?B?b0s3MEwyN3U2Q3NEVU5Td0Ruc1R0U1NXTy91aHUwdGtEdFNQV2lYcktLRVpp?=
 =?utf-8?B?ZnVXNE9VTE1obEtLK2hsRnJPTkVzcFQ2NWwxRmszQlZzK3Z3Ty9Tbk9NeVJr?=
 =?utf-8?B?UFZPb0MyVmlHeVgzVEpBZENqcDROMUpFQStqYXBmSnNXWHF0eFF0UnNhaHFB?=
 =?utf-8?B?VytmLzgxQlJ6U0hMeDFENzA5QlRaR1ZLTVZjaG9LUWlud2xpRHNLY1FqV0VC?=
 =?utf-8?B?bVYrcUhLRG5nZWJZT1V2SkJjdUN3OTRBTXcwelExcjNmdXN5M0FJbjV1aExp?=
 =?utf-8?B?Mk90dUg4Q05MZXZuSGQzQTVEWVlHTDRZTGJaSjl4Sm84Z3FIcTAySVFuekZl?=
 =?utf-8?B?VzhoTk51eEpZMUJJOCtUUS9jREtEVkVtQ1FGOUlFY1lGNjFrNjVrSENiczd5?=
 =?utf-8?B?MkVrSExPUHM5WHJFdktOcy9XWW1pdkY4Ulc1OU4reUI1bkQwRWhDNC94SmVh?=
 =?utf-8?B?N2hPYWp0dUhNLzkvQkVzVE5ONVgyU29pdkVEVXhpcTlhN3d5RUY2ZGlibW42?=
 =?utf-8?B?VEJQVVNDRkZFWHpxTXR6QnF2cVlhL3IweU1RbWxzcWY4Mkd0amh0YzdSNVVs?=
 =?utf-8?B?TFdaU2VmZEtNK3JHcXltSytvRmhKaFFrNHhPMHFJUDZnV1NVT3pKdWc1VkhG?=
 =?utf-8?B?emNibks3NVFqY1AxVkxEWm5GMTJad2MwdlpIazJrb21YejU3OXVhek5ORnVE?=
 =?utf-8?B?aE1uWHRpQXJFUmxyckJsZjRVbDZMM2daL2EyNGNzaElqOHBHR0EwQkNkNmtW?=
 =?utf-8?B?SXBrUDJqcWJaUk1UTEFUTjZFelNRdXBTSVZURzJpNG10Rmw4NVk5L3VkVFl0?=
 =?utf-8?B?dTIvbFVCWkpEdXRuaXZxbVZZbVhRVmlIM1R6VmlDbWdsZ3R2bUtSUjZ1RmpB?=
 =?utf-8?B?aVZNSUNvbTVJV2FTREFsNDM3TjFyOE05djdhWjAvUE55eE91LzlGa1cvTXR0?=
 =?utf-8?B?c1h3YlVkcFcrWDkxQTZxbTJKakhVV2NnS0llMlkvaW4vb043WFUwbVdiSXJ5?=
 =?utf-8?B?S2lkS3pReVFUdU9CZ0V1aHJESXF0N21SMldkK1NwVWZzeE9wOVVHR0RmUTJl?=
 =?utf-8?B?c0xDUkNzZlc5VncreXhQYlhqVG8xS3A5a0dyOEphMGxSUTRiTytkdk51UWhN?=
 =?utf-8?B?M3IvM1JBRjEyRk42Y25hS094Uyt0T0tSS3ltOTFuY3BvN1U4NHhlT21pNk4z?=
 =?utf-8?B?Ymo0R25hOTFZMWdZSjFpUjV5KytTaWMvMmptai9BaDJEenRQQVBTSjVtalVO?=
 =?utf-8?B?Wm5FYmdJbFoxckE2L1g0SGVGdVlweTlrd0xTNDdhVTdkY0QrTDRndWlRSGFI?=
 =?utf-8?B?dkZBaGN1K1Vhc1hPdmdZVWhNSUxxbnNjMjViQ0FEQVFrMkZRU25ZMVFac1dI?=
 =?utf-8?B?RmNoc3RtSS9yTFVtdjBFZlRBc0VudnJ5ODVFdm51YmRhaFNHS05BME5pcnNU?=
 =?utf-8?Q?4u/lkLWTlQVth?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2024 15:47:52.1048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 665e227b-1d0a-40e6-5f12-08dcdbe71569
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB54.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8740

On 9/23/2024 6:03 PM, Florian Westphal wrote:
> Chris Mi <cmi@nvidia.com> wrote:
>> Hi Pablo & Ali,
>>
>> Our customer reported an issue. I found that it can be reproduced like
>> this. If the tcp client program sets socketopt linger to 0, when the client
>> program exits, RST packet will be sent instead of FIN.
>>
>> But this RST packet doesn't match the expected sequence, server will
>> ignore it and the ct entry will be in ESTABLISHED state for 5 days.
>> It seems like an expected behavior due to commit [1].
>>
>> We found another commit [2] in recent kernel. We tried to set
>> nf_conntrack_tcp_ignore_invalid_rst to 1.
>> It doesn't work as well. And the commit message is too short. We don't
>> know what's the usecase for it.
>>
>> In our case, if we have the following diff, ct will be closed normally:
>>
>> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c
>> b/net/netfilter/nf_conntrack_proto_tcp.c
>> index ae493599a3ef..04c0e5a86990 100644
>> --- a/net/netfilter/nf_conntrack_proto_tcp.c
>> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
>> @@ -1218,7 +1218,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>>                          /* ... RST sequence number doesn't match exactly,
>> keep
>>                           * established state to allow a possible challenge
>> ACK.
>>                           */
>> -                       new_state = old_state;
>> +                       if (!tn->tcp_ignore_invalid_rst)
>> +                               new_state = old_state;
> 
> Can you test if a call to
> nf_tcp_handle_invalid() here resolves the problem as well?
> Intent would be to reduce timeout but keep connecton state
> as-is.
> 
> I don't think we should force customers to tweak sysctls to
> make expiry work as intended.

It doesn't work. The if statement is not executed because the condition
is not met.

[Mon Sep 23 18:41:59 2024] nf_tcp_handle_invalid: 756, last_dir: 0, dir: 
0, last_index: 3

Even if the if statement is executed, the timeout is still not changed.
