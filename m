Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2065.outbound.protection.outlook.com [40.107.21.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4481D173F;
	Tue,  5 Nov 2024 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.21.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730801231; cv=fail; b=FPyt6b6yILEmBH98upsMpRcAVE5esD7GnDaCqUuh/hxJ0kFgH6LePEY34aLklrX0YFAN3INWUqJ8tboLRedMq29EkRZpEFtb+Yai2k97hUfn6Gf92F7POcO+9gnOxddA2zQxFywG1gHdsasD6uxiCXAVbJSvO1XLShDQuOyGpyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730801231; c=relaxed/simple;
	bh=03llzCMpQzSoq15Zs/K3QFSrYKjwR6YIoTppAfje9fQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=XYms8MEwZXcIdETbyPyVdqsYh+lmuLBPSzyuP23z099D7xlSWkgXGhRToBnfFpnvqOab1eYwEMly9sejEma1iOzHtGociM5B9zYubV8DyWPtYQDayllyBFMc171IdC+r97j1caBRH8Ev/uEZk02j2vnMgB2mohPJ83kf9BT7aT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=A1lKSCcP; arc=fail smtp.client-ip=40.107.21.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="A1lKSCcP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DDk/9LvZ6orgfhg31F7XK7e6j3V95hhXUqGDgTty+ABftz0bSOd/EINcc/6KNwGkR+Jj4ZPLOkb0ZvwQSZ7feTbtWygbPlfn1bzz+uCG7iZQ7wFzG3L2CLvNO9HOt4HHT0BtrPALJsFckymL94GRLotBR0pbBv/utE1+E/rO4r2sOjU9Uw6cX0blvV/rQ9qLLFdaJkpzm81IpyUWtbDA0acQGtL7sgKzGLnQgvZuX80hs9g232gp9wV7W/PxeQrPGRDsAqDZcJv8tG3KsuFcD6l3InZKG73Hh4XXB10H1zOu/vep9a7bqjKOqI1WjXeBoO3id7ChJlWdwSG9Sx3hcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RkxxDYKC3TbRMxWKBTv0GuslqoA/QDk4juOlWYYSrJs=;
 b=kXmKtk0jM0Ble0pIWKFebmmL7K5E3at6UpC1IV4o4DukMcI7PkDDr80W0md7ACdIEw+EuSXqvuc9T0Me2HCpG/Q7zzHbGPVTWs9OZciweofA716q2sNixF4EOmOEqgTC+sZ+LfW/Od5ZVf9r5EAwOC5H0vADmFRkITX2LZHN5YeYmsiPoj9lbiHhSNYUp9HPDxG3cbkJzPu5/Z88dQyIqlEXkfdOeYE0UcXwA5yjKWWZ+AQTXT8aiu9LF8H2g0rVLzO4fQAK1/YultL+K/ffuCR4KKpqggYVfpRTuC/898nz9EuCXExgRtqYTOlcrW1IermD5ZxjMMZIda7acTCBaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.101) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RkxxDYKC3TbRMxWKBTv0GuslqoA/QDk4juOlWYYSrJs=;
 b=A1lKSCcPjGyJueIWl2bGSk/acQrJJJbmTR/3MOIFfhylCdh8FpGfu61UQnRVgAfD+i8vbDjFdhvWDrzN0cdziB593PdpLuA9INBzh85DaNbx/D6iGjrQbIRh3uRWL8RNf1p0YbUhn6J6bsrs0vQbqjW17QylqVwv+3PbmnxFusU7niJ8o4a71Zp8bSxmWfm8Juc1Y4NDbyGmUPRrujCT4KxMBNwI7/VsoxgS0yHqXtFrgbuypvMzztPDiBxLmQvb/9jkdH4ocXtLybH1lmbsRsWGqqsDiuE/RX2N4BemyofzOI3q5VUH91n6brgw311x5lVeyyKHfIUq0qICrJMjAQ==
Received: from DU7P191CA0026.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:54e::6) by
 VI1PR07MB9876.eurprd07.prod.outlook.com (2603:10a6:800:1d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 10:07:05 +0000
Received: from DU2PEPF00028CFD.eurprd03.prod.outlook.com
 (2603:10a6:10:54e:cafe::a0) by DU7P191CA0026.outlook.office365.com
 (2603:10a6:10:54e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Tue, 5 Nov 2024 10:07:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.101)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.101 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.101;
 helo=fr712usmtp1.zeu.alcatel-lucent.com; pr=C
Received: from fr712usmtp1.zeu.alcatel-lucent.com (131.228.6.101) by
 DU2PEPF00028CFD.mail.protection.outlook.com (10.167.242.181) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Tue, 5 Nov 2024 10:07:04 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr712usmtp1.zeu.alcatel-lucent.com (GMO) with ESMTP id 4A5A6o2a024723;
	Tue, 5 Nov 2024 10:06:50 GMT
From: chia-yu.chang@nokia-bell-labs.com
To: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
        joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch,
        horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org, ij@kernel.org,
        ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com,
        g.white@CableLabs.com, ingemar.s.johansson@ericsson.com,
        mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at,
        Jason_Livingood@comcast.com, vidhi_goel@apple.com
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v5 net-next 00/13] AccECN protocol preparation patch series
Date: Tue,  5 Nov 2024 11:06:34 +0100
Message-Id: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU2PEPF00028CFD:EE_|VI1PR07MB9876:EE_
X-MS-Office365-Filtering-Correlation-Id: b171bcc5-0725-4de8-fc87-08dcfd819947
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUdKWmRETS91ZVU3TjFrQ21tNlRONUlxT2JwRVV5cXhzaWFwZTIvQ2diUWor?=
 =?utf-8?B?bzJIdGIrNnROR25CTWFWa1dLQ1FWa3F0Q0RqYlM5ekZBeUZZdStMd0lGYUtx?=
 =?utf-8?B?MnhvQThZUGdwdm1FdWdBTThWRHBCWUR6andiYnRON3dlWkx6RFBXbUFWQ2FY?=
 =?utf-8?B?dEhBN1BmUGJQaktvNU5VQW1sOTBaSEprYVBrZWJvUHpBbXM5TUp6RTBlT0x3?=
 =?utf-8?B?VmhXQkZBYnQ1VDAvbmNtNFlUKzVabDRhelBJS2hCSjJXdTYremZqRHVTUlQ2?=
 =?utf-8?B?eEZaWnRqWVNBTEtXM0NrVVNpNzkvUE1aZ2FFWlA3dE9ibHBvT0xJaHg4ZnZj?=
 =?utf-8?B?RU03MG51aWhaTEU1Nno0bS9iVUZvQkx1S2NqWTNuRVE3NGZRRXpjM2w1eFhL?=
 =?utf-8?B?ODBvUWVlZCtBVmJ1bGJha1JZZjQ0b1NoNHg1VStqcUpZSkpJT2tZM2NJeis0?=
 =?utf-8?B?U2tPSkl3WXREZmFDeHFCeUtIZVRxK2h4aHlld2ZoQ1AzYVV0V1REK3ZGQlZV?=
 =?utf-8?B?VEYyWjU2dmdPbUNoekxjSXdLZWpQTzdMYmlNc2xoaElDQXBDTExPditCY0xl?=
 =?utf-8?B?NDFzTkh3VDFOZkhwRk0rTlJ5Vm85cThsdk8xMVg5VTl2TlIrRjFDZjNSdWxZ?=
 =?utf-8?B?YkhyamJSVDhod0Rab0lRVE81bjhoRklFN29OUUUrcHQydXVDa25GK043R21K?=
 =?utf-8?B?TXNVdkpXZHdhT3kvbkw3dnNycUVzSUpkR3I4ZWpUeFo4QWpxMjdwdFBNNFRR?=
 =?utf-8?B?YmRqMFp1SXVZR1NRVnN2R3d6Sk9tMkpMTnJHRzVWYWpjSi9PeFJVaXo4cFJz?=
 =?utf-8?B?Ykc2cnhyUVYyRDhVbUh1QUdPdlRxdk9scTR6YWZIZlFQUW5RMHNUcnc4bmZu?=
 =?utf-8?B?T1BZSTJLYTExM1BaRjh0dzR3TEtZSnVhQVE2bDR0ODFFQXN2WFhXTUt3T3Ry?=
 =?utf-8?B?MVdDZWxEdXVHVERkaWpVUG9ZR1cxbWdId21ndU1aWVMxUUlXTUxCczVnMEVO?=
 =?utf-8?B?ekV5V3B2NUlMbnFoL0tDMnI1KzBuakJWZW9sb1dwVEIrNVRTZks0dGtBVXZ5?=
 =?utf-8?B?enVtUkkyOUtsVTRTejkreXc4YWRaL0tHYnZNODFrdzJpUFkwayszdnVHbVow?=
 =?utf-8?B?MDlralk5OVBsRGppOVJxc295bHpJb0diMCt1bWlUSllKN0FuUDRoNUtnMWFx?=
 =?utf-8?B?SmVtbHhrS1dnWEpKc21yL0ZreU51T1hTZmc4ay8zTDg1YUVBb0JIQTRmUlhD?=
 =?utf-8?B?Y2JDRHhYSVpjOVZpRUNCRFowRDJDYnhKSzhXQTE5K2drRzV0NXZOZ005M2t5?=
 =?utf-8?B?QVdZcmFmak5oR0phWWN4UnQyRWVUSnNJUndRd3RnWlRJbk1CdVZDWUFhQTNi?=
 =?utf-8?B?Nkd0QVN2YnVUTEJpM1hhT2V6aW5nQ0p1MEQ0SWI2NHJDRzNuMEp3RHZBTXl3?=
 =?utf-8?B?cWpsYnNqL0t4cnB3azRuSXJnQjcrVE1CVXNnYXhSWGFPNDdkb2R5MXF1YTl0?=
 =?utf-8?B?aXZXWWgrMFpTdVZrc0xIMWZPaXd5Y2l1STRvMnExN2RtdTZldllKV0E4N0U0?=
 =?utf-8?B?cHhBT0NadkFjQ05ISXU5WmJUREZuZlB1ZTlhc1kvK2xsSU05WFNCb2NXaGZD?=
 =?utf-8?B?Vm81ZDhiZ3crRDBpUG53dFE2ci9JRm8vNlNZclIxdFJBdmtrLzdxczhZVExX?=
 =?utf-8?B?OXhodG56NzdOM2p3dzZmNXdBTTJVYXJTY0pJQkN1TTZLVkIrRjZBZ1NNL2pk?=
 =?utf-8?B?M2p5QnBIcDlnc3VqZDdwWm9lZm1KZnYwbWRhbWJyMjFkWmpYeG5VM3lFKzE1?=
 =?utf-8?B?emJzNVROeFNTUjRPc21jbU1LalBvelRKbUVpVzh4ems0aUgySjBkNUxKUUhY?=
 =?utf-8?Q?39ct51akUHFdk?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.101;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr712usmtp1.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 10:07:04.2445
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b171bcc5-0725-4de8-fc87-08dcfd819947
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.101];Helo=[fr712usmtp1.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFD.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB9876

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Hello,

Specific changes in v5 (5-Nov-2024)
- Add helper function "tcp_flags_ntohs" to preserve last 2 bytes of TCP flags of patch #4 (Paolo Abeni <pabeni@redhat.com>)
- Fix reverse X-max tree order of patches #4, #11 (Paolo Abeni <pabeni@redhat.com>)
- Rename variable "delta" as "timestamp_delta" of patch #2 fo clariety
- Remove patch #14 in this series (Paolo Abeni <pabeni@redhat.com>, Joel Granados <joel.granados@kernel.org>)

Specific changes in v4 (21-Oct-2024)
- Fix line length warning of patches #2, #4, #8, #10, #11, #14
- Fix spaces preferred around '|' (ctx:VxV) warning of patch #7
- Add missing CC'ed of patches #4, #12, #14

Specific changes in v3 (19-Oct-2024)
- Fix build error in v2

Specific changes in v2 (18-Oct-2024)
- Fix warning caused by NETIF_F_GSO_ACCECN_BIT in patch #9 (Jakub Kicinski <kuba@kernel.org>)

The full patch series can be found in
https://github.com/L4STeam/linux-net-next/commits/upstream_l4steam/

The Accurate ECN draft can be found in
https://datatracker.ietf.org/doc/html/draft-ietf-tcpm-accurate-ecn-28

--
Chia-Yu

Chia-Yu Chang (1):
  tcp: use BIT() macro in include/net/tcp.h

Ilpo Järvinen (12):
  tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()
  tcp: create FLAG_TS_PROGRESS
  tcp: extend TCP flags to allow AE bit/ACE field
  tcp: reorganize SYN ECN code
  tcp: rework {__,}tcp_ecn_check_ce() -> tcp_data_ecn_check()
  tcp: helpers for ECN mode handling
  gso: AccECN support
  gro: prevent ACE field corruption & better AccECN handling
  tcp: AccECN support to tcp_add_backlog
  tcp: allow ECN bits in TOS/traffic class
  tcp: Pass flags to __tcp_send_ack
  tcp: fast path functions later

 include/linux/netdev_features.h |   8 +-
 include/linux/netdevice.h       |   2 +
 include/linux/skbuff.h          |   2 +
 include/net/tcp.h               | 135 +++++++++++++++++++++-----------
 include/uapi/linux/tcp.h        |   9 ++-
 net/ethtool/common.c            |   1 +
 net/ipv4/bpf_tcp_ca.c           |   2 +-
 net/ipv4/ip_output.c            |   3 +-
 net/ipv4/tcp.c                  |   2 +-
 net/ipv4/tcp_dctcp.c            |   2 +-
 net/ipv4/tcp_dctcp.h            |   2 +-
 net/ipv4/tcp_input.c            | 120 ++++++++++++++++------------
 net/ipv4/tcp_ipv4.c             |  28 +++++--
 net/ipv4/tcp_minisocks.c        |   6 +-
 net/ipv4/tcp_offload.c          |  10 ++-
 net/ipv4/tcp_output.c           |  23 +++---
 net/ipv6/tcp_ipv6.c             |  26 ++++--
 net/netfilter/nf_log_syslog.c   |   8 +-
 18 files changed, 249 insertions(+), 140 deletions(-)

-- 
2.34.1

