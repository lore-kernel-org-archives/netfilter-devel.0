From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 6/8] conntrackd: simplify branch in tcp_accept()
Date: Tue, 18 Aug 2015 19:28:37 +0200
Message-ID: <1439918919-6937-7-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37615 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbbHRRWj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:39 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The same code is executed regardless the reason why accept() has failed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/tcp.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/src/tcp.c b/src/tcp.c
index af27c46..c8f2544 100644
--- a/src/tcp.c
+++ b/src/tcp.c
@@ -247,13 +247,11 @@ int tcp_accept(struct tcp_sock *m)
 	/* the other peer wants to connect ... */
 	ret = accept(m->fd, NULL, NULL);
 	if (ret == -1) {
-		if (errno != EAGAIN) {
-			/* unexpected error. Give us another try. */
-			m->state = TCP_SERVER_ACCEPTING;
-		} else {
-			/* waiting for new connections. */
-			m->state = TCP_SERVER_ACCEPTING;
-		}
+		/* unexpected error: Give us another try. Or we have hit
+ 		 * -EAGAIN, in that case we remain in the accepting connections
+		 * state.
+		 */
+		m->state = TCP_SERVER_ACCEPTING;
 	} else {
 		/* the peer finally got connected. */
 		if (fcntl(ret, F_SETFL, O_NONBLOCK) == -1) {
-- 
1.7.10.4

