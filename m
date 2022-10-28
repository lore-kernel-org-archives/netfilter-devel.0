Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E7DECAAA1
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 20:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiJ1Uwl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 16:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiJ1Uwk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 16:52:40 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150121.outbound.protection.outlook.com [40.107.15.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EC32475FF
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 13:52:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gOO9+U9np/1dTLDLqO60ffyIOGwOnHvEixHT7uL/rCT1QjfU/uj8FwrrBi1l5QJYOmPI0ZedTVT9MOfjBHtS7/4PpDndHhvhug8LfHRZv6QYabzr63pRMzMLQwAlZZdzJ8jOiLTIQzY8WIHanov0MzfBk5a4mFeCDwLptAB41heuu9S/v2WhKpxQEQUebYd/m7BNFrsX0sw9J3Zm6TfkBqWPj6zYFJ9T1pWh1WSeuhIp0KQpf30dn8w7mpIUIvzUEDwEPj2vuPrD2dCNyayyZKrmJQREP7zCdxNHDRGT+yWWR8LrmbHeKg5ezSQG90HZN5nuBml92J+YkvGCw0oVCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JxCLCbY4lj1UZ4PX8v1q0hMRYk+eLpmtGa71ViOZ8V0=;
 b=bbvXGbeX5japdlJAAcRYsaqJxlsWJUyEvVSHkvMnWuMcWMF0X++ZCFKfXL5GwIkUYcoMlC8u0UpW0rofxtuKC0Znw2l1Ko1+NtR9CDiDKMQFc7XaCm90J4N7yEQARuo0dA6QROyYjPJ2K3TraCARTgdcpWz92w3MM+o3rSPumh45B5cQoFDwpyQ7jsOtrfhSw+B9abPtuWNAFOvlV/vh6MVcz6TROM7971EdicyXg3MmsWraL1yDLGxMLmHuzwf82ZpR2Dd956NiM3sBdQkj7O462E2CqnP8IbcV/j0tsrSLCOwjShxyBZNEwmPZRtbFl6d1fbigdlK9UL5kUUEIzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxCLCbY4lj1UZ4PX8v1q0hMRYk+eLpmtGa71ViOZ8V0=;
 b=miLQny7abhHyi+ImmQ5/k7C+lIRkjJeyM6tnN/VJY+da4qzfeAK7vltvYHw6kdh5T8zyxL8Hyck+isOeEFz3Lxm3Nilzm3p4cWAnJiW0ghmjd/694VxoBnjIoaqiq1vGEDS6okdqxBmu8ojXGzp/IzQcm41nvqODMaWxufTAx8E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P189MB2563.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:1c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 20:52:37 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::86af:ff77:340b:3faa]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::86af:ff77:340b:3faa%9]) with mapi id 15.20.5746.029; Fri, 28 Oct 2022
 20:52:36 +0000
From:   sriram.yagnaraman@est.tech
To:     netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 1/2] netfilter: nf_ct_sctp: introduce no_random_port proc entry
Date:   Fri, 28 Oct 2022 22:52:24 +0200
Message-Id: <20221028205225.10189-2-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028205225.10189-1-sriram.yagnaraman@est.tech>
References: <20221028205225.10189-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PA7P264CA0022.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2df::10) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P189MB2563:EE_
X-MS-Office365-Filtering-Correlation-Id: 01a78a08-f300-489a-4c98-08dab9265827
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 16G8SaiHYSMZM2+3X4dyqAEQUw60413pzctiWj+2TWHqnUThUiMsDBFCqJhwIoVCi2Nv1yMMRXGdJl11JvbK5ByA7ZWJgHmq4UsSWlOZq/JzQH/25w9+j0kdBnF/T55FdOiymawsHk3Dqy4dMerydatw1U+/OJxPh9tUItzTObjXZ2quwL+72XSTtBklJyTB5aCKIgkz3uRjGFSlRTv1o3nj5EzCJT8rbmdkKo2G1kJofr5SJ4lOANRzMVAEpGiOPSNkXR4dc4IwSYwDE5zSXwtJxsiHDQEIVt5U2gHYypkpqBwrp0RqqSu5qrqlYkb/73eKrefwJcLL0HrIl/5jhICiP1fNkAaoZ+fEE9nxVyBjE6EGVphRjVSObL+lmPkHBg22wY50f9FYSGEhUH5mbH67smJ4MOBrWRlTYc/vfKPOJf+Ku0KOFkLKLJ28PU4xLVNOCX3/pnWfCJ69wiQv1OiGGtuyegWrKjh4Hu09tcO0fkSqXGg8mtqv6o/QOG4ZighKLHBvUWKwjlj4U4Zotc2VUFYMXtecQdI29kjlsotIgTvWdbWqchVcf8OTM2GX8F/WppP1Bvf81awQekPLOxUZD9j016wfTjBwjz4ZXozIgQDP/qTEcQcA1ew/0/fYpjXZEfzS1XVbeGTnT2ZbCkeZ83qEpoMw94axTDwuQxBeg1xkv3IG0sDq+Fw48gtnqZ5g74a9lt1YqP5a8hIxH23upc5Gx5zoo3Z2QVWxOcpw5r85khmtajaVhNo+4qDP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(346002)(136003)(376002)(451199015)(86362001)(38100700002)(1076003)(186003)(2616005)(6666004)(6506007)(5660300002)(36756003)(2906002)(70586007)(8676002)(8936002)(83380400001)(66946007)(66476007)(66556008)(4326008)(316002)(478600001)(6916009)(6512007)(9686003)(26005)(41300700001)(6486002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dGUvQh5/aYMILVBFcXv+GLHBppHuV2vp7MwmktPQsY7E5z4exPzOgqfTPnWs?=
 =?us-ascii?Q?zGRHFK5Tj2cXGFUBDnzH20U6V8RdN5uEPmUiBaAHoRCNfzj4FRp6NdiiT9G6?=
 =?us-ascii?Q?gmHub960qrO0ffQWUJS0z/tbELE5qVg6zaB7GEm6O+/26ifmhsXk9ZMSCT/r?=
 =?us-ascii?Q?gSZXUUE35Y1+shiCZjWxzuXrYlw7ppU++czooQAxo5yWoyigz3Chp6/Lnic1?=
 =?us-ascii?Q?OQciR0opssEkNuYWH9Ee0xGofSvg9CLopqBiUUlOyvlMVHTJGQOoQpZCBFBN?=
 =?us-ascii?Q?k+7M1KvAAd/Q9O/oQ2eUgKcO4SeW9kzAVB6qEAOkpPZCgxH/G+fzxcrNHQbN?=
 =?us-ascii?Q?0fSRaNy3l7T/jVTr9byAAvfIQdzN4Mv2gfXkudIlruzsTnnZfFMg0U0oqnxj?=
 =?us-ascii?Q?91Iz/cbr5l5f7hBstlzYr2tUCT4AXepET6cmTkAUOs/q/iqtF4ux+IioFObq?=
 =?us-ascii?Q?fd5iN4OybO/mKGIAYoH26JD5ussj+4aaO7euzSpHgWO57pPipnzlcGtFjsCu?=
 =?us-ascii?Q?NDYqIB3FJZXPXtV/FVVcm4SXHRUH53CJGQFr2BfFAmhAyVYecYbY1ixmB7+M?=
 =?us-ascii?Q?4Kb45+CvaqssV+I9dMa3UbwTTvI3esOZbP0sTbtB7CxTyE1ESzmWOVUwlRDi?=
 =?us-ascii?Q?OPPLN8lHUqw3CozREWSbXMmzx664ksff2+nBPOWWXbam7iZqAq+uexpFfGbg?=
 =?us-ascii?Q?x+injcktWSaI07mqbwHEEg3fSGtfk0eiiyAP9V9uuefW3aH48/7z48DWOR+m?=
 =?us-ascii?Q?/O5//ttGYtFi1sFDhNclXnrua+ZZ1w+EsJe+BB69bLjuuq9YaiPTo4aZE/TM?=
 =?us-ascii?Q?Z6il6gxmxszWNIQNJRMKJm5wwvBEWwYvqdv1av/VJu4+uksqhyShFywl84Bz?=
 =?us-ascii?Q?L/57acZ9ViUoG/m4Wa9Qg9WB2ffpZkx0T/a03unL2KUYll7yS1xA9c0kfY6V?=
 =?us-ascii?Q?Y8W7pdsb2DsN2zzA428a3EQQ907HZ3iafMwow89J7rFJh35FJqm9jXz3gF5o?=
 =?us-ascii?Q?57JeIOav1FUVviBWEI8Xo8bKss0q6IgIJdkN5Bg4ekPRn/J92IlIfdbxwKu0?=
 =?us-ascii?Q?1y4p7l4S3YWcogOxWyZM+70cj5O6Lod6vz+JDWyYFt47wxDj2bHrbLNn31cM?=
 =?us-ascii?Q?ApjzQ6d/AIWj0qj3etvnmtA8WtkDHJT1MhSUTxueFW32eU+Gvm8C+Z3Lk6uF?=
 =?us-ascii?Q?Ur/rLEqJbt6a4+rM7iP/pBeObyXkijR7YbIrothVJS5lYQ4/QXX6y5mzlGRG?=
 =?us-ascii?Q?Dw4TNk4NURdrrnJxmYvIWOcgEuL+xoH6EvjrPJ3v8uni6J9wL2QfbGSeWpgD?=
 =?us-ascii?Q?hmE452W1t9WFK16hyXAqEdT61kBmLs8j3a5WbZJ7f8cZB+flwXBb9KNSSF3z?=
 =?us-ascii?Q?RDkb9XapVUnbQYjc8sNNzzuPeEs9PH8R/7OK9Ycz33SbRQkQoSnh3JCUDQ6e?=
 =?us-ascii?Q?FgcAKqclphP08TclcKo/J12Ms+mBeCiq3+tpdVZr6kXplbNRHXrvoIxtA3cG?=
 =?us-ascii?Q?Mc/fNwBKQo09TYYu50G6RPrjAYQ1bAavn8pyTO6FijkUxHAAEnmswi9BbHOU?=
 =?us-ascii?Q?1J5PM1odnvRdFy3CdkfWpUo4dS9sw1AlYr3ykcGz561L+r+OhEE1oH3ddLFF?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 01a78a08-f300-489a-4c98-08dab9265827
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 20:52:36.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTYhIkZoaXzADxsi4MTzccfPqmyqEKDCZoaNKuXJbnBfrZwGHcUjMExBCaepUQXbcP14TBWEbNE5GnevbSxXQDswCYaayZy7/pqXYBfv1eE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P189MB2563
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

This patch introduces a new proc entry to disable source port
randomization for SCTP connections.

As specified in RFC9260 all transport addresses used by an SCTP endpoint
MUST use the same port number but can use multiple IP addresses. That
means that all paths taken within an SCTP association should have the
same port even if they pass through different NAT/middleboxes in the
network.

Disabling source port randomization provides a deterministic source port
for the remote SCTP endpoint for all paths used in the SCTP association.
On NAT/middlebox restarts we will always end up with the same port after
the restart, and the SCTP endpoints involved in the SCTP association can
remain transparent to restarts.

Of course, there is a downside as this makes it impossible to have
multiple SCTP endpoints behind NAT that use the same source port.
But, this is a lesser of a problem than losing an existing association
altogether.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 include/net/netns/conntrack.h           |  1 +
 net/netfilter/nf_conntrack_proto_sctp.c |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 13 +++++++++++++
 net/netfilter/nf_nat_core.c             |  8 +++++++-
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e1290c159184..097bed663805 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -60,6 +60,7 @@ struct nf_dccp_net {
 #ifdef CONFIG_NF_CT_PROTO_SCTP
 struct nf_sctp_net {
 	unsigned int timeouts[SCTP_CONNTRACK_MAX];
+	u8 sctp_no_random_port;
 };
 #endif
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5a936334b517..5e4d3215dcf6 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -699,6 +699,9 @@ void nf_conntrack_sctp_init_net(struct net *net)
 	 * 'new' timeout, like udp or icmp.
 	 */
 	sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
+
+	/* leave source port randomization as true by default */
+	sn->sctp_no_random_port = 0;
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 4ffe84c5a82c..e35876ce418d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -602,6 +602,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
+	NF_SYSCTL_CT_PROTO_SCTP_NO_RANDOM_PORT,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -892,6 +893,14 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
+	[NF_SYSCTL_CT_PROTO_SCTP_NO_RANDOM_PORT] = {
+		.procname	= "nf_conntrack_sctp_no_random_port",
+		.maxlen		= sizeof(u8),
+		.mode		= 0644,
+		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
@@ -1037,6 +1046,10 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(HEARTBEAT_SENT, sn);
 	XASSIGN(HEARTBEAT_ACKED, sn);
 #undef XASSIGN
+#define XASSIGN(XNAME, rval) \
+	table[NF_SYSCTL_CT_PROTO_SCTP_ ## XNAME].data = (rval)
+	XASSIGN(NO_RANDOM_PORT, &sn->sctp_no_random_port);
+#undef XASSIGN
 #endif
 }
 
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 18319a6e6806..de0134d99d58 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -422,10 +422,16 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
 		}
 		goto find_free_id;
 #endif
+	case IPPROTO_SCTP:
+		/* SCTP port randomization disabled, try to use the same source port
+		 * as in the original packet. Drop packets if another endpoint tries
+		 * to use same source port behind NAT.
+		 */
+		if (nf_sctp_pernet(nf_ct_net(ct))->sctp_no_random_port)
+			return;
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE:
 	case IPPROTO_TCP:
-	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
 		if (maniptype == NF_NAT_MANIP_SRC)
 			keyptr = &tuple->src.u.all;
-- 
2.34.1

