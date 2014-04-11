From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH RFC] expression: fix constant expression allocation on big
 endian
Date: Fri, 11 Apr 2014 17:20:08 +0200
Message-ID: <20140411152008.GA10312@macbook.localnet>
References: <CAOkSjBjhsQ7wS4_0YMrcV0Mm5yKOSVh8rn+sg3JK5zTH2qhYDw@mail.gmail.com>
 <20140404120504.GB27267@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33831 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbaDKPUL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2014 11:20:11 -0400
Content-Disposition: inline
In-Reply-To: <20140404120504.GB27267@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 04, 2014 at 02:05:04PM +0200, Patrick McHardy wrote:
> On Wed, Apr 02, 2014 at 06:23:03PM +0200, Arturo Borrero Gonzalez wrote:
> > Hi there!
> > 
> > I've been testing nftables at sparc, looking for endianess issues.
> 
> Great, I meant to do this for a long time.
> 
> > Unfortunately, weird things happened.
> > 
> > Adding some rule:
> > 
> > % nft add table filter
> > % nft add chain filter input
> > % nft add rule filter input tcp dport 22 counter
> > % nft list table filter
> > table ip filter {
> >   chain input {
> >     payload @th,16,16 0x0 [invalid type] counter packets 0 bytes 0
> >   }
> > }
> > 
> > However, matching happened when I generated some traffic.
> 
> So it appears we only have a problem in userspace? That's at least partially
> good news. Could you provide access to that machine for debugging?

Ok here's a patch to partially fix the problem. We have a similar case
in the kernel when calculating the mask for the cmp_fast expression,
as well as some problems in data import/export in userspace. I'll take
care of those next.

I'm not entirely happy with the naming in this patch, better suggestions
are welcome.


>From 6c66c4998602c4489595222c47d79a5674952218 Mon Sep 17 00:00:00 2001
From: Patrick McHardy <kaber@trash.net>
Date: Fri, 11 Apr 2014 17:09:15 +0200
Subject: [PATCH] expression: fix constant expression allocation on big endian

When allocating a constant expression, a pointer to the data is passed
to the allocation function. When the variable used to store the data
is larger than the size of the data type, this fails on big endian since
the most significant bytes (being zero) come first.

Add a helper function to calculate the proper address for the cases
where this is needed.

This currently affects symbolic tables for values < u64 and payload
dependency generation for protocol values < u32.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/utils.h | 13 +++++++++++++
 src/datatype.c  |  3 ++-
 src/payload.c   |  4 +++-
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/utils.h b/include/utils.h
index 88ee0c9..93f9f06 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -46,6 +46,19 @@
 	typeof( ((type *)0)->member ) *__mptr = (ptr);		\
 	(type *)( (void *)__mptr - offsetof(type,member) );})
 
+/**
+ * Return a pointer to a constant variable of a size smaller than the variable.
+ */
+#ifdef __BIG_ENDIAN
+#define constant_data_ptr(val, len) \
+	((void *)&val + sizeof(val) - (len) / BITS_PER_BYTE)
+#elif __LITTLE_ENDIAN
+#define constant_data_ptr(val, len) \
+	((void *)&val)
+#else
+error "byteorder undefined"
+#endif
+
 #define field_sizeof(t, f)	(sizeof(((t *)NULL)->f))
 #define array_size(arr)		(sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 #define div_round_up(n, d)	(((n) + (d) - 1) / (d))
diff --git a/src/datatype.c b/src/datatype.c
index ac42faa..367c3ea 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <asm/byteorder.h>
 #include <linux/types.h>
 #include <linux/netfilter.h>
 
@@ -124,7 +125,7 @@ struct error_record *symbolic_constant_parse(const struct expr *sym,
 
 	*res = constant_expr_alloc(&sym->location, dtype,
 				   dtype->byteorder, dtype->size,
-				   &s->value);
+				   constant_data_ptr(s->value, dtype->size));
 	return NULL;
 }
 
diff --git a/src/payload.c b/src/payload.c
index 427080c..e2a9407 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -17,6 +17,7 @@
 #include <string.h>
 #include <net/if_arp.h>
 #include <arpa/inet.h>
+#include <asm/byteorder.h>
 #include <linux/netfilter.h>
 
 #include <rule.h>
@@ -209,7 +210,8 @@ int payload_gen_dependency(struct eval_ctx *ctx, const struct expr *expr,
 
 	right = constant_expr_alloc(&expr->location, tmpl->dtype,
 				    BYTEORDER_HOST_ENDIAN,
-				    tmpl->len, &protocol);
+				    tmpl->len,
+				    constant_data_ptr(protocol, tmpl->len));
 
 	dep = relational_expr_alloc(&expr->location, OP_EQ, left, right);
 	left->ops->pctx_update(&ctx->pctx, dep);
-- 
1.9.0

