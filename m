Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1982C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Feb 2022 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbiBNJlx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Feb 2022 04:41:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244801AbiBNJkx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Feb 2022 04:40:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2096.outbound.protection.outlook.com [40.107.243.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32544654AF
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Feb 2022 01:36:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilRyEdHO9JMZAtrcAgPv8BQFXFTKXocrGvw8cnCuXhNDm1BqCz1jIYV+h7u4MXu7CL+wdm+HXVt0llfZFPKaur7mocA0UYvqFuAgUifz4xYWDS0SGo8JKRnjO4atuKU4qsmZVUaN3gB6TIESq+tkWp/vDiC4zkwp2Beu28Qo3WBjTQbmwtN6KCq8yc+vPIhQGoerT1TTlPP7LGVPKasFvGEySFDCX/M9wLt1z8xruaBWv8XgfHcjhUhqokm3CLqfoLkLRzVlVoc/bVwHdl6/rRx4KBlT0OmHZxLFeRx5btU6k6SmYiTo/ihefPDlbjeGz3XoxPXOKb66eL/tQeYSiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yvMO1QqrODJuBQUz0POBh0XliZH6FOgSZJINxrsqMc=;
 b=b9GPWwLXV5VEN8xcHRiXhIhi69aC0tqrgRRDYoYSAOGWJfwhCKeKeY80LWikF02nMil7FaNrYsFS8H49zgeLR1S2r97F0pmgSCtPqzD0nSe8nOzCgHiUl3jUw/1JPo7tgrkG0oWL0KYO2W7SAeLwdw3gBxd55oRxA5FSgTQXWw0lb2NoHzwX+xdtYci6Iols0bcB8xnVdXKVgGr/YLpi8UvzoXle+dN6pML6LTHUfdPBQfzg9CqcbbyM0x5+RCB5KhGiZ9QcKAIji/x/SnUMVsZ8/bEijdAEfGaA2nIay9uGEid1M6oO+ykH/U+NkahaKdy5UL9sWmasY1pq+a6WOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yvMO1QqrODJuBQUz0POBh0XliZH6FOgSZJINxrsqMc=;
 b=jWhxRov2576NF6iETqFxupUXlOQzPgFTxMina3Ru2Iiu245zxlRniU0ukkl417yZcpwdvr9XL1I36bDCVubZi3I+BsWPYVOozVMi7r4UN9Omw+/0IO/IaXHo91MDblzVFskjrEbGQ7tPJIA4PjYHiTEeN9XqopVl6lU5uyVqtYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by MN2PR11MB3566.namprd11.prod.outlook.com (2603:10b6:208:ec::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Mon, 14 Feb
 2022 09:36:02 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::41d7:e1f8:b465:32d]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::41d7:e1f8:b465:32d%5]) with mapi id 15.20.4975.015; Mon, 14 Feb 2022
 09:36:01 +0000
Message-ID: <e213920b-a90d-b543-2166-4fb5ec94bdde@fortanix.com>
Date:   Mon, 14 Feb 2022 10:35:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH v2] xshared: Implement xtables lock timeout using signals
Content-Language: en-US
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms020202050501060109090809"
X-ClientProxiedBy: AM0PR02CA0209.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::16) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 191e4934-cbc1-4880-b650-08d9ef9d69db
X-MS-TrafficTypeDiagnostic: MN2PR11MB3566:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB3566C1EBBF8F5B3A483827F0AA339@MN2PR11MB3566.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SE0gtH0KX8n7+vaiZx8lYwkGCyYFy8u0pOA3VOobZNqkLDBOPAdREgGmw9PlPXP/b02teFkps8n89zB8zHts2ZLy3njBxTrMFGLFhWciMvFY55/lwxCRSJLCb9lUM8DVN7/mpCcgdThD1VB7ZT6oZpT5lQJlj3GUHaZ5cvf5SQhc6Gh1nzMvjC7xIoh+1Qfy6ZSlVeuoa+bdTbPHtKiVF5WXgTMX3UCynIzwVCbNtKY+99yaXkfxYc+eN+VoYIBbAub1WreI//IGIqr8IcW+n8zX3h6CRz6odHckEm4fgVFlZPbFbgBdaIlJnnDhoGKusjUObETiyXVW9mz1qvMmUeYJtfOCgMiKW2CFNfaNkEzcjhi6fA1VDa1tiYgbw4KaSihT00BUN6Z0T80OlkTCemrRRk4bR5raT00r163XhcetWb5HHS1Y1P+DA4fHpsqizke2IN3Iajist4y7jXv05RvzkBor1uQwnoNPO9DqJZAWhRrrzXtokt2UoijAWpfFuSD6ZR3E7rJnbwcCsMftvavTxUpHO39yl3fFUAi8h52eT1sXyrkUvxafhkILZkIhdxe186kzMAu/QXvUPOCCeE23woVSj+laKo6+oW9GVi1d3e1KfocnAKXaLcJ0pM8TPYRDXCk800Scs7yvKYB0Rt3nAmcyRZwYytgZbHPhTrkzI5vfNFILYD+O5pF+psXh1sP6OL5jkLwaDMLNM1JDCnuD7Wq0Jco5AOB9XV+1voagm2YeEZ0KcmYFp4D7rG39v7CQQOVbcYbD/rpGWhFmEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6916009)(86362001)(8936002)(66556008)(38100700002)(186003)(31696002)(4326008)(8676002)(66476007)(66946007)(26005)(38350700002)(33964004)(52116002)(6506007)(2616005)(316002)(6512007)(6486002)(508600001)(83380400001)(36756003)(31686004)(2906002)(235185007)(5660300002)(6666004)(30864003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEk2NndCOWxkUWU5UDBacVA1UlBBZUpSMDlrWk5GK0xZWHU0SFhaczdJekNB?=
 =?utf-8?B?VXJoOGVTaXN4ZDBhalRCNFh5UGp4dGttcEk3dFBUbXlvbWZ0WThkcW5PM2ts?=
 =?utf-8?B?c1dIc3lKdnI0QnRSek9GTUpNWTZkd0ZoSXlwaXU3cHgyY3FVeFMrR2RNc3dG?=
 =?utf-8?B?c29peko1OFR5dlJVdWVaQ1pzc0JORDFMM1Z3TDdqU2hlSmh5VWJhSHJKdzFC?=
 =?utf-8?B?MU1VNzgyNTdVaElvY3RCMmxYWDNacXFzREx0V0VoT3RVejcxN1BiVXVyU3BP?=
 =?utf-8?B?aHVEMWMrVUZxYTJ5ZlFsV2FVRHQzdHNoU1A2cFl1di9GN3ZWejZxY0txUGt2?=
 =?utf-8?B?eExRaUFjc0tRTnB5cDREbXgyRlFZeFFmQWlmTVIrcXI3V2RrU1JCYVYrVEoy?=
 =?utf-8?B?U2gvOTFZcUxpd0VkYU1rTGMyK01uMGI5ZzlEd2R6dzVadW9wTTNJdTVUQlZO?=
 =?utf-8?B?SkxHT0JkZ2ZXUlNKeXZROW5CL3cwMU9pNjRpNHBFZWNYWjNLQzlmSi9MKzE2?=
 =?utf-8?B?am1LQkNMdUF1bnBTWkhlenRnSERvWnlmb0Z2eWlOS3hvUE1iR3NiUTlqRlJ0?=
 =?utf-8?B?K0dTcnAza3c2T0hzWkc5bTBtSUxFd2Z0VUZONngzdEdaQ05XZVhHR2ZkOGp4?=
 =?utf-8?B?N2FNaGgwbmhsYzJnaUJGcHRFZkVtWmh1S25vajZmRWhQZU9oRkk3dkpUNGh4?=
 =?utf-8?B?c0JuWHc2Nk1rclpYajNiK1ZJRE9hNzF5NHRXTWFPaGduK0dLVjc4TnJOeTYw?=
 =?utf-8?B?b3oyUW84cDJJTzRKRmhTbHNtWmxhWXNxTk5BSzF0MWlxT21JV3ZWRkdHM2NB?=
 =?utf-8?B?aVZGeTJscWh5UFZhYTMzZkR0M1loazFIMzc2b0hzcDJtZjBCT1FwLzJlcnJG?=
 =?utf-8?B?NHEzcDcrbzgrakFidHExWmMzU1VzLzQxb2Z0Q3B0MStsbGtZcDRRNnl2T29O?=
 =?utf-8?B?Qk5wNmFLM09tZmZGZzdpVE5BbVNYRXBNTDFUbVBma2xsUXZBSkt0SlBVNHFn?=
 =?utf-8?B?WEFVRkpTaS9DVXluZnEveTNjOEx1eTRWQmI5elhPSkxWNzl1OUlJQ2RhTzg0?=
 =?utf-8?B?VlI3MDNiZEJWUFJpYk9mNHM3cFliZmM4a2psenQyZDlWU2J2ZUJtZTNENlJk?=
 =?utf-8?B?WkErck5MWUM0Rmd5bkJ5VzFBeVlNTkRUTkZyaktPU0JTREQ3UmdxcUNWb01F?=
 =?utf-8?B?TVZYcndYSTFDK3pBaGNlbFFDNUdOMjAxUmpUeCtOQmQ5YWI1UGZQM0pzUXkv?=
 =?utf-8?B?Ri9rVFBTZU1GOXl0ZlpPTkYybEtsdlI4amVPK09xbnZkTmFxdk9HaFFZdHJi?=
 =?utf-8?B?WEtyeWZ1aTRORG01dzd3Sm1sS3ZjTkJzWVd2VE5LMU5mTTRsV3RzL0F1R1Nv?=
 =?utf-8?B?SmhsdXREa294ajdOOE9CeXFnM2x3SDFUL00vb3Q2MEx5NmVUa2NwRG1jZkhC?=
 =?utf-8?B?azEyYW1ZMTBMUmNoZWlncDc2QlJFOTdjbkdERU96MHRrK0tjcHFvY21HTVpN?=
 =?utf-8?B?OGNZdzNCUHFJaU1qUENKWjhOR2NHZVJaZjBGM204ZnhhS0NYdkhLTkRtZUs2?=
 =?utf-8?B?QTBMZmFSZmFmY1BpZUNRRGlZSktjeUJody93OWJjdXM1SGM2K3ozKzFxQlpV?=
 =?utf-8?B?VnNlZHBmcSszNmg5aWtkeUZxblhDc2J2dzI2L2JpRzZ0dGRkNG5MTnlTcDBK?=
 =?utf-8?B?aWZGV3gxWkJzYU9aSXUvbXUxdm9iSWhtMzJmcnp3QmhiL1o3d2Q5NUZMdWtB?=
 =?utf-8?B?QStGOS9jWEdJRThBWGw3NzdrZGNCcHZ1TUFpaWtaYTRROUovVXh3V2p0N1FY?=
 =?utf-8?B?c29FOGNYOEQ5WUJkMVRreTVWc0dBckRsbW9LY1NCa3psYTE2clZUandGWXhh?=
 =?utf-8?B?WnJYeURWUTgzSWZzZVEwekQwRkZFaHltd2dZdU5aQWhvWnd3N1BwVzNZYjVs?=
 =?utf-8?B?UkJPYUlFOE9CckdPWTYwdzV3RFBYR0RNRU1JSUhmMHlhR1ZaS2dtbUcwSGRR?=
 =?utf-8?B?MUtSMjM3ZXVsQjJHeVZnSHQ2NUVvYWF6a0hENmZ2eEhsS1JyeGdjQWc2WWky?=
 =?utf-8?B?bWNrellYMHNTZUtYYjRnektKcmtpRDBoZWNSTUVFRGhWaERCOGJ5N2NrVmYx?=
 =?utf-8?B?N045TlN3dTJpNEIrV0tyOGxFeEZqdEtjakNHNmVibTJSRUZBVXJhSjgzbzBP?=
 =?utf-8?Q?qHAsLc4E6cVqYifT+LRc52U=3D?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 191e4934-cbc1-4880-b650-08d9ef9d69db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 09:36:01.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: evLp9rxAfdL0Usyu1pn2DHmqoPszyk8L84jA0BX3m5/tZniYH9Jj/ICteLf+HtHm6LVlRL341sf/eUJW9xRLGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3566
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--------------ms020202050501060109090809
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Previously, if a lock timeout is specified using `-wN `, flock() is
called using LOCK_NB in a loop with a sleep. This results in two issues.

The first issue is that the process may wait longer than necessary when
the lock becomes available. For this the `-W` option was added, but this
requires fine-tuning.

The second issue is that if lock contention is high, invocations using
`-w` (without a timeout) will always win lock acquisition from
invocations that use `-w N`. This is because invocations using `-w` are
actively waiting on the lock whereas those using `-w N` only check from
time to time whether the lock is free, which will never be the case.

This patch removes the sleep loop and deprecates the `-W` option (making
it non-functional). Instead, flock() is always called in a blocking
fashion, but the alarm() function is used with a non-SA_RESTART signal
handler to cancel the system call.

v2: Rebased

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 iptables/ip6tables.c                          |  7 +--
 iptables/iptables-restore.8.in                |  7 ---
 iptables/iptables-restore.c                   | 13 ++--
 iptables/iptables.8.in                        |  7 ---
 iptables/iptables.c                           |  7 +--
 .../testcases/ipt-restore/0002-parameters_0   |  3 +-
 iptables/xshared.c                            | 63 ++++++++-----------
 iptables/xshared.h                            |  6 +-
 8 files changed, 36 insertions(+), 77 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 560b6ed0..f4796b89 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -712,7 +712,6 @@ int do_command6(int argc, char *argv[], char **table,
 	};
 	struct xtables_args args = {
 		.family = AF_INET6,
-		.wait_interval.tv_sec = 1,
 	};
 	struct ip6t_entry *e = NULL;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
@@ -721,9 +720,6 @@ int do_command6(int argc, char *argv[], char **table,
 
 	int verbose = 0;
 	int wait = 0;
-	struct timeval wait_interval = {
-		.tv_sec	= 1,
-	};
 	const char *chain = NULL;
 	const char *policy = NULL, *newname = NULL;
 	unsigned int rulenum = 0, command = 0;
@@ -739,7 +735,6 @@ int do_command6(int argc, char *argv[], char **table,
 	newname		= p.newname;
 	verbose		= p.verbose;
 	wait		= args.wait;
-	wait_interval	= args.wait_interval;
 	nsaddrs		= args.s.naddrs;
 	ndaddrs		= args.d.naddrs;
 	saddrs		= args.s.addr.v6;
@@ -749,7 +744,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	/* Attempt to acquire the xtables lock */
 	if (!restore)
-		xtables_lock_or_exit(wait, &wait_interval);
+		xtables_lock_or_exit(wait);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 883da998..20216842 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -67,13 +67,6 @@ the program will exit if the lock cannot be obtained.  This option will
 make the program wait (indefinitely or for optional \fIseconds\fP) until
 the exclusive lock can be obtained.
 .TP
-\fB\-W\fP, \fB\-\-wait-interval\fP \fImicroseconds\fP
-Interval to wait per each iteration.
-When running latency sensitive applications, waiting for the xtables lock
-for extended durations may not be acceptable. This option will make each
-iteration take the amount of time specified. The default interval is
-1 second. This option only works with \fB\-w\fP.
-.TP
 \fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
 Specify the path to the modprobe program. By default, iptables-restore will
 inspect /proc/sys/kernel/modprobe to determine the executable's path.
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 3c0a2389..1917fb23 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -22,10 +22,6 @@
 
 static int counters, verbose, noflush, wait;
 
-static struct timeval wait_interval = {
-	.tv_sec	= 1,
-};
-
 /* Keeping track of external matches and targets.  */
 static const struct option options[] = {
 	{.name = "counters",      .has_arg = 0, .val = 'c'},
@@ -51,7 +47,6 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
 			"	   [ --wait=<seconds>\n"
-			"	   [ --wait-interval=<usecs>\n"
 			"	   [ --table=<TABLE> ]\n"
 			"	   [ --modprobe=<command> ]\n", name);
 }
@@ -101,6 +96,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 	FILE *in;
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
+	bool wait_interval_set = false;
 
 	line = 0;
 	lock = XT_LOCK_NOT_ACQUIRED;
@@ -135,7 +131,8 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 				wait = parse_wait_time(argc, argv);
 				break;
 			case 'W':
-				parse_wait_interval(argc, argv, &wait_interval);
+				parse_wait_interval(argc, argv);
+				wait_interval_set = true;
 				break;
 			case 'M':
 				xtables_modprobe_program = optarg;
@@ -165,7 +162,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 	}
 	else in = stdin;
 
-	if (!wait_interval.tv_sec && !wait) {
+	if (wait_interval_set && !wait) {
 		fprintf(stderr, "Option --wait-interval requires option --wait\n");
 		exit(1);
 	}
@@ -203,7 +200,7 @@ ip46tables_restore_main(const struct iptables_restore_cb *cb,
 			in_table = 0;
 		} else if ((buffer[0] == '*') && (!in_table)) {
 			/* Acquire a lock before we create a new table handle */
-			lock = xtables_lock_or_exit(wait, &wait_interval);
+			lock = xtables_lock_or_exit(wait);
 
 			/* New table */
 			char *table;
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index ccc498f5..627ff0e4 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -377,13 +377,6 @@ the program will exit if the lock cannot be obtained.  This option will
 make the program wait (indefinitely or for optional \fIseconds\fP) until
 the exclusive lock can be obtained.
 .TP
-\fB\-W\fP, \fB\-\-wait-interval\fP \fImicroseconds\fP
-Interval to wait per each iteration.
-When running latency sensitive applications, waiting for the xtables lock
-for extended durations may not be acceptable. This option will make each
-iteration take the amount of time specified. The default interval is
-1 second. This option only works with \fB\-w\fP.
-.TP
 \fB\-n\fP, \fB\-\-numeric\fP
 Numeric output.
 IP addresses and port numbers will be printed in numeric format.
diff --git a/iptables/iptables.c b/iptables/iptables.c
index f5fe868c..ccebb1a6 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -706,15 +706,11 @@ int do_command4(int argc, char *argv[], char **table,
 	};
 	struct xtables_args args = {
 		.family = AF_INET,
-		.wait_interval.tv_sec = 1,
 	};
 	struct ipt_entry *e = NULL;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *smasks = NULL;
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
-	struct timeval wait_interval = {
-		.tv_sec = 1,
-	};
 	int verbose = 0;
 	int wait = 0;
 	const char *chain = NULL;
@@ -732,7 +728,6 @@ int do_command4(int argc, char *argv[], char **table,
 	newname		= p.newname;
 	verbose		= p.verbose;
 	wait		= args.wait;
-	wait_interval	= args.wait_interval;
 	nsaddrs		= args.s.naddrs;
 	ndaddrs		= args.d.naddrs;
 	saddrs		= args.s.addr.v4;
@@ -742,7 +737,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 	/* Attempt to acquire the xtables lock */
 	if (!restore)
-		xtables_lock_or_exit(wait, &wait_interval);
+		xtables_lock_or_exit(wait);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/tests/shell/testcases/ipt-restore/0002-parameters_0 b/iptables/tests/shell/testcases/ipt-restore/0002-parameters_0
index 5c8748ec..d632cbc0 100755
--- a/iptables/tests/shell/testcases/ipt-restore/0002-parameters_0
+++ b/iptables/tests/shell/testcases/ipt-restore/0002-parameters_0
@@ -2,7 +2,7 @@
 
 set -e
 
-# make sure wait and wait-interval options are accepted
+# make sure wait options are accepted
 
 clean_tempfile()
 {
@@ -18,4 +18,3 @@ tmpfile=$(mktemp) || exit 1
 $XT_MULTI iptables-save -f $tmpfile
 $XT_MULTI iptables-restore $tmpfile
 $XT_MULTI iptables-restore -w 5 $tmpfile
-$XT_MULTI iptables-restore -w 5 -W 1 $tmpfile
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 1fd7acc9..50a1d48a 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -13,11 +13,11 @@
 #include <sys/file.h>
 #include <sys/socket.h>
 #include <sys/un.h>
-#include <sys/time.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <xtables.h>
 #include <math.h>
+#include <signal.h>
 #include "xshared.h"
 
 /*
@@ -243,14 +243,14 @@ void xs_init_match(struct xtables_match *match)
 		match->init(match->m);
 }
 
-static int xtables_lock(int wait, struct timeval *wait_interval)
+static void alarm_ignore(int i) {
+}
+
+static int xtables_lock(int wait)
 {
-	struct timeval time_left, wait_time;
+	struct sigaction sigact_alarm;
 	const char *lock_file;
-	int fd, i = 0;
-
-	time_left.tv_sec = wait;
-	time_left.tv_usec = 0;
+	int fd;
 
 	lock_file = getenv("XTABLES_LOCKFILE");
 	if (lock_file == NULL || lock_file[0] == '\0')
@@ -263,31 +263,24 @@ static int xtables_lock(int wait, struct timeval *wait_interval)
 		return XT_LOCK_FAILED;
 	}
 
-	if (wait == -1) {
-		if (flock(fd, LOCK_EX) == 0)
-			return fd;
-
-		fprintf(stderr, "Can't lock %s: %s\n", lock_file,
-			strerror(errno));
-		return XT_LOCK_BUSY;
+	if (wait != -1) {
+		sigact_alarm.sa_handler = alarm_ignore;
+		sigact_alarm.sa_flags = SA_RESETHAND;
+		sigemptyset(&sigact_alarm.sa_mask);
+		sigaction(SIGALRM, &sigact_alarm, NULL);
+		alarm(wait);
 	}
 
-	while (1) {
-		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
-			return fd;
-		else if (timercmp(&time_left, wait_interval, <))
-			return XT_LOCK_BUSY;
+	if (flock(fd, LOCK_EX) == 0)
+		return fd;
 
-		if (++i % 10 == 0) {
-			fprintf(stderr, "Another app is currently holding the xtables lock; "
-				"still %lds %ldus time ahead to have a chance to grab the lock...\n",
-				time_left.tv_sec, time_left.tv_usec);
-		}
-
-		wait_time = *wait_interval;
-		select(0, NULL, NULL, NULL, &wait_time);
-		timersub(&time_left, wait_interval, &time_left);
+	if (errno == EINTR) {
+		errno = EWOULDBLOCK;
 	}
+
+	fprintf(stderr, "Can't lock %s: %s\n", lock_file,
+		strerror(errno));
+	return XT_LOCK_BUSY;
 }
 
 void xtables_unlock(int lock)
@@ -296,9 +289,9 @@ void xtables_unlock(int lock)
 		close(lock);
 }
 
-int xtables_lock_or_exit(int wait, struct timeval *wait_interval)
+int xtables_lock_or_exit(int wait)
 {
-	int lock = xtables_lock(wait, wait_interval);
+	int lock = xtables_lock(wait);
 
 	if (lock == XT_LOCK_FAILED) {
 		xtables_free_opts(1);
@@ -334,7 +327,7 @@ int parse_wait_time(int argc, char *argv[])
 	return wait;
 }
 
-void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval)
+void parse_wait_interval(int argc, char *argv[])
 {
 	const char *arg;
 	unsigned int usec;
@@ -354,8 +347,7 @@ void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval)
 				      "too long usec wait %u > 999999 usec",
 				      usec);
 
-		wait_interval->tv_sec = 0;
-		wait_interval->tv_usec = usec;
+		fprintf(stderr, "Ignoring deprecated --wait-interval option.\n");
 		return;
 	}
 	xtables_error(PARAMETER_PROBLEM, "wait interval not numeric");
@@ -1235,9 +1227,6 @@ xtables_printhelp(const struct xtables_rule_match *matches)
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --wait	-w [seconds]	maximum wait to acquire xtables lock before give up\n"
-"  --wait-interval -W [usecs]	wait time to try to acquire xtables lock\n"
-"				interval to wait for xtables lock\n"
-"				default is 1 second\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n");
 
@@ -1665,7 +1654,7 @@ void do_parse(int argc, char *argv[],
 					      "iptables-restore");
 			}
 
-			parse_wait_interval(argc, argv, &args->wait_interval);
+			parse_wait_interval(argc, argv);
 			wait_interval_set = true;
 			break;
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index d13de95e..0de0e12e 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -6,7 +6,6 @@
 #include <stdint.h>
 #include <netinet/in.h>
 #include <net/if.h>
-#include <sys/time.h>
 #include <linux/netfilter_arp/arp_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
@@ -189,10 +188,10 @@ enum {
 	XT_LOCK_NOT_ACQUIRED  = -3,
 };
 extern void xtables_unlock(int lock);
-extern int xtables_lock_or_exit(int wait, struct timeval *tv);
+extern int xtables_lock_or_exit(int wait);
 
 int parse_wait_time(int argc, char *argv[]);
-void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval);
+void parse_wait_interval(int argc, char *argv[]);
 int parse_counters(const char *string, struct xt_counters *ctr);
 bool tokenize_rule_counters(char **bufferp, char **pcnt, char **bcnt, int line);
 bool xs_has_arg(int argc, char *argv[]);
@@ -294,7 +293,6 @@ struct xtables_args {
 	const char	*arp_htype, *arp_ptype;
 	unsigned long long pcnt_cnt, bcnt_cnt;
 	int		wait;
-	struct timeval	wait_interval;
 };
 
 struct xt_cmd_parse_ops {
-- 
2.25.1


--------------ms020202050501060109090809
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
DVUwggXgMIIDyKADAgECAhAorKRKpFwMN77KaahISgU8MA0GCSqGSIb3DQEBCwUAMIGBMQsw
CQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRy
bzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEczMB4XDTIxMDkyMDA4MjgxMloXDTIyMDkyMDA4MjgxMlowHjEc
MBoGA1UEAwwTamV0aHJvQGZvcnRhbml4LmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAN7ILCRnCqfq7ADD69ye2hNX9tiR29nMKgMVdUSx3FOQPEgohsmmuQOPiXlXirfk
s+jxVb/rkOboY9+nmWNauFXlKHflIe0jbFSFCuY8AxzVFKQllY2sa3t8KEsL5OvKoeNZ98NZ
BgmaxbDsKQVjnqFMWuHe2EV6TfnmZFg25hkKTjvg6uzIxs4zd+zIQPhGUlpd3Ezbu2G8kiCE
X8DI58eXN6xyQffN2N1rTgMME4V38Eub7nsgS31UU0PuGNHKLIKq1PwuU/BThviOaCP7Urce
0YHsWR+zGDkFU3Nhdj7cs7wsnrLTEIHHUwummCUZcangMad3dWWeIOM1iVQOsz8CAwEAAaOC
AbQwggGwMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUvpepqoS/gL8QU30JMvnhLjIbz3cw
fgYIKwYBBQUHAQEEcjBwMDsGCCsGAQUFBzAChi9odHRwOi8vY2FjZXJ0LmFjdGFsaXMuaXQv
Y2VydHMvYWN0YWxpcy1hdXRjbGlnMzAxBggrBgEFBQcwAYYlaHR0cDovL29jc3AwOS5hY3Rh
bGlzLml0L1ZBL0FVVEhDTC1HMzAeBgNVHREEFzAVgRNqZXRocm9AZm9ydGFuaXguY29tMEcG
A1UdIARAMD4wPAYGK4EfARgBMDIwMAYIKwYBBQUHAgEWJGh0dHBzOi8vd3d3LmFjdGFsaXMu
aXQvYXJlYS1kb3dubG9hZDAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwSAYDVR0f
BEEwPzA9oDugOYY3aHR0cDovL2NybDA5LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRIQ0wt
RzMvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUwInkh2YOl18URVO4DXuERsHxbzEwDgYDVR0PAQH/
BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4ICAQAi4cE7xYH7vsY3NNSxzLlm7K4xnomElL2pd2lq
0o0jp29kJxC5km9d/boVh3SfLLbPfubQRShERrOZl0CwHHZlCn7EF48jdcyDkqMSRzgeKjra
JhkWaxWhXvLc6AwV/de3hX5XD6xCZhC5CWSFaFJI4X6GLHyXzYT3bNPqjrks2Mmd1uQT5Fnt
Xj1rmTDJAK3AtBzcWkmWpKC7oqqzPLjqTMicWu7LKsGR3WS9DVf/UQXKh6I76fQ9sOXm7/Ll
U6CyRs2G4oq6tAsAAeiA4EUWg/0Q1zFYZ+6tRbYWC7Itl5+CQpKiPo1cLWrsSpzK4mpkf+8f
ZL23s8TlTliRTlLv2XLI8Gxl03qMhyR2dFWiI0Ldlx8Zp2Mc0hmAjZP7Tc+W8BFUR3pZIswY
dslI2uBpXFxFX2+T0K3lXOxqhvSRfXbIoJ+ulFEgDImTJnrBFRizHAX/8rwrxyxpJBhWTSY0
tbXRRSoxe1D0RAqcGf57+sh5CxSUuNgZ6n4ypdBt2SI6a/X/oIIwKJvbM5+aASsaLB24xYI3
AgiPb7nopSi1n2zn+XHw0TnzW8iC5wXUmY1GFMoq6aseE5nCE1wUZWt/bVrpO0XW/r9kkG6O
2tCmgbv8vHQT7gLfMgGQYAmKA6Ehniyjbi1evBYcpt9ly7xx/mIfACNwKLvxC3ksTMkNqTCC
B20wggVVoAMCAQICEBcQPt49ihy1ygZRk+fKQ2swDQYJKoZIhvcNAQELBQAwazELMAkGA1UE
BhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUy
MDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENBMB4XDTIwMDcw
NjA4NDU0N1oXDTMwMDkyMjExMjIwMlowgYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJn
YW1vMRkwFwYDVQQHDBBQb250ZSBTYW4gUGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5B
LjEsMCoGA1UEAwwjQWN0YWxpcyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzMwggIiMA0G
CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDt5oeWocGktu3CQlX3Pw8PImBfE+CmQ4iGSZF5
HBsvGlAP3EYB7va6OobMUWHvxA+ACHEpWq0YfNh6rRUlULOGcIpEFtVf4nAiEvdQtiFQBmtW
JSn3naoMHqpMvmwZ4lL0Xr1U9JHmTqkU3DuYcNNO3S+hYWDZpWQbeSGibNVeiJ4kY6JDh0fv
qloK1BsuS3n2OgArPYGfAYtDjCvT2d+6Ym3kArHZjEcrZeBI+yVVnjPwbTSCKax8DtS2NP/C
J6RjpnRvuSwusRy84OdwdB71VKs1EDXj1ITcCWRZpkz+OhV6L8Zh+P0rmOSJF6KdHiaozfnc
URx4s54GFJNRGkx1DnCxcuL0NJMYG42/hrDYOjNv+oGWSEZO/CT3aaLSMB5wTbZKfcD1R+tT
anXD+5Gz5Mi15DTE7QH8naZjZxqqhyxL1KyuIgaVDxvQtPSjo5vTsoa09rn+Ui8ybHnvYO/a
/68OIQIHLGbUd2COnwm0TiZ3Jg/oYGxwnJPvU1nDXNcecWTIJvFF5qD2ppJH3HgJVVePUEOY
1E4Kp3k0B8hdRdhMV5n+O6RCKCTFcZaESF8sELgdrqnCLPP1+rX7DA8pxZoX0/9Jk64EOsbf
QyLIJlrrob2YS0Xlku6HisZ8qrHLhnkzF5y7O34xmatIp8oZ5c54QP+K5flnTYzWjuIxLwID
AQABo4IB9DCCAfAwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRS2Ig6yJ94Zu2J83s4
cJTJAgI20DBBBggrBgEFBQcBAQQ1MDMwMQYIKwYBBQUHMAGGJWh0dHA6Ly9vY3NwMDUuYWN0
YWxpcy5pdC9WQS9BVVRILVJPT1QwRQYDVR0gBD4wPDA6BgRVHSAAMDIwMAYIKwYBBQUHAgEW
JGh0dHBzOi8vd3d3LmFjdGFsaXMuaXQvYXJlYS1kb3dubG9hZDAdBgNVHSUEFjAUBggrBgEF
BQcDAgYIKwYBBQUHAwQwgeMGA1UdHwSB2zCB2DCBlqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUu
YWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRoZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxv
JTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJl
dm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVw
b3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUvpepqoS/gL8QU30JMvnh
LjIbz3cwDgYDVR0PAQH/BAQDAgEGMA0GCSqGSIb3DQEBCwUAA4ICAQAmm+cbWQ10sxID6edV
94SAhc1CwzthHFfHpuYS30gisWUfWpgp43Dg1XzG2in3VGV7XrzCCGZh4JM/XQWp+4oxmyV4
2Qjz9vc8GRksgo6X2nYObPYZzQjda9wxsCB38i4G3H33w8lf9sFvl0xm4ZXZ2s2bF/PdqvrK
0ZgvF51+MoIPnli/wJBw3p72xbk5Sb1MneSO3tZ293WFzDmz7tuGU0PfytYUkG7O6annGqbU
1I6CA6QVKUqeFLPodSODAFqJ3pimKD0vX9MuuSa0QinH7CkiPtZMD0mpwwzIsnSs3qOOl60t
IZQOTc0I6lCe1LLhrz7Q75J6nNL9N5zVwZ1I3o2Lb8Dt7BA13VFuZvZIzapUGV83R7pmSVaj
1Bik1nJ/R393e6mwppsT140KDVLh4Oenywmp2VpBDuEj9RgICAO0sibv8n379LbO7ARa0kw9
y9pggFzN2PAX25b7w0n9m78kpv3z3vW65rs6wl7E8VEHNfv8+cnb81dxN3C51KElz+l31zch
FTurD5HFEpyEhzO/fMS5AkweRJIzwozxNs7OL/S/SVTpJLJL1ukZ1lnHHX0d3xCzRy/5HqfK
3uiG22LPB5+RjNDobPAjAz2BKMfkF/+v0pzn8mqqkopQaJzEAbLbMpgQYHRCjvrUxxwjJyUF
b2Z+40UNtMF4MTK7zTGCA/MwggPvAgEBMIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwH
QmVyZ2FtbzEZMBcGA1UEBwwQUG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBT
LnAuQS4xLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhAo
rKRKpFwMN77KaahISgU8MA0GCWCGSAFlAwQCAQUAoIICLTAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMjAyMTQwOTM1NTZaMC8GCSqGSIb3DQEJBDEiBCDp
1jFZcvkkk08+cDVBbaTSxZkNkVvNxYB7OK9RVuouVTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCG
SAFlAwQBKjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqG
SIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGnBgkrBgEEAYI3EAQxgZkwgZYw
gYExCzAJBgNVBAYTAklUMRAwDgYDVQQIDAdCZXJnYW1vMRkwFwYDVQQHDBBQb250ZSBTYW4g
UGlldHJvMRcwFQYDVQQKDA5BY3RhbGlzIFMucC5BLjEsMCoGA1UEAwwjQWN0YWxpcyBDbGll
bnQgQXV0aGVudGljYXRpb24gQ0EgRzMCECispEqkXAw3vsppqEhKBTwwgakGCyqGSIb3DQEJ
EAILMYGZoIGWMIGBMQswCQYDVQQGEwJJVDEQMA4GA1UECAwHQmVyZ2FtbzEZMBcGA1UEBwwQ
UG9udGUgU2FuIFBpZXRybzEXMBUGA1UECgwOQWN0YWxpcyBTLnAuQS4xLDAqBgNVBAMMI0Fj
dGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEczAhAorKRKpFwMN77KaahISgU8MA0G
CSqGSIb3DQEBAQUABIIBADU0ADYQeG6V1SkI/inx+dS+78g0HYnOJEHQ0Cgjz/95khSY5hY+
FoFfQh8ocEFG3e91nAjXkK80BS5YlYm2v1RDh8SIhqM1irO9oIOhElZV20dh94wJ4pxZFVtC
r0hyBI4xLQDnBW0fGlW1h1WeIpfmEAn1763x7KCW7D4085qF2223Yk1Hx7uTOz/q6f60Obkq
nihiB1Lk37BXs6G7K7QaP6DHknJ4V0NaunG8PktwdZpnh3192sIh12I6n+2ERdPwlf5W5/ya
Qk+i4/g0jYziHsKushC3HhovmTtIxv1VANcXr29+LLpct+8lJC1zMXmnHyn68ACFih3FUUbT
sJkAAAAAAAA=

--------------ms020202050501060109090809--
