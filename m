From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/10] build: resolve compiler warnings
Date: Tue, 19 Oct 2010 12:47:38 +0200
Message-ID: <1287485262-6562-8-git-send-email-jengelh@medozas.de>
References: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44407 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255Ab0JSKrv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:51 -0400
In-Reply-To: <1287485262-6562-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nlmsg.c: In function "mnl_nlmsg_fprintf":
nlmsg.c:260:4: warning: format "%.3d" expects type "int", but
argument 3 has type "size_t"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/nlmsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index af08671..3cec2a2 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -255,7 +255,7 @@ void mnl_nlmsg_fprintf(FILE *fd, const struct nlmsghdr *nlh)
 	for (i=sizeof(struct nlmsghdr); i<nlh->nlmsg_len; i+=4) {
 		char *b = (char *) nlh;
 
-		fprintf(fd, "(%.3d) %.2x %.2x %.2x %.2x | ", i,
+		fprintf(fd, "(%03zu) %.2x %.2x %.2x %.2x | ", i,
 			0xff & b[i],	0xff & b[i+1],
 			0xff & b[i+2],	0xff & b[i+3]);
 
-- 
1.7.1

