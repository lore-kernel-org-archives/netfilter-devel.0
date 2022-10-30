Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BAA3C38A02
	for <netfilter-devel@archiver.kernel.org>; Sun, 30 Oct 2022 12:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiJ3M0I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 30 Oct 2022 08:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3M0H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 30 Oct 2022 08:26:07 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70097.outbound.protection.outlook.com [40.107.7.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121501B1
        for <netfilter-devel@vger.kernel.org>; Sun, 30 Oct 2022 05:26:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DObmYiulqfMMfRVlVgvG3SV7OYU23WzV6ity0cpebTO2ePHdjm0/PMF27A9/idkPGQ3awge66l2Rw/rTNF4chB9BgZnY2/3MJD72Kyb4v9pQx98j77mRB+sRzsrDwOCdcT0cErQ5hrFCnmBGdn9KmfYF6yAg1eT4Wu5OTPh10248oXtLzIo3FQoE6Wt98KYLA/Vl9hLO6ZtwtFfeicV/vnghsS9SycNK7B/m8EGvf0JNHZohQ+26Uj5Um5EwgdU+4+Vkzmjz0DlNUzsIZFT0+2AzdAdQSXhWVBCZKdy4XggIYbcgnU4oe5gC63KPShXyvv5gAQui0GOGiSQBoQwjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EYkFLe54JVkRAaqHwIwR6MRxlyiQXnwMaaH4OuXieA=;
 b=ES4NOJsivVoO78kVMIGAQZUSfdU/dvnJFQbtVb8fFeYI24OKqYXZnEFLHodkcIgJEjW0D5kAD1iZvIQzOMT6op/jsE/7YTxy3Is7fxyg6bsgN0oHCC6l0Qs0QR2Wpd0v8pkgO/rOXg1+W5tYYQgnf/x/NybxpbQHgDoQ21dcZtR9MnKuSAn9naVRUcynH2BjBCt3kTaaYcicFMsnuPyP+4iSFK6OyMm3a29NBtAyb+IYirsAQahCG2uQgIjmuElIJfe98yql+9lL0AO81xUqffHaPM+tPW9xJKzedGgyfgG5xvfFEFGdGzGfRTSFGczPCzcb5xze3iKgV/hNY4ceww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EYkFLe54JVkRAaqHwIwR6MRxlyiQXnwMaaH4OuXieA=;
 b=UBEipYvsYAhV5X3lqVnqKy5L+34Hr/BEZNg6I/rnbd7lh95bixdJg9gTExwKOvOlS8X/7nbr84HrH1vijMih30uBdKc+ZzfqsiGLL2TUsXczuT65qPMbjYVHIgyZU1jEQelY+GiwME/QF33/1pRT4LPrV9fvgR2k4MuxRIudavM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AS4P189MB2231.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:582::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.10; Sun, 30 Oct
 2022 12:26:03 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8%7]) with mapi id 15.20.5791.015; Sun, 30 Oct 2022
 12:26:03 +0000
From:   sriram.yagnaraman@est.tech
To:     netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 2/2] netfilter: conntrack: add sctp DATA_SENT state
Date:   Sun, 30 Oct 2022 13:25:41 +0100
Message-Id: <20221030122541.31354-3-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0075.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::24) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AS4P189MB2231:EE_
X-MS-Office365-Filtering-Correlation-Id: 760ffe9f-14c0-4480-ad8f-08daba71e966
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z4TuSuQAO9Ct9da4sJtprUw534bq4DYj4Dl9Eqt5mZWil8G5mDRDvkIw1jU6y5ulQtiELJXjL1rmHZWQSbLW97Et3friRdOFRXpqmrjiKWO1FVD5KaeKx04EV9NZZ4GZxmk8+MryhFGpo8mBXKiz33965z+7LHskj2VWgCkqZ4UNqao4A64pqzRJORRgI7DjYltp+bJSlS6FlBgOpP+G+tgXd/eHtQ7MNYSHlfiFifQVKdTprartlgHbNlb0xogy5r64c0r9FbQBH6JikS893Wai3zI6piIujLVr/D6QTwEPtTE2R5ktShJzgOONWJpQ8VcXSpMiEVyRDCqbeuLhlUrXVINd+x7bz7AMxIZ2JoYeWYj869qvXbjW4BX9iHFBNSmWyOAV+nTJd8hGiRunyP9EbIvAL2JDVNckHYyAsOzj2RmO0Qq6oaADvgOq6hl1ttfin+pQRBjMz2uaXWnh7SdUEas5On9Anp59ZUtgW1OvVnP/or7wzUF6k9bIIx5CglGjF1medDLn44ZXz1aMFGsGAWy8uXXcFOLQRcWnApX6bpHx36tir8gJ77Dq6XJE1OMC1lWCZOpL/d64c5ZHA6w1eaGKbRxYoWlz9nUSGu4eldeSXtifBFwuoqyn+t1BPorBjHhXBM6nvjeVqiWRlXls+nLWTeu5/n2vt1Uko5R/LHFEYFJwd0UDWe7c7IiPXHlqiLfGmY5vPG3oBPFQfm1ahJuT5Jdfalz6ZV6znzHvW2pGm4Iv5XwSboxdaZnY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(396003)(136003)(346002)(451199015)(36756003)(316002)(66476007)(4326008)(6486002)(66556008)(8676002)(83380400001)(41300700001)(478600001)(8936002)(6916009)(2906002)(30864003)(5660300002)(186003)(2616005)(6512007)(1076003)(38100700002)(66946007)(9686003)(70586007)(26005)(86362001)(6666004)(6506007)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N6JTdwN+tyeoHT9ozb5D1AcRjaDHcP5sKB57m9bBcPk1SFYP2zP7W8xbrnvN?=
 =?us-ascii?Q?23FYjiPhIAPYtvbpROjH3q+YdvQZ31RtBw1/eylnaduBmAaJfQBxYUOMz8n2?=
 =?us-ascii?Q?Yq8+VhV+mT+/ZXKA9HBDssSmxnUG2uAksUSz9CqvomXHPHsz1m1CwbpTkeqe?=
 =?us-ascii?Q?5egVeL1vu5p1lz5cH8LTxB+Uih1lfeCAQHxBMGsYX9a/s+6aF+Lr1F+9J5t5?=
 =?us-ascii?Q?8jkB0SmOMkoLSc0Z8gdhPr5h9SNqcL8V3Vw0smsPlN/1RSHx5Eb06J3+0HRF?=
 =?us-ascii?Q?zUbrrmMnDP5Y5eVIJ1Zyks43P+pZ5vIY6OxDlkFBE0cp1GJoz3lsEUnUMO3k?=
 =?us-ascii?Q?HyzLa7TQrZDa1B9nOb45eH/0Y2uLdWiAC7KNhcUSKwZVvrW36KUs4wUR/ipL?=
 =?us-ascii?Q?3zUc1nLNLWRaU082a3u4pMc2vIMs5KcLnUI03wwxDEbjUsG/XRldeS8koDOo?=
 =?us-ascii?Q?r7XraqT3ooqCxm/pGmGreA1OVgzzfvjH4LE19tD2+/3cOtFfI42z5H6Bzakx?=
 =?us-ascii?Q?PqhfHZ674teMRBG/29vW3u3qujbNTmZYeP73HZq79c/JQ0/5l7MyCF4h03u7?=
 =?us-ascii?Q?GU8h6z6yJj1n3hgNIkIoBAHz+GRysxFWlv+2i9LkI041u9GnPhdqdGQYsoiS?=
 =?us-ascii?Q?pHd9/RNJqjwnIXQkKSIG0Z7MH5b2hU7tD8lD18oeBwEbumsYTjaWuaffqEzV?=
 =?us-ascii?Q?ZLBNU4J5MTbJaUp15N9Md0tNVEFdzG7zIkjFfev4WBQ58eNGP7xfHKNg4vSc?=
 =?us-ascii?Q?uchyCqBUXdZSVmrK95GJv9gC+MK6dODT3jzfgCk1eUiFV5beLh1/g3uh2ys0?=
 =?us-ascii?Q?qkxS9dnN+T8WgCGcvC9BnVRUgIckpFYnzS0EqtnS8RMlu75RlI5dMYztP1X2?=
 =?us-ascii?Q?FsvOJH+CAWHm1BH24hLxE7pQls3IC13QJK+ev4TIla6eLOR8a8+NZjcSy41K?=
 =?us-ascii?Q?T4rZxbqopU3ZWaGrCvzVceEy4TMbpDtPe6ZfIeSMhSjV7T3ty7RVjziKQxbK?=
 =?us-ascii?Q?syfbws7nKoBov7jlUr6HfeRQNpauFWt6DaBquzrThE9ZP0k3emMFlyAoqxeA?=
 =?us-ascii?Q?4q/LpkFTkfZh996+TCps+3cq1tWEnW80BIbJHBnFuJPEGswzHIf51CYpPgNc?=
 =?us-ascii?Q?HFQCWi98VaKvfUoNZ0IIhUmzmdd0pCaqqdmrRz5Kj2yVY/DJigCYkKiOU6BM?=
 =?us-ascii?Q?GRxxhW+4nQlXu2WuRxf4JiCe07AL0KX5e534hYdnnAe+1q3rBvWCkq44UH/2?=
 =?us-ascii?Q?2+rF89/fDDzCnit7AgizdCtpyQTJAFeMgfW5SR6shm5W1Y1zvRw9oFu98geY?=
 =?us-ascii?Q?6njtNLzNF+oxQChThuqqzBPnn2TaIzBDc6Ru8ryWWg3mV4dshq3eOH0l9Tt6?=
 =?us-ascii?Q?fcidJ6c5evlHktSYBmwdm2NC1IuLcMy+vbyMRELwjXtvkqemChaVuehK19z4?=
 =?us-ascii?Q?1wvJ/vJ2sadL4I5LWK5OK7//zroTF6AMA65n80kO7P+9/rV0P8+IqLr5bsiQ?=
 =?us-ascii?Q?HEYmfVZTGsI3Nqt2QUrpEDGpslNpJZ5j8nSPdiov5/zty7fJHau5womIwnID?=
 =?us-ascii?Q?UDF4YutPNMNIhhoKEhOKb66hHCV5PDHB6G9JLngYVo7uocalwVqcw19ZWPdf?=
 =?us-ascii?Q?Ow=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 760ffe9f-14c0-4480-ad8f-08daba71e966
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2022 12:26:03.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOPJTtmZAa1gzeTnTCjHlmLBodSuxoGVT58RrEvO4xm1G+qFz2zkw5Tm/ieXQpcbdGRQz0WGKFY6OORtQmbtNWeQHxEcuJDIVzWWEe9iFr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P189MB2231
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>

SCTP conntrack currently assumes that the SCTP endpoints will
probe secondary paths using HEARTBEAT before sending traffic.

But, according to RFC 9260, SCTP endpoints can send any traffic
on any of the confirmed paths after SCTP association is up.
SCTP endpoints that sends INIT will confirm all peer addresses
that upper layer configures, and the SCTP endpoint that receives
COOKIE_ECHO will only confirm the address it sent the INIT_ACK to.

So, we can have a situation where the INIT sender can start to
use secondary paths without the need to send HEARTBEAT. This patch
allows DATA/SACK packets to create new connection tracking entry.

A new state has been added to indicate that a DATA/SACK chunk has
been seen in the original direction - SCTP_CONNTRACK_DATA_SENT.
State transitions mostly follows the HEARTBEAT_SENT, except on
receiving HEARTBEAT/HEARTBEAT_ACK/DATA/SACK in the reply direction.

State transitions in original direction:
- DATA_SENT behaves similar to HEARTBEAT_SENT for all chunks,
   except that it remains in DATA_SENT on receving HEARTBEAT,
   HEARTBEAT_ACK/DATA/SACK chunks
State transitions in reply direction:
- DATA_SENT behaves similar to HEARTBEAT_SENT for all chunks,
   except that it moves to HEARTBEAT_ACKED on receiving
   HEARTBEAT/HEARTBEAT_ACK/DATA/SACK chunks

Note: This patch still doesn't solve the problem when the SCTP
endpoint decides to use primary paths for association establishment
but uses a secondary path for association shutdown. We still have
to depend on timeout for connections to expire in such a case.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   1 +
 .../linux/netfilter/nfnetlink_cttimeout.h     |   1 +
 net/netfilter/nf_conntrack_proto_sctp.c       | 104 ++++++++++--------
 net/netfilter/nf_conntrack_standalone.c       |   8 ++
 4 files changed, 71 insertions(+), 43 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index edc6ddab0de6..c742469afe21 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -16,6 +16,7 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_ACKED,
+	SCTP_CONNTRACK_DATA_SENT,
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 6b20fb22717b..94e74034706d 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -95,6 +95,7 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
+	CTA_TIMEOUT_SCTP_DATA_SENT,
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 5e4d3215dcf6..d7f11145c7eb 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -60,6 +60,7 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
+	[SCTP_CONNTRACK_DATA_SENT]		= 30 SECS,
 };
 
 #define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
@@ -74,6 +75,7 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 #define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
 #define	sHS SCTP_CONNTRACK_HEARTBEAT_SENT
 #define	sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
+#define	sDS SCTP_CONNTRACK_DATA_SENT
 #define	sIV SCTP_CONNTRACK_MAX
 
 /*
@@ -90,15 +92,16 @@ COOKIE WAIT       - We have seen an INIT chunk in the original direction, or als
 COOKIE ECHOED     - We have seen a COOKIE_ECHO chunk in the original direction.
 ESTABLISHED       - We have seen a COOKIE_ACK in the reply direction.
 SHUTDOWN_SENT     - We have seen a SHUTDOWN chunk in the original direction.
-SHUTDOWN_RECD     - We have seen a SHUTDOWN chunk in the reply directoin.
+SHUTDOWN_RECD     - We have seen a SHUTDOWN chunk in the reply direction.
 SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
 		    to that of the SHUTDOWN chunk.
 CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
 		    the SHUTDOWN chunk. Connection is closed.
 HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
-HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK in the direction opposite to
-		    that of the HEARTBEAT chunk. Secondary connection is
-		    established.
+HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK/DATA/SACK in the direction
+		    opposite to that of the HEARTBEAT/DATA chunk. Secondary connection
+		 is established.
+DATA_SENT         - We have seen a DATA/SACK in a new flow.
 */
 
 /* TODO
@@ -112,36 +115,38 @@ cookie echoed to closed.
 */
 
 /* SCTP conntrack state transitions */
-static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
+static const u8 sctp_conntracks[2][12][SCTP_CONNTRACK_MAX] = {
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
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS */
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA, sCW},
+/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},
+/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
+/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS, sCL},
+/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA, sHA, sSA},
+/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* Can't have Stale cookie*/
+/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* 5.2.4 - Big TODO */
+/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA, sCL},/* Can't come in orig dir */
+/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL, sHA, sCL},
+/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS},
+/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS},
+/* data/sack    */ {sDS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS}
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
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sDS */
+/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},/* INIT in sCL Big TODO */
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},
+/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL, sIV},
+/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR, sIV},
+/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA, sIV},
+/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV, sHA, sIV},
+/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA, sIV},/* Can't come in reply dir */
+/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV, sHA, sIV},
+/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV, sHA, sIV},
+/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA, sHA},
+/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA, sHA},
+/* data/sack    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA, sHA},
 	}
 };
 
@@ -253,6 +258,11 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 		pr_debug("SCTP_CID_HEARTBEAT_ACK");
 		i = 10;
 		break;
+	case SCTP_CID_DATA:
+	case SCTP_CID_SACK:
+		pr_debug("SCTP_CID_DATA/SACK");
+		i = 11;
+		break;
 	default:
 		/* Other chunks like DATA or SACK do not change the state */
 		pr_debug("Unknown chunk type, Will stay in %s\n",
@@ -306,7 +316,9 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 				 ih->init_tag);
 
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag;
-		} else if (sch->type == SCTP_CID_HEARTBEAT) {
+		} else if (sch->type == SCTP_CID_HEARTBEAT ||
+				sch->type == SCTP_CID_DATA ||
+				sch->type == SCTP_CID_SACK) {
 			pr_debug("Setting vtag %x for secondary conntrack\n",
 				 sh->vtag);
 			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
@@ -392,19 +404,19 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 		if (!sctp_new(ct, skb, sh, dataoff))
 			return -NF_ACCEPT;
-	}
-
-	/* Check the verification tag (Sec 8.5) */
-	if (!test_bit(SCTP_CID_INIT, map) &&
-	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
-	    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
-	    !test_bit(SCTP_CID_ABORT, map) &&
-	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
-	    !test_bit(SCTP_CID_HEARTBEAT, map) &&
-	    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
-	    sh->vtag != ct->proto.sctp.vtag[dir]) {
-		pr_debug("Verification tag check failed\n");
-		goto out;
+	} else {
+		/* Check the verification tag (Sec 8.5) */
+		if (!test_bit(SCTP_CID_INIT, map) &&
+		    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
+		    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
+		    !test_bit(SCTP_CID_ABORT, map) &&
+		    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
+		    !test_bit(SCTP_CID_HEARTBEAT, map) &&
+		    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
+		    sh->vtag != ct->proto.sctp.vtag[dir]) {
+			pr_debug("Verification tag check failed\n");
+			goto out;
+		}
 	}
 
 	old_state = new_state = SCTP_CONNTRACK_NONE;
@@ -464,6 +476,11 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
 				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
 			}
+		} else if (sch->type == SCTP_CID_DATA || sch->type == SCTP_CID_SACK) {
+			if (ct->proto.sctp.vtag[dir] == 0) {
+				pr_debug("Setting vtag %x for dir %d\n", sh->vtag, dir);
+				ct->proto.sctp.vtag[dir] = sh->vtag;
+			}
 		}
 
 		old_state = ct->proto.sctp.state;
@@ -684,6 +701,7 @@ sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
 	[CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_SCTP_HEARTBEAT_SENT]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED]	= { .type = NLA_U32 },
+	[CTA_TIMEOUT_SCTP_DATA_SENT]		= { .type = NLA_U32 },
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e35876ce418d..15199f00e33f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -602,6 +602,7 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
+	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT,
 	NF_SYSCTL_CT_PROTO_SCTP_NO_RANDOM_PORT,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
@@ -893,6 +894,12 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
+	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT] = {
+		.procname       = "nf_conntrack_sctp_timeout_data_sent",
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_jiffies,
+	},
 	[NF_SYSCTL_CT_PROTO_SCTP_NO_RANDOM_PORT] = {
 		.procname	= "nf_conntrack_sctp_no_random_port",
 		.maxlen		= sizeof(u8),
@@ -1045,6 +1052,7 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(SHUTDOWN_ACK_SENT, sn);
 	XASSIGN(HEARTBEAT_SENT, sn);
 	XASSIGN(HEARTBEAT_ACKED, sn);
+	XASSIGN(DATA_SENT, sn);
 #undef XASSIGN
 #define XASSIGN(XNAME, rval) \
 	table[NF_SYSCTL_CT_PROTO_SCTP_ ## XNAME].data = (rval)
-- 
2.34.1

