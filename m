Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28AEC38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 12:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjARMQt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 07:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjARMQY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 07:16:24 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2100.outbound.protection.outlook.com [40.107.8.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200375255
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:39:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMcbWx5vRNiUjS6X1GKWHtbHsrSQM+hy7KAbds/pZ9z47ajGNEuMAsvgl/boOPK/zhXIA3dGSg4sZpEVxCd24pPJGNZr/nK2KbW0oxunRHihni8h488dtXndxXRWAkkNK/3P6y1PGaJXKvKMPDEIVPRfZYlm0ImsLNHjj+NyzXgvF97VfigxnQXOeMLfFQWHdOlm9g98YQlwMA7vf4o1jQUEWmpIsfxV3nFFRtoMh2ClHiEjdrr8WMBd83ezBhgXOp7uTSC0tABqeQkElggI1m/NbXXMmT4U9i/jwv20F3nPRKEtRPvBGEBCQm0XOX2Vz9VHyfoE61gUjywqGie70A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z54AAya4XqKs9eIKXZS8y6AWSnH7k25CsOzlcwEPYtw=;
 b=N+rh8hhvt3xViDuLHzOjqx52b1th5gwhq3SMMdloHBsrqgIwYqNJL1aa9aFgxPyT9RgMgmd6tAbwpQhnGIBGKowMCd4VaJeZZjH1TbDo3tIGluc01CiFegT1398G/4eMm+ji8SFV6ykwdkPbv0eGhC5L0/j2Il0IcoLPqFcyCjH81QlPv/0SnYOe66x+T6p//jqdmVeZ0I4l15u4lJRVQ2JcNaQhonq+AImbL4+KV5qeejZ7QnhDq3kYZ3lSrL8jJmhQb7CbAA550/GQn8tOTBa3mmJcWf1LNkAJ9aXHt2rlt4FoWy1eKHlb7F41OSJFdUfOq6kFpaSUEqiOXSxj1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z54AAya4XqKs9eIKXZS8y6AWSnH7k25CsOzlcwEPYtw=;
 b=XIrifFobAKEEIC0NiIlxrocWyA3IVraie8+J10TRMsn/vCyNj0SfbpGGb08OpZcy1gMPVcXleUpThoP/c5bGkcBrTjG+//SPXJQ8cJPjdkH2DQeAGoGbkGWqcn33C/gKhQPpNHqCwO+m2G/fwcxrDAKS1rz3F7umi+An4Q2o6L0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DU0P189MB1867.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:347::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.22; Wed, 18 Jan
 2023 11:39:02 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:39:01 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v3 1/4] netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
Date:   Wed, 18 Jan 2023 12:38:50 +0100
Message-Id: <20230118113853.8067-2-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
References: <20230118113853.8067-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0053.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::21) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|DU0P189MB1867:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de0ce3c-2494-415e-aa4a-08daf9489877
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8uz40gewnAZQi+LJrfCaVDAQAwDqSLHYMpiuQDfvRuosBpFnoBXI9oq7PgWDcFJuwAUoAms3oSqI0WzxmoFuyzXZE56cwjbVEF8b0PGoOHy5mor6XEePOZKNZrgGjMaeGlqK7M+5RsIUthGbUpLGXw7g0c/vJeyDbfPfmaZzrfirozOMGnURfwdAKoK33ARpdGmsheGxrrf5IocdFhjQxC4kOqerxP0OL5HNZKPke9TNAdle/PHcF0oIbMUCg44B+CgFTSiUjDNHx6rLEommYrcqKR7XVfnjc2tlLAUPkjIPVC6bPG6aR+3OKWq7kcTm5Gs0pVTksddCQt0Tc9xQbzBw0oK+62+s4MOR+14FaJAITciZKYtXoymiT9uPKtBGJead75IR1CA5L2zir6J5TjD2vPXSMv6nZWOhfaFysdMxmQeJ9a21mMDiWFGSCBe9hdnOGn/N+ShXUL3cjuNz1H6QBfMSWu1oBzJY9GVkzS+GVMRjGVkg0PdfPEKcJ1wRbywWb1oB5Yc3EYqdTpjoIqY7QScP+/WWYYBVND/Pz6frZgfRsBi2NwIjxUic6xsleoHgQO/SGPEO/iCsq4dsf1FLUEj6S5NAbygS+j9rtlXdBbwCWj2A4uiASQb70i8X5KloZriTXm3vrApRXUtjmRevoYLaMDa3lHmO8PH5ypFOECAKRpt9SaH1D63yjc+ri6Q94+HEqWqyZBOzdDFLKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(39840400004)(346002)(451199015)(1076003)(8936002)(36756003)(38100700002)(2616005)(5660300002)(6506007)(66946007)(186003)(6666004)(86362001)(54906003)(6916009)(316002)(6512007)(8676002)(66476007)(70586007)(478600001)(41300700001)(4326008)(26005)(6486002)(66556008)(44832011)(2906002)(83380400001)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BS/MtwbJDvypq6gJ6UPMhObgosibmeY+iNxvcf1/bgXcmlrN8rvIghAUj9B5?=
 =?us-ascii?Q?w/xxU+mQPBabddrsRSgUVyjetcJI7HxZeqjPlpPvfYK1ffddWnTR9gF+Pt+D?=
 =?us-ascii?Q?NY1oNgFvP4GZ8z5FLPGjseRAaJ6etcwaZwoUelw88Zg6V2kbEupwaHgxkftb?=
 =?us-ascii?Q?aViCnOBmnRYLRyJaxL3w/5hB9A33evIZjc/LictOfyVFftiKbLsFD7o2PdL8?=
 =?us-ascii?Q?gqarLAefQaWTg91wML1HySL9pO7JTGEk/Sm+UlVVWtICCcyfD1RmxeSQOv8k?=
 =?us-ascii?Q?dZg8PcuxYb6470Z0EuJXip7sNtkycQZ40hRug/K42Ro3ZbP3wt/EXro7ZxLH?=
 =?us-ascii?Q?fZDfsSuXUDKTgD7oyP23ZrFkAZHrfxs6r7CHkM2AYFedQXhOPeYBAw36J0C9?=
 =?us-ascii?Q?oM4OkywbCCAeBSD65VwdK3uDHwjD2ysF1iT+QO5mzQY2mzubpEUQXuFe77TN?=
 =?us-ascii?Q?FqP9uueMHT9KxOVLaYfB+Xi24cXmuRGoI+mi36w8TE26+3DmT7FLD5z1UUXa?=
 =?us-ascii?Q?4wySsMVdku1k62DFtrEGJqienBLe/3Rk9JoxmR9T2O3RO/OJWF0ufTglrGUs?=
 =?us-ascii?Q?VXmJ/twvtYB5w77NdF05wSgAQ1PuCas9jlXbHIHyUxE81E0ebD+bQXuzkP40?=
 =?us-ascii?Q?HW3AaCxiRND427wQhjQc4TvKP8zLUwvmW9L3MTc48c/LD7q9Ksr7w4OMKxuq?=
 =?us-ascii?Q?1SbUM5BiYjrkfYWexGakFroBeHS2jKqJOUPc2k/MnYPko96EnVFtOnJNhi+L?=
 =?us-ascii?Q?goYaVN+R3mIcoeFlOCbUbBmAR3bfhNb1peHf8N/JjbuV5Lq5kkjIj+svI5MI?=
 =?us-ascii?Q?2yzvmgamG9HlPzlts52XAXfqKsNFVuheiL/DoxS9DS1VTr7bNz133Pp8m5/4?=
 =?us-ascii?Q?7A9FeS8k5zS6gSu0V89whdNINeE3ra15wIXI4k7vXGK/SKPSt4RMfe61zlRk?=
 =?us-ascii?Q?Og4tRX9rBkOHrvEi+nEdKHz6d9XSrL/wZpDjVAE+M4sUEcJUwj7/O3+ZwqyE?=
 =?us-ascii?Q?rPK1ktMDs0BJqZPxGMLkfNHXQQGln05VYOnsIROPPMdz625i2+5LCj2kHPlK?=
 =?us-ascii?Q?jKF0X4lE0oWXIeGeANRBF0lzJsSj3teOnLkkN8Tuab0LSPsM3kiLPGDt7UL9?=
 =?us-ascii?Q?/Tx8Efgtcan9xLxyZNVPckTRnMVyibCQqFA9dmzOioEQc7Ev9iZYfWWOOBW5?=
 =?us-ascii?Q?iTJ1xhHpGwv7P2EGoq6OtYoJtEsyHyeTN256n9stGyLKKI4z7m92U2NB9LII?=
 =?us-ascii?Q?J4FUgmutXzukrfPuTOlxPqgCMvVee3dheVUEuAIARNymg/mG4l6kNKwyU7B4?=
 =?us-ascii?Q?l2Wl0T8+Qx0EiRkT6b0fzePW3zS6zbM0KLC4dJ5qMftj7tt7mxchUjUzPEp8?=
 =?us-ascii?Q?YPE0tLcvj65Tn7z3FePMmJRMp2CieRWIkJCiU73Hv4EkX+Uxf+cpQL16as/i?=
 =?us-ascii?Q?G0S1rvcv5Jve55TkaSZ3dnS4ou4odIIz8xUBgTcFyg39kHiVOpqzV4T8CfNx?=
 =?us-ascii?Q?RciqwvjPXKgKYhzP8rWBBFrm4OCl4k/21B1p6nif5svMQ4JDTgfoYPfqklvH?=
 =?us-ascii?Q?zXNKojvhk0/NXk9YY9XR4E4p3TUr3rpWu+lD3Yl0WiJt/g/Z7d+S8JZHoV8A?=
 =?us-ascii?Q?ag=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de0ce3c-2494-415e-aa4a-08daf9489877
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:39:01.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 77LCTCesK+bn0uI3woRRWMgYMpIyj8bkqlKAdZ+kTVrbf1zHTDtBnPnCIsc5e3/gtMUtsAtRPxENVefP8tnp+8Jofj/xKMJajvBLwo1VXY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P189MB1867
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

