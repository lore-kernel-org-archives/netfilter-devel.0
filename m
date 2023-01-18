Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD77C38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjARMU4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjARMTG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:19:06 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2129.outbound.protection.outlook.com [40.107.103.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC3F5898B
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:42:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhRaBkaELV1qRUcJs2qEcZsl4Fwi/zFY+FTTunHSTABMteUMmYJwxG3xyADOm3ANMtVIMZxeceCR8KzsvE85iWqyWL1U+DxlaVXzO6Qp3cTbyRVYfF5I2h+0s8EENj1xCKEox8XWUJZt4wTB9/FbiE2qPY/4koBO47dSPxN6aMPY/ZqWYKlo54E7DfcPTLy/zBsH8cda57q4UonNiEgtOVlJPKYC5VlFhg3u5zOh1wfjEHYl2cE8PIUxwutRYwDNxh6xwz3s/Q4XidNczuHakRf+PLo47O4xjbB4Zsz2Hzq693XjEN+I606lWOFWW28KYuPLXuBBK05lI0AYPZcplQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tz26JB5QK7VuZPFzWcPpBTFz1tKomdIStf8FJgN8dxE=;
 b=fsuolfdaEaYC7zbY/C5PT9LRfmdqvSjjtSBywCDDnsr6Sm4LXKTDYAF8c61S7qfCoQDx8rtRj5RTLcSG16D1yQKE1bbFxu4bmJ4howzsIN4afGDVJFDunzo4JC8x6IjEsYUtspXZFxtOPzeK2fSrrHrasgLjHWP+wdo7N6Gt1AbG/eg2KPfTqHeqn31HyKv24I9uhCXBFPp6Q9wN4oYRwfObU63htvmlChnLziuCNWaYhbdWo1vkbxRGFT3tscKura4tugMbCzfuetd7MxwP+yBYghyM5G5XltiMILsd21KYTAaI20p5zSi9G/A74xv796TIG4pEH/avqvepLPyETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tz26JB5QK7VuZPFzWcPpBTFz1tKomdIStf8FJgN8dxE=;
 b=B2kXnnqQvt6GJbenIPiVfxgCnJmWaFgpTOEGFvPphJcWBGv8r2C5TwgOKWHRRT7J/oQsW51xC7QhMscr4zxQ2P9BcYTEuyminSR0gyarP5VApHmOetfDo7OaT5tSg0NJW8Q9h75TjGxFA78u8NReIxM575DJsuSPPV14c5HGuEE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM0P189MB0643.EURP189.PROD.OUTLOOK.COM (2603:10a6:208:19f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:42:00 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:42:00 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v3 4/4] netfilter: conntrack: unify established states for SCTP paths
Date:   Wed, 18 Jan 2023 12:38:53 +0100
Message-Id: <20230118113853.8067-5-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
References: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0063.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::27) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM0P189MB0643:EE_
X-MS-Office365-Filtering-Correlation-Id: bfaf1315-2112-4a74-d690-08daf94902eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjJXhtpB4Gtpejera97WTLRQSkCb+vysozBaeCNXLTchn00Th4AYFoZMPSHAXhSY9BqcqUAu8vJKSMRk2bJOb4yIwdZotAFUa97TtXL9tcPSZ4vllg8urTRrdG0mwAnYEbDJVO5/ce/tAJdnnPzo716Ga7CYJZWxp/PZqodTGDxGNx9SzWh4p9RKdSzAQ7/Esf9oBNs292Y3sJhEIKxh4ZgFHX5zmNdt+ZhIE5vFJ/BWhmZLw7GyBnejbXgWZ7jDzh0PhZLTxiFnjg8gNjRKyHP2MS7v3NxhrrAVDEX4EKm9Z+5EAk6bPNhOMHJhgzQAzoPgcwFoK4ozGWvrSU0hD9hlSrLxkSVDkH8491WGKMQp9p2x2kc9x12pAdIJnqtaJ32q+7cd+dncWEJcBZ9TEYkfpP2Lzbh57sRHQ94tu3zBSBWOWTU9ytmZoZ4P+pz7a2YWWRUCjFJrcTdSAzFWSem+qV7n23BZzYuwbImyWv0w7gRuQXpIpxliZpS18GV/SzfYRm2xQJ08eD0XU6yCwN6WDDpsJMgvvoXjlbJcCvgmT8eL8ImOtSn7VRdSNEoQTviKZMuUXeN/vLjI2Vmtt+eotbV34t0xSUyrmLA4II0Bc6nO38rjelK/53W6vN0Tm4lF/HPCbQP8JSdMN3QY1C3UCLfno8eRdBL05+MaFDhzkg6pZhkicc7PQSl6RQXMNI0Et2TeVMVQzm/eqoVdeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(136003)(346002)(376002)(451199015)(66476007)(66946007)(26005)(6512007)(478600001)(186003)(8936002)(41300700001)(83380400001)(86362001)(44832011)(8676002)(4326008)(30864003)(6486002)(36756003)(70586007)(5660300002)(66556008)(38100700002)(316002)(6506007)(2906002)(2616005)(6916009)(1076003)(54906003)(6666004)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b/hCtvm12Is5BeuQ2Tt9E+97vAR8Am89aWoqmK4Yf7yo3iSqLpylfwgF0Bv7?=
 =?us-ascii?Q?J5Hrh3kYPgQ1ux7Dx+BFlNEj4fQIBLWPMKQOF0BVqAHyCQa79lbrnNGOISi4?=
 =?us-ascii?Q?ROR8rgkGG72HfmMfx2U8Q5Y/Uoe6kHfu+y3Ao9etYqEDi42RtuTVyGsXxj6p?=
 =?us-ascii?Q?G1QSHDtU40zo4Oe/UedI8CuepAgQ2CQtFaJ/oo8RHegM/fhnTNAKyZbtaeyQ?=
 =?us-ascii?Q?DFid1/YblM/ySaIQI9GruJuFZPZn9gykFYdh2r+yOoQIlZFWqqGjq2KWzwEJ?=
 =?us-ascii?Q?CqhCJIvMTTMu3LfOJ2VinfiJPZAM/gNndRS+RC0w+dvv+J9sTEcXvokM2MQU?=
 =?us-ascii?Q?Mc4p49pGAg11WJQdfWapbTQOWWJCTXBq/Pqx3uURYVOmpelnCaha47vXKsai?=
 =?us-ascii?Q?lTiilFV4pKnGfRrFTlg4ytW5MwLR6oDFbf9EYgWakVz1remkg9kC2LEltKUu?=
 =?us-ascii?Q?egl7LeFte+PIYJnxTi0FhZNhh4lxXwLJJJf5EJf1PYLjbosEhTbkOyJ3Hno3?=
 =?us-ascii?Q?q/8AqWB/ggRBM6dr2qecXKTzPxfTz/TjNU+Q95c90DoVD+JVo4VZprWEYRNh?=
 =?us-ascii?Q?nyfpKlgUEZGKD51G8YdkMRLGP93DVgt+B7OfeTGGgNwODzMEM9Z7SBDxkX1m?=
 =?us-ascii?Q?JHc5fL8S19c5HsYQGeAbBg45JvEW8bBEweK/pXnie7SZtkppusUlPkO3yv9N?=
 =?us-ascii?Q?qluxEEbBLLRvIgxCdT8ShtoQ534WtUJMxGqGj68Ck2sGYoqxkdAJAb35Hxd1?=
 =?us-ascii?Q?269MN/zkeXA6c3WCg8mVfzbzeSgZCBPBFLNc+uw3iBbb5dsE8Mkjo7XdX+bJ?=
 =?us-ascii?Q?AnJe5DW63gi3CiVw9LUF2YakP4rQ+BDJJXqULxqxc9+iRaa6GoMxiZASEXoH?=
 =?us-ascii?Q?unFqKMc/T4Zf7BrbyDnidBFbyKWIKH/bf16KF6XUATN9iNMqh0Gl75OyNUa7?=
 =?us-ascii?Q?09fZfZZZjWq7Q6rvdgp1261AumcniEQwcuuQ2UTGvXVWPer9D+IkLPow0B2z?=
 =?us-ascii?Q?cfgTCpW/UQMb98cYs0FrJsjbgcmdKCXhm8NUGflde1INNfAH9uHU+Zt/rRtw?=
 =?us-ascii?Q?eb5N4AfDgl6wa+Njgwe9XVOLJ17Ty+EQA5679VvKenQ87zEo2pvjYfPuG/fK?=
 =?us-ascii?Q?uGCnZPLI7KO3PouHqkkHQFXrhTMN8RXJB93tF5vUVIrSkLGC5t5tjLLHGyLb?=
 =?us-ascii?Q?WA22oRvzBOi+02c1la2WgRJ+q92Lc6tla0NUGU8vCcF2zmbBnX7gkbgyVm9B?=
 =?us-ascii?Q?V5I8CkoTp1caLigVSPqCVzQrIKD/eHXtuhuQlMwPhiiGFGHXrJSl1PNbJqlk?=
 =?us-ascii?Q?W8n/Y+ROKX6Eu+cLdtghu6QKiklgUPA2Yyc0SwDUj8V+n0Snl9fBFblfB1VI?=
 =?us-ascii?Q?Azx+gNOfC2grBK4IK/6y6W3Zyzy/vBteMgzCtx1C4A1Z5sT4NjsUncvEYKE6?=
 =?us-ascii?Q?5bMccU0HLSmun0/denL4uEDfgF9Z5PKjNHsy7msx3tT3xY48OfCTa67QFq3m?=
 =?us-ascii?Q?RtD9O4GKH7j5SzXNHgw0nx32X0TZfewwg2yjTm6cGbKCScOGg6c+i3CFVuJc?=
 =?us-ascii?Q?NSZa1sRqzuHnVW5ZGF3G/N8wN2Mha3DXkHaGL5OaP10f/3ApZd+jILIUYDDk?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: bfaf1315-2112-4a74-d690-08daf94902eb
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:42:00.4379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmftUQDH5USouAlK5lIznZiCrJZdHERPAbE3SxuHxI/LJ1qg77+x1XruNWQx9lf42jM31Q+ZAAU14oSZW3uJejzzLs8z2D0nmTr8rsvwp1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P189MB0643
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
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  2 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |  2 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 82 ++++++++-----------
 net/netfilter/nf_conntrack_standalone.c       |  8 --
 5 files changed, 40 insertions(+), 64 deletions(-)

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

