Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DC018D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727139913; cv=fail; b=RyQxDGgHu0HAVo+hVMDxJPhjgP//EYut2H/8KzhjAB8cJ6RZby3G3+g89gogNbfFZiVFBIasMacHOop4HxtQzYE8w5lU/YKs01pPhQB1DcQ+9Z/dQuYG5H5jAEd8P3UpDlUTVKV9iC+j35MLL6HBczedJJfSR5DzY7nVk+LMhyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727139913; c=relaxed/simple;
	bh=jqpfINCkpoQCFyAVrwtOlD/2fMXejJrpefCY1m6b5Lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PMt4qj+aan63gvUsABXyA+F5OvgeMvi8BM81EGJ+PiK1j8Jd6ya7fVXmuRGWPEdUdKuye0Vq3TjitAxNDdpfMPVs36QJbQvQflPdrJm6yitrirzQtFr8LoGnNNFO8bLX2i0oF6FUaYvhDwBWchool1UV2y+u9QJr2ahdxrYNIQ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eOFDZrw5; arc=fail smtp.client-ip=40.107.101.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eOFDZrw5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6uVP17r8al1a75VP2ziR/DVZU94Ply7oifdcf14ywZ/Q3x2rKdRYeRwpsn2zFWwvvyS8yvIi/braju8wUAXMLdoD+xIbQreG794i/CQmvGLM9Iti8D12iIVesrW+lRvINNngo5ActPHA77/PUG38GLR7hnRhzbhpIofMx5jjJY5bqY0TKaAWErkjtidyVqUkjgDnbZpvYX7UgZDXJpKhhCS46Ty6UKtdXpCnrET/3pYGZztSbjQ4fwTQxJ/PDo/UOW5x4FYSq7tGh5AZYBVWZRjFkQ8zLvKu3B+H6rPwR0zkxlAChalb/NaJ1GHtmUM05lkRCTqfH1d6qSwWwMdvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMp6f6SpE/ERGR7b2QCksiqnVO5yxDPPUTB7gXkPTK8=;
 b=NOt6W/l3LLgS0k33npJH/IoXZOnTcrr7MfZVTWsX1gf3w+pbkUvK7MV7Ir6PZsYtp2Wc1l/pjb2VmKmT67+FxqWepkRxatXd0umz/lUPPfeDaMxLxguul7xJ8ylfeS3uWWUUEcmHl38saVF4gzNs2w0QFAj8lSNKawo0SgOISIWvcmmsoElaXFWW9u4JQ23uDSH2QauOyLOlqlYWggpC9ihrgebW+w7i6u00JAiqEvj4JEnXO6IXBtnBRNTG7T9KLrckkMJIfmLmX47CoFx9z1d9Wu9Xd5V6SmiaEfGzrd8zcbbj2XqGpr3Lk+Iu6b33S0Rj7dkHiHilsK+4QzZKoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMp6f6SpE/ERGR7b2QCksiqnVO5yxDPPUTB7gXkPTK8=;
 b=eOFDZrw53KjGrRyld8eRmV/LP8oG2NdSo4PoQfMIUnANKQaEcH8vfXazIu9MhtT5BdYfJ6jdqpjzVak4mKFifbHGE6fptu1oDISMcADxrddHKMXW7y1R48DHrFNuLCS6y7kzf7UPMNOmtBIfzmVzeWOHsqwmDceqeE/SIlWiv4Jtrw7IYIZZq7meI/agyGJ2CTxRgnXEVNYmF09JCtk4Lspfe+9V8HK7tsEA+Dq/JQzHVUu6pvcx90SbQGeWbqMp0Jl9ytGFkJTKD4IGE5XOtOufA2ikD1PIPG2MJrzfSXMkABuYgmEwv1hI9Ue+nejRNadaQxjozsjkOhTxABasNQ==
Received: from MW4PR04CA0232.namprd04.prod.outlook.com (2603:10b6:303:87::27)
 by PH7PR12MB5904.namprd12.prod.outlook.com (2603:10b6:510:1d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Tue, 24 Sep
 2024 01:05:07 +0000
Received: from SJ5PEPF000001E9.namprd05.prod.outlook.com
 (2603:10b6:303:87:cafe::7a) by MW4PR04CA0232.outlook.office365.com
 (2603:10b6:303:87::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.30 via Frontend
 Transport; Tue, 24 Sep 2024 01:05:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001E9.mail.protection.outlook.com (10.167.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 24 Sep 2024 01:05:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 18:05:01 -0700
Received: from [10.19.211.37] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 23 Sep
 2024 18:04:59 -0700
Message-ID: <e946d016-f21e-4ae2-abfe-1d85e2b9d652@nvidia.com>
Date: Tue, 24 Sep 2024 09:04:53 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ct hardware offload ignores RST packet
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
CC: Ali Abdallah <aabdallah@suse.de>, <netfilter-devel@vger.kernel.org>
References: <704c2c3e-6760-4231-8ac8-ad7da41946d9@nvidia.com>
 <20240923100346.GA27491@breakpoint.cc>
 <5edeab2c-2d36-4cef-b005-bf98a496db2c@nvidia.com>
 <20240923165115.GA9034@breakpoint.cc> <ZvGoVXf6thRynmPn@calendula>
Content-Language: en-US
From: Chris Mi <cmi@nvidia.com>
In-Reply-To: <ZvGoVXf6thRynmPn@calendula>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E9:EE_|PH7PR12MB5904:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a42e028-039b-4415-4caa-08dcdc34edce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?blpKcnNheFRrZm5mUms0bkRReGR1bDkwLzEveXErUllHOWhKS0RWQnMrcXNn?=
 =?utf-8?B?cHdaS0daVnBXbFYvbTRrZlNucXQrejlxQjAxbUZzU3BJMHM1dFA2TnhDazdG?=
 =?utf-8?B?SWRSVHRublFVS3oyVHdJYVJlamZBMXJia0FVNWdNMVJ5Z0RCMFpMSmFlZkxs?=
 =?utf-8?B?cmxydDYxdUszTGtSOTQ0ZHhNejZQbUVXRkxUTzJua2V1Tk56ZGxNTnRQOXgx?=
 =?utf-8?B?NENya1RKUVMvMVNIaXk1elM3by9WaStxUkNyVlBycS9ieXNMa2t2L25vWUM0?=
 =?utf-8?B?NGhkd1BPWXRWYm0yY3hCRWhaNEhycUpvQVFuNXVPVWQyci9HMFVNb1dLdjd2?=
 =?utf-8?B?R1hOSzVkTmtONEJ0SzlHSnJHa1NiVnd4eUpJU3h6TmZNdEY1UDJpTWRySzNq?=
 =?utf-8?B?eUlZRFRPVXErK2dFcnpoQnhScjZqcXBPM3pXK2lrQXdCY3pzRkdYeVNDSm5x?=
 =?utf-8?B?VXJwN2diSHRCck5KZnRsZjV4NFY5SjYxWGlFSEQrUi9uVldqdzFsS0J3TmUv?=
 =?utf-8?B?L3d4ZjhZNEpueGluQUNaaEpoLzNGOE1pL0Q1YlFENCswUzR6QTFHU2t0TGRn?=
 =?utf-8?B?VDJDL2t4Sm5HTGxqRHBudTg4ZlFxcFFZMENIR1dmN2hzQ1hFb0F6NXM3MHFo?=
 =?utf-8?B?eTBjUUx3RlpKaG5NQWFYK2FCMWNqYnRhSC9xRlp2QzZ2dnQwWjE5TDNwVjJ2?=
 =?utf-8?B?M2RzSFUzQysrSnd6ODVOZFdOMUpCTkxCd0pkblFYRTlHRVd3TU80VU9Gc3VH?=
 =?utf-8?B?aXZCUnNSLzVsOFJ5VGdPQ2xHQ2ZFQlNUZ1FMcWprelIrYy8vZGg0SEpibjlU?=
 =?utf-8?B?NGZoQU5jWWYrRVJGWlNrTEhYeDNycXVlSkJwcldHdmJTaGIvQ1VXMDZqbTN5?=
 =?utf-8?B?THhBN2RNV3BOZ01JM2lYczR5RTFBbHlPaEh2N0ZCMThyQUt2NDQ4Y1ZpaUhi?=
 =?utf-8?B?bDB0R2dHa1Q5c0RMQzQwem9KMUVMaC80NytpSzlQZ1FlY0UxU3dKUERQWG9w?=
 =?utf-8?B?MHpwNVVvYU9RMGRSUVoycnZsZXNvZURRdGxhUFZISTlNUkw5aitIZWRibW15?=
 =?utf-8?B?RzhDeks4V083OVpyV0wyNDNOc2RtWVBpZEFISEMvOWZkcmJFRHB6TERISDQ4?=
 =?utf-8?B?bkdDQWZkRC9hTmtmQmQ5RzFockdXcS9wd3EyY2daaVkrcDkvdTFJQWJCbnFJ?=
 =?utf-8?B?RTJUVzJxNjJqaUtuVXFrQUtJY0ROdERaT3F6M05yaDJRV2NWTFdoUWNWeUx2?=
 =?utf-8?B?Q3NCbDVuUHA1dmhEZVE5cDlicThZMEhFN3lMdDl6TDMvYTl1d1dGN0p2bTli?=
 =?utf-8?B?ZDVNOTRNRmtadFpGY291UzYzK001SnQvYjd4a085OFBYalp0a2lFMlFCYm9r?=
 =?utf-8?B?T0praVpESnVuQk41emI0SU5FcERUTEJaTThNZDhXZllidTVHMFE3Sit0Mith?=
 =?utf-8?B?eEx0cHpnUEZ0alozNFJGY3ZDbE80NXo3UExFNXJwOGYyL3hIYjU2eVExRFJU?=
 =?utf-8?B?RHNZc2hXZGRsN2xtTmhGS0dDaU12aDZQaFJQUDlmcGh6NDZMT0RSUUVXd1I1?=
 =?utf-8?B?OHkwNHo2dXd1M2pPNytYSVVHdU5CbkRRMFRweUYxbG1qNzFaYmZhTUVCenJL?=
 =?utf-8?B?alF3UVU0dXRnQkJNQWEreG5hWU1CVHRHWlRvOVhycXI0YkszWnI2Q0NncWNE?=
 =?utf-8?B?amVoWFhRcUViRXMyV0Z2U0ZhVzZJK0QzcDNtbFowZEdGRnoxSHJVbUJ5blUy?=
 =?utf-8?B?bmtrTmo2bHNwenB4VW55d094VVRyQlcySjRLY1N5V1Fidlg4ZURLTFBUUXY2?=
 =?utf-8?B?d2tselB2WWlvVFU3TXB5UUNOMFdrZTdxRUFGWkZCbUVmQ1hyTmRoMndDM2lJ?=
 =?utf-8?Q?yghNVrg44Mp7u?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 01:05:06.4804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a42e028-039b-4415-4caa-08dcdc34edce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5904



On 9/24/2024 1:41 AM, Pablo Neira Ayuso wrote:
> On Mon, Sep 23, 2024 at 06:51:15PM +0200, Florian Westphal wrote:
>> Could you propose a patch? As I said, I dislike tying this to sysctls.
> 
> I prefer to remove the sysctl too and try to handle this via the
> invalid routine handling as Florian suggests.

Sure. I will propose a patch to call nf_tcp_handle_invalid().
