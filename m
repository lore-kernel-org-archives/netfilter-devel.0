From: Sebastian Hagen <sebastian_hagen@memespace.net>
Subject: Re: libnetfilter_conntrack checks for (getuid() == 0)
Date: Tue, 15 Aug 2006 19:45:20 +0200
Message-ID: <44E20830.6090402@memespace.net>
References: <44E1FFF7.2010103@memespace.net> <44E20094.8080309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070405040109010609060405"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44E20094.8080309@trash.net>
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
--------------070405040109010609060405
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Please send a patch.
Done, and attached to this mail.

Sebastian Hagen

--------------070405040109010609060405
Content-Type: text/x-patch;
 name="libnetfilter_conntrack_getuid.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnetfilter_conntrack_getuid.patch"

--- libnetfilter_conntrack/src/libnetfilter_conntrack.c	2006-05-24 19:39:29.000000000 +0200
+++ libnetfilter_conntrack_patched/src/libnetfilter_conntrack.c	2006-08-15 19:41:25.000000000 +0200
@@ -1125,12 +1125,6 @@
 
 int nfct_event_conntrack(struct nfct_handle *cth)
 {
-	/*
-	 * You need to be root to listen to conntrack events
-	 */
-	if (getuid() != 0)
-		return -EPERM;
-	
 	cth->handler = nfct_conntrack_netlink_handler;
 	return nfnl_listen(cth->nfnlh, &callback_handler, cth);
 }
@@ -1298,12 +1292,6 @@
 
 int nfct_event_expectation(struct nfct_handle *cth)
 {
-	/*
-	 * You need to be root to listen to conntrack events
-	 */
-	if (getuid() != 0)
-		return -EPERM;
-
 	cth->handler = nfct_expect_netlink_handler;
 	return nfnl_listen(cth->nfnlh, &callback_handler, cth);
 }

--------------070405040109010609060405--
