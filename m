Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D3B3218AF;
	Tue,  9 Sep 2025 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757416667; cv=fail; b=FCbjs7HBeINJ/dapAzSMOV563Y2k/yWC71c0IK9u0ee0k/yOvWHGboBhdGeIQGSdUdAP3XkChUM0U2aTvllG/lPPyIRiMa9cSTcPH85XUrC6DVYPfn4ymPEjSVEmcxDTBSCuchWDhH0RsUBIlDPr0MIwwbdupvWAIDQCR+lCBkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757416667; c=relaxed/simple;
	bh=KIlxhn1HxKA/7JCnzpk7kK4pUAcKt1qtxKiifdcwySY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gT1lNWxQGm4U15qjsH9a6itIl6wCbhrDRPxTm3zYNQ8nlEyXUJLuEJ/81h2l1C/PCXUKzNnDWW9bYEEOZh2xpvui4hmh5tIbdP3Txzw3yZryQpeB1f+UWZxxu2EDxK2Ud2rMRr581BH4x2juk64aT+YUem4XW1SGNmHapX2UA7o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sBX8sq/2; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sBX8sq/2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pi6VF02LzzlPVAPJcw5s/GMfbB+oVagN3wz/pIov0EOP8TqHJoNjlQKITh7UQZtcbZYeUVxUJjOrq3F5e86Ay0SkHlVnPr4elHHE2obQcfchgFBk7oIx49nrDZiHQSN/fGRcjczonxlkVfdaB3I47nEyb1cUWpBAVr/G2PDLIy8ShPASSwfsGLf+eu85xKA7+DPqQ79Rjs3YSAzp8TbzMoqRj3hlVQRxElyBu9JROCC/x3q4D2PgBoNx9ovB2fT8xSu1W2OWLtj9oWlGZco1o47P6peTVh1W3E45VobcU7B3uzBQ6I0bT1vTsaaNwdjnAHAbEXaYT4hLDByBwml3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krgrQEp493op32mqTi16wBez4LfuHIUfj/yn4wqYVCI=;
 b=va7hMSmjfhCtFruOzn6cdQ+fp+ZqhIjodJf3lPCxWX0P4IShZnAcA6be4k6PC7m8ZLwJRbefFGN04DWPKj0MCHu9JYeHfoBBx1BjE1ncyjEkTyXuHzy2p10IUzJMZOnMbms8xhLAbhFKLiWfk3fx5wv0B3gB6kP6Flmy/CNbOr11AoLGWEoslm32uTBCdlLVjkquozBEdLAZ+LrZ9FmiKC81XW8S9swyYjjfJaevc07V7GKUzSbnXqG6+DOJ3DP07dxmsLvuoxcl+BDeKml+4tkxK62z32cZsSkPBQgDBCOOvEkut1j7vbtfWXGwtJx0ABNBXcb65kY7Q8tdw3Y/lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krgrQEp493op32mqTi16wBez4LfuHIUfj/yn4wqYVCI=;
 b=sBX8sq/2tZwj3sMvoBe+HR+eGCSTlbWMb5HVcelDopDyZkUPDC4CfRBjfM0mjiMdVwHWRpeuxDgR3IMMUM6oDH3OKcUebFl5dtbyW0btR/SO3bB+M8LN3SF3uUik5pv2Tjgq2ujMjrLX+A6C1wca9iWUGOLOvl9oNRt0PSbuN+G/LdMVYs5ELnfSifdy3jhloJQemWJsFPZXHZvg/YHpMYPsTGONlDebd0GQ1rM2azHxYCpT/wjxerouMiVoXTB44QlvGRKyPJLp+S4BP8GRO8JFFI5ymqI6d/JVTLJUpWv/+ZPvSomg5YQOy6bSV/xP+Dof8nsE4KorH7PRer42iA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
 by CYXPR12MB9337.namprd12.prod.outlook.com (2603:10b6:930:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 11:17:43 +0000
Received: from SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2]) by SA3PR12MB7901.namprd12.prod.outlook.com
 ([fe80::6f7f:5844:f0f7:acc2%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 11:17:43 +0000
Date: Tue, 9 Sep 2025 14:17:29 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: syzbot <syzbot+aa8e2b2bfec0dd8e7e81@syzkaller.appspotmail.com>
Cc: bridge@lists.linux.dev, coreteam@netfilter.org, davem@davemloft.net,
	edumazet@google.com, fw@strlen.de, horms@kernel.org,
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pabeni@redhat.com, pablo@netfilter.org, razor@blackwall.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bridge?] [netfilter?] WARNING in br_nf_local_in
Message-ID: <aMAMyaBrrUGGFbY-@shredder>
References: <68bfb77b.a00a0220.eb3d.003f.GAE@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68bfb77b.a00a0220.eb3d.003f.GAE@google.com>
X-ClientProxiedBy: TL2P290CA0024.ISRP290.PROD.OUTLOOK.COM (2603:1096:950:3::8)
 To SA3PR12MB7901.namprd12.prod.outlook.com (2603:10b6:806:306::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB7901:EE_|CYXPR12MB9337:EE_
X-MS-Office365-Filtering-Correlation-Id: 7da4b11a-192e-4d03-470b-08ddef927eff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SHzT3Or+XyONQQ1+r22bEPPgg6c/H+hrjg/QYp7KTqHVCot6tOvjx4fu4AXS?=
 =?us-ascii?Q?57rwbuwB+cGmog9eJtu0hXQ9hLXgw4/ZMfT2w79D1+FBb2WNWdft4hpmIBa5?=
 =?us-ascii?Q?mMgN5QbHasJYV2nMSexOQicBCNF9U4MbkutLb4U6WOSFCishlpbLLCPMDxeR?=
 =?us-ascii?Q?GdzXXWQ1Za5uRxXirKcSta1x/DU1z47YBZ4l/amHxSQNU2+D/3FY20fEZvkg?=
 =?us-ascii?Q?Rzpl0K1Q1uLqlp2jSY48Cqa6D2BE+OCfvYQtpygAvF2wt52/yJbG594sVdDF?=
 =?us-ascii?Q?vAQdHsUf9JVs8J2MIKZetvywYxG2jL5WM6QPWGRGUqTwj4FnDTWcGgATGe4H?=
 =?us-ascii?Q?7YDbEC2acs+i3cy//TKymMDP3HYnZFTbeUPwPnoHSGKJHqtiVMcgjzduCiTz?=
 =?us-ascii?Q?r0fq4nLLSMtPXaiwL0fkFbQ2ILFu/2EXByMcmrs4/KzG6p1P7N13SfB43gUO?=
 =?us-ascii?Q?i5xTQZaDbidsaOzInoxP3R5O9AZUUaRz738Nx1QRN80GAiu+0OrIUKJH8RVF?=
 =?us-ascii?Q?I6YgeT6RnUMLXZWPdKsPJ70ghdvtsQJvqVZE95RneDesuG5cqaquUJPQ+o4a?=
 =?us-ascii?Q?Gxqx95GXWlC41eyUMf61T5Ec9ZHbwlGzDYrYmJYY8/ewaVmMf7Qxt68+j+rd?=
 =?us-ascii?Q?HuQNmyOJKXa6BvOEr5Su8Mb0OUcXc185ciS8hegcuC/eAvmplonfOvp3Rhay?=
 =?us-ascii?Q?u0hR34ZTqlf5chx0/l3p9Th3mDuS8NGju0DloCrdvpfA3SsGBT94985cCsQW?=
 =?us-ascii?Q?0R6R0sqg+U4FMvT3fb3OaJu3k67QJ24xj6bMIEQofNIFFCU8I6f8dvF4oKy3?=
 =?us-ascii?Q?trHBgdDKSD0s0k7o0KtxLZJyTu1qC29jKOwaA0onkWMdLEvRp1IzgxOg7s5p?=
 =?us-ascii?Q?VW6/Ekidp6F+9ehqlbjOO/yVs+39R9ZqjUEqLje3ZVEuX/oX/8ccow/kkrXC?=
 =?us-ascii?Q?PSTEYa/wTwAP2y3EkGnZNyt9X53W281xP6JWlj1VZ12GeKb/hA9g2JxWxEUf?=
 =?us-ascii?Q?T6F5hzo7J1yvQH3zbIZwtUnW4F40GOBTcUisFvxoGKvFCiSS8D8Cg87W0bL7?=
 =?us-ascii?Q?m9lIjDeeozSy/x39yQxHTOU63UEYWMsPE3L0QHY8TH1RYtyldnzJ0Dvj5aeg?=
 =?us-ascii?Q?2jpZDW9ORiN/QADGyswlm+Ok8FSRjGVC31JW9SofGGZSEK0AaEGZdsgfd6CO?=
 =?us-ascii?Q?hfYTETzS6S9Sj9gLHe+UL7J1a1QNH9WHBGdqY+43KXBJjR9QXcO+XcuMKJI6?=
 =?us-ascii?Q?l9lokWTBk5iIdO1rUh8fYCmQgI5+XkVctRaO8JN1hXmErkTAUzo2yOJYL4IA?=
 =?us-ascii?Q?QXuwXQeOIfjCq4hIkSawA4xZ5qm/eBLTBpx4BU3NzzHHhlH85Uy9L27lW6Gg?=
 =?us-ascii?Q?Bj48MsEY/1l5+uCvPreT2cDeePmAV4guzdnd8DGPbgO/j+7cymEwkqxTcH12?=
 =?us-ascii?Q?hZdHYI5/M/k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB7901.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pReM77a6OEx2OGEhd3KQhrGelecAq2pOBPpQKmwSFzar9CTxudjYNahgsdiD?=
 =?us-ascii?Q?WIkjl+Osg++1hUOKOZg0ZybDMcUZf4pjqZeUIbl5/0HdHnzDsdAwVKQp2pWl?=
 =?us-ascii?Q?De4Dhk2P9esIkhibAFPDkEiA+3HPNoszJo192XYUpAD2DPwq+IMz6q42NasT?=
 =?us-ascii?Q?MNzIsLzP8jHNeeqiR80vTb1dQE0EZRk3TfGH3GEtx6nE4HtLHDoTAUcNObRo?=
 =?us-ascii?Q?4BLD1UFKYzIt1rF8Ef2pnnZbZsCpOpU66atezhgRgfgPPz39+bWRljrEu2EE?=
 =?us-ascii?Q?QL8lDDqd+aooI3JNgrKCxXU5oemlACKPcYcNuB5JxGNDC+8A7SQw/lsb4oG4?=
 =?us-ascii?Q?9rPvm5yYdy5ITXyM82H7v5DOeRfSbTPh3JQYaVt3m+w1QhTBWKkGdWbR4C08?=
 =?us-ascii?Q?X+Uu9dqfJDscCDWhe6N6pdth2r7wG7bvisxPyRBF/m1YG6f5YsIVbu3vmehB?=
 =?us-ascii?Q?UgUTTv0kG4R6L6dwiGmvjYG1scpcTh1RSyELeCAJ740W3WyYq57T/lWvwItM?=
 =?us-ascii?Q?SfEYDqjl6dByldaF529JtrxYDS5UishEWAZysh7JZxO3yhPin5290h2b5JIt?=
 =?us-ascii?Q?tY00+0RYmqUiSZFRgqkX8IsGXj90w0lzDvzzMWebJGOHAIm/faKSIBWjmZhE?=
 =?us-ascii?Q?NOELmVRoefP5RtzrogVB61op6RyLdGP/fa+na5kzZzuyXhMtzgr6/826Dnd/?=
 =?us-ascii?Q?OMMhPDsx3QP9KWueJf7I/BuVZ6+E2v2ODxSaG9rkstiFB7rnIDp92p5V+LUV?=
 =?us-ascii?Q?NUfyO/6AssBB3rrOQ9er+dbmZbuy7rEZUdQu0n5z3jGTPdBQODY00nFXGKMH?=
 =?us-ascii?Q?BY0zNmqQaKETSPyHyb/eO8P1sXo80j6m7GUTUEY1Et0XMZBBEuNV5gOj7fyQ?=
 =?us-ascii?Q?AeHHeTnldsgrmnnYwzWeIxSidWijptKBQch2jM54ekVMLbOGkcUj0C+XEalm?=
 =?us-ascii?Q?Ha+scrqRIVn9fuJfl64O9X/D826NV6saVd3r0o0wg6UnqCVv018osQVyjwxp?=
 =?us-ascii?Q?1qUDVMKhnjnqsuZuCJ7GbZNP5Yww54urP2qNPMZsf8AagMUwoWR3aKnObCnu?=
 =?us-ascii?Q?VW166QsmHxxdm4/3JjVldKPaUEQrorNIy0SrRszCiK11SWjatcZzfJ04Tj8Y?=
 =?us-ascii?Q?UHEC0EdIIv8Gw5vj9xuKBh7iJesKRDmob20sJFVCrYZ0PCBXuk7G6yV54OMe?=
 =?us-ascii?Q?MG6r9vYY7sQeobj1D6juJKaXgeFq7lqFNZ1GCjyVXEcAajCzsxyfkK4k/y1d?=
 =?us-ascii?Q?Az75VoKO/SzfzJqSpPIpSpn/SFQPbZH767aZxq6bGaRLcT90tn6ssVqOGhOq?=
 =?us-ascii?Q?I7CKSHwaFfjiuNHkMHNEnVJPg0/Jxm+7o9LtO3GXSMdYJa5w5+4wfyd9VNER?=
 =?us-ascii?Q?trnBlVoUwfV8OCdfGfcnkI1dDt+xx7GwGiCYE+hAXJSrm/lf9zw6jOAxAv/7?=
 =?us-ascii?Q?HBuhq98zH0XbdZOkT5vU5cvEYuN0guNEbDK8ECy6vNxDaAgbPwxvJ2qhKWFt?=
 =?us-ascii?Q?D2wqLcgDCzN62nII1bvhAR65TlutsPwzOVKdTZw9LhVs4K5ZUhqKA8C/OoOv?=
 =?us-ascii?Q?//fuZbj7vso/8sHxzLpJSBaB+SJCDQTQ0QVAwwqJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da4b11a-192e-4d03-470b-08ddef927eff
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB7901.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 11:17:43.2574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMs/kw0N/nkeMKeC0niiWyWGSUbXxHR+ThHTLDj61fgC0l6Xu9/2r9WysLEHxoMw5X3GkP54dCtoAOv0Uklcxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9337

On Mon, Sep 08, 2025 at 10:13:31PM -0700, syzbot wrote:
> syzbot found the following issue on:
> 
> HEAD commit:    08b06c30a445 Merge tag 'v6.17-rc4-ksmbd-fix' of git://git...

Doesn't include this patch:
https://lore.kernel.org/netdev/20250827133900.16552-2-fw@strlen.de/

Which removed the warning.

#syz fix: netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm
