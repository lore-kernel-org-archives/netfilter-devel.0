Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1CB6C25B6D
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233988AbjJXKBd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbjJXKB3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FFDD68
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698141643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZgGBoKML0QNhyikZ+R4kbZQGYxek3acLPlnqOUF1c5k=;
        b=ao5ne86RWLRcilSgjlH4cIU+w3yUCcE1rlRjpd3W+OnssY21Fe1ZkIr9nbHfKLMvPWpGoT
        701z+EbOe4USu86YJjazv//ctteSrsaAvpVvMXjcMRkmfS+5LdOB6ykoFIUjrcbsZZGuWd
        zR8k1W63oHkQHPYnPHTxn6ix9yP/UII=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-4m-8RU59NzK2rYvWomQmjg-1; Tue, 24 Oct 2023 06:00:42 -0400
X-MC-Unique: 4m-8RU59NzK2rYvWomQmjg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E950A891F28
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 10:00:41 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.225])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 656A21121318;
        Tue, 24 Oct 2023 10:00:41 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft v2 1/4] datatype: don't return a const string from cgroupv2_get_path()
Date:   Tue, 24 Oct 2023 11:57:07 +0200
Message-ID: <20231024095820.1068949-2-thaller@redhat.com>
In-Reply-To: <20231024095820.1068949-1-thaller@redhat.com>
References: <20231024095820.1068949-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The caller is supposed to free the allocated string. Return a non-const
string to make that clearer.

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 src/datatype.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/datatype.c b/src/datatype.c
index 64e4647a605f..6362735809f7 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1465,10 +1465,10 @@ const struct datatype policy_type = {
 
 #define SYSFS_CGROUPSV2_PATH	"/sys/fs/cgroup"
 
-static const char *cgroupv2_get_path(const char *path, uint64_t id)
+static char *cgroupv2_get_path(const char *path, uint64_t id)
 {
-	const char *cgroup_path = NULL;
 	char dent_name[PATH_MAX + 1];
+	char *cgroup_path = NULL;
 	struct dirent *dent;
 	struct stat st;
 	DIR *d;
@@ -1506,7 +1506,7 @@ static void cgroupv2_type_print(const struct expr *expr,
 				struct output_ctx *octx)
 {
 	uint64_t id = mpz_get_uint64(expr->value);
-	const char *cgroup_path;
+	char *cgroup_path;
 
 	cgroup_path = cgroupv2_get_path(SYSFS_CGROUPSV2_PATH, id);
 	if (cgroup_path)
-- 
2.41.0

