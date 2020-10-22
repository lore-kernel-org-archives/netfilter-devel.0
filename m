Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5414BC56201
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:30:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE85524182
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 17:30:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="T53GQiKM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369207AbgJVRaT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 13:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368004AbgJVRaT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 13:30:19 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FB8C0613CE
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2020 10:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fgaLF2ps+ngTudmj6aOBA9IhsN5m8w7WF3LHKTcOp1Y=; b=T53GQiKMME1X24eX/zUbD4lUB4
        Slk70fNw6tI9b5BmY3sURKni4WJvtILgxkWPd9/TpM69gewGzSSJ6m2EFsScrijNkzvhG31nr/sSN
        0p7hJ9K7NVBv4iN1wfKCBJz6Uox+g/qtRMu3WJ75IYEYBg6bV5dDyAE1mT3gdOwyHMm8Ew/AtUaRZ
        1iCVckyTHtC8bRm/65bmoQ5NmPhXet8+pjwCERidlu69LAg+beWM08+drubad4PpJuqq/1Eh3jSs+
        S6ssY5iBWXyqHieMlc6ZeLrQIw/U24sf7e6QNB4VgHDPjMXv8z74vgvAmcfKJu6GEc6os9RaK7Ixl
        p3MuapMw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kVePl-0003s0-EI; Thu, 22 Oct 2020 18:30:13 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 2/3] pknock: pknlusr: fix hard-coded netlink multicast group ID.
Date:   Thu, 22 Oct 2020 18:30:04 +0100
Message-Id: <20201022173006.635720-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201022173006.635720-1-jeremy@azazel.net>
References: <20201022173006.635720-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The group ID used by xt_pknock is configurable, but pknlusr hard-codes
it to 1.  Modify pknlusr to accept an optional ID from the command-line.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index 161a9610a018..ca3af835c9a8 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -7,6 +7,8 @@
 #include <arpa/inet.h>
 #include <linux/netlink.h>
 #include <linux/connector.h>
+#include <libgen.h>
+#include <limits.h>
 
 #include "xt_pknock.h"
 
@@ -19,7 +21,19 @@ static unsigned char *buf;
 
 static struct xt_pknock_nl_msg *nlmsg;
 
-int main(void)
+static void
+usage(const char *argv0)
+{
+	char *prog;
+	if (!(prog = strdup (argv0))) {
+		perror("strdup()");
+	} else {
+		fprintf(stderr, "%s [ group-id ]\n", basename(prog));
+		free(prog);
+	}
+}
+
+int main(int argc, char **argv)
 {
 	socklen_t addrlen;
 	int status;
@@ -30,6 +44,23 @@ int main(void)
 	const char *ip;
 	char ipbuf[48];
 
+	if (argc > 2) {
+		usage(argv[0]);
+		exit(EXIT_FAILURE);
+	}
+
+	if (argc == 2) {
+		long n;
+		char *end;
+
+		n = strtol(argv[1], &end, 10);
+		if (*end || n < INT_MIN || n > INT_MAX) {
+			usage(argv[0]);
+			exit(EXIT_FAILURE);
+		}
+		group = n;
+	}
+
 	sock_fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 
 	if (sock_fd == -1) {
-- 
2.28.0

