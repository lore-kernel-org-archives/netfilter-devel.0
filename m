Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD27EC05027
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 01:48:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjAXBsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:48:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAXBsc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 20:48:32 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2127.outbound.protection.outlook.com [40.107.8.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A0F16AD0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 17:48:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIH5g8/CwBSgvm+Jv+uGR1YpdBBIRC32DbAa2RmWCBrHSh4VFVI9u0Dab1KPmBk1+lIbotARnPJQqfmVoD8v6FcZrpkYrabn6i44zr/M5AZxKfrwOUbswO2rKm/i+ae+JUAqWBPs8LO6dSZXJMbrDo7fMhgeuiKmvGhTGicQ09bmNan9yh1fjp0w7iDGlLV2zzqplIO6VLlyXEFRayYERTa8X3jrgsZl2ehYpJeMWyxJK+mv4Du1su/vrLwJgotWFmP5dcBX/4K4s1oSS2csWtxpK2Cq5yArKk/XTciWBi+6PBvQQDoJ17QHgfSeNovxIdVlLzb4hEd6N4hGONEEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z54AAya4XqKs9eIKXZS8y6AWSnH7k25CsOzlcwEPYtw=;
 b=nWArvI7BdXET7P/54NuXJzvhb94x1rYqIubQicHf/pALz0l9eWv9Bv6RHbwg8jb6gtQR17tWpbuUmNGoKjkl734C//1F4wFi/wl4awUAlXamlPj04aEoGQuXnTgUO5AboDz93oR8dbq7hqgtY1qIEjgaIHEyqIdeYeiJFV6SGbwbj7rsQLfTy0TAWOdbADTEqmgLTXkHzO07rgyvCwas2Li4GQ3Jv6V4cP87sn/ZnbiTZbHB/B0i1MxdQmeKB124ShtmaGxA9k//BPp0vNBZiNxhBiCkp22dCk3kKlPbPvImpY6qUmBXD4SRZGsYyoLT9nQDQO7o/7hu8JqZj/e7jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z54AAya4XqKs9eIKXZS8y6AWSnH7k25CsOzlcwEPYtw=;
 b=IE2gVI9lx7F5VOMT4K2T7BhoOKNFlE2jpE9G4LL62TCwepK1GumoZw7imM4Sofp0jhCAidskZXJ5lCRGJSBhLVSAXyN4JqWhf89fWA/DyIIb7uI7EVfyP7JZKmHMeB9VZIoRrc2kaWPOUVZnWgy5ejEQ6zSQ7un6giOMLEVNtWo=
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
Subject: [PATCH v4 1/4] netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
Date:   Tue, 24 Jan 2023 02:47:18 +0100
Message-Id: <20230124014721.6058-2-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
References: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0097.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::29) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0821:EE_
X-MS-Office365-Filtering-Correlation-Id: b4b3eaac-74a8-4678-f884-08dafdad16d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1UNCHCVQNykOfzajT72iuR7euUTCfsIFFfOPPErK90pbic92RphpGzr7DVGrm5CJ7znCI59NjNMcGdxmHWla4ZCsai72RXBrb0gMDsSYd1tYPlg/uVp3kYqWzl9gna44FfwzJm9V11+VrdcqXr++EhYqbd+Y9sYYXfkbKBjOF5jafIv/8lnmMYunf4RbVPMU5PpZYvOiST8txd/W2DMzIKAVsOohQ3xWKrmheXLBFGTu8ppNJgikj9UZOPjqPv8C44MqVQ9+02rn50BO5E/nX4D6ozrml3UWPDUsckUcOI8HCl8PU6IP3fFAhFBMOGpnTZVSzhHaFY111CIoSllrevxsbai+Vud4GSJ2GAN3OUBtONv+RYvjcUpW0lLUfQeJpH44doLRXL4KtEkLxc/NdIOQmsk66iGuegIf05658KYgsyQ/j7kAYML7ZPFHOTCQKwB5ZA2VFJNF2/hL7FJ0sVTOrMUrXWQvBhkO0KeZW0jox+TiXtRZu3YxH/QvaFx00cerSRkswENvXrsqIwZKZOblxQ+DFw0a+kRlNqo7InMKhDOJskP9SyC9tQ1cMzcOa6GTrIdC3grPRt56elDwiuxPCkboDtAH6vrtMq+NwRbpBmgTD62VlVxpmO9p0yjcCi4ZvKh/90uDh73x2mmyYPgOd4nR24wcLTRewHl7c1/n3pxRpMAgJCkFt0LdBy+uJ+cC5QDq7Qlpf37OTzyXoQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39830400003)(396003)(376002)(451199015)(6506007)(1076003)(38100700002)(86362001)(54906003)(478600001)(6486002)(316002)(36756003)(44832011)(83380400001)(66946007)(2616005)(26005)(186003)(6666004)(6512007)(2906002)(5660300002)(8676002)(66556008)(6916009)(66476007)(41300700001)(4326008)(70586007)(8936002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KyNK9G3/SfSZ43WNJF9SXELskW5q4d2x0CnGXMkkMSOiEo2BaobGyBsB8ja5?=
 =?us-ascii?Q?F7aelAL7waAAUYh4MOOL6xyXfAcwt5Hh/8f4VLDK+7w7LMWn8lzvtXqLzsuq?=
 =?us-ascii?Q?9VsKRvowr/BCXImgwInTuPv3cUXY8PbikC3bq1kGT4V2mRqH38VzEN3iU+i/?=
 =?us-ascii?Q?abesMqSQ/hgWsQGRytuaLnbr4UYWykL/1JKCtMuEtgYTckdZx5X1ZVh2dZmt?=
 =?us-ascii?Q?LX3Pj0BVoS9YL1G3fljVBPbCjsuFuK5qCVGUZwtRLKw4tQNyxn2UubfWqmUE?=
 =?us-ascii?Q?68orUcx+QaAbXRHVleStQXiO6dyBucTLBnHw2tWFbisGdSGQR1R2f2zCi/Mb?=
 =?us-ascii?Q?QMNUKgsC9Dfl7bzIqWjWUz4WmR/1Kj/RMcL64b+E9PiiBOgVfEReVyVytKnD?=
 =?us-ascii?Q?FocmdUpeHdx6UKlWpa5E4B4w6BGzPg1BvETRyHnRu6O0tuTAfv7kzCXeHP6+?=
 =?us-ascii?Q?0X3AD4u9oOH7MdNTozK6MkaaOB3T6BAHG9O/vjNcwWM4CWRvZdbST3/FC38g?=
 =?us-ascii?Q?bM3U4TsAiQUDOJOGmsI6k61EpM9mV5xW3XEvOBZ6zEocJIbZWnPfdqkmZd+/?=
 =?us-ascii?Q?XEk0gqBh2Jx/pI7ZgX/NP0D0IY/Wp0s9Zo4ePIIr+jDpD1UKkTJMSMPnGvV+?=
 =?us-ascii?Q?osrGghmZTGk0e8vQtMolUAPJbcKel5nGLQmF1TrAqI1H1bT257v/ho+9sXeO?=
 =?us-ascii?Q?bDycnXNuYZO2sw9vmnUZzE9AuoY7+pR04qECeMTrvC/l/CID+rHrEaDuCmMq?=
 =?us-ascii?Q?7Nq+PVhUeQaZQJ309HPvChtOKl9wptcQHV22GzvbUc9QOqYi+JKbXuHivGAM?=
 =?us-ascii?Q?1A9/Kp53e5+Wy7BHcb6h11SL4/amHy/6ygSmJAn1y7Nfo4epvCX12S/kKUEB?=
 =?us-ascii?Q?UPuqe+v7iX6nePoEdwz9rfvXl6XC3UUBomJgMo6auxJjNxmCgs6b91cXqg7/?=
 =?us-ascii?Q?pZu+8sNXtph6BqchEALvrx9WS20ks1Yfqb46I33ZkuZbBVjuMP6BF6/C68ee?=
 =?us-ascii?Q?06ehEcmVu8qW5EA/Quk3HQaQewmsRBVGti/ESzKTOWTGYcdvrbOMnkf78oaG?=
 =?us-ascii?Q?9qlDFcP1eVMKsPvqDdwM/bVOJy2LUuYevnbRZYwd/5yIeLC+Mr6wy3fW4Uwz?=
 =?us-ascii?Q?mjjGCxC5tuS95SLEIbosSIkDCZBIn0GTOWVFGxhi+HvIHheRqun82HCPzYnk?=
 =?us-ascii?Q?w+pUQ0VRdxLoc2q/V0yWnJ6uALyX4/s1c0SCS2umnrA0eGa+XNQLvPjHARhr?=
 =?us-ascii?Q?1ZE3k+3vWK6m2bs1i0vqu6bE4Bdw0jN5SpJ9AfWqPiSSV48MfvloGf9glO2o?=
 =?us-ascii?Q?xYxd7YE1QTwZz5nwWJdao7lsBvafjtQOv2/xPYn30qDF5KAvSEX5NqjmYmr5?=
 =?us-ascii?Q?2wdZlI1Ij0t1PJ4lhneFBYgP9LNXrpYvTvTqNmmg6YYpRTX6x1fAHYWiXNbb?=
 =?us-ascii?Q?V33euhEm9GwUmSJYvvqxyNAOY9de0C7thaAbZp348fqs72L/M+fG/8alXNkw?=
 =?us-ascii?Q?g+e1+IIkrhhzVps8l8ZSQD3qSN8RWyCUPMSsiQt7YNOC8JBlOqer02Wf0ffx?=
 =?us-ascii?Q?dA0mGFR4NDKxhpPJkXjlsjVQSlYOAm2q6k4HCg6YHA5C+A1FW77fQ5J5Hs7z?=
 =?us-ascii?Q?IA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: b4b3eaac-74a8-4678-f884-08dafdad16d3
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:48:28.1599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +QsDdTL9lQBoEyuVrXdqsxkUy9Oke7+/iJNR+seySYupfXwsvbMWKocnLMRouE4YNzHvSzboKn3Sjcx/Zo9JKse+fYqCVp5SujzZKLC8AkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0821
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

RFC 9260, Sec 8.5.1 states that for ABORT/SHUTDOWN_COMPLETE, the chunk
MUST be accepted if the vtag of the packet matches its own tag and the
T bit is not set OR if it is set to its peer's vtag and the T bit is set
in chunk flags. Otherwise the packet MUST be silently dropped.

Update vtag verification for ABORT/SHUTDOWN_COMPLETE based on the above
description.

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d88b92a8ffca..2b2c549ba678 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -424,22 +424,29 @@ int nf_conntrack_sctp_packet(struct nf_conn *ct,
 	for_each_sctp_chunk (skb, sch, _sch, offset, dataoff, count) {
 		/* Special cases of Verification tag check (Sec 8.5.1) */
 		if (sch->type == SCTP_CID_INIT) {
-			/* Sec 8.5.1 (A) */
+			/* (A) vtag MUST be zero */
 			if (sh->vtag != 0)
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_ABORT) {
-			/* Sec 8.5.1 (B) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir])
+			/* (B) vtag MUST match own vtag if T flag is unset OR
+			 * MUST match peer's vtag if T flag is set
+			 */
+			if ((!(sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[dir]) ||
+			    ((sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[!dir]))
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_SHUTDOWN_COMPLETE) {
-			/* Sec 8.5.1 (C) */
-			if (sh->vtag != ct->proto.sctp.vtag[dir] &&
-			    sh->vtag != ct->proto.sctp.vtag[!dir] &&
-			    sch->flags & SCTP_CHUNK_FLAG_T)
+			/* (C) vtag MUST match own vtag if T flag is unset OR
+			 * MUST match peer's vtag if T flag is set
+			 */
+			if ((!(sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[dir]) ||
+			    ((sch->flags & SCTP_CHUNK_FLAG_T) &&
+			     sh->vtag != ct->proto.sctp.vtag[!dir]))
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_COOKIE_ECHO) {
-			/* Sec 8.5.1 (D) */
+			/* (D) vtag must be same as init_vtag as found in INIT_ACK */
 			if (sh->vtag != ct->proto.sctp.vtag[dir])
 				goto out_unlock;
 		} else if (sch->type == SCTP_CID_HEARTBEAT) {
-- 
2.34.1

