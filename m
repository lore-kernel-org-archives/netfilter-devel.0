From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 4/*] libnfnetlink fixes
Date: Wed, 13 Jul 2005 09:23:56 +0100
Message-ID: <42D4CF9C.2000304@ufomechanic.net>
References: <42D429F9.7000707@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000507010206050905060106"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42D429F9.7000707@eurodev.net>
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
--------------000507010206050905060106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is a patch I propose for libnfnetlink.c

It allows the application-supplied callback handler to signifiy in its
return code whether or not the nfnl_listen read-loop should terminate.

If the handler returns a negative code, then nfnl_listen returns
immediately with the same return code.

If the handler returns a postitive code, then nfnl_listen returns at the
next iteration of the while loop, which is when it finishes handing all
netlink messages in the current packet.

This avois the need to duplicate most of nfnl_listen in a non-loop
context where the application needs control over the read and packet
decode process.

I use it to break out of the loop when a signal handler sets a flag,
once the loop has broken I then do some per-signal processing and
re-enter the loop.

Sam


--------------000507010206050905060106
Content-Type: text/x-patch;
 name="libnfnetlink.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnfnetlink.c.diff"

Index: /opt/KERNEL/SVN/libnfnetlink/libnfnetlink.c
===================================================================
--- /opt/KERNEL/SVN/libnfnetlink/libnfnetlink.c	(revision 3897)
+++ /opt/KERNEL/SVN/libnfnetlink/libnfnetlink.c	(working copy)
@@ -184,6 +193,7 @@
 	int remain;
 	struct nlmsghdr *h;
 	struct nlmsgerr *msgerr;
+	int quit=0;
 
 	struct msghdr msg = {
 		(void *)&nladdr, sizeof(nladdr),
@@ -197,7 +207,7 @@
 	iov.iov_base = buf;
 	iov.iov_len = sizeof(buf);
 
-	while (1) {
+	while (! quit) {
 		remain = recvmsg(nfnlh->fd, &msg, 0);
 		if (remain < 0) {
 			if (errno == EINTR)
@@ -243,6 +253,7 @@
 			err = handler(&nladdr, h, jarg);
 			if (err < 0)
 				return err;
+			quit |= err;
 		
 			/* FIXME: why not _NEXT macros, etc.? */
 			//h = NLMSG_NEXT(h, remain);
@@ -259,7 +270,7 @@
 		}
 	}
 
-	return 0;
+	return quit;
 }
 
 int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,

--------------000507010206050905060106--
