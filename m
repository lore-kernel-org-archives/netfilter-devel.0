Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42651C54E94
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Jan 2023 01:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjAXBsg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Jan 2023 20:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAXBsf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2023 20:48:35 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2127.outbound.protection.outlook.com [40.107.8.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C6516AD0
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jan 2023 17:48:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtwYjQ5/Ce8zIsLEqu+Kr+i2V8/Ni/s9sVOs/xkLgTpbe2IYo5a0gyHOgzJz0YP1n8evwad+2Tzw+eeVtPM4x2dTlRweb3Ca4/RhxoBzJA6gM9vI9EoeR0uReyEMtOpiqmT4GkdCiHSa1BNy1IhchMbzJ4BhoQl4kmnvlzvIWas1QWRxjNfismG/D5OVKrHfMROnyWw4/LiJNHRwTh5KLt+yf8/YbuCsuR3x3dl4Ocy4ga2MOLEJySEtmU6aXWF0n5UPlpsuNs2zyBflbcUemJgk6dXOxTbfjMywGlHuEJkZVCQQSbJifPz7Pv+1xLUr4fXZ7QBEPyORWVwWtrCW2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFt5WqzxGE88r1FpKNK204IfkuMa4fBcX0HnSULJpA4=;
 b=Nb45vGXXKx0WuFFxc4SSi4UDzMZF1D8OyKb/JPubgBkJhPbxGmsrkNygCgNGrKDkAxSq+MVzkBkiZFwIVFrq+cdmTCPMII4bLojQCK+iq++veEXstXUF4MfSZs8Ss1VyZweN7bZYf5Or4G1yi1g6etvy0FaSUeiMj/tfB9O3fRjzKVXfGAJMIjx6bpvq8dWvzKU8n2IFhQxQwBv/UaOF1RbPJO1muSCenCc58lml7OTT6ei7Em6v2PtW8dX0bt0gGscyGgpT/s0QcWEiyRvDElaz8MzlDnQGg6B2aZbtiezdmKHfKKYkS1PxY+Rq2isLS5vORI1dQJGkQjVNxksdrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFt5WqzxGE88r1FpKNK204IfkuMa4fBcX0HnSULJpA4=;
 b=NrDMdmhpXT3UOvezTkP+JQBJGjuiCabT2gRZM4tpgjB9yVmEQ8X+eOubYblBwsa2bnOgS1FxB1UizoCfJpIYlVduUeu4amZjqCSew74I+/ithqgYJ1WU5iQ/3qHaFlDT0FwENzHt0XiLaDHM94G4kjnvkMJj3fMVXgLFtDxgnkc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB0821.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:122::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.28; Tue, 24 Jan
 2023 01:48:29 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%9]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 01:48:29 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v4 2/4] netfilter: conntrack: fix bug in for_each_sctp_chunk
Date:   Tue, 24 Jan 2023 02:47:19 +0100
Message-Id: <20230124014721.6058-3-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
References: <20230124014721.6058-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0108.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:8::19) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB0821:EE_
X-MS-Office365-Filtering-Correlation-Id: e1c6fc0e-fe60-4d5f-612a-08dafdad1746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aO+g/DthFtPALNWqtfKiXJKDf9ZGWco0AM/eTSzUw+d4VUDC+k6vVPU8m6+CSgm6MJLWGRKWGBBzN+22Q0TF1ohEm56VfLZFT9KCDyYszyrs1SqP9ExOR/sbuCW8mjiddJDs5IIZmJjEmn1HJlHeBN839o1bSz2/kymTVrSWhPzhyBU23hopJTvg/lBO3ryiflF08HAYuVLSGaIN1qrzNj5UOI/ASveUid+bfw8uzJkTtzQLMNpX1gNqhjpOENETRlJK7/wndHUrJhh6z3FffQd/iVbLC2WGZ54rp+32IXrTPwRtluApHzpTUPP6STfDJHal9HmE77V+gY8MUgRBXLoZ7YgLvAX0p78XZv96lRmEcx2xo5dWO9mvgf7Hb0OC4xZZupw7/qN5J8Y+aj3D/MqtA3Jlgb4WI/PVv04WFIRjndvQsANOJxzXqJC6MaPq6b3BzrwJcwb1BU4JzduDTrEdZMRnC0rSxewe7XOUxwKTG0DxrH7u4D8TG3T1NjxHZOf5tylrxRP27fVsi1f01w7UMpoMJ31nCvHtdU4h+bOeFzijqBu/rRS4oaR1yQE/3A5aP+xznec6mJiIh7XrPJA41jKpOLRKJfGI4k1zgey6O50Bjb/t453lzNZLCr6W6fZdfKLWN5iv3UhUKSo+8rMKko4k5Qr0v5bg50DYaQ4u+Y5m5ooUpbtLPdVOO33eTArYZCZRxSDDWYsh08aYtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39830400003)(396003)(376002)(451199015)(6506007)(1076003)(38100700002)(86362001)(54906003)(478600001)(6486002)(316002)(36756003)(44832011)(83380400001)(66946007)(2616005)(26005)(186003)(6666004)(6512007)(2906002)(5660300002)(8676002)(66556008)(6916009)(66476007)(41300700001)(4326008)(70586007)(8936002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gut5iBvuUPO3+yHdrnDBa+No3nwBbjhYpOmf6J8AieNksmhU0zauXcTxISMP?=
 =?us-ascii?Q?ZMTC4MsY0IDYgBYvlBXWR8ACTxohadjE+g3ITQMYzHvimFyiB6jvIg51cb6g?=
 =?us-ascii?Q?fuBkKXi2DxFcNl07mL1ElxXIue/qcVMTUBpRVm5ZaS+/qe+x1zlBxnDejdmD?=
 =?us-ascii?Q?MaW9ABZu6C9iyyaSoBGcrIvEh80JEYETCZTux1X+o4mEu8vYU+8/ihqxN03O?=
 =?us-ascii?Q?J4R4V4GvxR1TAzFcAvWqTQaAJa1+3SuO4TyFz2MKmch64BdEKsCE819kVjbb?=
 =?us-ascii?Q?kbymRAJ0Odi+zYuyOn7KVEDVm4kVXCrP6NdnpW5fQlW1f+H5aKptn8yeSQuf?=
 =?us-ascii?Q?HdxmEgoXadmT82eyDfJC12bgmyGS9YBFwdEADEO8ubozJ7DaFyzVH6+82pwV?=
 =?us-ascii?Q?o6PVIR6wYvDm8Fw7484hV3nUafOqP+Ten9E5qqhtVCAdPQr+6cX/qU0OGW6N?=
 =?us-ascii?Q?y6GhHiB+sCzrRfAXINmKr7q4vvzldB7/Gn2ZxtFP7C6qqLdesZjpspAvEwfn?=
 =?us-ascii?Q?Uv/pw33keVpB6R5VYxutHD8IWwSYXz1+9pOH9Pb+tOTX0+LclFaz7CqsPPB9?=
 =?us-ascii?Q?YNU+b6l6ydxQlvYTblqzspFt6knej0vaWQc3ltAdFQauanUFbwa4BSBA1J2s?=
 =?us-ascii?Q?uzfRjKMPnPZIDOnfzAM79Z6Ol5SnWGS4pSTtZ3bO4aijr00oPZQQUMYAHQXh?=
 =?us-ascii?Q?pM13b99f7crEBbvq5sL3P0kaT3kE+iEGYbLDjv/lqgNOICuYFr41p/jrB+7x?=
 =?us-ascii?Q?DNKSbdqWW0kHHpgsIe/vtd0BUVvA6MtpRZ/dPoAoXuc+th8RrU89Ik6exLCC?=
 =?us-ascii?Q?QkYKIHlosXxVngHcEVlPPdV9anc6S6lsnugPz82OLR9JsHRsWPAmKMI4iQ+z?=
 =?us-ascii?Q?NJ3a1vMbDHliHaznbLBWrQmwUYfBgxOR3u+Qs0BjuXsF52XChrq1qvGWAs3R?=
 =?us-ascii?Q?5L6+5dFdFeJfqWWUnGrQCS8oQZgHdyDtUW9Yu5j2aYsPqO/JicFxbz7IV06l?=
 =?us-ascii?Q?i167NT30AxhU5XI8+ZzE9G2aXyrtdb8N+T+03RtUL6nlVOekAqA3sWj6pQIa?=
 =?us-ascii?Q?ptrMfvuz2TaMmlb72bYHkNTNYB5LisNUQukQtRojMdhFAkjSKr+42/mUDjKv?=
 =?us-ascii?Q?PvQ+2jU4Nu4hlOq8gZHDIX6XWw2PXS/vjRpEQtHkOBCGn9lwixwmDCuNQKfd?=
 =?us-ascii?Q?feq07VWCS6b9U/sCXKjkrPrCHI8RohNgO/JrXgBwdwZXTgRQWpPCczQWO7LV?=
 =?us-ascii?Q?utaJ9LMVeckjtWLWMo2/w7QfG5Lrd78ZI0FdX4FYyD2MTi2IoQwV3bwVuPZD?=
 =?us-ascii?Q?6Er6IhdzVj7XRM1dhtrlN5KwqGW/XqJoYAAh9zXE5G/yWkYk/7jcpcd7vfgj?=
 =?us-ascii?Q?s+604uM3+UCZy8M45heYdu5Zhkd5HEJBcUuyEKl0x1H3aF+wrLPL8yDpde63?=
 =?us-ascii?Q?3fVuxSVpXA/+0PgqK4tZD2A2EsnMsKjB4HrUPsb712EyDzi0SH+5Ifsx4405?=
 =?us-ascii?Q?qKCa5byWxeAuZo+FZcFUO/Fp5b6KHidoyT5scZesD4Wx9sKCLDJmsksKQib/?=
 =?us-ascii?Q?Cs8jCVp+4vb8u2GKmAOppTKnwuXnOcqFl9SryGdSX1L3qdwqk1hodVknQEer?=
 =?us-ascii?Q?PQ=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c6fc0e-fe60-4d5f-612a-08dafdad1746
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 01:48:28.9098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oK9HeWuAjTN8sGsLCosxj/rKC1asdbf9x2BTh7cKPd5AFWshWFsyXvI9jUWr8xr4pOCTZ0/ukSqLzsSS1xLCScGzM5+ZjJRP5HO5v43SO1c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB0821
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

skb_header_pointer() will return NULL if offset + sizeof(_sch) exceeds
skb->len, so this offset < skb->len test is redundant.

if sch->length == 0, this will end up in an infinite loop, add a check
for sch->length > 0

Fixes: 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 2b2c549ba678..c561c1213704 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -160,8 +160,8 @@ static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
 
 #define for_each_sctp_chunk(skb, sch, _sch, offset, dataoff, count)	\
 for ((offset) = (dataoff) + sizeof(struct sctphdr), (count) = 0;	\
-	(offset) < (skb)->len &&					\
-	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch)));	\
+	((sch) = skb_header_pointer((skb), (offset), sizeof(_sch), &(_sch))) &&	\
+	(sch)->length;	\
 	(offset) += (ntohs((sch)->length) + 3) & ~3, (count)++)
 
 /* Some validity checks to make sure the chunks are fine */
-- 
2.34.1

