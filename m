Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB175C38147
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 11:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbjARL7T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 06:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbjARL6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 06:58:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2130.outbound.protection.outlook.com [40.107.105.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6845C3A87D
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:15:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4hKnpmv65gfv46RzLL5LuisvOj3ecWuK60VXGlWeAquZYGEN5mOaZ6oaMlt9FuQLmrd+wnEy4WvcjkeAUkJgVPdwRWPOKNqGkw7okxZbNZvRI4RrLe1nCKgI7ndsnTmRxZmFR3fh7VqsSToXdK+Vqa1COG8cFwTq5lUl+9VxplFJqJDQNa28pS0TD5S58kYdW3IDUFCNPVGJf5icc7sMXVGCtfqdo+o9RBwOtpS0EoIC8hEXvTzZlET4kp8J/WvQsOkHWTyLWcINknoM++8UHwT64ZjJ5U5lYACJGzCeUii79oHh8YZmeuRKYYoPsQqi9aoVdFs/ntszg2YSgBk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vFt5WqzxGE88r1FpKNK204IfkuMa4fBcX0HnSULJpA4=;
 b=MWafQHflh9taKh6190GrezIQKLVjCElpTQmjtuEfDpP6+HA+NTie6KKwiP121YeD3LB0Zqlc7mrxKOOUDcR88k6YCgnvHCcnI1ZT+QZl2aHcapEiCuv5uy+xcvLLcRnbLBrssgEyEERLIpLjyncjWwxdBBDjbJJr7Ecr7mm+ok0dTVj1oP5Mtw1Kox5n7acuusubssHE/s955+Mit++0bTudQ5e1GN9HQcrEwA0jObEnQEGVAL5AXPHegnAP9EYblKKV7PAHGhe1BBXa33e2XLbrwstRhZbBoRT8n9nNJECXB4wYq9xeRhvsvYZfmS9FACl87GRUr6asL/3ioP6nRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vFt5WqzxGE88r1FpKNK204IfkuMa4fBcX0HnSULJpA4=;
 b=QuAVE/vixtOCn8wCf6w1uP00woALYXWzCX8kLeHT3Gj/mRMsmPoy94eZs+S/hn4rek6Rf3betyjtVV1ZvUXLmxJo4mEqWj53Y9RfvTbY9f+OFGV21ZLuP7Vgo5Bip5LLzOOV65f57T8mV/W0Gc1wZNKtyn7M0wusq9TruByCqhE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P18901MB0783.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:15:12 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:15:12 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 2/4] netfilter: conntrack: fix bug in for_each_sctp_chunk
Date:   Wed, 18 Jan 2023 12:14:57 +0100
Message-Id: <20230118111459.32551-3-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
References: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0011.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::14) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P18901MB0783:EE_
X-MS-Office365-Filtering-Correlation-Id: a36eceb5-875f-48d2-a692-08daf94543b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIKyVnNdPoY7yH+2H8q2h2x94Y01On1CR2YmrBykRaBDoT+gPa94R0t8QRw0uSX/5TsjN5xE36ROhx3gx4rOc/PhXqL/ew32z7yhIVfr1QymV/4P6giPl4VhlY9J8P9zOqm//wO6e11OLqNkzMg1W4ri5Op4gy6sQryYFIzPRQvlHhrnJDHmfvg2Jt+3Zrh07yKZviH3PDocRloXaOkYJXV4fnPaJhErAIQND2PteEoCBM6c7pZUX5xhx0pjtHK8G2Hau2e2Tjx2tpaXs2qrV3MJ/HYqDRtnnt8q/PXfDwykd6aIYVpVPDnhNuFShIewvosT6CD1IcqcYbL2pw3JQee7DGhNxSeDfLn2RR9+M3K6FDQsEqw3+vGcokL9jEKoYtau2QUAS2GAcjeJi67wVTK3SZVf/1vIo8HXUTP5MUgFRflWr09MaZuhvE0BqqxxyLO/K7MAPWVFQF1sapJiR0SUtnMVH1YpDDQCdpOK1H/u0WJN9l5M2wxZn6yQ2dYwd03ZVyHNjLad7G57OpcGBXHinjx9aJmVmksGyjDv2bgYIJslddLRv9TJUm72AEtV+cV7eRu5v8RMuTdcd4w0GUgGi6WRk02kACPayuc40qf2YmdfPVI8rEx8vp4l/L0Q/ESESRL6rQo7iGH+z+Go9GSVTbErOEyuPoB1l4fmztAYk+muWyoroEnMJ8mKChNVJai4w/J4ZbEpN2BYsNa/gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(136003)(346002)(376002)(451199015)(2906002)(38100700002)(86362001)(66476007)(36756003)(316002)(2616005)(1076003)(6916009)(54906003)(4326008)(44832011)(6506007)(8676002)(70586007)(66946007)(41300700001)(66556008)(83380400001)(5660300002)(6512007)(6486002)(26005)(478600001)(6666004)(8936002)(186003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FMbN3FpainK0mKWEiR0TyRvwZ5SCXoivS3OPc3Qne5I8ii2SiEsLpWy/5lkC?=
 =?us-ascii?Q?dcCe7SeDtWeYgV+nOaun6G+CPPYBd5ccQmP7CCwEcB23ozaBOd+64gz819+1?=
 =?us-ascii?Q?Ci4Aqm7AcEeOaCCBdJN8hD0Svm1ABYyrFTb1cNrEjyaPTStlGA1dRzMyR19A?=
 =?us-ascii?Q?uAMhBt5nCowE1i4apTz4hJV4f998AeHf030q0WE8a38R0FqDZpkR7kevBiwg?=
 =?us-ascii?Q?C3z59XDKDoElGEil+Zpfs/vvWDh/HvnocNpO2wr+Wd1lnrLoFLHXEBp4B8KR?=
 =?us-ascii?Q?K4KeKg8ks4mO8XAa/xdMF3gx6mj2ArswCLj99kbLs+rSwvWV/ujXQfkpMwCa?=
 =?us-ascii?Q?k01Y7WP5qQYOBEVqkoH58e5AlX5FscnQqV/WdZ1LU/ixjQRHECvPXtZuZiob?=
 =?us-ascii?Q?fKOhx44NjdZ5Y83d5NX+aa/oROcWrxUadLwqAhK+Cyrs4He5qKpI0CIaKoWw?=
 =?us-ascii?Q?aNFxbVmZGd/vP2Oz9UOOGKmvKFl40z/uai/c2kiY2J2e16UMHq/hdGN0vKR8?=
 =?us-ascii?Q?+6wJ8UxOs3NC+YgHlFfgctKjdbe66Gn/dwN8OERJJC1z6gWezRJ+yg/vBBxC?=
 =?us-ascii?Q?ac2A7+LcfYrmZFS3fJW29AqUv6i919naEFGyESi3JuJdJQbY2dvwyi33d8V+?=
 =?us-ascii?Q?UPbamhAPV16jBMa2V+Fro3kZi6fB+tohiN0wkrOzBxqccSxcDSAfh13XHENV?=
 =?us-ascii?Q?sDvUgTZchq1HZ59aMofZo8LGlX8QoovIum78ebaMINxhsTJdOjKvccZtXzbp?=
 =?us-ascii?Q?WtcBuGlvQ4GJSTaXAFmPkTxPSZOA0hdVaUO9FpMBr1uWtO3rqEyhvGApwEb7?=
 =?us-ascii?Q?bZHD4SYoB0Q31r8qJwf2BRpuxMZHA4N8B3YnCujUXABJKcgaZWG7Ayznym+k?=
 =?us-ascii?Q?bX+ZIatBi/Y++cbjkX72SqH2FcKvscTSzGDCWrSNW+AfYT+laMqjjD7QPyEO?=
 =?us-ascii?Q?d68Bav9jOd/TrxFZBfvhd3K5A/4rooJSIYcJDweAx3JT16E4Gej3zsb78vid?=
 =?us-ascii?Q?BPgkdkV+WoDu7tqcmvS5+whxGkG7fd7KOLhtXKsCiLTMR2tfMCKq8SUuHOlM?=
 =?us-ascii?Q?JSjOZxKVUH2y1bRctB4FTqRr3PxFQeX3nr3bpWNSktXmNMKJnwScz2sdoDER?=
 =?us-ascii?Q?ijlugIgz5XNS6RGf6DX+DqocW18q9CVhXLo5wTT7epR+IQzntpNjqBNdURLG?=
 =?us-ascii?Q?lPl6/eUbXBt1h97f1WIHC9vPTrjqpYVS7iI/bkXHwZ43UeTflfATJctSNp3f?=
 =?us-ascii?Q?udB6z5GMFOkFVrrnI3KtpBYOUguWzPcsS4YnWxVmeF1nfb8oqvQqNLbUsdHr?=
 =?us-ascii?Q?jcEs9htA4/Au2oy4yFrNwPadoC9UmFqahg9Shgf9if63iFfLKiWNeOyHvy8R?=
 =?us-ascii?Q?CWqpdpITS0NV1rQcIm0RzPa7/zAcB1aIKyWK3nm0/aKW1AaDcBQvH9JNwhxE?=
 =?us-ascii?Q?b1zd2nrvciOG5xJBh2HzyHAv96w+ahZkMSvikXyQGa4G/vPCGiVoynGxPrn6?=
 =?us-ascii?Q?dXniTtz7WfwsFZM+HpR/7s5qXxfHAQpTfzhuPFRZ52NfawbzWIeujI+Gs+a7?=
 =?us-ascii?Q?gdHN/CnT48h4hIopeU0nLrTahBybceIXx1bcEPIowh+0bO7vr4Ipe9PdiMJR?=
 =?us-ascii?Q?tA=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: a36eceb5-875f-48d2-a692-08daf94543b4
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:15:11.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 04NKTYKd5QHBS268RDvfbEj1C7z+3ywCKu8Z4zj4QyDfp+GGvda0nTc/uFJFGBhbOMNglNuSrkgO8IWGy8saL1Q87uRpLVYAo4Yv68J5tnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0783
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

