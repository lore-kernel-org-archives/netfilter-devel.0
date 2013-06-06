From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] datatype: concat expression only releases dynamically allocated datatype
Date: Thu,  6 Jun 2013 13:37:25 +0200
Message-ID: <1370518645-9812-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36962 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab3FFLhf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:37:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond reports a crash with the following invalid command:

 nft add rule global filter ip daddr . tcp dport { 192.168.0.1 . 22\; 192.168.0.3 . 89 } drop

Note that the semicolon is incorrect in that concatenation,
it should be a comma.

The backtrace shows:
(gdb) bt
 #0  0x00007ffff6f39295 in __GI_raise (sig=sig@entry=6) at ../nptl/sysdeps/unix/sysv/linux/raise.c:56
 #1  0x00007ffff6f3c438 in __GI_abort () at abort.c:90
 #2  0x00007ffff6f7486b in __libc_message (do_abort=do_abort@entry=2, fmt=fmt@entry=0x7ffff7070d28 "*** Error in `%s': %s: 0x%s ***\n") at ../sysdeps/unix/sysv/linux/libc_fatal.c:199
 #3  0x00007ffff6f7eac6 in malloc_printerr (action=3, str=0x7ffff706ccca "free(): invalid pointer", ptr=<optimized out>) at malloc.c:4902
 #4  0x00007ffff6f7f843 in _int_free (av=<optimized out>, p=0x428530, have_lock=0) at malloc.c:3758
 #5  0x000000000041aae8 in xfree (ptr=0x428540 <invalid_type>) at src/utils.c:29
 #6  0x000000000040bc43 in concat_type_destroy (dtype=0x428540 <invalid_type>) at src/datatype.c:690
 #7  0x000000000040cebf in concat_expr_destroy (expr=0x643b90) at src/expression.c:571
[...]

It's trying to release 'invalid_type', which was not dynamically
allocated. Note that before the evaluation step, the invalid type
is attached to the expressions.

Since nftables allocates a dynamic datatype for concatenations in
case that needs to be released in the exit path. All datatypes
except this, are allocated in the BSS. Since we have no way to
differenciate between these two, add a flag so we can recognize
dynamically allocated datatypes.

While at it, rename dtype->type from enum to explicit uint32_t, as
it is used to store the concatenation type mask as well.

Reported-by: Eric Leblond <Eric Leblond <eric@regit.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/datatype.h |    8 +++++++-
 src/datatype.c     |   15 +++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 8a12363..053fbd9 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -81,11 +81,16 @@ enum byteorder {
 
 struct expr;
 
+enum datatype_flags {
+	DTYPE_F_ALLOC		= (1 << 0),
+};
+
 /**
  * struct datatype
  *
  * @type:	numeric identifier
  * @byteorder:	byteorder of type (non-basetypes only)
+ * @flags:	flags
  * @size:	type size (fixed sized non-basetypes only)
  * @name:	type name
  * @desc:	type description
@@ -96,8 +101,9 @@ struct expr;
  * @sym_tbl:	symbol table for this type
  */
 struct datatype {
-	enum datatypes			type;
+	uint32_t			type;
 	enum byteorder			byteorder;
+	unsigned int			flags;
 	unsigned int			size;
 	const char			*name;
 	const char			*desc;
diff --git a/src/datatype.c b/src/datatype.c
index 2cb937f..ca6c92f 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -658,6 +658,16 @@ static struct error_record *concat_type_parse(const struct expr *sym,
 		     sym->dtype->desc);
 }
 
+static struct datatype *dtype_alloc(void)
+{
+	struct datatype *dtype;
+
+	dtype = xzalloc(sizeof(*dtype));
+	dtype->flags = DTYPE_F_ALLOC;
+
+	return dtype;
+}
+
 const struct datatype *concat_type_alloc(const struct expr *expr)
 {
 	struct datatype *dtype;
@@ -676,7 +686,7 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 	}
 	strncat(desc, ")", sizeof(desc) - strlen(desc) - 1);
 
-	dtype		= xzalloc(sizeof(*dtype));
+	dtype		= dtype_alloc();
 	dtype->type	= type;
 	dtype->size	= size;
 	dtype->desc	= xstrdup(desc);
@@ -687,5 +697,6 @@ const struct datatype *concat_type_alloc(const struct expr *expr)
 
 void concat_type_destroy(const struct datatype *dtype)
 {
-	xfree(dtype);
+	if (dtype->flags & DTYPE_F_ALLOC)
+		xfree(dtype);
 }
-- 
1.7.10.4

