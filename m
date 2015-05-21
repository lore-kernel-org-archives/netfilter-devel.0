From: Loganaden Velvindron <logan@elandsys.com>
Subject: Re: Harden iptables memory allocator
Date: Thu, 21 May 2015 12:29:56 -0700
Message-ID: <20150521192956.GA21427@mx.elandsys.com>
References: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Loganaden Velvindron <loganaden@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.qubic.net ([208.69.177.116]:60580 "EHLO mx.elandsys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422732AbbEUUAD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 May 2015 16:00:03 -0400
Content-Disposition: inline
In-Reply-To: <CAOp4FwQ5a=kKWDjGdpdHV7i3SX1msaqDkTrwYL2y=2+Bd690Cg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 21, 2015 at 06:42:49PM +0000, Loganaden Velvindron wrote:
> Hi All,
> 
> A number of Open Source projects such as OpenSSH, nsd, unbound,
> OpenBSD and FreeBSD have implemented a safe replacement for
> malloc(x*y) idiom which may lead to overflows.
> 
> Quoting from man page:
> Consider calloc() or the extension reallocarray() when there is
> multiplication in the size argument of malloc() or realloc(). For
> example, avoid this common idiom as it may lead to integer overflow:
> 
> if ((p = malloc(num * size)) == NULL)
> err(1, "malloc");
> 
> A drop-in replacement is the OpenBSD extension reallocarray():
> 
> if ((p = reallocarray(NULL, num, size)) == NULL)
> err(1, "reallocarray");
> 
> 
> Replacing malloc() with reallocarray() has led to one vulnerability
> being mitigated:
> See here: https://www.kb.cert.org/vuls/id/695940
> 
> The other advantage is that reallocarray() is faster than calloc(x*y)
> as there is no zero'ing overhead.
> 
> Patch below with a few conversions to reallocarray(). -- Feedback welcomed !
> 

Gmail broke the patch. Sorry for that.

Sending it using my other account:

diff --git a/include/xtables.h b/include/xtables.h
index bad11a8..e18b4cd 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -418,6 +418,7 @@ extern void xtables_init(void);
 extern void xtables_set_nfproto(uint8_t);
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
+extern void *xtables_reallocarray(void *, size_t, size_t);
 extern void *xtables_realloc(void *, size_t);
 
 extern int xtables_insmod(const char *, const char *, bool);
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 8db13b4..8964c1e 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -858,7 +858,7 @@ for_each_chain6(int (*fn)(const xt_chainlabel, int, struct xtc_handle *),
 		chain = ip6tc_next_chain(handle);
 	}
 
-	chains = xtables_malloc(sizeof(xt_chainlabel) * chaincount);
+	chains = xtables_reallocarray(NULL, chaincount, sizeof(xt_chainlabel));
 	i = 0;
 	chain = ip6tc_first_chain(handle);
 	while (chain) {
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 5357d12..1f62aa3 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -15,6 +15,23 @@
  *	along with this program; if not, write to the Free Software
  *	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
  */
+
+/* xtables_reallocarray.c is under: 
+ * Copyright (c) 2008 Otto Moerbeek <otto@drijf.net>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+*/
+
 #include "config.h"
 #include <ctype.h>
 #include <errno.h>
@@ -308,6 +325,23 @@ void *xtables_malloc(size_t size)
 	return p;
 }
 
+/*
+ * This is sqrt(SIZE_MAX+1), as s1*s2 <= SIZE_MAX
+ * if both s1 < MUL_NO_OVERFLOW and s2 < MUL_NO_OVERFLOW
+ */
+#define MUL_NO_OVERFLOW	((size_t)1 << (sizeof(size_t) * 4))
+
+void *
+xtables_reallocarray(void *optr, size_t nmemb, size_t size)
+{
+	if ((nmemb >= MUL_NO_OVERFLOW || size >= MUL_NO_OVERFLOW) &&
+	    nmemb > 0 && SIZE_MAX / nmemb < size) {
+		perror("ip[6]tables: reallocarray failed");
+		exit(1);
+	}
+	return xtables_realloc(optr, size * nmemb);
+}
+
 void *xtables_realloc(void *ptr, size_t size)
 {
 	void *p;
@@ -1432,8 +1466,8 @@ void xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
 		++loop; /* skip ',' */
 	}
 
-	*addrpp = xtables_malloc(sizeof(struct in_addr) * count);
-	*maskpp = xtables_malloc(sizeof(struct in_addr) * count);
+	*addrpp = xtables_reallocarray(NULL, count, sizeof(struct in_addr));
+	*maskpp = xtables_reallocarray(NULL, count, sizeof(struct in_addr));
 
 	loop = name;
 
@@ -1753,8 +1787,8 @@ xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
 		++loop; /* skip ',' */
 	}
 
-	*addrpp = xtables_malloc(sizeof(struct in6_addr) * count);
-	*maskpp = xtables_malloc(sizeof(struct in6_addr) * count);
+	*addrpp = xtables_reallocarray(NULL, count, sizeof(struct in6_addr));
+	*maskpp = xtables_reallocarray(NULL, count, sizeof(struct in6_addr));
 
 	loop = name;
 
