Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2107.outbound.protection.outlook.com [40.107.20.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B9837C6DE
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 16:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.107
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710260998; cv=fail; b=o+93jBiYhWVBdG/d0mCmWA148nC3hlNsqAjvoXWrVQEbCirBSc7MU81/d12O5lg8m5fOd0HWh+YMv5WBiNtxp8cmZJOoT1pcTqJd7xa/0+1uUzhdzSK0/Xss23SK4ckOR48//quA1SwMwCp9GCKo6QBfZzlhx3ADZlptK2H6HG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710260998; c=relaxed/simple;
	bh=yD1ldIO3rW9VsBHuF9ZJ5if8D8wSNr9yaAmGlTZGkQA=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=imD9w30320hL++9QtUN6FsCdi7Zd0nlgj05euOLbDnziVsVjveBrVsxAtzOtWx6CSq4/tQ5ZxeTr8NeAKCui9Exvl4WjQ0C/OD0OGgI3MHgcSmMu5PLC45GbyipQYDbpPUtL8PmzzIvXW/nQUxzsje+ZyM45BkPT2A7hKgZ8FRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de; spf=pass smtp.mailfrom=voleatech.de; dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b=Ih8q3iKV; arc=fail smtp.client-ip=40.107.20.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=voleatech.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=voleatech.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=voleatech.de header.i=@voleatech.de header.b="Ih8q3iKV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBzPVV6SMfs2SAfRjL0JIkstkHB7d0yMEcb1b3/MQtVX3nUburKXqgfdHKuZxeXnjfiymWuO3MsIZz59SwxpZFgq3S5jHQJvkpmHAklxMGp8Ia9rkR4Zt2iYjt1MWXZA/mY7Ng4J+xERk7ZYYSzT1Aj1m9kPK+gA+2DfMrpuMjdGVfZvJ84Ejt7lgqpa8oM53N26ZefI62CUm73iwae0TUq6l+FnOEyvyCj5dPK8yzS+mUZzlOeuzSwqS6l9QUPrpfdimsLdqI459RxF1khn10qyhoalWo9bDn0vMm4yxDih/EBQ3g3fwUU9aWGj6QbKjwi267WUvnRRjReg/rcWug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJm6sBh3iCZJX/OkDulagdtx++HYob4rZSU0M9BU4QI=;
 b=mDY6DkwebCo6um1mENUF6Krqg0Ezlj0/w9awIRy5WZESXqm0BKSOKz9GbWJIziuoPaqSCCFGXbsGAHMCWkSbr+GcxsaGWDAPsNGvDW0RFLWSEABWGAua99EzU13pxJLSYPiYcXYUZ4d7VqJxq/6t8F6KN5VCLf+iLnYHmiwea1eqneYmvrTNARFqsKBGxKAHVyNFMrFzH8YPJo53YDEMeOTeHHV+5IemUVH/BBzOJ6HstH+vQlWxkpUScopgh/LkCM7UOFCz1GKaFPQ14yc+IJe/ER4Ksy98sgS+9LA7z/dxyUcsKbLeq7SpVuk3TFaJj6981/zETx9HizY7Ki0AGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJm6sBh3iCZJX/OkDulagdtx++HYob4rZSU0M9BU4QI=;
 b=Ih8q3iKVqfiYU2dE71KDEyJOheyNjR+IUWbPCyuStO02jEMudtE/qHzB+Zy0E0R+jITSdH9qDQy1lSxUIIaqOfCYWCqY9n8f8vq26FObzF4MQJAjw2YQMRUWkecd+M26QVvVKUxZO5lPf3herZHAceBvO4LxIeJ66Z1M6rSTU7g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13) by AS4PR05MB9109.eurprd05.prod.outlook.com
 (2603:10a6:20b:4e9::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Tue, 12 Mar
 2024 16:29:49 +0000
Received: from GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b]) by GVXPR05MB11233.eurprd05.prod.outlook.com
 ([fe80::9d0c:55e:de01:2a2b%2]) with mapi id 15.20.7362.019; Tue, 12 Mar 2024
 16:29:49 +0000
Date: Tue, 12 Mar 2024 17:29:45 +0100
From: Sven Auhagen <sven.auhagen@voleatech.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org
Subject: Flowtable race condition error
Message-ID: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR3P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::16) To GVXPR05MB11233.eurprd05.prod.outlook.com
 (2603:10a6:150:14e::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVXPR05MB11233:EE_|AS4PR05MB9109:EE_
X-MS-Office365-Filtering-Correlation-Id: 47494fde-dc9d-43bd-c1c8-08dc42b1a2d3
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HOYxB1SBuSdqGU49VDAUUON6XhV7aun4zYwNfMEc4BY5lQcg/nWc6JyQcWLyG8hv9qgAHYAtFJFYz4LN84bh8zGnejG2ZN/zkxuuCoK/menRXasmHWvKtwDI7d+EVSq3KydJMoNmq/+nn1hSKueltUSCc8mL4KyPwZpYB+JEb3fssHgk7ma8xeIAnRdh9o5E0JSrYYsS4Snvlx8SRc7HZbBuXcPELozGqIh6M/Hl6tepW+SkW1oryeWXZIUjA2Fs5vVezjlSy61YKUd3/LP15WchXlxbwHI1rldaL5P60oQXvK29AnyhqbdF73oVzV7CKaQf0IcpICr+Qmq8oyQrM1KQQsGyU7gBna4/AoZv40XyXimTOClBr+rmiXRbr4RRrb63UXlDadgbAFBnjsEg4Q8Bbb0kWJKLzMX5HXTyAOCivY/5HYWinnVAHa30BGaeFqUe2IThsbxhBGjskBe5UrHfpkcGxYVqdqsmqMQoiGl0AO1IqiLjGlO3bs7UQ5QDtlKh04a0uU5QMtS5Q1QmIAQfmAFLPuqsQgHMZVzexsOyhcr9IFUgDOEjkOZ4wxD7UBm/SpT8J4qwEpk/RDpe4z06PpDwjSP4eVe3rZcM2BJmRpHNTF5n8T1QMvv1+YK9S3HvCV60m5QcKOhxrChWSEX48XJiie7IFPSR/h/+Ckc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR05MB11233.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KMZYIsMeJMbLbVhmK1JylZuG0NGUWLXR1CYomqfn/q2mrjPHe8atDKsPO2tG?=
 =?us-ascii?Q?zIT5gollPCfQDjvebu0KcM2POvDyaccpqY19wxUANXWpijudSRBUNDpZiEje?=
 =?us-ascii?Q?wnPs6JC/FRVgW3/KA1FKl9r48ua+jSGaI2zoi3j1GCF0pF7IT5zGpyoPy4Il?=
 =?us-ascii?Q?RKe3n5Scp1kdzE/vCGsG74SwcAYfdXO7P8A8RDg3TM4oDzEwaFiikxSPCOKz?=
 =?us-ascii?Q?7fRAOSxn1UgqJ7t1k1I+tCWrwF4KZ8QY4wwSqDHkWEG608tTS4hdijpPf/SO?=
 =?us-ascii?Q?x8446ymJd0RBBDck9+aOu6TlCGh6hEJfuwHyw9u18iSGZxgmZa8Hap9jq5dD?=
 =?us-ascii?Q?hmixeVoKmWnShqIKaMWkcYf/aCWZjuicw5Y9eNS5tb/uUvbCuuyWm9y2W56K?=
 =?us-ascii?Q?pVnfS6bc7OBwFDdy8kUWC3TEUI90nbhN72fI2ZdD4RCRYiAc0yxug4fFl/2L?=
 =?us-ascii?Q?YKjomMVzJRxSfYmxH7g891v/qqA130BhG4y+GVqUgvO9vPC/aiFTrL11Tgl1?=
 =?us-ascii?Q?my4/EIdalEqvnYWpP7YXHKGF8kOCKm7/REI3Z/JH3Qs04JAyHqNXCvN6tqob?=
 =?us-ascii?Q?isZsKKR8lKLFhGpAJ4bN4mEFi3bbEacUaUUxUMwKuKL4m0RTUmM8B5AigX0/?=
 =?us-ascii?Q?whEbIiC8CPold9p2UHEus/M0fQXn+5Pe6aaEc2EhLDuOwSJxSoQQ383ROtNp?=
 =?us-ascii?Q?EWf15K6b5ISYueAVuKVopwhXFT4puBduDM5dVDLaXckf//FE3lF14DITYqBY?=
 =?us-ascii?Q?GmT5BjJGH5ZKHG5cA7SIQRWAViuGf4LOIa2Kd8ILlRYgaCBkMlsyTeZhj7u3?=
 =?us-ascii?Q?MltyzlrhVHE4f9SHGFHqJDAwup7aw/59rDltBSyoWHHlbtkVCnjuNvwLClYf?=
 =?us-ascii?Q?XWkYWYfNXqZImULhnQce+E9tfxv5CHlj30VO5jaFIr7V4COAYEq2+n9BUrMs?=
 =?us-ascii?Q?KsGwYa0oTiWu/iWmVeKGgfTrh8HwrHiBSaW+ZBPVMPvp/n0Q6dX++Be9tb9S?=
 =?us-ascii?Q?+NY8tmhyWWSPsqvYqDvg/urebc1qDsztaXo3ODQqr7q36acBibNuep1sUaVk?=
 =?us-ascii?Q?BKlIGdmmlP8ys4YdTOo+TWlQIDtBd3EIsJ+0I/j7tin7M8hnybFIDi3dz+lM?=
 =?us-ascii?Q?+rBMWaHmgTW83v29LuC/iiN8iZ0frd1J8lzQSMe/oqKi35YXV5HKUGq8Ni1x?=
 =?us-ascii?Q?CW0jI9pQCfeTSsNBpLZBm5abo/D3DdTGVoCzUOiitdIj1JZsx4evMVBXZ7+W?=
 =?us-ascii?Q?aIWW0wII03nbBDzKr4dl+rqpyFGhMN8xwMgnoEvkIsWlW+xygeofufzqTBPH?=
 =?us-ascii?Q?7okopyVme8tjo0U59ncgUtzqKHQBRp53VNiWuZmU1/F78nPO93xFQ8V+Qjcb?=
 =?us-ascii?Q?DgbG5+Y+ND7HKFmpGEcLGbcIdUaN2I4cGJVrZ+p+Fpm97N65I/DreIYEk0K2?=
 =?us-ascii?Q?bjwkXAwDJ4vD3HWPjrb1Qq9/TqImc4kyHvsJ20kIBvGD/BSQ81zxHhRzQs60?=
 =?us-ascii?Q?Zzvr++j1K4RtPWG1kqUtqnmvLB6y5SfI6JqbDACI08JmnBSFHoY+Ujhhc3cq?=
 =?us-ascii?Q?xgxjL+u90IKFAH9dQZk8Hymgr4cYaE76SJoS2HTcUOLRqEcBF97HlDU49dgn?=
 =?us-ascii?Q?TA=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 47494fde-dc9d-43bd-c1c8-08dc42b1a2d3
X-MS-Exchange-CrossTenant-AuthSource: GVXPR05MB11233.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 16:29:48.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2sCHsXN+rdMxothQP5mWz6dS+g0vQUSVYNmgciQIBQGQCVgmPa6rVSs7DTnlSHgj8KWJbolO+XrqhZABslIHiHPx3Nozzvpu4ve0IPjVjiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR05MB9109

Hi,

I have a race condition problem in the flowtable and could
use some hint where to start debugging.

Every now and then a TCP FIN is closing the flowtable with a call
to flow_offload_teardown.

Right after another packet from the reply direction is readding
the connection to the flowtable just before the FIN is actually
transitioning the state from ESTABLISHED to FIN WAIT.

No the FIN WAIT connection is OFFLOADED.
This by itself should work itself out at gc time but
the state is now deleted right away.

Any idea why the state is deleted right away?

Here is the output of the state messages:

    [NEW] tcp      6 120 SYN_SENT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 [UNREPLIED] src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
 [UPDATE] tcp      6 60 SYN_RECV src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 mark=92274785
 [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
 [UPDATE] tcp      6 86400 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 [OFFLOAD] mark=92274785
[DESTROY] tcp      6 FIN_WAIT src=192.168.97.23 dst=192.168.107.52 sport=63482 dport=443 packets=10 bytes=1415 src=192.168.107.52 dst=192.168.97.23 sport=443 dport=63482 packets=11 bytes=6343 [ASSURED] mark=92274785 delta-time=0

Thanks and best
Sven

