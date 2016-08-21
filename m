From: =?UTF-8?q?Carlos=20Falgueras=20Garc=C3=ADa?= <carlosfg@riseup.net>
Subject: [PATCH 4/4 V6 nft] parser: Improve syntax errors
Date: Sun, 21 Aug 2016 23:22:10 +0200
Message-ID: <20160821212210.26161-4-carlosfg@riseup.net>
References: <20160821212210.26161-1-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.riseup.net ([198.252.153.129]:34481 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753490AbcHUVWn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2016 17:22:43 -0400
In-Reply-To: <20160821212210.26161-1-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Shows a more informative message when user commits a syntax error:

	$ nft add rule t c handle 3 ...
	<cmdline>:1:14-19: Error: Did you mean `position'?
	add rule t c handle 3 ...
	             ^^^^^^
	$ nft delete rule t c position 3 ...
	<cmdline>:1:17-24: Error: Did you mean `handle' or insert a rule description?
	delete rule t c position 3 ...
	                ^^^^^^^^

Adds function 'erec_del_last' that deletes last error from the error queue.
This is needed to do not show two error messages.

Signed-off-by: Carlos Falgueras García <carlosfg@riseup.net>
---
 include/erec.h     |  5 +++++
 src/parser_bison.y | 17 +++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/erec.h b/include/erec.h
index 36e0efa..95ed24a 100644
--- a/include/erec.h
+++ b/include/erec.h
@@ -58,6 +58,11 @@ static inline void erec_queue(struct error_record *erec,
 	list_add_tail(&erec->list, queue);
 }
 
+static inline void erec_del_last(struct list_head *queue)
+{
+	list_del(queue->prev);
+}
+
 extern void erec_print(FILE *f, const struct error_record *erec);
 extern void erec_print_list(FILE *f, struct list_head *list);
 
diff --git a/src/parser_bison.y b/src/parser_bison.y
index beea38b..9739cb1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1273,6 +1273,14 @@ rule_position		:	chain_spec
 				$$ = $1;
 				handle_merge(&$$, &$2);
 			}
+			|	chain_spec HANDLE error
+			{
+				erec_del_last(state->msgs);
+				erec_queue(error(&@2, "Did you mean `position'?"),
+					   state->msgs);
+				$$ = $1;
+				YYERROR;
+			}
 			;
 
 ruleid_spec		:	chain_spec handle_spec
@@ -1287,6 +1295,15 @@ ruleid_spec		:	chain_spec handle_spec
 				$$ = $2;
 				handle_merge(&$$->handle, &$1);
 			}
+			|	chain_spec POSITION error
+			{
+				erec_del_last(state->msgs);
+				erec_queue(error(&@2, "Did you mean `handle' or insert a rule description?"),
+					   state->msgs);
+				$$ = rule_alloc(&@$, NULL);
+				handle_merge(&$$->handle, &$1);
+				YYERROR;
+			}
 			;
 
 comment_spec		:	COMMENT		string
-- 
2.8.3

