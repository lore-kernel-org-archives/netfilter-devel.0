From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] libiptc: fix fortify errors in debug code
Date: Thu, 20 Aug 2015 07:12:59 -0400
Message-ID: <1440069179-21334-1-git-send-email-vapier@gentoo.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39983 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbbHTLNB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 07:13:01 -0400
Received: from localhost.localdomain (localhost [127.0.0.1])
	by smtp.gentoo.org (Postfix) with ESMTP id 2B7C4340A99
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 11:13:01 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using open(O_CREAT), you must supply the mode bits, otherwise the
func will pull random garbage off the stack.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 libiptc/libiptc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index f0f7815..9c07bb4 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1357,7 +1357,7 @@ retry:
 #ifdef IPTC_DEBUG2
 	{
 		int fd = open("/tmp/libiptc-so_get_entries.blob",
-				O_CREAT|O_WRONLY);
+				O_CREAT|O_WRONLY, 0644);
 		if (fd >= 0) {
 			write(fd, h->entries, tmp);
 			close(fd);
@@ -2588,7 +2588,7 @@ TC_COMMIT(struct xtc_handle *handle)
 #ifdef IPTC_DEBUG2
 	{
 		int fd = open("/tmp/libiptc-so_set_replace.blob",
-				O_CREAT|O_WRONLY);
+				O_CREAT|O_WRONLY, 0644);
 		if (fd >= 0) {
 			write(fd, repl, sizeof(*repl) + repl->size);
 			close(fd);
@@ -2664,7 +2664,7 @@ TC_COMMIT(struct xtc_handle *handle)
 #ifdef IPTC_DEBUG2
 	{
 		int fd = open("/tmp/libiptc-so_set_add_counters.blob",
-				O_CREAT|O_WRONLY);
+				O_CREAT|O_WRONLY, 0644);
 		if (fd >= 0) {
 			write(fd, newcounters, counterlen);
 			close(fd);
-- 
2.4.4

