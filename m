Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CFA4EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbjHBCEe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjHBCEd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F3B610E
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nv+9yDxHPWuwpmCRZwX8eRrIn2pL5TbGUnBRPYvyUsI=; b=JUATgdjDV8ARmw8qWHLeBElgvh
        B7WZnSc33L8AZOtpYHbL69Oxm7e6kcCJNGW/GapagkEnVrlxmF7kiP0m8yUz9Cz1F5A7t0YCsfk2G
        05w5IbpDtgCMjuP/BxJ2RJipQwHC280hOHx6KvIuHXJE0dxd5PX/G1m1vvyYTp0Rb+frIwB28aZum
        AupryVzOQcMg6bpAgliLHzFCpdOiQq8dDzZuqXWZJizcucQ9vJBvOF7pqtaiOYsIszh5NDeGHJbjN
        0PU2Sm6mw1NCjLX95ZeLNdgep0e/rNh+GYBM/amVG8GCWNpioN8c4wkFnr0LU6rq+dI3u1aRAuZLb
        Eulo2Iaw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1Dx-0002p5-Vv; Wed, 02 Aug 2023 04:04:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 16/16] man: iptables-save.8: Trivial: Missing space in enumeration
Date:   Wed,  2 Aug 2023 04:04:00 +0200
Message-Id: <20230802020400.28220-17-phil@nwl.cc>
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
 iptables/iptables-save.8.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 540f85d485ee2..bcf446cd3e5b1 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -66,7 +66,7 @@ Rusty Russell <rusty@rustcorp.com.au>
 .br
 Andras Kis-Szabo <kisza@sch.bme.hu> contributed ip6tables-save.
 .SH SEE ALSO
-\fBiptables\-apply\fP(8),\fBiptables\-restore\fP(8), \fBiptables\fP(8)
+\fBiptables\-apply\fP(8), \fBiptables\-restore\fP(8), \fBiptables\fP(8)
 .PP
 The iptables-HOWTO, which details more iptables usage, the NAT-HOWTO,
 which details NAT, and the netfilter-hacking-HOWTO which details the
-- 
2.40.0

