From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 1/4] RFC: fast string matching infrastrure for netfilter
Date: Sun, 09 Jan 2005 23:23:09 +0100
Message-ID: <41E1AECD.6020209@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060300070005060001080801"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060300070005060001080801
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've finished a first usable version of a infrastructure to look for 
matchings in a packet. Features:

* A library consisting in three public functions: constructor, 
destructor and searching.
* Boyer-moore algorithm to perform fast matchings.
* Brute force search on the edges of two fragments to look for 
fragmented matches, that is O(m) searchs where m is the size of the 
pattern, it's not that bad for small pattern I think. It's fragment 
aware by means of rusty's skb_iter functions.

Comments welcome.

--
Pablo

--------------060300070005060001080801
Content-Type: text/x-patch;
 name="string-match.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="string-match.patch"

--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ linux-2.5/net/ipv4/netfilter/nf_string_match.c	2005-01-09 21:54:04.000000000 +0100
@@ -0,0 +1,264 @@
+/* Efficient string matching fragment aware infrastrure for netfilter
+ * Copyright (C) 2004 Pablo Neira Ayuso <pablo@eurodev.net>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * Idea:
+ * 	
+ * 	This algorithm used Boyer-Moore fast matching algorithm to look
+ * 	for a pattern in the payload of a packet. Since it is fragment
+ * 	aware, it looks for partial matches on the edges of two fragments.
+ *
+ * Literature:
+ * 
+ *      A Fast String Searching Algorithm, R.S. Boyer and Moore.
+ *      Communications of the Association for Computing Machinery, 
+ *      20(10), 1977, pp. 762-772.
+ *	http://www.cs.utexas.edu/users/moore/publications/fstrpos.pdf
+ *
+ * 	Handbook of Exact String Matching Algorithms, Thierry Lecroq, 2004
+ * 	http://www-igm.univ-mlv.fr/~lecroq/string/string.pdf
+ * 
+ * Implementation:
+ * 
+ * 	Boyer Moore implementation heavily based on Gianni Tedesco's.
+ */
+
+#include <linux/module.h>
+#include <linux/netfilter_ipv4/nf_string_match.h>
+#include <linux/skbuff.h>
+
+#if 0
+#define DEBUGP printk
+#else
+#define DEBUGP(format, args...)
+#endif
+
+/* Compute constant structures needed by the boyer-moore algorithm,
+ * this is done just ONCE. */
+static void
+sm_preprocess(struct nf_string_match *sm)
+{
+	int i, j, len[ASIZE], ended;
+
+	/* Compute the bad caracter shift array */
+	for (i = 0; i < ASIZE; i++)
+		sm->badshift[i] = sm->patlen;
+	for (i = 0; i < sm->patlen - 1; i++)
+		sm->badshift[(int) sm->pat[i]] = sm->patlen - 1 - i;
+
+	/* Compute the good shift array, used to match reocurrences 
+	 * of a subpattern */
+	for (i = 1; i < sm->patlen; i++) {
+		for (j = 0; j < sm->patlen && sm->pat[sm->patlen -1 - j] 
+				== sm->pat[sm->patlen - 1 - i - j]; j++);
+		len[i] = j;
+	}  
+
+	sm->goodshift[0] = 1;
+	for (i = 1; i < sm->patlen; i++)
+		sm->goodshift[i] = sm->patlen;
+	for (i = sm->patlen - 1; i > 0; i--)
+		sm->goodshift[len[i]] = i;
+
+	ended = 0;
+	for (i = 0; i < sm->patlen; i++) {
+		if (len[i] == sm->patlen - 1 - i)
+			ended = i;
+		if (ended)
+			sm->goodshift[i] = ended;
+	}
+}
+
+struct nf_string_match *
+nf_string_match_create(const char *pat, int patlen)
+{
+	struct nf_string_match *sm;
+
+	sm = kmalloc(sizeof(struct nf_string_match), GFP_KERNEL);
+	if (!sm)
+		return NULL;
+	memset(sm, 0, sizeof(struct nf_string_match));
+
+	sm->goodshift = (int *) kmalloc(patlen * sizeof(int), GFP_KERNEL);
+	if (!sm->goodshift)
+		return NULL;
+	memset(sm->goodshift, 0, sizeof(int) * patlen);
+	
+	sm->pat = (char *) kmalloc(patlen * sizeof(int), GFP_KERNEL);
+	if (!sm->pat) {
+		kfree(sm->goodshift);
+		return NULL;
+	}
+	memset(sm->pat, patlen, sizeof(char) * patlen);
+	
+	strcpy(sm->pat, pat);
+	sm->patlen = patlen;
+
+	/* Preprocess the pattern */
+	sm_preprocess(sm);
+
+	return sm;
+}
+
+/* release the structure */
+void nf_string_match_destroy(struct nf_string_match *sm)
+{
+	kfree(sm->goodshift);
+	kfree(sm->pat);
+	kfree(sm);
+}
+
+#define MAX(a,b) a>b?a:b
+
+/* this functions returns the offset where a matching was found */
+static unsigned int
+sm_search(struct nf_string_match *sm, unsigned char *data, int size, 
+	  unsigned int *offset)
+{
+	int right_end = sm->patlen, sk, sh, i;
+
+	while (right_end < size) {
+		DEBUGP("Searching in position %d (%c)\n", 
+		       right_end, data[right_end]);
+		for (i = 0; i < sm->patlen && data[right_end - i] 
+				== sm->pat[sm->patlen - 1 - i]; i++);
+		if (i == sm->patlen) {
+			/* London calling... */
+			DEBUGP("found!\n");
+			*offset += (right_end - (sm->patlen - 1));
+			return 1;
+		}
+		
+		sk = sm->badshift[data[right_end - i]];  
+		sh = sm->goodshift[i];
+		DEBUGP("bad shift: %d good shift: %d\n", sk, sh);
+
+		/* Now jumping to... */
+		right_end = MAX(right_end - i + sk, right_end + sh);
+	}
+	*offset += size;
+	return 0;
+}
+
+/* Brute force: look for a partial matching at the end of the packet.
+ * A match never hits here, it's impossible. */
+static void
+sm_frag_search_end(struct nf_string_match *sm, void *ptr, int size, 
+		   int *partial)
+{
+	int i;
+	unsigned char *data = ptr + size - sm->patlen;
+
+	for (i=0; i < sm->patlen; i++) {
+		DEBUGP("end: %c == %c (%d)\n", data[i], 
+			sm->pat[*partial], *partial);
+		
+		if (data[i] == sm->pat[*partial])
+			(*partial)++;
+		else {
+			if (data[i] == sm->pat[0])
+				*partial = 1;
+			else 
+				*partial = 0;
+		}
+	}
+	DEBUGP("sm->partial:%d\n", *partial);
+}
+
+/* Brute force: Look for a matching at the beginning. Yes, here
+ * we can hit a full match */
+static int
+sm_frag_search_begin(struct nf_string_match *sm, void *ptr, int size, 
+		     unsigned int *offset, int *partial)
+{
+	int i, j = sm->patlen - *partial;
+	unsigned char *data = (unsigned char *) ptr;
+
+	for (i=0; i<j; i++) {
+		DEBUGP("begin: %c == %c (%d)\n", data[i],
+			sm->pat[*partial], *partial);
+
+		if (data[i] == sm->pat[*partial])
+			(*partial)++;
+		else
+			*partial = 0;
+	}
+
+	if (*partial == sm->patlen) {
+		DEBUGP("Fragmented match!\n");
+		*offset += i;
+		return 1;
+	}
+
+	/* No matching founds, so reset counter */
+	*partial = 0;
+
+	return 0;
+}
+
+static inline int
+frag_search(void *data, int size, struct nf_string_match *sm, 
+	    unsigned int *offset, int *partial)
+{
+	/* There was a partial match before */
+	if (sm_frag_search_begin(sm, data, size, offset, partial))
+		return 1;
+
+	if (sm_search(sm, data, size, offset))
+		return 1;
+
+	sm_frag_search_end(sm, data, size, partial);
+
+	return 0;
+}
+
+int
+nf_string_match_search(const struct sk_buff *skb, struct nf_string_match *sm,
+		       unsigned int *offset)
+{
+	/* make sure offset is always set to zero */
+	*offset = 0;
+
+	if (!skb_is_nonlinear(skb)) {
+		DEBUGP("linear searching\n");
+		/* General case: look for pattern in linear packet */
+		if (sm_search(sm, skb->data, skb->len, offset))
+			return 1;
+	} else {
+		/* The packet is fragmented */
+		struct skb_iter i;
+		int partial = 0;
+
+		DEBUGP("non linear searching\n");
+
+		/* Look for the pattern in first fragment */
+		skb_iter_first(skb, &i);
+		if (frag_search(i.data, i.len, sm, offset, &partial))
+			return 1;
+
+		/* Now, the rest of fragments ... */
+		while (skb_iter_next(skb, &i)) {
+			DEBUGP("%p (size:%d)\n", i.data, i.len);
+			if (frag_search(i.data, i.len, sm, offset, &partial))
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int __init init(void) { return 1; }
+static void __exit fini(void) {}
+
+module_init(init);
+module_exit(fini);
+
+MODULE_LICENSE("GPL");
+
+EXPORT_SYMBOL_GPL(nf_string_match_create);
+EXPORT_SYMBOL_GPL(nf_string_match_search);
+EXPORT_SYMBOL_GPL(nf_string_match_destroy);
--- /dev/null	2004-09-23 01:18:13.000000000 +0200
+++ linux-2.5/include/linux/netfilter_ipv4/nf_string_match.h	2005-01-09 19:28:25.000000000 +0100
@@ -0,0 +1,24 @@
+#ifndef _STRING_MATCHING_H
+#define _STRING_MATCHING_H
+
+#include <linux/skbuff.h>
+
+/* Alphabet size */
+#define ASIZE 256
+
+struct nf_string_match {
+	char 		*pat;
+	int 		patlen;
+
+	int 		badshift[ASIZE];
+	int 		*goodshift;
+};
+
+extern struct nf_string_match *
+nf_string_match_create(const char *pat, int patlen);
+extern int nf_string_match_search(const struct sk_buff *skb, 
+				  struct nf_string_match *sm,
+				  unsigned int *offset);
+extern void nf_string_match_destroy(struct nf_string_match *sm);
+
+#endif

--------------060300070005060001080801--
