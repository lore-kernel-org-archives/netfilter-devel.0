From: Max Kellermann <max@duempel.org>
Subject: [PATCH nfsim] tcpsession: implement the RESET command
Date: Thu, 22 Sep 2005 10:24:04 +0200
Message-ID: <20050922082404.GC21617@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nmemrqcdn5VTmUEE"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I implemented a RESET command for the tcpsession command.  It can be
used to quickly purge TCP connections.

Max


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nfsim-tcpsession_reset.patch"

Thu Sep 15 00:06:48 CEST 2005  max@duempel.org
  * implemented tcpsession RESET
diff -rN -u old-nfsim-0/tools/tcpsession.c new-nfsim-0/tools/tcpsession.c
--- old-nfsim-0/tools/tcpsession.c	2005-09-22 10:25:35.000000000 +0200
+++ new-nfsim-0/tools/tcpsession.c	2005-09-22 10:11:23.000000000 +0200
@@ -248,6 +248,15 @@
 	return true;
 }
 
+static bool reset_session(struct tcp_endpoint *in, struct tcp_endpoint *out)
+{
+	if (!tcp_send(in, out, 0, "RST", NULL, 0, NULL))
+		return false;
+	talloc_free(curr);
+	curr = NULL;
+	return true;
+}
+
 static bool tcpsession(int argc, char *argv[])
 {
 	if (argc < 2) {
@@ -314,6 +323,20 @@
 		if (streq(argv[2], "reply"))
 			return close_session(&curr->reply, &curr->original);
 	}
+	if (streq(argv[1], "RESET")) {
+		if (!curr) {
+			nfsim_log(LOG_ALWAYS, "Session not open!");
+			return false;
+		}
+		if (argc != 3) {
+			tcpsession_help(argc, argv);
+			return false;
+		}
+		if (streq(argv[2], "original"))
+			return reset_session(&curr->original, &curr->reply);
+		if (streq(argv[2], "reply"))
+			return reset_session(&curr->reply, &curr->original);
+	}
 	if (streq(argv[1], "ABANDON")) {
 		if (!curr) {
 			nfsim_log(LOG_ALWAYS, "Session not open!");


--nmemrqcdn5VTmUEE--
