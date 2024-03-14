Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2107.outbound.protection.outlook.com [40.107.7.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061A5266A7
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710420243; cv=fail; b=VAlQVEWfsuR7Gzbf/fQKZxYu4Ko87ZI9OiAnMmpnzuK4XZzNZ8tLVe0xY0LwYSem+kTHFMjEnDaLPc4mrRSSiI05pTmt/cZdVFzjwIuhl5rJilUVsoGmpqAjpPIm6gKmAchWJH1AQyHiWwoBTN3/h4ReVmojHmDrLwqGfPKl9JY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710420243; c=relaxed/simple;
	bh=hd2sOBbaTBvSM8emI9NmO/PGsXKt1TMZx7JBV8NgWDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ENQJve1mN11Ha+j9NUMNd8mqjnechiB1JdARQGQbGu588B0mzxhNcL4XWBHXcQ6oeqJEi/UITgoxNkEtQopS7L6CKo20dbLYUsZDfrPclqCR0+p235+HQ8nGXzbe46sDZsievdQTuX1dot8Ymh4WE9PrjyEiyR+m2AkRoDVChhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=Dg9KF4Mu; arc=fail smtp.client-ip=40.107.7.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Dg9KF4Mu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJvHHEss2Jg9+hYfZKZOfSwfimd5FBl0Udw2AcehQOhuWOYvAZ+/nc/iaQzYFAI7UrwXawI4WEB4XKV0nTyYhITg4Eg0gBN/UQJyjbX9ot4+8On06bzTXHTJgNSVVPhnkI4qncq+Zyi2tJfgsndZUJ7TKK0DrnDBlCzj/1/j1X2be/N3jqnnhDtBnAFeQje3BpG71Y2CYtNQ9LQ31/cnwKtDVkRMrDq7Bd5VKg5/QeFa6v4spSJbiO+4BmhfMsYWij99d8tN8WT6HlAkxaT4sPzQiDSVJetvtiirY4epRE9brbWZLaEgvsUTM2MpdMuso2aGN+2RjpUpBpu6Gd4h4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10Y+7lThSaUAHivAfMPQktRULp81fe38LkU4N1/aiAs=;
 b=n1Cm7Ll9tQGq2rSHaUBp7y1aGyuMYfqgR/S5sRuP7aynwkc79bV1X+6sIT15duduYsJicLRyxvqYh5sv4Teu+QCu5CvZI/dIBa3FE/YfK6FrLZbgLpP5lJnVSczX/NkLEguIsPWg3ndQLCaCT8icvMaeWBtCsy5an8kA4gV2A6CoE83vu4+TJnXon8B0x1Q3feuc6STCh8L+dopMn1G9c7+eDuPJ3rdQZt0+Lry+5PsXudXDNd0QQVED5Rl1PCz6kiQfsSaDBfy3dsIs+IoPXbvGXuZ6TT+OmCxIqW58J9L8rq5aGVvxO38FjRlskDmG596mCe2axZp4n8+TglcoIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10Y+7lThSaUAHivAfMPQktRULp81fe38LkU4N1/aiAs=;
 b=Dg9KF4MuENzv4qLHxhvgDN8YSd44ABt+6wEP+9bAu6DxsayKmZX/CS0gijlAUOBrI/FKbTQdGVCrfZd8PaA61G5XAowlFwL6/L2PeZT2BcHR9434YyVX7SsgtPDLXnn4pnGA1owfBNSXk83hedazdmpx+lmL4CA1HGhGeo+6IR4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by PAXPR05MB8574.eurprd05.prod.outlook.com
 (2603:10a6:102:199::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Thu, 14 Mar
 2024 12:43:56 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Thu, 14 Mar 2024
 12:43:56 +0000
Date: Thu, 14 Mar 2024 13:43:52 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: Flowtable race condition error
Message-ID: <4tq2bj2nylpqkkqep2v47dnb3nfismzbdzv42jj2ksdll4figl@scwfgkdwyuks>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <ZfLc33WgQPKdv2vG@calendula>
 <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>
 <ZfLv3iQk--ddRsk2@calendula>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfLv3iQk--ddRsk2@calendula>
X-ClientProxiedBy: FR3P281CA0003.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::22) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|PAXPR05MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: aeb282ff-f9bf-4c21-71b3-08dc442469d5
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m2LwsJNXs9NPVHCSyT+dCMtAE8m4nbSZViah2syZBfC4FRzLxpuq4PJ+5GvcLprMoo8nIsewtM/bliEkyLGn4ds3vWrlx7k2rhpA8JZTKFC847cnKTUky4XvTODUNUfJqXe0IYNdmGmA5Ddvni9xmW35XHhxd+OUDt65R9VYklvPZxSCoNhumd3lZXPrHACmTXeJTtssspaJ8hH4LZRRVTe0bX7rnKQyj0QnX6Bu/IUp5jfyXUPcqc73XJixHnzG4NIOhAMZXO2VI0dWETO78iGOzwQdgGZqgDxTQx9Uu/av+4tQPH6Z7SXtgOw1YkZFac+lJ8aU2ufgueWUeY/JJUDbJrIWbcLEFwhbbt2dSj8EMTO4S0eXEVVjMQExtmQRVSA20OYM9xpS7Gks6sG2gmGCDV8I9JiXUnf5stvMc+PDOUpWTKFIEBbAqX93mIbrmpOszsdbBCrJuH1oloandJOUegdGVCS8Qth93lD3ejAI6NXdUvMyxgruUmIkFsAqMM042YjZSecrcqh0rb6YoGkIBM/HbXFev7ETCinoRMTIjYMW5AWzP8QMPQuI0GowzMu2uVcSCyp75QCBRcRlF9wk9VJEAsBbPZ/uBmFDY480S5UOE+w/V4zNd9/E3hv99VkxEzR9ABNs9HJShFA0/OrwPUJgKhsdym3Kw+eWUsQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wmmd5mheed9m2JS4Ph/O+9vqfHo2qh/a7IqKqZ23/XjGh0XuNqr60cQ8VmKJ?=
 =?us-ascii?Q?dedJOQvgzugXsqH0l8R60I8fXYpSROpYz0C4ypEwRd+Jbg2pb8hWMNBxpyQY?=
 =?us-ascii?Q?dtVv7do/ZOf2krl7jRveIj5wKPwPgAKiqkukNAJ8KVgGK8tREcNOYFEeU0O2?=
 =?us-ascii?Q?tu8A4zlAe1UHY5S4s7uSryJu2Q8YzQoexAvuPOv66mZojMiwMCK1hDoeFKNu?=
 =?us-ascii?Q?v62hRMAfyU9+QhSmcUpzvtC2VIILxJetnDBJYWSzFX6qP9uXBf5KxYS6qFup?=
 =?us-ascii?Q?snHFvzKQKshUgRPZype3bcUkwDzv1xrXbIy/4yTMj7QmDK1PK4OUs/g4aoRt?=
 =?us-ascii?Q?38g3hDuw0/6p2jSfN4w1EcLMFqQdwDanEgwNzt3dKAK/avSHjtllXtE/F2E2?=
 =?us-ascii?Q?reWPfoNVPH0iNEerm+zSMkRa0f+sxCQ/hKZTQCRJnwRg2n0hgUSpsq95N32x?=
 =?us-ascii?Q?Fxc9hh8xC/zBBI8KNxiTfzbY5RRvbJjY1ODj/K5PO+u7JncxQitcHnOuQPmL?=
 =?us-ascii?Q?gZc5YS4S5pBlmx5pYLPHTzCqgX49m4BHhPwUOdG4p4B54xDXOtUASPpNg2h0?=
 =?us-ascii?Q?wYea55wZEyGwORLqvuYyoD6m3sDR8qXQT+D59eVZNSLSyNxxZ/BbUvliJ2uZ?=
 =?us-ascii?Q?6POVK2E2N7oL1YY0jHUGKZyOCLzQnc1f5uSVPZlK3cznEsYBZdx8BEAu8S28?=
 =?us-ascii?Q?5dI7qvdHmo3lxKI9s/bhFjIGEtkNRNqQhUNTLCI7z2cg8fm4MtW3IRJBD0e+?=
 =?us-ascii?Q?RQsX3c0C50vYc3kF7X4q2i0219zf630lqRaRiP/ix5OqDsKu8u04ED3Rs0+D?=
 =?us-ascii?Q?7yG4VI4+zOl6Rki3wztLJxIvDwJc7RGAdWan5CLXWAb3fgNkCV+N2+G3v9c9?=
 =?us-ascii?Q?6oIuo3uSs4/2xK5pm5Pa7ACDdBeRvJilcG+zsfMao588swJM+SI8Qlk0DtZi?=
 =?us-ascii?Q?c0hij9aZZnAm0to1D1nh8t0w4zO2PqUPxlxmWxyG19JDnlJy6N/I9TjZd5iK?=
 =?us-ascii?Q?bYBql6VIrLlaJ0zY0PoqIqrwV9dsxU2OX+ioPS676kexMrhchAE8aF6zqsrr?=
 =?us-ascii?Q?RdxsDzAacLk+DMgrLzhHSdBuLMAhLG7N6v4/bVn/QhZ//ZfmMu2QhYWBfBxF?=
 =?us-ascii?Q?BKYFGeQq7LtoS69NFJf+tfV1WOE4zYwZgGJ4W1sYq2W9HUPbsa+JnuUwUtqo?=
 =?us-ascii?Q?sLAEMvNjlO2bqxQfMPyAM7WMRKKtYkxqfaIKPECq51V7Cjv84J8n7bdNq54N?=
 =?us-ascii?Q?f57Moe4IgfiemfUD47QycbWOnALsR8pcXnHdhLFHz5z8ARYIyI1OCefTWjGb?=
 =?us-ascii?Q?7/7xz0e1MVXBzTrlMzEcbsAxIozvZdsHN2BkVN36OW+DatbBCAsfDRZVk1Oy?=
 =?us-ascii?Q?AwPhhPgisVC+WcXYUrdxETVAR778nTkdQNfWKAmXtq2MHtAuurYbmPmOz1Ix?=
 =?us-ascii?Q?r+MikqVTTqkQJWFfIfgSWu/zpyRagoip5KcW+GXV/qstfYrWUPq6nCUOS/Rb?=
 =?us-ascii?Q?u6O9+fonlSX5W1YJWGOxz4HLPDHBneC0xf6r2KytiraQ+gwraJYSYHmTSyro?=
 =?us-ascii?Q?RmIysABPrN08H6K0RJea0hsy1je2IQcOq5EcXwFeY9PJOX2BxaZTDQJTSwJF?=
 =?us-ascii?Q?0w=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: aeb282ff-f9bf-4c21-71b3-08dc442469d5
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 12:43:56.6362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2CiN6/vudyTo6fDn4tStAdKvWPKnhrSbAdsN/hUWVrr8SSdTr4lrGloM/3j2WvxwD5m7gudpn4WwxWRhLyTe+/YrUrgbupkCkcIT+eD7ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR05MB8574

On Thu, Mar 14, 2024 at 01:38:54PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 14, 2024 at 12:30:30PM +0100, Sven Auhagen wrote:
> > On Thu, Mar 14, 2024 at 12:17:51PM +0100, Pablo Neira Ayuso wrote:
> > Hi Pablo,
> > 
> > > Hi Sven,
> > > 
> > > On Tue, Mar 12, 2024 at 05:29:45PM +0100, Sven Auhagen wrote:
> > > > Hi,
> > > > 
> > > > I have a race condition problem in the flowtable and could
> > > > use some hint where to start debugging.
> > > > 
> > > > Every now and then a TCP FIN is closing the flowtable with a call
> > > > to flow_offload_teardown.
> > > > 
> > > > Right after another packet from the reply direction is readding
> > > > the connection to the flowtable just before the FIN is actually
> > > > transitioning the state from ESTABLISHED to FIN WAIT.
> > > > Now the FIN WAIT connection is OFFLOADED.
> > > 
> > > Are you restricting your ruleset to only offload new connections?
> > > 
> > 
> > It does not work to only use ct state new as we need to see both
> > directions for the offload and the return packet is in ct state
> > established at that point.
> 
> Indeed, we need to see two packets at least, which will be the next
> one coming in the opposite that is, the conntrack needs to be
> confirmed.
> 
> > > Or is it conntrack creating a fresh connection that being offloaded
> > > for this terminating TCP traffic what you are observing?
> > 
> > I can see a race condition where there is a TCP FIN packet
> > so flow_offload_teardown is called but before the FIN packet
> > is going through the slow path and sets the TCP connection to FIN_WAIT
> > another packet is readding the state to the flowtable.
> >
> > So I end up with FIN_WAIT and status OFFLOADED.
> > This only happens every few hunderd connections.
> >
> > > > This by itself should work itself out at gc time but
> > > > the state is now deleted right away.
> > > >
> > > > Any idea why the state is deleted right away?
> > > 
> > > It might be conntrack which is killing the connection, it would be
> > > good to have a nf_ct_kill_reason(). Last time we talk, NAT can also
> > > kill the conntrack in masquerade scenarios.
> > > 
> > 
> > I found this out.
> > The state is deleted in the end because the flow_offload_fixup_ct
> > function is pulling the FIN_WAIT timeout and deducts the offload_timeout
> > from it. This is 0 or very close to 0 and therefore ct gc is deleting the state
> > more or less right away after the flow_offload_teardown is called
> > (for the second time).
> 
> This used to be set to:
> 
>         timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> 
> but after:
> 
> commit e5eaac2beb54f0a16ff851125082d9faeb475572
> Author: Pablo Neira Ayuso <pablo@netfilter.org>
> Date:   Tue May 17 10:44:14 2022 +0200
> 
>     netfilter: flowtable: fix TCP flow teardown
> 
> it uses the current state.

Yes since the TCP state might not be established anymore at that time.
Your patch will work but also give my TCP_FIN a very large timeout.

I have successfully tested this version today:

-	if (timeout < 0)
-		timeout = 0;
+	// Have at least some time left on the state
+	if (timeout < NF_FLOW_TIMEOUT)
+		timeout = NF_FLOW_TIMEOUT;

This makes sure that the timeout is not so big like ESTABLISHED but still enough
so the state does not time out right away.

> 
> > > > Here is the output of the state messages:
> > > > 
> > > >     [NEW] tcp      6 120 SYN_SENT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 [UNREPLIED] src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
> > > >  [UPDATE] tcp      6 60 SYN_RECV src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
> > > >  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> > > >  [UPDATE] tcp      6 86400 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
> > > > [DESTROY] tcp      6 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 packets=10 bytes=1415 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 packets=11 bytes=6343 [ASSURED] mark=92274785 delta-time=0
> > > 
> > > Is there a [NEW] event after this [DESTROY] in FIN_WAIT state to pick
> > > the terminating connection from the middle?
> > > 
> > > b6f27d322a0a ("netfilter: nf_flow_table: tear down TCP flows if RST or
> > > FIN was seen") to let conntrack close the connection gracefully,
> > > otherwise flowtable becomes stateless and already finished connections
> > > remain in place which affects features such as connlimit.
> > > 
> > > The intention in that patch is to remove the entry from the flowtable
> > > then hand over back the conntrack to the connection tracking system
> > > following slow path.
> > 
> > So if the machanism is intended as it is then we need to make sure that the
> > timeout is not so close to 0 and we life with the possible race condition?
> 
> Then, this needs a state fix up based on the packet from the flowtable
> path to infer the current state.
> 
> This patch is not complete, it just restores ct timeout based on
> the established state, which has also its own problems.


