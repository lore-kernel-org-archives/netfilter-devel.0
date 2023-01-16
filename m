Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957BBC46467
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Jan 2023 09:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbjAPJgO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Jan 2023 04:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjAPJgN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2023 04:36:13 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2114.outbound.protection.outlook.com [40.107.21.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71164C679
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2023 01:36:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9TcSlBJ/FNDGV9LRZVYXSshZomF0f9/yMLlMMYX/J2q3NNAOYEpAn7wABIhbGGhcLJOe3dcUnILsPVuIfx5CpJM0SC9D2WUu6fUzZiC84UvVDY1pcycSR7MwSG5VZ+Gd4vfOxvJxw6t0wi84O+dVipNciySQ0t/i+lkdgSjkZ1J4Wb/HbGSO8iqc8A3fQaNhKd7RfAEM3oYERY7O/96J9gYzcKXAceNLrUW0sdUaYwF8P6lEUwyEty3g6+8zRZhmHhbNas4hWnMHqhO6CJP46cYNz4LQMvO3qESew0ebieR6sPLOvbiaPxsR9GSQ5lUtvohoWJAQMpLbPxOZVLxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QjxzPaE0O5tcIZEojrnyntgusK5CuQx3ywDpzq53ACk=;
 b=TD9jLDI3xgM2Iu9863BKq8dSkygUZUbSEtIgTvVLm2W/4KM1YqjnvkY1FLcIjx9absxKZABlwx/iy4RNzuYHJYll7YQZvKhLXhzOzv2LeLfCzbcVtkKMOmVPxdKiNFdoEYCDTrXb/3zVyOlpV9wrq7HFQzT7xrgSruPLDGmpFFmrwOh7qMfV5/7YF4c99fJWdROx1bCGbEVIHI0l2p4zgX6Gf3xqNNKHyYXoZNNXc2Yf+TFd/KkO6KwnNRpbup/OmxzKisXOvhqXGLBcznp4cPXC9rVwsaxHAaxPG8F3DI71LaCMy4UFg26nZNog5of8acCxzqrSTffkAcpW0feQTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QjxzPaE0O5tcIZEojrnyntgusK5CuQx3ywDpzq53ACk=;
 b=FgZTj1irltUXQlH5XFvcsqc44Pct31/Ib0i96gtbh/af0TOypeJOMaY8ToInKEWtTHKwei3oELyDHgrQuLAp21V0EIofsQGxaPk37sYMPWggYBubaZCP4JuVeNGKHXuf5OaXq+OdvAkEu1/cwjLkikhD3DhdTskUgDzj8hJJyF4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by AM7P189MB1012.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:14c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Mon, 16 Jan
 2023 09:36:01 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.5986.023; Mon, 16 Jan 2023
 09:36:01 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH 2/3] netfilter: conntrack: fix bug in for_each_sctp_chunk
Date:   Mon, 16 Jan 2023 10:35:55 +0100
Message-Id: <20230116093556.9437-3-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
References: <20230116093556.9437-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0042.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::23) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|AM7P189MB1012:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ddb3030-de26-4414-04db-08daf7a5147e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMqsvIetYAsd2k3uGQkVi/u2nSDyRxYdgGsmjK666bURhU0jLFlKiL202i3DuRq/AW7RLtRWMCwqJ5weyx0x2ZHDZfIr3PmZXkrO1y+XIHPFlz2TQf3oyadhdy05se/zULfBMm6nQZQG4v3Sshs9OjAGeaxU/5zPAqXBVd+gwO7bDHLLbGmNGgcxGL9CzArsg8oCqb1vCwv84q3I8WHrqhGnLTHPqAV6/5aNZ/ORW0Su2+gA9foI/nNpSPo9vW7JtACifQftYNdQ71+TOPjlodiUnriiTeZA9kL8QDk6eRmwELLR3of2VZ2mLlI68dQgsivFmn23yQtbTSQ+MamhTMC9KNzvSzt2R9ANXO1u4VBGP486gVdDytKrMNhnSud1HYhDyy42LA8AsQWHRAjNthmJ2yNfEMDKaV+8iC3YMQPmsGM+teSrRCsqtYBBVRxiEsZsR4m76jiMY7kNdbzxt3KZwJEZQMKlXPL9IwzZzotWhhH68zGWVkvxJWo9H0Nl8WmuGRhlV5ZymYnq4cNbI7VofWhsFdoI2/RYOBu6tAUJcf6Jz/WSHwqUMojwvuQ1ba6Fk49IAh/otMxxmTHqC4DdLK3aBoY63VKzWaBTq7PPwBF2/TlohJNj/BllXOzYGWGTPq/9ODNwG3AslQX/c5ZNaX0ck6FCXwxU2vaSaSFZXGowAC5mxER6OVmTlo1jVu5uSZOyUQxGx5ZKX8fBNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(39830400003)(136003)(451199015)(6486002)(2906002)(83380400001)(478600001)(86362001)(26005)(186003)(5660300002)(54906003)(6512007)(8936002)(36756003)(44832011)(38100700002)(1076003)(2616005)(6666004)(41300700001)(6506007)(4326008)(66946007)(70586007)(6916009)(66476007)(8676002)(66556008)(316002)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xcw09PpNyIck4r6R1RdXb9iQ5Tbxhhns789rkeEYUrGnn+Yo72QjIRt8TZQe?=
 =?us-ascii?Q?iX1kdoLodPvtYoo4yDvTKI8MXSik+UafB2n7d3t7OSAOGRAitiMe6wmkDUSR?=
 =?us-ascii?Q?sh/6uRuAY1vokgdZCmytBzMjbQtgAaq8R2inlk5L5x2Lon90f3HvsdfWJE37?=
 =?us-ascii?Q?+MlZLqcFqkdzQQAzMpUwLU1+S9rgr1ubZ0U6u++DQ6kjzimULPRP3ODBprEf?=
 =?us-ascii?Q?EmZOwIinFoeIrFtJTQyNLLouZFI65VeAjoN5AKBrp3wPAXuG8iZiDP3pq7L7?=
 =?us-ascii?Q?qIOMSiZR+634eAQKobBj8FLkdnVJzKN4D0naPO/3woQqOiN91LGE7Wv3N06I?=
 =?us-ascii?Q?RayGS+Zm7ahIFZBb9gN3ocZFkRtEE6fKC11gsLp/6GP5N2MruXOQHv2C16+N?=
 =?us-ascii?Q?NciphWOK1Udkn4gvoVgxg3i4S21lzeaBP5BmKplEse/Qt/BuWz6lBv0RtnTa?=
 =?us-ascii?Q?7VR5BJmwpDVCNLrHUFmZcWerEej4V3QRdgKeG5CIw3jfi64RiE3b/UclkWfc?=
 =?us-ascii?Q?LWnXGT3vRJOjBtePNwC/M24g1oN/NLdUa6w7CogeNsGvT2V9NmSiPzffw4l8?=
 =?us-ascii?Q?N17Ym0YcfSqYzXQatN+TzB4ogwy208ChEGw8kCi6EcNt0AKl9rt87f8giC5b?=
 =?us-ascii?Q?4rlYvzcdiALCQpC2gTahNdMW7PPHezI4EtAY+RRGdmoL7E+Q4N+xeEjegqTW?=
 =?us-ascii?Q?j6yXUQuEu/FPZwnwPVZoiJ4d9ZhzCG6bqKca2dW9QEy3vrg5onxrcologziK?=
 =?us-ascii?Q?QvqZ+IJ2RZYSuQ+ogqRVkNMY20PtVz9YBiiqhdOBVX0qhwWunFofC/G9Tk8B?=
 =?us-ascii?Q?yBFZ64C1ihn/rXBWqr7S0e/VNZ4+6q0fOTk7aAebvxQ8IsrhjyiQ5tD1c+9K?=
 =?us-ascii?Q?HPHQIPDlNdf0Efwu4Sq/yRcbb0SoLbRtXLlRihPWMQykAbMYBJ3EY6tLd/Am?=
 =?us-ascii?Q?5RLG7GVWUOeV65NBZqAu6nayIibeETqg5+ex3jDoHOFL9pYmhesBtBqwscI3?=
 =?us-ascii?Q?1CatIGi5TmUNesLnrmVnAF5hH5RzfHr81ygb3nQ76grsJMRwNRzPcvqfU7eD?=
 =?us-ascii?Q?6BTZMliBRzdMl4CGqNSdzcVEk+QGQW93xekBBiZXhBhC8fUPuljpHDlmzhbB?=
 =?us-ascii?Q?vGuwtHxtU31c8Q6+Vp41n9aQU9xqE889KIq6XZCAicX3z16VJk5MDc9a0Unv?=
 =?us-ascii?Q?GzWmBSfJ7yz8ByVE/Xb2tqZZ7CeI2k+/89msxItGmqVBQ0Y7Dcs7y2exAaJ+?=
 =?us-ascii?Q?ucJSwukFyqL6LJrP1P7YYhRiwsR+BVfymTlDKvGY6smB38fkZErKNImbxvfa?=
 =?us-ascii?Q?KkA3YTlHE/fI0S3VM8+ac/0C+2jAm5JfapniohjmaS47L3A+nyqjGAG6PVsJ?=
 =?us-ascii?Q?5vybdgUVIXfH4MlRNuVk35FlpVQUAy41XMeKnakQEpspGp8gZd77/wcWxkTr?=
 =?us-ascii?Q?tYtjd9fe1xNmHTL0r35Ysv6Z0U2yw7g5/VCnbgjZrbpg+WgtC26UcL1ksw0A?=
 =?us-ascii?Q?yYNIBgQ4JdrzwatVWwuqj+O9s7FdhOdWdNT0HhoaCl1lYchts6NllFpu1QZj?=
 =?us-ascii?Q?BaqkNanOzAe3Vkg0xzewPhJxH9PG0Rtz72CsyGR49ts8fNxvjErmEduj2Ao1?=
 =?us-ascii?Q?Lw=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddb3030-de26-4414-04db-08daf7a5147e
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 09:36:01.3688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXhM/WZuHwX8PDret/jimxdO9u/aw+i10lUBrEZMg/CoqV/ee7e6i3/zKhbg2XCcgARfdXyK83hzHIL2NTUtvrP7K8al25fzQ7FnuAJBfqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7P189MB1012
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

skb_header_pointer() will return NULL if offset + sizeof(_sch) exceeds
skb->len, so this offset < skb->len test is redundant.

if sch->length == 0, this will end up in an infinite loop, add a check
for sch->length > 0

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

