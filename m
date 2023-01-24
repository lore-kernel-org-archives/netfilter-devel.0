Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15B0DC25B50
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 01:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjAXBsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAXBsl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 20:48:41 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2127.outbound.protection.outlook.com [40.107.8.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA0A39BA4
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 17:48:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cmrRIYHo1AigKYSQ3TCbJbk4PIgobS0Php5/NXpRWoCJn+gjAv0EBzQ5gNSbDu7qDkXlkcpot4evavL7EmFZLgY+oMy5yoFN/20DokUclvV+8NP5wIJpyYIGqostis8tzbUzc1fu2RxYMQWPhRKlXFFoR1z6Bausrgs3dAc9NCwJDCHaIxrARaCAeSfCb7qEySgK3StgwDfWqPvOUWM5jboqInBe1zkxYURIyh9gzMhIN0LK61vwknDBS6iTMAKJjM/CPXC27x8nxWGWs9wTO09oJxCwcSg40Q+XaJeLVEFPtJQ1SC6mZH77fprtydpPpchzQWYcCdytciez9Cm41w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Og7zC0hlxIcKSmHoudrelrErJ7OLadRgPtXbBKnrPZE=;
 b=c/Qlr2nuI843CwcPiwIxjl41DUOWGv8ORT/xrzVkWOjjRknNIEaYZ4VptLVqUZgj1qiwnsOKf3JVtqu7WMg1L+Dv4TdkFfHiAR8gWI9PPczi0UQNbARAIaISdZ2vV1aJ5dTAu9tDEyoGAGDawlR2iBMvU6rzrXezRsffO3DWh7AGhP8AMeTDGs6df9sGK9m+u8gRF3otABTnHU2VkFzFrfYgAuHEOe7lBBgIjKYomEpfXR684Rp+3RM87fnnv3W+tNU/4eOeSuF1iE38/jdaGluTKVSl9OeIyUgEGrlocpP7cqhuDQtHxzLnc4k26PG3DM9Ea//CMY0xdbYq6l4fbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Og7zC0hlxIcKSmHoudrelrErJ7OLadRgPtXbBKnrPZE=;
 b=D+sggsKi3zd/s6AbNzrRd3c71OoelWNnMf2cbrqg81z1Jj03YEkbHUAUkHCf/9wq2lIo1IDwbBG0vZXc5YYXO6wz0D2qpf8Ob20WlMnzqSY6R6xV+DWsehicXX+02LE9tkV1ZCpz83bksv41Gz7aVlMnKOfZv4c8gYiQpmH+Rsk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB0821.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:122::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 01:48:29 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%9]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 01:48:29 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v4 3/4] Revert "netfilter: conntrack: add sctp DATA_SENT state"
Date:   Tue, 24 Jan 2023 02:47:20 +0100
Message-Id: <20230124014721.6058-4-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
References: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0116.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::15) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0821:EE_
X-MS-Office365-Filtering-Correlation-Id: fdb11082-b2cc-40b2-d111-08dafdad1797
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cenFqYwUg4dh3Bw3M2a5DzhP868SF36i8xR8ZvrTWiQURO49UTU6aMfWQhu6c0Kf3swNpqV0CHYCEx5VgRywsoP28MDzbmL3TEwY+iRcDVYVABwPJ6tAjlUVCQXbTC/lWXuuILivwEgtsgtXDl0zJbHQFC010cuxOMSPPwJhUZ+pd/2PqD8KQny7nfoXcao5WMGmddUsT1+Uw06aJC1RzeV/BqgXKsSshYyB9Xfs2za3A9hoYmhQBvcCcFpdnayI/NYRt1VNtxxuM84wLC5AmgCQWdc9YVVI7cDCzdBSxv71NqvKKWt/2GJ+9owHlt755ncYDstTZ1Gp+hsxytYcIv+Ev9Ho6EpU018pDNDhdFAnSzMmJ/QphgDlUJSGAwHa89i0IxL62qP3vJNxpNFFAZdD4NCT0/M1Z0Im71CHKgPmeuXnCiWFTj33ybFv+9pYiAMbCI3KtV/tyI+Qmi0kSh2U/L+C7d2zmLYd7cXICopWmk6vSZpKjcALSk42n5hBprqRasRRQDplA9aVH3CrxT+QyY9/pDeHVqsQojIR60QB3vVA9FOngrp1ilfKvwPwWrTuGcVy5GUp1IOb1Rhlte07vuziv6TMlrwoqnMas81gfuTzrCcQliHQTb5BGryYehJDSTCf+f3JUqP+cOJGa/aGVX0YaoZSNxh3Ia6fg3B57jOqbUzbBDcTzkIsAB4zn6vGQXbOu6BvLTByFHX6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39830400003)(396003)(376002)(451199015)(6506007)(1076003)(38100700002)(86362001)(54906003)(478600001)(6486002)(316002)(36756003)(44832011)(83380400001)(66946007)(2616005)(26005)(186003)(6666004)(6512007)(2906002)(5660300002)(8676002)(30864003)(66556008)(6916009)(66476007)(41300700001)(4326008)(70586007)(8936002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yQl1tAKoAFf+I1p5ymXp/aKP03WXhGO3f/Lf+jQP78rQaUhU9qPmlrOJzQSb?=
 =?us-ascii?Q?TfFmU1TYceSSt971Xa6F8z+reA/v9RRziryCOBXuT3iO4/yyiYvyzi4UTAw6?=
 =?us-ascii?Q?wKYbDDE03j2hnmdlm+3e7C0nkRlIYbgI/CzWRxI3/rKmkqDFlyuqMHPLJ+FF?=
 =?us-ascii?Q?vv0xQHx70OaIi+189e8cn+OKLikVezMVFJIpRexh9oY0bOycMUk/R/YdHOKk?=
 =?us-ascii?Q?cvplj4FyjwM1DsX76GygcVdV4tP57B41LN6SziZXQzxVYdOvDQNpTqj+8LfD?=
 =?us-ascii?Q?o8mmPJzh4nK+IENpOWW+l+VboTD6NWYlo1/stctsD8uW7igkliLyBfHsfqWD?=
 =?us-ascii?Q?HwJj/S/O4GWi4+SSPFVecICbhsCQYygKXxqM/ufr+rgJK6iSbpHlalJYORxh?=
 =?us-ascii?Q?UrxSaLhJySGheMlVWaXJCIYwHls8O/+ex0Pyiy7XKitJAU3hFwl2djEY8jn8?=
 =?us-ascii?Q?DM322Bt511S2uMWD0q1doGKKFet+p0Hn7cMIEX2RWVHQVTyY/YY4CSi4NewD?=
 =?us-ascii?Q?dB9vji7xKOw5JJVgeYwCOXfuJT5YoyEHR9AtGDxuRL0FnsgZLbetUo6tMobD?=
 =?us-ascii?Q?v/O6yeUMUBuzuEjyBBDGcHxYxBxTNAhwVRbvfjw83PcuSn9mcRu5rC1uMbKd?=
 =?us-ascii?Q?0jWCpyXt7+W3C43TyAGtY2qAIJ4tTouTSjRIk9wQeibAMCtaxW44mqtC+GXj?=
 =?us-ascii?Q?zE3y6XVHF/jMsFfZWG1vbASL5dN+xVKp7mj633rLB6hcJfwPVJc2pb1RwwIl?=
 =?us-ascii?Q?KMRSv/J+Zt/W/U6jBSUk22lkg9KDivwpMOCkUk38nXEJF4ifOnLKcMCeAmRM?=
 =?us-ascii?Q?ch0e+1SeJJNItqR3fwVbl+O/Ub24Tz43gWzGTL1rziskV4vVtj1oP/1fXdaq?=
 =?us-ascii?Q?+sSilpCW2cfBFey4KqQpQrpOHUOUm27qBmjtYjLoFxcHFhRaehuyhnRotnLA?=
 =?us-ascii?Q?6/P2AGfYrABnKCZBxruswBc8O53jQ4OaH05HNZNT8wy3ywB/x8zpHk8CS0O9?=
 =?us-ascii?Q?h3RvHZpMQRJAhSS1lapxV3maV/0uVZ7MK/5eZKsd9UChUC9d0f9HRgwupKNV?=
 =?us-ascii?Q?Bw1Q6lOEkYocWDO1LQWbR9eFlTzgpvcalb3zWQQehw4TBShEuwzg7xhb46Uv?=
 =?us-ascii?Q?/K3DjuQP2So9MCeh2cvELCkXAYH6hdcW0iRbdChJp+vfPjZ0OYlock1eKkEW?=
 =?us-ascii?Q?qOiKo/ATWl5br2C6N1qneyUarovaEpcJmEuM5G+bMT0z6Ce7VL6V2DCPKWPY?=
 =?us-ascii?Q?lxSokvLNMe/gO6Q24p5UQKwhljqMAH/etFA9rYvwTV8hQlNBEGkPQWznZjDX?=
 =?us-ascii?Q?W+MBi/7j9d08PDZt89IlqVi9O/Rc50ZWC21dgM1HjfY0W7hK3E32K3e5e/st?=
 =?us-ascii?Q?TXjKVY+RqAjbu64xJIleSRiZWnSoclyY+xmYNnSnJRyl53BDU1diK6AY6BlV?=
 =?us-ascii?Q?fXm6mPRQ5nZRqI7AB+zFUeQULELcrDSn7/i5i+zrvKHbCsHXBKB3yyxuvtgh?=
 =?us-ascii?Q?Y4PetaThRUKE1FN5OLxZeZaVULAid4Hm7Kx8LzWdOTkI6kEnuuHcwFb8Td8/?=
 =?us-ascii?Q?UekjfaXXG0VRDXwbHbBLdMYuaCbZMCK3QrEkMHU7Sq7XJAlNTR6bfmVTWkry?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: fdb11082-b2cc-40b2-d111-08dafdad1797
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:48:29.4435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QACXqWDx6W/2cP3vDMzA9G0j2C49nBXQ6V5MgPm5cZPCWP+Mvk9Gh+SuJm34emy8M1BpC8iLMgohnuav642LQVLyMO3PGWhikb//lH+22zw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0821
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
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   1 -
 .../linux/netfilter/nfnetlink_cttimeout.h     |   1 -
 net/netfilter/nf_conntrack_proto_sctp.c       | 102 ++++++++----------
 net/netfilter/nf_conntrack_standalone.c       |   8 --
 4 files changed, 42 insertions(+), 70 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index c742469afe21..edc6ddab0de6 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -16,7 +16,6 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_ACKED,
-	SCTP_CONNTRACK_DATA_SENT,
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 94e74034706d..6b20fb22717b 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -95,7 +95,6 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	CTA_TIMEOUT_SCTP_DATA_SENT,
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

