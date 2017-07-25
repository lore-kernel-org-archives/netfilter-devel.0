From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/6] monitor: Print space after semicolon
Date: Tue, 25 Jul 2017 16:56:27 +0200
Message-ID: <20170725145629.20974-5-phil@nwl.cc>
References: <20170725145629.20974-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:40823 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752332AbdGYO4m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jul 2017 10:56:42 -0400
In-Reply-To: <20170725145629.20974-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes output a bit more readable.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 5ea4fce546e30..12714ed3ccc70 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -381,7 +381,7 @@ void set_print_plain(const struct set *s, struct output_ctx *octx)
 		.nl		= " ",
 		.table		= s->handle.table,
 		.family		= family2str(s->handle.family),
-		.stmt_separator	= ";",
+		.stmt_separator	= "; ",
 	};
 
 	do_set_print(s, &opts, octx);
-- 
2.13.1

