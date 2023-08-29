Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B411BC83F1A
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbjH2S4q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236432AbjH2S4R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A35FD7
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MAipuHNrSFw5EOx3MB3gNrkXuzCiXyiNq8lve6hx9ws=;
        b=dJitWfuzJP5wHzeY/QMr4UnAuLRT0o8jyuW58nDoUNjD6MDbyWhDPLOC2eR/LETFOh3jMR
        VjhCphA/hcLlV5eDJPw03ce7gtk17ZbgR/HkVSHb0oKybsG5jYZGEmR56nyDyKdYf14RJ6
        4ij6JViK8GEc630bOIOXsQMOeGNH4B0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-g0rKnT9jNEyH5djsKWdZQw-1; Tue, 29 Aug 2023 14:55:26 -0400
X-MC-Unique: g0rKnT9jNEyH5djsKWdZQw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD9C93810D35
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 18:55:25 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4E7BA401E54;
        Tue, 29 Aug 2023 18:55:25 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/5] rule: fix "const static" declaration
Date:   Tue, 29 Aug 2023 20:54:07 +0200
Message-ID: <20230829185509.374614-2-thaller@redhat.com>
In-Reply-To: <20230829185509.374614-1-thaller@redhat.com>
References: <20230829185509.374614-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gcc warns against this with "-Wextra":

    src/rule.c:869:1: error: static is not at beginning of declaration [-Werror=old-style-declaration]
      869 | const static struct prio_tag std_prios[] = {
          | ^~~~~
    src/rule.c:878:1: error: static is not at beginning of declaration [-Werror=old-style-declaration]
      878 | const static struct prio_tag bridge_std_prios[] = {
          | ^~~~~

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/rule.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 8ea606e146b2..bbea05d5b288 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -866,7 +866,7 @@ struct prio_tag {
 	const char *str;
 };
 
-const static struct prio_tag std_prios[] = {
+static const struct prio_tag std_prios[] = {
 	{ NF_IP_PRI_RAW,      "raw" },
 	{ NF_IP_PRI_MANGLE,   "mangle" },
 	{ NF_IP_PRI_NAT_DST,  "dstnat" },
@@ -875,7 +875,7 @@ const static struct prio_tag std_prios[] = {
 	{ NF_IP_PRI_NAT_SRC,  "srcnat" },
 };
 
-const static struct prio_tag bridge_std_prios[] = {
+static const struct prio_tag bridge_std_prios[] = {
 	{ NF_BR_PRI_NAT_DST_BRIDGED,  "dstnat" },
 	{ NF_BR_PRI_FILTER_BRIDGED,   "filter" },
 	{ NF_BR_PRI_NAT_DST_OTHER,    "out" },
-- 
2.41.0

