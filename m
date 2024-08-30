Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9927016DEDB
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Aug 2024 08:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725008208; cv=fail; b=FN6ymHX/RoCKtfV9ckFOQcJLnPUfI+I96BIyxbaRgxC4BdUZ6rOcg4yCUSCzfkS+k6l8FvczqJ+bigBN0zX/s8RZ5qA+tUJ/qUvHCcF8XnKZIYV+i5Vl3U9NOONN+gDzz1A6nSLGnPOx4SAjOi1WUq/nO/Q7L2R4uoZbnrRBS9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725008208; c=relaxed/simple;
	bh=g0pzHAk9V6fVCkj6EDjkeJgSg74jzzvwTAM0n2DjRD8=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=psCNH36pwZiJlrSGosswWMMdLX+jbQksOxLndUhhxzzc2PFp8E9fFKZIvBK12/9WZBZDLNKgqhdiAw8ZEA3ceNbx/frmjiLzarxaP/TfRNS2BWwFO6TuJOgCRhBUafNPf6ZwJiSWMrMDsBh229obd/OB0NSZXFwWfD+EkovocDc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vrVwojjc; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=vKQWLenu; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vrVwojjc";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="vKQWLenu"
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47TN9FWx005254;
	Fri, 30 Aug 2024 01:56:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=B975uvvzVADWJ
	BnJnl39QnfVVEtjGNdAmfKcV/fdpGo=; b=vrVwojjczmPjSUdQ3mr+F8QA+tX3E
	HnvBlgez87VK4F3HF6U2r3k8ThaulMN9u4BYaerwMQvCMsF9TBiWjCLxYPxu45eb
	s3rsaiirGnKHOW0cd+e/pHefG8UL0NywlYP0RN5vAXmx5MDS1fiiS/bkh3LsJIuJ
	3JKatLCldxikpG7g0+3vgiPpfN/rrzM6OalzH6Gd1OIlV6D5ZRLsI25a5e/iI/mW
	Mz+VcrnmxeO43U3L+QYxoM7ZMj3cXVfoss5dsKQgApV/IERZMG+fQTMVxQJFoZPN
	Lp/87I8p39W/jvsqpSGfib85tHM+v+BAV/OagKq8T1ZPvYAoFVR2xdjSg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010002.outbound.protection.outlook.com [40.93.20.2])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41b2df924y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 30 Aug 2024 01:56:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mYqWXtkDZjmFKDUj2dZTLC5JfCnLTp5k6/pMD++21/4pmmNC2UQFiVUqX0Rs3OJenDB08NQf6vJOk9Bv54/KaHWrJoH9/gnZD6UmLwdUqbTSE+hzvEtjBoQKBP41LUDBP7CSRTNFeBE1sLpgIMzAp5/O+aA8BOBKwm++yAms9ljVMeVZJCNEYUtGu85rGnjoiHbeeNEZor0S4IPgC5kJNEaAiX3xZlDVAitwh9rY3C20Fuq+YDawHTBDw7I/C/3XVDCrWnyRi9U00JgcoP9yVMQXmgOSWuQQPsUSQnKvegaqInxWb5Qc0uRqvh4VtK8gIEOY5j4z0e/JIbssBtpgFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B975uvvzVADWJBnJnl39QnfVVEtjGNdAmfKcV/fdpGo=;
 b=ck2q7rAscvEwR/kB4shgE/tmgReO6On0sLr3pSkOZ23TZ/5eiDJKAw81mSqb7eKl4hgGeq1ikLg+XnTj0XFrEtaFaSBHDBNehv642rfCzXugw0crt38uog//FwlloB8z13h1o6Pn74SsX/0cYECfxmcUtVClM5izPjd42Ib1F3tB6uWrBdfAPAZBQzWesEfsNoJdplj5BNwQp7Rdcn7rBZJssG5K6mb++nPcPQvg/yR6P0zGRpycCC2qLhXH4AMvdZmaQrywoS3FW+Dhpw+kJOdc4S5y5jffcIaE338yG9qmrweMRvqiTGjHBvzNZadm5S0RI0AEzWBdYbjblLJaEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B975uvvzVADWJBnJnl39QnfVVEtjGNdAmfKcV/fdpGo=;
 b=vKQWLenu6Cmb9uuKzc2Td2T3xW6DdWg03KrpqqehlTDdYmSwlrs2r3K5jY80sTB1cSnTM1nDwF8mI4E8hHxXK4m+KHQFLl4u1NjB8O3/DEu0d6AusbIBQxIb5IuYQ92z9bvw9FN8z5QYQ9GPBufCvrIP4XPe+n3aId3mYjtA2x75vRkCzASpnZZ6t4kJrzIWVhi3LMY4Eh/S4G6CKXiHrUxeStUmjk5S6Sk86XMtygwFHIR6+PhSyqSAJQ/yyZ7MAnXGxLczua2bx+TzCxMdQ5+9b0+I2bd7qu6gNxvhX99GbQA5QcTsmVIqh97ZRLuUFMi8rbPngLIP99GH8nXaBw==
Received: from PH0PR02MB7496.namprd02.prod.outlook.com (2603:10b6:510:16::12)
 by SA2PR02MB7787.namprd02.prod.outlook.com (2603:10b6:806:134::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 08:56:34 +0000
Received: from PH0PR02MB7496.namprd02.prod.outlook.com
 ([fe80::d47d:ed:381c:b8d5]) by PH0PR02MB7496.namprd02.prod.outlook.com
 ([fe80::d47d:ed:381c:b8d5%6]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 08:56:34 +0000
From: Priyankar Jain <priyankar.jain@nutanix.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org, Priyankar Jain <priyankar.jain@nutanix.com>
Subject: [PATCH libnetfilter_conntrack v1] conntrack: Add zone filtering for conntrack events
Date: Fri, 30 Aug 2024 14:26:01 +0530
Message-Id: <20240830085601.86774-1-priyankar.jain@nutanix.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA0PR01CA0116.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::18) To PH0PR02MB7496.namprd02.prod.outlook.com
 (2603:10b6:510:16::12)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7496:EE_|SA2PR02MB7787:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e44d1c-1940-484f-9d75-08dcc8d1a607
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|52116014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?llVdCwAzxpdsz1ZB9tVUfTR+BWSQWMyZrW93L89WKgi3qP+6mH6Ev57mr5SD?=
 =?us-ascii?Q?8h37OmRn1nbJAa4VtQbXDYsLHlqESKPeRaTD3hQlxuWW6VCh6/iidIFpgHJS?=
 =?us-ascii?Q?rISHDaSVqAfTvi2euDBxM6L9mwAmmTFat7uZaJjdsZr6BF/g6YcbCAKTqNmI?=
 =?us-ascii?Q?EMB0oJYVEg63+wqYqzFGjyFv8jeJmoYU0DPTqhBBQ1qRtE2zk/s8zmx05FXO?=
 =?us-ascii?Q?HWhGDReH8TOE7xjUQ7V3vKtn8fUK1olHqFpxSm6nKVQP8wKhiV33JFxnD9Y1?=
 =?us-ascii?Q?n1FwIMvmnvbMvMqF+yHMLFkNX/V25jNBOWnWa6/KXdvDepJ9xuqUPDyp2BUr?=
 =?us-ascii?Q?CLlzLeY0Ih/KhHX05YMQSu8IV+efY1yTEYZU04jbI4hs9GLOrB/t/zFZCp9H?=
 =?us-ascii?Q?MpzO4GTFzhNu5Rd5pJHd1RyyQYNf0J+r5+5j1kwWOrw3ZIod35t/1LuMNH3M?=
 =?us-ascii?Q?GtP20rbQ+NgE0Od5TBrD+eblpZgsflTxoESDfdtnslDsQEdI+6/b7dIXSNIU?=
 =?us-ascii?Q?6phETDSNDV91VVRS5//2q5W100xw+WV8q3c8VHklYqKQIXEUw8PWnOHVxp4w?=
 =?us-ascii?Q?cev4gul9RTaqkgF+CnqrWcMELHMGL4SuPgOiVq+XZ+2GHrFyxmSHFvetQbGT?=
 =?us-ascii?Q?VU0CLf0lRnxiGuCU4L2MlsA35xA3mO/4D8NvpLjry/6e1jf2RLdS76H092sL?=
 =?us-ascii?Q?+6TgKGIAiED7c1uJ94PcZPeZytWgnemIArMqEXf8HjymNeXHtSMSgClXHXaF?=
 =?us-ascii?Q?e1wQ3wJbM66I/1E7q4tS3Zy/qDOVjaEJP77132NtxG1CZTFsZ6i2Hw72HWM0?=
 =?us-ascii?Q?IOxMNc2qZKl2ZpR0jz3QzdepT/E0fKlN40wSHAkErLvfGQtXVV/8vWobJu/N?=
 =?us-ascii?Q?XhfATEHHnW/qsUMg+soNzEaIg3wodwjdTeFVguccqZoChBRQww0deRwf2kct?=
 =?us-ascii?Q?pqv/RBeQOlyKutlYai0a7S16vFOxgPoNh6sOZs9Spci8/UoFZTzjUmJh9ojy?=
 =?us-ascii?Q?5TJTnOJSvwI0cvsgeoQqHQhppHvlnmlNMWrICgA3Di+SkNXHoR0gmYhg7uEY?=
 =?us-ascii?Q?L/66sgf0jkE/mgc6k0M1foHX7AyGJYADmoU8N7+nHEQyVPArcgDq5W7tAoHT?=
 =?us-ascii?Q?rUalFoMEUkDcNZr3bges5/z+6SWLSvvXqrH3sgbtD5mgjwDTEGOSzfXIv7lW?=
 =?us-ascii?Q?TEzSJiWSqMD2gr/Dk2vgkL67E3Uzlk0T34NmzX/bCalfXa+mNGrSXwjQcF5W?=
 =?us-ascii?Q?bCfHF4Z4g4nRp3N+cw610Izd+J7RntlOYtGy3rRkxO7iSqCdI3EeeiF5OwA1?=
 =?us-ascii?Q?rfeAnH/DF6u/0lFi2eZY8o6Hfoed2QcDoGf1i6LGbPce2Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7496.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3ErOxLbHp5+9rKL12YXIc/f+Ir26LMS7wyDDskWuzWOpkKO2gmssb1N8gOuB?=
 =?us-ascii?Q?jxBlAqCGHAPVWOpjdw8Gtf1JzKNr6iZ/0pEci+RN8S6gHoY7C2GjE9MGJfZn?=
 =?us-ascii?Q?qSRQQy8iGdjGO/9Ql1pmCJQpkYyNdjDdjQQ42VcwZ5hOpp+/Bam6L4Witk6m?=
 =?us-ascii?Q?wuelkpqpuLn6eR70bxCRCiUs4XBiKTSjBwv8zr23pm5wGDGNocxp+7DY+W1q?=
 =?us-ascii?Q?Dn1kt/NflUhEp82gnTrvlaewK/2oXqF6cVGTRI5moX7GeBl9PuIE+58xz4RO?=
 =?us-ascii?Q?BtvKpq1S/ZDrg7paSl7HIhBh0xJTLZF7MONKlJevo/e0eEfdFHQNU8z4DAa1?=
 =?us-ascii?Q?MpppIbZB2xPbbd7GH9HX+Gf4mIiSRSmZgUsWRPhyIjDlCOcWiFfhqK5t3zTs?=
 =?us-ascii?Q?PE7bp7bdh1hRPGhxrsUamcHbJ/jO/BY1OG68TNR2lZuDe842K9FeItqBpXWV?=
 =?us-ascii?Q?++NeK2zNBs88wo6+izpEtlRdIUACrKVYJyF58HZT+/+IY3AkbMekuBtjngi1?=
 =?us-ascii?Q?yA3/UfhZA1qCw0zPZobHNp+IMizCY6VdWnWMJQU19zvb/9fnlYToBIj1Ui/u?=
 =?us-ascii?Q?aGZNleAfaw2QriQxMDjQ4d1xNDmwmTn04K7/mVxN4SeadxLJvDslrVp70Um0?=
 =?us-ascii?Q?4kdst3GsTHrdYFVXlXdNZMK/TVftqriHKH2/cQAChXUCUg5RzYdiZo7afEqH?=
 =?us-ascii?Q?oax3lKPtWNUgBV5Z2tbVKHoG8dUjXwMU3dhdl1orh0dE1GYKepYk/BSyK866?=
 =?us-ascii?Q?lBaVzHhlIOpDCdW4+hC3khOVgJLcQGswXK8fHbYNNh9OzOffBoNUGSSYUFlA?=
 =?us-ascii?Q?lp9Lmv6u0v/dX6SNPEgO17vSYnyWNvWI1H5SgpyTEvxfUhfRETdz2HohG/0c?=
 =?us-ascii?Q?NVSPCiYXV4iwBZkpc47Z4IWAmWBxrbp1lbq+duaE1V8NJxiFd0wXuX764t1X?=
 =?us-ascii?Q?aeijGvDDX7PPNb4pNlrf6yE0PAjAxvYc0cvN+5XwQC/5LM15HDMmZwXyYF+Z?=
 =?us-ascii?Q?2fOZ/xlmqFvWUGX7FVWyJpqLPZzYnPGq3A53hXD6ISDum92uGt12sOYQfZTb?=
 =?us-ascii?Q?Rzcy2fnGRww9+gqydP7TTfbhMkxe9PteOxagPOnQChp3ERT4pHTKzVRMw85D?=
 =?us-ascii?Q?xJlfd8l9ii82v7PGfeZ0gQaNNjyidUwOi6c36peVFOYV8vM1s/dl2xg2nZCU?=
 =?us-ascii?Q?1A1fTM1OHWSbvmG77h7Czgp0AGwAbA/yZta3uHI6eRZY/9iJKKM0CTdUxA1p?=
 =?us-ascii?Q?pL4lVKjQC5vGs1D4+u2Ceyo90vVKETRL4woBfVs58hghX8iP+2bgTlphYkXS?=
 =?us-ascii?Q?IFKg5url6bwMm7OEXl3RXizwlph5rv6BZ/pt3LvWC9rKerYtp/jDyONREGK0?=
 =?us-ascii?Q?hFx1nX10/9CY73Zpi3PRi/y0FyYv75VoREWJkbZT1oRdeX5XKJPV28lZ7McN?=
 =?us-ascii?Q?rjleEQom9G4pbZZMs5Vc7gBtbZFu7YoOhgC6fZ+pn9c+iidEyu4Hx++6ed8Y?=
 =?us-ascii?Q?S+KRHbHQzqDOksfSc9ovqYFb1SnW7RCmRXOXqtiuJtW4wCWiPM/OS14Wa/Kc?=
 =?us-ascii?Q?KmPZ6Ti512LC9iwXidSP5k+osCHEiD5LDCP1KFfEsIytSiAW7zzo2yOBFi3M?=
 =?us-ascii?Q?mLfsFjHrKrvF4s/+EylkXxbquKgFINYB3n75/4RaKtOmKhP4lheT/vA05RLc?=
 =?us-ascii?Q?P3+N1A=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e44d1c-1940-484f-9d75-08dcc8d1a607
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7496.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 08:56:34.1945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XFANfVnfZjs6khH3C15TRIh09ivXr2nNEWXobStUI6VFV0hfVHHTq4mYoSYMOi/cnlnbIROgOA0FRPYKvkgORDWHaJ+1DC4LjBWv1IG8UPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR02MB7787
X-Authority-Analysis: v=2.4 cv=DIvd4DNb c=1 sm=1 tr=0 ts=66d18944 cx=c_pps a=qtOW3xRV1T1JVXeTS8V0gg==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yoJbH4e0A30A:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=Ca3RLHRxqVLdICoXx5IA:9
 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-ORIG-GUID: Fjhybw4p5H89sE-7rSV2X0epJSAHGsXT
X-Proofpoint-GUID: Fjhybw4p5H89sE-7rSV2X0epJSAHGsXT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_04,2024-08-29_02,2024-05-17_01
X-Proofpoint-Spam-Reason: safe

This patch adds support for filtering CT entries by their zones
using bsf. Max number of zones for filtering is 127. (Although
it can be supported till 255 but keeping it consistent with
IPv4 and mark filtering). Entries which does not ct-zone set
will be treated as ct-zone=0.

Signed-off-by: Priyankar Jain <priyankar.jain@nutanix.com>
---
 include/internal/object.h                     |   4 ++
 .../libnetfilter_conntrack.h                  |   1 +
 src/.DS_Store                                 | Bin 0 -> 6148 bytes
 src/conntrack/bsf.c                           |  55 ++++++++++++++++++
 src/conntrack/filter.c                        |  10 ++++
 5 files changed, 70 insertions(+)
 create mode 100644 src/.DS_Store

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
 
diff --git a/src/.DS_Store b/src/.DS_Store
new file mode 100644
index 0000000000000000000000000000000000000000..2af724bd533135b0fa3282354cd51c33ce26edb0
GIT binary patch
literal 6148
zcmeHKJ8Hu~5S?*U$hdKta<7mZEJi+oFW`_siUbKvl3JC|<)it{2V)_n38V>c#LU|r
z&0C>YXfz_CyRX+Lk*$cda6>s;n48@<pV=xi3WVc~PdUl6yvY0aVOG7IFzy<RL3&(w
z{8Rri^lx$UGL=~>Kn17(6`%rC;1>#5?}fFSKt?J+1*pJH0sB4_xM58k1O3y1;3ELA
zLD~&#pCy3B62O``1|kE~paO%cIbvwgkuO<S6UV@yi{|j5`DD!rMg8eGzj(Q54P>MO
zRA8#WLu|L!|M&18=Km>)J1Rg0{*?mSbcb$-SIXWxdpYa11%8BE%>{0TwNnth9Rs}`
hV`J_3(Tk$4*c$h1;uz?3<ed)W&w%MdqXK`ez!e2N6_Nk|

literal 0
HcmV?d00001

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

