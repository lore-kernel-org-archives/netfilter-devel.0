Return-Path: <SRS0=S2pA=AZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA9AC433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 16:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D50B2242B
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 16:52:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IcND3iaf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgGNQwS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:52:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:42631 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726999AbgGNQwR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Jul 2020 12:52:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594745536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XfXlOzzfBvdLOrA2aWRHbIZ/ghJ5fhhPi6bLI41G0Rk=;
        b=IcND3iaftp12FpcRk8jbpgmI1bcLXZdpuSImnc7VERwcZQZsp5BoVvmk30fgf8Gk/Aa2Y2
        17v1LHQfvwDNdXHSDidsb71A6Q79xEyu7shAoPstWFlNEVYztdd73bJRKx1jY3dI/lVJhb
        b28vC8Muenq/CvVQvLT7eGk/jaYdMzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-ToRlp6kNP46AIOx7xG4sYg-1; Tue, 14 Jul 2020 12:52:14 -0400
X-MC-Unique: ToRlp6kNP46AIOx7xG4sYg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 772031DE0;
        Tue, 14 Jul 2020 16:52:13 +0000 (UTC)
Received: from lithium.redhat.com (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E52417150;
        Tue, 14 Jul 2020 16:52:12 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     netfilter-devel@vger.kernel.org
Cc:     gscrivan@redhat.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH] iptables: accept lock file name at runtime
Date:   Tue, 14 Jul 2020 18:52:06 +0200
Message-Id: <20200714165206.4078549-1-gscrivan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

allow users to override at runtime the lock file to use through the
XTABLES_LOCKFILE environment variable.

It allows using iptables from a network namespace owned by an user
that has no write access to XT_LOCK_NAME (by default under /run), and
without setting up a new mount namespace.

$ XTABLES_LOCKFILE=/tmp/xtables unshare -rn iptables ...

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 iptables/xshared.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index c1d1371a..291f1c4b 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -248,13 +248,18 @@ void xs_init_match(struct xtables_match *match)
 
 static int xtables_lock(int wait, struct timeval *wait_interval)
 {
+	const *lock_file;
 	struct timeval time_left, wait_time;
 	int fd, i = 0;
 
 	time_left.tv_sec = wait;
 	time_left.tv_usec = 0;
 
-	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
+	lock_file = getenv("XTABLES_LOCKFILE");
+	if (lock_file == NULL || lock_file[0] == '\0')
+		lock_file = XT_LOCK_NAME;
+
+	fd = open(lock_file, O_CREAT, 0600);
 	if (fd < 0) {
 		fprintf(stderr, "Fatal: can't open lock file %s: %s\n",
 			XT_LOCK_NAME, strerror(errno));
-- 
2.26.2

