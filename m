Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E74C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Dec 2021 15:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349003AbhLWPc5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Dec 2021 10:32:57 -0500
Received: from mail-dm6nam10on2131.outbound.protection.outlook.com ([40.107.93.131]:30177
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348994AbhLWPc5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Dec 2021 10:32:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=akA0ZgM7wbVF4wen2K5ZeFTXv1gE9HFShIwikJWOxX5mV030NEP46NvmKqmkHJQpvtaPAGKHbiI2IQQUoQqUcQjpSjqWgNNSaHyvfeGrN5VRMknrO7140y+9JrjAGDQ8RPAI1j76qHe5VPjBps/yU8/R9FVdbOa1QzSBpGTzwyk0tbyVsPhSFxo+cM0SzMmtQ/Iso/MDznrLqN+b7603BcQEB7U67SBI4GObyaavC1CUmK4fQ/yb7mGc8zjR5D8T2ltxqojpfaJLUNZ07N4RTzxUoI6wIPjUds/RhQBFetEAx9YEu8DueeslBxBp6VH4xrj+eRLhBczggJycRFPgsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0F3o6mxGPFD6imu3Yni3HPnPHm+zklypCALKBWAAlHY=;
 b=QPzD0cawJHcuZC4/vek+Xc1N8W4fkt/JwfcPr3BcM0ZhnQ7oPLocjCfZntH6/tEzN97Clqsnz0FcvDef6TsExLqvtCMzUhQ7VtThf46ioyNEY+lO7YhOyMO3YmnLLgCWVPEcRLqA2rG4uDqcCBdV9MymYNhZaAq1IzqJzLMYUlGMtR52i6lDYfBMRJS4Pmp9OqkbnpqHGPokXLWk9XyEP+fC9TKkmdLCvhrgjGa/M6ESOgZQhJhOF9FZ4EU59no5FH/WTiVpRz6+VABhfYVoaR3RvmRr4JykNzOEIKloL9EhO0htJ4wkLAbZ+z+dEtTit0WY+kaZ1VAh121jqFUXMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fortanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0F3o6mxGPFD6imu3Yni3HPnPHm+zklypCALKBWAAlHY=;
 b=JcO+DfNR1DfIUuLCeupK6mPF6/mU21gTnqdPFVQvqnEoRhGWepjo6F2sgBowR4jqlx/j/auh8MNo8CAfXsXa8w7C5OjBcnmT32rK1N7lghHu7yatN4Q84sDCCkHnYdkUo5X1sJm3cqcG3hOEJVvXk2uyfJq/bmW/mkfOOtASfU4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fortanix.com;
Received: from PH0PR11MB5626.namprd11.prod.outlook.com (2603:10b6:510:ee::15)
 by PH0PR11MB5594.namprd11.prod.outlook.com (2603:10b6:510:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Thu, 23 Dec
 2021 15:32:54 +0000
Received: from PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::d179:d7b6:81dc:71fe]) by PH0PR11MB5626.namprd11.prod.outlook.com
 ([fe80::d179:d7b6:81dc:71fe%6]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 15:32:53 +0000
From:   Jethro Beekman <jethro@fortanix.com>
Subject: [PATCH iptables] xshared: Implement xtables lock timeout using
 signals
To:     netfilter-devel@vger.kernel.org
Message-ID: <256b8216-77db-cc28-4099-30c7dafb986e@fortanix.com>
Date:   Thu, 23 Dec 2021 16:32:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:207:1::11) To PH0PR11MB5626.namprd11.prod.outlook.com
 (2603:10b6:510:ee::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af45aa89-bd6a-494a-a6fb-08d9c6297c97
X-MS-TrafficTypeDiagnostic: PH0PR11MB5594:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB559428D5FEC9CFDF4E75A620AA7E9@PH0PR11MB5594.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R54nZJj/VCc/jnlCHPelTlC1JmGOWXeZkSbDHvN+WeVvMvVrUfTh7XmwfwGF4kA/kY3BSXC0nr9bedc6pMmhJUzCgtTlwht2ilWJgdh1FZsIGZ/DNwphYLcv8ZsFKKmOoljv+jkbsdyIRbN3vNESvJuwf4P/3G19+37/u2cy5x5mWP+oknnEevrMOTStc/I1YxOIj0du90XOgUXWm212rufrFC/2pt1hfSgM9pCdrQaocZBeEuOwZlRTCFWsb3h7CP0VM8qnUvzEDgxcHSk+o8bhbWWIKe+LGqBvMWz9JWUsvgjoH7NCf1oVPxFlZ8vs9oYtmBOV8ppJkzdWDlRRJM9/6qGlKIWupzFj9BRcMnBpQnVTwWPEqKkDRohZXgE/Il8caxGm9hvqehuHV1xa5gie2+NzlUFvLeWBo/NgzrqtqRMbz08JzJANz+t9LIDcsIq10vAzcFgxuJ+R+kOp2ffpO/6/Km7PH2zkTGZPmnIfJMRYXpLd9j/ikQCzdHBk18q9iKhhMaZFHZ0UNVfw1ZPZJp8mLTapVhmV1pHBS8L+wRpiO2XJXJY4oSAQ5ak12W4vImAihW7V3mwvduXf0A0yvoWND8G//ZnSJ5fLsTKgRWM+QVpc6r8UwG3d5vJaPzL7c5XIhLFBFimyiw9ojkCHCOboETnIMwJCvr0XHn5eGy1ZLmRJDT5XFrzhsrIr8CWgkyCFS/riXmeqNGJCBwHVzKiSbDYHHA3npjjLTdBNzS6ZdxLwAanfODVb3iiJznLerpsQGpvp6KQsDSSJmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5626.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39840400004)(376002)(346002)(366004)(136003)(31686004)(5660300002)(2616005)(86362001)(6666004)(6512007)(66476007)(66556008)(38100700002)(38350700002)(66946007)(36756003)(30864003)(83380400001)(186003)(31696002)(26005)(6916009)(508600001)(8676002)(6506007)(2906002)(6486002)(52116002)(8936002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHRlbEF3QjdJTU5qeW5TSkxrNDVhRTZ1TTBGK0VSY0hPK0tURllRSzNHYm5U?=
 =?utf-8?B?djk0TDJxbzd5d2VTNk5xVVBZd2RsWnRBTmw5S2hFV1FMZ0EydEZ5U3ZIZDhT?=
 =?utf-8?B?aEJRTWNLdGVXNlVTUHNiWVFHeDU3eHU1Q3F1RkxscWE3cXRKZitGTXI1S1dr?=
 =?utf-8?B?V2F4NEtWK3VHYnJOSEtCbm5EazRHcVZSc3JyVXNVQko3MFo2ZzE2MCt2ekFW?=
 =?utf-8?B?eEVlU0xTQ2dYckVjUk1LemtTYnMyRzRpNlRQSWhpYk92bjZYaTUzNlI2SzBr?=
 =?utf-8?B?MDlCNHpwYTFqeXVZUnBhdUIwT1drVStrOEVUV3QzeVZNR0VwOVlQNlpqUS9z?=
 =?utf-8?B?KzFCN1BMSjZqZkV6S0V4eDBMbjR1MzY4b0RHSUo3NnV1dlVnSDdiUFphTWg4?=
 =?utf-8?B?cUttVGFhNHRydXh2cG9Mc1hMWStlazNUQXB5SXY4NjRNQitTd2lyaEtEZFVr?=
 =?utf-8?B?M2g5QTkxL0ErYmF1MW82OENrdWQyQXRFQUJSUlh5cXlraFJzZ3JEakJZWHpL?=
 =?utf-8?B?dThjZE9pYXlnOEJodHBQOWxCTzVOK0x3V1RsZXc4anp4YjZrWW9FdkRUNlpp?=
 =?utf-8?B?VTJkL3k0cTRuaFZnYzJZZWNDSnNFYzBrai9IQXI3NEdFbmptdkljYXFHb1ZC?=
 =?utf-8?B?MWNEdlZKOXJLVnRxWDdGa1pNSDYzM2NMY2ZSZHpkeGpXTFNCMFVHU01IZEgy?=
 =?utf-8?B?Y01adEZ5bjVQZ3JWU1NoNjdlUFpleFdybGVieDA5dFAwdFdZRVM5eXhBdkJX?=
 =?utf-8?B?QlorWVpRY28yN2N0OGxFVFdIRTRRS1RTa1JtaWZzTDA4aklHbHJjTWlCd0NW?=
 =?utf-8?B?eUMrcytnRjhuTkgxVHBjZ1RwcGNBSm9NdHd3V0w0VG1ianN3bFFUNFp4dTVv?=
 =?utf-8?B?YmV4UVhlZW52cURNcUZlbHVHNytTbFhlUlVPL0piVGlTWERGR3hsYmVySlFH?=
 =?utf-8?B?TzlnVmdYYVNuMThGTy9CbWYyRWIvekVMdFRlNEhPUDBWbW5pNHY0L280eUp0?=
 =?utf-8?B?QTkyYTBkYktDeXc0YlF5bmdzNGlVdElucTBFbmVZNGNqUjF1TDgyUDVlN2xL?=
 =?utf-8?B?TXZLZHMyYXZsZDhKNU1xSG1qYjN1cEhyb3h2bEsxK3B0SXhtM0ZLay9Dbnc1?=
 =?utf-8?B?RHN0ZFhJdU50WGEyclVxRDh2SjV0YVBXaEp2WXhKZHZ0SVNlQ1MyaUFpQmVt?=
 =?utf-8?B?V2Q3TFh2eUxvVnNMS0RaU3lpUDR0ODlvbERDdi9NL1UzdzJjaWMwMFJuN3Zw?=
 =?utf-8?B?dVZrV0VyODBISlk3QmRFcmx6N3pES2t6cnk3U1RGN1h4TjFTd0lDQlVRNzZm?=
 =?utf-8?B?eHBuRXpwZC9rR24xL1NLbDg0RG1JRE1rbnNEbmRIbXljb1pmaVNOajdXRSsz?=
 =?utf-8?B?SEdMWUNyUXFxODErOEsvM2dpOG51WHVQL0NrdURPQnRvaXVOaUZDUm5IOFBH?=
 =?utf-8?B?REJvOGNwbmx1K3p0TEs1Wk1NcjRxN3BFV3NrWWQzd09FQXNicjV1dFRkUk9S?=
 =?utf-8?B?aUJVWGpqZm14UmZNbDJ0cVorSEE5emhncUc2SXNOZHIvRWVKa1dFRWRIVEh3?=
 =?utf-8?B?SlRnazJCNHBNWnlRSStvYVA1bnZ3RjlzTmdRZzE0Szk0d0FqRzdLWm5lMkRk?=
 =?utf-8?B?SjFRemtpN3Z3MXh6YXZvMFhJOVJwaTc1emdOQkFEcmluYndBRXhwMCtyRHdT?=
 =?utf-8?B?V0ZkVllBeThndzN2NWpGMEtmdTBjV2ttNVgyKzY2ZEJTMk9DRkMwMkR4eita?=
 =?utf-8?B?OGgvaDZJQjdoK3dibm1TMjh0VjJ0d3Y4ZzhJb3ZNSnVsaU5YeEpHd2o4T0Z5?=
 =?utf-8?B?aDRKSXhxUXJOU0FyRThXRnN6WjAva0tlM2xXaS9JMXdxeHU0dGVyTXI2YjZP?=
 =?utf-8?B?b0o5M25odWdpajgxNzZIVVRqaVNSNFJ2YUdJc1hEVlZydE5UdXE0NWlldEN2?=
 =?utf-8?B?SjZXKy85Wm5nWjF6ZVZaY213cXlwdysyWXZweXppZ285RHAvTWdzcDhzUXI3?=
 =?utf-8?B?R0FqMWJuU0RlQWFnOWNyait6d0UxcG80eUliMzQ2ZmRkU2w3b2JJRXVaMjVR?=
 =?utf-8?B?TjBOU1NoajBVVFhuQkp2dFlTN0c3bnZIcGhRVEIvTzZXS05ER3NmTTBMbmo2?=
 =?utf-8?B?aUlFbFVnOEUwSFV6SlM4RDMwRkdYWlh6MmRTcTVuZVBhU1c2SkZ6SzMyOGdN?=
 =?utf-8?Q?XM8ch+9lKHzxTNp/HcsFtFE=3D?=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af45aa89-bd6a-494a-a6fb-08d9c6297c97
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5626.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 15:32:53.7782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8v49Bb3sPbth4PjVZeERkKX30NJFMClLLuyaqGqNkSjwE1D0QH9ruZATayydARHvBwe3xSvMT3dv3H8ADSaOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5594
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Previously, if a lock timeout is specified using `-w`, flock() is called
using LOCK_NB in a loop with a sleep. This results in two issues.

The first issue is that the process may wait longer than necessary when
the lock becomes available. For this the `-W` option was added, but this
requires fine-tuning.

The second issue is that if lock contention is high, invocations using
`-w` without a timeout will always win lock acquisition from
invocations that use `-w` *with* a timeout. This is because invocations
using `-w` are actively waiting on the lock whereas the others only
check from time to time whether the lock is free, which will never be
the case.

This patch removes the `-W` option and the sleep loop. Instead, flock()
is always called in a blocking fashion, but the alarm() function is used
with a non-SA_RESTART signal handler to cancel the system call.

Signed-off-by: Jethro Beekman <jethro@fortanix.com>
---
 iptables/ip6tables.c                          |  7 +--
 iptables/iptables-restore.8.in                |  7 ---
 iptables/iptables-restore.c                   | 13 ++--
 iptables/iptables.8.in                        |  7 ---
 iptables/iptables.c                           |  7 +--
 .../testcases/ipt-restore/0002-parameters_0   |  3 +-
 iptables/xshared.c                            | 61 ++++++++-----------
 iptables/xshared.h                            |  5 +-
 8 files changed, 37 insertions(+), 73 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b4604f83..46059785 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -725,9 +725,6 @@ int do_command6(int argc, char *argv[], char **table,
 
 	int verbose = 0;
 	int wait = 0;
-	struct timeval wait_interval = {
-		.tv_sec	= 1,
-	};
 	bool wait_interval_set = false;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
@@ -994,7 +991,7 @@ int do_command6(int argc, char *argv[], char **table,
 					      "You cannot use `-W' from "
 					      "ip6tables-restore");
 			}
-			parse_wait_interval(argc, argv, &wait_interval);
+			parse_wait_interval(argc, argv);
 			wait_interval_set = true;
 			break;
 
@@ -1162,7 +1159,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 	/* Attempt to acquire the xtables lock */
 	if (!restore)
-		xtables_lock_or_exit(wait, &wait_interval);
+		xtables_lock_or_exit(wait);
 
 	/* only allocate handle if we weren't called with a handle */
 	if (!*handle)
diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index b4b62f92..e6144c75 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -66,13 +66,6 @@ the program will exit if the lock cannot be obtained.  This option will
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
index a3efb067..5b238d3e 100644
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
index 759ec54f..99252884 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -373,13 +373,6 @@ the program will exit if the lock cannot be obtained.  This option will
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
index 7dc4cbc1..ab0a417a 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -707,9 +707,6 @@ int do_command4(int argc, char *argv[], char **table,
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *smasks = NULL;
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
-	struct timeval wait_interval = {
-		.tv_sec = 1,
-	};
 	bool wait_interval_set = false;
 	int verbose = 0;
 	int wait = 0;
@@ -975,7 +972,7 @@ int do_command4(int argc, char *argv[], char **table,
 					      "You cannot use `-W' from "
 					      "iptables-restore");
 			}
-			parse_wait_interval(argc, argv, &wait_interval);
+			parse_wait_interval(argc, argv);
 			wait_interval_set = true;
 			break;
 
@@ -1140,7 +1137,7 @@ int do_command4(int argc, char *argv[], char **table,
 
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
index efee7a30..c727a301 100644
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
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 2c05b0d7..a524622e 100644
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
-- 
2.25.1

