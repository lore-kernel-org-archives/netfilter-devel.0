From: Behan Webster <behanw@converseincode.com>
Subject: [PATCH V2 3/3] Remove VLAIS usage from netfilter
Date: Tue, 30 Oct 2012 17:18:57 -0400
Message-ID: <1351631937-21455-4-git-send-email-behanw@converseincode.com>
References: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>,
	pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>
To: balbi@ti.com, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351631937-21455-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=46rom: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>

The use of variable length arrays in structs (VLAIS) in the Linux Kerne=
l code
precludes the use of compilers which don't implement VLAIS (for instanc=
e the
Clang compiler). This patch instead calculates offsets into the kmalloc=
-ed
memory buffer using macros from valign.h.

Patch from series at
http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/14=
2707.html
by PaX Team.

Signed-off-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
Cc: pageexec@freemail.hu
[Modified to use macros from valign.h]
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 net/netfilter/xt_repldata.h |   40 ++++++++++++++++++++++++-----------=
-----
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_repldata.h b/net/netfilter/xt_repldata.h
index 6efe4e5..d2b4232 100644
--- a/net/netfilter/xt_repldata.h
+++ b/net/netfilter/xt_repldata.h
@@ -5,31 +5,39 @@
  * they serve as the hanging-off data accessed through repl.data[].
  */
=20
+#include <linux/valign.h>
+
 #define xt_alloc_initial_table(type, typ2) ({ \
 	unsigned int hook_mask =3D info->valid_hooks; \
 	unsigned int nhooks =3D hweight32(hook_mask); \
 	unsigned int bytes =3D 0, hooknum =3D 0, i =3D 0; \
-	struct { \
-		struct type##_replace repl; \
-		struct type##_standard entries[nhooks]; \
-		struct type##_error term; \
-	} *tbl =3D kzalloc(sizeof(*tbl), GFP_KERNEL); \
-	if (tbl =3D=3D NULL) \
+	int replsize =3D paddedsize(0, 1, \
+		struct type##_replace, struct type##_standard); \
+	int entsize =3D paddedsize(replsize, nhooks, \
+		struct type##_standard, struct type##_error); \
+	int termsize =3D paddedsize(replsize+entsize, 1, \
+		struct type##_error, int); \
+	struct type##_replace *repl =3D kzalloc(replsize+entsize+termsize, \
+		GFP_KERNEL); \
+	if (repl =3D=3D NULL) \
 		return NULL; \
-	strncpy(tbl->repl.name, info->name, sizeof(tbl->repl.name)); \
-	tbl->term =3D (struct type##_error)typ2##_ERROR_INIT;  \
-	tbl->repl.valid_hooks =3D hook_mask; \
-	tbl->repl.num_entries =3D nhooks + 1; \
-	tbl->repl.size =3D nhooks * sizeof(struct type##_standard) + \
-	                 sizeof(struct type##_error); \
+	struct type##_standard *entries =3D paddedstart(repl, replsize, \
+		struct type##_standard); \
+	struct type##_error *term =3D paddedstart(entries, entsize, \
+		struct type##_error); \
+	strncpy(repl->name, info->name, sizeof(repl->name)); \
+	*term =3D (struct type##_error)typ2##_ERROR_INIT;  \
+	repl->valid_hooks =3D hook_mask; \
+	repl->num_entries =3D nhooks + 1; \
+	repl->size =3D entsize+termsize; \
 	for (; hook_mask !=3D 0; hook_mask >>=3D 1, ++hooknum) { \
 		if (!(hook_mask & 1)) \
 			continue; \
-		tbl->repl.hook_entry[hooknum] =3D bytes; \
-		tbl->repl.underflow[hooknum]  =3D bytes; \
-		tbl->entries[i++] =3D (struct type##_standard) \
+		repl->hook_entry[hooknum] =3D bytes; \
+		repl->underflow[hooknum]  =3D bytes; \
+		entries[i++] =3D (struct type##_standard) \
 			typ2##_STANDARD_INIT(NF_ACCEPT); \
 		bytes +=3D sizeof(struct type##_standard); \
 	} \
-	tbl; \
+	repl; \
 })
--=20
1.7.9.5
