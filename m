Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E39FC63797
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 09:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjAPJgR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 04:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjAPJgQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 04:36:16 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8789116AFA
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 01:36:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgIOwK5JYf/4Ha6QKyaVfBukZYX54YM+mkdR92cs3jUh44MoA5LqjA68jRxdMylvUQ6CmSIz83qsrwR1npjWRifozD0eoLN4sjvv9c07gaSS0CIrIOn29bFB8oS9zkBDPDtJ1cdnEdLnAC8Q5vUb1H8O5c1pBHQR1k0gy77TTQosnUJCV5P3XmA05zL4fumksk9WwkxOiBh425288SECzy302rIv21hESsG2dy5VtgGQHLYn75ockr7YoSwpJ0zGuC9uc+uW0g6gMcptUFlXRGrz+7iWZQXDtpuDX0r6L4SoiUAdNmSD0kyl43tIU1hsJq0IFveAlQx4Afag5OthQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OCTQSzQzpDhgUTm61v1APDOJKLpL82xbhVr0KkJjbOc=;
 b=mrEgA7KsrR35GuSXFTfrgh3mp2goXZChHB6n1lMo3bPmvaKLlHVfwmh++YNVZ6XipNXav4sMV2MRSVwMAvgUrhQc8nMT/jMG9H4gIk5OpBf3CZSPcXTK/h7Xj2wJ9JpkrrfqOgfQ1SU1XmdfcUFbgghv3yAzES/oE0gisN+XJ7Blivhi3PtrFZ/rvnPY9skI2Hi44TQZ3U+9qtqVbX2QkMDXYQMjDCdl+9+jDJCpnWtcBd+9tg9e/DZLXdJi3vCtrVeTQMLHCxSru4gqIgE1RF0VU13CwuZadsQbsnupqVwp0rtHBRHqVLu4DF1wUzfZJr6iYdXLLsXRAOO/ae2+AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OCTQSzQzpDhgUTm61v1APDOJKLpL82xbhVr0KkJjbOc=;
 b=GGZ8RlkGQFa9Cor0HJHsQUQkbeym1+ZstcYgJsUMFhGk3o7h5scSSzjkQ7PZMfkc+M6sxg95g/O8+5sVueN07lJ42StjsvOPZ4NJLcScEUomCvp+BsvIfG+uFSOt8VdaCT+5nF5zfNTF+OICnith2qKdnsK4ef56XDWrYk6sSUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB1012.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 09:36:02 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 09:36:02 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 3/3] netfilter: conntrack: unify established states for SCTP paths
Date:   Mon, 16 Jan 2023 10:35:56 +0100
Message-Id: <20230116093556.9437-4-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
References: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0030.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::11) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB1012:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cf5062e-c559-4380-315a-08daf7a51514
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUu49gLM1maCfxTtxypMvXTFO2hy/pP8DNdwFZHiJKkZXp4Vlchx9D8dD9JWfMxFmAHp1SI/caohDGh8CLNorsC5KbeKkwvIfo98+Sj7acJAM3eo61o93/z9Mc9At0xlovrcAM2u36vqpg1oS15bgn1wume+vzp8w1B+j44fIyRBbg/Z59pqh9ZvdLHUOUAy9+br72BtrLxDMp/aXjR4sduDfTQIqmFkjB+KKGCCeEd3Bdz9dQMbwixLFiC6hgaVW0B+UHi0aDHC0Zg52Js8QuWr1KaNoiUlX4/05BBpNRYdLQCfZz2vyJX0oZgBmP4DocH4tcwzS8rUTRZyjMhnmutpfp9/kF2/XwVnMbyJUuMMjmwUtu6egzrCX0sDdQBycDt2+K6VLhAsPPNQ7lwD7KwVYifun6TUGmnIeVGRyDWiQ2RxjWrg3vWptlFRnm/5F/c42RPLwmzegmGAqJjKbTF2FJFXO7ErMwmGiZvBAE/jhCnHODHh5uejg3ACyOsPrtow8yYYE8mJ90ywNOrzEZyBAjCoXeV5/NvBgmHhlagoE+RxBxTr1JpPGgzs3doK+gFLzxmGHcCz0AkaqDRSRxCxUFuDHS179yv38YKUknFjTxwNakSDFMeggypNbHS4nKOGkRfN0PWrh3WJF83Wfud71HJdGi/gscHLhHkxAPMxY0GSI8pRv/SzNRwN6wOuSxct1MIzRWm7PvEtuQyGxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39830400003)(136003)(451199015)(6486002)(2906002)(83380400001)(478600001)(30864003)(86362001)(26005)(186003)(5660300002)(54906003)(6512007)(8936002)(36756003)(44832011)(38100700002)(1076003)(2616005)(6666004)(41300700001)(6506007)(4326008)(66946007)(70586007)(6916009)(66476007)(8676002)(66556008)(316002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wp8RXu8k2q2nzKdeQZf9T7CZtX406bjzB3YfYeuMSsnxaTQOQQFLI7RllmvF?=
 =?us-ascii?Q?ac9rlTdoug8KNtPNSTSFXtZmWJknXKxObpTdNq79FlARLvasraOOxfK7u17M?=
 =?us-ascii?Q?yKzr6rk74q3kQOsMISUwK4khVNfadUFt3VleJs+dlOmv+gNG2hJIznfcY7Ae?=
 =?us-ascii?Q?ArUf/amlpkKGIWXB9CyjvIq5xIVO0WG+BPDr81EaH5g2n6IBccMi3vYKCnSj?=
 =?us-ascii?Q?zsUJEqg5TJjWRas8XpAEuiVV9IUrZoFaTW9iG3ZnXixxTxrYbgQsPzCPS2qt?=
 =?us-ascii?Q?h+pP+HHWyRin8h4BTO1IGDDPlCLsSFDsYy2Bkyl141oWrJQevc4Q/Xf7aXRm?=
 =?us-ascii?Q?2t71uTvUoYJGExgKaOIshK1knD7F5Ye5cs+q7t0vLoO4c2EGd5Vx9CikPPqx?=
 =?us-ascii?Q?NgD30L26GzkdyzPcOIE3yTSZphShOBnw6fb/W6C8NJf83UchTns1uXoTQCEe?=
 =?us-ascii?Q?QxG8YUy5uQRU++cFr9fRypMCfXkuUk6Ckc2QayT7V2j6BYWshTFsUNylwJjp?=
 =?us-ascii?Q?sQBEvI0Pot6wB+r4swEdUsAXyZlgStpa7xbkrfG38P5TSIVxGXcYKelVm9ZX?=
 =?us-ascii?Q?nvA0mbTX4H/Ha6So2ELsIMlMPb4dMZh8LbT495em2YHZzEEAj17Xt1m8zJPP?=
 =?us-ascii?Q?7wz6buZlrupVlQkUcTAi4yKFRG7ezEjB/2OGBG9aJgDL2OVE6BIU21i4MbaM?=
 =?us-ascii?Q?B3FSnaKQ3jc63mSpQN2R+Fd8yCVzzy/AneQx8EFamvl+CqCcS6RqY/ngn4XW?=
 =?us-ascii?Q?6/aPRvd+rIdE0tVoLRP886eUJSCeRiknis1jXLuUUQIzQ9Mfk0rxIalmQerF?=
 =?us-ascii?Q?HI/yryiQVqRkCVBLt5ORfaxrIxtwzrIsxrhDANLqY0h1IT5t0TSMiPvfMogb?=
 =?us-ascii?Q?A3APBedUyLs1Ea6biDgQ5s7QfTfMagefGAXybZYtB/1syG9+bZDGEhbL1mAD?=
 =?us-ascii?Q?1jWv9Fo/KyyuSTDoMXdW4GJ9jJg7/79KhpKeQNKULuI87qllM3wf/MBoaRq1?=
 =?us-ascii?Q?XuOy5mhURWmkP0C1lKmA+XANb5zXSVCBRHdv9D/3zLky1MOwDwFwnBwx+RWZ?=
 =?us-ascii?Q?PNfMJc7GXiddBf5OnbsnLEk74pmnBrIoNukCRKyefaVivQDAUb3MtOYVEzyB?=
 =?us-ascii?Q?WlerU8+W8dtQYJKtKJj+KwsHnasugGyjy/IWwYfwQtbo58AfdI0OOl9i1/Mb?=
 =?us-ascii?Q?jHwENtffMi41FgyK09Gi77Du3zqAyOz4sGFZZ9XUlA7BKVUwM+iRZ9PW68ci?=
 =?us-ascii?Q?1JtLFikp7yR+HGBe2uUVRJizlSj1eK9QIkmTCKfgh7B+pwlDU9wx2HqsPcwQ?=
 =?us-ascii?Q?iTnZ3+54DeHZK/taTI5loli8sF+xYR3Wiosud7VnsXGOTI0B43PHzuGGCh7i?=
 =?us-ascii?Q?KbegB663jBJHxkFlHBqS9uV0KwfscfZ5lT75pjHkOVpvnkMm3jaFSX3qEejU?=
 =?us-ascii?Q?YJhZ/zRij1tWNqwh5qbkzFLx8xTlDON3XBasB5sTvAaPeYw7Gx4dg9Km8NOw?=
 =?us-ascii?Q?SbN69T7NHFPIqbq+NqgchZKq0rfBmrGcHjp5O0IP5v0ZNJcVe+0SBFAhDzHe?=
 =?us-ascii?Q?A85v6EDamRqOL3UhMyKUrTAZMD0YsSjXggXADdgProiXdIZgn0goc9WH7pfw?=
 =?us-ascii?Q?PA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cf5062e-c559-4380-315a-08daf7a51514
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 09:36:02.3061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 94EnooYdWwDStRC8vHPug4ypGUlSDd1pCNXlTdX5+dQl3+EOBHdblE/RP353ewBN4ASAzqyx+lDLvZZLSyxIu0jt9+mxHqKFVvNavZNmL8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB1012
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
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |  4 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |  4 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 90 ++++++++-----------
 net/netfilter/nf_conntrack_standalone.c       | 16 ----
 4 files changed, 42 insertions(+), 72 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_sctp.h b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
index c742469afe21..150fc3c056ea 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_sctp.h
@@ -15,8 +15,8 @@ enum sctp_conntrack {
 	SCTP_CONNTRACK_SHUTDOWN_RECD,
 	SCTP_CONNTRACK_SHUTDOWN_ACK_SENT,
 	SCTP_CONNTRACK_HEARTBEAT_SENT,
-	SCTP_CONNTRACK_HEARTBEAT_ACKED,
-	SCTP_CONNTRACK_DATA_SENT,
+	SCTP_CONNTRACK_HEARTBEAT_ACKED,	/* no longer used */
+	SCTP_CONNTRACK_DATA_SENT,	/* no longer used */
 	SCTP_CONNTRACK_MAX
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
index 94e74034706d..282343d433a6 100644
--- a/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/uapi/linux/netfilter/nfnetlink_cttimeout.h
@@ -94,8 +94,8 @@ enum ctattr_timeout_sctp {
 	CTA_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	CTA_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	CTA_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	CTA_TIMEOUT_SCTP_DATA_SENT,
+	CTA_TIMEOUT_SCTP_HEARTBEAT_ACKED,	/* no longer used */
+	CTA_TIMEOUT_SCTP_DATA_SENT,		/* no longer used */
 	__CTA_TIMEOUT_SCTP_MAX
 };
 #define CTA_TIMEOUT_SCTP_MAX (__CTA_TIMEOUT_SCTP_MAX - 1)
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index c561c1213704..22417757ce94 100644
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
+	[SCTP_CONNTRACK_NONE] = "NONE",
+	[SCTP_CONNTRACK_CLOSED] = "CLOSED",
+	[SCTP_CONNTRACK_COOKIE_WAIT] = "COOKIE_WAIT",
+	[SCTP_CONNTRACK_COOKIE_ECHOED] = "COOKIE_ECHOED",
+	[SCTP_CONNTRACK_ESTABLISHED] = "ESTABLISHED",
+	[SCTP_CONNTRACK_SHUTDOWN_SENT] = "SHUTDOWN_SENT",
+	[SCTP_CONNTRACK_SHUTDOWN_RECD] = "SHUTDOWN_RECD",
+	[SCTP_CONNTRACK_SHUTDOWN_ACK_SENT] = "SHUTDOWN_ACK_SENT",
+	[SCTP_CONNTRACK_HEARTBEAT_SENT] = "HEARTBEAT_SENT",
 };
 
 #define SECS  * HZ
@@ -54,13 +48,11 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
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
-	[SCTP_CONNTRACK_DATA_SENT]		= 30 SECS,
 };
 
 #define	SCTP_FLAG_HEARTBEAT_VTAG_FAILED	1
@@ -74,8 +66,6 @@ static const unsigned int sctp_timeouts[SCTP_CONNTRACK_MAX] = {
 #define	sSR SCTP_CONNTRACK_SHUTDOWN_RECD
 #define	sSA SCTP_CONNTRACK_SHUTDOWN_ACK_SENT
 #define	sHS SCTP_CONNTRACK_HEARTBEAT_SENT
-#define	sHA SCTP_CONNTRACK_HEARTBEAT_ACKED
-#define	sDS SCTP_CONNTRACK_DATA_SENT
 #define	sIV SCTP_CONNTRACK_MAX
 
 /*
@@ -97,11 +87,7 @@ SHUTDOWN_ACK_SENT - We have seen a SHUTDOWN_ACK chunk in the direction opposite
 		    to that of the SHUTDOWN chunk.
 CLOSED            - We have seen a SHUTDOWN_COMPLETE chunk in the direction of
 		    the SHUTDOWN chunk. Connection is closed.
-HEARTBEAT_SENT    - We have seen a HEARTBEAT in a new flow.
-HEARTBEAT_ACKED   - We have seen a HEARTBEAT-ACK/DATA/SACK in the direction
-		    opposite to that of the HEARTBEAT/DATA chunk. Secondary connection
-		    is established.
-DATA_SENT         - We have seen a DATA/SACK in a new flow.
+HEARTBEAT_SENT    - We have seen a HEARTBEAT/DATA/SACK in a new flow.
 */
 
 /* TODO
@@ -118,35 +104,35 @@ cookie echoed to closed.
 static const u8 sctp_conntracks[2][12][SCTP_CONNTRACK_MAX] = {
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
+/* data/sack    */ {sHS, sCL, sCW, sCE, sES, sSS, sSR, sSA, sHS}
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
+/* data/sack    */ {sIV, sCL, sCW, sCE, sES, sSS, sSR, sSA, sES},
 	}
 };
 
@@ -264,7 +250,7 @@ static int sctp_new_state(enum ip_conntrack_dir dir,
 		i = 11;
 		break;
 	default:
-		/* Other chunks like DATA or SACK do not change the state */
+		/* Other chunks do not change the state */
 		pr_debug("Unknown chunk type, Will stay in %s\n",
 			 sctp_conntrack_names[cur_state]);
 		return cur_state;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0250725e38a4..460294bd4b60 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -601,8 +601,6 @@ enum nf_ct_sysctl_index {
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_RECD,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_SHUTDOWN_ACK_SENT,
 	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_SENT,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_HEARTBEAT_ACKED,
-	NF_SYSCTL_CT_PROTO_TIMEOUT_SCTP_DATA_SENT,
 #endif
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 	NF_SYSCTL_CT_PROTO_TIMEOUT_DCCP_REQUEST,
@@ -887,18 +885,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
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
@@ -1042,8 +1028,6 @@ static void nf_conntrack_standalone_init_sctp_sysctl(struct net *net,
 	XASSIGN(SHUTDOWN_RECD, sn);
 	XASSIGN(SHUTDOWN_ACK_SENT, sn);
 	XASSIGN(HEARTBEAT_SENT, sn);
-	XASSIGN(HEARTBEAT_ACKED, sn);
-	XASSIGN(DATA_SENT, sn);
 #undef XASSIGN
 #endif
 }
-- 
2.34.1

