From: Pablo Neira <pablo@eurodev.net>
Subject: [IPTABLES PATCH] Fix leak in merge_opts
Date: Sat, 07 May 2005 16:26:08 +0200
Message-ID: <427CD000.40002@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060203040707090208030402"
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
--------------060203040707090208030402
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

The function merge_opts doesn't release previously merged options, this 
results in a memory leak. This increases considerably memory comsumption 
in iptables-restore.

This patch fixes a leak on error paths as well.

Results: With my testcase ruleset of ~10.000 rules and this patch, 
iptables-restore reduces memory consumption by 66 percent. It's passed 
from eating ~12 Mbytes to ~4 Mbytes. This can be interesting for 
embedded devices running iptables.

--
Pablo

--------------060203040707090208030402
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: iptables.c
===================================================================
--- iptables.c	(revision 3889)
+++ iptables.c	(working copy)
@@ -306,6 +306,16 @@
 	dst->s_addr = src->s_addr;
 }
 
+static void free_opts(int reset_offset)
+{
+	if (opts != original_opts) {
+		free(opts);
+		opts = original_opts;
+		if (reset_offset)
+			global_option_offset = 0;
+	}
+}
+
 void
 exit_error(enum exittype status, char *msg, ...)
 {
@@ -321,6 +331,8 @@
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps iptables or your kernel needs to be upgraded.\n");
+	/* On error paths, make sure that we don't leak memory */
+	free_opts(1);
 	exit(status);
 }
 
@@ -331,6 +343,7 @@
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
+	free_opts(1);
 	exit(status);
 }
 
@@ -1016,6 +1029,9 @@
 	unsigned int num_old, num_new, i;
 	struct option *merge;
 
+	/* Release previous options merged if any */
+	free_opts(0);
+	
 	for (num_old = 0; oldopts[num_old].name; num_old++);
 	for (num_new = 0; newopts[num_new].name; num_new++);
 
@@ -2443,12 +2459,7 @@
 
 	free(saddrs);
 	free(daddrs);
+	free_opts(1);
 
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		global_option_offset = 0;
-	}
-
 	return ret;
 }
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 3889)
+++ ip6tables.c	(working copy)
@@ -252,6 +252,16 @@
 	/* dst->s6_addr = src->s6_addr; */
 }
 
+static void free_opts(int reset_offset)
+{
+	if (opts != original_opts) {
+		free(opts);
+		opts = original_opts;
+		if (reset_offset)
+			global_option_offset = 0;
+	}
+}
+
 void
 exit_error(enum exittype status, char *msg, ...)
 {
@@ -267,6 +277,8 @@
 	if (status == VERSION_PROBLEM)
 		fprintf(stderr,
 			"Perhaps ip6tables or your kernel needs to be upgraded.\n");
+	/* On error paths, make sure that we don't leak memory */
+	free_opts(1);
 	exit(status);
 }
 
@@ -277,6 +289,7 @@
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
+	free_opts(1);
 	exit(status);
 }
 
@@ -1016,6 +1029,9 @@
 	unsigned int num_old, num_new, i;
 	struct option *merge;
 
+	/* Release previous options merged if any */
+	free_opts(0);
+
 	for (num_old = 0; oldopts[num_old].name; num_old++);
 	for (num_new = 0; newopts[num_new].name; num_new++);
 
@@ -2336,11 +2352,7 @@
 	for (c = 0; c < ndaddrs; c++)
 		free(&daddrs[c]);
 
-	if (opts != original_opts) {
-		free(opts);
-		opts = original_opts;
-		global_option_offset = 0;
-	}
+	free_opts(1);
 
 	return ret;
 }

--------------060203040707090208030402--
