Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D116BC54EBE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 09:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjAPJgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 04:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjAPJgI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 04:36:08 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333B717154
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 01:36:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E38m9TVdgDbyG+TZRYBYv20WGTHIEALLhxiowRhH9LCUQUJ1W51hgfi7s7WRssxToMcBpKUVZF3BypcktTVGwVSOgBJu7HKpi8hDwfNvR0+K/3+FlozVDQr7G2F/KWTnDFbm84rpO9UhQvOH2jX1mnoPAuna/Nlq5K/u9xb8dksBu6JhP+4bcM99sULhNjQHgVr5S3XVJhGoU2dsdUxuWvk+w3h9APnwI3FzBD9aEYjPjTS4w5fJdUR+PlQqINvHGFl5WePjRh38zdsKVCncjicbIZbdJd2+iQeZ3xKUYBVCQ3aWw6Dh+FwwcZb+5x5pbIGKlH4tIArTNjlLgfLVig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/sSzc5Qc99g+ogw7Yt1MRxksQamVuVFDlbk5JDyukLQ=;
 b=hyyOVSglQjeCHZXmU6PLNp8zIU85J1SdA3/hgbriXmeeT8UXTe0kPttQD8G6NTex9R5rK7Gw36G3iMOfKmyRS89+26Afbelv9Nw9y7Gj/fwY0jAoJFoCVEWVY+JTo78vOjNYkXRXiP8CRzDSP0EYfGhBB0n6bgyizXnv1G6V5YQwpvGRYzaOTLDjemOnwvjbPdG9qskwIjJ+glgBKQjMiOOU15WQk9GkWaZGGbdUXCPUXd5HF+y4KIopOplOKvG91ZWbatKaXSsU1SvBkKi34XsjxYS3glZEe1jePXhrA9iMOXEN8tmriHEbHIFHK9bDp1QFg/uesGAVgVeCn1gi3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/sSzc5Qc99g+ogw7Yt1MRxksQamVuVFDlbk5JDyukLQ=;
 b=a5YnMhyBjDKfzHwQgvpUQ+ckP/OpLUWtmx/MXI+5wfzQqAYb93dImwW8imnpJSuLdWqwbAIbrRdE4O68RglDjprc4PQ7B8obaCRaD+7Bkt0uGBh30SwrjkvnK4rqsKYDeIeKUyxsSQWmeAOuwDLkOAHSWOb1ol7+vWuE4goeJ5Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB1012.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 09:36:00 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 09:36:00 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 1/3] netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
Date:   Mon, 16 Jan 2023 10:35:54 +0100
Message-Id: <20230116093556.9437-2-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
References: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0027.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::26) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB1012:EE_
X-MS-Office365-Filtering-Correlation-Id: 1597f3cd-ae8e-4f93-897e-08daf7a51412
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngfzWeJE5WcQoCD7YvHpkp0diPRun8/+tq8fZ7o9cZZ1Z39dbof5QVCn6b4GVj1kmjJJx2zMFmeS/VkY6vs9TaTrwkUBsZ8ugL4JLTYvcGFRaorfQN9XjPgITESztqg+oNopU6EA6p+k1Kpp3YnBZlULfLaECE3gJjZDncVLzlFn46iHAAnkEoj82xrJLwzKiD2oMsWinR0MXT6SXLu5d9H/DZBFAO3+gd3jdpfaxK1r2wIgd60cUbZiK8SRbCBQXISqSBry5iYqr7CA8rCuX8mZI+5yzQLFHKaxTaOxivgNSfrz7QFkniY2qTU07KnxyIkotgAdmBgKER8hi+A3xLiV297DXstln0LjPCukMYqCPAY96OyUcgxee2LoE8OdkyikgMHcjyPA09TV2Bbbd6dGPWkZetBQK1/ARUHNWA9KOzjGl90GliYjSodLhUPIKl7zfA9wZWIlMSma+GWTXU+lleEatT48Sneqk3FLVZTlyblOwPT5q0OmjgDYyqzJT+FsmKGi3byqgtlUEXLMoQJt7PC2bZ7M/xsDAgpidT+Xh4ueH+0DOmt8DtbzNbGcvo1mnJTNAqwzXqfYlBX1B+CqtsB7FiYOy5YNmPQX1PQ8pbWQTKJVuo6rmsFUuNudtk9hfWVdt7kyjB9OTJevbWXhJ52+S1dzL1GSWmdpd7F5HDy1TW5EBKzf6M+FlB/jnR2dOZzNVMIwUDYRwAIq5g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39830400003)(136003)(451199015)(6486002)(2906002)(83380400001)(478600001)(86362001)(26005)(186003)(5660300002)(54906003)(6512007)(8936002)(36756003)(44832011)(38100700002)(1076003)(2616005)(6666004)(41300700001)(6506007)(4326008)(66946007)(70586007)(6916009)(66476007)(8676002)(66556008)(316002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RrPow/GMvfhQ+fErM+JkgrJV+ADj4/ypcAInmWQ5OToVaTMJUhZH9xG6H3HD?=
 =?us-ascii?Q?w7RxDL8aQ+YvM8xPNZUexUKqbcxEi2uzqx2/GR2VAKUOCodGaItv78SYIA6S?=
 =?us-ascii?Q?VmMQoda1lo9vNmiyQce0zNS9kfF03BHg3YRuFs2/nHSfb+5GycI+c1GnUQGl?=
 =?us-ascii?Q?afFjX0Np1/bsSc+x+SK3flDJxaGkplXLXEUwuC/OSLCkZn9MOidxrvQ+c0eN?=
 =?us-ascii?Q?53Jy2WeUg0brs1M5AC+8kAHh5Qpc+VwMlcG3HYizbgvRZoQlQio3V4+7dR3U?=
 =?us-ascii?Q?deoV9jF5sLkYLpqDoSKdKWyQjhVC6A5VYeiuVdb0Lqw1B2nEvpFWbnz+k5c3?=
 =?us-ascii?Q?9CvatqBs+zExdkVadSApzeEebKr+uHxSZj6Mpm32rZ0HFOgtBn1Bo4O3n0sy?=
 =?us-ascii?Q?XanHw+ILy5Eh6vmdVkMq6gyi4IouMnqt9n/4+ABOYZ/T5/BiSmpW3D1IQ+vt?=
 =?us-ascii?Q?YXL98dpBaXf6ZEakgPtAvyqotIKvB/RoAjnkTZ3v5dB8++P+Q12OK06IMYv6?=
 =?us-ascii?Q?CGP/D8mzIP2EzZ+HBFnRPQigl/xmJGGx1xl1qo4AK/07ExX3sm1+6StW/nKY?=
 =?us-ascii?Q?4PmZEPCPqcp7p5zDgdj5xtn32aGbi3ScbN1b3QDye5uTiH6Ib3wl1p0ZAnIE?=
 =?us-ascii?Q?eEOoTv4dg3daTwuTde7PiqmZvSyboYbNeTM5F/p1SpvHZ7ZRaM219paCIuRo?=
 =?us-ascii?Q?WQ3pBp3eBC05nVLZrDkZVbZGMkatQ4ObCYEsyMxBL7IBBojWxlSYDZbKJ8Hy?=
 =?us-ascii?Q?vcB/hOokamwdfg9AdcUa379hP19LKWzBaUDUMj2GXWnlDlZl64JiO/Df9Ns4?=
 =?us-ascii?Q?D/+HY5veZm8jXAKtypKyIwV5aPSZ1TfgjNfXOD427HY3H1xUvEgw+wmZzfz6?=
 =?us-ascii?Q?6o2XQlIB5gVUgXiSRtgVDQuewa+Dkf/3LZW5ypNXKd2byy2g+sWsPTRbBnzq?=
 =?us-ascii?Q?DznRCcGkduGgmWCLBqJlx9/Bj15nWTXI3wZAaDBfLTsxX3JH+YDS77zpGWs9?=
 =?us-ascii?Q?CV2e4W3CDRHzn3zzb3l84ffPh3cEelhiex/nSE/xaQ4NdnQa7YT+nHGxAKF5?=
 =?us-ascii?Q?xO1LxdvAQfFOg76w58ObYV0wcUxokjnXNVP3Qp782ib/JtbewQCgkpSYTBKh?=
 =?us-ascii?Q?U91mVxF/vHbq86r2Beab/yU+FGVhnSQw6vYUSWX+fPUaT9uOsmeU/dXoRDNX?=
 =?us-ascii?Q?KFTugYK7/dUr51n3TTf2xw/dsdnixTQZXXZCFIOxNclViqWeN95VzGzHPvrA?=
 =?us-ascii?Q?IfT6wkB7T1bB/3X1adKG/EpBXqgn1aDw04eDDm0HohlQ9uM3VOECL+tSVuu/?=
 =?us-ascii?Q?0vFWPeJa9oDH3/M6mbG2AkfjBF7xIHiLHxZzRBKRnnANK9AFK/oJbE5xmELO?=
 =?us-ascii?Q?JVCOxlVJU/bQTiyssrugA7AOv5AhA+WuhszBOBWS8g+/6y34VAH/54mZKZ/V?=
 =?us-ascii?Q?6u7pie0Dasy/l8LtqfPt8DMMO17Bz0b0XvZwK+td59jHv4WZQgWorR/il/X3?=
 =?us-ascii?Q?JYBCRExfL+c5p6HzUNYl3LhmVRfKRq2eSL7CoiUfJ7qyHMvwh7xpr8qg63//?=
 =?us-ascii?Q?5GbtsKhGZvZfjmcFwv83E00L9xv6V5h/Z99k/qNaV/8pjKyyvZuam6MaY8sp?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 1597f3cd-ae8e-4f93-897e-08daf7a51412
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 09:36:00.6658
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q1HVp+GoP+S5gPFuzvBkJjg7dakD6pB8eJKqFXmSIgdF/662ZkJfoGDMxk+TwjLEltSalDNvA+ytY5LN5qcKQA35k+rucv0Pom6Wrdh4euM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB1012
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

RFC 9260, Sec 8.5.1 states that for ABORT/SHUTDOWN_COMPLETE, the chunk
MUST be accepted if the vtag of the packet matches its own tag and the
T bit is not set OR if it is set to its peer's vtag and the T bit is set
in chunk flags. Otherwise the packet MUST be silently dropped.

Update vtag verification for ABORT/SHUTDOWN_COMPLETE based on the above
description.

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

