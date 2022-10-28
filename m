Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF1DC38A02
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 20:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJ1Uwn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 16:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJ1Uwm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 16:52:42 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150121.outbound.protection.outlook.com [40.107.15.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CAF247E0A
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 13:52:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsqP/QUN5w9SQCIW8sFcHt8828yM3/Yc5fM8H7vjn3J3uCJH6iYlu2NDizh4IzZ/j9RiKsy2qEQtejT0FzdfYiNqPhYgkm4EYRsNAPBQ4YktyJV5jkicnoqdhn/wepoXZDNf0T7MHnQSJ9HUhZZYqflRqKCaRDbLs5DZkxTu97QQypMsTXPUbgIuEi2Dlj1o/1w32uetQJtcS4AgzlVmUV9NB6+NroCAbkUnxKw4nUB+MeGFUYwzAPIcLTY9CzutHV2LdpJLdPI94KmHWEuZeEl+Twds77uPV9Moswr/N8JC9Pe9pmYxN8ibLE+p0YxcbWZIPdJqPNqR0u7RXJnlYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EYkFLe54JVkRAaqHwIwR6MRxlyiQXnwMaaH4OuXieA=;
 b=dMMroDlipEPW19X6E4+k6UVFRvmOl4fXGevCiX2gbAExE0kaCwyiP7K504hqr/70ph9Zpt1qadvh5M21hw5PAeezEemSStQgVupmg3kiSvfTzPr4u1UeeLk54m3aYUGfOFZDgZI+DSrj5ZagFRIxFNWYoXMpsN1/eiwcWsChQbBWUMcOlH+bMKAfokmEkGCN23eWdogboaXJt51NkVbl8d2hgbNC8tqYvF2nIu1963/ufdASHd/yjCWQvWqtB4hCaJK8qH2JNwQOVQZqXB4BRwJxWpAvHztb9s+DnmmZjojn4vf57qxablhsX8KdeyF1LnYfppeXHyGMUC7tWEnlVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EYkFLe54JVkRAaqHwIwR6MRxlyiQXnwMaaH4OuXieA=;
 b=IExRP3A0XkWKgJOidk3itPLkc7JDL2wZKkJx7GFmh35ifP8Av5UccJtojYJa1MZLaMAJX3XSay9vh4ZR1uad0a+JJPl6MjSlX5VbhkP0qEO27qfeROKbd+sru0dAgV9pcOdqD5snMc8HX9bxfJ7ZUvrNkWsfHVdPgB5kOHlgjb0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P189MB2563.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:1c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 20:52:38 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::86af:ff77:340b:3faa]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::86af:ff77:340b:3faa%9]) with mapi id 15.20.5746.029; Fri, 28 Oct 2022
 20:52:38 +0000
From:   sriram.yagnaraman@est.tech
To:     netfilter-devel@vger.kernel.org
Cc:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 2/2] netfilter: nf_ct_sctp: add DATA_SENT conntrack state
Date:   Fri, 28 Oct 2022 22:52:25 +0200
Message-Id: <20221028205225.10189-3-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028205225.10189-1-sriram.yagnaraman@est.tech>
References: <20221028205225.10189-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PA7P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2df::8) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P189MB2563:EE_
X-MS-Office365-Filtering-Correlation-Id: b05c03f2-13ef-4924-2421-08dab9265924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3n+rqWN9u6YJr7BL783NPu2BgxNYOB9YLhZ+kb1H+L5yDRBE9DiyZRgNol9i+Cbv2mNLy84pAbPQwhmYXfDN0A9ZA9AX62tZxAysvqzAs+xvLXNSitA5sJ8VzoGVYcXJCgNMkH+UEirpy/kg8ZpMIjgZMdmlD3N52d2sgLjogXpNqxx5MWYqbEp1+AnmUzO68BoRRQxiecasbNfXU32NmK9QQaX62CKshQ6AfaD+1YFD0FT9QDwxmap5rbsxnHXU72Og4ppFy8fLO79cl4ID4b1HOYwaiXHHL8JeAbe1mQxctS+lTtmirJ6Mm0RYnsPvOXk/O5NOtMskdLpKJmblrt+T/5pBooKeA2MqTYmmfjR9Yc97OtkRmu8P2pOwkA7eObvK7B0CEB8ZTS6ZIOVnV2aXbBGXeyqVCI+V5LTIHCpdCFcAe6T9Cxgmcd+Q2Josc4hF7qLBuvytvxC49+hcYrjop5krxwYe2SOpn0lwAGUZvlROXm85xbpuW4GvVUDyFUrNiJ19lXuxPIpGxI47byIWIhlQSuWS3JYdhd/z5JgsF8sUb7V4rXvq66581fflymnZDleRnYerwjeEVARe05p++zsx+nUCqptCXFZ2ZdlBZN1CMsSvL3Gv+xNcp+uSYoLlZpYdjD3GJDYuqjVCjLE2SHarHA07+5KPeVFL+K4d3LB8CaR/haw67XLEMn+NGGNmuFUGDAjD/NvKx1Zc1XwE/VqPO6ph5YQhrCI3hU/fLXt7Y10sgFJUCIup9DVA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(346002)(136003)(376002)(451199015)(86362001)(38100700002)(1076003)(186003)(2616005)(6666004)(6506007)(5660300002)(30864003)(36756003)(2906002)(70586007)(8676002)(8936002)(83380400001)(66946007)(66476007)(66556008)(4326008)(316002)(478600001)(6916009)(6512007)(9686003)(26005)(41300700001)(6486002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rp1QcAHsldGq43+NTgJ+s35ixUMZ48pyHjUiwLr4mbsBSzV+JOvsFqDdxasl?=
 =?us-ascii?Q?8DNQbL2fvDrgr/WrTDWET2eYUuVnyTER461ZLexrxiD2xp3oHGreliSB4WBX?=
 =?us-ascii?Q?UVt5MDXD+VvNEMf8W5BGN/wqF6vOhUQ2Dv5YmnpiVauOf1bb1vbU2gV+oGE7?=
 =?us-ascii?Q?dWrtwnMBXIHmkh73J94NjRzHXU+0lBVFVccWswFK/vXRY4GaM8Jn6zADgvFe?=
 =?us-ascii?Q?LbXPdQXRo56s0rlC2M6B9T7BxjzeAkwmHhRjaZ4GMa2NWGeNB/zHaP8IF+GA?=
 =?us-ascii?Q?uS49ft0Y2psg7ekwbbvMU29mjzkr4sUYCTl5nDNfn3R0frsLN/1SgDRFYl88?=
 =?us-ascii?Q?z2aq4HlnslHlyLoK+bBztg4UH/AAdOirV2HCvenv3bLAJBQvKGmZ4zAz+75W?=
 =?us-ascii?Q?SiQZylC8Jsb+td9Z505tQORsdIECDV6+vpt2vhywPR4/Iqr8HN7OfT12DRSX?=
 =?us-ascii?Q?wWMkvTrbahnIyLuOsEdM6XodUxIus4cue6abVIwPct2hkuNa3dy2va4Fx5Ba?=
 =?us-ascii?Q?dDXVYaV1FIs7/eQcinKFhkFZjGKwsLOgqLoKjS1Zm6kiLUGVoZs+Hhxue4ve?=
 =?us-ascii?Q?CUXNXvskOwOS21Dyh7b78GUJ29G8oAs2VNerS6SiIqfR7LyCIuGyjBQ6809f?=
 =?us-ascii?Q?4yeZSipCcjjYgrf4Xu0mOwy4+SIBe8P/+a29awbZoEtGPB1yF4ciC2g/wlLQ?=
 =?us-ascii?Q?aZUTfmCxrrLL9BBpqiEKvIhbWfDkUNk9e2DfTYr5kMJ3HY93x30kplZSht8I?=
 =?us-ascii?Q?+WrfWZayzYsso7vBBQJzPYpoAeWCHTxVHvbAHx2QB/W/r4RlBYxhv5koxdcC?=
 =?us-ascii?Q?z37lsezr31UEVqT16DdqivYA55u4Q245x9acv7TZnEdfJ1fIjlPzXw7Oin72?=
 =?us-ascii?Q?WN2B9xJnnfUdVC1iMrIbfhE4IBLShZwDS2fuhWjNiSVjsH3QJP2SlvZZQtTc?=
 =?us-ascii?Q?EZzix+6tyT0bSnBbqrAjmDIxb35EO5gqOIhiMKQ194R/GI1OcE5jofP6SRfq?=
 =?us-ascii?Q?qR1H97bkdZcumV/CpeAXt74VI1YiUz+YwpGAUKudA7k/Rb1m75MKLy5J5CrF?=
 =?us-ascii?Q?FFYrsZ3LyIQMKZp65Y3o9L9hecp9oKocZdpEHle4zioIV5py7chs8NqQMTrm?=
 =?us-ascii?Q?FOvIH6VpNBfFKuqkDAdLSMPKq9klqxT4LCq9KQ24pSuXbchx/bfnhdH1A7PA?=
 =?us-ascii?Q?/ltY5PIlKhAju1ZPWZwwfXk1H0Ja3wZsc1xqxIz94uW49cdYfFIsCAiAtu4G?=
 =?us-ascii?Q?8SRVQizA9iJgSQFVLxWMwroBSeq80xmrYsXhyK/Tgfsz2mVYUUUkK3yJ9Wwr?=
 =?us-ascii?Q?5L+yOFL11CgWYkILR7jvGh+4sOY7NLxTGTgWEzYT77X8G+dZ2ew/HlyIFMib?=
 =?us-ascii?Q?xOpIcPqKSQqNYMoM04vw3Q0PwmCg0NSx1eKb6pNl5zZ5XQx1sfv+nQVG0HhU?=
 =?us-ascii?Q?MSiKw2zlZ3Q1cnMV5U/30/iqIN1KvbO3ppjvYkqojyqtalYYqOJBaEoE8pL0?=
 =?us-ascii?Q?43o1pzJBSmY1tl72MKseQ2xgHffJcuCAbuaI+bMhwgKdJCX6XGRhJ1NU7yRj?=
 =?us-ascii?Q?bRtXs/CWcuCodeFatjOzhYRJBS82oPOBJvVft66+GjBOhqq3eNfvFsycmEEO?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: b05c03f2-13ef-4924-2421-08dab9265924
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 20:52:38.3549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JTRBLPfdBn8cm4ZTZ8VB4r8LiiEmcW9wRs3pOBq7m6ehUbOo5gAnYyyH+KFfMjvqNlYnVD/RQC3wgmFoUyKkKIcpCUsLuDshwtfCt82gOCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P189MB2563
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

