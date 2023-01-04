Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C644C46467
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Jan 2023 11:38:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjADLit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Jan 2023 06:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjADLir (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Jan 2023 06:38:47 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2091.outbound.protection.outlook.com [40.107.105.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED439FFF
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Jan 2023 03:38:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UHOwZdshgJ0IqXjxRzWscmijrwfbfQaaIetKMCHmQfIomnRK7lypaPVPkWtzpvATofdK1Q4Swx4yaF5Fux54zK+qBE+WE+64OzoD1eihTNd1FifLwMLv4PWn5kz2FTl3iv3DVyEqgmZASF1HLf3zgjZ1hcXCGLswZBSJDm81JZsNM5GSlyH+U6QaoE+o5aBcQp2k2H39UC9dE9esd9U98BbYRWqzhRwkAYNOkrWYG/7w0XJ1XXxQailPGBf4SjtqXFM5Jp/bm7FPCfSUiAv4ARVCd88wx+qD2U5cxKwR0rvW2yv9m0bbcMD+LL2IedXkPwkcgWg9gQjGAQCZTvRvyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jue4V0DPVR+NsCHLR0XNLuDIq5hvz+8JoTWxkqq39M=;
 b=ATm6xpuwa2h9mVOVeJd+nHkH3uCey/276tagrqIV+UMWmGZy35mVxFKpvq/LLjhW1xx/oo+U43rC2YIJJ7mPD4+XQpHeLXexAk2M3Yf+oq6Enb01bOE8DDEa1kcvjyoDn0lswCKavoCw/Otp0VdRtmr75cBqt0iP7PF0d1V6JrxX2YU0VbjTNRSlpec+H2A6mhwVBgVpcPLETSXc3pxWG+f4qZybu8XjBN22zbefbmuc24mI3gpg1+yxWjJZ67BhmwnPgUeMknBQZI0d+oY0FXwJDwz3VspZyotVvKqJyvUrO7+9afGSxOUJfoRGpxEwC5AIItbQt6VJAxamrnMtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jue4V0DPVR+NsCHLR0XNLuDIq5hvz+8JoTWxkqq39M=;
 b=WIJ7GVolzrclf3dVpRReeO9vbMQ/wQdcUw/bNCHvMt+kSB5VZHCbzXQS2fRiGkxxbwS2OHfy1Wcrq6z6Kwx+eD2gcnDOl48vg1LBnM6ypiYySKoKnDb1GMKyKXHBB8PogN9nO3ei31npe/VKs+qcOiK8eU3LW4VZJ2t5Pzeagx0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM0P189MB0612.EURP189.PROD.OUTLOOK.COM (2603:10a6:208:1a0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.9; Wed, 4 Jan
 2023 11:38:41 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%3]) with mapi id 15.20.5986.009; Wed, 4 Jan 2023
 11:38:41 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [RFC PATCH] netfilter: conntrack: simplify sctp state machine
Date:   Wed,  4 Jan 2023 12:31:43 +0100
Message-Id: <20230104113143.21769-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3PEPF000000CB.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:144:1:0:2:0:7) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM0P189MB0612:EE_
X-MS-Office365-Filtering-Correlation-Id: 59be75d7-7bd9-4594-ea38-08daee483a33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsqR4m5hpaI482eY4zl56UURlshgz4+bGwV5TdBrNq9gKrWxarOy7CoA5UEp0Zgl46CuyroKVU3kZbnNOJR4sZhX/PzymQlgKKdaAah6mfGvTGhiQCSKlU3iI8+3m+s2bp/CzZGLyVyZ0vEKg654EIFq8KNv1KeemJN8gl0UmH6qovnbQdQCxa3dBFx+HZ9XtLoMghgLAIc91/WKldbiTxvvBPCbyDaaYy1CrkyNxSu+aTSNRfAuyH450zRgu9UnZtfPXLCQe00uagbFyrx4fP7V2rlKxGrDoADALzaZkureZ+k5f7B8zw6qbXTvR34LIfR1dni/uJKZ8X29ECId5XLmw5yrwV80BjTfmQ3camUBHC3bS2KLWYAtbcZlnxrU0p86n1ZppbOAwF1bO10u1o2pN4RgoCNVdCAYQdO/f6dmFFt/It9+UdP2F21sc9KkIfC8kyUY9DUQ4FzvYjSAX4e+1vD3478B5JC14wxag40ML3Jpnpg/RVnxM6vOk6mIAvPWr/SAQmF8T8WbzngxDvHMRryLQTIBNiaixL1Q78oAe5ESji5JU2526EJ8RuWcnXhl2vRw/3EJvMNT8BtyY0Kj3AURI3UilzzyoTH0CkGzLlOAHwSJXRQlhZYGKkMay7hrhvYn+OlhmncRBSckmDSed00EHrfNLl5Ue/o9up6nu5RS76bburmEeZ7WXgXI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(39840400004)(396003)(376002)(136003)(451199015)(83380400001)(6512007)(66556008)(478600001)(2906002)(186003)(86362001)(2616005)(26005)(6486002)(41300700001)(66476007)(70586007)(4326008)(8676002)(30864003)(5660300002)(44832011)(1076003)(36756003)(316002)(66946007)(54906003)(8936002)(6916009)(6506007)(38100700002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LwjB3gZ2DH+DqNk5Qzhe3FVyKrcN5NuJWXaHZJ+4ZZUiibiA1ts4UTSSzxZU?=
 =?us-ascii?Q?pgbJTOYouboOZb22jZfNqVPaDS8LPC4VN3+bFX8xMl5wERUDg+tSitwNXeHN?=
 =?us-ascii?Q?QPX2WTMrxH6B+wfx5iuM/HqwyEBDKNtz5jfbwdUIivlpD8VUAz5c5X8q8A1S?=
 =?us-ascii?Q?+mhzoUlMufUsOnXpF/W12BZiSqzcbZbsJcBgTH8sdbHkpYnBGuML/NnH3slz?=
 =?us-ascii?Q?j/lXDbuBibHVGISxJ7SUUj9eC3i9PLJ+oQDyLzTdnBeqrrk3o/MF4NYli5pT?=
 =?us-ascii?Q?T/ixjd8RN3P/3MKzs8G2gsdFxBiVHo21gggdC4yqFaTQJnzi6lRXSkAfroQ8?=
 =?us-ascii?Q?K/rnkcCnd3RYyrDfmNqKChUYYYiHHza3UaCDTuNZgQqMODiJNOGH5li83fit?=
 =?us-ascii?Q?wu1T7RgNuTSLHXXWkchMMCin86VgRI7GOEEwrXFVKivIyoypz3CEojNcmjIY?=
 =?us-ascii?Q?7zbA7NJu58SjpaMXArwnmA189PJBijKGSrIA9umBgYdxV3G6W/HPREexGGvL?=
 =?us-ascii?Q?D18QRbiiZ8nt0v22KxphOff97jlpiN0nfnpiicjge0phqTRF2NzAF3MMHhba?=
 =?us-ascii?Q?74P4DUqiCjecprLPiIKlUkBq8qTxqoZnk0FCsGdAL8IB152qZZqr8c+8zOV+?=
 =?us-ascii?Q?nbFfzfi0+1DpyFJA6l8+d7hpeOLGsRryWzPXdwrVBjkGrI96TGoG8hNrhgQw?=
 =?us-ascii?Q?aprCF9zdhobvjOKYPORpLiMdAfIJGqmL40I/v3RJY4naRKw36IrQVdTbrLTe?=
 =?us-ascii?Q?mlELBnbqEjXvlsnLER981+v+1nXv+VXHWtYD+s7TuGnHttI/Rf5ldSbdVQyK?=
 =?us-ascii?Q?7V3I7rDmbrqdgoxos8UZDLLXw8q7qsNX7y+K8sgCFyrcUfTz5w/iPN5zjZ4z?=
 =?us-ascii?Q?MXWHBeYDq3jK8vARTMVACTZEV8QtcDkGTZusqzyex1sSwEcD/hWWh360n+uI?=
 =?us-ascii?Q?gqOCoexmRrBUnkOkZpaPRkO2ZvJila6Effj9Se2U1V/4/xvbTw20TmGBkP+q?=
 =?us-ascii?Q?YPxSOTvRZYCBbICvA5SvDQACrtUyiBR6SCtMQfF4+c4fFT3gu8d6MMEcw4Iy?=
 =?us-ascii?Q?hdbFdB8lFwwu6ztPr9WGRXjJ/MUidx8wjtgcLFu4JTOMhHff2sG9Yxiuuhx0?=
 =?us-ascii?Q?5nmtUEoDPz/xgTpfc0YUYTt0kwVKMR9i15H1It1b0ATcLFWpyDZFJrcrY3f8?=
 =?us-ascii?Q?urizFCJSVsn8zWt3YgWqBtuADnCDvSxFvQA0JwkbXeLy31+fvhEd5JrRmdH8?=
 =?us-ascii?Q?gTPSFgm12jSFJT3K0A9qAwR0UKr+awRN1FyAvpvRIpvsyM/LFRAJxdhKVerB?=
 =?us-ascii?Q?P1i/N/uKWjph5/2FbrgkKD9B8EhbixKolxv5ES3RFv0K4hhxDCByvHKMaIla?=
 =?us-ascii?Q?xktuN0jwSUGocTOaVu0AcAc7/J4rzZT6IdsV+dbwPpIzZMdO/avFatQoaG2b?=
 =?us-ascii?Q?S11lssUUgmxE8h2ZjnisstDFMIu11pUk2b3ntkvv4+v2L17kdGDxZuV983Kt?=
 =?us-ascii?Q?4Ah5Iuy2Nzxr2Zt3IilN3Y1VjY0hYvhJiRPiY2SDeGsfeAhq+SEq+T0QYf7I?=
 =?us-ascii?Q?OKr1hJ6+LIsqw0SjktqWgmV/rZNdB10nEJrgQ0TZ++hTlPlHdkC0R9tNs6B3?=
 =?us-ascii?Q?SA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 59be75d7-7bd9-4594-ea38-08daee483a33
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2023 11:38:40.9288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50ZmYqPDMOWZwiQ8146/YagaRybVqLD3olJPiZExML9VcWg29z5ih1Kp8VQYQvc57r8YQ3dyfdM4Xl9bb5xoBOUPr+zIRZy8DN4nmGfbDaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P189MB0612
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

All the paths in an SCTP connection are kept alive either by actual
DATA/SACK running through the connection or by HEARTBEAT. This patch
proposes a simple state machine with only two states OPEN_WAIT and
ESTABLISHED (similar to UDP). The reason for this change is a full
stateful approach to SCTP is difficult when the association is
multihomed since the endpoints could use different paths in the network
during the lifetime of an association.

Default timeouts are:
OPEN_WAIT:   3 seconds   (rto_initial)
ESTABLISHED: 210 seconds (rto_max + hb_interval * path_max_retrans)

Important changes/notes
- Timeout is used to clean up conntrack entries
- VTAG checks are kept as is (can be moved to a conntrack extension if
  desired)
- SCTP chunks are parsed only once, and a map is populated with the
  information on the chunks present in the packet
- ASSURED bit is NOT set in this version of the patch, need help
  understanding when to set it

Note that this patch has changed uapi headers.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  10 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |  10 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 589 ++++--------------
 net/netfilter/nf_conntrack_standalone.c       |  72 +--
 4 files changed, 143 insertions(+), 538 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index c742469afe21..89381a57021a 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -7,16 +7,8 @@
 
 enum sctp_conntrack {
 	SCTP_CONNTRACK_NONE,
-	SCTP_CONNTRACK_CLOSED,
-	SCTP_CONNTRACK_COOKIE_WAIT,
-	SCTP_CONNTRACK_COOKIE_ECHOED,
+	SCTP_CONNTRACK_OPEN_WAIT,
 	SCTP_CONNTRACK_ESTABLISHED,
-	SCTP_CONNTRACK_SHUTDOWN_SENT,
-	SCTP_CONNTRACK_SHUTDOWN_RECD,
-	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
-	SCTP_CONNTRACK_HEARTBEAT_SENT,
-	SCTP_CONNTRACK_HEARTBEAT_ACKED,
-	SCTP_CONNTRACK_DATA_SENT,
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 94e74034706d..372dfe7c07ed 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -86,16 +86,8 @@ enum ctattr_timeout_dccp {
 
 enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_UNSPEC,
-	CTA_TIMEOUT_SCTP_CLOSED,
-	CTA_TIMEOUT_SCTP_COOKIE_WAIT,
-	CTA_TIMEOUT_SCTP_COOKIE_ECHOED,
+	CTA_TIMEOUT_SCTP_OPEN_WAIT,
 	CTA_TIMEOUT_SCTP_ESTABLISHED,
-	CTA_TIMEOUT_SCTP_SHUTDOWN_SENT,
-	CTA_TIMEOUT_SCTP_SHUTDOWN_RECD,
-	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
-	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	CTA_TIMEOUT_SCTP_DATA_SENT,
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d88b92a8ffca..d79ed476b764 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -5,12 +5,13 @@
  * Copyright (c) 2004 Kiran Kumar Immidi <immidi_kiran@yahoo.com>
  * Copyright (c) 2004-2012 Patrick McHardy <kaber@trash.net>
  *
- * SCTP is defined in RFC 2960. References to various sections in this code
+ * SCTP is defined in RFC 4960. References to various sections in this code
  * are to this RFC.
  */
 
 #include <linux/types.h>
 #include <linux/timer.h>
+#include <linux/jiffies.h>
 #include <linux/netfilter.h>
 #include <linux/in.h>
 #include <linux/ip.h>
@@ -27,127 +28,19 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 
-/* FIXME: Examine ipfilter's timeouts and conntrack transitions more
-   closely.  They're more complex. --RR
-
-   And so for me for SCTP :D -Kiran */
+#define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
 
 static const char *const sctp_conntrack_names[] = {
 	"NONE",
-	"CLOSED",
-	"COOKIE_WAIT",
-	"COOKIE_ECHOED",
+	"OPEN_WAIT",
 	"ESTABLISHED",
-	"SHUTDOWN_SENT",
-	"SHUTDOWN_RECD",
-	"SHUTDOWN_ACK_SENT",
-	"HEARTBEAT_SENT",
-	"HEARTBEAT_ACKED",
 };
 
 #define SECS  * HZ
-#define MINS  * 60 SECS
-#define HOURS * 60 MINS
-#define DAYS  * 24 HOURS
 
 static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
-	[SCTP_CONNTRACK_CLOSED]			= 10 SECS,
-	[SCTP_CONNTRACK_COOKIE_WAIT]		= 3 SECS,
-	[SCTP_CONNTRACK_COOKIE_ECHOED]		= 3 SECS,
-	[SCTP_CONNTRACK_ESTABLISHED]		= 5 DAYS,
-	[SCTP_CONNTRACK_SHUTDOWN_SENT]		= 300 SECS / 1000,
-	[SCTP_CONNTRACK_SHUTDOWN_RECD]		= 300 SECS / 1000,
-	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
-	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
-	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
-	[SCTP_CONNTRACK_DATA_SENT]		= 30 SECS,
-};
-
-#define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
-
-#define sNO SCTP_CONNTRACK_NONE
-#define	sCL SCTP_CONNTRACK_CLOSED
-#define	sCW SCTP_CONNTRACK_COOKIE_WAIT
-#define	sCE SCTP_CONNTRACK_COOKIE_ECHOED
-#define	sES SCTP_CONNTRACK_ESTABLISHED
-#define	sSS SCTP_CONNTRACK_SHUTDOWN_SENT
-#define	sSR SCTP_CONNTRACK_SHUTDOWN_RECD
-#define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
-#define	sHS SCTP_CONNTRACK_HEARTBEAT_SENT
-#define	sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
-#define	sDS SCTP_CONNTRACK_DATA_SENT
-#define	sIV SCTP_CONNTRACK_MAX
-
-/*
-	These are the descriptions of the states:
-
-NOTE: These state names are tantalizingly similar to the states of an
-SCTP endpoint. But the interpretation of the states is a little different,
-considering that these are the states of the connection and not of an end
-point. Please note the subtleties. -Kiran
-
-NONE              - Nothing so far.
-COOKIE WAIT       - We have seen an INIT chunk in the original direction, or also
-		    an INIT_ACK chunk in the reply direction.
-COOKIE ECHOED     - We have seen a COOKIE_ECHO chunk in the original direction.
-ESTABLISHED       - We have seen a COOKIE_ACK in the reply direction.
-SHUTDOWN_SENT     - We have seen a SHUTDOWN chunk in the original direction.
-SHUTDOWN_RECD     - We have seen a SHUTDOWN chunk in the reply direction.
-SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
-		    to that of the SHUTDOWN chunk.
-CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
-		    the SHUTDOWN chunk. Connection is closed.
-HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
-HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK/DATA/SACK in the direction
-		    opposite to that of the HEARTBEAT/DATA chunk. Secondary connection
-		    is established.
-DATA_SENT         - We have seen a DATA/SACK in a new flow.
-*/
-
-/* TODO
- - I have assumed that the first INIT is in the original direction.
- This messes things when an INIT comes in the reply direction in CLOSED
- state.
- - Check the error type in the reply dir before transitioning from
-cookie echoed to closed.
- - Sec 5.2.4 of RFC 2960
- - Full Multi Homing support.
-*/
-
-/* SCTP conntrack state transitions */
-static const u8 sctp_conntracks[2][12][SCTP_CONNTRACK_MAX] = {
-	{
-/*	ORIGINAL	*/
-/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS */
-/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA, sCW},
-/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},
-/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
-/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS, sCL},
-/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA, sHA, sSA},
-/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* Can't have Stale cookie*/
-/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* 5.2.4 - Big TODO */
-/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* Can't come in orig dir */
-/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL, sHA, sCL},
-/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS},
-/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS},
-/* data/sack    */ {sDS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS}
-	},
-	{
-/*	REPLY	*/
-/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS */
-/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},/* INIT in sCL Big TODO */
-/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},
-/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL, sIV},
-/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR, sIV},
-/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA, sIV},
-/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV, sHA, sIV},
-/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},/* Can't come in reply dir */
-/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV, sHA, sIV},
-/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV, sHA, sIV},
-/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sHA},
-/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA, sHA},
-/* data/sack    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA, sHA},
-	}
+	[SCTP_CONNTRACK_OPEN_WAIT]			= 3 SECS,
+	[SCTP_CONNTRACK_ESTABLISHED]		= 210 SECS,
 };
 
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
@@ -158,184 +51,6 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 }
 #endif
 
-#define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
-for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	(offset) < (skb)->len &&					\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
-	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
-
-/* Some validity checks to make sure the chunks are fine */
-static int do_basic_checks(struct nf_conn *ct,
-			   const struct sk_buff *skb,
-			   unsigned int dataoff,
-			   unsigned long *map)
-{
-	u_int32_t offset, count;
-	struct sctp_chunkhdr _sch, *sch;
-	int flag;
-
-	flag = 0;
-
-	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
-
-		if (sch->type == SCTP_CID_INIT ||
-		    sch->type == SCTP_CID_INIT_ACK ||
-		    sch->type == SCTP_CID_SHUTDOWN_COMPLETE)
-			flag = 1;
-
-		/*
-		 * Cookie Ack/Echo chunks not the first OR
-		 * Init / Init Ack / Shutdown compl chunks not the only chunks
-		 * OR zero-length.
-		 */
-		if (((sch->type == SCTP_CID_COOKIE_ACK ||
-		      sch->type == SCTP_CID_COOKIE_ECHO ||
-		      flag) &&
-		     count != 0) || !sch->length) {
-			pr_debug("Basic checks failed\n");
-			return 1;
-		}
-
-		if (map)
-			set_bit(sch->type, map);
-	}
-
-	pr_debug("Basic checks passed\n");
-	return count == 0;
-}
-
-static int sctp_new_state(enum ip_conntrack_dir dir,
-			  enum sctp_conntrack cur_state,
-			  int chunk_type)
-{
-	int i;
-
-	pr_debug("Chunk type: %d\n", chunk_type);
-
-	switch (chunk_type) {
-	case SCTP_CID_INIT:
-		pr_debug("SCTP_CID_INIT\n");
-		i = 0;
-		break;
-	case SCTP_CID_INIT_ACK:
-		pr_debug("SCTP_CID_INIT_ACK\n");
-		i = 1;
-		break;
-	case SCTP_CID_ABORT:
-		pr_debug("SCTP_CID_ABORT\n");
-		i = 2;
-		break;
-	case SCTP_CID_SHUTDOWN:
-		pr_debug("SCTP_CID_SHUTDOWN\n");
-		i = 3;
-		break;
-	case SCTP_CID_SHUTDOWN_ACK:
-		pr_debug("SCTP_CID_SHUTDOWN_ACK\n");
-		i = 4;
-		break;
-	case SCTP_CID_ERROR:
-		pr_debug("SCTP_CID_ERROR\n");
-		i = 5;
-		break;
-	case SCTP_CID_COOKIE_ECHO:
-		pr_debug("SCTP_CID_COOKIE_ECHO\n");
-		i = 6;
-		break;
-	case SCTP_CID_COOKIE_ACK:
-		pr_debug("SCTP_CID_COOKIE_ACK\n");
-		i = 7;
-		break;
-	case SCTP_CID_SHUTDOWN_COMPLETE:
-		pr_debug("SCTP_CID_SHUTDOWN_COMPLETE\n");
-		i = 8;
-		break;
-	case SCTP_CID_HEARTBEAT:
-		pr_debug("SCTP_CID_HEARTBEAT");
-		i = 9;
-		break;
-	case SCTP_CID_HEARTBEAT_ACK:
-		pr_debug("SCTP_CID_HEARTBEAT_ACK");
-		i = 10;
-		break;
-	case SCTP_CID_DATA:
-	case SCTP_CID_SACK:
-		pr_debug("SCTP_CID_DATA/SACK");
-		i = 11;
-		break;
-	default:
-		/* Other chunks like DATA or SACK do not change the state */
-		pr_debug("Unknown chunk type, Will stay in %s\n",
-			 sctp_conntrack_names[cur_state]);
-		return cur_state;
-	}
-
-	pr_debug("dir: %d   cur_state: %s  chunk_type: %d  new_state: %s\n",
-		 dir, sctp_conntrack_names[cur_state], chunk_type,
-		 sctp_conntrack_names[sctp_conntracks[dir][i][cur_state]]);
-
-	return sctp_conntracks[dir][i][cur_state];
-}
-
-/* Don't need lock here: this conntrack not in circulation yet */
-static noinline bool
-sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
-	 const struct sctphdr *sh, unsigned int dataoff)
-{
-	enum sctp_conntrack new_state;
-	const struct sctp_chunkhdr *sch;
-	struct sctp_chunkhdr _sch;
-	u32 offset, count;
-
-	memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
-	new_state = SCTP_CONNTRACK_MAX;
-	for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count) {
-		new_state = sctp_new_state(IP_CT_DIR_ORIGINAL,
-					   SCTP_CONNTRACK_NONE, sch->type);
-
-		/* Invalid: delete conntrack */
-		if (new_state == SCTP_CONNTRACK_NONE ||
-		    new_state == SCTP_CONNTRACK_MAX) {
-			pr_debug("nf_conntrack_sctp: invalid new deleting.\n");
-			return false;
-		}
-
-		/* Copy the vtag into the state info */
-		if (sch->type == SCTP_CID_INIT) {
-			struct sctp_inithdr _inithdr, *ih;
-			/* Sec 8.5.1 (A) */
-			if (sh->vtag)
-				return false;
-
-			ih = skb_header_pointer(skb, offset + sizeof(_sch),
-						sizeof(_inithdr), &_inithdr);
-			if (!ih)
-				return false;
-
-			pr_debug("Setting vtag %x for new conn\n",
-				 ih->init_tag);
-
-			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag;
-		} else if (sch->type == SCTP_CID_HEARTBEAT ||
-			   sch->type == SCTP_CID_DATA ||
-			   sch->type == SCTP_CID_SACK) {
-			pr_debug("Setting vtag %x for secondary conntrack\n",
-				 sh->vtag);
-			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
-		} else {
-		/* If it is a shutdown ack OOTB packet, we expect a return
-		   shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
-			pr_debug("Setting vtag %x for new conn OOTB\n",
-				 sh->vtag);
-			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = sh->vtag;
-		}
-
-		ct->proto.sctp.state = SCTP_CONNTRACK_NONE;
-	}
-
-	return true;
-}
-
 static bool sctp_error(struct sk_buff *skb,
 		       unsigned int dataoff,
 		       const struct nf_hook_state *state)
@@ -367,6 +82,12 @@ static bool sctp_error(struct sk_buff *skb,
 	return true;
 }
 
+#define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
+for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
+	(offset) < (skb)->len &&					\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
+	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
+
 /* Returns verdict for packet, or -NF_ACCEPT for invalid. */
 int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			     struct sk_buff *skb,
@@ -374,195 +95,168 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			     enum ip_conntrack_info ctinfo,
 			     const struct nf_hook_state *state)
 {
-	enum sctp_conntrack new_state, old_state;
 	enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
-	const struct sctphdr *sh;
-	struct sctphdr _sctph;
-	const struct sctp_chunkhdr *sch;
-	struct sctp_chunkhdr _sch;
-	u_int32_t offset, count;
-	unsigned int *timeouts;
 	unsigned long map[256 / sizeof(unsigned long)] = { 0 };
-	bool ignore = false;
+	unsigned int *timeouts;
+	u_int32_t init_vtag = 0;
+	u_int32_t offset, count;
+	struct sctphdr _sctph, *sctph;
+	struct sctp_chunkhdr _sch, *sch;
 
 	if (sctp_error(skb, dataoff, state))
-		return -NF_ACCEPT;
+		goto out_drop;
+
+	sctph = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
+	if (sctph == NULL)
+		goto out_drop;
 
-	sh = skb_header_pointer(skb, dataoff, sizeof(_sctph), &_sctph);
-	if (sh == NULL)
-		goto out;
+	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
+		pr_debug("Chunk Num: %d  Type: %d\n", count, sch->type);
+		set_bit(sch->type, map);
 
-	if (do_basic_checks(ct, skb, dataoff, map) != 0)
-		goto out;
+		if (sch->type == SCTP_CID_INIT ||
+			sch->type == SCTP_CID_INIT_ACK) {
+			struct sctp_inithdr _inith, *inith;
+			inith = skb_header_pointer(skb, offset + sizeof(_sch),
+						sizeof(_inith), &_inith);
+			if (inith)
+				init_vtag = inith->init_tag;
+			else
+				goto out_drop;
+		}
+	}
 
+	spin_lock_bh(&ct->lock);
 	if (!nf_ct_is_confirmed(ct)) {
 		/* If an OOTB packet has any of these chunks discard (Sec 8.4) */
 		if (test_bit(SCTP_CID_ABORT, map) ||
 		    test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) ||
 		    test_bit(SCTP_CID_COOKIE_ACK, map))
-			return -NF_ACCEPT;
+			goto out_unlock;
 
-		if (!sctp_new(ct, skb, sh, dataoff))
-			return -NF_ACCEPT;
+		memset(&ct->proto.sctp, 0, sizeof(ct->proto.sctp));
+		ct->proto.sctp.state = SCTP_CONNTRACK_OPEN_WAIT;
+		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
+
+		if (test_bit(SCTP_CID_INIT, map))
+			ct->proto.sctp.vtag[!dir] = init_vtag;
+		else if (test_bit(SCTP_CID_SHUTDOWN_ACK, map))
+			/* If it is a shutdown ack OOTB packet, we expect a return
+			shutdown complete, otherwise an ABORT Sec 8.4 (5) and (8) */
+			ct->proto.sctp.vtag[!dir] = sctph->vtag;
+		else
+			ct->proto.sctp.vtag[dir] = sctph->vtag;
 	} else {
-		/* Check the verification tag (Sec 8.5) */
-		if (!test_bit(SCTP_CID_INIT, map) &&
-		    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
-		    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
-		    !test_bit(SCTP_CID_ABORT, map) &&
-		    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
-		    !test_bit(SCTP_CID_HEARTBEAT, map) &&
-		    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
-		    sh->vtag != ct->proto.sctp.vtag[dir]) {
-			pr_debug("Verification tag check failed\n");
-			goto out;
+		if (!ct->proto.sctp.vtag[!dir] &&
+			test_bit(SCTP_CID_INIT_ACK, map)) {
+			ct->proto.sctp.vtag[!dir] = init_vtag;
+		}
+		if (!ct->proto.sctp.vtag[dir]) {
+			ct->proto.sctp.vtag[dir] = sctph->vtag;
 		}
-	}
 
-	old_state = new_state = SCTP_CONNTRACK_NONE;
-	spin_lock_bh(&ct->lock);
-	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
-		/* Special cases of Verification tag check (Sec 8.5.1) */
-		if (sch->type == SCTP_CID_INIT) {
-			/* Sec 8.5.1 (A) */
-			if (sh->vtag != 0)
-				goto out_unlock;
-		} else if (sch->type == SCTP_CID_ABORT) {
-			/* Sec 8.5.1 (B) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir])
-				goto out_unlock;
-		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
-			/* Sec 8.5.1 (C) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
-			    sch->flags & SCTP_CHUNK_FLAG_T)
-				goto out_unlock;
-		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
-			/* Sec 8.5.1 (D) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir])
-				goto out_unlock;
-		} else if (sch->type == SCTP_CID_HEARTBEAT) {
-			if (ct->proto.sctp.vtag[dir] == 0) {
-				pr_debug("Setting %d vtag %x for dir %d\n", sch->type, sh->vtag, dir);
-				ct->proto.sctp.vtag[dir] = sh->vtag;
-			} else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
-				if (test_bit(SCTP_CID_DATA, map) || ignore)
-					goto out_unlock;
-
-				ct->proto.sctp.flags |= SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
-				ct->proto.sctp.last_dir = dir;
-				ignore = true;
-				continue;
-			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
-				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
-			}
-		} else if (sch->type == SCTP_CID_HEARTBEAT_ACK) {
-			if (ct->proto.sctp.vtag[dir] == 0) {
-				pr_debug("Setting vtag %x for dir %d\n",
-					 sh->vtag, dir);
-				ct->proto.sctp.vtag[dir] = sh->vtag;
-			} else if (sh->vtag != ct->proto.sctp.vtag[dir]) {
-				if (test_bit(SCTP_CID_DATA, map) || ignore)
-					goto out_unlock;
-
-				if ((ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) == 0 ||
-				    ct->proto.sctp.last_dir == dir)
-					goto out_unlock;
-
-				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
-				ct->proto.sctp.vtag[dir] = sh->vtag;
-				ct->proto.sctp.vtag[!dir] = 0;
-			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
-				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
-			}
-		} else if (sch->type == SCTP_CID_DATA || sch->type == SCTP_CID_SACK) {
-			if (ct->proto.sctp.vtag[dir] == 0) {
-				pr_debug("Setting vtag %x for dir %d\n", sh->vtag, dir);
-				ct->proto.sctp.vtag[dir] = sh->vtag;
-			}
+		/* we have seen traffic both ways, go to established */
+		if (dir == IP_CT_DIR_REPLY &&
+			ct->proto.sctp.state == SCTP_CONNTRACK_OPEN_WAIT) {
+			ct->proto.sctp.state = SCTP_CONNTRACK_ESTABLISHED;
+			nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 		}
+	}
 
-		old_state = ct->proto.sctp.state;
-		new_state = sctp_new_state(dir, old_state, sch->type);
+	/* Check the verification tag (Sec 8.5) */
+	if (!test_bit(SCTP_CID_INIT, map) &&
+		!test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
+		!test_bit(SCTP_CID_COOKIE_ECHO, map) &&
+		!test_bit(SCTP_CID_ABORT, map) &&
+		!test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
+		!test_bit(SCTP_CID_HEARTBEAT, map) &&
+		!test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
+		sctph->vtag != ct->proto.sctp.vtag[dir]) {
+		pr_debug("Verification tag check failed\n");
+		goto out_unlock;
+	}
 
-		/* Invalid */
-		if (new_state == SCTP_CONNTRACK_MAX) {
-			pr_debug("nf_conntrack_sctp: Invalid dir=%i ctype=%u "
-				 "conntrack=%u\n",
-				 dir, sch->type, old_state);
+	/* Special cases of Verification tag check (Sec 8.5.1) */
+	if (test_bit(SCTP_CID_INIT, map)) {
+		/* Sec 8.5.1 (A) */
+		if (sctph->vtag != 0)
 			goto out_unlock;
-		}
+		else if (nf_ct_is_confirmed(ct))
+			/* don't renew timeout on init retransmit so
+			* port reuse by client or NAT middlebox cannot
+			* keep entry alive indefinitely (incl. nat info).
+			*/
+			goto out;
+	}
+	if (test_bit(SCTP_CID_ABORT, map)) {
+		/* Sec 8.5.1 (B) */
+		if (sctph->vtag != ct->proto.sctp.vtag[dir] &&
+			sctph->vtag != ct->proto.sctp.vtag[!dir])
+			goto out_unlock;
+	}
+	if (test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map)) {
+		/* Sec 8.5.1 (C) */
+		if (sctph->vtag != ct->proto.sctp.vtag[dir] &&
+			sctph->vtag != ct->proto.sctp.vtag[!dir] &&
+			sch->flags & SCTP_CHUNK_FLAG_T)
+			goto out_unlock;
+	}
+	if (test_bit(SCTP_CID_COOKIE_ECHO, map)) {
+		/* Sec 8.5.1 (D) */
+		if (sctph->vtag != ct->proto.sctp.vtag[dir])
+			goto out_unlock;
+	}
+	if (test_bit(SCTP_CID_HEARTBEAT, map)) {
+		if (sctph->vtag != ct->proto.sctp.vtag[dir]) {
+			if (test_bit(SCTP_CID_DATA, map))
+				goto out_unlock;
 
-		/* If it is an INIT or an INIT ACK note down the vtag */
-		if (sch->type == SCTP_CID_INIT ||
-		    sch->type == SCTP_CID_INIT_ACK) {
-			struct sctp_inithdr _inithdr, *ih;
+			ct->proto.sctp.flags |= SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+			ct->proto.sctp.last_dir = dir;
+		} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
+			ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+		}
+	}
+	if (sch->type == SCTP_CID_HEARTBEAT_ACK) {
+		if (sctph->vtag != ct->proto.sctp.vtag[dir]) {
+			if (test_bit(SCTP_CID_DATA, map))
+				goto out_unlock;
 
-			ih = skb_header_pointer(skb, offset + sizeof(_sch),
-						sizeof(_inithdr), &_inithdr);
-			if (ih == NULL)
+			if ((ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) == 0 ||
+				ct->proto.sctp.last_dir == dir)
 				goto out_unlock;
-			pr_debug("Setting vtag %x for dir %d\n",
-				 ih->init_tag, !dir);
-			ct->proto.sctp.vtag[!dir] = ih->init_tag;
 
-			/* don't renew timeout on init retransmit so
-			 * port reuse by client or NAT middlebox cannot
-			 * keep entry alive indefinitely (incl. nat info).
-			 */
-			if (new_state == SCTP_CONNTRACK_CLOSED &&
-			    old_state == SCTP_CONNTRACK_CLOSED &&
-			    nf_ct_is_confirmed(ct))
-				ignore = true;
+			ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
+			ct->proto.sctp.vtag[dir] = sctph->vtag;
+			ct->proto.sctp.vtag[!dir] = 0;
+		} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
+			ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
 		}
-
-		ct->proto.sctp.state = new_state;
-		if (old_state != new_state)
-			nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 	}
-	spin_unlock_bh(&ct->lock);
-
-	/* allow but do not refresh timeout */
-	if (ignore)
-		return NF_ACCEPT;
 
 	timeouts = nf_ct_timeout_lookup(ct);
 	if (!timeouts)
 		timeouts = nf_sctp_pernet(nf_ct_net(ct))->timeouts;
 
-	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[new_state]);
+	nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[ct->proto.sctp.state]);
 
-	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
-	    dir == IP_CT_DIR_REPLY &&
-	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
-		pr_debug("Setting assured bit\n");
-		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_ASSURED, ct);
-	}
+	/* Need some thought on how to set the assured bit */
+	// if (dir == IP_CT_DIR_REPLY &&
+	// 	!(test_bit(IPS_ASSURED_BIT, &ct->status))) {
+	// 	  set_bit(IPS_ASSURED_BIT, &ct->status);
+	// 	  nf_conntrack_event_cache(IPCT_ASSURED, ct);
+	// }
 
+out:
+	spin_unlock_bh(&ct->lock);
 	return NF_ACCEPT;
 
 out_unlock:
 	spin_unlock_bh(&ct->lock);
-out:
+out_drop:
 	return -NF_ACCEPT;
 }
 
-static bool sctp_can_early_drop(const struct nf_conn *ct)
-{
-	switch (ct->proto.sctp.state) {
-	case SCTP_CONNTRACK_SHUTDOWN_SENT:
-	case SCTP_CONNTRACK_SHUTDOWN_RECD:
-	case SCTP_CONNTRACK_SHUTDOWN_ACK_SENT:
-		return true;
-	default:
-		break;
-	}
-
-	return false;
-}
-
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 
 #include <linux/netfilter/nfnetlink.h>
@@ -670,7 +364,7 @@ static int sctp_timeout_nlattr_to_obj(struct nlattr *tb[],
 		}
 	}
 
-	timeouts[CTA_TIMEOUT_SCTP_UNSPEC] = timeouts[CTA_TIMEOUT_SCTP_CLOSED];
+	timeouts[CTA_TIMEOUT_SCTP_UNSPEC] = timeouts[CTA_TIMEOUT_SCTP_OPEN_WAIT];
 	return 0;
 }
 
@@ -692,16 +386,8 @@ sctp_timeout_obj_to_nlattr(struct sk_buff *skb, const void *data)
 
 static const struct nla_policy
 sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
-	[CTA_TIMEOUT_SCTP_CLOSED]		= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_COOKIE_WAIT]		= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_COOKIE_ECHOED]	= { .type = NLA_U32 },
+	[CTA_TIMEOUT_SCTP_OPEN_WAIT]		= { .type = NLA_U32 },
 	[CTA_TIMEOUT_SCTP_ESTABLISHED]		= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_SHUTDOWN_SENT]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_SHUTDOWN_RECD]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_HEARTBEAT_SENT]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_DATA_SENT]		= { .type = NLA_U32 },
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
@@ -716,7 +402,7 @@ void nf_conntrack_sctp_init_net(struct net *net)
 	/* timeouts[0] is unused, init it so ->timeouts[0] contains
 	 * 'new' timeout, like udp or icmp.
 	 */
-	sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_CLOSED];
+	sn->timeouts[0] = sctp_timeouts[SCTP_CONNTRACK_OPEN_WAIT];
 }
 
 const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
@@ -724,7 +410,6 @@ const struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp = {
 #ifdef CONFIG_NF_CONNTRACK_PROCFS
 	.print_conntrack	= sctp_print_conntrack,
 #endif
-	.can_early_drop		= sctp_can_early_drop,
 #if IS_ENABLED(CONFIG_NF_CT_NETLINK)
 	.nlattr_size		= SCTP_NLATTR_SIZE,
 	.to_nlattr		= sctp_to_nlattr,
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0250725e38a4..07da9db31783 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -593,16 +593,8 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMP,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_ICMPV6,
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_CLOSED,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_WAIT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_ECHOED,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_OPEN_WAIT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ESTABLISHED,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -839,20 +831,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.proc_handler	= proc_dointvec_jiffies,
 	},
 #ifdef CONFIG_NF_CT_PROTO_SCTP
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_CLOSED] = {
-		.procname	= "nf_conntrack_sctp_timeout_closed",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_WAIT] = {
-		.procname	= "nf_conntrack_sctp_timeout_cookie_wait",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_COOKIE_ECHOED] = {
-		.procname	= "nf_conntrack_sctp_timeout_cookie_echoed",
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_OPEN_WAIT] = {
+		.procname	= "nf_conntrack_sctp_timeout_open_wait",
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
@@ -863,42 +843,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_SENT] = {
-		.procname	= "nf_conntrack_sctp_timeout_shutdown_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD] = {
-		.procname	= "nf_conntrack_sctp_timeout_shutdown_recd",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT] = {
-		.procname	= "nf_conntrack_sctp_timeout_shutdown_ack_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT] = {
-		.procname	= "nf_conntrack_sctp_timeout_heartbeat_sent",
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED] = {
-		.procname       = "nf_conntrack_sctp_timeout_heartbeat_acked",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT] = {
-		.procname       = "nf_conntrack_sctp_timeout_data_sent",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
@@ -1034,16 +978,8 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	table[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_ ## XNAME].data = \
 			&(sn)->timeouts[SCTP_CONNTRACK_ ## XNAME]
 
-	XASSIGN(CLOSED, sn);
-	XASSIGN(COOKIE_WAIT, sn);
-	XASSIGN(COOKIE_ECHOED, sn);
+	XASSIGN(OPEN_WAIT, sn);
 	XASSIGN(ESTABLISHED, sn);
-	XASSIGN(SHUTDOWN_SENT, sn);
-	XASSIGN(SHUTDOWN_RECD, sn);
-	XASSIGN(SHUTDOWN_ACK_SENT, sn);
-	XASSIGN(HEARTBEAT_SENT, sn);
-	XASSIGN(HEARTBEAT_ACKED, sn);
-	XASSIGN(DATA_SENT, sn);
 #undef XASSIGN
 #endif
 }
-- 
2.34.1

