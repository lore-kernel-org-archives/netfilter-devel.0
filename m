From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH NFSIM]: use unsigned long for nf_userspace_message args
Date: Thu, 06 Jan 2005 15:10:46 +0100
Message-ID: <41DD46E6.8040108@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010407060900080305060904"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
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
--------------010407060900080305060904
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

nf_userspace_message args may hold pointers, use unsigned long so they
also fit on 64 bit.



--------------010407060900080305060904
Content-Type: text/x-patch;
 name="2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.diff"

Index: core/fakesockopt.c
===================================================================
--- core/fakesockopt.c	(revision 3578)
+++ core/fakesockopt.c	(working copy)
@@ -234,8 +234,8 @@
 	msg.args[0] = PF_INET;
 	/*msg.args[1] = level;*/
 	msg.args[1] = optname;
-	msg.args[2] = (int)optval;
-	msg.args[3] = (int)*optlen;
+	msg.args[2] = (unsigned long)optval;
+	msg.args[3] = (unsigned long)*optlen;
 	ret = fake_syscall(&msg);
 	*optlen = msg.args[3];
 	return ret;
@@ -249,8 +249,8 @@
 	msg.args[0] = PF_INET;
 	/*msg.args[1] = level;*/
 	msg.args[1] = optname;
-	msg.args[2] = (int)optval;
-	msg.args[3] = (int)optlen;
+	msg.args[2] = (unsigned long)optval;
+	msg.args[3] = (unsigned long)optlen;
 	return fake_syscall(&msg);
 }
 
Index: core/nfsockopt.h
===================================================================
--- core/nfsockopt.h	(revision 3578)
+++ core/nfsockopt.h	(working copy)
@@ -45,7 +45,7 @@
 	int len;
 
 	/* syscall/kernelop arguments */
-	int args[MAX_MESSAGE_ARGS];
+	unsigned long args[MAX_MESSAGE_ARGS];
 
 	/* return val of the syscall/kernelop */
 	int retval;
Index: core/message.c
===================================================================
--- core/message.c	(revision 3578)
+++ core/message.c	(working copy)
@@ -282,7 +282,7 @@
 					  msg.args[3]);
 			msg.retval = nf_getsockopt(NULL, msg.args[0],
 					msg.args[1], (char *)msg.args[2],
-					&msg.args[3]);
+					(int *)&msg.args[3]);
 			if (strace)
 				nfsim_log(LOG_USERSPACE,
 					  "    getsockopt -> %s (len %i)",
@@ -358,9 +358,9 @@
 	msg->type = UM_KERNELOP;
 	msg->opcode = KOP_COPY_TO_USER;
 	msg->len = n;
-	msg->args[0] = (int)to;
-	msg->args[1] = (int)from;
-	msg->args[2] = (int)n;
+	msg->args[0] = (unsigned long)to;
+	msg->args[1] = (unsigned long)from;
+	msg->args[2] = (unsigned long)n;
 
 	/* Keep valgrind happy.*/
 	msg->args[3] = 0;
@@ -393,9 +393,9 @@
 	msg.type = UM_KERNELOP;
 	msg.opcode = KOP_COPY_FROM_USER;
 	msg.len = 0;
-	msg.args[0] = (int)to;
-	msg.args[1] = (int)from;
-	msg.args[2] = (int)n;
+	msg.args[0] = (unsigned long)to;
+	msg.args[1] = (unsigned long)from;
+	msg.args[2] = (unsigned long)n;
 
 	/* Keep valgrind happy.*/
 	msg.args[3] = 0;
Index: core/core.c
===================================================================
--- core/core.c	(revision 3578)
+++ core/core.c	(working copy)
@@ -431,7 +431,7 @@
 		oldpath = getenv("LD_LIBRARY_PATH");
 		path = talloc_asprintf(NULL, "%s%s%.*s",
 				       oldpath ?:"", oldpath ? ":" : "",
-				       p - argv[0], argv[0]);
+				       (int)(p - argv[0]), argv[0]);
 		setenv("LD_LIBRARY_PATH", path, 1);
 		talloc_free(path);
 	}

--------------010407060900080305060904--
