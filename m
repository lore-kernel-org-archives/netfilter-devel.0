Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B3B8C38A02
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Oct 2022 12:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJ3M0C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Oct 2022 08:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3M0B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2022 08:26:01 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70137.outbound.protection.outlook.com [40.107.7.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F391B1
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Oct 2022 05:26:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vjn27uyPPsleiUpCfBeKh5Ia+rfKF+OZIdyAPNp4pDf7KUmfrvqgfhoqWwVSb5eWxcBPNNqYoB5DnpwD1O55dZ8zLeD+TI9WTq7GAKduLi2mzd7NLTTp89Nd+9wJImoma7yR586PbWZKQNE8E51BZIn5n6aBbzuf60VDFVW7gIp0uD0ZObJsoffQyUBb0Z+fEoYsUZ3YoviCEA67dQJHqewgGg4EaXpat62+JmnbYnanupayY7FtCfep8UBJE8Xq2mCbNo0N81lHajlJx30SqwDWke6JPgyXb3m72DA13h7AeTysop8lWRQRoknqd+BkNIps7GRAUwSNWt2Xx3cOJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uv5Fx6HiCZkHqd5KNSPK0nw7ocdmQP0KV8EvAqz50Fg=;
 b=I/smmi2BPaUkBgO/ZKTrZDYRKUDbWAw8Waeatxhb7wCA0QKBIHbEBrfb/GL4bX41PWVy0DQUDbFq/GWQZlTYnyboX3ti9Dkw9VaohUmg51WL44qggH3MoJBHMVcV9mkM3ZpTfMP6enu4Xvgu7tAWGv6THnL/7eNApyzqLv8X7QulPpaq4lmL2QL0AtWsvaObgauHC2yT+LZqkdj7k9wcUCe8rNhdyk06aFKE76G0GueOxNqkmewbzoEEMddNJo0IDN0IDuqJF4HaXgTJKZ1JAyx2lPFeeBxVemPwY94RR2WnBDb53WlEgqox+reSJ+O+dEvzq1W47N20ow9HX+I04Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv5Fx6HiCZkHqd5KNSPK0nw7ocdmQP0KV8EvAqz50Fg=;
 b=V6cAVXb7Acj+iiP6E+GoKPUBRamRODi7jF+NVlth9+m2bvMY4p37zkLaIx2SKZWkYe+HOYTnPvDl7U6pWWvKnwvg2X+R/cTJnpovbKerU77V9gRQclJmQC2pyjJYtyKxcXgMueBb3QmO0vXvpiA1+W6FoUyfHxL/kfOnRHVmdYw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB2231.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:582::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.10; Sun, 30 Oct
 2022 12:25:57 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8%7]) with mapi id 15.20.5791.015; Sun, 30 Oct 2022
 12:25:57 +0000
From:   sriram.yagnaraman@est.tech
To:     netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/2] netfilter: conntrack: introduce no_random_port proc entry
Date:   Sun, 30 Oct 2022 13:25:40 +0100
Message-Id: <20221030122541.31354-2-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVX0EPF000013D2.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1::f) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AS4P189MB2231:EE_
X-MS-Office365-Filtering-Correlation-Id: 63bf0b00-2db6-4fbb-1fba-08daba71e5e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gVrkOJ9sYsjovE22j36epbHuJ0J91H18ty06pa25Q0CQi6MTldFZOBZWTDiqkxlP04gw12XyS4gVpM5RmQDQH7fBZe1cK+nuTNGTCiptzfjK9hT3WK/bztdiwLix9i2Um0klgR0ZSwFSDV58JHooNNKj7Jv1C/E5dKR7LsTrKghCECDtHSB0p2R36IrjtZcZorYCVpQ/MvJ2Rx8jaoLlNpdoATRw5NCBbpDAluyAQsUrXqdocYfNITBDcXhttZX6+R8x25DDu8SJsolIcoPYmD5jK1oI6Ch8c7TXQkkaLp/0mGHlQRUsIUytwp/PWYBhNYrDumgbSMuhV5oJFGOAgC7BlvzR22XupfDdq9gm6MS7OeUnha78r/ceqspg8FYMzKF5Jo3Jqfrx/pXu39uBhscZN+/stT6VYKH5MJepuoRMpbiVS6PiNWhGYMPVNoH8Cqv9rF3nvDhgH6AdYMlr0QMtq+7pDfuby6x03H4Vp/4ZwWb2nca6RrBQmMvNq7RFeeZDCCmmnDIjBeccSpX3vS98o/ZG1i8SaI7nySoeOik43RVw4e2ziW9VNzU1GK62APyv4bhrFofOc2YJHPG4xD4WbvTgQ40G1E1//7iZ46M42JPWgWJI1ya/puzjXt/vz9HxVp9Gzvo3b0/SXwlnr3blCOzK1BUXNl/9rmpuTXCqsuNW6Wu5rHo8HKyIDpyvyJiVKDjH37GeXYazosS2eJZavf8gqNCdvXFdQapwzhD7rHK4iSptzBwb1jMTClF5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(396003)(136003)(346002)(451199015)(36756003)(316002)(66476007)(4326008)(6486002)(66556008)(8676002)(83380400001)(41300700001)(478600001)(8936002)(6916009)(54906003)(2906002)(5660300002)(186003)(2616005)(6512007)(1076003)(38100700002)(66946007)(9686003)(70586007)(26005)(86362001)(6666004)(6506007)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tzlYzrnY+McsZa/xyz2iGrb1dpVBY8urxneroMgeNlGdazXM0IWy+J16IOmx?=
 =?us-ascii?Q?ZX78lfA7COwfq82XBp05zw2C4JsUnX/1Ac/BFjf3SlGpF4B+hI/KzNHAz60l?=
 =?us-ascii?Q?vS5owywEr/u2YJWDlSgVfU0+ni2TM1vBQ1gdnkHoW2wSeZOReHD9FRY1BfEZ?=
 =?us-ascii?Q?RgED6HK1Gkkg4cPScyFMOAGmY7Pjs/Uz7PAMnv3TCmSee0HJwXVF1WLqDRpF?=
 =?us-ascii?Q?xX6hy+9Yfu+dCK6FowrNURXgfS/fjm4UHnIrBXDfnmKLMm55aUHWAbI7sey1?=
 =?us-ascii?Q?CYnkZBqEIuspSaASp9uHaxUMQHHp9eC3lvxmS4DiUu3CGLRvF5PO7eTaIcHT?=
 =?us-ascii?Q?yPm01C9VuWslDFr37L7eXYjNgTeRZERyvctEvanMW4xFzvbuKIqmZhcIOOlT?=
 =?us-ascii?Q?znzY65LV6is0/Rti+L3XQMjywt2iE2lE3aLsW1/0AG0wxLsXEdfzISDPe44C?=
 =?us-ascii?Q?9MnkudT7OEGqJTeLeAw6P48Yop9l+mpdLkogT3wPBz0bdUxvG2syVAJi+rMl?=
 =?us-ascii?Q?79SRBdmeOBbSNrCAAQlC25VEgCRZ/6NWXfwA7f8fkPs0cDCpDAXPyAmPuWMZ?=
 =?us-ascii?Q?9leY1G3F59iRI34/ufErPyHe/zfH1Vh824oEzuSUsifEOdBMzNbj8IvNzLcK?=
 =?us-ascii?Q?dSxiVmKn2lx8eAQCz5opmfpwsKBXp+ip4NPwyiUBM6EnNrBAbeDVfaArwabA?=
 =?us-ascii?Q?lrsiu5KQS+y6fD73CS1+zJFX84RPZPQIo0qhwx7sc0eUUuEn2ULkPugxS073?=
 =?us-ascii?Q?67ieGxKjJjpbzShCDvi+LEsb5SfVLGtHZwZEpWBYKi8miECQgnRSUEAkZdBi?=
 =?us-ascii?Q?UG0CUouHaEAYlPHJC3hS9PsT0BIDLaaYelisrhliPlXC5hgGoM4eetPv5XI6?=
 =?us-ascii?Q?q0vGyerqKoo8KER4mPNtuH/WbaDPkZmsj7IymIWgnJKCpjV+HeOd8lLsVB8N?=
 =?us-ascii?Q?wRzyp736oGPOtGZwUnK8ZprqvTdYhQhgoEHbwLX3vTajdVLCJHkwqRABUaNy?=
 =?us-ascii?Q?OB6m4qUM1og4YgvWIGzmR5VuMJ3ZTpF0AxzyaH6T5sLJ8SQ4tW6hnLtFxoqZ?=
 =?us-ascii?Q?mdk++9pdgeqtlBG3kJyYpHBgbmIrp1UdFyW7GY8CnvCq30vOS0U69XUO9uM2?=
 =?us-ascii?Q?v4jBG1M2TZ7Xa/LkBun8zVkrXMis4+0KJCVV613HmHEqYFl04d2a/afcdxKY?=
 =?us-ascii?Q?f4L0qZIus6u7F/oKYC1fWwNcKjHlrXxMOzNv+pZ3YwESJAIxPqial2wGgIaq?=
 =?us-ascii?Q?dBE965IZbKZGxaK7iuOO1yQ5PIsUOIr7VvytGkHVvVMmNsxFeS9WMT/tyQjB?=
 =?us-ascii?Q?z0Lt2ovrOwGhe9rhSrPMFolb+xogeHUZ7g91O2+GoOgMBwlx7BpEp5OhM43o?=
 =?us-ascii?Q?zlR7sUnk55LmJLU9IIHGJBsBqkKL5OtFF2ZjvpyWSF9L60H88+iTYPhKKkNm?=
 =?us-ascii?Q?kI9jEx9dDY/wroJ+0WIr9Mcd37r9swZd9D48Z7TSS8NEvLk14cmraxS55O5u?=
 =?us-ascii?Q?lOCQt7L6D/Qz9c/zRJeU89t8ADGVQYXrCZn9/Zom2tdCQ0cUyUvYDh3aHPkd?=
 =?us-ascii?Q?plZQH8TiEJYXNAH8NqU8QlZ2/iIp8SDzQheWrQVGji2eMzivXEc0Wp1heLMl?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 63bf0b00-2db6-4fbb-1fba-08daba71e5e1
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 12:25:57.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ISH4XSmyLKsVnLmu0mIMG4HnuO/H5UYdfuTrIhtAiJcT/ibneyRvxugcriVUM9iyVY7tifw9u28Ub/ZfgIo9MS7L1LBWLOV67I9V25ptQ2M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB2231
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

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 include/net/netns/conntrack.h           |  1 +
 net/netfilter/nf_conntrack_proto_sctp.c |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 13 +++++++++++++
 net/netfilter/nf_nat_core.c             | 10 +++++++++-
 4 files changed, 26 insertions(+), 1 deletion(-)

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
index 18319a6e6806..cdcff0ed094c 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -19,6 +19,7 @@
 #include <net/netfilter/nf_conntrack_bpf.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_helper.h>
+#include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 #include <net/netfilter/nf_nat.h>
@@ -422,10 +423,17 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
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
+		fallthrough;
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE:
 	case IPPROTO_TCP:
-	case IPPROTO_SCTP:
 	case IPPROTO_DCCP:
 		if (maniptype == NF_NAT_MANIP_SRC)
 			keyptr = &tuple->src.u.all;
-- 
2.34.1

