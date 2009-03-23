From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 3/3] iptables: libiptc give credits to my self.
Date: Mon, 23 Mar 2009 13:55:25 +0100
Message-ID: <20090323125524.959.35879.stgit@localhost.localdomain>
References: <20090323125514.959.87191.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:59524 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZCWNXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:23:20 -0400
In-Reply-To: <20090323125514.959.87191.stgit@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add notes about my scalability work on the library libiptc.
This should make in more obvious who to complain to.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 libiptc/libiptc.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 59cbf55..ac71667 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -23,6 +23,11 @@
  * 	- libiptc now has a real internal (linked-list) represntation of the
  * 	  ruleset and a parser/compiler from/to this internal representation
  * 	- again sponsored by Astaro AG (http://www.astaro.com/)
+ *
+ * 2008-Jan+Jul: Jesper Dangaard Brouer <hawk@comx.dk>
+ * 	- performance work: speedup chain list "name" searching.
+ * 	- performance work: speedup initial ruleset parsing.
+ * 	- sponsored by ComX Networks A/S (http://www.comx.dk/)
  */
 #include <sys/types.h>
 #include <sys/socket.h>

