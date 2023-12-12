Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9D7E9
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 04:32:34 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rD1w8-0007zq-GX; Tue, 12 Dec 2023 13:32:32 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] parser_bison: ensure all timeout policy names are released
Date: Tue, 12 Dec 2023 13:32:24 +0100
Message-ID: <20231212123227.7859-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We need to add a custom destructor for this structure, it
contains the dynamically allocated names.

a:5:55-55: Error: syntax error, unexpected '}', expecting string
policy = { estabQisheestablished : 2m3s, cd : 2m3s, }

==562373==ERROR: LeakSanitizer: detected memory leaks

Indirect leak of 160 byte(s) in 2 object(s) allocated from:
    #1 0x5a565b in xmalloc src/utils.c:31:8
    #2 0x5a565b in xzalloc src/utils.c:70:8
    #3 0x3d9352 in nft_parse_bison_filename src/libnftables.c:520:8
[..]

Fixes: c7c94802679c ("src: add ct timeout support")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/parser_bison.y                            | 32 ++++++++++++++++---
 .../testcases/bogons/nft-f/ct_timeout_memleak |  7 ++++
 2 files changed, 34 insertions(+), 5 deletions(-)
 create mode 100644 tests/shell/testcases/bogons/nft-f/ct_timeout_memleak

diff --git a/src/parser_bison.y b/src/parser_bison.y
index ce80bcd917c3..85cc9b6b0a80 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -173,6 +173,24 @@ static struct expr *ifname_expr_alloc(const struct location *location,
 	return expr;
 }
 
+static void timeout_state_free(struct timeout_state *s)
+{
+	free_const(s->timeout_str);
+	free(s);
+}
+
+static void timeout_states_free(struct list_head *list)
+{
+	struct timeout_state *ts, *next;
+
+	list_for_each_entry_safe(ts, next, list, head) {
+		list_del(&ts->head);
+		timeout_state_free(ts);
+	}
+
+	free(list);
+}
+
 #define YYLLOC_DEFAULT(Current, Rhs, N)	location_update(&Current, Rhs, N)
 
 #define symbol_value(loc, str) \
@@ -230,6 +248,7 @@ int nft_lex(void *, void *, void *);
 		uint16_t kind; /* must allow > 255 for SACK1, 2.. hack */
 		uint8_t field;
 	} tcp_kind_field;
+	struct timeout_state	*timeout_state;
 }
 
 %token TOKEN_EOF 0		"end of file"
@@ -967,8 +986,11 @@ int nft_lex(void *, void *, void *);
 
 %type <val>			ct_l4protoname ct_obj_type ct_cmd_type
 
-%type <list>			timeout_states timeout_state
-%destructor { free($$); }	timeout_states timeout_state
+%type <timeout_state>		timeout_state
+%destructor { timeout_state_free($$); }		timeout_state
+
+%type <list>			timeout_states
+%destructor { timeout_states_free($$); }	timeout_states
 
 %type <val>			xfrm_state_key	xfrm_state_proto_key xfrm_dir	xfrm_spnum
 %type <expr>			xfrm_expr
@@ -4860,11 +4882,11 @@ timeout_states		:	timeout_state
 			{
 				$$ = xmalloc(sizeof(*$$));
 				init_list_head($$);
-				list_add_tail($1, $$);
+				list_add_tail(&$1->head, $$);
 			}
 			|	timeout_states	COMMA	timeout_state
 			{
-				list_add_tail($3, $1);
+				list_add_tail(&$3->head, $1);
 				$$ = $1;
 			}
 			;
@@ -4878,7 +4900,7 @@ timeout_state		:	STRING	COLON	time_spec_or_num_s
 				ts->timeout_value = $3;
 				ts->location = @1;
 				init_list_head(&ts->head);
-				$$ = &ts->head;
+				$$ = ts;
 			}
 			;
 
diff --git a/tests/shell/testcases/bogons/nft-f/ct_timeout_memleak b/tests/shell/testcases/bogons/nft-f/ct_timeout_memleak
new file mode 100644
index 000000000000..014525a34b34
--- /dev/null
+++ b/tests/shell/testcases/bogons/nft-f/ct_timeout_memleak
@@ -0,0 +1,7 @@
+table ip filter {
+        ct timeout cttime {
+                protocol tcp
+                l3proto ip
+                policy = { estabQisheestablished : 2m3s, cd : 2m3s, }
+        }
+}
-- 
2.41.0

