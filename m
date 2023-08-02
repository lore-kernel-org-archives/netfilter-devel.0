Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C44C001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjHBQJm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232795AbjHBQJl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:09:41 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA2A1BFD
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5TO84p//iC6CUeE9Yli1pcrPhWmNJx07POOwnhKFWVs=; b=dU4JsrhSKCpVG9fAa5UUfX7mtz
        5Oi3KwSuZUYbOT8oAY1Olsdha6hfhY11NTNUKFJBsC2s3CkAHsnzcDhczXd463VvmHN6cudYkTWkp
        1XZC+fjNpz/37SyNnmufV9E7Q+ECStdI/sOCZYXkBIvqQ6HC/zM+xzeOlzFx7Tsz6O5V0LSQkONL7
        5ugQAJYjSmc5PToZq2S11jjfNx8uQT0Ol23Iq88Vza4LsNlIxK16s3OqNSwuquspLQ+zry1OZ+ta7
        DGr4O6142OMPO7xkVCULyTlFXFNIBq3zc/cmWrKGzN7u0iTR/M2bBrib4xGvzp2FMzb9sZtMXetCK
        CUquoV7A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREPp-0004tq-6h
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:09:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/15] man: iptables-restore.8: Fix --modprobe description
Date:   Wed,  2 Aug 2023 18:09:15 +0200
Message-Id: <20230802160923.17949-8-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

- Consistently use 'modprobe' as option argument name
- Add a reference to modprobe man page
- Put the path in italics, and the command in bold

Fixes: 8c46901ff5785 ("doc: document iptables-restore's -M option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Non-bold "modprobe" and iptables-restore program name
---
 iptables/iptables-restore.8.in | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
index 20216842d8358..f95f00acd8d49 100644
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
+Specify the path to the modprobe(8) program. By default,
+iptables-restore will inspect \fI/proc/sys/kernel/modprobe\fP to
+determine the executable's path.
 .TP
 \fB\-T\fP, \fB\-\-table\fP \fIname\fP
 Restore only the named table even if the input stream contains other ones.
-- 
2.40.0

