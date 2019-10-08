Return-Path: <SRS0=bnKo=YB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F55C10F14
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 13:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24580206BB
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Oct 2019 13:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfJHNul (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Oct 2019 09:50:41 -0400
Received: from 195-154-211-226.rev.poneytelecom.eu ([195.154.211.226]:54114
        "EHLO flash.glorub.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfJHNul (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Oct 2019 09:50:41 -0400
Received: from eric by flash.glorub.net with local (Exim 4.89)
        (envelope-from <ejallot@gmail.com>)
        id 1iHpsr-0004hG-Hy; Tue, 08 Oct 2019 15:50:37 +0200
From:   Eric Jallot <ejallot@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Eric Jallot <ejallot@gmail.com>
Subject: [PATCH nft] src: obj: fix memleak in parser_bison.y
Date:   Tue,  8 Oct 2019 15:47:24 +0200
Message-Id: <20191008134724.17839-1-ejallot@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Each object (secmark, synproxy, quota, limit, counter) is dynamically allocated
by the parser and not freed at exit.
However, there is no need to use dynamic allocation here because struct obj
already provides the required storage. Update the grammar to ensure that
obj_alloc() is called before config occurs.

This fixes the following memleak (secmark as example):

 # valgrind --leak-check=full nft add secmark inet raw ssh \"system_u:object_r:ssh_server_packet_t:s0\"
 ==14643== Memcheck, a memory error detector
 ==14643== Copyright (C) 2002-2017, and GNU GPL'd, by Julian Seward et al.
 ==14643== Using Valgrind-3.14.0 and LibVEX; rerun with -h for copyright info
 ==14643== Command: nft add secmark inet raw ssh "system_u:object_r:ssh_server_packet_t:s0"
 ==14643==
 ==14643==
 ==14643== HEAP SUMMARY:
 ==14643==     in use at exit: 256 bytes in 1 blocks
 ==14643==   total heap usage: 41 allocs, 40 frees, 207,809 bytes allocated
 ==14643==
 ==14643== 256 bytes in 1 blocks are definitely lost in loss record 1 of 1
 ==14643==    at 0x4C29EA3: malloc (vg_replace_malloc.c:309)
 ==14643==    by 0x4E72074: xmalloc (utils.c:36)
 ==14643==    by 0x4E72074: xzalloc (utils.c:65)
 ==14643==    by 0x4E89A31: nft_parse (parser_bison.y:3706)
 ==14643==    by 0x4E778E7: nft_parse_bison_buffer (libnftables.c:375)
 ==14643==    by 0x4E778E7: nft_run_cmd_from_buffer (libnftables.c:443)
 ==14643==    by 0x40170F: main (main.c:326)

Fixes: f44ab88b1088e ("src: add synproxy stateful object support")
Fixes: 3bc84e5c1fdd1 ("src: add support for setting secmark")
Fixes: c0697eabe832d ("src: add stateful object support for limit")
Fixes: 4d38878b39be4 ("src: add/create/delete stateful objects")
Signed-off-by: Eric Jallot <ejallot@gmail.com>
---
 src/parser_bison.y | 83 ++++++++++++++++++------------------------------------
 1 file changed, 27 insertions(+), 56 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index cd249c82d938..1e2b30015f78 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -149,12 +149,7 @@ int nft_lex(void *, void *, void *);
 	struct set		*set;
 	struct obj		*obj;
 	struct flowtable	*flowtable;
-	struct counter		*counter;
-	struct quota		*quota;
-	struct secmark		*secmark;
-	struct synproxy		*synproxy;
 	struct ct		*ct;
-	struct limit		*limit;
 	const struct datatype	*datatype;
 	struct handle_spec	handle_spec;
 	struct position_spec	position_spec;
@@ -782,16 +777,6 @@ int nft_lex(void *, void *, void *);
 %destructor { xfree($$); }	monitor_event
 %type <val>			monitor_object	monitor_format
 
-%type <counter>			counter_config
-%destructor { xfree($$); }	counter_config
-%type <quota>			quota_config
-%destructor { xfree($$); }	quota_config
-%type <limit>			limit_config
-%destructor { xfree($$); }	limit_config
-%type <secmark>			secmark_config
-%destructor { xfree($$); }	secmark_config
-%type <synproxy>		synproxy_config
-%destructor { xfree($$); }	synproxy_config
 %type <val>			synproxy_ts	synproxy_sack
 
 %type <expr>			tcp_hdr_expr
@@ -989,17 +974,16 @@ add_cmd			:	TABLE		table_spec
 				handle_merge(&obj->handle, &$2);
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, obj);
 			}
-			|	COUNTER		obj_spec	counter_obj
+			|	COUNTER		obj_spec	counter_obj	counter_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
-			|	QUOTA		obj_spec	quota_obj
+			|	QUOTA		obj_spec	quota_obj	quota_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
 			|	CT	HELPER	obj_spec	ct_obj_alloc	'{' ct_helper_block '}'
 			{
-
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_HELPER, &$3, &@$, $4);
 			}
 			|	CT	TIMEOUT obj_spec	ct_obj_alloc	'{' ct_timeout_block '}'
@@ -1010,15 +994,15 @@ add_cmd			:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_ADD, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
 			}
-			|	LIMIT		obj_spec	limit_obj
+			|	LIMIT		obj_spec	limit_obj	limit_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
-			|	SECMARK		obj_spec	secmark_obj
+			|	SECMARK		obj_spec	secmark_obj	secmark_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
-			|	SYNPROXY	obj_spec	synproxy_obj
+			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config
 			{
 				$$ = cmd_alloc(CMD_ADD, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
@@ -1087,11 +1071,11 @@ create_cmd		:	TABLE		table_spec
 				handle_merge(&obj->handle, &$2);
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, obj);
 			}
-			|	COUNTER		obj_spec	counter_obj
+			|	COUNTER		obj_spec	counter_obj	counter_config
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_COUNTER, &$2, &@$, $3);
 			}
-			|	QUOTA		obj_spec	quota_obj
+			|	QUOTA		obj_spec	quota_obj	quota_config
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_QUOTA, &$2, &@$, $3);
 			}
@@ -1107,15 +1091,15 @@ create_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc_obj_ct(CMD_CREATE, NFT_OBJECT_CT_EXPECT, &$3, &@$, $4);
 			}
-			|	LIMIT		obj_spec	limit_obj
+			|	LIMIT		obj_spec	limit_obj	limit_config
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_LIMIT, &$2, &@$, $3);
 			}
-			|	SECMARK		obj_spec	secmark_obj
+			|	SECMARK		obj_spec	secmark_obj	secmark_config
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SECMARK, &$2, &@$, $3);
 			}
-			|	SYNPROXY	obj_spec	synproxy_obj
+			|	SYNPROXY	obj_spec	synproxy_obj	synproxy_config
 			{
 				$$ = cmd_alloc(CMD_CREATE, CMD_OBJ_SYNPROXY, &$2, &@$, $3);
 			}
@@ -1911,7 +1895,6 @@ counter_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       counter_block     stmt_separator
 			|       counter_block     counter_config
 			{
-				$1->counter = *$2;
 				$$ = $1;
 			}
 			;
@@ -1921,7 +1904,6 @@ quota_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       quota_block     stmt_separator
 			|       quota_block     quota_config
 			{
-				$1->quota = *$2;
 				$$ = $1;
 			}
 			;
@@ -1958,7 +1940,6 @@ limit_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       limit_block     stmt_separator
 			|       limit_block     limit_config
 			{
-				$1->limit = *$2;
 				$$ = $1;
 			}
 			;
@@ -1968,7 +1949,6 @@ secmark_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|       secmark_block     stmt_separator
 			|       secmark_block     secmark_config
 			{
-				$1->secmark = *$2;
 				$$ = $1;
 			}
 			;
@@ -1978,7 +1958,6 @@ synproxy_block		:	/* empty */	{ $$ = $<obj>-1; }
 			|	synproxy_block	stmt_separator
 			|	synproxy_block	synproxy_config
 			{
-				$1->synproxy = *$2;
 				$$ = $1;
 			}
 			;
@@ -2883,7 +2862,7 @@ synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
 				struct synproxy *synproxy;
 				uint32_t flags = 0;
 
-				synproxy = xzalloc(sizeof(*synproxy));
+				synproxy = &$<obj>0->synproxy;
 				synproxy->mss = $2;
 				flags |= NF_SYNPROXY_OPT_MSS;
 				synproxy->wscale = $4;
@@ -2893,14 +2872,13 @@ synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
 				if ($6)
 					flags |= $6;
 				synproxy->flags = flags;
-				$$ = synproxy;
 			}
 			|	MSS	NUM	stmt_separator	WSCALE	NUM	stmt_separator	synproxy_ts	synproxy_sack
 			{
 				struct synproxy *synproxy;
 				uint32_t flags = 0;
 
-				synproxy = xzalloc(sizeof(*synproxy));
+				synproxy = &$<obj>0->synproxy;
 				synproxy->mss = $2;
 				flags |= NF_SYNPROXY_OPT_MSS;
 				synproxy->wscale = $5;
@@ -2910,15 +2888,13 @@ synproxy_config		:	MSS	NUM	WSCALE	NUM	synproxy_ts	synproxy_sack
 				if ($8)
 					flags |= $8;
 				synproxy->flags = flags;
-				$$ = synproxy;
 			}
 			;
 
-synproxy_obj		:	synproxy_config
+synproxy_obj		:	/* empty */
 			{
 				$$ = obj_alloc(&@$);
 				$$->type = NFT_OBJECT_SYNPROXY;
-				$$->synproxy = *$1;
 			}
 			;
 
@@ -3655,18 +3631,16 @@ counter_config		:	PACKETS		NUM	BYTES	NUM
 			{
 				struct counter *counter;
 
-				counter = xzalloc(sizeof(*counter));
+				counter = &$<obj>0->counter;
 				counter->packets = $2;
 				counter->bytes = $4;
-				$$ = counter;
 			}
 			;
 
-counter_obj		:	counter_config
+counter_obj		:	/* empty */
 			{
 				$$ = obj_alloc(&@$);
 				$$->type = NFT_OBJECT_COUNTER;
-				$$->counter = *$1;
 			}
 			;
 
@@ -3683,19 +3657,17 @@ quota_config		:	quota_mode NUM quota_unit quota_used
 					YYERROR;
 				}
 
-				quota = xzalloc(sizeof(*quota));
+				quota = &$<obj>0->quota;
 				quota->bytes	= $2 * rate;
 				quota->used	= $4;
 				quota->flags	= $1;
-				$$ = quota;
 			}
 			;
 
-quota_obj		:	quota_config
+quota_obj		:	/* empty */
 			{
 				$$ = obj_alloc(&@$);
 				$$->type = NFT_OBJECT_QUOTA;
-				$$->quota = *$1;
 			}
 			;
 
@@ -3703,21 +3675,22 @@ secmark_config		:	string
 			{
 				int ret;
 				struct secmark *secmark;
-				secmark = xzalloc(sizeof(*secmark));
+
+				secmark = &$<obj>0->secmark;
 				ret = snprintf(secmark->ctx, sizeof(secmark->ctx), "%s", $1);
 				if (ret <= 0 || ret >= (int)sizeof(secmark->ctx)) {
 					erec_queue(error(&@1, "invalid context '%s', max length is %u\n", $1, (int)sizeof(secmark->ctx)), state->msgs);
+					xfree($1);
 					YYERROR;
 				}
-				$$ = secmark;
+				xfree($1);
 			}
 			;
 
-secmark_obj		:	secmark_config
+secmark_obj		:	/* empty */
 			{
 				$$ = obj_alloc(&@$);
 				$$->type = NFT_OBJECT_SECMARK;
-				$$->secmark = *$1;
 			}
 			;
 
@@ -3822,7 +3795,7 @@ ct_expect_config	:	PROTOCOL	ct_l4protoname	stmt_separator
 			}
 			;
 
-ct_obj_alloc		:
+ct_obj_alloc		:	/* empty */
 			{
 				$$ = obj_alloc(&@$);
 			}
@@ -3831,13 +3804,13 @@ ct_obj_alloc		:
 limit_config		:	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 			{
 				struct limit *limit;
-				limit = xzalloc(sizeof(*limit));
+
+				limit = &$<obj>0->limit;
 				limit->rate	= $3;
 				limit->unit	= $5;
 				limit->burst	= $6;
 				limit->type	= NFT_LIMIT_PKTS;
 				limit->flags	= $2;
-				$$ = limit;
 			}
 			|	RATE	limit_mode	NUM	STRING	limit_burst_bytes
 			{
@@ -3851,21 +3824,19 @@ limit_config		:	RATE	limit_mode	NUM	SLASH	time_unit	limit_burst_pkts
 					YYERROR;
 				}
 
-				limit = xzalloc(sizeof(*limit));
+				limit = &$<obj>0->limit;
 				limit->rate	= rate * $3;
 				limit->unit	= unit;
 				limit->burst	= $5;
 				limit->type	= NFT_LIMIT_PKT_BYTES;
 				limit->flags	= $2;
-				$$ = limit;
 			}
 			;
 
-limit_obj		:	limit_config
+limit_obj		:	/* empty */
 			{
 				$$ = obj_alloc(&@$);
 				$$->type = NFT_OBJECT_LIMIT;
-				$$->limit = *$1;
 			}
 			;
 
-- 
2.11.0

