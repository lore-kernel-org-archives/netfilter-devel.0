From: Peter Riley <Peter.Riley@hotpop.com>
Subject: [PATCH] Last vestiges of NFC
Date: Sat, 25 Aug 2007 10:21:38 -0700
Message-ID: <46D06522.2090509@hotpop.com>
Reply-To: Peter.Riley@hotpop.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040803020800070308050604"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------040803020800070308050604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Hello!

It appears that the tweaking of NFC_* bits of nfcache was almost completely
done away with around the times of these threads:

http://lists.netfilter.org/pipermail/netfilter-devel/2005-February/018448.html
http://lists.netfilter.org/pipermail/netfilter-devel/2005-May/019574.html

But I found some vestiges remaining in iptables-1.3.8 that look like this

 static void init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_UNKNOWN;
 }

remaining in the init() functions of these extensions:

     libipt_policy.c    libip6t_policy.c
     libipt_connmark.c  libip6t_connmark.c

The first patch attached below removes these.


But anyway, the question I *really* want to raise is whether the is_same()
comparison functions in libip4tc.c and libip6tc.c might be changed to *not*
compare nfcache bits:

-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;

The problem I find is that old userspace tools that still set the nfcache
bits create rules that cannot be match-deleted by newer versions of iptables,
because these bits are no longer set up in iptables but are still compared.
It seems there is no harm in removing this.  The second patch attached below
makes this change.

Thank you for considering these minor changes.

Best Regards!



--------------040803020800070308050604
Content-Type: text/plain;
 name="vestiges-of-NFC-in-extensions.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vestiges-of-NFC-in-extensions.patch"

diff -Naur iptables-1.3.8.orig/extensions/libip6t_connmark.c iptables-1.3.8/extensions/libip6t_connmark.c
--- iptables-1.3.8.orig/extensions/libip6t_connmark.c	2007-01-23 04:50:00.000000000 -0800
+++ iptables-1.3.8/extensions/libip6t_connmark.c	2007-08-24 17:30:35.000000000 -0700
@@ -48,8 +48,6 @@
 static void
 init(struct ip6t_entry_match *m, unsigned int *nfcache)
 {
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it
diff -Naur iptables-1.3.8.orig/extensions/libip6t_policy.c iptables-1.3.8/extensions/libip6t_policy.c
--- iptables-1.3.8.orig/extensions/libip6t_policy.c	2007-01-23 04:50:00.000000000 -0800
+++ iptables-1.3.8/extensions/libip6t_policy.c	2007-08-24 17:30:44.000000000 -0700
@@ -135,7 +135,6 @@
 
 static void init(struct ip6t_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static int parse_direction(char *s)
diff -Naur iptables-1.3.8.orig/extensions/libipt_connmark.c iptables-1.3.8/extensions/libipt_connmark.c
--- iptables-1.3.8.orig/extensions/libipt_connmark.c	2007-01-23 04:50:00.000000000 -0800
+++ iptables-1.3.8/extensions/libipt_connmark.c	2007-08-24 17:30:51.000000000 -0700
@@ -48,8 +48,6 @@
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
-	/* Can't cache this. */
-	*nfcache |= NFC_UNKNOWN;
 }
 
 /* Function which parses command options; returns true if it
diff -Naur iptables-1.3.8.orig/extensions/libipt_policy.c iptables-1.3.8/extensions/libipt_policy.c
--- iptables-1.3.8.orig/extensions/libipt_policy.c	2007-01-23 04:50:00.000000000 -0800
+++ iptables-1.3.8/extensions/libipt_policy.c	2007-08-24 17:31:01.000000000 -0700
@@ -95,7 +95,6 @@
 
 static void init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static int parse_direction(char *s)





--------------040803020800070308050604
Content-Type: text/plain;
 name="vestiges-of-NFC-in-is_same.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vestiges-of-NFC-in-is_same.patch"

diff -Naur iptables-1.3.8.orig/libiptc/libip4tc.c iptables-1.3.8/libiptc/libip4tc.c
--- iptables-1.3.8.orig/libiptc/libip4tc.c	2007-01-23 04:49:53.000000000 -0800
+++ iptables-1.3.8/libiptc/libip4tc.c	2007-08-24 17:54:47.000000000 -0700
@@ -204,8 +204,7 @@
 			return NULL;
 	}
 
-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;
 
diff -Naur iptables-1.3.8.orig/libiptc/libip6tc.c iptables-1.3.8/libiptc/libip6tc.c
--- iptables-1.3.8.orig/libiptc/libip6tc.c	2007-01-23 04:49:53.000000000 -0800
+++ iptables-1.3.8/libiptc/libip6tc.c	2007-08-24 17:54:37.000000000 -0700
@@ -236,8 +236,7 @@
 			return NULL;
 	}
 
-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;
 





--------------040803020800070308050604--
