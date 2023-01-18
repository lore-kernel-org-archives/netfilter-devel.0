Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31F2C46467
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Jan 2023 11:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjARL7Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Jan 2023 06:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjARL6p (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2023 06:58:45 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2130.outbound.protection.outlook.com [40.107.105.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F9737F12
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2023 03:15:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACYyqQx8lHoE5lzywdyPdj1UXaZ7fzhgry6jx2tBbxVQt8LKE5U2xl+Y/RSEzmSFe4h8Iwc5lyxjUUd+/G3Ekou2Z9Yde686J45ISQQxp2nd8E475aNB+lpAKY/iwu5aaTAzaQJlBRDcaMW0bU710q1tXAtfPrx1s2VXuT+7FwQrv2OdZkUlyykmZBpKNQCdhWrAsWaxNUTWh94SUR4hV0cOYpOxNVaTu2bs7cgJkDH/q9eInBBOMD47ZllymKHWJt1SvYVCquik7Z68GiCS0aLsO8fLIi3sHkXoS/dbXQEOhoqVVy9o7qttqsGLVZjBDqjzSCRkNIipH0lnbtVXPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z54AAya4XqKs9eIKXZS8y6AWSnH7k25CsOzlcwEPYtw=;
 b=kpUnVFz7ijXnjKpOAPU3/PCxGx14PAtTxjD3q6ZDIQdXLyL8dapVNzuf3QFNDJCq1VGIrUWCZgHnYZVvLseWM+v8wxDuVf+ZSLZ1v7i7QgCkUNNSgXTuyMGmn+vHGt9Jxvw3bcnaPXPqhv9QxgoE/LAub/tz0ynKudeQsEhCmAw9JcG9VN0Ly1MB/JjWX0yJ0K0oeSzhHUndNch15yxmQNUnAL55//RJzIC5BDU2JxrnkSGboR2ewAamLycknFbaDfBqOY7sgEuDxEOHrehobv98FK+SSXckG1+tAW/VMfze/q8MROt+nc1Ooz4xHmFNCxjVF5u+5XIc7O6Dghnf1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z54AAya4XqKs9eIKXZS8y6AWSnH7k25CsOzlcwEPYtw=;
 b=UbmR30iC3gsPHpZ9s/Y0Iq6tYTFYzKT4YmLIH/EJUWAn1A9nFTDPUDwyuFNox5EAtg+ycRnXIdcBM1nptzMfe8skxKHwtcL4/VkBS6Ym47FZdbeS3vGbuo+CAbIJjnL82Cq5BxorzTzdWzAKzKoQxW/6CLBd2J96T8DJ3Y1MkIE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by VI1P18901MB0783.EURP189.PROD.OUTLOOK.COM (2603:10a6:800:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 11:15:10 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%8]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 11:15:10 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Long Xin <lxin@redhat.com>,
        Claudio Porfiri <claudio.porfiri@ericsson.com>,
        Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Subject: [PATCH v2 1/4] netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
Date:   Wed, 18 Jan 2023 12:14:56 +0100
Message-Id: <20230118111459.32551-2-sriram.yagnaraman@est.tech>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
References: <20230118111459.32551-1-sriram.yagnaraman@est.tech>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GVYP280CA0019.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:fa::22) To DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:10:1e7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DBBP189MB1433:EE_|VI1P18901MB0783:EE_
X-MS-Office365-Filtering-Correlation-Id: c2a5ee7e-48b8-4d26-29bd-08daf945432f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZPg85x60Hk/n6v+2mqV9/4sS5d+5OWHzhpeltMMf6kUyf9N9OnulP3h62cTCjbt6X10mS7OJM16NXCbEGUo5m5uNTdJzhftH6PgaNcyy8D6FqvdOPhhwMuQgZZoBxezn6gip/sFOOoLg0jDzTw7fkSsPAxnqLc1SeR4pHmmKn5el9srZYi7E4UIAPUFdzmNzcnv7fTvvSRB/Xb0zg/xKXMQQVxeAuCji8wXuVTYeCTlr7aYjbH+QzdPBghhUKXSTjOYSHpjdUgweO1FGEvQ38mrx27sM+nLj263CRYGLp5kPmjwinF4MbiL4SkpcYJBzS9sTn8grNOqQKls54uaG/9izp0cOOfUIWppSYITnea5sGA6xA2WN4i5IONrsjPtQQyqEGbb3DmPJ7T/5Xl0eQ0vRbeMiEVC4jSrr9sf09uIM71TZUb0ccRSaIwzLwhQyo7Xb4Nf9zy2z6PY46GP1sv9GnhveNFyn2PSOVKlWzl6ZZLUcANXbj+ArJEPWHyInKJSekHRvBbL8BsozTDvkQgR+fDS5HL5yZOJcD/C56sI0pnhXwNIrRJpOM5aPt4LAHKlsIfz+MN9H2EnysOiSE84ourCMveJ0gOTNQT7JOsoKHOcVOWmWhuM4xCRpmVD7pA1vYZrS+BpI1SfJrOpFBLVp0mGcBNXRd9ISg+YobuhMZrnSPGAfx3WWQlfC+bfB+0p8QHIFAd+SMlHgpvI9Cw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(39830400003)(136003)(346002)(376002)(451199015)(2906002)(38100700002)(86362001)(66476007)(36756003)(316002)(2616005)(1076003)(6916009)(54906003)(4326008)(44832011)(6506007)(8676002)(70586007)(66946007)(41300700001)(66556008)(83380400001)(5660300002)(6512007)(6486002)(26005)(478600001)(6666004)(8936002)(186003)(37730700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q0KHKPTWG7rnf2fi34KQfIb5XrNUZMmDKsAaumGSnXw1jhR8FrqEwnEljXW6?=
 =?us-ascii?Q?iuu2rVdZCwM5rSUY0D9cKb4Ed2lY0XMMLVOiR4MTmowconAa21kWMEx5lcxY?=
 =?us-ascii?Q?PRjwN/l8xCvtt7ePFLUj6zxNvyF8TMo4fTUt54aCz8V68l3uMnseEfsffIcK?=
 =?us-ascii?Q?r4ZRSS8Q1pMeN5gTGrp4n4BeiyMSPmZzD8DSjd7KJZbOQVn7JZh9QixLUy44?=
 =?us-ascii?Q?2iHOe8rTOLpNBtMS1ZERfh5sskSzcakDW419/czYCR2AfQGjKXRIOJ4z2Fa3?=
 =?us-ascii?Q?cWkMgpiHvz8FJGdSVxT8ojT6wcvOO+/dSHywVfag3wOjvvN776wR4kYJBL2H?=
 =?us-ascii?Q?UJmY5ebLAsPBQW/HNDetYKFpncfs/0X1+rKnqPSfUrBrxaBcp2/Tx8DZUIvo?=
 =?us-ascii?Q?0lF0C3WJLipN12B2BEUs/3lVHROoW33hqnrntLdmoBm8dZajNHXMHmsCTaDg?=
 =?us-ascii?Q?zkVklFQZESkSxdKZVAmKoVbzTtzkcVDstHLirXrl0dGWsEsXpL3kaR6sftin?=
 =?us-ascii?Q?z3RQmxAQKeMT3MxZ7vDDOrD13ECu9f4S18eFo8yZRI8vayz+ffjYLu3tZM6G?=
 =?us-ascii?Q?7VjmWSjELm7wJjZB6roNJdoIztyvOaKgbJrwe4ffmpRqp2Vw0dR/wuXUMJ51?=
 =?us-ascii?Q?UpqoD5RuHPP8Fv9Sy8WrwMwEmi4t/ffQcaw/KMTCmy1KFqE3pGnJiGpFXziW?=
 =?us-ascii?Q?QgZmitfq/iVQyYW1JOaLCNwE+fEqyzUf+HsJNrzTAshtpTMSBiitdNBRqJ/f?=
 =?us-ascii?Q?goBaUDYHRiBiAj1bk9u6L41Da9c0nC4d7j/IlAVvZbxCTWB61Ns6Au+gkONl?=
 =?us-ascii?Q?aCTULXmNRRUnfYHGGOo8MeBEyoQOa29bgXHjuZMRBiLDxOj7iatIFWtnlFkG?=
 =?us-ascii?Q?sVSaO5fOFvr/1WyvdoqeaHlX/q0hR7MgCmV4NtXsnB1OOo1tjwPbdTumErST?=
 =?us-ascii?Q?KmrCdeEZ7dulvex+wyuvuiVCVd0pRlZi3p0k2WESHc4v336v6jkLSWM5dHyQ?=
 =?us-ascii?Q?rSv4wVRBBFCGK9j9dQx0HVMY6ykQ1Kl3ilDto69r3ZhxIPrX6J8I86mXnIZQ?=
 =?us-ascii?Q?timMHYHhsNEfUKW+cHEpnu+p7R5+iuv+Ll1DbDZBc0A3xez89Rjs/gV0Cme5?=
 =?us-ascii?Q?wYWgwJFJ/TQUpxuCgti+/z5cp0tqGzByuRsgv0gOALRSbO242tQPjz1jWm/p?=
 =?us-ascii?Q?F/lPWNvY7U09lTduj11zDPekHEaHuztixPo+7dryUpnSYbzU2pkk7jYQVoXq?=
 =?us-ascii?Q?MU9DZzJaoDqkSZNI10oE5WAIqTxQVj4v9gv7dwHHuXW95+YXWwQFVBCt7xYZ?=
 =?us-ascii?Q?Tc6H4BjqBAmMy4JsIZvHqXiapE4qxzbK0v6XKPdnEujEdzlUdHsZ5DtVNtCZ?=
 =?us-ascii?Q?2LaOIORzLJ7N2M1hH4SXU1fd7sPakKZADvPLQia94vFJIU/Fou+ATHsM5ECN?=
 =?us-ascii?Q?BmjGY9klY1QfKeT9SLmrnQ1cuYXNzTPHw/5c4Qf65XihqtIEMcQanx4j/GvH?=
 =?us-ascii?Q?txaH05kMTx4OcybmLZCJP1zBbprEithAarU4U9rsaPFLID88xamyfhkeEo+b?=
 =?us-ascii?Q?yCFofhPoEK1cewLyXXduE0x+i1/Hv3RhvYvMBPZd7IosvRR1t6A84bPwezQI?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-Network-Message-Id: c2a5ee7e-48b8-4d26-29bd-08daf945432f
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 11:15:10.3288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: guU1qGuA5DB9N/Qa0DRxQ3dyol5+XG2SlHYkxmoUAKBNQ3iWgaaD9l/kTHQnvKuDl+VnQsQchrDmAtkfbSNxbLBK5K/u9Zc2UZdbUGmcO1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P18901MB0783
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

