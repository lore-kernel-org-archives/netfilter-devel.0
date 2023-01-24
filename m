Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498F0C25B50
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 01:48:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbjAXBsp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAXBso (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 20:48:44 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2127.outbound.protection.outlook.com [40.107.8.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AD5392B5
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 17:48:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jsDcpvnqTCCI7PyuHQLLtrqqicVv/2cagvS1qu2jIobqqwXShnJ6Yvg9+dUujLFL8lNsvwLin0jhxTLG64XxPd+bI9AFo8BacnMIEpwf313u5LbsLVr2Tn4Nnea/7x9fuSv5BzGRh7nZdb4wqXi4QVuL4DVIrlgd2JlnnJUyx5BxsZBqo0cAfGVniJu6hBZ5jXXTVQV4uYT0Yh9YR/6TNdWqSrAeQy9OMZmZpKJ7x68xebx1fPsBLyT9N4N92LB6zyKOASJuWvC0YptJ9CSQ7AXQ2vTHZOT072wuuzkhQbK0PI/xOQno990MJi9lMZhxjVjsjNArZWoXDS+V0aDe3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cKVOlX0pViIB7DqleFuc7roRqO3piaj8j5avCUTpUA=;
 b=CHHNCtyPr2pXmn2gZJ48f89VBwt3Ntyno86rYKjjheE9IbMbYqRsw5QC3D87RERDwdqRyp6QgRjonIdzbjdcK1LRcHtwP07OnpQNltBGBbzBHRwlMduLwODdm0XG5udHIuWHQd03sB4OQgEet8q5brTwSfXrINrAZKxAwtNmlytPBRsTHmn+xEhEOPhp0QNHVTHbIJ3VOivsJkDabSuY/ficV5fePMPf8bn81/PWewXChr3n/OtehMOPYoS9lJUERuMFYXLGDC2AeL8GGp0NxgqV7PafPwokBg0OCWN8JNlvXL3D+phJ0tGt0UAIyZFQSnozNz+gK1j0jPANfwFz3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cKVOlX0pViIB7DqleFuc7roRqO3piaj8j5avCUTpUA=;
 b=GWgv25HyKdvazlRyHmYicH7mi/Nprj6ArnYK0BDHMtUyOljSwejxW/XELAiY59xihmKfMRtsWnmw9TpdEg1SAxn8ApAegNTIxEQlS8u/3ayZN20btK5gLDDBeRWJqZRiyfhDe3P1QUSelc2R2yeB/OHxhfV76vQhoFz8O23A1Kw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB0821.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:122::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 01:48:30 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%9]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 01:48:30 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v4 4/4] netfilter: conntrack: unify established states for SCTP paths
Date:   Tue, 24 Jan 2023 02:47:21 +0100
Message-Id: <20230124014721.6058-5-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
References: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0110.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::17) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0821:EE_
X-MS-Office365-Filtering-Correlation-Id: adfd1044-6e2d-4446-5e78-08dafdad1830
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eomqM51BkG5eQeJkuFYabZrob/OQhJsMXVb/7ul4QpS5rAnVn2jrc9mCHi9CCA9XGERqvUd3J9rL12SG1xMZmGW/2DRb4dM27c9LyeucO9w8NPVMObJ0iKMxCdtt8uZiCZDrEa1tuaEqXu1d+368yjefGM/MkyyoAMtWixHRxxYhrtHiKjHCKB3xW2CqYW8498X9oVsPXwSHlXN8M83OLks2aLParUQR33E4WCvr8gcrXw/7n4HBYbKjATED3ammQiOB43BgqEepwKDghykuh6NmYVie+SWhLntVhT5BJkTwCPYPq0wLzYiKruWdXsE2I00EdZsPqVjqraKJAbgva7YLXWT67Ni5EfUd03jxvBOjsg6peVn2/BlcClrNfFXr1Idw9YEu+UPYraqfshPOZFfOD4oGNLKk8/Pf2GklyfeWmcXzkYbqWwF9eoPj+3fhssFvi/nQr4QZgEs2yBtKVHiaXK+y28Dcv2oIz92siKq4VJlz/C4Q9iSShrM1/mLGTwJVcVD0S4gyafCtzEUkWUJZGGWpjYmH+0eFDOTD62tBs9Nrgl2200Y0jdpI9Nooiq6Be+fcg2VTdKlPkPAKGszMZUmxJWSTPNIMSFeStrTgmfUEAiBH80PBQE1jQJwcGaPm/F8kiH/NVWhs81hMolIrpaylrMRUO7dzeO4FiYxV1BJlYEPPf/LDl0/GGA7goJThpOfRf2UOyCqRGdP0Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39830400003)(396003)(376002)(451199015)(6506007)(1076003)(38100700002)(86362001)(54906003)(478600001)(6486002)(316002)(36756003)(44832011)(83380400001)(66946007)(2616005)(26005)(186003)(6666004)(6512007)(2906002)(5660300002)(8676002)(30864003)(66556008)(6916009)(66476007)(41300700001)(4326008)(70586007)(8936002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gO2exQqWMMzYpWLQF+2fOWOnFMU3yHg5Ahem461Tzb0IaeXqbEGb0g7uf+FL?=
 =?us-ascii?Q?8QfvrM9yJNnFV2x5LajbhKtEpu7cwF8ZSH2iUqKEt4ZBcUl+mjxYUuI0HccQ?=
 =?us-ascii?Q?9fVzVsL8bZb5WdsZ1Er2AChiEI+2TlmaxaNcU0uPcqOGOE1v6hDAOnveFBqX?=
 =?us-ascii?Q?q53y8c4AOaBsnpDOUDDEKxC8WU2BGrGqXVCvzTbmR8yuOyC8pP0O8JCryzdi?=
 =?us-ascii?Q?8unb3CgC22MsMmBNGD9UZXjnHAb48pvy2XybNS0XaG0bjwST4Xhjn/bV6KGy?=
 =?us-ascii?Q?5Leh46aIZUBI/YQrdMu9vTgD+JRnHckbbNUyq/WMqy/jS1BYWP+Z2mX8V7vG?=
 =?us-ascii?Q?z5TlsnpFuZe5c5cDMezkkkaW/bTSAexVONxqLE469++DAa17O6Db46TctecU?=
 =?us-ascii?Q?n89vy4J9PSwNugKAu8XhhWbmxGcneic11h6VyslPvvcipkPJpuSF6yWRYqUI?=
 =?us-ascii?Q?6ljDV1/9EHoJjfol3IBy9IXQm0i7dkqQLv4AWmBh9VMptmzFQdsHmjW0Dbxy?=
 =?us-ascii?Q?FlQ5uLdFEspdJL8GQTBuq5KRVGxs9iqJDysRTLjj81iEmP4mrcqRaoJI//K3?=
 =?us-ascii?Q?vOnIxafSp4fqnRPkbO5L8jqgXAKVtQBB3TJ83Xzf+ConO/lQVVVTYGvliyrs?=
 =?us-ascii?Q?xPqKidrEeYpgl0m9yVPwneYJWDZ/crcnlNINf/naNFk/EIuXOAzPxE/Lhend?=
 =?us-ascii?Q?51Q9envxAI4Evrb3DtxE+xfeFVLoUW39D/CTP51hmf5ONomPl0ojBNn1Dbu9?=
 =?us-ascii?Q?pjTZNKox+pPB5lftXq17keQtrNJr8OmJ1tw21KtM4sc8BoJmAX2mi7gos8A9?=
 =?us-ascii?Q?UDbwu6POu292fkj+9wOKnf1j0EbAvMIXRlOFfjht77opblvIFRVlPN2IB6eK?=
 =?us-ascii?Q?QaRI5le0dPoYIaHXyfBAf+bfcP6kIHW6pdifHBLpPjwkcyYOZwo/VPc/e2Me?=
 =?us-ascii?Q?A2R4qSoTz5rbema30JQDD1kvIOVJDSEBhtFlTqa5jX/6Kb/gVitP6HvQU0CY?=
 =?us-ascii?Q?vebMC5pdt7c2J3tFPrJ+UXp+KK5BidaCCulXuhuP8jSh8eEVj78le1tG6srp?=
 =?us-ascii?Q?ZJWzlivF/wCUhE2n7723NtwhAyMAh+P6tIoarqmHATLSruqG2Kzz6t3moW3/?=
 =?us-ascii?Q?hUYur4AmxmkYUS5h4b0sh7ECREO4pAfnHiJ4CCoSSwQfIVtElRYQ0nzS3go1?=
 =?us-ascii?Q?ccNuW1d4aAgmzBqaTmPWxiAm7xoMnfOPVCPSFh2CxwaciOMnFCSmkGkWNFwd?=
 =?us-ascii?Q?Hy4JidRTcGSUzmk10NM282Cr53A2xwl3jm30UfRe2u1XYteEL8BWMPNwxMKY?=
 =?us-ascii?Q?Haf59+7rLp/P7OfLf+jgWz48YT9w2Gh2kcxZjXC0LoR4NnAn0GWg3YpWYYcP?=
 =?us-ascii?Q?hXmklrZ5lq7Xmre8EYqSytZMAr6GDnr/Hp8LxocpDI3SE6z4OSU8ayg5+sO9?=
 =?us-ascii?Q?LuR+F9NcEvhMc9LtSSUAFoIE8yNDfspKb+WPXFL3Dx6oFJ7BbCPBjOKMQYGC?=
 =?us-ascii?Q?NoNj6kHhfCwb3elusFLCP7Qr0TCgFcsu2YxfLaEV0Wv5TBZvX9hNli1358bH?=
 =?us-ascii?Q?nfpIwinyWGbg0/SkuqqKR0+qWojIl5RNKqKvSTZBacS/NO79xWiawerUV2YV?=
 =?us-ascii?Q?QA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: adfd1044-6e2d-4446-5e78-08dafdad1830
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:48:30.4432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNlYpV2MaNDBeNu49sqBVSgbpqgTf40DoTc4mxJwc7OPH7o3Nn17pdeuCb00PsNB/TcTH5Lg3MtldzYtrAc3RXF3AVECD8nLzGHalAdnibk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0821
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

With this change in place, there is now more than one state from which
we can transition to ESTABLISHED, COOKIE_ECHOED and HEARTBEAT_SENT, so
handle the setting of ASSURED bit whenever a state change has happened
and the new state is ESTABLISHED. Removed the check for dir==REPLY since
the transition to ESTABLISHED can happen only in the reply direction.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 .../networking/nf_conntrack-sysctl.rst        | 10 +-
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  2 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 93 ++++++++-----------
 net/netfilter/nf_conntrack_standalone.c       |  8 --
 5 files changed, 44 insertions(+), 71 deletions(-)

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
index edc6ddab0de6..2d6f80d75ae7 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -15,7 +15,7 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_RECD,
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
-	SCTP_CONNTRACK_HEARTBEAT_ACKED,
+	SCTP_CONNTRACK_HEARTBEAT_ACKED,	/* no longer used */
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 6b20fb22717b..aa805e6d4e28 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -94,7 +94,7 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
+	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED, /* no longer used */
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 01cf3e06f042..945dd40e7077 100644
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
 
@@ -508,8 +497,12 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 		}
 
 		ct->proto.sctp.state = new_state;
-		if (old_state != new_state)
+		if (old_state != new_state) {
 			nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+			if (new_state == SCTP_CONNTRACK_ESTABLISHED &&
+			    !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+				nf_conntrack_event_cache(IPCT_ASSURED, ct);
+		}
 	}
 	spin_unlock_bh(&ct->lock);
 
@@ -523,14 +516,6 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
 
-	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
-	    dir == IP_CT_DIR_REPLY &&
-	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
-		pr_debug("Setting assured bit\n");
-		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_ASSURED, ct);
-	}
-
 	return NF_ACCEPT;
 
 out_unlock:
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

