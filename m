From: Jan Engelhardt <jengelh@medozas.de>
Subject: libiptc: use hex output for hookmask
Date: Thu, 6 Nov 2008 09:35:46 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811060935350.26551@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811060933060.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060934380.26551@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0811060935020.26551@fbirervta.pbzchgretzou.qr>
 <alpine.LNX.1.10.0811060935130.26551@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52645 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbYKFIfr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2008 03:35:47 -0500
In-Reply-To: <alpine.LNX.1.10.0811060935130.26551@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a573a8f34c11c3361644172847c90b7fe3bcd712
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Nov 6 09:23:10 2008 +0100

libiptc: use hex output for hookmask

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 libiptc/libiptc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 98780a6..13e4c69 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1417,13 +1417,13 @@ TC_DUMP_ENTRIES(struct xtc_handle *const handle)
 	printf("libiptc v%s. %u bytes.\n",
 	       XTABLES_VERSION, handle->entries->size);
 	printf("Table `%s'\n", handle->info.name);
-	printf("Hooks: pre/in/fwd/out/post = %u/%u/%u/%u/%u\n",
+	printf("Hooks: pre/in/fwd/out/post = %x/%x/%x/%x/%x\n",
 	       handle->info.hook_entry[HOOK_PRE_ROUTING],
 	       handle->info.hook_entry[HOOK_LOCAL_IN],
 	       handle->info.hook_entry[HOOK_FORWARD],
 	       handle->info.hook_entry[HOOK_LOCAL_OUT],
 	       handle->info.hook_entry[HOOK_POST_ROUTING]);
-	printf("Underflows: pre/in/fwd/out/post = %u/%u/%u/%u/%u\n",
+	printf("Underflows: pre/in/fwd/out/post = %x/%x/%x/%x/%x\n",
 	       handle->info.underflow[HOOK_PRE_ROUTING],
 	       handle->info.underflow[HOOK_LOCAL_IN],
 	       handle->info.underflow[HOOK_FORWARD],
