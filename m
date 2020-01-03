Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D351AC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 19:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9959820866
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 19:36:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BGyfMLgd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgACTgr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 14:36:47 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44363 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728519AbgACTgr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 14:36:47 -0500
Received: by mail-yb1-f195.google.com with SMTP id f136so15922347ybg.11
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jan 2020 11:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zgWr+nxyJZbH90FsyYvZb980JEWi+ZyhdefWazFQmNM=;
        b=BGyfMLgdx0xg6EInoHE/ShjQYTHVZjSZV+3pWxdS65yZktxtaeGF1hEuJtIWIPAWMV
         QV8U190xZ97OPxiiqA2cD0Fpt2LwL5OMmhtygTDqzonAfs6tLo/tb//J+TIg9sZCCh5Y
         aXEcD6eWIaDG2U4IEgcL8NC2dsupH1E5P89lyhInWMf7AW2W9NHkjiM2pnbWhLZJLScO
         8xJll+ftEnRNyggFDtZyKFKuWscV+bOAiSQqDIPLZWqVvM205GZMXSwN9FOmku1cVyvr
         bdyKT5MTgXLecjlhrBp8oDWnYIm739i09w4t/BT+o1GJ9V4c5mGGZKyezPQ4FrJw69Ic
         Kt3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zgWr+nxyJZbH90FsyYvZb980JEWi+ZyhdefWazFQmNM=;
        b=HiF7I9uKbXB/LGHEtZTKGTT7OoDRO35CDCX4D3QlrRfKWsJ+t8GP1MGDtAWaPxOUqp
         sQUDAoYTshZ58bUdJ47pfcM9CvfmxjwvUHts+n+wLeik3aaLm+kQZAciMjL/itqx4tCy
         ZoMo16Bfkw4FgJbIknNAhGrE0kpMHJggmozry/fWwk8SIxfujAicEY+fFcxhrsI00ToT
         sUHQYTlkmMgtbyLiVVv4drF7Rf2X2H49xnjVn+aLDnT7L6YoB5membWcq9XttW3Rr86O
         3fx/4HLc1H3px9wbG8/RFBCz9W1ktxcsXO8nlpOBX5AaOsoYzycD+afWbmtWGRukMu3j
         g+Kg==
X-Gm-Message-State: APjAAAV+pjg0poNorT3BTnC6hnf+jIYkQXDfhpS2YiF8wA7i5zwBI+ru
        9wjDPo3ZGIwdKhxAyJFc0GNZ7twEhEA=
X-Google-Smtp-Source: APXvYqxw6LwpSsM6QkWeyHJptoVcDUPtxRPa9g06+KFA4H+QOswZSZgsXtA6serFnTpQzWecSD/W7Q==
X-Received: by 2002:a5b:d4f:: with SMTP id f15mr66368591ybr.134.1578080205772;
        Fri, 03 Jan 2020 11:36:45 -0800 (PST)
Received: from osboxes.zebraskunk.int (cpe-74-137-94-90.kya.res.rr.com. [74.137.94.90])
        by smtp.gmail.com with ESMTPSA id 207sm23703236ywq.100.2020.01.03.11.36.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 11:36:45 -0800 (PST)
From:   Brett Mastbergen <brett.mastbergen@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Brett Mastbergen <bmastbergen@untangle.com>
Subject: [PATCH libnftnl] include: Remove buffer.h
Date:   Fri,  3 Jan 2020 14:36:40 -0500
Message-Id: <20200103193640.8257-1-brett.mastbergen@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Brett Mastbergen <bmastbergen@untangle.com>

Almost everything in this header is unused.  The command defines
used in utils.c don't seem to be justified and have just been
replaced by their strings

Signed-off-by: Brett Mastbergen <bmastbergen@untangle.com>
---
 include/Makefile.am |   1 -
 include/buffer.h    | 109 ----------------------------------------------------
 include/internal.h  |   1 -
 src/chain.c         |   1 -
 src/common.c        |   1 -
 src/expr/dup.c      |   1 -
 src/expr/dynset.c   |   1 -
 src/expr/fwd.c      |   1 -
 src/flowtable.c     |   1 -
 src/object.c        |   1 -
 src/rule.c          |   1 -
 src/table.c         |   1 -
 src/utils.c         |  20 +++++-----
 13 files changed, 10 insertions(+), 130 deletions(-)
 delete mode 100644 include/buffer.h

diff --git a/include/Makefile.am b/include/Makefile.am
index b31aa10..738f807 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -2,7 +2,6 @@ SUBDIRS = libnftnl linux
 
 noinst_HEADERS = internal.h	\
 		 linux_list.h	\
-		 buffer.h	\
 		 data_reg.h	\
 		 expr_ops.h	\
 		 obj.h		\
diff --git a/include/buffer.h b/include/buffer.h
deleted file mode 100644
index f6626a6..0000000
--- a/include/buffer.h
+++ /dev/null
@@ -1,109 +0,0 @@
-#ifndef _NFTNL_BUFFER_H_
-#define _NFTNL_BUFFER_H_
-
-#include <stdint.h>
-#include <stdbool.h>
-
-struct nftnl_expr;
-
-struct nftnl_buf {
-	char		*buf;
-	size_t		size;
-	size_t		len;
-	uint32_t	off;
-	bool		fail;
-};
-
-#define NFTNL_BUF_INIT(__b, __buf, __len)			\
-	struct nftnl_buf __b = {				\
-		.buf	= __buf,			\
-		.len	= __len,			\
-	};
-
-int nftnl_buf_update(struct nftnl_buf *b, int ret);
-int nftnl_buf_done(struct nftnl_buf *b);
-
-union nftnl_data_reg;
-
-int nftnl_buf_open(struct nftnl_buf *b, int type, const char *tag);
-int nftnl_buf_close(struct nftnl_buf *b, int type, const char *tag);
-
-int nftnl_buf_open_array(struct nftnl_buf *b, int type, const char *tag);
-int nftnl_buf_close_array(struct nftnl_buf *b, int type, const char *tag);
-
-int nftnl_buf_u32(struct nftnl_buf *b, int type, uint32_t value, const char *tag);
-int nftnl_buf_s32(struct nftnl_buf *b, int type, uint32_t value, const char *tag);
-int nftnl_buf_u64(struct nftnl_buf *b, int type, uint64_t value, const char *tag);
-int nftnl_buf_str(struct nftnl_buf *b, int type, const char *str, const char *tag);
-int nftnl_buf_reg(struct nftnl_buf *b, int type, union nftnl_data_reg *reg,
-		int reg_type, const char *tag);
-int nftnl_buf_expr_open(struct nftnl_buf *b, int type);
-int nftnl_buf_expr_close(struct nftnl_buf *b, int type);
-int nftnl_buf_expr(struct nftnl_buf *b, int type, uint32_t flags,
-		   struct nftnl_expr *expr);
-
-#define BASE			"base"
-#define BYTES			"bytes"
-#define BURST			"burst"
-#define CHAIN			"chain"
-#define CODE			"code"
-#define COMPAT_FLAGS		"compat_flags"
-#define COMPAT_PROTO		"compat_proto"
-#define CONSUMED		"consumed"
-#define COUNT			"count"
-#define DATA			"data"
-#define DEVICE			"device"
-#define DIR			"dir"
-#define DREG			"dreg"
-#define EXTHDR_TYPE		"exthdr_type"
-#define FAMILY			"family"
-#define FLAGS			"flags"
-#define GROUP			"group"
-#define HANDLE			"handle"
-#define HOOKNUM			"hooknum"
-#define KEY			"key"
-#define LEN			"len"
-#define LEVEL			"level"
-#define MASK			"mask"
-#define NAT_TYPE		"nat_type"
-#define NAME			"name"
-#define NUM			"num"
-#define OFFSET			"offset"
-#define OP			"op"
-#define PACKETS			"packets"
-#define PKTS			"pkts"
-#define POLICY			"policy"
-#define POSITION		"position"
-#define PREFIX			"prefix"
-#define PRIO			"prio"
-#define QTHRESH			"qthreshold"
-#define RATE			"rate"
-#define RULE			"rule"
-#define SET			"set"
-#define SET_NAME		"set_name"
-#define SIZE			"size"
-#define SNAPLEN			"snaplen"
-#define SREG_ADDR_MAX		"sreg_addr_max"
-#define SREG_ADDR_MIN		"sreg_addr_min"
-#define SREG_PROTO_MAX		"sreg_proto_max"
-#define SREG_PROTO_MIN		"sreg_proto_min"
-#define SREG_KEY		"sreg_key"
-#define SREG_DATA		"sreg_data"
-#define SREG_QNUM		"sreg_qnum"
-#define SREG			"sreg"
-#define TABLE			"table"
-#define TOTAL			"total"
-#define TYPE			"type"
-#define UNIT			"unit"
-#define USE			"use"
-#define XOR			"xor"
-#define ADD			"add"
-#define INSERT			"insert"
-#define DELETE			"delete"
-#define REPLACE			"replace"
-#define FLUSH			"flush"
-#define MODULUS			"modulus"
-#define SEED			"seed"
-#define ID			"id"
-
-#endif
diff --git a/include/internal.h b/include/internal.h
index a61b725..1f96731 100644
--- a/include/internal.h
+++ b/include/internal.h
@@ -11,7 +11,6 @@
 #include "set_elem.h"
 #include "expr.h"
 #include "expr_ops.h"
-#include "buffer.h"
 #include "rule.h"
 
 #endif /* _LIBNFTNL_INTERNAL_H_ */
diff --git a/src/chain.c b/src/chain.c
index b9a16fc..b4066e4 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -28,7 +28,6 @@
 
 #include <libnftnl/chain.h>
 #include <libnftnl/rule.h>
-#include <buffer.h>
 
 struct nftnl_chain {
 	struct list_head head;
diff --git a/src/common.c b/src/common.c
index feb13b2..2d83c12 100644
--- a/src/common.c
+++ b/src/common.c
@@ -17,7 +17,6 @@
 #include <libmnl/libmnl.h>
 #include <libnftnl/common.h>
 #include <libnftnl/set.h>
-#include <buffer.h>
 
 #include <errno.h>
 #include "internal.h"
diff --git a/src/expr/dup.c b/src/expr/dup.c
index 2bb35e5..ac39839 100644
--- a/src/expr/dup.c
+++ b/src/expr/dup.c
@@ -19,7 +19,6 @@
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
 #include "data_reg.h"
-#include <buffer.h>
 
 struct nftnl_expr_dup {
 	enum nft_registers	sreg_addr;
diff --git a/src/expr/dynset.c b/src/expr/dynset.c
index 4870923..b2d8edc 100644
--- a/src/expr/dynset.c
+++ b/src/expr/dynset.c
@@ -20,7 +20,6 @@
 #include <libnftnl/expr.h>
 #include "data_reg.h"
 #include "expr_ops.h"
-#include <buffer.h>
 
 struct nftnl_expr_dynset {
 	enum nft_registers	sreg_key;
diff --git a/src/expr/fwd.c b/src/expr/fwd.c
index cff8235..2ec63c1 100644
--- a/src/expr/fwd.c
+++ b/src/expr/fwd.c
@@ -19,7 +19,6 @@
 #include <libnftnl/rule.h>
 #include "expr_ops.h"
 #include "data_reg.h"
-#include <buffer.h>
 
 struct nftnl_expr_fwd {
 	enum nft_registers	sreg_dev;
diff --git a/src/flowtable.c b/src/flowtable.c
index 9ba3b6d..1e235d0 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -17,7 +17,6 @@
 #include <linux/netfilter_arp.h>
 
 #include <libnftnl/flowtable.h>
-#include <buffer.h>
 
 struct nftnl_flowtable {
 	struct list_head	head;
diff --git a/src/object.c b/src/object.c
index c876add..4f58272 100644
--- a/src/object.c
+++ b/src/object.c
@@ -22,7 +22,6 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libnftnl/object.h>
-#include <buffer.h>
 #include "obj.h"
 
 static struct obj_ops *obj_ops[__NFT_OBJECT_MAX] = {
diff --git a/src/rule.c b/src/rule.c
index 252410b..8d7e068 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -20,7 +20,6 @@
 #include <errno.h>
 #include <inttypes.h>
 #include <ctype.h>
-#include <buffer.h>
 
 #include <libmnl/libmnl.h>
 #include <linux/netfilter/nfnetlink.h>
diff --git a/src/table.c b/src/table.c
index adcfafe..94d522b 100644
--- a/src/table.c
+++ b/src/table.c
@@ -24,7 +24,6 @@
 #include <linux/netfilter/nf_tables.h>
 
 #include <libnftnl/table.h>
-#include <buffer.h>
 
 struct nftnl_table {
 	struct list_head head;
diff --git a/src/utils.c b/src/utils.c
index f641bf9..3617837 100644
--- a/src/utils.c
+++ b/src/utils.c
@@ -242,11 +242,11 @@ enum nftnl_cmd_type nftnl_flag2cmd(uint32_t flags)
 }
 
 static const char *cmd2tag[NFTNL_CMD_MAX] = {
-	[NFTNL_CMD_ADD]			= ADD,
-	[NFTNL_CMD_INSERT]		= INSERT,
-	[NFTNL_CMD_DELETE]		= DELETE,
-	[NFTNL_CMD_REPLACE]		= REPLACE,
-	[NFTNL_CMD_FLUSH]			= FLUSH,
+	[NFTNL_CMD_ADD]			= "add",
+	[NFTNL_CMD_INSERT]		= "insert",
+	[NFTNL_CMD_DELETE]		= "delete",
+	[NFTNL_CMD_REPLACE]		= "replace",
+	[NFTNL_CMD_FLUSH]			= "flush",
 };
 
 const char *nftnl_cmd2tag(enum nftnl_cmd_type cmd)
@@ -259,15 +259,15 @@ const char *nftnl_cmd2tag(enum nftnl_cmd_type cmd)
 
 uint32_t nftnl_str2cmd(const char *cmd)
 {
-	if (strcmp(cmd, ADD) == 0)
+	if (strcmp(cmd, "add") == 0)
 		return NFTNL_CMD_ADD;
-	else if (strcmp(cmd, INSERT) == 0)
+	else if (strcmp(cmd, "insert") == 0)
 		return NFTNL_CMD_INSERT;
-	else if (strcmp(cmd, DELETE) == 0)
+	else if (strcmp(cmd, "delete") == 0)
 		return NFTNL_CMD_DELETE;
-	else if (strcmp(cmd, REPLACE) == 0)
+	else if (strcmp(cmd, "replace") == 0)
 		return NFTNL_CMD_REPLACE;
-	else if (strcmp(cmd, FLUSH) == 0)
+	else if (strcmp(cmd, "flush") == 0)
 		return NFTNL_CMD_FLUSH;
 
 	return NFTNL_CMD_UNSPEC;
-- 
2.11.0

