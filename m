From: Paul Aitken <paitken@brocade.com>
Subject: [PATCH] remove unused 'numbytes'
Date: Thu, 4 Jun 2015 10:15:00 +0100
Message-ID: <E1Z0RGE-0008Uk-1i@BRA-J2N4P12.vyatta.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <pablo@netfilter.org>, <paitken@brocade.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:58815 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751173AbbFDJRR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2015 05:17:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

'numbytes' isn't used and can be removed.

Signed-off-by: Paul Aitken <paitken@brocade.com>
---
 src/local.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/local.c b/src/local.c
index feff608..453799a 100644
--- a/src/local.c
+++ b/src/local.c
@@ -117,11 +117,10 @@ void local_client_destroy(int fd)
 
 int do_local_client_step(int fd, void (*process)(char *buf))
 {
-	int numbytes;
 	char buf[1024];
 
 	memset(buf, 0, sizeof(buf));
-	while ((numbytes = recv(fd, buf, sizeof(buf)-1, 0)) > 0) {
+	while (recv(fd, buf, sizeof(buf)-1, 0) > 0) {
 		buf[sizeof(buf)-1] = '\0';
 		if (process)
 			process(buf);
-- 
1.9.1

