Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F3BC001DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 16:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjHBQK3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 12:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjHBQK2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 12:10:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCD7171B
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 09:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YIFW9NswOndTXfKRhwMgvdZaEdBxOvo3HVNYO65T/g4=; b=pkeeJ12q1n7K+czEDqeFe4zqZF
        DNe6OMj4dpT+UyVItfmKIoJ6S8vd6/hBoXVRZq6pXItO8A0SAev0sr7DNjtYwvAHb++tCjSCfEs7/
        O9+odseSlbHNpiXaFjC6H5bFxvKsEumDCbJNdduu1AmJxE4EVTn4d1CWcTmF/OiATODaNftf8mcyU
        0IQ3GCI8u5WbS8WwYucXWD7mOmGXLPN/WQDjrctUPrZA+nVAy9SQwjokSP/SMkx8KKyumOjv4U7wU
        bRHjHWtr5FLSvkLY1WUPzVixHvmN9WW6ys5wvNrNRJOhemFUwRHxHH0qF/aY2wbxHDHZ0ezdAHRkk
        62MhbpFg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qREQb-0004ve-OV
        for netfilter-devel@vger.kernel.org; Wed, 02 Aug 2023 18:10:25 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 05/15] man: Use HTTPS for links to netfilter.org
Date:   Wed,  2 Aug 2023 18:09:13 +0200
Message-Id: <20230802160923.17949-6-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230802160923.17949-1-phil@nwl.cc>
References: <20230802160923.17949-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The browser is redirected there anyway, but who cares about such minor
details nowadays.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_nfacct.man | 2 +-
 iptables/iptables.8.in      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_nfacct.man b/extensions/libxt_nfacct.man
index b755f9770451c..a818fedd6b1ac 100644
--- a/extensions/libxt_nfacct.man
+++ b/extensions/libxt_nfacct.man
@@ -26,5 +26,5 @@ nfacct get http\-traffic
 .PP
 You can obtain
 .B nfacct(8)
-from http://www.netfilter.org or, alternatively, from the git.netfilter.org
+from https://www.netfilter.org or, alternatively, from the git.netfilter.org
 repository.
diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
index c83275b294872..71a6251d6b00c 100644
--- a/iptables/iptables.8.in
+++ b/iptables/iptables.8.in
@@ -419,7 +419,7 @@ allocation or error messages from kernel cause an exit code of 4. Finally,
 other errors cause an exit code of 1.
 .SH BUGS
 Bugs?  What's this? ;-)
-Well, you might want to have a look at http://bugzilla.netfilter.org/
+Well, you might want to have a look at https://bugzilla.netfilter.org/
 \fBiptables\fP will exit immediately with an error code of 111 if it finds
 that it was called as a setuid-to-root program.
 iptables cannot be used safely in this manner because it trusts
@@ -463,7 +463,7 @@ not in the standard distribution,
 and the netfilter-hacking-HOWTO details the netfilter internals.
 .br
 See
-.BR "http://www.netfilter.org/" .
+.BR "https://www.netfilter.org/" .
 .SH AUTHORS
 Rusty Russell originally wrote iptables, in early consultation with Michael
 Neuling.
-- 
2.40.0

