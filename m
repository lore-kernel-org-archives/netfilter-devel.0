Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2CECE79D0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 13:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbjITNRF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 09:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234731AbjITNRE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 09:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D306F9E
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 06:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695215768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xXfzV+2u6o2V+jgC7Lv9rUOWYE53V+3KUheKFdKZl10=;
        b=C1iyJVm/CTP1PGZkx6tucoUeu7DbwDeBBx4cT4AcVUIBlvqAQWlzvKFAz5oXKbUtVQFCKh
        YX8S33KuBjlvyNCuJ9wZ1VrI+iDPZxoK/+DIlglMHFazIDPBraHfNmhp6fdXUVQ0+b/KLx
        +7b+3N6wsR4yX1cXPkQXZ6UCAj/Jkpk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-CvSQbgJEO3-ynWciXfv5OA-1; Wed, 20 Sep 2023 09:16:06 -0400
X-MC-Unique: CvSQbgJEO3-ynWciXfv5OA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B2103C0DF7E
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:16:06 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8EDC6C15BB8;
        Wed, 20 Sep 2023 13:16:05 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/4] datatype: don't return a const string from cgroupv2_get_path()
Date:   Wed, 20 Sep 2023 15:13:38 +0200
Message-ID: <20230920131554.204899-2-thaller@redhat.com>
In-Reply-To: <20230920131554.204899-1-thaller@redhat.com>
References: <20230920131554.204899-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index 70c84846f70e..8015f3869ece 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1464,10 +1464,10 @@ const struct datatype policy_type = {
 
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
@@ -1505,7 +1505,7 @@ static void cgroupv2_type_print(const struct expr *expr,
 				struct output_ctx *octx)
 {
 	uint64_t id = mpz_get_uint64(expr->value);
-	const char *cgroup_path;
+	char *cgroup_path;
 
 	cgroup_path = cgroupv2_get_path(SYSFS_CGROUPSV2_PATH, id);
 	if (cgroup_path)
-- 
2.41.0

