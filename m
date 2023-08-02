Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F41CC04E69
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbjHBQK7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjHBQK4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F311A1BFD
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YyOdPY7JOT9qXh8KSqS/mkJe3O79T5nqBXa7lzRmg0w=; b=ReDe813QhhmeuBhdddImiF4Qx9
        MXaTXCocUqnG5NL7V4fJ4yEFJoUqKiJBTMs8vdQE2hPf00YTmXplIeYS5R23Csa7IjmcWe3pNAmkt
        M2Qli2LWO1n4M3QfxRmjkZMVmZ+2bDxWG9DN4nMN1hM67qWPX/V1bNEGJI1o0bbcsIf+3BarMvGCV
        xpxrpTcLBcFw6NRJDGSiy+uK8u27O49VJOhcrvs5TTzqHn7yHhh6CFRodi6EK6Ok0psmJk/r18FVj
        rMjUSnWkFiTvxp07QYURbGufW7le1kul39Iey1iL+xiAP2YgRuqGNA4T96EU+ciAbVNqJ4OFaKJRX
        y9rOrO/A==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qRER3-0004yu-Cq
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:53 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 06/15] man: iptables.8: Trivial font fixes
Date:   Wed,  2 Aug 2023 18:09:14 +0200
Message-Id: <20230802160923.17949-7-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No content changes intended, just type commands in bold and the single
path reference in italics.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Put only commands in bold font, not program names
- Add missing dash-escaping if done so
---
 iptables/iptables.8.in | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 71a6251d6b00c..ecaa5553942df 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -244,13 +244,13 @@ add, delete, insert, replace and append commands).
 \fB\-4\fP, \fB\-\-ipv4\fP
 This option has no effect in iptables and iptables-restore.
 If a rule using the \fB\-4\fP option is inserted with (and only with)
-ip6tables-restore, it will be silently ignored. Any other uses will throw an
+\fBip6tables\-restore\fP, it will be silently ignored. Any other uses will throw an
 error. This option allows IPv4 and IPv6 rules in a single rule file
 for use with both iptables-restore and ip6tables-restore.
 .TP
 \fB\-6\fP, \fB\-\-ipv6\fP
 If a rule using the \fB\-6\fP option is inserted with (and only with)
-iptables-restore, it will be silently ignored. Any other uses will throw an
+\fBiptables\-restore\fP, it will be silently ignored. Any other uses will throw an
 error. This option allows IPv4 and IPv6 rules in a single rule file
 for use with both iptables-restore and ip6tables-restore.
 This option has no effect in ip6tables and ip6tables-restore.
@@ -260,7 +260,7 @@ The protocol of the rule or of the packet to check.
 The specified protocol can be one of \fBtcp\fP, \fBudp\fP, \fBudplite\fP,
 \fBicmp\fP, \fBicmpv6\fP, \fBesp\fP, \fBah\fP, \fBsctp\fP, \fBmh\fP or the special keyword "\fBall\fP",
 or it can be a numeric value, representing one of these protocols or a
-different one.  A protocol name from /etc/protocols is also allowed.
+different one.  A protocol name from \fI/etc/protocols\fP is also allowed.
 A "!" argument before the protocol inverts the
 test.  The number zero is equivalent to \fBall\fP. "\fBall\fP"
 will match with all protocols and is taken as default when this
-- 
2.40.0

