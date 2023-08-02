Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BD53EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjHBCFF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjHBCFE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:05:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B75B10E
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=azUVxuSWTUOUP4KzlKHHp0ceYQKkLjXam8gCzUuOZ3k=; b=HGhDx3AjmtO08yLO27Eo2M2Xk7
        iWz+SF7yiYmzq+/OocDpSFAhOTVGjUTl1IdpwouDnzt2vFw/dQ5rGnAYXaM+j94x8KiJ+EP1+O/c8
        7KX9cL7pjMQsRCwvnW02iO/7B50LTazVOGl9yB3DhybZ/eII7mlLJj4ojEFFjFVl4bZEo0omISQ73
        I1D0P7wYNHqQT+FHYUyNX40daQH9LmPBORSQYNf1gYYZ0zRCTPVu0cNzImXwKXThxL54mRRpKRF8N
        Jbi05RWislJP5froAQyJ/mk6ZiYCiKGN8g+Cvx4/Qb9XxAmwEKFE+gUIuyqiO2vCQwM3owRi70A6q
        cCwoBwWg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1EU-0002rr-3B; Wed, 02 Aug 2023 04:05:02 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     debian@helgefjell.de
Subject: [iptables PATCH 14/16] man: iptables-save.8: Fix --modprobe description
Date:   Wed,  2 Aug 2023 04:03:58 +0200
Message-Id: <20230802020400.28220-15-phil@nwl.cc>
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
- Put the path in italics and the command in bold

Reported-by: debian@helgefjell.de
Fixes: fbb5639c02218 ("iptables-save: module loading corrections")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-save.8.in | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index cea972bcd6e0e..c0d9b202ad7bd 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -36,9 +36,10 @@ and
 are used to dump the contents of IP or IPv6 Table in easily parseable format
 either to STDOUT or to a specified file.
 .TP
-\fB\-M\fR, \fB\-\-modprobe\fR \fImodprobe_program\fP
-Specify the path to the modprobe program. By default, iptables-save will
-inspect /proc/sys/kernel/modprobe to determine the executable's path.
+\fB\-M\fR, \fB\-\-modprobe\fR \fImodprobe\fP
+Specify the path to the \fBmodprobe\fP(8) program. By default,
+\fBiptables-save\fP will inspect \fI/proc/sys/kernel/modprobe\fP to determine
+the executable's path.
 .TP
 \fB\-f\fR, \fB\-\-file\fR \fIfilename\fP
 Specify a filename to log the output to. If not specified, iptables-save
-- 
2.40.0

