Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CAEDC25B50
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 01:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAXBse (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:48:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAXBse (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 20:48:34 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2127.outbound.protection.outlook.com [40.107.8.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58DC16AD3
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 17:48:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxHTts+K8L4Xu/uFQVW3e9JxlPTzPOva8XMz4vDJwI9W0cEd552vSMZfRpei/QplaZO/9787P/K5V/3kMoVmQMlSm35WEFhgPrLEJamH729b2/UrtUawd4P+Ci+oOES4AczxfxQLaJm+YypVpyh8rGvGhNPven1YlenM7FlixH0jCJQER5EBoXK8ErcN0OtLrYOJ4ZiOxGQHFkyNEa2lVT89XGFfaPNrzMEeY2ydAft7zBtwlMqOvoKFHw7/r9+sZ9WFMVUXs2ry0c6aq19Kwrfi7yDo7FgRpeQqb70hEfBXzDPAX0FTdo1r7RwvpSLdgAaKJZshE/EH/bkJQ1jtNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkNuf94DklwDMI5dyJKXNRm8W6sBjB/YGU6217SyOp0=;
 b=BMmy6kX/pgTIY9bxodtzvdlTeYyW8PTSaMD648YoP7AdyNxMhU+JAqkjQKeoryqTKTwDZDQFvXkPDTsweX5juGz08BjchTKNUGI2AvC0z5DgT6QXcegLvwslw5q4roFCGawAYNEf+MK8qEGSRPAk0XpnZ1cV/UMPFF4E/9BA2Oshv1M2hpEK4G+nne24TdPCkUbOi80DHLKOwr7qNJfJdlaz0sLE2cJG9pvGyACZuS2bdyTdr2V+HUdylh/Ri5UvEhlt47pWSQfX3+19mpSQH9jL7UyvMcQCcNTcKtg1fstJ9KZYlMKY8sj/bUW7dJGCf3rla3v6T5LUFXM5yBLPIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkNuf94DklwDMI5dyJKXNRm8W6sBjB/YGU6217SyOp0=;
 b=eS8zzA6oRdtt++4OqxK5kloGYHANZGer84l28uRAUjzLry6hjnm79r+VB4qDpyrSz29gXIUtsU/GVsfIU3jlA6TYpiOyVvZK7Nql/Wm8R4+liLfaIZbjksCb07PRUrUfkZZ1weCgZK7j/BfuZ/TSH/LfK60opINjX2stbaK3McY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB0821.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:122::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 01:48:28 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%9]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 01:48:28 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v4 0/4] sctp conntrack fixes
Date:   Tue, 24 Jan 2023 02:47:17 +0100
Message-Id: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0102.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::27) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0821:EE_
X-MS-Office365-Filtering-Correlation-Id: 545b6063-ad28-4d7c-0f9f-08dafdad16a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vcbc5uuGze+o7tgUUK9pn1i4dv5uGnnB1eW6hg/EnACFJ1RNjOxp7VHR9EJ0zxDyPYFuwQ5mA8e4B/OGty+e1RlhCi5RwhFvdo2abghI6CxB2GMp5URj6J/k+UyhTbZQ7oLimPPqBTT50VNjE7O0dbmjPSGlVTpBVQH8UmFlaZdCYRApCR2E1+mFl28b6/DrjClco+ts2O4HMxBF4AoQP9gsk7zixOw0EhtO5GUvYNp2NOoQKZjfg4dUMO5v6/tHJsfSq6JkJHrPoCkZhAtKRu7maUxE8wug80vaeKx3Wfwba45bAsXIijj29oqDRGJ/jSM457vLIw8Mgvj8E0MWP7f6jp5QKjC0VBT9GUz/J2OwYpReVPgvkujQJd0BH7oZEQIgML27XLH0hTFYM7lyVA7K9WhC6cd2h5qpz8dp8RuetDGZwQ7W8VUxtvrBb+5PStFk29UbnbXtBoEyQjUGKVysqhJt8iDDVlJbIOfP6Ok3utDFviVLtO1kHeDHRNVKMvGcFcIlzMc2ORBNQkVSuiouQACIjBgwRVORdklwFDMWLmbBQFwBAThDZgddrE7HdlnM8u2wUdzr81N9qVprVFO+3Gf3By0JnBn/0cb8rsrBcVH5lHzWm1/vPbvhSrR5zqi06lMNBUwx7TmDnpqRWCtZXjpcXXpjw/dylpJ641sbMnVmJNZLO5dWGVoBWHNHoDxsnxzVHvhnzmpYyNLmj8vRf4xjfJnBE5AmImi4cag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39830400003)(396003)(376002)(451199015)(6506007)(1076003)(38100700002)(86362001)(54906003)(966005)(478600001)(6486002)(316002)(36756003)(44832011)(83380400001)(66946007)(2616005)(26005)(186003)(6666004)(6512007)(2906002)(5660300002)(8676002)(66556008)(6916009)(66476007)(41300700001)(4326008)(70586007)(8936002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Aqwy2veA6NsCWqG8VnG+EF8vRZZ85F+9W8nFPWEe7i4BC2dBlGNIE3nLTvho?=
 =?us-ascii?Q?6JbqKaY1siSkGs8AjYtI6q0Ltzu7uPmNKcUyB5wKp2p5EA8wCRSkqLm8LUZb?=
 =?us-ascii?Q?DIEJGIRQPEkfuNskNAyhLgY1XQFaJibFwZBF2naIk750cBj867jEBL5uUM+5?=
 =?us-ascii?Q?knnP9a6Kfxqy8e4/peHLyka4rgnuLyWJda2ldcP/JHq/atFvhTXIwdT3CNZR?=
 =?us-ascii?Q?O5DW49wXJAQtOMtSgBkvvMKC8zuPm5mMyusOYFKepCC39dGvUiBI9QxnHjuY?=
 =?us-ascii?Q?6/MPmwA0M1iNjIwaggpdNO3zpjJtQUImqQVERseGLeW7AO19ItSttas31Gfz?=
 =?us-ascii?Q?VW52NyyIJGdWj+GXmOwCK75FnVflwIOESbzUxRsCoUkQclw/TgfehUYc6VkC?=
 =?us-ascii?Q?oEp63rKFImKsaHp5N+rikUbQRbUhlv36xBmgqNq84KzSni8dPOWAyM/fPY5o?=
 =?us-ascii?Q?D6xubkg/pEYIgOztL+Zqk/Q8VASCOniCeFjzjF+G8fCTpIQg9Nzz9oPeDSWw?=
 =?us-ascii?Q?hD3al6P1gGHwaRkfydICo5LMrzyQfcMqBysTZKfYnRIXq+lO0lp4D8LK0sNP?=
 =?us-ascii?Q?oe6F5cMCbTRSmUD0dJnQF6M/KaRDkwkZ5D3xhdt+GssMgTEKj8i/arNOvu3M?=
 =?us-ascii?Q?hFTRqrVJ5aLH2ERmwL9J86vd8OG5e1JHkENJapx5bvtZgvbQAXuVUKtvhRnX?=
 =?us-ascii?Q?HvlAuKM9HqLi0voDez8ExT24YxNGXTbQ01f4dmwYqnxJ7RGtntizoXefhQpV?=
 =?us-ascii?Q?FYy5XRDcqFepD0/HoFXHIBXns+d1jAND//LSXYdwnS66VAYrB5ZGIX1/QgMk?=
 =?us-ascii?Q?evCzHLykjebhkmgS/GD5VmL3TtExQTGWE/wZylta97xOU9GfQVgyJMrRFQIx?=
 =?us-ascii?Q?euHg7B2JqNZJA+rXpLiQZBMHgywpBGAOzbxCwW+tn/4p+UKEQsdeDCcN58Dy?=
 =?us-ascii?Q?rRhBXKbn/J7ZN0MMJrqNQsUfIfDG3aIvBU/eTi4zyUTZxhw9t8U4sEN/c82n?=
 =?us-ascii?Q?vXwlwXTTwGJRt/MNkxzEdNoZJL/CEZ6RzkItpQkJPCoK5QLiRNbeYFNceFyd?=
 =?us-ascii?Q?qHY2J3WmYxuGOTlWCAENADfhBkwilhPRZoauvO8eCsjdCIsSdACfB1XRKqUf?=
 =?us-ascii?Q?/o0ShTAGwmJAn8sFjMNTvd2v6y5JY1imF35hNj75+NbMU4RQNQY2nQXURL4F?=
 =?us-ascii?Q?GdpqJWuZl4B91IMLvyRU1GY1F5qDBtKNGc1LP0pnbO2stKoHvP1WUkV9gwjn?=
 =?us-ascii?Q?8ZeGUDCPpabRa9s8dLUOHmBndcATkcnI4dgZrgqDdVgUgExsHSGXKAnB266q?=
 =?us-ascii?Q?a7i4olVmZYe3SMi49EvU6B8mBfEFqavzjvPTAUACEYSC+fVa0ljxInHHXhbh?=
 =?us-ascii?Q?8XVSDi17HkB0cJI1ed9OxxngZw/PRie86t8Vo2PHVwavVu72EnV6iU8sInUZ?=
 =?us-ascii?Q?TehY9MFQIn5eOjA9/q0rptiqBRnat6zKuafoDcgnIev+m4qWaC2O3gYBriEI?=
 =?us-ascii?Q?c5L0YJLbz8OwmoYIbPIbg8hoxCjwGMrUnUiCcypfEsF086ii4lQG+H3A3Hp/?=
 =?us-ascii?Q?stMWYeNMRjRBnnzuMuX79JKR3fOMiqoP1r+olbeTDoH3ABA7jcilw+2CrZVm?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 545b6063-ad28-4d7c-0f9f-08dafdad16a9
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:48:27.8943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w9D/Dz9lN+s40auTXpMi1kxvl+dktA1/LKrUMQzG8FKXOCyFgaDm1vPt4rDlwaDkBqBTaxPgI/o4B5Ckr3g7zmLZcGDhJb4BFwSWdZqCIfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0821
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A less diruptive change as opposed to below RFC patch:
https://lore.kernel.org/netfilter-devel/20230104113143.21769-1-sriram.yagnaraman@est.tech/

This contains a couple of bug fixes to existing bugs that were found
during the review of the above patch series, and also a patch that
unifies the ESTABLISHED states for primary and secondary paths.

Changes since v3:
- Set assured bit along with the existing check for old_state != new_state

Changes since v2:
- Remove UAPI changes for DATA_SENT since it is only part of 6.1-rc

Changes since v1:
- Reverted bff3d0534804: DATA_SENT state
- Set assured bit if new state is ESTABLISHED and direction is reply,
  regardless of the old state. Paths established by HEARTBEAT also gets
  the assured bit.
- Update nf_conntrack_sysctl documentation

Sriram Yagnaraman (4):
  netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
  netfilter: conntrack: fix bug in for_each_sctp_chunk
  Revert "netfilter: conntrack: add sctp DATA_SENT state"
  netfilter: conntrack: unify established states for SCTP paths

 .../networking/nf_conntrack-sysctl.rst        |  10 +-
 .../uapi/linux/netfilter/nf_conntrack_sctp.h  |   3 +-
 .../linux/netfilter/nfnetlink_cttimeout.h     |   3 +-
 net/netfilter/nf_conntrack_proto_sctp.c       | 170 ++++++++----------
 net/netfilter/nf_conntrack_standalone.c       |  16 --
 5 files changed, 77 insertions(+), 125 deletions(-)

-- 
2.34.1

