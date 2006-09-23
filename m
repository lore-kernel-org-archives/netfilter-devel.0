From: Denis Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH] fix dreaded "Unknown error 4294967295"
Date: Sat, 23 Sep 2006 13:43:32 +0200
Message-ID: <200609231343.32610.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_k3RFFQixcEc9F/9"
To: netfilter-devel@lists.netfilter.org, kaber@netfilter.org,
	webmaster@gnumonks.org
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

--Boundary-00=_k3RFFQixcEc9F/9
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

google.com gives 968 hits on 'iptables "Unknown error 4294967295"'.

The reason is that iptables sets errno
to error return value of setsockopt(), which is always -1.

A few small inrelated changes are also there:
stray ')' in message, array of error messages made static,
prevention of errno corruption in ipq_perror.
--
vda

--Boundary-00=_k3RFFQixcEc9F/9
Content-Type: text/x-diff; charset="us-ascii"; name="iptables-1.3.5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iptables-1.3.5.patch"

diff -urpN iptables-1.3.5.0/libipq/libipq.c iptables-1.3.5.1/libipq/libipq.c
--- iptables-1.3.5.0/libipq/libipq.c	2005-07-28 16:53:11.000000000 +0200
+++ iptables-1.3.5.1/libipq/libipq.c	2006-09-21 22:12:41.000000000 +0200
@@ -366,13 +366,14 @@ char *ipq_errstr(void)
 
 void ipq_perror(const char *s)
 {
+	int e = errno;
 	if (s)
 		fputs(s, stderr);
 	else
 		fputs("ERROR", stderr);
 	if (ipq_errno)
 		fprintf(stderr, ": %s", ipq_errstr());
-	if (errno)
-		fprintf(stderr, ": %s", strerror(errno));
+	if (e)
+		fprintf(stderr, ": %s", strerror(e));
 	fputc('\n', stderr);
 }
diff -urpN iptables-1.3.5.0/libiptc/libiptc.c iptables-1.3.5.1/libiptc/libiptc.c
--- iptables-1.3.5.0/libiptc/libiptc.c	2006-01-30 09:43:09.000000000 +0100
+++ iptables-1.3.5.1/libiptc/libiptc.c	2006-09-21 23:22:33.000000000 +0200
@@ -1118,7 +1118,7 @@ const char *standard_target_map(int verd
 			return LABEL_QUEUE;
 			break;
 		default:
-			fprintf(stderr, "ERROR: %d not a valid target)\n",
+			fprintf(stderr, "ERROR: %d not a valid target\n",
 				verdict);
 			abort();
 			break;
@@ -2097,7 +2097,7 @@ TC_COMMIT(TC_HANDLE_T *handle)
 	ret = setsockopt(sockfd, TC_IPPROTO, SO_SET_REPLACE, repl,
 			 sizeof(*repl) + repl->size);
 	if (ret < 0) {
-		errno = ret;
+		/* errno = ret; */
 		goto out_free_newcounters;
 	}
 
@@ -2191,7 +2191,7 @@ TC_COMMIT(TC_HANDLE_T *handle)
 	ret = setsockopt(sockfd, TC_IPPROTO, SO_SET_ADD_COUNTERS,
 			 newcounters, counterlen);
 	if (ret < 0) {
-		errno = ret;
+		/* errno = ret; */
 		goto out_free_newcounters;
 	}
 
@@ -2225,7 +2225,7 @@ const char *
 TC_STRERROR(int err)
 {
 	unsigned int i;
-	struct table_struct {
+	static const struct table_struct {
 		void *fn;
 		int err;
 		const char *message;

--Boundary-00=_k3RFFQixcEc9F/9--
