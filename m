Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 172CEEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjHBCEi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHBCEh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E025A10E
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KijLO1e05hSmoFQnYcGHbp7UPgycLJh8Y3j16rpQHbc=; b=F/8yc/akvd7eMdu5qa0aSRepIB
        tFiGAcUlHRGBvsVSl/efRuhlcNB/gc5dNk0NKr9wMuD6x5WAsNUlEwqAkcvsA3rOPZZvFZFnEIGIu
        4On0VUtn+4+vc9tZ0wBjhlD6w1nqlK3YUrubHp9ctcRgWg4op/SWPP4uFOJVA6EJivDcg1+EZTdFV
        dmI+eziByQx8jHbL02TpMogzGeRsJ08saB/mPFO+hAB0aIbCI67pYWsK60byLXjC+u3PjmUAEALdK
        3j6PAkiAqKLRYSe8cdJNq7a+Rk86W+iThvzq4ckdB8EQ8B2cp8NuIQYaKN1r86Xp8WvwUZINrB411
        tojlENbA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1E3-0002qB-At; Wed, 02 Aug 2023 04:04:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 07/16] man: iptables-restore.8: Fix --modprobe description
Date:   Wed,  2 Aug 2023 04:03:51 +0200
Message-Id: <20230802020400.28220-8-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Consistently use 'modprobe' as option argument name
- Add a reference to modprobe man page
- Put the path in italics, and the command in bold

Reported-by: debian@helgefjell.de
Fixes: 8c46901ff5785 ("doc: document iptables-restore's -M option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-restore.8.in | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 20216842d8358..5846a47cefbcc 100644
--- a/iptables/iptables-restore.8.in
+++ b/iptables/iptables-restore.8.in
@@ -67,9 +67,10 @@ the program will exit if the lock cannot be obtained.  This option will
 make the program wait (indefinitely or for optional \fIseconds\fP) until
 the exclusive lock can be obtained.
 .TP
-\fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
-Specify the path to the modprobe program. By default, iptables-restore will
-inspect /proc/sys/kernel/modprobe to determine the executable's path.
+\fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe\fP
+Specify the path to the \fBmodprobe\fP(8) program. By default,
+\fBiptables-restore\fP will inspect \fI/proc/sys/kernel/modprobe\fP to
+determine the executable's path.
 .TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
-- 
2.40.0

