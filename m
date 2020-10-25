Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7765FC55178
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DF3D20723
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="CJD6FfMM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416236AbgJYNRY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2894311AbgJYNRX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:17:23 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34522C0613CE
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IYyh5vs68YaNUTYimxZm0quFKnVREld0VIcyP4xy0B0=; b=CJD6FfMMj/6A8dDD5woL1xWEZ5
        YghXXjD2IjbDMc7J0Tah0EtHDzDYwMbbMku9H/jJW8mwMYw6i24O98gfzK048k7RMlqoUC/dUu413
        xXqh8LXsNVrY34+tqMiYQjYopIwo0H03zSDqsWuFUUerw9YtxuQ/gZi7mZvacrl9xz6kDMd+g+8NC
        8amRZLjgVc/3QX4x90zaBU3VARTAL0RF+E45VFrdnCnhk4t4r4usuP3iXEOH/T5vg7vY6G8g4s/hr
        e6DrTp+62IBn4ENdOJ+FewYYIZmG+69+nNSC8l4CbJzSKo37uTqABZLl+/mhTFTvHqH8OarbWo01k
        aH3/NO7w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsW-0001SE-0V; Sun, 25 Oct 2020 13:16:08 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 09/13] pknock: pknlusr: fix hard-coded netlink multicast group ID.
Date:   Sun, 25 Oct 2020 13:15:55 +0000
Message-Id: <20201025131559.920038-11-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201025131559.920038-1-jeremy@azazel.net>
References: <20201025131559.920038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The group ID used by xt_pknock is configurable, but pknlusr hard-codes
it.  Modify pknlusr to accept an optional ID from the command-line.
Group ID's range from 1 to 32 and each ID appears in the group bit-mask
at position `group_id - 1`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 41 +++++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index fba628e1f466..255649aefbb5 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -7,15 +7,22 @@
 #include <arpa/inet.h>
 #include <linux/netlink.h>
 #include <linux/connector.h>
+#include <errno.h>
+#include <libgen.h>
+#include <limits.h>
 
 #include "xt_pknock.h"
 
-#define GROUP 1
+#define DEFAULT_GROUP_ID 1
 
-int main(void)
+#define MIN_GROUP_ID DEFAULT_GROUP_ID
+#define MAX_GROUP_ID \
+	(sizeof ((struct sockaddr_nl) { 0 }.nl_groups) * CHAR_BIT)
+
+int main(int argc, char **argv)
 {
 	int status;
-	int group = GROUP;
+	unsigned int group_id = DEFAULT_GROUP_ID;
 
 	struct sockaddr_nl local_addr = { .nl_family = AF_NETLINK };
 	int sock_fd;
@@ -25,6 +32,32 @@ int main(void)
 	struct cn_msg *cn_msg;
 	struct xt_pknock_nl_msg *pknock_msg;
 
+	if (argc > 2) {
+		char *prog;
+		if (!(prog = strdup (argv[0]))) {
+			perror("strdup()");
+		} else {
+			fprintf(stderr, "%s [ group-id ]\n", basename(prog));
+			free(prog);
+		}
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc == 2) {
+		long n;
+		char *end;
+
+		errno = 0;
+		n = strtol(argv[1], &end, 10);
+		if (*end || (errno && (n == LONG_MIN || n == LONG_MAX)) ||
+		    n < MIN_GROUP_ID || n > MAX_GROUP_ID) {
+			fputs("Group ID invalid.\n", stderr);
+			exit(EXIT_FAILURE);
+		}
+
+		group_id = n;
+	}
+
 	sock_fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 
 	if (sock_fd == -1) {
@@ -32,7 +65,7 @@ int main(void)
 		exit (EXIT_FAILURE);
 	}
 
-	local_addr.nl_groups = group;
+	local_addr.nl_groups = 1U << (group_id - 1);
 
 	status = bind(sock_fd, (struct sockaddr*)&local_addr, sizeof(local_addr));
 
-- 
2.28.0

