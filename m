From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrackd 3/8] conntrackd: fix leak in fork_process_new()
Date: Tue, 18 Aug 2015 19:28:34 +0200
Message-ID: <1439918919-6937-4-git-send-email-pablo@netfilter.org>
References: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Cc: pwouters@redhat.com, fweimer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbbHRRWe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2015 13:22:34 -0400
In-Reply-To: <1439918919-6937-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Release the child_process structure in case that fork() fails.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/process.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/process.c b/src/process.c
index 7f0a395..3ddad5f 100644
--- a/src/process.c
+++ b/src/process.c
@@ -48,6 +48,8 @@ int fork_process_new(int type, int flags, void (*cb)(void *data), void *data)
 
 	if (c->pid > 0)
 		list_add(&c->head, &process_list);
+	else
+		free(c);
 
 	return pid;
 }
-- 
1.7.10.4

