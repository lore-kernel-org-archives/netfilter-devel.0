Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA73C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 15:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiLTPjV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 10:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiLTPjU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 10:39:20 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76015E0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 07:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=X4naVIVqK7eTpUSEybE3n/RTgudBwOsPaGOW58kLOJI=; b=gWGi+vTawIFBxdRbH9GbNlnO6L
        OkZfZUnkLSS9oL8skIUx+cc0drGUqfPFRxMmgXrG5QEAt2qWCttHXXa7pLJ47X4I3U0fIHW4v0h3a
        F+igK4skbi2nOGkvXmYKYGy/iz0dTOkG9Fn6vF5PyHmhWkgT0s25Z18J+5JvI3O7qS+wTeI0GIkkB
        C3BQbswrTDoVZa3ESBBMJn6gI1FSP1YXvjghv9LXiyJvJaNrLchfZGImEbKZcicYVNCAUFk0S3pep
        pvorhVM2xNYa+ePUZk6AwdEHTMiJa9BCZtmekwTMuIp4MDlg9g6C1pP8+T6VIo0wkoceixJDuWlwM
        bBD2PaBw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p7ei5-0000GS-8Y; Tue, 20 Dec 2022 16:39:17 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [conntrack-tools PATCH 4/4] conntrack: Sanitize free_tmpl_objects()
Date:   Tue, 20 Dec 2022 16:38:47 +0100
Message-Id: <20221220153847.24152-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221220153847.24152-1-phil@nwl.cc>
References: <20221220153847.24152-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function unconditionally dereferenced its parameter, yet it is
possible for the passed 'cur_tmpl' pointer when called from exit_error()
to be still NULL: It is assigned to by alloc_tmpl_objects() at start of
do_parse(), though callers of that function might call exit_error() in
beforehand.

Fixes: 258b4540f4512 ("conntrack: add struct ct_tmpl")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/conntrack.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/conntrack.c b/src/conntrack.c
index 2bd71e17e6be6..23eaf274a78a1 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -139,6 +139,8 @@ static int alloc_tmpl_objects(struct ct_tmpl *tmpl)
 
 static void free_tmpl_objects(struct ct_tmpl *tmpl)
 {
+	if (!tmpl)
+		return;
 	if (tmpl->ct)
 		nfct_destroy(tmpl->ct);
 	if (tmpl->exptuple)
-- 
2.38.0

