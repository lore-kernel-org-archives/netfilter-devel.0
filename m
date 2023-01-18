Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06B6C38159
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjARMRI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjARMQ1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:16:27 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2100.outbound.protection.outlook.com [40.107.8.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199D210A8F
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:39:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alpEtNhPUVnoHf+kCg/kUG2krFU+4GSmtXnYgCq62lLF9OJtM2sHZ2dvPXLZhxQMGScEBOxqGbzSEpn9oBgnvhvG7h9raGtDo3yWNg82AyiKSBUNPRK5CSKANRq3iTwiuYLEg+qH70rMDCacDeXkeUT1WDpY5jyZWAHSOOXTyxeAdfMOk/FxKkZiI8XxDCyz6UsFIzpxgeOt2xytECl92HaxqSPiYu6ytSGlmr2gcs/N1ufAjbV2eH2kueELzmq4z1HM3KQdt8osufKwYuDjE/wHHh3PMGlgVivK06GY7iwTpePmBogJ/xPql+JJOVvTFcMv0bIx4hWQNj0OPySx2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Og7zC0hlxIcKSmHoudrelrErJ7OLadRgPtXbBKnrPZE=;
 b=EElWE8JtFPjTIEbCsXMH7ffErBfuyn5yJQ8EhFz8QFrK9VUvf72hj/cjcQfJDcNxBtoK45aEV/+9wOiplKINgcuLg46w+0dRXN1ixjq4iQRvenlzmSCIDhw1aDNk8VAMjdqLoFv6XbwO5YDVCKmV/3axOnvpxXnX+g0p5a0c1YYXjRav3F2ap0rdh0fGiMpI6d5Yp0MpXPiMZEkt3hy827ZiuD/CnExYDv6+rOxXa3w0jHGwMM3ZJ26+e1I5xZ8bJlKpeC5MuThFkGAXSG5X6zBNiB6cy+1SsSpf9rcvKOM2J61YJ6yeqrTMZU6HXET30v5vNT0T8a6R2xQe3O3Vcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Og7zC0hlxIcKSmHoudrelrErJ7OLadRgPtXbBKnrPZE=;
 b=TTs7P+bCZGQ09+yakm7uwVFVSMCm1gcWPxy+vvn+vRvM6QxQN9I9qHVqvZQgNwoJY4vz6Bxlii23XWyuiyoJxLwVJp2Prh/2J9F6Z/Ni9HLAve0E0bpDPdpw2FKssaTIQCzwjNIvly562PBVx3qpmmYBXW/Y7k48518tu5TcR6Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DU0P189MB1867.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:347::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Wed, 18 Jan
 2023 11:39:04 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:39:04 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v3 3/4] Revert "netfilter: conntrack: add sctp DATA_SENT state"
Date:   Wed, 18 Jan 2023 12:38:52 +0100
Message-Id: <20230118113853.8067-4-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
References: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0050.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::13) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DU0P189MB1867:EE_
X-MS-Office365-Filtering-Correlation-Id: d6ec5a82-84b9-4069-e025-08daf94899b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 99gdVhk6zad9vSRKmMVLXOyWCG6DXTVMl+BWxO+jBt1lrissUksattebWRCGk7xJ1ROxJkqA4HuVFktpo1oVELC471h1r4bBlhpc5UDkutsw4kyYyfLCQ+3xhmRcoBUSDAPSNN1rYK0U0HOQqv7HlQ1MBFtAYRizA8xiuyPC3GqL3566d7jkmkNbdNY9dMd6SzZ4o1TwB2gKeuqJOyUStSdpLxdpWG40Iu4kw20ZjgchgoEcTmsvoXEbMJlwd4uh6Q3NkZIBAh4dDlysbJiOjcIequIPU32oNIaaqwn9ahFAlGQKKsd5Qym3mRu5zuAJ7HjfTkSgw0GqPFz9xVfVMdPt4orif6J/4mGG+/2ktvHTk76J3Mr3OPqHV+nkPhH7VHmu6CcSW8OfyMBrxN1xxgkVv4Yhf3nlbrCY140yD9xay6v/p4+AdJWcaPFL+UoI2aOB6ItzOZRX3KTwlemCyGHty2iYL60GyjY1cQRd8iPY/t1x4EfN2S5WH/sGB4DP5kaVOR4kxEwT+2gS6+FS1OgqHaXL9Q/0VLuQVuB5RJjhjuREsquKtavHfWjMUVHBEbN530j0JwC0dLAShvbbRcpPX4WSZStHtg1/PFTRcKZQPqMxmEiD9VGI/qCifUE0yZLYm4E/AF0yfdShozIZko41BgcZarPyHwFbQ2opt47yPnAgo8ohLcZ7tX86ca4vuaLiP2hQybAQPtuHb5JciA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39840400004)(346002)(451199015)(1076003)(8936002)(36756003)(38100700002)(2616005)(5660300002)(30864003)(6506007)(66946007)(186003)(6666004)(86362001)(54906003)(6916009)(316002)(6512007)(8676002)(66476007)(70586007)(478600001)(41300700001)(4326008)(26005)(6486002)(66556008)(44832011)(2906002)(83380400001)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iWWv31hFUxHsh9NuvbzcpLiJZ/4kEZhes7iGYTpFFwcbTGb0ac/ujkikNmKi?=
 =?us-ascii?Q?hYYob0b6zBsWUwciVkbawu7e+Bm3my6BWfg4WAq3vmArFLOuk2OgIO6/mpyM?=
 =?us-ascii?Q?XBwBg8OcGsgbnNh14R+cgbSF9TujIyuTa2DkZR22C87+FQLwsOhVQ1o14bIN?=
 =?us-ascii?Q?tcl+X7MIYdGukoqm1XBPE4ziHx/3RatboUF9LaJsAPe1iojk9Ua1qvXqln8H?=
 =?us-ascii?Q?zNDkHwqBZm3VptxgUiw2McOAIDppxQwxICDckPUD/fFtmFsb2lYW9+X1NMYG?=
 =?us-ascii?Q?lffrrGZcypwVjy5bR2FcDHPFSrloj3IoY7rSGgjxp165HWikb9H7TpG2faI2?=
 =?us-ascii?Q?QasYqWP+AfWcA/0rfzAJJiCyXfZY1oIMm8UGPvlwwcMS3+2f83k4FciLuIbI?=
 =?us-ascii?Q?jj0MoP+3bVZtuGMVUxvL4R9i36PH2V782uqVF5TzcAsiuvmpCs9lor5560X4?=
 =?us-ascii?Q?2TSVfwlMxDltomVkGDKN5bcltgg1lAORomPVQUP8geRrYS8YzKHL0r3Szt0S?=
 =?us-ascii?Q?Wa4Ua3LFX8IKk6lK0DaU7y69+3tBhYITt6C0mbBlPBnNYUINbVA9DNYG0RZU?=
 =?us-ascii?Q?mWPjN/Tzi26PQ5qIiP9NNJ3mTrgQIIOp2SNba4PSlJuDG6bakNiysw55dYBk?=
 =?us-ascii?Q?kc3c9Mynll18S2vPo3TWNlXWW/1TQlVvo2kpcf+FlPAdML+/mIQLHzYR3cii?=
 =?us-ascii?Q?RLfAdD3qSQV9/PM0It2sl2me9YNeieWQPMFK3Bf1l0KmidAHIXr8vMClFPjq?=
 =?us-ascii?Q?h80wZ7r3GCoO03hxiCc6J1QyOSBxzadvjWkvsOUOtc7oKylFhYnBreLAJB2H?=
 =?us-ascii?Q?F4Y9k8iRPxUkzpcIfVdBlkYmIwkG+x6t/nHhjZyXwJUYCXM2jYeAiDvjsG4R?=
 =?us-ascii?Q?xpojTU07ku/Les3zyMvfmU2z+OfzZAb8TmAlGt0wB8C9shiPnQnwGZ5Zkb1o?=
 =?us-ascii?Q?+Gjdb4V7VkSudmyxtuPoYv6SDfPemsx9OY1Jnjo2dtAPL7V9s2ifR617Rr0u?=
 =?us-ascii?Q?15lVOgYvQ/k7zc/YSWN1saaXYhVFAdglrcZMOdkgqCuX2cjClWSV4ZsG1OSZ?=
 =?us-ascii?Q?CEgdou/fe9tzs2sunzuXX8vkp/UQPEBpMUzvRfPs3GSJFW1CCxNeMek3iQQ8?=
 =?us-ascii?Q?DTinlM6uORX+w7cjaLdU0JCwxw1Hz2KiuDBpsOIIZ68Ih1gug9c7QJp79Kxc?=
 =?us-ascii?Q?uYH2astelN9wJG5OKPbZ3FUkjw4mOJeClyAjYBoJCDzZLL4XyQ+68V/WBDpC?=
 =?us-ascii?Q?NWdafFntgqoairql7OD/gQJaxzBx4okg7K1+VXPILxVraVJyfhU0AsZJds4v?=
 =?us-ascii?Q?lC60GAVZyQWdax5VNisI7+4biD4Vo96qI8HPztiVABW4bSae5TaYtYmxvd/z?=
 =?us-ascii?Q?g+yeO5X7DMmRGzebVg8RI17TuUtUgRU/U2MdsCzA4W/jxRgPAMxc0xaR8uUB?=
 =?us-ascii?Q?vBSmKitqWoPyECzSTf9xqcHres3ezohSZls6C+t2+7jg3PtwgqhJ766PJe8h?=
 =?us-ascii?Q?zr0eS5SO09CcT/jVEzYH3joP1CwDRgQulfDNfFJ6VAoC3KcMdEVTqUe01Uzr?=
 =?us-ascii?Q?gAJV64TwErY6ZYnIfIBY6Q2zj59XzejutvZD1+ZruA9Arty8ojrCGil6OjCo?=
 =?us-ascii?Q?/w=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: d6ec5a82-84b9-4069-e025-08daf94899b4
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:39:03.9481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gEJv4xY6DATx5sXOuT2HevN2SDbNOlNrqm/79ZncPqbVrCZhyf6Y05p3S1jB+D2oOLQNExXQEynyo5BW5KwmcOEtA7tXIRCEmayARy36/kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB1867
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

