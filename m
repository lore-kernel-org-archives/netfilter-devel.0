Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2086.outbound.protection.outlook.com [40.107.22.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E52C1F8921;
	Fri, 27 Dec 2024 19:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735326766; cv=fail; b=rG0EweKkD79v8yVjnvUzNCsys++hJ3XZYIXhsB/XjjdO6wFWAD6mtL/6KB5ZWmi5aFxCeUNvQTV/s/09Ul35OkLmjlnXe4smyRfGTSj+uuBU3q9pZkcFtn07LKsXNgs+6i9ggzbhblKAyRigp+rGUJdU0bD45xtRHs0L8t4KxT4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735326766; c=relaxed/simple;
	bh=rY0M4fQDezES8t234X4mXt7x4tDEawpk6xM/Kwua1oo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=S6eZAu8dC/f4JP/geUHlAMdsb+oZqXpRBlBeN69N7HG/g8CICVaouI9tG5dKAzdBwxSAcetWw1vDBl7U6uHpTmHBITxUTXnFpjepY7H/nLGLjGfB1KDetPxbrNGDKUCg6qFOh+0oltDxxanK+i5iGqnUAaizHvt4JVxQX9AXJ+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com; spf=fail smtp.mailfrom=nokia-bell-labs.com; dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b=XEWLqZZG; arc=fail smtp.client-ip=40.107.22.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nokia-bell-labs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nokia-bell-labs.com header.i=@nokia-bell-labs.com header.b="XEWLqZZG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yAl9eOJW4ixJHMsaYNqttiTG6mReQ180nLZs0OfYXlPH6GWViHGJFPKkZzMwBr6DPaNsp/wkQjwdnWUaSE3c5a621j5ofx3FNl9RHJPRICSd4e1C2rLlZZCAVMRYyjrNCrbglXs4doqGuKSJ2jnvNVmDgMpUJHSCCzpAmuQLrGPLml+dxtH4awURbz+zTMeso7y2+AI1K7hjUkjOeqEKiinngCyAiG8Laa7CkdifzTyKBoVsmTLsJQPDSLztu4ensbkaTpgQLFI+3felZ9QSG7zbCZpEHwD0JDjx9XT3NQO/+3Bk4X2BWOLBnTzju5uCdHAJvaBelxp7f+sIkS4zpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yEYeQ9qLm75yycrn1XihjRK6iZednYaCYKsRGajyCvU=;
 b=gc7TsGNbpEN8MOWR57OomvE8eI5R+0pAWfsm0tqHxZy9cz7avM5O9Gk5lJwYf0hjoOVgHOPcysf3IIExHBPtkH7cZ58Y7jUVU1Eg46DK3V/dR3IE67HuhT1mRvsGT92G7jbiL37OqpBj3Aa6gUnjKsGrVeV+CUXV00b9RiAVif2TQn1UtP7E85GST4NYS/dDrIHwE5stNpFsrO6XrCaK+M5B4z99sQhdVzxmgEs/HwmpaxCljilmlbAXtT7Erxr6NuoAtXGs2hIkme3avE36xDhqZFFeL9NT5wm6aIOG9/3puiDCTVBZU6GkpM2cjNXgcqnzj5AZSNsG1OI/n67eBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.6.100) smtp.rcpttodomain=nokia-bell-labs.com
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=nokia-bell-labs.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia-bell-labs.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEYeQ9qLm75yycrn1XihjRK6iZednYaCYKsRGajyCvU=;
 b=XEWLqZZGdr5MDFq2F0GkfDb0NIeR9nmkRPRpxEhhnCHcxkF0dhEZuEgAyL3h95nvyFSiY2BcAWI1t/nMCzsIcu2p4D8cwYRK95APxm1nnYWw8kCVbBQ6bafCIOvYisiKKl0U+PoWJIxqrs9CiJ+cSSFeEk2LlAplWlJ75lCQrrHff3tihypJ8GhS/DNNjBpQAYnxuLkCPhBED8E0lyXYpWIRSOUzXAbNj7ZHA5zwYfqAiWRG8p1hZ9R/F02jMD25pG+vxgnYrHnlfgrEXWIn1/kefbaZKOrZ3Mf7VvONC+ASwPZ5gkdwFtUHkK7RPIj8O28DV9RFuHOfoDNMqnsM0A==
Received: from DB3PR08CA0032.eurprd08.prod.outlook.com (2603:10a6:8::45) by
 PAXPR07MB7821.eurprd07.prod.outlook.com (2603:10a6:102:13c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.16; Fri, 27 Dec
 2024 19:12:36 +0000
Received: from DU2PEPF00028CFC.eurprd03.prod.outlook.com
 (2603:10a6:8:0:cafe::af) by DB3PR08CA0032.outlook.office365.com
 (2603:10a6:8::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8293.14 via Frontend Transport; Fri,
 27 Dec 2024 19:12:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 131.228.6.100)
 smtp.mailfrom=nokia-bell-labs.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia-bell-labs.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia-bell-labs.com
 designates 131.228.6.100 as permitted sender)
 receiver=protection.outlook.com; client-ip=131.228.6.100;
 helo=fr711usmtp2.zeu.alcatel-lucent.com; pr=C
Received: from fr711usmtp2.zeu.alcatel-lucent.com (131.228.6.100) by
 DU2PEPF00028CFC.mail.protection.outlook.com (10.167.242.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.12 via Frontend Transport; Fri, 27 Dec 2024 19:12:35 +0000
Received: from sarah.nbl.nsn-rdnet.net (sarah.nbl.nsn-rdnet.net [10.0.73.150])
	by fr711usmtp2.zeu.alcatel-lucent.com (GMO) with ESMTP id 4BRJCH2Q011940;
	Fri, 27 Dec 2024 19:12:17 GMT
From: chia-yu.chang@nokia-bell-labs.com
To: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net,
        edumazet@google.com, dsahern@kernel.org, pabeni@redhat.com,
        joel.granados@kernel.org, kuba@kernel.org, andrew+netdev@lunn.ch,
        horms@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        shenjian15@huawei.com, salil.mehta@huawei.com, shaojijie@huawei.com,
        saeedm@nvidia.com, tariqt@nvidia.com, mst@redhat.com,
        jasowang@redhat.com, xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, ij@kernel.org, ncardwell@google.com,
        koen.de_schepper@nokia-bell-labs.com, g.white@cablelabs.com,
        ingemar.s.johansson@ericsson.com, mirja.kuehlewind@ericsson.com,
        cheshire@apple.com, rs.ietf@gmx.at, Jason_Livingood@comcast.com,
        vidhi_goel@apple.com
Cc: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Subject: [PATCH v6 net-next 00/14] AccECN protocol preparation patch series
Date: Fri, 27 Dec 2024 20:11:57 +0100
Message-Id: <20241227191211.12485-1-chia-yu.chang@nokia-bell-labs.com>
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
X-MS-TrafficTypeDiagnostic: DU2PEPF00028CFC:EE_|PAXPR07MB7821:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2cccb4-167b-4b0b-9848-08dd26aa6c37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHAyYisyOUJGUEFPbS9ia3ZBQ3RXc1c1M0pLYlNYeTgxbVAxNmVkQm84ZjNr?=
 =?utf-8?B?S0hDS2V6QTJXNTdaN2pIMGVTVnc2SzRPVjdOcWxqMkZZM2lnZ3QyUEh3d0hM?=
 =?utf-8?B?SjV1dStCdXFTM3dxS0xUOGJINmM5WHB1SEdaUXlSYVNSZFg2NWd3cDhlSWJB?=
 =?utf-8?B?Ymc3R1pTbitJSWVCd2JGRFEwRFN1NUY1SWwrbGc2eUcySXlXS3IwbGpzVkhT?=
 =?utf-8?B?YmRieHNaRjk0NzVDcmlnS0FjNkhxUEhpczRhSks0UG9FaUsxWE5ZQ2M1SkRq?=
 =?utf-8?B?UzgvMG1oblNkRVNndElwQ3VJVmVxV0xidDBLMXcrVndneXNhWGE3cnlMSkVF?=
 =?utf-8?B?UU82VkVyTTdmWm5RTXlVV1paNXREaXFaZ3I5TjF6WTM2YThRMUttOEEvV1VT?=
 =?utf-8?B?M28yb0RhT0dTV0VoeE5MNlVLRGZ1ZXE5N2ZRNjZDU0FidWV4WUhGL00rY1NB?=
 =?utf-8?B?bC82VXp0MlloTkpGQnlhRmJmQXZHQksvYnZMMFkxRi9rMEFOSytIWmFiWHhm?=
 =?utf-8?B?d2hlekRZUXpUUUN3YUxOQkw0OUVkTEpTWVlyaWtQZWh3UVB2QmFUdjdCS21K?=
 =?utf-8?B?QllwM0Zqd2VORW9DZXl4UU83Unc2R0dhb0ZvNUIwSUNaY3NReTZBTjFZcy8v?=
 =?utf-8?B?LzZiY1EvSXBndEdNTThIcUxvWGJGZHhiUW1zSWZINHBEZ3poUDR4Z2Njcm11?=
 =?utf-8?B?NDhCdW9tcFk3cWJMOWdyZHpqZmlUT1Jzc1lIOGxyRTRGdWlna3duRis5bjZX?=
 =?utf-8?B?a2RDeUlNRkNmYzdLL09KU3hsbkkzcE9LWkdQNjR5N082MWN6azZJMVNaaTF1?=
 =?utf-8?B?YlA4d1lvY2lsa2FXREJ3NWdPWVJrWmd2OWdBOGdvMUw1bG4yNEhhWWpkT0Iz?=
 =?utf-8?B?WmErcE5EK1BsWk1xa0lXNndRU0k3amgyUmYyb1VLZDRlUHNKN3E0Q0psV0JN?=
 =?utf-8?B?b0NaUVVjMGpFdDNQZUYxVjA5MGduYXlUVlJYTjdMVGRMVnRISXhRS2ZRdlVO?=
 =?utf-8?B?dVBkRXlKRm4yNDZUNldkSjFhZ2VpbEdDR1VuOFB5V2J5ejNHMk50VzRGUStr?=
 =?utf-8?B?M0J0S1hWcDJJNDNTajhKakNaTENkUzQ5S1hTVDBtOXE1NWNYLzl3RThwU1du?=
 =?utf-8?B?MHQ5aUtMaGIvZjNPTkdrdlRORCtwWmRhaTVnZTdiRFpzU0hsMkNVUDZRVWl3?=
 =?utf-8?B?QWZhV1R0dVphWXZMc1MrTnkrM2cycks5Z00zL1FxRTFjQXgwWTY5SGM5ekZX?=
 =?utf-8?B?eTdQTkw1TkNNcVYwOGJpemZuelRibVNnQ0ZsTkZUcmwrc2prZlZNMytPNWpt?=
 =?utf-8?B?MVlNOFhtL1hUQnBOYjk0Z2FESDUvR3A1VUMrMm0raUduaThoTUlmMWlmTVlE?=
 =?utf-8?B?b2NzdnUyQXR1UDhONVpWTEJnbnA3MzJaOXhYb1FoN1Q5OGRCbC9Uc0JQWUlk?=
 =?utf-8?B?VmtUUkxZcnp6a2xTTElwVStpYTBUcnRHSmlQSWlma3RGM2pla0hxTDczZTAr?=
 =?utf-8?B?U3QwdTFIVzF2Tm9IUW5vR1BjcWpraWY4QTd1WFpEbjN5dzZ4MHFMNTIzaEp3?=
 =?utf-8?B?Z1EwNlR0V3ROeW5OZFQzQ096bEQ2WnZnWFNRRmprTGFiaFVpRDhEYjRKY1lD?=
 =?utf-8?B?T0gwQzN0NTBVVE5kaUs0cHM1UFdHVGEyNk5PbWpYUDRnWlM3ZDdqZ05WUlRp?=
 =?utf-8?B?OWY5c1BGMHAvaDEra2FGalN6OHoxOXo0VmlVajVUYjJiU0VONVdCMHFrY3pt?=
 =?utf-8?B?SEhCT0dQTEdLeFdTSk02SjhFTnc3R1RFRHNMS1BFWEw1bHNlRVVxeW9DTlg3?=
 =?utf-8?B?aHRhdE12ZHIyUmFRYXFJeGxiY1BtcS9UUXF1RDhhZVc1TWZuN0xnVlpCT3pS?=
 =?utf-8?B?dnRsQk5abHdzMVJwbG1hZEVhTERLOTBJUDFTOWVTcFEvSVFvUWEzZlFmcVpt?=
 =?utf-8?B?SW04VUJoRWhla2dad0dxRmVIakY1U3pMWGh1K0tOTWxVb2hqREtNeHdkT0pw?=
 =?utf-8?B?L2tXVnIrWk5YdVhDZzRjNkdxN0lkQ0JlVnBnV2FhZmRwY09TbmQzZlNWSzBy?=
 =?utf-8?Q?+zqLr7?=
X-Forefront-Antispam-Report:
	CIP:131.228.6.100;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fr711usmtp2.zeu.alcatel-lucent.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 19:12:35.7106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2cccb4-167b-4b0b-9848-08dd26aa6c37
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.6.100];Helo=[fr711usmtp2.zeu.alcatel-lucent.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028CFC.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR07MB7821

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

Hello,

Specific changes in v6 (27-Dec-2024)
- Avoid removing removing the potential CA_ACK_WIN_UPDATE in ack_ev_flags of patch #1 (Eric Dumazet <edumazet@google.com>)
- Add reviewed-by tag in patches #2, #3, #4, #5, #6, #7, #8, #12, #14
- Foloiwng 2 new pathces are added after patch #9 (Patch that adds SKB_GSO_TCP_ACCECN)
  * New patch #10 to replace exisiting SKB_GSO_TCP_ECN with SKB_GSO_TCP_ACCECN in the driver to avoid CWR flag corruption
  * New patch #11 adds AccECN for virtio by adding new negotiation flag (VIRTIO_NET_F_HOST/GUEST_ACCECN) in feature handshake and translating Accurate ECN GSO flag between virtio_net_hdr (VIRTIO_NET_HDR_GSO_ACCECN) and skb header (SKB_GSO_TCP_ACCECN)
- Add detailed changelog and comments in #13 (Eric Dumazet <edumazet@google.com>)
- Move patch #14 to the next AccENC patch series (Eric Dumazet <edumazet@google.com>)

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

Chia-Yu Chang (3):
  tcp: use BIT() macro in include/net/tcp.h
  net: hns3/mlx5e: avoid corrupting CWR flag when receiving GRO packet
  virtio_net: Accurate ECN flag in virtio_net_hdr

Ilpo Järvinen (11):
  tcp: reorganize tcp_in_ack_event() and tcp_count_delivered()
  tcp: create FLAG_TS_PROGRESS
  tcp: extend TCP flags to allow AE bit/ACE field
  tcp: reorganize SYN ECN code
  tcp: rework {__,}tcp_ecn_check_ce() -> tcp_data_ecn_check()
  tcp: helpers for ECN mode handling
  gso: AccECN support
  gro: prevent ACE field corruption & better AccECN handling
  tcp: AccECN support to tcp_add_backlog
  tcp: add new TCP_TW_ACK_OOW state and allow ECN bits in TOS
  tcp: Pass flags to __tcp_send_ack

 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 drivers/net/virtio_net.c                      |  14 +-
 drivers/vdpa/pds/debugfs.c                    |   6 +
 include/linux/netdev_features.h               |   8 +-
 include/linux/netdevice.h                     |   2 +
 include/linux/skbuff.h                        |   2 +
 include/linux/virtio_net.h                    |  16 ++-
 include/net/tcp.h                             |  81 +++++++++---
 include/uapi/linux/tcp.h                      |   9 +-
 include/uapi/linux/virtio_net.h               |   5 +
 net/ethtool/common.c                          |   1 +
 net/ipv4/bpf_tcp_ca.c                         |   2 +-
 net/ipv4/ip_output.c                          |   3 +-
 net/ipv4/tcp.c                                |   2 +-
 net/ipv4/tcp_dctcp.c                          |   2 +-
 net/ipv4/tcp_dctcp.h                          |   2 +-
 net/ipv4/tcp_input.c                          | 120 +++++++++++-------
 net/ipv4/tcp_ipv4.c                           |  34 +++--
 net/ipv4/tcp_minisocks.c                      |   6 +-
 net/ipv4/tcp_offload.c                        |  10 +-
 net/ipv4/tcp_output.c                         |  23 ++--
 net/ipv6/tcp_ipv6.c                           |  26 ++--
 net/netfilter/nf_log_syslog.c                 |   8 +-
 24 files changed, 263 insertions(+), 125 deletions(-)

-- 
2.34.1

