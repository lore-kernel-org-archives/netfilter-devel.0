From: Peter Stamfest <peter@stamfest.at>
Subject: Re: Introducing iptables-snmp...
Date: Wed, 26 Mar 2003 17:33:04 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0303261728120.25652-100000@peter.stamf.pr.at>
References: <20030326145910.GW21953@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030326145910.GW21953@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 26 Mar 2003, Harald Welte wrote:

> On Wed, Mar 19, 2003 at 12:02:27PM +0100, Peter Stamfest wrote:
> > It also requires iptables-1.2.7a (+a small patch to introduce 
> > "iptc_free" - I would suggest to actually apply this patch to the 
> > iptables-distribution) - it uses the libiptc.a library.
> 
> please post this patch here, I would like to include it. 
> 

Ok, see at the end...

> if you consider fixing the memory holes, please also post the fixes
> here.  thanks.

Unfortunatly ;-) I'm not experiencing any currently. I cannot talk about 
extensions/modules right now, as my test-system doesn't use many of them. 
A quick grep for "alloc" showed only some modules to use *alloc functions.

Do you have any more information?

peter

PS: The patch


diff -ur iptables-1.2.7a-org/include/libiptc/libip6tc.h iptables-1.2.7a/include/libiptc/libip6tc.h
--- iptables-1.2.7a-org/include/libiptc/libip6tc.h	Mon Feb 25 10:00:36 2002
+++ iptables-1.2.7a/include/libiptc/libip6tc.h	Mon Mar 17 15:14:23 2003
@@ -26,6 +26,9 @@
 /* Take a snapshot of the rules. Returns NULL on error. */
 ip6tc_handle_t ip6tc_init(const char *tablename);
 
+/* Frees space allocated for the handle. */
+void ip6tc_free(ip6tc_handle_t h);
+
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *ip6tc_first_chain(ip6tc_handle_t *handle);
 const char *ip6tc_next_chain(ip6tc_handle_t *handle);
diff -ur iptables-1.2.7a-org/include/libiptc/libiptc.h iptables-1.2.7a/include/libiptc/libiptc.h
--- iptables-1.2.7a-org/include/libiptc/libiptc.h	Thu Apr 19 18:35:39 2001
+++ iptables-1.2.7a/include/libiptc/libiptc.h	Mon Mar 17 15:12:36 2003
@@ -34,6 +34,9 @@
 /* Take a snapshot of the rules.  Returns NULL on error. */
 iptc_handle_t iptc_init(const char *tablename);
 
+/* Frees space allocated for the handle. */
+void iptc_free(iptc_handle_t h);
+
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *iptc_first_chain(iptc_handle_t *handle);
 const char *iptc_next_chain(iptc_handle_t *handle);
diff -ur iptables-1.2.7a-org/libiptc/libip4tc.c iptables-1.2.7a/libiptc/libip4tc.c
--- iptables-1.2.7a-org/libiptc/libip4tc.c	Wed Jun 12 21:22:29 2002
+++ iptables-1.2.7a/libiptc/libip4tc.c	Mon Mar 17 15:13:14 2003
@@ -91,6 +91,7 @@
 #define TC_SET_POLICY		iptc_set_policy
 #define TC_GET_RAW_SOCKET	iptc_get_raw_socket
 #define TC_INIT			iptc_init
+#define TC_FREE			iptc_free
 #define TC_COMMIT		iptc_commit
 #define TC_STRERROR		iptc_strerror
 
diff -ur iptables-1.2.7a-org/libiptc/libip6tc.c iptables-1.2.7a/libiptc/libip6tc.c
--- iptables-1.2.7a-org/libiptc/libip6tc.c	Thu Feb 14 00:13:23 2002
+++ iptables-1.2.7a/libiptc/libip6tc.c	Mon Mar 17 15:13:29 2003
@@ -86,6 +86,7 @@
 #define TC_SET_POLICY		ip6tc_set_policy
 #define TC_GET_RAW_SOCKET	ip6tc_get_raw_socket
 #define TC_INIT			ip6tc_init
+#define TC_FREE			ip6tc_free
 #define TC_COMMIT		ip6tc_commit
 #define TC_STRERROR		ip6tc_strerror
 
diff -ur iptables-1.2.7a-org/libiptc/libiptc.c iptables-1.2.7a/libiptc/libiptc.c
--- iptables-1.2.7a-org/libiptc/libiptc.c	Wed May 29 15:08:16 2002
+++ iptables-1.2.7a/libiptc/libiptc.c	Mon Mar 17 15:14:54 2003
@@ -292,6 +292,15 @@
 	return h;
 }
 
+void 
+TC_FREE(TC_HANDLE_T h)
+{
+    if (h) {
+	if (h->cache_chain_heads) free(h->cache_chain_heads);
+	free(h);
+    }
+}
+
 static inline int
 print_match(const STRUCT_ENTRY_MATCH *m)
 {
