From: Jan Engelhardt <jengelh@medozas.de>
Subject: [1/5] build: compile fix
Date: Tue, 20 Jan 2009 12:16:39 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901201216070.13700@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39850 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500AbZATLQk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:16:40 -0500
In-Reply-To: <alpine.LSU.2.00.0901201214520.13700@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 75b3becf5b95c4ab5ddcef88b6565de716e5c230
commit 00f879a81e898b37b9c17c878dc90327ca84684e
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jan 18 18:50:04 2009 +0100

build: compile fix

ulogd_inpflow_NFCT.c: In function 'propagate_ct':
ulogd_inpflow_NFCT.c:483: error: 'IPPROTO_UDPLITE' undeclared (first use in this function)

(and more for IPPROTO_SCTP)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 input/flow/ulogd_inpflow_NFCT.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index 244454b..4605fd9 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -35,6 +35,7 @@
 
 #include <sys/time.h>
 #include <time.h>
+#include <netinet/in.h>
 #include <ulogd/linuxlist.h>
 #include <ulogd/jhash.h>
 #include <ulogd/hash.h>
