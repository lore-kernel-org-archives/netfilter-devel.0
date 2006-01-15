From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] [LIBNFNETLINK] fixes
Date: Sun, 15 Jan 2006 15:35:41 +0100
Message-ID: <43CA5DBD.1010507@eurodev.net>
References: <43C9B94E.9040409@netfilter.org>
	<20060115094521.GG6740@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070802070006030702060304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060115094521.GG6740@sunbeam.de.gnumonks.org>
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
--------------070802070006030702060304
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
>>The patch attached fixes two issues in libnfnetlink:
>>
>>- subsys_id was not set in nfnl_subsys_open
>>- set nfnlh->local.nl_pid in nfnl_open since nfnl_talk checks that:
>>h->nlmsg_pid != nfnlh->local.nl_pid
> 
> unfortunately no patch attached...

:( sorry about that, patch attached.

>>Now the libnetfilter_conntrack test says OK again ;)
> 
> great. sorry for the breakage, but I hope you can appreciate the beauty
> of this new concept.  Being able to talk to all nfnetlink subsystems at
> the same time through one socket...

Sure, it's a nice rework. And it's really promising that now we can have
helpers in userspace, as Rusty dreamed in early stages :).

BTW, are we going to distribute the further application helpers
(implemented in userspace) separately or living somewhere in
libnetfilter_cthelper?

-- 
Pablo

--------------070802070006030702060304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revision 6411)
+++ src/libnfnetlink.c	(working copy)
@@ -16,6 +16,10 @@
  *
  * 2006-01-14 Harald Welte <laforge@netfilter.org>:
  * 	introduce nfnl_subsys_handle
+ *
+ * 2006-01-15 Pablo Neira Ayuso <pablo@netfilter.org>:
+ * 	set missing subsys_id in nfnl_subsys_open
+ * 	set missing nfnlh->local.nl_pid in nfnl_open
  */
 
 #include <stdlib.h>
@@ -152,6 +156,10 @@
 		goto err_close;
 	}
 	nfnlh->seq = time(NULL);
+	/*
+	 * nfnl_talk checks: h->nlmsg_pid != nfnlh->local.nl_pid
+	 */
+	nfnlh->local.nl_pid = getpid();
 
 	return nfnlh;
 
@@ -196,6 +204,7 @@
 	ssh->nfnlh = nfnlh;
 	ssh->cb_count = cb_count;
 	ssh->subscriptions = subscriptions;
+	ssh->subsys_id = subsys_id;
 
 	if (recalc_rebind_subscriptions(nfnlh) < 0) {
 		free(ssh->cb);

--------------070802070006030702060304--
