Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EB1C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E8D265142
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 01:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232328AbhCHBYb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 20:24:31 -0500
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:36996 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbhCHBY2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 20:24:28 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Mar 2021 20:24:28 EST
Received: from fanir.tuyoix.net ([68.150.218.192])
        by shaw.ca with ESMTP
        id J4VGlVwWwnRGtJ4VHlAVVW; Sun, 07 Mar 2021 18:16:11 -0700
X-Authority-Analysis: v=2.4 cv=cagXElPM c=1 sm=1 tr=0 ts=60457adb
 a=LfNn7serMq+1bQZBlMsSfQ==:117 a=LfNn7serMq+1bQZBlMsSfQ==:17
 a=dESyimp9J3IA:10 a=M51BFTxLslgA:10 a=3I1X_3ewAAAA:8 a=ljtVHcs82eP08VpLTIoA:9
 a=QEXdDO2ut3YA:10 a=VG9N9RgkD3hcbI6YpJ1l:22
Received: from tuyoix.net (fanir.tuyoix.net [192.168.144.16])
        (authenticated bits=0)
        by fanir.tuyoix.net (8.15.2/8.15.2) with ESMTPSA id 1281GAQa020152
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 7 Mar 2021 18:16:10 -0700
Date:   Sun, 7 Mar 2021 18:16:10 -0700 (MST)
From:   =?UTF-8?Q?Marc_Aur=C3=A8le_La_France?= <tsi@tuyoix.net>
To:     Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: {PATCH nf] x_tables: Allow REJECT targets in PREROUTING chains
Message-ID: <alpine.LNX.2.20.2103071733480.15162@fanir.tuyoix.net>
User-Agent: Alpine 2.20 (LNX 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463807856-687965147-1615163781=:15162"
Content-ID: <alpine.LNX.2.20.2103071815490.20147@fanir.tuyoix.net>
X-CMAE-Envelope: MS4xfGgClr2WH1WuigY+YUeuC9a4akfbsDDnHKjbke2tOh0IAAoy6RwWAiWdQIiLojc+TY37TI7chc775KtTznU418dHhtthH1X6kMwesDuU7az2Ogl+EuW5
 6M4J33vI/1u9R7MWitfjJ0jAHvoR5AOatQJIgDof/IAV9c4o0oX//px1epnTTPGjJCfE7P8ITFxXZevSwmToNziGXxIn9NWFlV+eGqMn9RrsMVOCZ+zKDRpy
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

---1463807856-687965147-1615163781=:15162
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.20.2103071749511.15181@fanir.tuyoix.net>

Extend commit f53b9b0bdc59c0823679f2e3214e0d538f5951b9 "netfilter:
introduce support for reject at prerouting stage", which appeared in
5.9, by making the corresponding changes to x_tables REJECT targets.

Please Reply-To-All.

Thanks.

Marc.

Signed-off-by: Marc Aurèle La France <tsi@tuyoix.net>
Tested-by: Marc Aurèle La France <tsi@tuyoix.net>

--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -92,7 +92,7 @@ static struct xt_target reject_tg_reg __read_mostly = {
 	.targetsize	= sizeof(struct ipt_reject_info),
 	.table		= "filter",
 	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT),
+			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_PRE_ROUTING),
 	.checkentry	= reject_tg_check,
 	.me		= THIS_MODULE,
 };
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -102,7 +102,7 @@ static struct xt_target reject_tg6_reg __read_mostly = {
 	.targetsize	= sizeof(struct ip6t_reject_info),
 	.table		= "filter",
 	.hooks		= (1 << NF_INET_LOCAL_IN) | (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_LOCAL_OUT),
+			  (1 << NF_INET_LOCAL_OUT) | (1 << NF_INET_PRE_ROUTING),
 	.checkentry	= reject_tg6_check,
 	.me		= THIS_MODULE
 };
---1463807856-687965147-1615163781=:15162--
