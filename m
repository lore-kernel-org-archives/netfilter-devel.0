From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 4/*] libnfnetlink fixes
Date: Mon, 12 Sep 2005 09:03:25 +0100
Message-ID: <4325364D.8030406@ufomechanic.net>
References: <42D429F9.7000707@eurodev.net> <42D4CF9C.2000304@ufomechanic.net>
	<20050828115013.GE4244@rama.de.gnumonks.org>
	<431879F6.5020505@ufomechanic.net>
	<20050910090908.GD4314@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080305000006020402040007"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050910090908.GD4314@rama.de.gnumonks.org>
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
--------------080305000006020402040007
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Harald Welte wrote:

>On Fri, Sep 02, 2005 at 05:12:38PM +0100, Amin Azez wrote:
>  
>
>>Harald Welte wrote:
>>
>>    
>>
>>>On Wed, Jul 13, 2005 at 09:23:56AM +0100, Amin Azez wrote:
>>>
>>> 
>>>
>>>I think this change is fine.  Would you mind to re-submit the patch
>>>against current svn?  Please also document the meaning of the return
>>>values, probably with a comment in the code or the header file?
>>>
>>> 
>>>
>>>      
>>>
>>Will do (Monday)
>>
>>thanks for the feedback.
>>    
>>
>
>I haven't received an updated patch so far. Did I miss it somehow?
>
>  
>
err... you must have, I sent it on 5th Sept.

Attached again.

Azez


--------------080305000006020402040007
Content-Type: text/x-patch;
 name="libnfnetlink.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnfnetlink.c.diff"

Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revision 4254)
+++ src/libnfnetlink.c	(working copy)
@@ -257,6 +257,16 @@
  *
  * nfnhl: libnfnetlink handle
  * handler: callback function to be called for every netlink message
+ *          - the callback handler should normally return 0
+ *          - but may return a negative error code which will cause
+ *            nfnl_listen to return immediately with the same error code
+ *          - or return a postivie error code which will cause 
+ *            nfnl_listen to return after it has finished processing all
+ *            the netlink messages in the current packet
+ *          Thus a positive error code will terminate nfnl_listen "soon"
+ *          without any loss of data, a negative error code will terminate
+ *          nfnl_listen "very soon" and throw away data already read from
+ *          the netlink socket.
  * jarg: opaque argument passed on to callback
  *
  */
@@ -270,6 +280,7 @@
 	int remain;
 	struct nlmsghdr *h;
 	struct nlmsgerr *msgerr;
+	int quit=0;
 
 	struct msghdr msg = {
 		(void *)&nladdr, sizeof(nladdr),
@@ -283,7 +294,7 @@
 	iov.iov_base = buf;
 	iov.iov_len = sizeof(buf);
 
-	while (1) {
+	while (! quit) {
 		remain = recvmsg(nfnlh->fd, &msg, 0);
 		if (remain < 0) {
 			if (errno == EINTR)
@@ -332,6 +343,7 @@
 			err = handler(&nladdr, h, jarg);
 			if (err < 0)
 				return err;
+			quit |= err;
 		
 			/* FIXME: why not _NEXT macros, etc.? */
 			//h = NLMSG_NEXT(h, remain);
@@ -348,7 +360,7 @@
 		}
 	}
 
-	return 0;
+	return quit;
 }
 
 int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,

--------------080305000006020402040007--
