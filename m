Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1748F16F0DD
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2024 09:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725008751; cv=fail; b=hncRBix7LnTCk6/k6JvJCfhIcbFdLh7Sy2/oWgqMCRnV41VKXrKHoshaZwNR4fvIYYIB/yApQu6p5Tcvzi3WnFjvHP0Y26EixDW6ZjRN9LAKIL0vLK1cM/hUHdX/NvavvO8bDY+jkU65RL658nkEEXknGNIE+8fM3tx7ucDKlso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725008751; c=relaxed/simple;
	bh=UjLL3xXe3c2BKPyH6le+aOLpgilQhNhJSSIJ4jMRatc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=J+iVltUOb2kr9Sx0BSyuqhjMZCF4hcTE7PvIVR4Jsb+sveQsSw7LA5CdIX6G+wokOh+wLDHW+f2V3/AbpUHJkPLROBERZPdwWXy34Dwq1OE2VRX2qlssziEhAXdIQUNUyzoG5xdwiledkQk1hqcRwRD+Iep2ntd1yUETHoqLD2A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PiOXEREO; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=d80J3l6p; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PiOXEREO";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="d80J3l6p"
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47U0YsTQ006624;
	Fri, 30 Aug 2024 02:05:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=YI7XYYw4j82gM
	EGip8dv75EO2c00MmCzpK4u++0IfcM=; b=PiOXEREObbM5yR0THS/QRuWHUuvvg
	wVHCAXW9LZyOELDb9iL0E136i/WAxpG7/i9mIVtEW9W0pCbjl+tv6dCNJ+x+lwp+
	Ri8aJAS9T5rx97vX7l47m2MO0TdZ3Iiwh6iLYvRbzRDGOZkCQGHQ0S7ZyXoJ1JZK
	dRwvU2/E8SwyTYSg9asUk6PQkiHJu1ueBf5cxXBPTm4Hys3C9Nb/OOny1MdPeE5C
	IR1Cx9Z1GyAOpaQM4OPZGPUOpL0/ihRmkm7q2UxJVKJJ84AWWwkh3RcrgP/QiwMw
	3cyAMSpT1MMvkAgkQj1OmC5zW1+VhWEZZGJ6xMjKb0nbvOVeUnTW2uUxw==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 417f2ydt2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 02:05:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBZWvF2QID9y+loymRpOX9TA30iNXg+wXfGsvXbwK/7HLxRf26X38eEweAhAKbnEFOOX/wnvFskOD+q7B7dlR88irWrhZ3vhX1MGF1z52dCIcZzXI76p8UAwFrNMSi6Jqo1SbbC6HPN5a5sz60E9KnLIyPWRwEm1YnzoeTkNPVxnvz37lrmaA84jEk9jzWOYw3h1GPoSBVgGpUCjlZkrFm5D9fuuHAcTfDaftfJSn4ZaAmOzy/zwOVENe1t/XM5IRVbVf1xf8Ezwy5hQckXnYF2oJq26sx5BiyvPq1gDbC2smpcZZGPHC3vy5NZUE5wWl1MboUHmD5BAK36ReAc8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YI7XYYw4j82gMEGip8dv75EO2c00MmCzpK4u++0IfcM=;
 b=CZ/uPzmGmt+oBkSJX6b3CVPWKvlOsnDahJnZ2Qe74oCyJUsCNSfCw6NXJaLekDiaqR3fLKRq0OabvbidlSdTTb441kq5T8X/sBE95NIVdeNuFbg+5cE78TXCCsam74DaiWQrxBm5DciBxWggxWvuK7CaqG6DeqxSXul6ld6trTnASJMXEStJnMWF2TXgdM0YUq1Vp5Ob44XN5DqZo/TpJ73YTtLHgU3OIWP09avhdw/11AR+1RmSOP2Br8JFrVCYMDOf9djWIwxEnE9lLXGGYwyr6h6YSThut6ti8eVZ+rPmFQev79ZKQO6NrYVeyncGRNVCiPTtjOPnh9FZknh3XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YI7XYYw4j82gMEGip8dv75EO2c00MmCzpK4u++0IfcM=;
 b=d80J3l6pVdcU2UJhVGfMJRRP244iQ8Rvr2ii5QF+UWmyf3COKIQy1JK9p/zyTscmhvqlG8MlC5lwz0+ne34Fw9ZE+w2psKjDKDCACL5x9ZtvytQP/PZupBUsLRkyMhHvF3TCTTnhRu9nDglOVPmHRHsTD/S6QYtp7B8Kh508FGs0qCl6VPz/aBcPKIKnN9bdy31J+UFl7SLLv/o6brR7q2QgWG+J8AkTYPA1yohuAdh1QqXZ7DcHJOGTuYi+GUkmRE6w7xNUydw1N48LTL32qAR5oc1JMDs3EcDInBZ56Zn6+SoQetwVszMcQtODGE9aX+v4yyeFja3b/fTUASjqUw==
Received: from PH0PR02MB7496.namprd02.prod.outlook.com (2603:10b6:510:16::12)
 by PH7PR02MB9411.namprd02.prod.outlook.com (2603:10b6:510:279::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 09:05:44 +0000
Received: from PH0PR02MB7496.namprd02.prod.outlook.com
 ([fe80::d47d:ed:381c:b8d5]) by PH0PR02MB7496.namprd02.prod.outlook.com
 ([fe80::d47d:ed:381c:b8d5%6]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 09:05:43 +0000
From: Priyankar Jain <priyankar.jain@nutanix.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, Priyankar Jain <priyankar.jain@nutanix.com>
Subject: [PATCH libnetfilter_conntrack v2] conntrack: Add zone filtering for conntrack events
Date: Fri, 30 Aug 2024 14:35:30 +0530
Message-Id: <20240830090530.99134-1-priyankar.jain@nutanix.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0P287CA0010.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::15) To PH0PR02MB7496.namprd02.prod.outlook.com
 (2603:10b6:510:16::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7496:EE_|PH7PR02MB9411:EE_
X-MS-Office365-Filtering-Correlation-Id: a3d40c26-3555-48a5-cd60-08dcc8d2ed88
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|52116014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qTqgJAuPBekF8pwNujq9nLFr/09Ibf63azrH76asZsiq5cW+LwY69BjDMp3X?=
 =?us-ascii?Q?xsNJQnQgcBzV+LM54wT5w0e2JyF+S07ALTbmvn4sDr+tAN8VH+qPdRjq7vAn?=
 =?us-ascii?Q?3ND2Sv86A+TVoklw26ZbMRmW/FN2OC9QN/JzUJK3cG9nlnvLW3EZJbDo9n4j?=
 =?us-ascii?Q?sbmPN11n9jDpdYlW9g6sej8smRoil2DhM4ftelrW8hGbVPxGZn88n96IjwmN?=
 =?us-ascii?Q?aCzx4CrdVtxG52x47Fz2QUSCAWq/LLCTBOf70TU9p3NJ5W9mWrtUcGkjyqNZ?=
 =?us-ascii?Q?uOaWcnZcDyPPHEiPMWKW6rbZSzn29mGtE//7l6632q0uyZds1jgCEAhXw73X?=
 =?us-ascii?Q?XVAHSQDomBEsU1j5rLO9VmaTd33W92H6+z33dqWUB8ait/enVhuUT7qqbjTE?=
 =?us-ascii?Q?DsdPOv3FHG4n8+iMbZ3YSmyIuU9l9IKp2D+JRIiIk52ewvV/N1MPIjg/9mX0?=
 =?us-ascii?Q?XCvTXVrCWIaJAnWw/O1EMm2i/IkHYiSJ6lnmPJOoeLW57LxtNUoRTth5bVWL?=
 =?us-ascii?Q?pJVNioST2tFA8kBhpifWevuJaphpFh4/e13AwkxSNQpKOTMd3isyc82DNu8Q?=
 =?us-ascii?Q?YW5jlK5COE1zi24AZ2JYaiSl3ehM0uBRIqakVHdr1z4TFK7fxave14GSMz1Z?=
 =?us-ascii?Q?TMaR3NHI9pwrmHQRR2JKG9CIkqNNDc7dhaMa55jVWWJPGninr6L2mZxoDUAe?=
 =?us-ascii?Q?JL8PYei39DUu4mGYOdti8zD6TjRFLnm2MzKLo5QDzNAFu2NoR72TqHSQDKbw?=
 =?us-ascii?Q?sp9isqXGmtZuxi7AYyfFaIcs9agFGsjM1Jl9WFvK9qVheWShq8vmvGK//SDy?=
 =?us-ascii?Q?TISrwETtbncsCmYo2oV3xURkbF2qrGh9hJ6riiCYXCDqXfCpiAoU0imQTBkQ?=
 =?us-ascii?Q?vT/jx/rVbZMO4+HRURPEjdy5phsA3W9986i8i32d8TgVSqp2tlCPZG2mWPGn?=
 =?us-ascii?Q?m/bhdXmTxsRP7UHyT1GsyWoQFcftVR02MCZAGPV85pn1daNm4I6SHAdszH56?=
 =?us-ascii?Q?Ut96CQVWqVpi9HC8ZpmvToRKt5Gx/UF3QGWL5X/LxH+8jTnEZZOH0A9H4ia7?=
 =?us-ascii?Q?0tT0DJuhU5mlqzB78f29qpjpEo+3QeKn/fvuijGmF1efZoh4UgLncu+nVgRO?=
 =?us-ascii?Q?ZW/T9FRdX5BdyavjcopdxA19BwE9sRV8lh6ALbKL0tE05emzRCJnPzjYVwpM?=
 =?us-ascii?Q?5gEdI494JfjIo57nqjpucv/iSMFrkaUzm/PVJtVxyi+1tQgccowsuO1JzaUB?=
 =?us-ascii?Q?3GyC5Us0rD3spoBpYxcpA5ex75xk1B9u6Q5vxo1RQP1feLLkvoI1DwEotDnI?=
 =?us-ascii?Q?wVhfZ9sevzvk7brexJEn+2y18aiZ0Lgcdk9BvYo+nqOLjw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7496.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jx1IjyXEWfi+ZVLSQdok6ufzeM/PtdPM6jdYHBBt7tSerxffakVtoO/gda/n?=
 =?us-ascii?Q?cAaow0pSEc84brcnY/ImLEC0IVBzCqa9VYg39jDG8+1ZQjdWWqjBWcNZkryc?=
 =?us-ascii?Q?awdakDGn1I3MIjBhY+63Em3nVlcFcOXBgrJRSXre+ofDx/r5n6tB2/v/jbOf?=
 =?us-ascii?Q?h2mfgVnrV0sSA03rgQbD/7ngPybF0CGlnXhNcdEzMoJJmszCx7Hd2nljQBkh?=
 =?us-ascii?Q?74E0OlsODQ+HEfAg7tOIkptA7KQjzezxmsAMO0wIgvuz3bjZtrKCk5TByPoR?=
 =?us-ascii?Q?DYWBmoQQ6ciMDuky7V0WdwpYGGICi9Y/oS9gOdgIs+9DDlrCA34oWtyAL3Hu?=
 =?us-ascii?Q?2gaPNoqgLYDtBdJAkB9rAuFNYKJbLx2Jop/9T+QZZU7Z/EqWFv4KmE7poLNk?=
 =?us-ascii?Q?dvCM2BUkqBgjvqDfhA2q9s3m8IgYovSJ75xQry8eAZ72EN0rFd4VgAvSjSXC?=
 =?us-ascii?Q?h4HPHlOBsUU4qsuNpHSCzHFIM+riFQjpxo+Br/PmJOkzX1MezKafzQSLly9u?=
 =?us-ascii?Q?Azxe6q1Z3qGfagDHJkmYeHCffdnrr7krB7nrLBoKfF1+4FIKPQ2t7c/p35d4?=
 =?us-ascii?Q?TDwjyA4uC1SQBW6SmjRhI5CJUOb4pleBMJlsuL/MdWEWWUiQ6+LBrScsfxWJ?=
 =?us-ascii?Q?K/2VwqrGulq6To62hxevLbZjWmpZRtwb5wyI++mrND2YRAIHTL7+rqd4CfPj?=
 =?us-ascii?Q?BCClRuKOwc8MWKxRlC74ibwfCKEJVX8RseCA8gEnum3+wfuKrbbCDO9cksIZ?=
 =?us-ascii?Q?UHVOF0g+q9qN/6pOi9CKZWotNgihCQEL5OJLfK/Gu9x2F8Pcb4MMJchXxK4+?=
 =?us-ascii?Q?NMRb3JOnY1FbzLgCWjpY3ZrTKdSzPlzghtmONEltepc4sME9WWMVili13lQL?=
 =?us-ascii?Q?HOtVWo29G4eCTU6gVgONPDcUsThfZf7eHUVc3+SyL8Rklrso6vmGIbci292X?=
 =?us-ascii?Q?8Y8opNrhWFpzMNvefSqjZuYjfXVBup2M0QuhDNhivv89pCaHaQn61egIruP6?=
 =?us-ascii?Q?Yugib0B667LltLIOKovfxNgRFuVJCuPzA5oYXnC5gRdIE2hZ/tKlNzBg9/Um?=
 =?us-ascii?Q?Zn20Ek+mIAkuReOM2lLW8aCXiD4KlcpBp9ta1eZUPRbCketnYQJLKjAPekgf?=
 =?us-ascii?Q?nChFkGvphuz+se49nH6ky6gv1WpGwVVxzewsD8D44iu46Pj8M5itOUoaMnaH?=
 =?us-ascii?Q?Se26GK6YgxFhU7N3YcW8UUnqaUKoYflr5Mdu73u9MzIj05v1teeHDkuymKaT?=
 =?us-ascii?Q?hVR9IqW2++FKcIxtwaavutTmveOMcM7uudm+s4Btv7RyKmKxL4w7nAp9YgEs?=
 =?us-ascii?Q?koxKofy269FLQjr+aNdR2u0HpEPZtdpZ4EbZ5IYV2XnfBu39zc8CKH8UTCLC?=
 =?us-ascii?Q?xA776qvqeIfawQNSG71qIEXrjCycGshJ48LE6SooK4DKg0hJhf2MdKaGh3Uh?=
 =?us-ascii?Q?M+mt7JAgitpnkCJ4r+ki67dOiXHxMPVKy2y2s0GBh4sIwoa3LvZ9OBrrlMRU?=
 =?us-ascii?Q?ye2s1vjLhH31KCrDo1p0hfdPAcdPQqe1gk/bFaBEShxht3GA2Bk54X1mcnxu?=
 =?us-ascii?Q?3Wprf8L58dS4LymPmmFOfN55eLmvgTJ5Jk+CCNSFyc6LwWaZ7GImRsZUK9Q8?=
 =?us-ascii?Q?wVY6JwSHte1OUmo4NgkZgiTlkvO3VX+13noe3leYrQoterFs70LiHogj7Jc1?=
 =?us-ascii?Q?wz4Cew=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d40c26-3555-48a5-cd60-08dcc8d2ed88
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7496.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 09:05:43.6520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +IdtQWaVDvshhlWl/5qkaq7c5wlJ1Pl9v/QP/mrQX2+B7cQAtHu2T6NSVHUZVN6hOEzIE4BEjI8vYR+/bUAXTACOPPQ6RVlJF2dndsdNFWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9411
X-Proofpoint-GUID: _qJnsuP-yc60qJttqu0p4dgQeRdZuw1Z
X-Authority-Analysis: v=2.4 cv=dZ3S3mXe c=1 sm=1 tr=0 ts=66d18b69 cx=c_pps a=MPHjzrODTC1L994aNYq1fw==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yoJbH4e0A30A:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=51MvTyaRAOU2H0hLeJAA:9
 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-ORIG-GUID: _qJnsuP-yc60qJttqu0p4dgQeRdZuw1Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_04,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Reason: safe

This patch adds support for filtering CT entries by their zones
using bsf. Max number of zones for filtering is 127. (Although
it can be supported till 255 but keeping it consistent with
IPv4 and mark filtering). Entries which does not have ct-zone
set will be treated as ct-zone=0.

Signed-off-by: Priyankar Jain <priyankar.jain@nutanix.com>
---
 include/internal/object.h                     |  4 ++
 .../libnetfilter_conntrack.h                  |  1 +
 src/conntrack/bsf.c                           | 55 +++++++++++++++++++
 src/conntrack/filter.c                        | 10 ++++
 4 files changed, 70 insertions(+)

diff --git a/include/internal/object.h b/include/internal/object.h
index 8854ef2..658e4d2 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -280,6 +280,10 @@ struct nfct_filter {
 		uint32_t 	mask;
 	} mark[__FILTER_MARK_MAX];
 
+	uint32_t	  zone_elems;
+#define __FILTER_ZONE_MAX	127
+	uint16_t zone[__FILTER_ZONE_MAX];
+
 	uint32_t 		set[1];
 };
 
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 2e9458a..27d972d 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -510,6 +510,7 @@ enum nfct_filter_attr {
 	NFCT_FILTER_SRC_IPV6,		/* struct nfct_filter_ipv6 */
 	NFCT_FILTER_DST_IPV6,		/* struct nfct_filter_ipv6 */
 	NFCT_FILTER_MARK,		/* struct nfct_filter_dump_mark */
+	NFCT_FILTER_ZONE,		/* uint16_t */
 	NFCT_FILTER_MAX
 };
 
diff --git a/src/conntrack/bsf.c b/src/conntrack/bsf.c
index 1e78bad..da5919c 100644
--- a/src/conntrack/bsf.c
+++ b/src/conntrack/bsf.c
@@ -738,6 +738,58 @@ bsf_add_mark_filter(const struct nfct_filter *f, struct sock_filter *this)
 	return j;
 }
 
+static int
+bsf_add_zone_filter(const struct nfct_filter *f, struct sock_filter *this)
+{
+	unsigned int i, j;
+	unsigned int jt;
+	struct stack *s;
+	struct jump jmp;
+	struct sock_filter __code = {
+		/* if (A == 0) skip next two */
+		.code = BPF_JMP|BPF_JEQ|BPF_K,
+		.k = 0,
+		.jt = 2,
+		.jf = 0,
+	};
+
+	/* nothing to filter, skip */
+	if (f->zone_elems == 0)
+		return 0;
+
+	/* 127 max filterable zones. One JMP instruction per zone. */
+	s = stack_create(sizeof(struct jump), 127);
+	if (s == NULL) {
+		errno = ENOMEM;
+		return 0;
+	}
+
+	jt = 1;
+	j = 0;
+	j += nfct_bsf_load_payload_offset(this, j);	/* A = nla header offset 		*/
+	j += nfct_bsf_find_attr(this, CTA_ZONE, j);	/* A = CTA_ZONE offset, started from A	*/
+	memcpy(&this[j], &__code, sizeof(__code));	/* if A == 0 skip next two op		*/
+	j += NEW_POS(__code);
+	j += nfct_bsf_x_equal_a(this, j);		/* X = A <CTA_ZONE offset>		*/
+	j += nfct_bsf_load_attr(this, BPF_H, j);	/* A = skb->data[X:X + BPF_H]		*/
+
+	for (i = 0; i < f->zone_elems; i++) {
+		j += nfct_bsf_cmp_k_stack(this, f->zone[i], jt - j, j, s);
+	}
+
+	while (stack_pop(s, &jmp) != -1)
+		this[jmp.line].jt += jmp.jt + j;
+
+	if (f->logic[NFCT_FILTER_ZONE] == NFCT_FILTER_LOGIC_NEGATIVE)
+		j += nfct_bsf_jump_to(this, 1, j);
+
+	j += nfct_bsf_ret_verdict(this, NFCT_FILTER_REJECT, j);
+
+	stack_destroy(s);
+
+	return j;
+}
+
 /* this buffer must be big enough to store all the autogenerated lines */
 #define BSF_BUFFER_SIZE 	2048
 
@@ -774,6 +826,9 @@ int __setup_netlink_socket_filter(int fd, struct nfct_filter *f)
 	j += bsf_add_mark_filter(f, &bsf[j]);
 	show_filter(bsf, from, j, "---- check mark ----");
 	from = j;
+	j += bsf_add_zone_filter(f, &bsf[j]);
+	show_filter(bsf, from, j, "---- check zone ----");
+	from = j;
 
 	/* nothing to filter, skip */
 	if (j == 0)
diff --git a/src/conntrack/filter.c b/src/conntrack/filter.c
index 57b2294..9feff80 100644
--- a/src/conntrack/filter.c
+++ b/src/conntrack/filter.c
@@ -104,6 +104,15 @@ static void filter_attr_mark(struct nfct_filter *filter, const void *value)
 	filter->mark_elems++;
 }
 
+static void filter_attr_zone(struct nfct_filter *filter, const void *value)
+{
+	if (filter->zone_elems >= __FILTER_ZONE_MAX)
+		return;
+
+	filter->zone[filter->zone_elems] = *(uint16_t *) value;
+	filter->zone_elems++;
+}
+
 const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_L4PROTO]		= filter_attr_l4proto,
 	[NFCT_FILTER_L4PROTO_STATE]	= filter_attr_l4proto_state,
@@ -112,4 +121,5 @@ const filter_attr filter_attr_array[NFCT_FILTER_MAX] = {
 	[NFCT_FILTER_SRC_IPV6]		= filter_attr_src_ipv6,
 	[NFCT_FILTER_DST_IPV6]		= filter_attr_dst_ipv6,
 	[NFCT_FILTER_MARK]		= filter_attr_mark,
+	[NFCT_FILTER_ZONE]		= filter_attr_zone,
 };
-- 
2.39.2 (Apple Git-143)

