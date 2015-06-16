From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH nft-sync] event.c: Include <signal.h> for signal names
Date: Tue, 16 Jun 2015 21:23:21 +0200
Message-ID: <20150616192321.GB3247@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:45130 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbbFPTXo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 15:23:44 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 8442B22B47E0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:23:43 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3m9zwH2v4PzFpWM
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:23:43 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 src/event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/event.c b/src/event.c
index 464b689..a41374c 100644
--- a/src/event.c
+++ b/src/event.c
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <event.h>
+#include <signal.h>
 
 #include "init.h"
 #include "logging.h"
-- 
2.3.6
