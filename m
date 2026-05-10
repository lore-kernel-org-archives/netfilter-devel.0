Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011041.outbound.protection.outlook.com [52.101.52.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D51299923;
	Sun, 10 May 2026 11:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778411665; cv=fail; b=eaGkgx5KqZd2F7ZdP3QUMTIbVeytoofNy9tTTQygVhqTR3OUEWL+QBUmj07OZ5qmdYP0G76mfLq5kYD8Jui+Y8QHhlzqLuLl1VhVuqJGjxzNZPoKF9U90VxeUMpeRhwmzqeFZRo4msfORUZFA8cRFNBgY3sJr1mKq/JlVy1AfHM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778411665; c=relaxed/simple;
	bh=+VpASGzpQQSOlQc4I5iReRDBfrENYhz0TWR5nI3ahoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T0CUZjbu05fDooeMtWTTP/TexV7sGywZB33d1wKbwnYUB1d+6zYaa5U3LK0V2le2Np6XMxqbl0xcoMYcTd2BVJ83B+enSbOfCfasMw0LikkYWs0vQdisysyWwaLt6SCa8y10Dqj/X7xRvogppw4qAWSQkU6mKIcTPW4ymKWJwPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SOkb4kee; arc=fail smtp.client-ip=52.101.52.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SOkb4kee"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eEepxPbFtAWPsLDGfE8Ad1ER2soLT3eUpzmJK+/GJoNCh0uvRllv1gBLThVv0z4h6VH1vqsvkvKf8Blfj17bnEAehBiIo4Hox2gEHzs4vQw9uYpiBatwen9GvebilfxaTmGrbvmrzJhJIyGC+ssiyFcUY7NNV46cuNSwzXBQXq8rXv5qUY/t7IAr8DZv7Aj1U//5cNZ9O+QJ5faQZcCyhTDGavJB0aT2SCQt7mhrcopn+vi9EQfpJg90rWzQlEmFp6uM8ww58MNkDWgZwqBadvaeOO4gTIo9wgJhxI5Txoz0VodhC2ierfCf6coZL41fARKj7U5EpX8XloGGW0uqiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SRBOQ2oBI54MSrm61Xe2n/l3Yu8ZH/s3to0OboeoaYk=;
 b=OomFxmflqMOdVVSXYlZ1OvPsQ32KGHNR9RsNIBDTG7zo1+TCeOgiwcevjnyQIszclyIPfVasTP1bUhiuWTuJV6XWhF7tCCLfMsDQeP5ckTN4M0hHzfiNocqEq6umL+iAvqELV967GXE/mamvzyYgvX3Vg2k2l0UUMqRF+6WCHlAWvEEFDRJ8magnlJNzuFl7jDKBLQggvef5xIh/OHnd7/iNGTMtLi4LOByU0gcKrJgEpq0S75UZXyTOAHcxHkVOEABvlaJ1eg8HYvVyGcmckJO/JoRnTNCZWPgCOoYcSQVpfIIGKAYYKOehG7oLVhQVNW0LRAso31DHUNNdM1xSwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SRBOQ2oBI54MSrm61Xe2n/l3Yu8ZH/s3to0OboeoaYk=;
 b=SOkb4keew3rpvE/I+aZqWQB8wFHiMxJ61ySWMCpCJh5jHTCJ7yT/YR8snY7H14/1OpOyeF7a3D+nN9V/6Jmg3s53VDrgY4X5TV7AkMmioZnNWzrGumpoZZcUAEvDYCIU+2Ly5nbPEKy4IBIuwEhxE1iBILnEHm6O09BQARxycivEYaBtAwH1lxXMK+SvFpeOWbvegagfr/k0X9ilgferQJ93preur+PH+kO+KpK98iIX+OrbSTD+lyp/z7PKsVTpTNi7AiiuAmeygCqa/YVk9+rdecH4BXoYEo+uNOVenwiNDszVMJCPZwhCFn+wxl3WHz6lcORiehAOpuZ8fN3/QQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by DS7PR12MB8230.namprd12.prod.outlook.com (2603:10b6:8:ed::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.22; Sun, 10 May 2026 11:14:15 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2%6]) with mapi id 15.20.9891.021; Sun, 10 May 2026
 11:14:15 +0000
Date: Sun, 10 May 2026 14:14:05 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <20260510111405.GA78831@shredder>
References: <20260508-nf-neigh_hh_bridge-fix-v1-1-a1464468d92e@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508-nf-neigh_hh_bridge-fix-v1-1-a1464468d92e@kernel.org>
X-ClientProxiedBy: FR2P281CA0183.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::19) To SA3PR12MB7901.namprd12.prod.outlook.com
 (2603:10b6:806:306::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|DS7PR12MB8230:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e2a39ac-ab86-42f6-5d4e-08deae85454c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	s/vGqH9u880eRs/u8G6vuqxKkLZ6fcLq7ID3A1IqJHf24a+uSobrlOdZN96Efb6X4EV9r5aqwDU0su3Q81rC1ql5l4wELkt7DmfGKtxRPCw/XirgGPKTJaSbbWIaruhjtcwIn/No7kb90OqmVwWHL7m/ruGZ2iG9nAeeeVmvevIsiPzfhHChtjyuXUex/IqMb/0x9jOz/F1mgIlsUMwBYgLvWGr5zjuvWVp6THh+r5DOR4h8IhJvGtltV2YAQA+fzrET9cci6ktvWULbVzUmj6Cnd0yzGUTmj+6W3ILOxtyR22qlXFC2dz3PPq+pd1CzYrYd2Y5iexkAWHwLNt1Wjx77Mic0TqUSNZdD48YANaXC8dqiSRgoScL2O19240rNf1b2b94gQL3pEPvsp5oXBcW6LG5G/goRXtUcUuCsvE0oHya/EFK1yjM60ZzgxdlZAmjGY6QkbQQatMK0PrTxDy/xuzYzBhJZKIO/AVGuTAshwQbiKu/nD6ufEe8FXLQKxQgBZkrGHMK1+zmdMgKbSvfCXAoKGjNoXd72TBAcCFNEdc7pPcJmMSanXpXJ1oHIdVnZu0fsUSYXi9TpnVSmI7LzViqSzQzNkcVNX7yCiOg/E9nYAT9q333pFeYJfUNlYaT7TwHwqETzqJcaJ2AiaXXw4GUlcfrXRZR/IRd44NfVq4DNk8z/nxqNSUApDB1N
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?n+v+lrSWuYb6teXNNSomihxngnH/gad0nlcT22o13nwXLKcFqTGrJa4f7OGU?=
 =?us-ascii?Q?+VF37gO1E6+tfmWPuJv2PVhd4K063OBdb8BSsMLcY8wqv6cIV8oTDGfgq2pF?=
 =?us-ascii?Q?xWgILYSSVVJS3maoQay87tNcI2PqS1nW9uNPLuvmFNfHHIwdChSwHUQ+H+7x?=
 =?us-ascii?Q?e9S1WdWMCyn0F2P3MLH76JBFEmAk+yTtbT9A6hmjX5SMH+JWGmPCAnPGdrLx?=
 =?us-ascii?Q?ZEf8L+Iz3u0QN6Bd7TlAkvVSMGMp7pC/Yo3sTHWHuwCeJgmfcTZ9r6SPvxU5?=
 =?us-ascii?Q?aqdLx17J2TERoc/bnHScBhbO0xnhJI/9jZq8hhlt+E5DYpJwpAoQf1tzRTSu?=
 =?us-ascii?Q?oeAZ/dJDMZh2X5SXm4YpxFfTr2qcW+ydmSxfU65Mlr0GVeIGrnW5D+hn1+C8?=
 =?us-ascii?Q?tDCC7RL5Ej3kKClv9KotEruq5S57ThviJpxJ7/t6LZcVkkGXWhy5R65l+P6p?=
 =?us-ascii?Q?O4+tSm/RImqoU7zWajr8yPt84ZiULneflglrEOrDQwH0zeSyJrFerHd0K1ce?=
 =?us-ascii?Q?S4+z5RmNTxFL47J4b8b7DftzOKjPUvjATLPNHgfVG96txtfREk91ceu6KmL2?=
 =?us-ascii?Q?AmuTk05JkJEBx30pAKZSNe+cYvM6TfvVeaQfODro/FH3nYih+kHqE/hhpQd5?=
 =?us-ascii?Q?8OzyEqOe+nQvi6AEFOXMaJcxNy3mXcjV5udHgSQ9adl2zf60SBuINRzHY3kI?=
 =?us-ascii?Q?0IxJ6Oh4OAJPtgKRpdsj3LT6UhSVAa4Ix9fvCUqhQwDv2flaISXFuNF0ZBII?=
 =?us-ascii?Q?Mk1SeLNPZDh9/65OpJRdOtNyjXaVSgRvxqBjhWt3Arbt2Wx01mU+AqhrS8H9?=
 =?us-ascii?Q?oHZYSq1zeXlgo8110TAvxVTOM4L3Pv3BvJGW/5hGoVyWDAP8gcup5hWhtlfs?=
 =?us-ascii?Q?karzhaNiZb91RkP6xihL+Fz7tCCv3N5pt4nx8/dr3Q/fkJ5R2y5//rmFoZM9?=
 =?us-ascii?Q?95fnHc9W2YR7aG51Lu+vmisNAAI4qW+F9chJVlKpOHMV/e1lIZc7cZNwibev?=
 =?us-ascii?Q?KZz6sLvS6ngcV2p4yXiDZeqx+qi+BO3Rop5qDSJUmfG/aYlNVIUK9pxoU247?=
 =?us-ascii?Q?GWuWzyFDgZ2Ygk/iGuWCATsmGEvYDUd05kMatgwAt2T1SZayI/wIRhkT3obO?=
 =?us-ascii?Q?oSMQXdaVykO+WGv0RN5//OoD5TLJC8yOVx6ePAqdcJeO2A7l54VndLD0GiSY?=
 =?us-ascii?Q?zlD4VzfHnOSTGL6gXCGXrbS3Q1zkUt9KPmlgkUFWSA2YjnAi76KNsVsP1neJ?=
 =?us-ascii?Q?X6dyyUmsfYMhBQI6ZWtjn6yyCdOQNOkBop9C/+MhCypay3+KrN/a+eBbSBwF?=
 =?us-ascii?Q?VjFWSOwGiGbDAJ27k3QMb5DbpPRrb/sfhciW81Hy14+MSeo6LUSbCMbpXBgt?=
 =?us-ascii?Q?ooMK6R9eH+iSxXqqBRkCFPHta9H6mAQtSI+XzzHVuH9lozO3u2/NrwFnCTaV?=
 =?us-ascii?Q?G4QopIz99xmnBOxLB+CAfLwgwYtbF3IKY5Cyiflu7pSBPXJQ6SHlf8iCKosA?=
 =?us-ascii?Q?UAHasjTv5iZUojCGu6dnFR8vOeKlYcpEPz53ca+exlKJ3+dAS87/PJE0+UOk?=
 =?us-ascii?Q?O5sm641aRspAJLU8ElAHh+Dd0ufbP64ur+apNRxwhAI55OIcG1UhOtPcyGud?=
 =?us-ascii?Q?dG1HqtG2KYDDWjRMkFFYBPlkwahl9SHv5CtXQKtNuxH93238ciiq3KPSRrZy?=
 =?us-ascii?Q?rh3uBCoKooInfh/EHwyhjEu5LIy2rHZwQpXt4a3bFjPo6joP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e2a39ac-ab86-42f6-5d4e-08deae85454c
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2026 11:14:15.1492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMNaaYDguUDI+RS/xk86xF34zS1a+Q+CpgAR00KJGE1RdGkzBpZlvTyY8QLe8yAooxF7aT+k6ZvCTTjWa6vFrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8230

On Fri, May 08, 2026 at 01:25:14PM +0200, Lorenzo Bianconi wrote:
> neigh_hh_bridge() assumes the skb always has sufficient headroom to copy
> the aligned  L2 header. This assumption can trigger the crash reported
> below using the following netfilter setup:
> 
> $modprobe br_netfilter
> $sysctl -w net.bridge.bridge-nf-call-iptables=1
> 
> $root@OpenWrt:~# nft list ruleset
> table ip nat {
>         chain prerouting {
>                 type nat hook prerouting priority dstnat; policy accept;
>                 ip daddr 192.168.83.123 dnat to 192.168.83.120
>         }
> }
> 
> - iperf3 client (192.168.83.119) --> bridge (192.168.83.118) --> iperf3 server (192.168.83.120)
> 
> the iperf3 client is sending packet for 192.168.83.123 to the bridge device.
> 
> [ 1579.036575] Unable to handle kernel write to read-only memory at virtual address ffffff8004d76ffe
> [ 1579.045482] Mem abort info:
> [ 1579.048273]   ESR = 0x000000009600004f
> [ 1579.052024]   EC = 0x25: DABT (current EL), IL = 32 bits
> [ 1579.057363]   SET = 0, FnV = 0
> [ 1579.060417]   EA = 0, S1PTW = 0
> [ 1579.063550]   FSC = 0x0f: level 3 permission fault
> [ 1579.068345] Data abort info:
> [ 1579.071224]   ISV = 0, ISS = 0x0000004f, ISS2 = 0x00000000
> [ 1579.076720]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
> [ 1579.081770]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [ 1579.087092] swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000080dc4000
> [ 1579.093794] [ffffff8004d76ffe] pgd=180000009ffff003, p4d=180000009ffff003, pud=180000009ffff003, pmd=180000009ffe3003, pte=0060000084d76787
> [ 1579.106343] Internal error: Oops: 000000009600004f [#1] SMP
> [ 1579.193824] CPU: 0 UID: 0 PID: 235 Comm: napi/qdma_eth-3 Tainted: G           O       6.12.57 #0

AFAICT this driver does not reserve any headroom in skbs that it's
injecting to the Rx path. Is there a reason for that?

> [ 1579.202614] Tainted: [O]=OOT_MODULE
> [ 1579.206102] Hardware name: Airoha AN7581 Evaluation Board (DT)
> [ 1579.211929] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [ 1579.218889] pc : br_nf_pre_routing_finish_bridge+0x1ac/0xcc8 [br_netfilter]
> [ 1579.225859] lr : br_nf_pre_routing_finish_bridge+0x18c/0xcc8 [br_netfilter]
> [ 1579.232822] sp : ffffffc0817cba20
> [ 1579.236128] x29: ffffffc0817cba20 x28: 0000000000000000 x27: ffffff8002b89000
> [ 1579.243273] x26: ffffff8004d7700e x25: 0000000000000008 x24: 0000000000000000
> [ 1579.250416] x23: ffffffc08179d4c0 x22: 0000000000000000 x21: ffffffc08179d4c0
> [ 1579.257561] x20: ffffff8004d9b800 x19: ffffff8015010000 x18: 0000000000000014
> [ 1579.264704] x17: ffffffbf9e930000 x16: ffffffc0817c8000 x15: 0000000000000070
> [ 1579.271848] x14: 0000000000000080 x13: 0000000000000001 x12: 0000000000000000
> [ 1579.278993] x11: ffffffc0798caae0 x10: ffffff8014db6fd8 x9 : 0000000000000000
> [ 1579.286136] x8 : 0000000000000003 x7 : ffffffc08171f628 x6 : 000000001a3b83d3
> [ 1579.293281] x5 : 0000000000000000 x4 : 1beb76f22fee0000 x3 : ffffff8004d7700e
> [ 1579.300425] x2 : 0000000000000000 x1 : ffffff8004d9b8bc x0 : ffffff80026ed000
> [ 1579.307570] Call trace:
> [ 1579.310018]  br_nf_pre_routing_finish_bridge+0x1ac/0xcc8 [br_netfilter]
> [ 1579.316632]  br_nf_hook_thresh+0xd4/0x14bc [br_netfilter]
> [ 1579.322032]  br_nf_hook_thresh+0x250/0x14bc [br_netfilter]
> [ 1579.327517]  br_nf_hook_thresh+0x76c/0x14bc [br_netfilter]
> [ 1579.333003]  br_handle_frame+0x180/0x480
> [ 1579.336935]  __netif_receive_skb_core.constprop.0+0x540/0xf40
> [ 1579.342682]  __netif_receive_skb_one_core+0x28/0x50
> [ 1579.347561]  process_backlog+0x98/0x1e0
> [ 1579.351398]  __napi_poll+0x34/0x1c4
> [ 1579.354887]  net_rx_action+0x178/0x330
> [ 1579.358638]  handle_softirqs+0x108/0x2d4
> [ 1579.362560]  __do_softirq+0x10/0x18
> [ 1579.366051]  ____do_softirq+0xc/0x20
> [ 1579.369627]  call_on_irq_stack+0x30/0x4c
> [ 1579.373550]  do_softirq_own_stack+0x18/0x20
> [ 1579.377734]  do_softirq+0x4c/0x60
> [ 1579.381050]  __local_bh_enable_ip+0x88/0x98
> [ 1579.385234]  napi_threaded_poll_loop+0x188/0x21c
> [ 1579.389853]  napi_threaded_poll+0x70/0x80
> [ 1579.393863]  kthread+0xd8/0xdc
> [ 1579.396918]  ret_from_fork+0x10/0x20
> [ 1579.400499] Code: 88dffc22 3707ffc2 f9406663 f9406684 (f81f0064)
> [ 1579.406589] ---[ end trace 0000000000000000 ]---
> [ 1579.411209] Kernel panic - not syncing: Oops: Fatal exception in interrupt
> [ 1579.418083] SMP: stopping secondary CPUs
> [ 1579.422012] Kernel Offset: disabled
> 
> Fix the issue reallocating the skb headroom if necessary in neigh_hh_bridge routine.
> 
> Fixes: e179e6322ac33 ("netfilter: bridge-netfilter: Fix MAC header handling with IP DNAT")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/neighbour.h         | 15 +++++++++++----
>  net/bridge/br_netfilter_hooks.c |  5 ++++-
>  2 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> index 2dfee6d4258a..4e1222968753 100644
> --- a/include/net/neighbour.h
> +++ b/include/net/neighbour.h
> @@ -487,16 +487,23 @@ static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
>  }
>  
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> -static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
> +static inline struct sk_buff *
> +neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
>  {
> -	unsigned int seq, hh_alen;
> +	unsigned int seq, hh_alen = HH_DATA_ALIGN(ETH_HLEN);
> +
> +	if (unlikely(skb_headroom(skb) < hh_alen)) {
> +		skb = skb_expand_head(skb, hh_alen);
> +		if (!skb)
> +			return NULL;
> +	}

The comment from Sashiko looks relevant:

Does this adequately protect against writing to shared or cloned SKBs?

If a cloned SKB already has sufficient headroom, this check evaluates to
false, and the code proceeds to overwrite the MAC header via memcpy().
Modifying a cloned SKB without unsharing it could corrupt the data for
other users of the buffer, or still trigger the read-only memory panic
this patch aims to fix.

Should this use skb_cow_head() or explicitly check skb_shared() and
skb_cloned() before modifying the buffer data?

>  
>  	do {
>  		seq = read_seqbegin(&hh->hh_lock);
> -		hh_alen = HH_DATA_ALIGN(ETH_HLEN);
>  		memcpy(skb->data - hh_alen, hh->hh_data, ETH_ALEN + hh_alen - ETH_HLEN);
>  	} while (read_seqretry(&hh->hh_lock, seq));
> -	return 0;
> +
> +	return skb;
>  }
>  #endif
>  
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 0ab1c94db4b9..6b59d7eb7906 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -297,7 +297,10 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
>  				goto free_skb;
>  			}
>  
> -			neigh_hh_bridge(&neigh->hh, skb);
> +			skb = neigh_hh_bridge(&neigh->hh, skb);
> +			if (!skb)
> +				return -ENOMEM;
> +

Also from Sashiko:

Does returning early here leak the neighbour reference?

Earlier in br_nf_pre_routing_finish_bridge(), a reference to neigh is
obtained via dst_neigh_lookup_skb(dst, skb). By returning -ENOMEM here,
we bypass the neigh_release(neigh) call at the end of the if (neigh) block.

Could this cause the neighbour reference count to leak, eventually preventing
the network device from being unregistered?

>  			skb->dev = br_indev;
>  
>  			ret = br_handle_frame_finish(net, sk, skb);
> 
> ---
> base-commit: fcee7d82f27d6a8b1ddc5bbefda59b4e441e9bc0
> change-id: 20260508-nf-neigh_hh_bridge-fix-9ab775ee23c6
> 
> Best regards,
> -- 
> Lorenzo Bianconi <lorenzo@kernel.org>
> 
