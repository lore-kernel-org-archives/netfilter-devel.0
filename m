Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020087.outbound.protection.outlook.com [52.101.150.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A97926D4F9
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2026 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771580286; cv=fail; b=mES5oi2GtQDmDxxKO0UTKer/nzW78Bmkd+FGcmBKlfu7ntfWQVm0nzo1fRk66iUKhbOZLzBne+qvToIwOdUrE6ffYmVf9RD410DGlxueeg1Vknbb7P8L5u24ihvdNY3BVKG7PEmm93u0cxKo9KCHCEpop5PZwAZjerUvMcF4TV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771580286; c=relaxed/simple;
	bh=bsmZO+uoy2AWEBp9BfALz+NyaVBsP27BPdSkfEDnsT4=;
	h=Date:From:To:Cc:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=dMZ4b+UoweiK+LdewO6H5vno95ua6yxmNATECZEndRZKxO9eaPtxjWkWhLAVyg4+71S0uz4Zaq9jHdkCWitp2NDci7EJhNIbf2iQkhlTKH4Ev3MquKlntBbaPHccOHmMoOrcXKWyrBYyHjScrOJkBrqhraaqf15PIdElv3I5HP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com; spf=pass smtp.mailfrom=heitbaum.com; arc=fail smtp.client-ip=52.101.150.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QfVarUm9nmuYqzUOluILaorppdpdwmqdmY+ul2rqP0BdQJdyMfDuREeTsgztD7glux4t1iE8jJh0ApFoUNUDFHTakEtxdrq5BM/mwalpn/QsXjrrcJSxwSg4BNA43uHXEX8DRsroiRNU/2h9mcXrYG+3613UJAi9kyEONbzmlr6CJW2X8RQJ/Pcmh9evQV45gVDQz/X29/NqPV+/awjHMfXkXdDnsGQxoOAY8AlND6TU22RP9LoQ0OQojnFWrQzVzAJ64Cvx7YDinEOtymzZ4AvYbtjIz57+5J/HkMUJf/relSndd1ZAEAzUbmBjs0gcBIvXgVyAuLEfLqx43Oh0dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sv0Fv/vDwuGTA9MuTVLgIGNkzvtkGUbVF4PnWKGkkEY=;
 b=JpaXfwj7r2sFK7Akw6BxR8njDv8WlmayuHCBAIL7edxzDyVaBLqKeWyDrVQiWSzps/M5pTEty6MqyuuIZ4j1/xFcb+YZPEocJJ23Kt49fKeMXgeINgD0m1MdmpkKCDKQtjNq6Sy8/yjpes6KhpnLvgIXK1liZSfJfUtie3XBZC6YGsDdIUuhcyzMGCLksrmMyfhPDlbXODLKBAjHYasvYf5bEtMjhK+s4n7fk6cJKHob3IyJ6MJuYZCDU9OMKyZY45x0JBHExBwobBwlCdAy00DMvyfuToDCQNyRpoogJt5tcr010tARwp6KD1u1Mdg9xTy3jmlUuoZRMOyEl6JI2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=heitbaum.com; dmarc=pass action=none header.from=heitbaum.com;
 dkim=pass header.d=heitbaum.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=heitbaum.com;
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:73::13) by
 SY7P282MB5676.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:2d0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.17; Fri, 20 Feb 2026 09:38:00 +0000
Received: from SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f]) by SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 ([fe80::7340:fb70:eaa2:ee1f%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 09:38:00 +0000
Date: Fri, 20 Feb 2026 09:37:46 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: netfilter-devel@vger.kernel.org
Cc: rudi@heitbaum.com
Subject: [PATCH 1/3 iptables] xshared: fix discards 'const' qualifier
Message-ID: <aZgragyOBo2vEOUe@6f548583a531>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ME2PR01CA0095.ausprd01.prod.outlook.com
 (2603:10c6:201:2d::35) To SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:73::13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SYYP282MB0960:EE_|SY7P282MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e20c207-6087-4fe7-3b99-08de7063bc60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2t2W4X26WP3kHmiUPVGorzxCMWUkL8mVyD9z4QnWVYOb0V9T1VvWr+Mdrfti?=
 =?us-ascii?Q?VxemRDKESnzcWPtrGkievywiuLUQBIhluBjp7xmaYNCqiDlwaZX5jcpruQhX?=
 =?us-ascii?Q?CLNPlLqT7DIsPznt0YtW01HmMK/GpsjDBFuALkd9d0XJClHGjyVStmu8j5gt?=
 =?us-ascii?Q?PBz3zpU++LfPMkloFNhKlUGQWHpHfV3u9OTNviEflxCI7E6Rx0j9EVnqdP3b?=
 =?us-ascii?Q?drG2NqGo8Aicvm3DdXGLLz1GJThjNXx4+6oTEMMYPTOIcPszFf/O/ckeMbzK?=
 =?us-ascii?Q?qvWDaz7GnGQE+XuUvFh70/xWScB8se+qnDEKYqy9Own/YTdTlitGfwgVG0MU?=
 =?us-ascii?Q?KB6eGYfzVPy+tihehUVHFbhbMsV0lyPj9B2gqor9q1oMhSxKH7WBFP8/CKdt?=
 =?us-ascii?Q?1AoIKasB1yjg8JBlOm50X9vERCIgPyCb+rxuhnyImZV3I/WxTCtE0t5jWq90?=
 =?us-ascii?Q?SaDv04GsPx70mnRDYkIHWAJnUv5GIsXIemcDErZ80tXVe9hEP6Rvn2tHBI5l?=
 =?us-ascii?Q?UPdjQCAAUo7wZ8POtfchG5wb44aDR2BZzjHWYA8a87qLiig31lr+iEKCmyv0?=
 =?us-ascii?Q?7GywWTx3AimaKHTU/pKgNk8HVyjUe8s9gcmP3so15JljNCxI5hOCFDrteuZz?=
 =?us-ascii?Q?AgpTqLw601bCAqJ8uVlMZJ4fqrmmJfK9rZDgw7d3EdUjGsiC8ZGHYQdW4jU3?=
 =?us-ascii?Q?6UKTC+MOw12dgPzD2694vkpIKVm+xIHxXAsRFHoaRdQRKeHFfb0zkbVbqrFO?=
 =?us-ascii?Q?UR2vtxQ7CgDG/Wh65e9Uce4xDqeQO1RhNDXxNwXKWw9S5M4tuINUyQ07FNku?=
 =?us-ascii?Q?WrqiGXADNy2lcXFqEphqsJrxN4yQf4ZRkXio7OdlUa3sPErJNaxgmlSmQbu4?=
 =?us-ascii?Q?3u+9bj9DEzoEO32fqxVsA8GojynItdJurmwFuQSseRp7pvWuAlvgBRPALW6h?=
 =?us-ascii?Q?D5H3qFjIzSCjfbZA4zYDpV2ETgvM1yiBo/GczOReOkY40AolaHlE0U2yr2++?=
 =?us-ascii?Q?snTQuMQYIHbN+HZBUpxR0EoLvSOOngeiWrN0t3GfDuqStoWuxB7oo/sxyKWu?=
 =?us-ascii?Q?Vz91jLKcbc3+LhMpAss4fFcAfT9Qdc4MPLuXxYF8M4zt3MqG0cHjHxKW6pUE?=
 =?us-ascii?Q?xRNYUZ0Hy6D1CIjytPExC8H77k8mrtL6UZTs53slAeC0fXN1b5VWg0FCNX4K?=
 =?us-ascii?Q?zxoQNH6E3awDXY5rw3bMSqTRVjpnosbYnYT7P7QzSU2jE9ChkVBClq3Y12lN?=
 =?us-ascii?Q?WM1+8eR3t/DsN9QOmrVy7YaFiy5KxTILeYqMwTzds44BZ1i2CPY4WYAWyfps?=
 =?us-ascii?Q?mvOKKg1noU0mC4u1X8WWJNO7EoWO6Z9zpA8pVpf102q/Kp/KQvn6W1qhemk6?=
 =?us-ascii?Q?vhSzL895jwXS4EgZr71mfQ2n4VEwwd1qG+hEzVGgr6WeFe040qHbFw0Tz4j3?=
 =?us-ascii?Q?a0KaEEB5Wop32pXbuImhMQy8+JBpneFobieY6RUJdjkxkzJ1Oxx7SProiBLj?=
 =?us-ascii?Q?p1hJPVx5WuaQ3tAQhpRCmjSbkuOmP7UB106yHLAMsTt5AiA+1ycq3otwPuAH?=
 =?us-ascii?Q?SIJhkuW41LjGVGkne4o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G321MRSOUKYj5Ipr/ZNjaWKffTwjh5D7munD+QJbUkESuTseOQb1Gtagng3k?=
 =?us-ascii?Q?h5yF4Z2SkP9EmpxUhJRbTyAOcDdduakAVjuUOZ9NsdFAOCtNEocIfW9SyopM?=
 =?us-ascii?Q?ZuBxs59AlN9BwgVdMt2jsaUG2OQucgCBozGCQJSLMrMPsMakz3ZOautA7a0F?=
 =?us-ascii?Q?cBb43Mir4f4FL4opsFbkjx9RAlOuaqLxv5eUYBAXpPQxuzatjVyS/SXzNNaI?=
 =?us-ascii?Q?nQMp4YatH9v31ZNhs9ydAs+1AbZyqdETC2FruxuVhnIcw01m7Fre/r7M7SXE?=
 =?us-ascii?Q?3zeaKotHUfFb/tLED+5IL6GHg00yheS5o6TH+MiheonLOyh5YAu0GFiXmwjp?=
 =?us-ascii?Q?EZ33GpcOVunhB2sOBMu6STHZZZuHRFmPzbXSY18jls27Msf4BzR2kxrGfLiU?=
 =?us-ascii?Q?z4dUHuBpclBsa8Oww6p8R0KmpxZutLyFLw0JeDMLb6ZNJ08pBfD/qb8IMrgK?=
 =?us-ascii?Q?VQEEYNEHF9xLQz3KaISP3ize5RvC1sW/fMTeltTZmZnUSLFSi/bIE4y9DR+o?=
 =?us-ascii?Q?00+mFCREy3H3XrjPZi36oDbQWTJhJukTyjCJ027jjtisDc3VxEaUD9Lk1CvX?=
 =?us-ascii?Q?to14/0BVLWaWk1GpIvQdp9n7DgmRBhvFJnAe7ENKTj4CdEDrLHbGwIVvdOGA?=
 =?us-ascii?Q?pOtwY/4VHy9Qid57+9N2BhMCS73/zeokOMmk/x422hv+rTCLr/js8XSYUwfM?=
 =?us-ascii?Q?n8KgEGee399nvuihfXISdUD0dAt5Qf31a5ty+9Ioeb5ShkoZiQ5WGdwo8aXM?=
 =?us-ascii?Q?6dw52KohaqpRpC2vt07dcjKOFwngRk+n3XeAFNCa+ncMl06Cx45CuHOrzEYp?=
 =?us-ascii?Q?XTnz/JbfOGArZwWUwqcy+iTE2Y1IEmYU4h+uxwCCU/Cjhg5rFIoTDfKrd++y?=
 =?us-ascii?Q?Ia6LOnBYTTr5tfq7eL2G65FOjS3Qe7cwAL3J0mbi3O28C9IotsjDL8dLZlPc?=
 =?us-ascii?Q?Ev7GSbxEEvECGIPbwbfO6KJwukktrhvO/taWGHx3DuvKcJk3j9/xFnaspjj/?=
 =?us-ascii?Q?8QuChJZ6+BhGO/TWVLcIvleteR8+Mue92NXlIn4OsTVxlA9e1T0q+OEPPlQQ?=
 =?us-ascii?Q?n2Lo/23ZNndiGwA2OZi6qt/v52Fr2fwoTbFxblZbXGHNLpUfWhfKI3kbNS/v?=
 =?us-ascii?Q?hhOtOPKBVFgT9QVBGkEujyHYjEsUOggl08LBeMn8woJr8aBeQ1GVQT35DDTK?=
 =?us-ascii?Q?3GvYg1VIo/cyS32J+UDg9YVcDRKxeIYAod4NOUdKKR9hecpG/+Y8eRClTkEb?=
 =?us-ascii?Q?qDgx6crePIWe+AQZQrhjglNKGAkcg3+vEA7FHtum0s6Dm1NcbCvcuMQtcfDk?=
 =?us-ascii?Q?oDU106nxMp4u4L0XOVL+D1HSvb7ohwllqmudGKsf14Xo/AyHNxEXNQYplmdC?=
 =?us-ascii?Q?Cx2Qd/xGoVzwrilBl+kyJRjD0GSuU4mQq3JsgENyx3t5HsZDb56EU+2mQWLI?=
 =?us-ascii?Q?vc4xXueuMvdHQIR91B/fZxPDPMdP78yuRfgJg63LzVwPNfJtwuzqDmya5UKl?=
 =?us-ascii?Q?8dKC1so1kVQkOEcqpDQsF3A3qqGKO8Y8qaNrI2X+WvAaRlT/Yr709084pBUK?=
 =?us-ascii?Q?aT1Wn5rqlU/j4Bb5Dbj2VKfeJyrhPIZ+m/YHDF0VtNsdQT5cu/lwiu6vMYxd?=
 =?us-ascii?Q?jx80n0C83TsiA9BF5e3I4pJa8moUmaNM1voZKI9fKRRLnJNDrSZVLZYCUzNu?=
 =?us-ascii?Q?gPDbATot1j/hiwTq3GPK/PK7076W+qffpYNu72RT0r/CXm3Q?=
X-OriginatorOrg: heitbaum.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e20c207-6087-4fe7-3b99-08de7063bc60
X-MS-Exchange-CrossTenant-AuthSource: SYYP282MB0960.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 09:38:00.0231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 35ffebb5-7282-4da6-8519-efab29b0108e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6VKjLKryeUUk/zmIPoEZG6BBefYS0jjSJ81DkQdTjWO9/skCqRDbhtK0333JK+T5TzN0M2/fw/2OBQDmd8/xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY7P282MB5676

argv is passed by parse_change_counters_rule and do_parse to parse_rule_range
as a const char. parse_rule_range modifies thepassed in argv, so pass as
non const so that it can be modified without warning.

Fixes:
    iptables/xshared.c: In function 'parse_rule_range':
    iptables/xshared.c:912:23: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      912 |         char *colon = strchr(argv, ':'), *buffer;
          |                       ^~~~~~

Signed-off-by: Rudi Heitbaum <rudi@heitbaum.com>
---
 iptables/xshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index b941b8df..26e91e37 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -907,7 +907,7 @@ static int parse_rulenumber(const char *rule)
 	return rulenum;
 }
 
-static void parse_rule_range(struct xt_cmd_parse *p, const char *argv)
+static void parse_rule_range(struct xt_cmd_parse *p, char *argv)
 {
 	char *colon = strchr(argv, ':'), *buffer;
 
-- 
2.51.0

