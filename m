From: Michael Rash <mbr@cipherdyne.org>
Subject: [PATCH] Trivial space char fix for --log-prefix
Date: Mon, 8 Dec 2003 04:45:57 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031208094557.GA16116@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello -

This patch adds a space character to the --log-prefix string if the
user did not have it already.  This prevents the "IN=" field in
iptables log messages from being obscured by a --log-prefix that
doesn't have a space.

(Resending this since my original post did not seem to make it
through).

--Mike

Michael Rash
http://www.cipherdyne.org
Key fingerprint = 53EA 13EA 472E 3771 894F  AC69 95D8 5D6B A742 839F



diff -u -r1.14 libipt_LOG.c
--- libipt_LOG.c	11 Aug 2003 19:58:56 -0000	1.14
+++ libipt_LOG.c	5 Dec 2003 07:15:45 -0000
@@ -107,6 +107,7 @@
       struct ipt_entry_target **target)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
+	unsigned short int addspc_f = 0, prefix_len = 0;
 
 	switch (c) {
 	case '!':
@@ -131,12 +132,21 @@
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
-		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
+		prefix_len = strlen(optarg);
+		if (optarg[strlen(optarg)-1] != ' ') {
+			/* we need to add a space */
+			addspc_f = 1;
+			prefix_len++;
+		}
+
+		if (prefix_len > sizeof(loginfo->prefix) - 1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Maximum prefix length %u for --log-prefix",
 				   sizeof(loginfo->prefix) - 1);
 
 		strcpy(loginfo->prefix, optarg);
+		if (addspc_f)
+			loginfo->prefix[prefix_len-1] = ' ';
 		*flags |= IPT_LOG_OPT_PREFIX;
 		break;
