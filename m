From: Derrik Pates <demon@devrandom.net>
Subject: Patch to libiptc
Date: Sat, 22 Jan 2005 19:28:49 -0500
Message-ID: <41F2EFC1.2050904@devrandom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000809010004050904060204"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------000809010004050904060204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

All:

The attached patch fixes a few minor issues in libiptc. These changes 
are as follows:

   - Sets the 'iptc_fn' global variable to the pointer to the current 
functions in all major TC_* functions. This is necessary because in 
certain cases, an error return from a function that doesn't set 
'iptc_fn' will conflict with a function-specific error return from one 
that does, causing TC_STRERROR() to return the wrong error string. This 
ensures that the right one will be returned.
   - Implements a simple reference counter for the netlink socket global 
variable 'sockfd'; this is necessary for IPTables::IPv4, where multiple 
tables (filter, nat, mangle, untracked) may be opened at one time. The 
way libiptc does it in the official version causes previously-opened 
tables to break such that attempts to commit changes will fail.
   - Adds a couple of memset() invocations in TC_COMMIT, based on past 
analysis with valgrind. It claimed that allocated structure were not 
being fully initialized, and adding the memset()s corrected this warning.

It is against the current version in the Subversion repository. It only 
changes libiptc/libiptc.c.

-- 
Derrik Pates
demon@devrandom.net

--------------000809010004050904060204
Content-Type: text/x-patch;
 name="libiptc-fixes.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libiptc-fixes.diff"

--- iptables/libiptc/libiptc.c.stock	2005-01-22 12:45:11.981755400 -0500
+++ iptables/libiptc/libiptc.c	2005-01-22 17:01:08.257590648 -0500
@@ -45,6 +45,7 @@
 #endif
 
 static int sockfd = -1;
+static int sockfd_use = 0;
 static void *iptc_fn = NULL;
 
 static const char *hooknames[]
@@ -788,33 +789,38 @@
 
 	iptc_fn = TC_INIT;
 
-	if (sockfd != -1) {
-		close(sockfd);
-		sockfd = -1;
-	}
-
 	if (strlen(tablename) >= TABLE_MAXNAMELEN) {
 		errno = EINVAL;
 		return NULL;
 	}
 	
-	sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
-	if (sockfd < 0)
-		return NULL;
+	if (sockfd_use == 0) {
+		sockfd = socket(TC_AF, SOCK_RAW, IPPROTO_RAW);
+		if (sockfd < 0)
+			return NULL;
+	}
+	sockfd_use++;
 
 	s = sizeof(info);
 
 	strcpy(info.name, tablename);
-	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info, &s) < 0)
+	if (getsockopt(sockfd, TC_IPPROTO, SO_GET_INFO, &info, &s) < 0) {
+		if (--sockfd_use == 0) {
+			close(sockfd);
+			sockfd = -1;
+		}
 		return NULL;
+	}
 
 	DEBUGP("valid_hooks=0x%08x, num_entries=%u, size=%u\n",
 		info.valid_hooks, info.num_entries, info.size);
 
 	if ((h = alloc_handle(info.name, info.size, info.num_entries))
 	    == NULL) {
-		close(sockfd);
-		sockfd = -1;
+		if (--sockfd_use == 0) {
+			close(sockfd);
+			sockfd = -1;
+		}
 		return NULL;
 	}
 
@@ -846,6 +852,10 @@
 	CHECK(h);
 	return h;
 error:
+	if (--sockfd_use == 0) {
+		close(sockfd);
+		sockfd = -1;
+	}
 	TC_FREE(&h);
 	return NULL;
 }
@@ -855,8 +865,11 @@
 {
 	struct chain_head *c, *tmp;
 
-	close(sockfd);
-	sockfd = -1;
+	iptc_fn = TC_FREE;
+	if (--sockfd_use == 0) {
+		close(sockfd);
+		sockfd = -1;
+	}
 
 	list_for_each_entry_safe(c, tmp, &(*h)->chains, list) {
 		struct rule_head *r, *rtmp;
@@ -886,6 +899,7 @@
 void
 TC_DUMP_ENTRIES(const TC_HANDLE_T handle)
 {
+	iptc_fn = TC_DUMP_ENTRIES;
 	CHECK(handle);
 #if 0
 	printf("libiptc v%s. %u bytes.\n",
@@ -912,6 +926,7 @@
 /* Does this chain exist? */
 int TC_IS_CHAIN(const char *chain, const TC_HANDLE_T handle)
 {
+	iptc_fn = TC_IS_CHAIN;
 	return iptcc_find_label(chain, handle) != NULL;
 }
 
@@ -1003,6 +1018,7 @@
 {
 	struct rule_head *r;
 
+	iptc_fn = TC_NEXT_RULE;
 	DEBUGP("rule_iterator_cur=%p...", (*handle)->rule_iterator_cur);
 
 	if (!(*handle)->rule_iterator_cur) {
@@ -1576,6 +1592,7 @@
 		STRUCT_ENTRY *entry,
 		TC_HANDLE_T *handle)
 {
+	iptc_fn = TC_CHECK_PACKET;
 	errno = ENOSYS;
 	return NULL;
 }
@@ -1611,6 +1628,7 @@
 	struct chain_head *c;
 	struct rule_head *r;
 
+	iptc_fn = TC_ZERO_ENTRIES;
 	if (!(c = iptcc_find_label(chain, *handle))) {
 		errno = ENOENT;
 		return 0;
@@ -1763,6 +1781,7 @@
 {
 	struct chain_head *c;
 
+	iptc_fn = TC_GET_REFERENCES;
 	if (!(c = iptcc_find_label(chain, *handle))) {
 		errno = ENOENT;
 		return 0;
@@ -1991,6 +2010,7 @@
 	int new_number;
 	unsigned int new_size;
 
+	iptc_fn = TC_COMMIT;
 	CHECK(*handle);
 
 	/* Don't commit if nothing changed. */
@@ -2016,6 +2036,7 @@
 
 	counterlen = sizeof(STRUCT_COUNTERS_INFO)
 			+ sizeof(STRUCT_COUNTERS) * new_number;
+	memset(repl, 0, sizeof(*repl) + (*handle)->entries->size);
 
 	/* These are the old counters we will get from kernel */
 	repl->counters = malloc(sizeof(STRUCT_COUNTERS)
@@ -2025,6 +2046,8 @@
 		errno = ENOMEM;
 		return 0;
 	}
+	memset(repl->counters, 0, sizeof(STRUCT_COUNTERS)
+			* (*handle)->info.num_entries);
 	/* These are the counters we're going to put back, later. */
 	newcounters = malloc(counterlen);
 	if (!newcounters) {

--------------000809010004050904060204--
