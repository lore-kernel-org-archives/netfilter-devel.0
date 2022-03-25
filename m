Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 374FBC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Mar 2022 14:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348126AbiCYOtr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Mar 2022 10:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359371AbiCYOtq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Mar 2022 10:49:46 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF8F654D
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Mar 2022 07:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xr7pi1wh/5hc+kw8bQG71V9e+8Z63nWzhpowcH0ULbw=; b=nRNboA+XaHhpWITg/1zYcclwa0
        Qhmw5OOQEcnPGpS8TMWcS+xCIVg0szLN0/WGp3AFr64h+Kj1yT7rgqFzPq7W2b5Z1YfBewgife7s3
        hznxev7IhCw7Bk6MXygfQzF3oth5hoAh9x51gG91NEIDH9NyYi5ycQV7rr7ual0vUO1n3p0RMDn5c
        34lFuTG30MovNcNhrwvDZdngiyxXBUkGrKWDKHXRoBVJeSCHFPDNFq2w9eb0ssZUq+vPRo41bgfGu
        fj2s/3n3+8PPUzLw3mAmdoJ9mE4rgCzsbzG+9XHfjhwKUAv5yH3W6G3mf0JVrTGZijJE9EHCRTglu
        vBT8XeCA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nXlEW-0002VX-MH; Fri, 25 Mar 2022 15:48:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnetfilter_conntrack PATCH] expect/conntrack: Avoid spurious covscan overrun warning
Date:   Fri, 25 Mar 2022 15:48:07 +0100
Message-Id: <20220325144807.18049-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It doesn't like how memset() is called for a struct nfnlhdr pointer with
large size value. Pass void pointers instead. This also removes the call
from __build_{expect,conntrack}() which is duplicate in
__build_query_{exp,ct}() code-path.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack/api.c   | 4 +++-
 src/conntrack/build.c | 2 --
 src/expect/api.c      | 4 +++-
 src/expect/build.c    | 2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index b7f64fb43ce83..7f72d07f2e7f6 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -779,6 +779,8 @@ int nfct_build_conntrack(struct nfnl_subsys_handle *ssh,
 	assert(req != NULL);
 	assert(ct != NULL);
 
+	memset(req, 0, size);
+
 	return __build_conntrack(ssh, req, size, type, flags, ct);
 }
 
@@ -812,7 +814,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
 	assert(data != NULL);
 	assert(req != NULL);
 
-	memset(req, 0, size);
+	memset(buffer, 0, size);
 
 	switch(qt) {
 	case NFCT_Q_CREATE:
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index b5a7061d53698..f80cfc12d5e38 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -27,8 +27,6 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 		return -1;
 	}
 
-	memset(req, 0, size);
-
 	buf = (char *)&req->nlh;
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | type;
diff --git a/src/expect/api.c b/src/expect/api.c
index 39cd09249684c..b100c72ded50e 100644
--- a/src/expect/api.c
+++ b/src/expect/api.c
@@ -513,6 +513,8 @@ int nfexp_build_expect(struct nfnl_subsys_handle *ssh,
 	assert(req != NULL);
 	assert(exp != NULL);
 
+	memset(req, 0, size);
+
 	return __build_expect(ssh, req, size, type, flags, exp);
 }
 
@@ -546,7 +548,7 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
 	assert(data != NULL);
 	assert(req != NULL);
 
-	memset(req, 0, size);
+	memset(buffer, 0, size);
 
 	switch(qt) {
 	case NFCT_Q_CREATE:
diff --git a/src/expect/build.c b/src/expect/build.c
index 2e0f968f36dad..1807adce26f62 100644
--- a/src/expect/build.c
+++ b/src/expect/build.c
@@ -29,8 +29,6 @@ int __build_expect(struct nfnl_subsys_handle *ssh,
 	else
 		return -1;
 
-	memset(req, 0, size);
-
 	buf = (char *)&req->nlh;
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK_EXP << 8) | type;
-- 
2.34.1

