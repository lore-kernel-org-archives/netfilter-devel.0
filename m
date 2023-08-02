Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10C0C04A6A
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjHBQKR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjHBQKR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC16171B
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O9ff9VwU8539S4y35OlwcuzvSXJMart4G6FNtPa++zQ=; b=Udp4y7DaOoHdAjdF6Nzky4Npvn
        fG9RQjASVzEZtr3iL8O/9wEbklCHbt4178u0Oqp4Bl+2z6cFowqrK+2LWGZnhXxeGaF6NxCz/GD5y
        iv6ilhiHnLOQ9HrzR2Jmqod2smV2x1rpy2eByY5HeweUwIRi7NzOxmQNkblov7n8BACP3z4CWBpnJ
        lkBYkJGHgu6B8bQ2O7tuP7BCC/VVjsZlHH1Brm1BbAYYpw/y89dgJd4M4WIdZw0G9PK5iryHFrsXb
        /B0hAgJpDhmsMkl9z2r8hVK9mXyJZuV8itM3Bq8Uof0hQUsh+RSA9pgNV4Y5O3hj4J2OiDANqhxa7
        +TztWLIQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQQ-0004vQ-Ta
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:15 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 03/15] man: iptables.8: Fix intra page reference
Date:   Wed,  2 Aug 2023 18:09:11 +0200
Message-Id: <20230802160923.17949-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When sections MATCH EXTENSIONS and TARGET EXTENSIONS were combined, the
reference could have been updated to specify the exact title.

Fixes: 4496801821c01 ("doc: deduplicate extension descriptions into a new manpage")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables.8.in | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index 6486588e34744..85af18008daab 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -307,8 +307,8 @@ false, evaluation will stop.
 This specifies the target of the rule; i.e., what to do if the packet
 matches it.  The target can be a user-defined chain (other than the
 one this rule is in), one of the special builtin targets which decide
-the fate of the packet immediately, or an extension (see \fBEXTENSIONS\fP
-below).  If this
+the fate of the packet immediately, or an extension (see \fBMATCH AND TARGET
+EXTENSIONS\fP below).  If this
 option is omitted in a rule (and \fB\-g\fP
 is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
-- 
2.40.0

