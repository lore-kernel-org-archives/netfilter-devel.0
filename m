Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90931C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 07:53:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A31A207ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 07:53:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="gzl9csKs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgFIHx2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 03:53:28 -0400
Received: from mail-eopbgr60100.outbound.protection.outlook.com ([40.107.6.100]:31070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726404AbgFIHx1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 03:53:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4pIwgXpW89Za8/h3KngVWd6OBwDJdhUN2URg48GGCIUuN1o8AKjg7TR7INjy3saoxt0oXyaVVTOMCGGV0vo1+Gdk7S7Ce2F12x0BhIAqVqoBtiFkE59vr/3wv/z8/HVq7CFrb56Dy0PWeVadCWrSVFX7t6KnD8uEUh55Pr6RR8hPP1yIF5/M25l+fNqGWkVTAUqCpkJmqHZcU3v08sg4Vtir4UFIyLgoEzn3oeH1c+3LqeahrZJhNfMy58hfbr6Ie1psRSK/U4zYUblwq+gFZcudmM0SY2N9+w1vH3GtFg17o/au8mWNl6TMwpuZ/7Bx13uZplZPCYoa3D6ayJT6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzp1Y9Jr/N756f+FL8TmWOvswurPhUmwq6W3RR5uqd4=;
 b=fmMePIMOB+mJUWYuvudUdQJ0ab11itOjkxFiimTO1Q1q3dt/HVLriCslTHl2pm0LZwbFEcL+n/j7jB3yt7LqdEDUBVH+xqDestFukLMdTeSVl9XUDyS21ncWJ/J76zoGhXNR94JpVTw0hiS9bpxeGb6Wu5n2B5e29p2hjMRlBy92oflNfcz2AxCR4oB11ETIWMFEhSEJzdE8FW8Y4qJvT1hOgN3fpSlJGLSaEPsloPuoVd/QdOnKiSFlqZ4dCKhNeoY1W+PkxeU8pWiNMqFI0tCCWfAXnv25qT+idsd3fbX6bpTgU0VXtjN1jUAeH+tOORdTiAhHv8Y991ZHHitkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzp1Y9Jr/N756f+FL8TmWOvswurPhUmwq6W3RR5uqd4=;
 b=gzl9csKs07/tSErp/OKMhdW0TsHrUEloF5bGjRYKJVqcV9RCNxJW6GEARIoK4/MxhQmjZ5gIGsmmUfdateFeqaRdFYa7m8qFoKo5vezPx7+8w5BIk17MnCIyvTxtZrLODFf2GkXG7xJ70pcCFCsCZK2H3ARWMc8pRu1ii+gHrBo=
Authentication-Results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com (2603:10a6:208:162::17)
 by AM0PR08MB5378.eurprd08.prod.outlook.com (2603:10a6:208:18a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 07:53:24 +0000
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::b8a9:edfd:bfd6:a1a2]) by AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::b8a9:edfd:bfd6:a1a2%6]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 07:53:24 +0000
From:   Vasily Averin <vvs@virtuozzo.com>
Subject: [PATCH v4.10] netfilter: nf_conntrack_h323: lost .data_len definition
 for Q.931/ipv6
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>
Message-ID: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
Date:   Tue, 9 Jun 2020 10:53:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::38) To AM0PR08MB5140.eurprd08.prod.outlook.com
 (2603:10a6:208:162::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR10CA0058.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Tue, 9 Jun 2020 07:53:23 +0000
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75e642ef-3a0d-478f-7c7a-08d80c4a2fa8
X-MS-TrafficTypeDiagnostic: AM0PR08MB5378:
X-Microsoft-Antispam-PRVS: <AM0PR08MB537884A9D39C49439C4085E5AA820@AM0PR08MB5378.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:626;
X-Forefront-PRVS: 042957ACD7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4rVgwzRch3P5nxdHaYnnD56+J7VCxwxnWMI1uQqKh9kGGmTsfjBILD6kmnFCbWSgJt9xbW6kdXNOP5MQXcIhwC+mthHTgwYl6aihMujcsD2IZ/S1d+PqB2o8JOvavgFiajAEVauyIf+Sng2WMESL1TXec+V/IgoNXU6gZmxLs06LVkM6XS/d7gf/rJ2H9xJyqzXY/n1suDMA31fqYIz0goYi8KDwiiTy+BoAwwAOSgT1hqO+UR6Dwk/Tuu0vGZth1okQBc1bagymaO1puxSizI5R+oRzzlgg6rKT3+kqd9rGZ8u96Rpy/qvuQu96UkIjaxre/GJmkPShamcQ2nkf++5x5qbql2F8ouNHR/bJpRPv201nqI4U8FKy4uISGqWGBV7u4d2iSpTK1pT6kLMwCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB5140.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(39840400004)(366004)(396003)(26005)(52116002)(316002)(2616005)(186003)(956004)(5660300002)(16576012)(16526019)(2906002)(8676002)(8936002)(86362001)(66946007)(4326008)(31696002)(478600001)(66476007)(6486002)(36756003)(66556008)(31686004)(142923001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cnkGB6OxvamMnLJg1sxBUFn74zVa8qGs9eoB6B4EVkMfSXEOtJyZzw3YKumomcd60aro4gDZ7NiIQr0bBpJzTOgcAEqy+3x5NjdEB7lVjIek7h1m+n02QVMQH3/nvqi8X8WUE98TuFRHMQ/YGRowr6QhK/iG52waPplDyeGpFPwyFb9mCL4D8OBRqcOrhKBn4OzLsPunj1jCYWLElaVkDhhlBfD5b0EiMptcUtlgr9CbLh/cXCkC4dCd9EIvX0h9534dzsx5hj4oEpgX50k18xFf6hF9TAA+6PmZujjMxG+WNRg9P7hi1ZeGr3lqclMkeVLneFYT0t0Y97K8M8bKgJUzrEKHJf15avyrCaa9E6niLlHkiDvVLGZa88001AOGxUVRhUX4Z8TJEpvnJGVKD9X8kYIWDcT23Z41Q0LnRto+9JKcn1VYRvchdKn8TT7z2DnvXeZodzacmTQmlI2l4ZsQwcKso17Nav5LpwbE3Jo=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e642ef-3a0d-478f-7c7a-08d80c4a2fa8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2020 07:53:24.0948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kHQwP5yc4GY7XBiRkXlx0cAwZWM6iEwcxx6bJNcay4Z+ZS3lL5LLCfWfflYXbOnlOxW490YCGKiSz26MziK+Bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5378
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Could you please push this patch into stable@?
it fixes memory corruption in kernels  v3.5 .. v4.10

Lost .data_len definition leads to write beyond end of
struct nf_ct_h323_master. Usually it corrupts following
struct nf_conn_nat, however if nat is not loaded it corrupts
following slab object.

In mainline this problem went away in v4.11,
after commit 9f0f3ebeda47 ("netfilter: helpers: remove data_len usage
for inkernel helpers") however many stable kernels are still affected.

cc: stable@vger.kernel.org
Fixes: 1afc56794e03 ("netfilter: nf_ct_helper: implement variable length helper private data") # v3.5
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
---
 net/netfilter/nf_conntrack_h323_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index f65d93639d12..29fe1e7eac88 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1225,6 +1225,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
 	{
 		.name			= "Q.931",
 		.me			= THIS_MODULE,
+		.data_len		= sizeof(struct nf_ct_h323_master),
 		.tuple.src.l3num	= AF_INET6,
 		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
 		.tuple.dst.protonum	= IPPROTO_TCP,
-- 
2.17.1

