From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: x_tables: fix net namespace leak when reading /proc/net/xxx_tables_names
Date: Tue, 29 Apr 2008 00:06:43 +0200 (MEST)
Message-ID: <20080428220646.18270.5101.sendpatchset@localhost.localdomain>
References: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33391 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463AbYD1WGo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:06:44 -0400
In-Reply-To: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: fix net namespace leak when reading /proc/net/xxx_tables_names

The seq_open_net() call should be accompanied with seq_release_net() one.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6317c53b124105c288604f51d50e2c759f6f333b
tree dc91473a4ea1688a27c71f3a0336bfcee922b6c5
parent 409c904821b52f9c4597ca87f3ab01b55183904e
author Pavel Emelyanov <xemul@openvz.org> Tue, 29 Apr 2008 00:02:17 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 29 Apr 2008 00:02:17 +0200

 net/netfilter/x_tables.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f52f7f8..11b22ab 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -787,7 +787,7 @@ static const struct file_operations xt_table_ops = {
 	.open	 = xt_table_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_net,
 };
 
 static void *xt_match_seq_start(struct seq_file *seq, loff_t *pos)
