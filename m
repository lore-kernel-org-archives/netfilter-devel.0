Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2117.outbound.protection.outlook.com [40.107.105.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692F56CDD7
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 11:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.105.117
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710415844; cv=fail; b=g4UeT4p21tqhojUvEx5tMAY4a5jWcGFavqpkOdY/jxwXx0+cmp5OnTbAYRDxEToewKHd1CkHIUFDhZ1S6h2Xu1zkTcEeCRdBjLQPqNuPJunKFBl1/pBUxwZmZQVcqyQ1/7UV62dXD/XcycPxFfvZqeWU7oK0o5dR7LKi2l0l+Gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710415844; c=relaxed/simple;
	bh=+HJjy36b/CKjtS6M0ZOuibDnLIWgCOT+eOOkcRB8VHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QyshpD1T2oNQpVzh0vdbKvi5J8zz33P9FItlw4BSkxPqKLBlSnK9J8fAjQvijRNEpdiXAJBIAy/JOI075QucnPh77ofKnfcy2p2so0aE6jJIsMBUhLiXpXgHZq3uj3tUhSmfFv6a8WR3gLabdeHipWJvo1vfMQgYKiKwuyvxVWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=hVp6IZS6; arc=fail smtp.client-ip=40.107.105.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="hVp6IZS6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4opZ77pvDnekWtEZQv/fLWVymNI7sdqjaRujd/xoSUbl24nG73Qrg76ic+NFggmuONLB3I7DvRap3dT+Q6d+elq+dv3LTpUwECmvNSKwutdakYZFtPATPFLBACO/SyHORykXzAJW1QbiVGV1yLSKy9/AYxxJeSWd2Y4flVjia9rXq53UU+ifw/X0aToC1cApNcCiHl+Oxz85Xt3foKOZ7aZC7NNTcEi01+z9jT5hMCXiqT3Lfa0g/5vEFN+Tdy6oStR185glQxC2JptqR1DdE2ow1j7CsxzFS3S2F8z2mrCs4JfSlKgvQ9PqUGoxG9QkhxRchOYP3i8IDH0JvD/hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y80eojrxxN7D7uW8WVLZNlnGdy4etElkKxhX4kAMrII=;
 b=VTQ2zjHAWfCX8dPuAE+KJHNKBfrACQ2gr2hLda9hoSYAAKBhTByGqanaEtkZ0dORNoCCxz/rF6GGkf4waB9kiog9bDyv4GejGj5QIgsqcTRX2YJfpn2E1fF08E8VlOY5APrxrOe96xCp5TN9WUcbPzxtnLW8xldUAEhFQVKUYE7GuzQVQtsbFUPzNAa59NU9R+IujY/wAFbfEES8n7rjH6daxoXHJTCwCqzU9HVFdF0In/hH3kCoKgNSA0wKqCBqRGK9TKFCsZZgwUCGDNdi3PObhfsBp5vfpZp1so+FL8P9xRKuvEcfZEShvxFVB7ccfnZqfQJo0xQra4X/vBTHlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y80eojrxxN7D7uW8WVLZNlnGdy4etElkKxhX4kAMrII=;
 b=hVp6IZS6y0yCCTuyelV6jnvDxsv1iVOaPTpk/IybqN5kJcEoXpsl1k7EcJZPREh4QzBSyNkdwV632V4DEfO+UTqfVFTAN1SJb/UQlUAoixxKoEPmciQU2zJ8Z8IapAScjSXSs5HUM/ri97kQ7VtChDl8upJRYacwFrkIz9OqAK8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by VI1PR05MB6686.eurprd05.prod.outlook.com
 (2603:10a6:800:141::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 11:30:36 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Thu, 14 Mar 2024
 11:30:35 +0000
Date: Thu, 14 Mar 2024 12:30:30 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Flowtable race condition error
Message-ID: <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <ZfLc33WgQPKdv2vG@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfLc33WgQPKdv2vG@calendula>
X-ClientProxiedBy: FR4P281CA0255.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f5::18) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|VI1PR05MB6686:EE_
X-MS-Office365-Filtering-Correlation-Id: 9904db6a-6053-4aff-ffe7-08dc441a2a47
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nSsXeKdAR0RAveV8O3IygVNHp3kseNdU2vIcHK2xX368fuY87rhoPehLFTDTqiIkgNZIbGxJrKepaCSACB5UCG1YwwIQvR9RSJyWeb14hTi486l4U8bUQMcpVst4q/bZGTD6ro4HhW8x5vNj+NnQ1MvxHP/VPOeOH6/bjZsbu81/DQiDL2cJrBuVswZgZV0UXjfOB8nbgjJviVDhsMnI9QtKBo+6oYv+/T75U7mjQcYw1u2pRsW9gzfY6atK5HOQGqSQhDEzxl722g1OUM2c0Od9fCAVAMB8Nl7rqybMVuGiQ5+Su/bgkA0hkXwT2nfQJ8B19OoRzrExoKngYeFifH9JI1ZogPse5qgLWXxzliJJCmoQIVzGtc4Yb52e9sjm4B1wqLN+D3DL+ZER3gWKDfWYN+9HmiI/kQzz8rX9kaFT7hvd/+/f7F+dQN5SMu2EzhJKOwNMTicHB2pq1FMM7Qual1GPXzkgM+5aC4kI8ZOQ/O7VLpbghBeds4L9hbWSOpIVWTyV1wccyhqZ5ADKVfyQnvEGz6w1NISLOwwFv0PyFIs7Q0PHMuYx1rYlS5jeIv0MaRcKgUFJ//VC6oGj2jRUoc15yx3YJf4xdFgdIXv1cAYdsz0RQnkfPXxOPMzWNEHpj9a0iymLPgV9oQ5IhnkagXisOCUQlV4eNVw8v9g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pz+nlasdOc++FlymgXU3bSusqHlzPaFxL6zZ55K250WEQrG8rzjwh+TghMmv?=
 =?us-ascii?Q?fTW7NkUqHNp8cyOehokgKalBRaiLb1RUJqMubbEj0WCGvm7VVCI0aQg5BmJr?=
 =?us-ascii?Q?QJpcPZERaXmFr4eqUtoDiwKTyC2cqmS7YQ1DBe828hvtuVbKaXSuOGB7ct0K?=
 =?us-ascii?Q?J1Kx0orOtws8ixjjGSGRsprQNJwAUY/vLRtljjx3xG3TtUhsfEpi1LCBYvOK?=
 =?us-ascii?Q?zyAgjiKjeV1UHlX0a0+xYG3NIZHZiZs/sgqs5wgSSh5gFYBuGqhh1U80AJvR?=
 =?us-ascii?Q?ZGbuDYjNtT5b3g4oehdJosjgn4rytrkyKxkC6eugZ1kLRj6N6WJNHzK3wsKb?=
 =?us-ascii?Q?jg/DRUzlTsqxkGID8Z/wxvC1jB7noCtwJf+0TK46R2iVzBC28LmOD96Buwe5?=
 =?us-ascii?Q?WXTJY1VR471UWGtz7AKPbyNPrRCwlkdU84n473ROTns43bulvLOBvt4JBXFA?=
 =?us-ascii?Q?AYy6VAkOoFQmiwWWxElnaqruMux65Ul9cnKrfLQHCx9Qhcw/4NwsIRSGE+eV?=
 =?us-ascii?Q?43hcRoNTkNUNvpunNTCGrFk/H/AhJwgytsTg+oHFgo/MxZmFt0x11qTkre5c?=
 =?us-ascii?Q?bSPGDp0ute+R9O5GeqOKo/MIRtekY/qIr78p44hqQ3tS71jUboO+BCL7LsYg?=
 =?us-ascii?Q?4JglvWYeVnt2gSFE2vnGFO3yPwGIsbb/RfZ0Vdkuf6V8NN0pkxoEJ+4gCgVu?=
 =?us-ascii?Q?Uk86yZdAANDWP2+Mihi5kGFAraIE0vwZp1DnSdXCSXkeJHFDTddViim81V4i?=
 =?us-ascii?Q?YUNX234tBfZ2zu0W22GEXIn9em6hqeOQxs/0EyRU5couHrS3euZ2x2Rnmmjj?=
 =?us-ascii?Q?dQsyxWNCb5aC5eX/wDZ1QGI7kX4XOwUoPs31sEqzo21RIxcDQUZJL+YU7vxG?=
 =?us-ascii?Q?oJtSprimXM9HolcSklxS9iq2aIXkaET73wSTA3fBsN82+ZRw+Df5vbk89jWs?=
 =?us-ascii?Q?CLm+q/XbN9F+Sd3OluEu7GWqUVz2WHenfioTVCeBlbdOt4EnWahJKRszCPS+?=
 =?us-ascii?Q?p2vUFSa8BeFP2c3GJrfdaz6tQwIEVrv1HXku4KcqLzt5GDYJqV2bLMOcMBp5?=
 =?us-ascii?Q?nmB9yuyCEF0+H7RSKsYDAdt6ZzwfFSWOqynt0LuZ0vMPZ0RRDgkymwIzS+fT?=
 =?us-ascii?Q?cR2SSBvLzeMVIvIuXLQStOhd5+ZSmaOogxbMz2MkSHRxMaFKMEjp2NuHzrPC?=
 =?us-ascii?Q?D8NnfGp447sxHJcdkQNBbHevC+3tQEq8zajCAnujLiHCKUibzRvCyOBXD2qX?=
 =?us-ascii?Q?2dwZyMgaDnG3EFyJmi1YmZTGELv/kQNqCyT2ZlzE2Gj0qC67Ashk4TFN7t8c?=
 =?us-ascii?Q?H7v1L9Mt7nGvF8n31cRvW7EkhmBiD1zPzSQLzjOXY7YLXhvjWRyHB2xOkjDl?=
 =?us-ascii?Q?pIq2hh4FZ8hi5pgqdzcY2tZ7fmNAD1tbfhtASrR207E9GS7VB1p/jZ+XsxT6?=
 =?us-ascii?Q?Bd8/YT3VcbIQEN41aM9sgTftCBXp9Ikp2srmQ1teaNd9eKyW1PHqOVjTXV42?=
 =?us-ascii?Q?eIPNxyFkg9j1U71Cwcv5EiCIFAKJE/BHrktD39/t4aQXU5t0JYxd3OXFecyy?=
 =?us-ascii?Q?ers3g6SiqOzfyzLvs6zuQvULG5G3jV7omgnm6t+jkGVGQcAGONHepz49nIfA?=
 =?us-ascii?Q?ZA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 9904db6a-6053-4aff-ffe7-08dc441a2a47
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 11:30:35.0941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05Y03HlUX529ZCQJYL7kCh433b2glcEHkVPU88NK8Ds5/cEprL6cJ1OSHTsTFYf16pfwfFebRvqjfIE7S2OBI7uyrXxxztyx6pR6plkz46c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6686

On Thu, Mar 14, 2024 at 12:17:51PM +0100, Pablo Neira Ayuso wrote:
Hi Pablo,

> Hi Sven,
> 
> On Tue, Mar 12, 2024 at 05:29:45PM +0100, Sven Auhagen wrote:
> > Hi,
> > 
> > I have a race condition problem in the flowtable and could
> > use some hint where to start debugging.
> > 
> > Every now and then a TCP FIN is closing the flowtable with a call
> > to flow_offload_teardown.
> > 
> > Right after another packet from the reply direction is readding
> > the connection to the flowtable just before the FIN is actually
> > transitioning the state from ESTABLISHED to FIN WAIT.
> > Now the FIN WAIT connection is OFFLOADED.
> 
> Are you restricting your ruleset to only offload new connections?
> 

It does not work to only use ct state new as we need to see both
directions for the offload and the return packet is in ct state
established at that point.

> Or is it conntrack creating a fresh connection that being offloaded
> for this terminating TCP traffic what you are observing?
> 

I can see a race condition where there is a TCP FIN packet
so flow_offload_teardown is called but before the FIN packet
is going through the slow path and sets the TCP connection to FIN_WAIT
another packet is readding the state to the flowtable.
So I end up with FIN_WAIT and status OFFLOADED.
This only happens every few hunderd connections.

> > This by itself should work itself out at gc time but
> > the state is now deleted right away.
> >
> > Any idea why the state is deleted right away?
> 
> It might be conntrack which is killing the connection, it would be
> good to have a nf_ct_kill_reason(). Last time we talk, NAT can also
> kill the conntrack in masquerade scenarios.
> 

I found this out.
The state is deleted in the end because the flow_offload_fixup_ct
function is pulling the FIN_WAIT timeout and deducts the offload_timeout
from it. This is 0 or very close to 0 and therefore ct gc is deleting the state
more or less right away after the flow_offload_teardown is called
(for the second time).

> > Here is the output of the state messages:
> > 
> >     [NEW] tcp      6 120 SYN_SENT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 [UNREPLIED] src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
> >  [UPDATE] tcp      6 60 SYN_RECV src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
> >  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> >  [UPDATE] tcp      6 86400 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> > [DESTROY] tcp      6 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 packets=10 bytes=1415 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 packets=11 bytes=6343 [ASSURED] mark=92274785 delta-time=0
> 
> Is there a [NEW] event after this [DESTROY] in FIN_WAIT state to pick
> the terminating connection from the middle?
> 
> b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or
> FIN was seen") to let conntrack close the connection gracefully,
> otherwise flowtable becomes stateless and already finished connections
> remain in place which affects features such as connlimit.
> 
> The intention in that patch is to remove the entry from the flowtable
> then hand over back the conntrack to the connection tracking system
> following slow path.

So if the machanism is intended as it is then we need to make sure that the
timeout is not so close to 0 and we life with the possible race condition?


