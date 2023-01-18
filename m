Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC60C32793
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 11:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjARL7W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 06:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjARL6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 06:58:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2130.outbound.protection.outlook.com [40.107.105.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F2954B3E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:15:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+UVxHdwt6nOcHTy3PEjclIqrufJNAdR5s5eXmNvaC5D1/KXy8jqy/0ILWnoPcT9xglGZU18nznrencL2wJ0W46jNNArvDvxu9Mvq0fB6Z0JBWoVVWZJT2zBvhIpVnBo6XfvLPpV+TAxY9VssbICyG0uybP9DwxaNUTZYTmYdrVLxpGJ5IrpTkQ31I3Uu1j473J0kB+4Osrcm+wByMsv55lXHT+6Avr5Zr+sLR8vaOLfqAdVZ3TGOgqEAKKbZ6Pjbao5ypoLqR4E4LVu+cvY8l4QELgmkZxRsz0dD6BQJETZpKR5Z9BzEFIQwNzb9LuEMGFsWCf8tNqZ7hlpTcCtBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HoHF2BKDZUnuf4okb0UnLmNH40gQ7rOw1zFNN3CKPt4=;
 b=XL5KesrqEmkKqe3P7YYHSW0/w13FNR7F0ZpEyjVuuYz0f2VbQcleTXTJPoXYCsJ/DBeGKfdCEmYOqGUp8P4spw0cJt3QeeFCCu5B2n/3TZ8dHIaz9WnXwYoJF9DdLNR1dcxy4BSbZhV9VUkEjK3ItsLc+Wej7Q23m1jGnImE79gB7BMJxf/PHMrfpUuDRWXyDO11JfXknlOTHQ6kT9oQN0ziqLHo1Q9/rLMpB7zxSen50khXtNRJ9EoapbG4bLVG9xNQBcJPM9FiGGCNTopbRhpkWQQf7nzBDqIHbbsbK224n1pX/6AlrDd8hXYdBa41cO/fYvQ+UKalH7saxwDGjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HoHF2BKDZUnuf4okb0UnLmNH40gQ7rOw1zFNN3CKPt4=;
 b=DCWHUAJMgAQOuQeoYJAseteFhNIEntqZmlRKtYKgKj8vSTQR6xOdWVmP/iQP2aSs/QY80Q1UsriWShentAZOEHqLrns1Qi3V+YMpMuCLNl2dv/zBJaur6L9xcyxD8Eh6kz2JL7vllTog0iKwDy0dZ1e7R8O6n0Ornw469vcCC2E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P18901MB0783.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:15:13 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:15:13 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 3/4] Revert "netfilter: conntrack: add sctp DATA_SENT state"
Date:   Wed, 18 Jan 2023 12:14:58 +0100
Message-Id: <20230118111459.32551-4-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
References: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0024.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::12) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P18901MB0783:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d5fda1-8e6d-45c1-d52c-08daf9454467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K/vAvDu1fAwiIaw33t2DQZJXqvh/dh2Z/BjdQPtIe6o7OfLcxBu2UQWCYcjDDIGO3xAeEcTYCutBq1y86wxM66e/vV82m+MGlH/vwfnUkkABjSqnGMhDmiCNTs/a9jH0sV+0AnTK4z5eJqQGkQUdc8IIJqOOIlCXjl72bNyvdGGAqBiZaU8cDd8+Qm1VHuhCnuuwX9LlalFwgzpGOmXBFixKg289LXldGhC+YrK2NbjyAhxF2nU3CitUKE8IWpIektx9ViGyW3r3BMbe/I7mUxzjkAOLeo71R6Mokm5cRZxDh3yAoAsj1SQr0jldH3dihBdB5yF3GWqZ7ulrowV7NdZLzsg90ekQHp0e3+C3hpZslXLkqTZr5e54aLutb744K9xvnvjxSF/wmIF1Cdp6H8T4wXtQDRiv3fhKa5hstr/LYF4oyslKYlwTecIoVEmOEGSHHHHe50hlChA2tDC/vCbDK8tP/g7qzdrs+sYP0QiAdwmskuJxsK5mZYy6+jzgE0zZsLId8QB7/+B5ejSK93GpNTPQuEnGl7PELhAIghazBZUUiXXHZwZRWJtFXE2TtDtQjVUqWCEGyKMaqcAFx0o1dwX75W7sUfs77z2/4KP+91BFIgKRaeKhCe0fg6X11dYRxItfQRP1toyfv7odjfOdemy8hzT6M4qxdPKT5Clh79868pkgrb2btQ3f7oENYQlHRrFrJtYMNsG6sfj5yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(136003)(346002)(376002)(451199015)(2906002)(38100700002)(86362001)(66476007)(36756003)(316002)(2616005)(1076003)(6916009)(54906003)(4326008)(44832011)(6506007)(8676002)(70586007)(66946007)(41300700001)(66556008)(83380400001)(5660300002)(6512007)(30864003)(6486002)(26005)(478600001)(6666004)(8936002)(186003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hl5AbQQtglnq4jWxTzyo1tSIIthJolSiwKEoQq4xkAf8Ya272zTguv1vgawL?=
 =?us-ascii?Q?yRMilvQ2KzdEaRk1lNdSYsSZV+WgJSXYWScqnEbXj9AJXuZAMSGrbfj+s0Dd?=
 =?us-ascii?Q?qytyLgD7fWAlYSyRVKD1xtGyZAkNQHwDBwMl41MROc+C8UySwkycPeh1ateH?=
 =?us-ascii?Q?7dzkvB5ixzkFQBz+hBkmKkKo0rppf6XV3abwvLNUvsJ5052fwRiQh5yVhRBf?=
 =?us-ascii?Q?rgrNvMZsFHAGS5wyXaxhCj0EolwCWH20euyDsxoT0kcbaDXw3jaJUD6/kiHO?=
 =?us-ascii?Q?GN3Ovh7RyNuh0AXi0/pcHAswKbXHcAkOH4Ey3VBg04qlSqjIdVwS6SJhSkki?=
 =?us-ascii?Q?Sl1/Iz0V7N0n5PcOi7wGvr9dZCme4fHdCLiaJi9lfrbUHGdpEYoLSXLfCbzV?=
 =?us-ascii?Q?iIqx/095Erwx+XYYwmTWIv8hRaBlWg9jqR3TAjCC+1++0N9Bfh1089KKOPNW?=
 =?us-ascii?Q?fwAWedj4vvEdtxxVS6rRxp3NecLKiMJ7rekUBmZ+zLNSSh++aufRFSPFF9oS?=
 =?us-ascii?Q?X36cfajk31RmnwgmKqtgdyPtVeTiUvqxazrI0aQWHEECArJgirTblavMQv3h?=
 =?us-ascii?Q?fL2dPyn5DbZH6q1DZhSGHHw6ddH6n3njnUYhQKycCx/CjNbbcQw6EHlT+ZEg?=
 =?us-ascii?Q?0WuFnNUmDw+KlT2XM79NDkriiLNgXKVO57ymwxYL1gAX0Ig8e8UnwPyXjenY?=
 =?us-ascii?Q?D7bK4g1kT8bl5nTHrhNeubX5lB74FWqlL4GuwS26YyRVyzcusK8ExbxbRMp4?=
 =?us-ascii?Q?A7pHsBGID/pCICmas4hj+vbZgj9ZkGgD2CYOayOWxpExM0+cL0Cgst3uzXgX?=
 =?us-ascii?Q?NbPaqZDBLfeDTTEm4F8AvXLo4oZrqatSyGpKXthrKTFopwBCCuPGwB0KHpDO?=
 =?us-ascii?Q?TDFj+I5uaymhYD2tEDXtkAp+YCKkFQa3WdbgHZKW0LeBhlNGiyOTt/7x9GIM?=
 =?us-ascii?Q?xdBjcjrxw7RW1uF4vGOnfjDllzEqU73jCL2yxrhc+Ftf8ZQFHNSRcDDCjlsb?=
 =?us-ascii?Q?bK85yhA+dtDW3MhjLvr9cXkVzRd0+vNl13iHxwxG+9oSUSV1xjFeKh6rrXEK?=
 =?us-ascii?Q?bJxPPiiFnT9BvswYa0gySXv1K5g0OS5a9tHPnCvSpGXYTplMez0llAu/Ger+?=
 =?us-ascii?Q?23wD/fLU07rXoK+jqsE05yuEasNFaDipNL0L2w4Zt2K3sGW758ODvgdS/LGQ?=
 =?us-ascii?Q?v6M1JUe8JTvU2rD6OST2gFJVjG8Th5sJPKCk/pwohK4DT0aeP5vlfmXjNUXC?=
 =?us-ascii?Q?iza5IqPawVAccT5GnCRrmFIWNb/LSgUdvukDFr9jLrOpzPdDpzuywDe6QRSf?=
 =?us-ascii?Q?myzR2M89sX3l0ULQt8J5JE0YUompGjbLcXff4Nc6SrFR2MO3UH+OJJlRPUsq?=
 =?us-ascii?Q?bV37YGhLvFqgA5fS5xOt6M2qw6Mr+m9XyUB/TjULuXxKkX0z42ngu9iNA2RD?=
 =?us-ascii?Q?GZdIv3+pEbToCo1M6bzRI2t1BUyvzYL52uiPubc2zhXmCS+1cCU/evBb8LWK?=
 =?us-ascii?Q?6sXKv7eQIvEMqSXg4G3GuBocGLGGz2D+tgZs4EPZaHD7X3XXmJohOGsYemmt?=
 =?us-ascii?Q?SU5KtgxIGMHFqfJmsGxqwsDF4uXp+8ATb2aMGitXqG4t6K/p95UzYA6+kaI3?=
 =?us-ascii?Q?Ug=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d5fda1-8e6d-45c1-d52c-08daf9454467
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:15:12.2842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DOFpRwcT6DIMYrmWT0fzZclB9/z6hwXrIgBJkHHJTgwH2edmxNWDwYEypsdFoRITycylQ9oL0KoN2v/xcq/qOgX66nmUFUHOMoXvlQ89Yv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0783
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This reverts commit (bff3d0534804: "netfilter: conntrack: add sctp
DATA_SENT state")

Using DATA/SACK to detect a new connection on secondary/alternate paths
works only on new connections, while a HEARTBEAT is required on
connection re-use. It is probably consistent to wait for HEARTBEAT to
create a secondary connection in conntrack.

Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   2 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |   2 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 102 ++++++++----------
 net/netfilter/nf_conntrack_standalone.c       |   8 --
 4 files changed, 44 insertions(+), 70 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index c742469afe21..b90680f01e38 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -16,7 +16,7 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_ACKED,
-	SCTP_CONNTRACK_DATA_SENT,
+	SCTP_CONNTRACK_DATA_SENT,         /* no longer used */
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 94e74034706d..1f4c691fe926 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -95,7 +95,7 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	CTA_TIMEOUT_SCTP_DATA_SENT,
+	CTA_TIMEOUT_SCTP_DATA_SENT,          /* no longer used */
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index c561c1213704..01cf3e06f042 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -60,7 +60,6 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT]	= 3 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_SENT]		= 30 SECS,
 	[SCTP_CONNTRACK_HEARTBEAT_ACKED]	= 210 SECS,
-	[SCTP_CONNTRACK_DATA_SENT]		= 30 SECS,
 };
 
 #define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
@@ -75,7 +74,6 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 #define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
 #define	sHS SCTP_CONNTRACK_HEARTBEAT_SENT
 #define	sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
-#define	sDS SCTP_CONNTRACK_DATA_SENT
 #define	sIV SCTP_CONNTRACK_MAX
 
 /*
@@ -98,10 +96,9 @@ SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
 CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
 		    the SHUTDOWN chunk. Connection is closed.
 HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
-HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK/DATA/SACK in the direction
-		    opposite to that of the HEARTBEAT/DATA chunk. Secondary connection
-		    is established.
-DATA_SENT         - We have seen a DATA/SACK in a new flow.
+HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK in the direction opposite to
+		    that of the HEARTBEAT chunk. Secondary connection is
+		    established.
 */
 
 /* TODO
@@ -115,38 +112,36 @@ cookie echoed to closed.
 */
 
 /* SCTP conntrack state transitions */
-static const u8 sctp_conntracks[2][12][SCTP_CONNTRACK_MAX] = {
+static const u8 sctp_conntracks[2][11][SCTP_CONNTRACK_MAX] = {
 	{
 /*	ORIGINAL	*/
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
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
+/* init         */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCW, sHA},
+/* init_ack     */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},
+/* abort        */ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL},
+/* shutdown     */ {sCL, sCL, sCW, sCE, sSS, sSS, sSR, sSA, sCL, sSS},
+/* shutdown_ack */ {sSA, sCL, sCW, sCE, sES, sSA, sSA, sSA, sSA, sHA},
+/* error        */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* Can't have Stale cookie*/
+/* cookie_echo  */ {sCL, sCL, sCE, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* 5.2.4 - Big TODO */
+/* cookie_ack   */ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sCL, sHA},/* Can't come in orig dir */
+/* shutdown_comp*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sCL, sCL, sHA},
+/* heartbeat    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA},
+/* heartbeat_ack*/ {sCL, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA}
 	},
 	{
 /*	REPLY	*/
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
+/*                  sNO, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA */
+/* init         */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* INIT in sCL Big TODO */
+/* init_ack     */ {sIV, sCW, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},
+/* abort        */ {sIV, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sIV, sCL},
+/* shutdown     */ {sIV, sCL, sCW, sCE, sSR, sSS, sSR, sSA, sIV, sSR},
+/* shutdown_ack */ {sIV, sCL, sCW, sCE, sES, sSA, sSA, sSA, sIV, sHA},
+/* error        */ {sIV, sCL, sCW, sCL, sES, sSS, sSR, sSA, sIV, sHA},
+/* cookie_echo  */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sIV, sHA},/* Can't come in reply dir */
+/* cookie_ack   */ {sIV, sCL, sCW, sES, sES, sSS, sSR, sSA, sIV, sHA},
+/* shutdown_comp*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sCL, sIV, sHA},
+/* heartbeat    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS, sHA},
+/* heartbeat_ack*/ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHA, sHA}
 	}
 };
 
@@ -258,11 +253,6 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 		pr_debug("SCTP_CID_HEARTBEAT_ACK");
 		i = 10;
 		break;
-	case SCTP_CID_DATA:
-	case SCTP_CID_SACK:
-		pr_debug("SCTP_CID_DATA/SACK");
-		i = 11;
-		break;
 	default:
 		/* Other chunks like DATA or SACK do not change the state */
 		pr_debug("Unknown chunk type, Will stay in %s\n",
@@ -316,9 +306,7 @@ sctp_new(struct nf_conn *ct, const struct sk_buff *skb,
 				 ih->init_tag);
 
 			ct->proto.sctp.vtag[IP_CT_DIR_REPLY] = ih->init_tag;
-		} else if (sch->type == SCTP_CID_HEARTBEAT ||
-			   sch->type == SCTP_CID_DATA ||
-			   sch->type == SCTP_CID_SACK) {
+		} else if (sch->type == SCTP_CID_HEARTBEAT) {
 			pr_debug("Setting vtag %x for secondary conntrack\n",
 				 sh->vtag);
 			ct->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = sh->vtag;
@@ -404,19 +392,19 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 
 		if (!sctp_new(ct, skb, sh, dataoff))
 			return -NF_ACCEPT;
-	} else {
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
-		}
+	}
+
+	/* Check the verification tag (Sec 8.5) */
+	if (!test_bit(SCTP_CID_INIT, map) &&
+	    !test_bit(SCTP_CID_SHUTDOWN_COMPLETE, map) &&
+	    !test_bit(SCTP_CID_COOKIE_ECHO, map) &&
+	    !test_bit(SCTP_CID_ABORT, map) &&
+	    !test_bit(SCTP_CID_SHUTDOWN_ACK, map) &&
+	    !test_bit(SCTP_CID_HEARTBEAT, map) &&
+	    !test_bit(SCTP_CID_HEARTBEAT_ACK, map) &&
+	    sh->vtag != ct->proto.sctp.vtag[dir]) {
+		pr_debug("Verification tag check failed\n");
+		goto out;
 	}
 
 	old_state = new_state = SCTP_CONNTRACK_NONE;
@@ -483,11 +471,6 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 			} else if (ct->proto.sctp.flags & SCTP_FLAG_HEARTBEAT_VTAG_FAILED) {
 				ct->proto.sctp.flags &= ~SCTP_FLAG_HEARTBEAT_VTAG_FAILED;
 			}
-		} else if (sch->type == SCTP_CID_DATA || sch->type == SCTP_CID_SACK) {
-			if (ct->proto.sctp.vtag[dir] == 0) {
-				pr_debug("Setting vtag %x for dir %d\n", sh->vtag, dir);
-				ct->proto.sctp.vtag[dir] = sh->vtag;
-			}
 		}
 
 		old_state = ct->proto.sctp.state;
@@ -708,7 +691,6 @@ sctp_timeout_nla_policy[CTA_TIMEOUT_SCTP_MAX+1] = {
 	[CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_SCTP_HEARTBEAT_SENT]	= { .type = NLA_U32 },
 	[CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED]	= { .type = NLA_U32 },
-	[CTA_TIMEOUT_SCTP_DATA_SENT]		= { .type = NLA_U32 },
 };
 #endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0250725e38a4..bca839ab1ae8 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -602,7 +602,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -893,12 +892,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode           = 0644,
 		.proc_handler   = proc_dointvec_jiffies,
 	},
-	[NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT] = {
-		.procname       = "nf_conntrack_sctp_timeout_data_sent",
-		.maxlen         = sizeof(unsigned int),
-		.mode           = 0644,
-		.proc_handler   = proc_dointvec_jiffies,
-	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST] = {
@@ -1043,7 +1036,6 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(SHUTDOWN_ACK_SENT, sn);
 	XASSIGN(HEARTBEAT_SENT, sn);
 	XASSIGN(HEARTBEAT_ACKED, sn);
-	XASSIGN(DATA_SENT, sn);
 #undef XASSIGN
 #endif
 }
-- 
2.34.1

