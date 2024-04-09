Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2100.outbound.protection.outlook.com [40.107.104.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FA785636
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.104.100
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712662524; cv=fail; b=iDeiSAbbKuEDLICxPgiS7Ns+lYd2ts6GUI88+aG6+GlZpDDZpcabHODRvjpiZh2+lGjxiH1L1woImd6TCkGrtbEaZ/Bc7mXD+qBWVnDaLdv87a2kM1yJKwhxa3sLVYyUHX7GG9GV8XpmYasTwjW8B4NRyuMIuU76H4RwVCrbQMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712662524; c=relaxed/simple;
	bh=mcpXKxQFaXBLlJ/qraIMbcz9C+dyLn8Sf/3XbDqGhB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oS+Ip4jYUAML3rn6rVJ5OWj2ZUZ0qbaZ/4oYe240YqAuz339CWsNgOGWq4HkO0Asl9VFN4O7zcou/qWjFuXl9y1wT6tNmCmtTQyvqPcp9CznAUqfASyVLgT5v5V1VHh221tuj2v9kf+46anZy14Nqw2RMuZvQODXx7agq0a6Q8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=AQBH2RnC; arc=fail smtp.client-ip=40.107.104.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="AQBH2RnC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eBCXck+Ex7h+raDjzQeREkHXSUXP+Q03jTxfCWHWLNa3PGcPkltao0fdqyxZmqT5aXrFCKWeVd3oqTA7350rcpXqiAwzRQwfDzsblC392tYPV7jANfMFC8q1BJybxYaf9qTcCNV6/HtMIYWckSp1H+CG4/wFw5JZeu17gvZGDHWd0c38a+t2QHhk4J4XRGI4ZAbU3zLH+oRyCLQB0F5Nt7kqRbViEP43SK2n1QDtsjXD6ZrqchPsIRpX+w7z1Auk9SuhYoKE/yduV5QA6hQQYIRP0Db8zEU6XVMmBWk3mDb3IuW5Ar3R4JfPFZjl58t/jmFs7b0B9w98S6zzpTlqSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6paOdt5Caktb6Ek4/zbHnFIQWD7mMVo20HkzDCkJg4=;
 b=nRGlTrnYrMtUkgri0QnbGMsJ33YtSBApdLbhbqqi5qZrWPvgrdQ4WSdfqvHon/KTPqyB/Gk8yDxVP/kYmLrJyENugXR9ppWzolkpFCM/aQtzUBE4KET6t1pATTUuZ66jjvTQEXP1t0zrDVZuhld9mgKN9jWRLBS/BaVazuaauQN594mProjVhGk95EkR0fX01Oxu43JqjMVuCJU2Z76yNtap2oTxPaFv+L//U2mQMCtld0YxrE7irvxXjByvt7Qk8nwTsR976x0Gjrp+JPladtOmC3xzX20gCJba2sQ1myCRpup6HhAqmNNYZRi8PJdsEgPw8QXVrBchFjmeAZ27tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6paOdt5Caktb6Ek4/zbHnFIQWD7mMVo20HkzDCkJg4=;
 b=AQBH2RnCFd6z+EBbY1+CZ6ZsYrcmIJ6rpqAn/CL4ImfrHC7azBLQn8IZU+WVSNBtbuJ2igFpwC9NyYkgDlaAlTNrqO+2iBM+iYy2raN0rHMK3QpO2M3M0K+oyjHnZe0CIxD6qI9/OBQ07MSrFuSEhjdeyFhAX6XIIl7vwr//cSc=
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com (2603:10a6:10:538::14)
 by DUZPR05MB11041.eurprd05.prod.outlook.com (2603:10a6:10:4d8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Tue, 9 Apr
 2024 11:35:19 +0000
Received: from DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086]) by DBBPR05MB11225.eurprd05.prod.outlook.com
 ([fe80::eb7:22e6:e723:9086%6]) with mapi id 15.20.7409.039; Tue, 9 Apr 2024
 11:35:19 +0000
Date: Tue, 9 Apr 2024 13:35:15 +0200
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, cratiu@nvidia.com, ozsh@nvidia.com, 
	vladbu@nvidia.com, gal@nvidia.com, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: flowtable: infer TCP state and timeout
 before flow teardown
Message-ID: <uhn7bt3jdrvmczhlw3dsrinb2opr2qksnbip7asekilgczm35v@hyvzkxrgdhgn>
References: <lderg42fd4jbcwsztkidn3lhnjhufj5yv3zsdu4dpsenzikkta@cya5vq3prnzf>
 <ZfqsAoSNA4DRsVga@calendula>
 <nvslglowbvxntlpftefkumbwn2gz72evwnfvv4q2qencte7wyn@3jejk23urzeg>
 <Zfqxq3HK_nsGRLhx@calendula>
 <xvnywodpmc3eui6k5kt6fnooq35533jsavkeha7af6c2fntxwm@u3bzj57ntong>
 <Zfq-1gES4VJg2zHe@calendula>
 <o7kxkadlzt2ux5bbdcsgxlfxnfedzxv4jlfd3xnhri6qpr5w3n@2vmkj5o3yrek>
 <ZfrYpvJFrrajPbHM@calendula>
 <x3qvcfxgdmurfnydhrs7ao6fmxxubmhxs2mjk24yn5zjfbo3h5@esbr3eff7bir>
 <ZhUibxdb005sYZNq@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhUibxdb005sYZNq@calendula>
X-ClientProxiedBy: FR0P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::11) To DBBPR05MB11225.eurprd05.prod.outlook.com
 (2603:10a6:10:538::14)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBPR05MB11225:EE_|DUZPR05MB11041:EE_
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Msb7LQJ26p2obr0BG/JSBYNQpBejYkzoS6bxMWtcpMQ3P5fjdcuXDL6CK1o/Hve/i5mYwI1Ajcb3v2XQjM2oeWaH5gNJ3VdOwzc4DKiDL2n+XYbBBackONMzcemlnl1DH3Btx2W8mydLXOoLgrcHhE6T0eRBUFJsBpdmYwvfvBVwzGs2jGoK+GqsTqmcoXSPuf7BovbcO8YH2uSNB0ytpXN/Olrk+qo+rmJnk18Y/N/V/g8WltUgdu7SesiR54BJO6tO1NSP+Epf6KvfDjVMe34Vwdmm05y6ElWR/6EkJpU+nSZAm9VP8TVFhdJ+LgsfusRaZuKGthrBGGXswk61L+j1Ss6NHSGRLKoM6pXpSdf7dNrDA2B+ue0tr8eVZm0fwbo1G9FGmt8WCxAlxrsI9Fl2h2Hps2T9vB0GPsrfPbFRG4pb17e7CnN5mY3yfX2HGHww0piuYJoVWQ4AkHm8bsj4bnP0b55Ba8BtlB57C6CyGEdUi1KtKVL6CE6cjbQuzIlFNVoHhUCDrZnI8U00/H14g+sEqX5hPy1DHS9qr2gqk+gOfI0FAKybNBAS3YjIZaeGISqLXAyeHna4BuzF3YV9dUKyZvkw0ip1b1WPSZ7yVL1T3imN29SDqC8fIDir5vYfRQFhg6D61RZgFXoss5gxXWtH8VxE9CVnxga7+S27lA949euxd0jo8oXixUTu4wSN2RtKilV/H8t7nwk5+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR05MB11225.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(27256008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hnuh7u0rYHO6YAlfU3duI7R3/fQQdUanlB+6AeQ9QU3HILRnFLQKEDolVzYG?=
 =?us-ascii?Q?MbG+K9nsLjKam7iIn7FjNHUyUHjC2BM1ETQFHfYKCHlbKfKQUxggVvyr3apX?=
 =?us-ascii?Q?tgPwPAXOnXe+hIoc5DuAE5H0fhO9tKoWNxsbw6epbP+/bW+j9L7+UmDB6Lc7?=
 =?us-ascii?Q?YtiAXD56fmtp4VNMjoyO77sdjXY1BBI/KXRrzAKEv+Z9rOL6vScAB1spuzPU?=
 =?us-ascii?Q?eV0byTQqD7j8cW6qthLE3V4wK+mawqiGaHIvAsMTD3QmoxMIN84N2EnQpi+P?=
 =?us-ascii?Q?jVtnq5pt7RZgRFM56WLIFKq4Kbw7kfVulqD65+VP5polhrr0VqkemaijtyJf?=
 =?us-ascii?Q?I1yxU2amKqIQPbZbdc071U29MbfAa8n2hkzclor4g8UtwUChpeD0TZSmPqgL?=
 =?us-ascii?Q?XYMHLsSMxcA9ChFZfYTmQZXi7A5UwzzRBFDJw8PRI4GKnJIL/tFyH8gi0fJh?=
 =?us-ascii?Q?fgMDsKWQvSvOHPY4pb+N5rCL4hmPlo4qeYMvTwn0KGMpC225aClp2lpKWnjr?=
 =?us-ascii?Q?Z9DhTyWdpZHwsg81Jj16vLe7/zFiFQfJrk2S2aebwkCG8cmPvbJlKVi2c/z8?=
 =?us-ascii?Q?qWFNu7xbCVTgFfMq4sRpKJByEXnBTP54LeIabtlgeNpakcU2gHgPaKI0SKFQ?=
 =?us-ascii?Q?8O4/Cf+/k9CSMlp/QiMmZv7dtrAZWx/vF3rfjbaI/8jXTHfVljv0Ed4MVKgJ?=
 =?us-ascii?Q?/oLRomiqpCErIGnuNmtwIUBQi1v6neaVH5ykMfdzQ0HSuk/u2Chg86utuWQH?=
 =?us-ascii?Q?zvIYXTa82I/9CbFXfeaZBH3q0tG/BY5Dyo6kRApGreHF7OdWSFn9ErfxBVBI?=
 =?us-ascii?Q?m5rRn8xbiSVCwWm5EzPIt89Y9TLBcUafAGZSxG66aXGudpKUi6+QDmI1QT1u?=
 =?us-ascii?Q?zgXdDboh+xakf3gs+VEK8+fyA/Y62RuugS4IhRxyMfzEXqqlaijNuCkB0bRQ?=
 =?us-ascii?Q?3kfqIIgwoO31SnYptr65aCivJ+4XB07eYdoKatNCtLpar49o6Uo2zNNTOqTp?=
 =?us-ascii?Q?OQouhajDN9x42d+2I54Rm+zf2CkFVpAwhhXCSrtgEc97olMWKpBgnDn1H7Rn?=
 =?us-ascii?Q?THvvXpown0/MaMgOL4HIaWJInQ+TAhjZbHDRbEZ8CveBL9CcEC9kDDZ6VmLn?=
 =?us-ascii?Q?Eqfa18sjF8sUTwa4XVlAsnmfHdgeGr3AGjWYNztLL/UMPhHZwecbbDe5RhW+?=
 =?us-ascii?Q?8NfdCxeZQCphH94F0S+jNCMXoVPph29aNIH4dPS7JU2NDKfUyj30rfUbxL81?=
 =?us-ascii?Q?7IgzYIY8PUgnc9SBfZYqvh573wDz8RTWkrvH79e5gp8GY/mjBgjwJqLj/vFV?=
 =?us-ascii?Q?VOJVRnVLhSO5b75lHRX8vP63tooehfHFZlYEAbTBJjd+hGOUgyY52/IiDBQC?=
 =?us-ascii?Q?mqqv0lYdUjCbOIGlgSWyYMCuDt3VdOtvQE3rqPWa6a91PFOokFZHAiws+jHF?=
 =?us-ascii?Q?Lwakqr5BcuHJWk6lFYqh49VzLY/mcDjbX8tjJEtYmqVe5kM3/yKT4CMbRrkX?=
 =?us-ascii?Q?YGLjo+j5DJ2R4XgU/SkLqTKSFUzernEqzJihaIr3R9CuVKvgBt6HNsm+W65n?=
 =?us-ascii?Q?qacmccUPVNwcKch+38UDNi7zsxjal6dYknIJwYUALddSWJZrnkMuiYva0Cuq?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 89cb8c5d-00b7-4367-d4b2-08dc5889226e
X-MS-Exchange-CrossTenant-AuthSource: DBBPR05MB11225.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2024 11:35:19.2351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnKuO46kkonQGEBFB4dQ4cSuZ3JQohtrSFrWsSSgVofE3D+f3LqFK2UQc9yeptxhDRRNto0BDuX5b9ICby39aXrB92qa5FJNsH4kiVVIbiQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR05MB11041

On Tue, Apr 09, 2024 at 01:11:43PM +0200, Pablo Neira Ayuso wrote:
> Hi Sven,
> 
> On Mon, Apr 08, 2024 at 07:24:43AM +0200, Sven Auhagen wrote:
> > Hi Pablo,
> > 
> > after some testing the problem only happens very rarely now.
> > I suspect it happens only on connections that are at some point
> > one way only or in some other way not in a correct state anymore.
> > Never the less your latest patches are very good and reduce the problem
> > to an absolute minimum that FIN WAIT is offlodaded and the timeout
> > is correct now.
> 
> Thanks for testing, I am going to submit this patch.
> 
> If you have a bit more cycles, I still would like to know what corner
> case scenario is still triggering this so...
> 
> > Here is one example if a flow that still is in FIN WAIT:
> > 
> > [NEW] tcp      6 120 SYN_SENT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 [UNREPLIED] src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
> > [UPDATE] tcp      6 60 SYN_RECV src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 mark=16777216
> > [UPDATE] tcp      6 86400 ESTABLISHED src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
> > [UPDATE] tcp      6 120 FIN_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [OFFLOAD] mark=16777216
> > [UPDATE] tcp      6 30 LAST_ACK src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
> >  [UPDATE] tcp      6 120 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 [ASSURED] mark=16777216
> >  [DESTROY] tcp      6 TIME_WAIT src=fd00::192:168:5:32 dst=2a05:d014:687:ed01::21 sport=58790 dport=443 packets=15 bytes=1750 src=2a05:d014:687:ed01::21 dst=2003:a:c7f:e5e8:a3ae:63f7:7f92:e286 sport=443 dport=60848 packets=13 bytes=6905 [ASSURED] mark=16777216 delta-time=120
> 
> ... could you run conntrack -E -o timestamp? I'd like to know if this is
> a flow that is handed over back to classic path after 30 seconds, then
> being placed in the flowtable again.

Sure here is a fresh output:

[1712662404.573225]	    [NEW] tcp      6 120 SYN_SENT src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 [UNREPLIED] src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 mark=25165825
[1712662404.588094]	 [UPDATE] tcp      6 60 SYN_RECV src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 mark=25165825
[1712662404.591802]	 [UPDATE] tcp      6 86400 ESTABLISHED src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [OFFLOAD] mark=25165825
[1712662405.682563]	 [UPDATE] tcp      6 120 FIN_WAIT src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [OFFLOAD] mark=25165825
[1712662405.689501]	 [UPDATE] tcp      6 30 LAST_ACK src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [ASSURED] mark=25165825
[1712662405.704370]	 [UPDATE] tcp      6 120 TIME_WAIT src=192.168.7.101 dst=157.240.251.61 sport=52717 dport=5222 src=157.240.251.61 dst=87.138.198.79 sport=5222 dport=26886 [ASSURED] mark=25165825
[1712662451.967906]	[DESTROY] tcp      6 ESTABLISHED src=192.168.6.122 dst=52.98.243.2 sport=52717 dport=443 packets=14 bytes=4134 src=52.98.243.2 dst=37.24.174.42 sport=443 dport=20116 packets=17 bytes=13712 [ASSURED] mark=16777216 delta-time=140



