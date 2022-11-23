Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A79C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 16:44:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbiKWQoj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 11:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239081AbiKWQoi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 11:44:38 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6916D975
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 08:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KJZ0nEO1VBlWJ2KeVCjw/8w9I7aYSpIIsBbb6aomuao=; b=IrIYDa0n2n7vlzcf9bRcqA3Dlr
        YAvWwJjf2sC/+NlM24oLDfYsFIY9AlpHaful4b2ti0u6HMIJyXWZCbOpKfM8MKZXn3ngFMkrAGxId
        4372020LgSG8prP6Ufkddw/Lx/6XgMoWAcSwh6c1EalUSK+WBjW3WIoW2q32GanKDitfgF9JMjOPK
        175HY6lWsHmLTLB8thSMVqVE4CGdmd9lfWuaaXFlokJVDYLAJCb+Dcw5To1zo2Yx27qPSNPiljwGb
        WAIPViyezxMp4/MJOqtmhWE6r+D9nvcX8fj4R7TAqy+wfRZJpOXk8ivP57UaZ7z+6gkFeiPzsZKbL
        KkRAbiaw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oxsrU-0003xN-0h
        for netfilter-devel@vger.kernel.org; Wed, 23 Nov 2022 17:44:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/13] extensions: tcp: Translate TCP option match
Date:   Wed, 23 Nov 2022 17:43:47 +0100
Message-Id: <20221123164350.10502-11-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221123164350.10502-1-phil@nwl.cc>
References: <20221123164350.10502-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A simple task since 'tcp option' expression exists.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_tcp.c      | 9 ++++++---
 extensions/libxt_tcp.txlate | 6 ++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 0b115cddf15d9..043382d47b8ba 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -430,9 +430,12 @@ static int tcp_xlate(struct xt_xlate *xl,
 		space = " ";
 	}
 
-	/* XXX not yet implemented */
-	if (tcpinfo->option || (tcpinfo->invflags & XT_TCP_INV_OPTION))
-		return 0;
+	if (tcpinfo->option) {
+		xt_xlate_add(xl, "%stcp option %u %s", space, tcpinfo->option,
+			     tcpinfo->invflags & XT_TCP_INV_OPTION ?
+			     "missing" : "exists");
+		space = " ";
+	}
 
 	if (tcpinfo->flg_mask || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
 		xt_xlate_add(xl, "%stcp flags %s", space,
diff --git a/extensions/libxt_tcp.txlate b/extensions/libxt_tcp.txlate
index 921d4af024d32..a1f0e909bb46c 100644
--- a/extensions/libxt_tcp.txlate
+++ b/extensions/libxt_tcp.txlate
@@ -24,3 +24,9 @@ nft add rule ip filter INPUT ip frag-off & 0x1fff != 0 ip protocol tcp counter
 
 iptables-translate -A INPUT ! -f -p tcp --dport 22
 nft add rule ip filter INPUT ip frag-off & 0x1fff 0 tcp dport 22 counter
+
+iptables-translate -A INPUT -p tcp --tcp-option 23
+nft add rule ip filter INPUT tcp option 23 exists counter
+
+iptables-translate -A INPUT -p tcp ! --tcp-option 23
+nft add rule ip filter INPUT tcp option 23 missing counter
-- 
2.38.0

