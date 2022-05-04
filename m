Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3BFC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 10:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239023AbiEDKiN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 06:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiEDKiM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 06:38:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6FD1402B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 03:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+DRnxaXPa5BUNe8COOwQLyk2WYafhKVyszCVdLRcIUI=; b=YSlGmj3DcRbId2hVIwKlZU7zHL
        TN+A3wSewROAbjidMkP5M1chIxGrtwunQ+OyS9mbdNzFy1Htcjbmm+au0DQLJlgx/IIs68ZLHeSFo
        w6wRby9IUOam7cl9tFxsAvgSGPO6YeGOj3R+KqfDIkwYeatkVVCsIiH53hgV94buQCZAa6Oid36hJ
        6mFMxjnicqkxEJKQ8uEN0ucx+LpmgbJD1OlWsm3bU7LSlXXVpcbHkdt8m57FVLuomESplP1tcabbs
        O29DxqConBlx/2Uq/ygv7jnc4AgANZr0erkXBkS5EDA7UPoWOjFfNX/rbwNArmHEvBesLlg6QCQCO
        Qfb162rg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nmCL5-0008Pe-Mq; Wed, 04 May 2022 12:34:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/4] extensions: LOG: Document --log-macdecode in man page
Date:   Wed,  4 May 2022 12:34:15 +0200
Message-Id: <20220504103416.19712-4-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504103416.19712-1-phil@nwl.cc>
References: <20220504103416.19712-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Help text already contains it, so no update needed there.

Fixes: 127647892c7ca ("extensions: libipt_LOG/libip6t_LOG: support macdecode option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_LOG.man | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/extensions/libxt_LOG.man b/extensions/libxt_LOG.man
index 354edf4cc2916..1d5071ba720b9 100644
--- a/extensions/libxt_LOG.man
+++ b/extensions/libxt_LOG.man
@@ -30,3 +30,6 @@ Log options from the IP/IPv6 packet header.
 .TP
 \fB\-\-log\-uid\fP
 Log the userid of the process which generated the packet.
+.TP
+\fB\-\-log\-macdecode\fP
+Log MAC addresses and protocol.
-- 
2.34.1

