Return-Path: <SRS0=suW2=DF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CBE7C2D0A8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 12:26:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16C6E207E8
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Sep 2020 12:26:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Jomg2fWl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgI1M0g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Sep 2020 08:26:36 -0400
Received: from mx1.riseup.net ([198.252.153.129]:39798 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgI1M0g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Sep 2020 08:26:36 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4C0MFm3nMjzFmPL;
        Mon, 28 Sep 2020 05:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1601295996; bh=3exaNZ4grBQ8R+mul9vr1GGAo55bVMLbiXJqmOvsWWI=;
        h=From:To:Cc:Subject:Date:From;
        b=Jomg2fWlmG59QeXcnmMmQFCAlwSIQz9nuwAmy/GiVvTu1lFW4hh5I52erWvh2Y66y
         nszwiX7LskT4Aow7jtaR4ur2/kWDQYeWeJx4gzaXKqIJAXaib6MI4yFTzfUKoo15HR
         iBytwYA1AeJpwYCZ4nOvNZFRiTT21eFr1nyfZ8yA=
X-Riseup-User-ID: 1EA09CD577E9EE38083A81C0975F633E01BEC4752F8E3E2D06B7B773A104CFB1
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 4C0MFl5B8jzJmxx;
        Mon, 28 Sep 2020 05:26:35 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: use nla_memdup to copy udata
Date:   Mon, 28 Sep 2020 14:24:57 +0200
Message-Id: <20200928122457.6411-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When userdata support was added to tables and objects, user data coming
from user space was allocated and copied using kzalloc + nla_memcpy.

Use nla_memdup to copy userdata of tables and objects.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b3c3c3fc1969..a4393eddaffd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1024,11 +1024,10 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_TABLE_USERDATA]) {
 		udlen = nla_len(nla[NFTA_TABLE_USERDATA]);
-		table->udata = kzalloc(udlen, GFP_KERNEL);
+		table->udata = nla_memdup(nla[NFTA_TABLE_USERDATA], GFP_KERNEL);
 		if (table->udata == NULL)
 			goto err_table_udata;
 
-		nla_memcpy(table->udata, nla[NFTA_TABLE_USERDATA], udlen);
 		table->udlen = udlen;
 	}
 
@@ -5958,11 +5957,10 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_OBJ_USERDATA]) {
 		udlen = nla_len(nla[NFTA_OBJ_USERDATA]);
-		obj->udata = kzalloc(udlen, GFP_KERNEL);
+		obj->udata = nla_memdup(nla[NFTA_OBJ_USERDATA], GFP_KERNEL);
 		if (obj->udata == NULL)
 			goto err_userdata;
 
-		nla_memcpy(obj->udata, nla[NFTA_OBJ_USERDATA], udlen);
 		obj->udlen = udlen;
 	}
 
-- 
2.28.0

