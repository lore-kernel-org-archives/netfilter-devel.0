Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F2F1A3A97;
	Mon,  2 Sep 2024 19:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725304178; cv=fail; b=T5eLXvK5g7A68jCosuGFRgRg17a0BQvblai1xI/6Pj1kWJp8LipSYJCRRrfnIEz3wpL2A6TkAUfHJDtYnfiJsrNCZmW08oIKY+NiTS3R4jBjtm7yL4vHGOByaTQnu2dWvbPAkhZBlrT5NpdvhE/BNlmbKn2ZzqLikqL5iSe6+vQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725304178; c=relaxed/simple;
	bh=RWKpjERvl6b+r+vjXJnMA5we/+7cNnS5pbaIJvCBrIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LVB4joMsD6ueLwCdcUn5Dp7PKwLe7/yhJ/8fV3fAourlaBSXu+i3Z6JR38o7dWwob5KDXskYB+IcQ2Q2Nb7u9zUIDi4G6b+IPqKX8ZgG692Nj9ygjFNHKJHF2RcfcFflYyZV+FunfujFQJ5JPgTVFVt3QcxyfHUjvR6GhBG02ZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rMP+H4N2; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rMP+H4N2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZkO87/17TEDMcXgl/YHMPpjb0Z9yd63Gew4YOGLAPIiTciivTnIQmaQFfb0PlKe0EcAh35Zai+c+tXUHpmiaNZxKD1P5FkZeGytOwYawQ/B6aXjbxFYpbOujO1FR6Hl0HhURUxkcw+DeXBOg/TWXS6dsoRQFNNhpOn6UYIWhfxxUmf45SKzhr4WirnSlbLjLTC+aKOEe4H5G552FY4jAhn+KL02CHISENOAGaRZOKXlQXsLuve+r3TojmsAx1m6MI4QUEcpp8NfYUz1KZ224RUUn3CiXD5Nb56LSWMM0k3TKBYbdFy4CdCu2UAx8Jc/fGjLrAg+Lj1e3yIHJb93KQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOHO1wS8+W16epnfF5XQAOQHxrAwgumgYoDoUAVzqdU=;
 b=ZYonHiXAJgX57zwffqfm/vj/XRooNTsNqQCCogWIXjoH0yOwG1TpwaPRJ5gtOOEYyzw1dRyN+NHZrevSoR9W5aCnLw0sH/r4tdFmenNm6jf0YlN6bZ31MhX9/+xk/AajzHHQS5HhNTSD3mmqNMN8UbJ0wduxjVb/dWbhZIkEJwwCLbKLWKOw0LM+7qkcZxMXegpkZhVbg6uRaxbJCS96Tb8yWfpi6EN6RsIbuEAXPCfvSilWh8WxVcwji/+D8CeF/YkSf/HvPddmjCex3mCJKrQEgrOSKzAhPkFe0P+OibKdrFbp/OPznVW/BmyiE+Os9ExEQxLgT1lI846rMHTFZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOHO1wS8+W16epnfF5XQAOQHxrAwgumgYoDoUAVzqdU=;
 b=rMP+H4N2UK0GRLZLpTJBiLID9xhYK7XrJppzD59HxCQzXfN7VERpSawV93nVrvk7XODW7khNpizLZ2Dxlx6g+HeFSkXTjIUX6RVWUv0p/+RSRlkvUU0ZbEI8CybRcj2VeYkyTPAZfEkXVWUxKgRLYfKVO5nVY2QLuuqZOWDpsynHh49iiMGjrR9fPTxftxApnoNDHuIz1sEIkAG0T5zIynUwVtCzhQDw78ohW8iKWvezhd54TC+NmXVxa5oG1qBjcvsS5SFyjTy6A/82lKhDakXhYUrj1foyGIt4cKjps16xHdIf5xmxrrQZnIR6HsEBHozfhGZ5xeVKMoIQidZJQg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN6PR12MB2719.namprd12.prod.outlook.com (2603:10b6:805:6c::12)
 by DM4PR12MB6159.namprd12.prod.outlook.com (2603:10b6:8:a8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.24; Mon, 2 Sep 2024 19:09:33 +0000
Received: from SN6PR12MB2719.namprd12.prod.outlook.com
 ([fe80::1ab4:107a:ae30:2f95]) by SN6PR12MB2719.namprd12.prod.outlook.com
 ([fe80::1ab4:107a:ae30:2f95%7]) with mapi id 15.20.7918.020; Mon, 2 Sep 2024
 19:09:32 +0000
Date: Mon, 2 Sep 2024 22:09:21 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: David Ahern <dsahern@kernel.org>, gnault@redhat.com
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de
Subject: Re: [PATCH net-next v2 3/3] ipv4: Centralize TOS matching
Message-ID: <ZtYNYTKSihLYowLO@shredder.mtl.com>
References: <20240814125224.972815-1-idosch@nvidia.com>
 <20240814125224.972815-4-idosch@nvidia.com>
 <2f5146ff-507d-4cab-a195-b28c0c9e654e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2f5146ff-507d-4cab-a195-b28c0c9e654e@kernel.org>
X-ClientProxiedBy: FR4P281CA0049.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:cc::13) To SN6PR12MB2719.namprd12.prod.outlook.com
 (2603:10b6:805:6c::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2719:EE_|DM4PR12MB6159:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc8e322-cfd3-4468-6384-08dccb82c721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ejBkOWxFZkovWm85NWVEUzFLVzIwVW9LM3hUVHFpbjA5WmtsaUs4YU9OYmFL?=
 =?utf-8?B?QVRXenZEUnpyaFFoSm84MTMvVFlqcnBFbzZJUSt0cXhUeXBNOWNVVzUrS2tv?=
 =?utf-8?B?ZUpVQXVJa2c1QlpOZytKUFVDNkhCUmdZd2RoVEJVckVNRlNSRmRSVW5wRHlq?=
 =?utf-8?B?ajVjK1Evd3l5d2dHbFNYcGxtY1MvZlV1dGR4aXFVTHZNL3hQb1V3NVQzdnJ5?=
 =?utf-8?B?R2tHR0lJazZGUURnR2J3SmNnK1hnVWFUbDRPVVkzZkdMd1E0eU4wQWZ3Qkcv?=
 =?utf-8?B?dUlmb2kyMGZXeWF2K25ueUNMbXJJRTRjSUorUDF0a2RjSTM3NDh5cWk2UXMw?=
 =?utf-8?B?VUtXcW1XdmpjTWViVDFBcjlYRDRidFN4YmdWbmFwT1B0VEhIUzI1Sk0wU21p?=
 =?utf-8?B?ekZ0SnFCbVFXUzJGNUlxTGhJVU50UDFRNDNLR295Tm1vTmVJYXZWNFE2dmNv?=
 =?utf-8?B?OWpVdVMzOUFQYWpqODZjOEc4RkVvNUlPQllJTzQweEk5NzlMcC9QZnp5eXBk?=
 =?utf-8?B?VHZXMTQ4WUpaUjFGWk11OHBLOHgzQTR5UjQ5R282aCtiWm4wOFB3dFV6cCtp?=
 =?utf-8?B?Q21KRHpjNlJWZ2JxUGYyT2dCN1pMNXpDUi9mbVRsb1lNYjZMQXFoM29vcnQr?=
 =?utf-8?B?NnMxaE1OMk4vZDhueVpjb1NiZUZEUmhuSklMbXVSSUYzR256UlhDbVRDS1Bz?=
 =?utf-8?B?SFJWenRjWll3N0dGWVZaL1hZRGJkQlIyK3h4QWh5ZytvbnVLdFhHaG5OYVlK?=
 =?utf-8?B?RDhseTVmMWwxSHVSYXo2WXkvVjh3U3hWMHVSVmpOV05SZ05US2Rxb0FUbDJF?=
 =?utf-8?B?cWlUSnFxaHZuUkI5d0ovVnQ4WVNHU00yMHJLaktmSmNoeUVpajNaUHV1citn?=
 =?utf-8?B?YnJYRnF6NENuTU1DcVlmTFY4MHlYTkR6SUUzVVBZSUtvMWVGaDZqOCsrTGhh?=
 =?utf-8?B?WmxwZHJPOURMdDR5b0pyNlNKWVRmelY5ajhvamdwSlgvTDA1OHE0WndxZ1BT?=
 =?utf-8?B?WkhSQm55RHFqcVdiWDd4SXNTdTJ4Vm1YKzNtb1dlV3ltWmc5OERDWXAxUU9r?=
 =?utf-8?B?ZkpCWDdDOW1WNmplV2VDUVRuSVlHaGZWckNxMHoySWpCOTZmZmVUYmk1enk2?=
 =?utf-8?B?VmZtTVNnQk1hREpEMHdQblgrNFlxN1d3SHZIN0xyT3RHeEMrWmpEWmJIb3VB?=
 =?utf-8?B?MkJMWDBtZHUzMjhYa0RrMS9adDliRzhieG1kWjc0elkvV0RMcGV6cDZtdU1m?=
 =?utf-8?B?ZXU4a0R0U1VIckZ2UktJaW40RmlDMjhuSWx2SnJ1MFBYUnlIdnNuT3JTcFlQ?=
 =?utf-8?B?TUM3RDZMcVQvMjBDRnVYem05RkFhZUUrVEJONTFxdnhGQ1g2Ujlsd1BVMkdh?=
 =?utf-8?B?Ry9pVjk2NGhpRDRobzZqSGFvemV2ZHlzUU0rd1plb0t6MVZObkFDYU9sT09s?=
 =?utf-8?B?REx3N1pUUld4ZStSNHg0M056OE9Kb0k5YWJXOSttekVnejhGWjRYQWU2dzk0?=
 =?utf-8?B?SGtic2QxZGh3cG5VdnlhV0VrRndzZVpqTGRBdnJhOEt3MjJtN2FvVVphWi9m?=
 =?utf-8?B?N3FVN1phbEpydnQ5YnlubnFrRzF1YlNqYmpRdDZuSThXRnRBUXQrclg2ajZu?=
 =?utf-8?B?aGRzY3R4dkE1WWNWN3hxZmRFUVhEZ1ZNeXpWOXB1a3hhRWZjbWZmaVlRcmdt?=
 =?utf-8?B?eHU2NGl5WU45RkxmSk9vYWFhdnZnUWMwUDZRUWxaTTVYalpmK0RuU0s3UC9z?=
 =?utf-8?B?YjI5NmYzYnZoRmNRaXVhL1VQV1haM1hJbEVIUEt5bi9ZU3hORGRML3VGQzNS?=
 =?utf-8?Q?rKd8F4RFRkyLjA1w3tKtKBV5QZx9M4W7UL/mU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2719.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHh2eThZbGo5eU5RTG5CYmZNSEJ1Vk43eHhJYzNBWXNNSWluOTVNc1pxcVdP?=
 =?utf-8?B?ejIwM3JydjZ1Vml4ZTkxWDdKOXV4UlBKdlIvNUlNMzFIYWdWMERDRkkzRUdO?=
 =?utf-8?B?Wm0rcFVLSzc2SGkxNzZkbVc1djJROFJSMlNveDdGbFN4S2xUUmduUG9rSEdR?=
 =?utf-8?B?emNpbW5QY295Vk55ZlpFcGdXWEpmVU03TkR1ME1WOVA2M0RiemlWUzZhRUVj?=
 =?utf-8?B?QW1SK3h4bzZtUmJDc3d3c0xJWDRONFlvY1l4YllhM3NSVmpqLzNZY0dKRVFs?=
 =?utf-8?B?MnFqRTlpTUwwRjN1alRyMlVRTGdxdnN6ekc1VmtoY2dYcUI3cjIyMkswMm44?=
 =?utf-8?B?MDZSd0IwbHkzeFFjQ1hCeTBUZzNxWHNqRU5oT0VFU1hLeUZpWmpMV0VnKy9Y?=
 =?utf-8?B?NXRSYW5FTFcwNXpicit6YUNGc0hFS3h3d0Zmck14b1pqOHVrWURxaFRYSnNk?=
 =?utf-8?B?dVpFaERaT09FV0V2aXNwaDB6RGNNRE9RLytTU1loWEhxeityY2RBYTlsYWg4?=
 =?utf-8?B?bFA1c3FNWkMzRmUyZS9FT2wxYWxnL2tBeHRpMFNCaUdZS3lwbTRGbU1paUk0?=
 =?utf-8?B?U3VhZ0JKcHplbkFNL2NSNjdlYSt2Q2RSWmUrYU5saUxLRExZMTRLZGFsU3FI?=
 =?utf-8?B?dlpNYTJGNGphWURKNXl6b0pVeUZsNkNQR3RPNFo0M0hYRVFMZWFXSWhaTm9L?=
 =?utf-8?B?WDVCSno3dFFFSjBqbXpJa3VtNFFrejZBOEhIdkVUVUtSZ1Z3NUxMOUFUQnRC?=
 =?utf-8?B?OHVGSFBKeXYzUWZxM3BEcUI4cEl6Mmg2R0I1cUYxbFNMMERxMmVGbEFSR1hw?=
 =?utf-8?B?QmFSWjhDYW9xdEs5R0x3eVYwWWVLSjNHWmlRZ3B4UE8wRnBiVVB0M0dSdllr?=
 =?utf-8?B?a1Y5bTBselJRcmpCNXVabXFLTy96WDd6QmgrMVBvZVd0VVBRc3B1LzdHV2d3?=
 =?utf-8?B?LzZrY3lKL2hoUVovUnh4V1QvWm9wOTBrb1pnanFNUDlaQmtEZkx5aUt2UFBX?=
 =?utf-8?B?LzljQTBqc0d0eFEvaGgyZTNLY1Y0QURhVVFnZEJXdW5NOWtvN0liV1dSRUpN?=
 =?utf-8?B?NVNyelhJeHhydU55OVNCcUFQaHBRelZXOUpOeUdwSVlqczRKUGhVYlZ3K2FS?=
 =?utf-8?B?UGV6bjUxaU1wOThicmtYUEZFa28zYktGUkNISkhPWHBBL2JqQ2hpUGRSakdk?=
 =?utf-8?B?YXdLQm1SUFk3MVhtbGVBblVENjVua0liU1I1VHhFeFBXSGNOK3dCTWNmT2g0?=
 =?utf-8?B?QnBXVE13OTYzTW03WnJYR2VpcGlWbmRmSVlIVVhOa3BjTTBCdS9FVWhUN2Ey?=
 =?utf-8?B?Q0tQdEdEcEc0aEVCbytkQ1ZybDdOWlQ5TGhUaUhXZktzQlBwa1RBMmw0QTdt?=
 =?utf-8?B?ZkJ2bDRVdnJRUWZsc3MxUnBlRUZvcXZlaktJT3htN2Z3Slk0Qk0wQ3doL0Mw?=
 =?utf-8?B?SHl4VUx2SGF0MXBCQ0E4VklOdEs5czlIOVMxNDhVdkJDeEZPeDZaa0Zta1FF?=
 =?utf-8?B?SkJ3YjNVT2hHMmROZWlZbUhFRUZoaWxSY0FJait0MGhWOG9teVVReHVDRVVm?=
 =?utf-8?B?K3c1U0VTb3RrNnZZdDZNNHRZaURWK055MFp6bDF0cEpPcDZoUGNTd21VOXhR?=
 =?utf-8?B?Wi90NGNlQlU1RGRnZlRmM1A0UWZDZldTTS81VlFOWXl2MlZJN1JaM21LMmw3?=
 =?utf-8?B?UzZmRWZrRkR0dWVLNXhzZTJzUHZIaW40SDVET00rcWh4MjRCWmk3R0p0Y2px?=
 =?utf-8?B?dWhaQmdOQW5lTnpmdnY3Nm5QZUl6VnVsZ29TTXViWG1EbHhXLytZaXl0cFd0?=
 =?utf-8?B?WVR1NmJtUi9uWUpkWWNZblo5eVBxTkhISkxrczV6akxSSlBuenZ4SDc0N1dT?=
 =?utf-8?B?RmhXZE1hNW9EMW9wdGwrYTdwNHN0RjVKUi9RdXhCS3NXTko0UmVRNzlDVGsx?=
 =?utf-8?B?MHV3MjNWcm5wTG5vMWc4Y1ZNakhMWCt0UGI2TkFYejJZYU8vUTU2a0FqaVAr?=
 =?utf-8?B?SkN0WXlIVHNKQ1BGSHFDdGdlZ1hXVGJHcUZaNnFjYkNjZllwdWhBQXFIQllU?=
 =?utf-8?B?UGlyZkp3M293K3lmQW5MN1JSTzRoVFh1Rmo2a3hmZEEzQTlMVWNHMXJyK3VJ?=
 =?utf-8?Q?X1ka3Zi3RN2XCW77xpK/srzSC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc8e322-cfd3-4468-6384-08dccb82c721
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2719.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 19:09:32.8179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xy0hvcP0eNbFG+cShxawxi95pJKdG0BqhE/uTZhm0hMSOHo3zc9sJkhUiRixQVR9sbraDe2UAi06wOioM4h2Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6159

On Mon, Sep 02, 2024 at 10:50:17AM -0600, David Ahern wrote:
> On 8/14/24 6:52 AM, Ido Schimmel wrote:
> > diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
> > index 0cc2c23b47f8..10bdd7e7107f 100644
> > --- a/include/uapi/linux/in_route.h
> > +++ b/include/uapi/linux/in_route.h
> > @@ -2,6 +2,8 @@
> >  #ifndef _LINUX_IN_ROUTE_H
> >  #define _LINUX_IN_ROUTE_H
> >  
> > +#include <linux/ip.h>
> > +
> >  /* IPv4 routing cache flags */
> >  
> >  #define RTCF_DEAD	RTNH_F_DEAD
> 
> This breaks compile of iproute2 (on Ubuntu 22.04 at least):

Sorry about that. Some definitions in include/uapi/linux/ip.h conflict
with those in /usr/include/netinet/ip.h.

Guillaume, any objections going back to v1 [1]?

[1]
https://lore.kernel.org/netdev/ZqYsrgnWwdQb1zgp@shredder.mtl.com/

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 269ec10f63e4..967e4dc555fa 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -22,6 +22,7 @@
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/refcount.h>
+#include <linux/ip.h>
 #include <linux/in_route.h>
 
 struct fib_config {
diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
index 10bdd7e7107f..0cc2c23b47f8 100644
--- a/include/uapi/linux/in_route.h
+++ b/include/uapi/linux/in_route.h
@@ -2,8 +2,6 @@
 #ifndef _LINUX_IN_ROUTE_H
 #define _LINUX_IN_ROUTE_H
 
-#include <linux/ip.h>
-
 /* IPv4 routing cache flags */
 
 #define RTCF_DEAD      RTNH_F_DEAD

> 
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:25: warning: "IPTOS_TOS" redefined
>    25 | #define IPTOS_TOS(tos)          ((tos)&IPTOS_TOS_MASK)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:212: note: this is the location of the
> previous definition
>   212 | #define IPTOS_TOS(tos)          ((tos) & IPTOS_TOS_MASK)
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:29: warning: "IPTOS_MINCOST" redefined
>    29 | #define IPTOS_MINCOST           0x02
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:217: note: this is the location of the
> previous definition
>   217 | #define IPTOS_MINCOST           IPTOS_LOWCOST
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:31: warning: "IPTOS_PREC_MASK" redefined
>    31 | #define IPTOS_PREC_MASK         0xE0
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:222: note: this is the location of the
> previous definition
>   222 | #define IPTOS_PREC_MASK                 IPTOS_CLASS_MASK
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:32: warning: "IPTOS_PREC" redefined
>    32 | #define IPTOS_PREC(tos)         ((tos)&IPTOS_PREC_MASK)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:223: note: this is the location of the
> previous definition
>   223 | #define IPTOS_PREC(tos)                 IPTOS_CLASS(tos)
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:33: warning: "IPTOS_PREC_NETCONTROL" redefined
>    33 | #define IPTOS_PREC_NETCONTROL           0xe0
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:224: note: this is the location of the
> previous definition
>   224 | #define IPTOS_PREC_NETCONTROL           IPTOS_CLASS_CS7
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:34: warning: "IPTOS_PREC_INTERNETCONTROL"
> redefined
>    34 | #define IPTOS_PREC_INTERNETCONTROL      0xc0
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:225: note: this is the location of the
> previous definition
>   225 | #define IPTOS_PREC_INTERNETCONTROL      IPTOS_CLASS_CS6
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:35: warning: "IPTOS_PREC_CRITIC_ECP" redefined
>    35 | #define IPTOS_PREC_CRITIC_ECP           0xa0
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:226: note: this is the location of the
> previous definition
>   226 | #define IPTOS_PREC_CRITIC_ECP           IPTOS_CLASS_CS5
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:36: warning: "IPTOS_PREC_FLASHOVERRIDE" redefined
>    36 | #define IPTOS_PREC_FLASHOVERRIDE        0x80
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:227: note: this is the location of the
> previous definition
>   227 | #define IPTOS_PREC_FLASHOVERRIDE        IPTOS_CLASS_CS4
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:37: warning: "IPTOS_PREC_FLASH" redefined
>    37 | #define IPTOS_PREC_FLASH                0x60
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:228: note: this is the location of the
> previous definition
>   228 | #define IPTOS_PREC_FLASH                IPTOS_CLASS_CS3
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:38: warning: "IPTOS_PREC_IMMEDIATE" redefined
>    38 | #define IPTOS_PREC_IMMEDIATE            0x40
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:229: note: this is the location of the
> previous definition
>   229 | #define IPTOS_PREC_IMMEDIATE            IPTOS_CLASS_CS2
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:39: warning: "IPTOS_PREC_PRIORITY" redefined
>    39 | #define IPTOS_PREC_PRIORITY             0x20
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:230: note: this is the location of the
> previous definition
>   230 | #define IPTOS_PREC_PRIORITY             IPTOS_CLASS_CS1
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:40: warning: "IPTOS_PREC_ROUTINE" redefined
>    40 | #define IPTOS_PREC_ROUTINE              0x00
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:231: note: this is the location of the
> previous definition
>   231 | #define IPTOS_PREC_ROUTINE              IPTOS_CLASS_CS0
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:48: warning: "IPOPT_COPIED" redefined
>    48 | #define IPOPT_COPIED(o)         ((o)&IPOPT_COPY)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:240: note: this is the location of the
> previous definition
>   240 | #define IPOPT_COPIED(o)         ((o) & IPOPT_COPY)
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:49: warning: "IPOPT_CLASS" redefined
>    49 | #define IPOPT_CLASS(o)          ((o)&IPOPT_CLASS_MASK)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:241: note: this is the location of the
> previous definition
>   241 | #define IPOPT_CLASS(o)          ((o) & IPOPT_CLASS_MASK)
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:50: warning: "IPOPT_NUMBER" redefined
>    50 | #define IPOPT_NUMBER(o)         ((o)&IPOPT_NUMBER_MASK)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:242: note: this is the location of the
> previous definition
>   242 | #define IPOPT_NUMBER(o)         ((o) & IPOPT_NUMBER_MASK)
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:54: warning: "IPOPT_MEASUREMENT" redefined
>    54 | #define IPOPT_MEASUREMENT       0x40
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:247: note: this is the location of the
> previous definition
>   247 | #define IPOPT_MEASUREMENT       IPOPT_DEBMEAS
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:57: warning: "IPOPT_END" redefined
>    57 | #define IPOPT_END       (0 |IPOPT_CONTROL)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:251: note: this is the location of the
> previous definition
>   251 | #define IPOPT_END               IPOPT_EOL
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:58: warning: "IPOPT_NOOP" redefined
>    58 | #define IPOPT_NOOP      (1 |IPOPT_CONTROL)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:253: note: this is the location of the
> previous definition
>   253 | #define IPOPT_NOOP              IPOPT_NOP
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:59: warning: "IPOPT_SEC" redefined
>    59 | #define IPOPT_SEC       (2 |IPOPT_CONTROL|IPOPT_COPY)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:259: note: this is the location of the
> previous definition
>   259 | #define IPOPT_SEC               IPOPT_SECURITY
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:60: warning: "IPOPT_LSRR" redefined
>    60 | #define IPOPT_LSRR      (3 |IPOPT_CONTROL|IPOPT_COPY)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:260: note: this is the location of the
> previous definition
>   260 | #define IPOPT_LSRR              131             /* loose source
> route */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:61: warning: "IPOPT_TIMESTAMP" redefined
>    61 | #define IPOPT_TIMESTAMP (4 |IPOPT_MEASUREMENT)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:257: note: this is the location of the
> previous definition
>   257 | #define IPOPT_TIMESTAMP         IPOPT_TS
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:63: warning: "IPOPT_RR" redefined
>    63 | #define IPOPT_RR        (7 |IPOPT_CONTROL)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:255: note: this is the location of the
> previous definition
>   255 | #define IPOPT_RR                7               /* record packet
> route */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:64: warning: "IPOPT_SID" redefined
>    64 | #define IPOPT_SID       (8 |IPOPT_CONTROL|IPOPT_COPY)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:262: note: this is the location of the
> previous definition
>   262 | #define IPOPT_SID               IPOPT_SATID
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:65: warning: "IPOPT_SSRR" redefined
>    65 | #define IPOPT_SSRR      (9 |IPOPT_CONTROL|IPOPT_COPY)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:263: note: this is the location of the
> previous definition
>   263 | #define IPOPT_SSRR              137             /* strict source
> route */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:66: warning: "IPOPT_RA" redefined
>    66 | #define IPOPT_RA        (20|IPOPT_CONTROL|IPOPT_COPY)
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:264: note: this is the location of the
> previous definition
>   264 | #define IPOPT_RA                148             /* router alert */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:77: warning: "IPOPT_NOP" redefined
>    77 | #define IPOPT_NOP IPOPT_NOOP
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:252: note: this is the location of the
> previous definition
>   252 | #define IPOPT_NOP               1               /* no operation */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:78: warning: "IPOPT_EOL" redefined
>    78 | #define IPOPT_EOL IPOPT_END
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:250: note: this is the location of the
> previous definition
>   250 | #define IPOPT_EOL               0               /* end of option
> list */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:79: warning: "IPOPT_TS" redefined
>    79 | #define IPOPT_TS  IPOPT_TIMESTAMP
>       |
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:256: note: this is the location of the
> previous definition
>   256 | #define IPOPT_TS                68              /* timestamp */
>       |
> In file included from ../include/uapi/linux/in_route.h:5,
>                  from iproute.c:19:
> ../include/uapi/linux/ip.h:87:8: error: redefinition of ‘struct iphdr’
>    87 | struct iphdr {
>       |        ^~~~~
> In file included from iproute.c:17:
> /usr/include/netinet/ip.h:44:8: note: originally defined here
>    44 | struct iphdr
>       |        ^~~~~
