Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993A2C32793
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 11:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjARL7S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 06:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjARL6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 06:58:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2130.outbound.protection.outlook.com [40.107.105.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC26B5CE66
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:15:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L08nElZAe4wt1qB93K7BJ6+fpsdBcdCIvEEvTkuSAEFPim7rA/hkjUn1iBMcSghsTKYh3+kmj5A9II95R4/EoWmiXbTfcSSQImN6sVFG+LterRQdHDx39it0LdbmR4ng3mJP4bsYNrHIsD4LvXaf0XKEON3MfEILlPuck8kuQyZuGjU8mlTfVwwEOT5BYiwW7wtjkjwwWaYxgg5+NI3eC95h2n2WX2e3WtcBtvBNFTMmG5UKaWICY8gKuBMEkjVNa54lV08gC4Qb6PguNUH9tOq8TXZjDD6ejFLSPGj2L63kypHK5e73hFca13AMY0uhQsT0xRULK5IZkb7B1AvkBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZlpnvWPUNBpceQy4iuQrQc6GbW2xrSsfTCPAd1AzcJo=;
 b=dPCjdfZvdR0FD9dmxR1FvJOvEtECkmYRc96UGkv2CHfHA2UKuWRbrrX4dE4kSNd+69tQSvJSnQsItBcSMxGoQ5C5msbZZhrEBHhLHA5MKpyKWvyeKXTGSiB9hSncKeFwKWiqIgsGx/dAXliqwj11Bq0r9E4hLgbwY42vOXmAS1bERar3VsrE8Z18mLFigqW1/vjj+daslkzsm91CPvVnH/gI5v2P3/n7jF95HcJgIlwOfJezHQptPAxxC0ARfHY87Vz9GvMW2B0q7WNRRp1xB1W9yl0+UOhkshQBCNgY3LYjM2d+A7bx9At7plbz12Egm6EmGJW5NcM7gh1jBHnfBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlpnvWPUNBpceQy4iuQrQc6GbW2xrSsfTCPAd1AzcJo=;
 b=RXkyNOX0ByiLh+txFI418U2oJDfmu2YAeVJou15rDjhjuul/lRsBmXAYFr0AH5+yGgezNl4oL9TrRJ+OWxQeXgpjtqBrSHy46OjgSQ5c1t32CGculIVJkoK4jrhe0qdUI6qR6l0Hco2lF5wP5LnhljjJtWA7nabQrI+qdKSc4n4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P18901MB0783.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:15:14 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:15:14 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 4/4] netfilter: conntrack: unify established states for SCTP paths
Date:   Wed, 18 Jan 2023 12:14:59 +0100
Message-Id: <20230118111459.32551-5-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
References: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0003.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::18) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P18901MB0783:EE_
X-MS-Office365-Filtering-Correlation-Id: 71a4fa79-f6d6-4214-57ce-08daf945457c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TpxZ9Z7T+LjryKURF7BQUZSWzIRLJ2x4g2kRtehKr+whKannJdwmUtmMmNvmscs/2eyMY52EEm2whHZv5Y/B5V5n3ge9ylgDpVmIKzbAChd6JczsaKlk3fagC+9dkSYcG7plei9KFL51ueFoJm4kzyiTC2CPMNkXW7kW9RoKoxe6AznLi0UMlixZsYzTP1dOO/fdsG8qDjGRtSi/tVFgj+nLBQOntgQIovTFA5idsKweSwAL6FHT5O6nns5e2JqVbY1WLYjTR+iYJxVPLW9N7TTu1blfAxSqv9C58DF8iSwiyY587AlATIg+9RQEiX93jgbuQZn9ZD7wb2EuQJ/mWFvYVkmgzR2H8u0nzhKw7AjH/UEbpevvS7QLXpyn7hrHoXGC9atoZ6znFp60R4FFbPI2LBu/2yB064TSNDPz1gKOh4Avjzs7PBmt3X90rTah5fj890Wss6KQJnxGatvuyX4c+4fuu1sKCzMKvQ+KtUuuvWdlUQciWBdMzVe/H3UD8HALACoNcAhJW9DAq6AdT/p1YJsAnRBpUeqUqjZ6+3D6mfXYyvRiQMhnxt7vVVa8U4LTsmB33zBdpl194y+RLJfXWrTIc8n4/7GiAPtKL/uCqmhKE00JBEO/fyJXGMTYZUg9GP8O8HW9yx7eX9JCX03bZwVhtQ2afq0mux8hUKmsJJBs5q34h5nwCSqZl2Ng6tyFKuJLI6EbNGmGKEqkVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(136003)(346002)(376002)(451199015)(2906002)(38100700002)(86362001)(66476007)(36756003)(316002)(2616005)(1076003)(6916009)(54906003)(4326008)(44832011)(6506007)(8676002)(70586007)(66946007)(41300700001)(66556008)(83380400001)(5660300002)(6512007)(30864003)(6486002)(26005)(478600001)(6666004)(8936002)(186003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?79TD665Rs0a6k+FgL/KkzNmUGLAuU1JY61svESywC0XfYoteWU0oONzsbtx6?=
 =?us-ascii?Q?280jX0rfquy8gXMZhqbanmskXLSAVN2PAXfWpnCerrPl57+I4JXqYO3GuD/D?=
 =?us-ascii?Q?TQ6i+PGCoAPantewptPLQaESbCyN8XE/FgNYwbAjz+rv1WNRYtSBDRZ6SJlD?=
 =?us-ascii?Q?LCQkvDso7Nje8Vbo0phYVe3g1fuBWlgOJEKDh0PtSR6IyPWjm6ipQkA0nmiu?=
 =?us-ascii?Q?x+JnH8LEC9LpzmmoYD1OsxrMumKSuKKMtTPZ16r1a5SuI4i7EczSKDShxWs0?=
 =?us-ascii?Q?WGLHVKs654vGyS4bptRAEyu8BQrFAjI85Tn+AZaISe25i135DNzIAOdklfcJ?=
 =?us-ascii?Q?iG3VVLKinc3z2zBV9d2N2443+7x9tQbzkbSeGMHFa1m5WWukHQ4VArkQV0uQ?=
 =?us-ascii?Q?mPMMJVPgn4lFonF/NuAYSCM4SIPVILADBWrzMSRo/XjeoVBWhpIy5vAAs0Tx?=
 =?us-ascii?Q?vNyezHQ7Qo1nO+X0wTvNsQHDEZetrkhZCa4jEz1SJjHtAvga1RerESVPO9iO?=
 =?us-ascii?Q?g70/L31LTlO7Obs9Hws1uzKctpw0Y9AnTQVdHE0355KjJDIGRa70FV16gDdh?=
 =?us-ascii?Q?HtsrjRGuU9T9Oh7fNQbX1Qd6VPAFsj4IwT0MCMsijN2lg5QT6h4Kbwi/KnQh?=
 =?us-ascii?Q?ThMjY9hOE38at4tf5X6O3e094xQTb3LOzmKKSRtItANk/rWgDD0tLHSYrhlD?=
 =?us-ascii?Q?Xqv1J0c6uOMURyexCZpBxOxnClheznbk0YWIqH1cz3sUqoPmeiKtH8jrceQM?=
 =?us-ascii?Q?HlSdCOmBSzoIVZsrCeWLImp/ldyZclv9fs0YeaTCe4gPV398/2p7YXffQ6fm?=
 =?us-ascii?Q?ig6A0JK0JrSfbbR1YUo7XkrIFZJNv02jGIaJVXAh5upo4Srzvg680cyZ8hpo?=
 =?us-ascii?Q?QVAE1ajK7LkBzt+J0f3gA8ES03SkpvTnpcM+r78HfAohUJAtz4gA8A/c8PV2?=
 =?us-ascii?Q?Znrkuocvl9YJW82Cz1/k9x1/clcyzXr4L+C8q28Mt0RJwZ6ecwG+Qf4F+UoF?=
 =?us-ascii?Q?OYLE3PR2o66LxdrDfIRqMur6YCnUTA59rvog5LFbd4gywqk0zqR7gVj+hdlF?=
 =?us-ascii?Q?SPjywEdZpxDGhzPwOAvX99BisP6tuWHvppsNdtSO79Cg1TWeQy391RwZAWcO?=
 =?us-ascii?Q?+OtTVWwRoHIVB9nRItdmkLJHeCJ8Evs5Ui2HStBjy21Dy7cPiImwIXA5iwEL?=
 =?us-ascii?Q?AOk/uiQDr+knuEGU9b3nCliOmM+prfesoHyzw00sZzU0UBMQ/f+E/UOm/4F9?=
 =?us-ascii?Q?3fPKfkC7kTvagVEU924fDirr0RRUgx8c03HJ8enFGHNfpdRPLRzofGZsoxkn?=
 =?us-ascii?Q?WmtWHHuZVdxGFetneCR2Oa+8oxJgjk4ATQV1DwtKz0Tjf7XXs0gq+Li7G6KX?=
 =?us-ascii?Q?zAvtQwTQ+OBwEz4O1E0hhat4s/TZo7xaTH/wL5tvtn5x7qTxKstBjtxE9pil?=
 =?us-ascii?Q?D3OGTa8jQRry0zGzpDUhgBVWUQffcSDEpO2kKa4jVfkkHSlmZ2pTIgYKGd3b?=
 =?us-ascii?Q?jRP1X4WFyPP7Js6eSQMBW1/bzjsC8e7weVhNPCAdO2dTv6xb7H/a5Km7Klb9?=
 =?us-ascii?Q?RWZAtIlTHj2OC5A0zBPWFZFcn1Okd0IjpPzmcM7FSy0qBpFq7AI0Yp/HZyq0?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a4fa79-f6d6-4214-57ce-08daf945457c
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:15:14.1435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZteLnBZkhNpPhjz5Qdz7TCOPifSKLICj7ufVxvWk/ngHHziteL52xo3XJKA+MNhfGMReyAwdtASRFW1FoDaK0UxTe5mi4A+kjCqCSoOYZyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0783
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An SCTP endpoint can start an association through a path and tear it
down over another one. That means the initial path will not see the
shutdown sequence, and the conntrack entry will remain in ESTABLISHED
state for 5 days.

By merging the HEARTBEAT_ACKED and ESTABLISHED states into one
ESTABLISHED state, there remains no difference between a primary or
secondary path. The timeout for the merged ESTABLISHED state is set to
210 seconds (hb_interval * max_path_retrans + rto_max). So, even if a
path doesn't see the shutdown sequence, it will expire in a reasonable
amount of time.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 .../networking/nf_conntrack-sysctl.rst        | 10 +--
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  4 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |  4 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 82 ++++++++-----------
 net/netfilter/nf_conntrack_standalone.c       |  8 --
 5 files changed, 42 insertions(+), 66 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index 49db1d11d7c4..8b1045c3b59e 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -173,7 +173,9 @@ nf_conntrack_sctp_timeout_cookie_echoed - INTEGER (seconds)
 	default 3
 
 nf_conntrack_sctp_timeout_established - INTEGER (seconds)
-	default 432000 (5 days)
+	default 210
+
+	Default is set to (hb_interval * path_max_retrans + rto_max)
 
 nf_conntrack_sctp_timeout_shutdown_sent - INTEGER (seconds)
 	default 0.3
@@ -190,12 +192,6 @@ nf_conntrack_sctp_timeout_heartbeat_sent - INTEGER (seconds)
 	This timeout is used to setup conntrack entry on secondary paths.
 	Default is set to hb_interval.
 
-nf_conntrack_sctp_timeout_heartbeat_acked - INTEGER (seconds)
-	default 210
-
-	This timeout is used to setup conntrack entry on secondary paths.
-	Default is set to (hb_interval * path_max_retrans + rto_max)
-
 nf_conntrack_udp_timeout - INTEGER (seconds)
 	default 30
 
diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index b90680f01e38..150fc3c056ea 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -15,8 +15,8 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_RECD,
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
-	SCTP_CONNTRACK_HEARTBEAT_ACKED,
-	SCTP_CONNTRACK_DATA_SENT,         /* no longer used */
+	SCTP_CONNTRACK_HEARTBEAT_ACKED,	/* no longer used */
+	SCTP_CONNTRACK_DATA_SENT,	/* no longer used */
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 1f4c691fe926..282343d433a6 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -94,8 +94,8 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	CTA_TIMEOUT_SCTP_DATA_SENT,          /* no longer used */
+	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,	/* no longer used */
+	CTA_TIMEOUT_SCTP_DATA_SENT,		/* no longer used */
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 01cf3e06f042..b6f4fbc77d59 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -27,22 +27,16 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
-   closely.  They're more complex. --RR
-
-   And so for me for SCTP :D -Kiran */
-
 static const char *const sctp_conntrack_names[] = {
-	"NONE",
-	"CLOSED",
-	"COOKIE_WAIT",
-	"COOKIE_ECHOED",
-	"ESTABLISHED",
-	"SHUTDOWN_SENT",
-	"SHUTDOWN_RECD",
-	"SHUTDOWN_ACK_SENT",
-	"HEARTBEAT_SENT",
-	"HEARTBEAT_ACKED",
+	[SCTP_CONNTRACK_NONE]			= "NONE",
+	[SCTP_CONNTRACK_CLOSED]			= "CLOSED",
+	[SCTP_CONNTRACK_COOKIE_WAIT]		= "COOKIE_WAIT",
+	[SCTP_CONNTRACK_COOKIE_ECHOED]		= "COOKIE_ECHOED",
+	[SCTP_CONNTRACK_ESTABLISHED]		= "ESTABLISHED",
+	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= "SHUTDOWN_SENT",
+	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= "SHUTDOWN_RECD",
+	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= "SHUTDOWN_ACK_SENT",
+	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= "HEARTBEAT_SENT",
 };
 
 #define SECS  * HZ
@@ -54,12 +48,11 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
 	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
 	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
-	[SCTP_CONNTRACK_ESTABLISHED]		= 5 DAYS,
+	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
 	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 300 SECS / 1000,
 	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 300 SECS / 1000,
 	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
-	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
 };
 
 #define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
@@ -73,7 +66,6 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 #define	sSR SCTP_CONNTRACK_SHUTDOWN_RECD
 #define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
 #define	sHS SCTP_CONNTRACK_HEARTBEAT_SENT
-#define	sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
 #define	sIV SCTP_CONNTRACK_MAX
 
 /*
@@ -96,9 +88,6 @@ SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
 CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
 		    the SHUTDOWN chunk. Connection is closed.
 HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
-HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK in the direction opposite to
-		    that of the HEARTBEAT chunk. Secondary connection is
-		    established.
 */
 
 /* TODO
@@ -115,33 +104,33 @@ cookie echoed to closed.
 static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
-/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
-/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},
-/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
-/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS},
-/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA, sHA},
-/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* Can't have Stale cookie*/
-/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* 5.2.4 - Big TODO */
-/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* Can't come in orig dir */
-/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL, sHA},
-/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA},
-/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA}
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS */
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW},
+/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},
+/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
+/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL},
+/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA},
+/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},/* Can't have Stale cookie*/
+/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL},/* 5.2.4 - Big TODO */
+/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL},/* Can't come in orig dir */
+/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL},
+/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
+/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
 	},
 	{
 /*	REPLY	*/
-/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
-/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* INIT in sCL Big TODO */
-/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
-/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL},
-/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR},
-/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA},
-/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV, sHA},
-/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* Can't come in reply dir */
-/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV, sHA},
-/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV, sHA},
-/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA},
-/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA}
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS */
+/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV},/* INIT in sCL Big TODO */
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV},
+/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV},
+/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV},
+/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV},
+/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV},
+/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV},/* Can't come in reply dir */
+/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV},
+/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV},
+/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS},
+/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sES},
 	}
 };
 
@@ -523,8 +512,7 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
 
-	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
-	    dir == IP_CT_DIR_REPLY &&
+	if (dir == IP_CT_DIR_REPLY &&
 	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
 		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &ct->status);
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index bca839ab1ae8..460294bd4b60 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -601,7 +601,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -886,12 +885,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED] = {
-		.procname       = "nf_conntrack_sctp_timeout_heartbeat_acked",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
@@ -1035,7 +1028,6 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(SHUTDOWN_RECD, sn);
 	XASSIGN(SHUTDOWN_ACK_SENT, sn);
 	XASSIGN(HEARTBEAT_SENT, sn);
-	XASSIGN(HEARTBEAT_ACKED, sn);
 #undef XASSIGN
 #endif
 }
-- 
2.34.1

