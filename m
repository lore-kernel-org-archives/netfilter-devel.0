Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4EBC04E69
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjHBQJ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbjHBQJ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:09:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB08D171B
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fm9uswpRhmQWLrC/6KteD+0m5GS1oHPRauVPEvYafMA=; b=cJ/OS9pfeXJrf6WUS5qvb5T7mc
        dBhom3kUxManIfaIxgLVhlNfJiczDqAmKmiM4QTq8lx+LwCJv5o2dPmRWHvRb+u05MGDP6U6zQJcy
        j0btDwaN/Kl4D1bRReu383K5RKwlkcEbhaCS9vWtu8kNr++Uxa9eWfRvuDBG0jsG+bzFqvpCtxUE9
        G8xA6xNnhJ84BudvhSwfoqOWI7VaHx7qv01HGis+W4H1QKUM3BpozwA1M8G8+v2ym2P4lxBwlk2k+
        D7OlSfGpvk7dYBl6bXYpwm1aNZxzEZ0MVTnIh9tTzAEXRBZhanoztYRL4aXC1o7zQF0MOYPbXRkh7
        4gecX65A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQ5-0004u7-9i
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:09:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 14/15] man: iptables-save.8: Fix --modprobe description
Date:   Wed,  2 Aug 2023 18:09:22 +0200
Message-Id: <20230802160923.17949-15-phil@nwl.cc>
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
- Put the path in italics and the command in bold

Fixes: fbb5639c02218 ("iptables-save: module loading corrections")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Non-bold "modprobe" and iptables-restore program name
---
 iptables/iptables-save.8.in | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 7f84907352238..118dddcdf62d5 100644
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
+Specify the path to the modprobe(8) program. By default,
+iptables-save will inspect \fI/proc/sys/kernel/modprobe\fP to determine
+the executable's path.
 .TP
 \fB\-f\fR, \fB\-\-file\fR \fIfilename\fP
 Specify a filename to log the output to. If not specified, iptables-save
-- 
2.40.0

