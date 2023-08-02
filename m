Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C6AEB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 02:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjHBCE7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Aug 2023 22:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbjHBCE7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Aug 2023 22:04:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D49E10E
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Aug 2023 19:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=doQhBd/HdmPLkIuGJtYGaZfqJd5g8eXR8VirEGe04JQ=; b=hop/GqjOLhP9wzziSiA+wtCJ41
        zD7WQ/TsHQi0nIDxU3tu1S/OCurHgyVNedujDz3ruVDhe5DxXc7scMh8TQr4wSbLR9sNN+Hs4i3iX
        rcfdnJfbksKJASViuVTiubezsqnIpNJiICHpfJGPrR3vftYIouCw95mKR5L2xvmWbs2xtlf/Ral2q
        fZQyPX9o5Jkf3u5AzatUZcLFqrbKIEb5azR5LcAx1RqRYLyWsvofGbCYpWNJ343w4qlDbJ9S9Plh+
        gFQXrg5yhv/Ny7tTI3qxK7CVjWXWYdCCuLMWsA8l9/YeGgbS8CjzCzduQht358oJJbukvhCtbUuUh
        /FTLtXVA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qR1EO-0002qx-Po; Wed, 02 Aug 2023 04:04:56 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jean-Paul Calderone <jean-paul@hybridcluster.net>
Subject: [iptables PATCH 13/16] man: iptables-save.8: Clarify 'available tables'
Date:   Wed,  2 Aug 2023 04:03:57 +0200
Message-Id: <20230802020400.28220-14-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802020400.28220-1-phil@nwl.cc>
References: <20230802020400.28220-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This appears to be confusing. Since a missing table is also not flushed
("restored") when feeding the dump into iptables-restore, such a restore
call may be considered incomplete.

Reported-by: Jean-Paul Calderone <jean-paul@hybridcluster.net>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=960
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/iptables-save.8.in | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/iptables/iptables-save.8.in b/iptables/iptables-save.8.in
index 7683fd3780f72..cea972bcd6e0e 100644
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

