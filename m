Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29BAEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjHBCFd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjHBCFc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:05:32 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAD62139
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G3NEGrSjXnU3DUgT2BKOHDIgIdxk+LO5Plc8bmK7cOY=; b=qrla3WPZzTxQHjNzUp9G/MGi/n
        9e5brQn1kl/yxzTosoSuUPSa7R4WgiZB3JDRiOBYZH+il+y9qZioY0V4Is2KQvksqHPmZXhE7xW0R
        /chUQVabY+oHM1/99KEF2RWGwAZbzFCew97B52Emu1f14tkkmXMKYrsbwXYblREma+sVmH8oYw9k1
        LYvrqxqYLrbKWYPktK6MUD5I6tm5AUwWWMQZh5WRTwYe5WSS1L/eifPOTKVC/dXzAjsB04AQmF3LK
        QX2hA5lhH5izfPcsYMoWwA0YZvde9u4uv7RdEF8kjst7B+ee445oLTdzCoyHWxvnr1NfSobcrAWqN
        ONCkdBxQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Eu-0002tw-Q7; Wed, 02 Aug 2023 04:05:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 12/16] man: iptables-restore.8: Trivial: Missing space after comma
Date:   Wed,  2 Aug 2023 04:03:56 +0200
Message-Id: <20230802020400.28220-13-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Reported-by: debian@helgefjell.de
Fixes: 6a79d78986c02 ("iptables: mention iptables-apply(8) in manpages")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index f97f53813aeed..b7217b4118fc0 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -82,7 +82,7 @@ from Rusty Russell.
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu> contributed ip6tables-restore.
 .SH SEE ALSO
-\fBiptables\-apply\fP(8),\fBiptables\-save\fP(8), \fBiptables\fP(8)
+\fBiptables\-apply\fP(8), \fBiptables\-save\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
-- 
2.40.0

