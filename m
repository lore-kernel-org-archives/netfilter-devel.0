From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH] complete nfnl_talk
Date: Mon, 02 Jun 2003 20:39:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EDB99E2.8050100@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000100010000020309010508"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000100010000020309010508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this patch completes nfnl_talk and removes a couple
of compiler warnings.

Best regards,
Patrick

--------------000100010000020309010508
Content-Type: text/plain;
 name="libnfnetlink-nfnl_talk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnfnetlink-nfnl_talk.diff"

? ChangeLog
Index: iptables2/libctnetlink/libctnetlink.c
===================================================================
RCS file: /cvspublic/netfilter/iptables2/libctnetlink/libctnetlink.c,v
retrieving revision 1.3
diff -u -r1.3 libctnetlink.c
--- iptables2/libctnetlink/libctnetlink.c	8 Aug 2002 10:27:46 -0000	1.3
+++ iptables2/libctnetlink/libctnetlink.c	2 Jun 2003 18:37:18 -0000
@@ -34,7 +34,7 @@
 #include "libctnetlink.h"
 
 #define ctnl_error(format, args...) \
-	fprintf(stderr, __FUNCTION__ ": " format, ## args)
+	fprintf(stderr, "%s: " format, __FUNCTION__, ## args)
 
 /***********************************************************************
  * low level stuff 
Index: iptables2/libnfnetlink/libnfnetlink.c
===================================================================
RCS file: /cvspublic/netfilter/iptables2/libnfnetlink/libnfnetlink.c,v
retrieving revision 1.2
diff -u -r1.2 libnfnetlink.c
--- iptables2/libnfnetlink/libnfnetlink.c	2 Aug 2002 08:17:18 -0000	1.2
+++ iptables2/libnfnetlink/libnfnetlink.c	2 Jun 2003 18:37:18 -0000
@@ -21,7 +21,7 @@
 #include "libnfnetlink.h"
 
 #define nfnl_error(format, args...) \
-	fprintf(stderr, __FUNCTION__ ": " format "\n", ## args)
+	fprintf(stderr, "%s: " format "\n", __FUNCTION__, ## args)
 
 #ifdef _NFNL_DEBUG
 #define nfnl_debug_dump_packet nfnl_dump_packet
@@ -35,7 +35,7 @@
 	struct nfattr *nfa = NFM_NFA(NLMSG_DATA(nlh));
 	int len = NFM_PAYLOAD(nlh);
 
-	printf(__FUNCTION__ " called from %s\n", desc);
+	printf("%s called from %s\n", __FUNCTION__, desc);
 	printf("  nlmsghdr = %p, received_len = %u\n", nlh, received_len);
 	printf("  NLMSG_DATA(nlh) = %p (+%u bytes)\n", nlmsg_data,
 	       (nlmsg_data - (void *)nlh));
@@ -250,13 +250,12 @@
 	return 0;
 }
 
-#if 0
 int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
 	      unsigned groups, struct nlmsghdr *answer,
 	      int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
 	      void *jarg)
 {
-	char buf[CTNL_BUFFSIZE];
+	char buf[NFNL_BUFFSIZE];
 	struct sockaddr_nl nladdr;
 	struct nlmsghdr *h;
 	unsigned int seq;
@@ -307,15 +306,65 @@
 			return -1;
 		}
 
-		for (h = (struct nlmsghdr *)buf; status >= sizeof(*h)) {
+		for (h = (struct nlmsghdr *)buf; status >= sizeof(*h); ) {
 			int len = h->nlmsg_len;
 			int l = len - sizeof(*h);
 			int err;
 
-				
+			if (l < 0 || len > status) {
+				if (msg.msg_flags & MSG_TRUNC) {
+					nfnl_error("Truncated message\n");
+					return -1;
+				}
+				nfnl_error("Malformed message: len=%d\n", len);
+				return -1; /* FIXME: libnetlink exits here */
+			}
+
+			if (h->nlmsg_pid != nfnlh->local.nl_pid ||
+			    h->nlmsg_seq != seq) {
+				if (junk) {
+					err = junk(&nladdr, h, jarg);
+					if (err < 0)
+						return err;
+				}
+				continue;
+			}
 
+			if (h->nlmsg_type == NLMSG_ERROR) {
+				struct nlmsgerr *err = NLMSG_DATA(h);
+				if (l < sizeof(struct nlmsgerr))
+					nfnl_error("ERROR truncated\n");
+				else {
+					errno = -err->error;
+					if (errno == 0) {
+						if (answer)
+							memcpy(answer, h, h->nlmsg_len);
+						return 0;
+					}
+					perror("CTNETLINK answers");
+				}
+				return -1;
+			}
+			if (answer) {
+				memcpy(answer, h, h->nlmsg_len);
+				return 0;
+			}
+
+			nfnl_error("Unexpected reply!\n");
+
+			status -= NLMSG_ALIGN(len);
+			h = (struct nlmsghdr *)((char *)h + NLMSG_ALIGN(len));
+		}
+		if (msg.msg_flags & MSG_TRUNC) {
+			nfnl_error("Messages truncated\n");
+			continue;
+		}
+		if (status) {
+			nfnl_error("Remnant of size %d\n", status);
+			exit(1);
+		}
+	}
 }
-#endif
 
 /**
  * nfnl_addattr_l - Add variable length attribute to nlmsghdr

--------------000100010000020309010508--
