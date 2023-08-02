Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3D8C001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjHBQKs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjHBQKq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6521995
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3/yPolv6nEugyLifIpau90FKxx68zAcA4ypp7VVibl8=; b=ZHv829uzseBjx97VbNQgIjWluP
        i2PjjY0PihFA7xB8oZViKVZDvrBX43U+NjJpyruxxn/E7LeeVRds0ibe/jmBZwuB00C6cYhzb0NrF
        KPtoJxprHkJD4B1jamLmwe3VM8JayUwruJ0fyEWbLZzlD6tuor9ImZ8nSm+iXw+ZxMeyEbKwqf1rC
        u9j+Je25A54UQ/i3Rv1FE3i5Y/4Zi2/GpWXQ6hurMCgKFJRMTsWDYNX2SVJivhSwa+cWPrhwrseAS
        RaIgsauO+UPnK+3B3jnmQGD8vM/33jC+7jIrF+O8Nh0mvVYfktayzA9Ss/0Wlszt72WL33SsfmcYC
        hAGzy7Ng==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQs-0004yR-AB
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 13/15] man: iptables-save.8: Clarify 'available tables'
Date:   Wed,  2 Aug 2023 18:09:21 +0200
Message-Id: <20230802160923.17949-14-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This appears to be confusing. Since a missing table is also not flushed
("restored") when feeding the dump into iptables-restore, such a restore
call may be considered incomplete.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-save.8.in | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 253907719acee..7f84907352238 100644
--- a/iptables/iptables-save.8.in
+++ b/iptables/iptables-save.8.in
@@ -52,7 +52,10 @@ restrict output to only one table. If the kernel is configured with automatic
 module loading, an attempt will be made to load the appropriate module for
 that table if it is not already there.
 .br
-If not specified, output includes all available tables.
+If not specified, output includes all available tables. No module loading takes
+place, so in order to include a specific table in the output, the respective
+module (something like \fBiptable_mangle\fP or \fBip6table_raw\fP) must be
+loaded first.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
-- 
2.40.0

