From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Note IRC helper limitation
Date: Tue, 5 Apr 2005 15:25:54 -0700
Message-ID: <20050405222554.GA8985@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
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


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

IRC helper does not handle spaces in filenames, and a fix for it
is non-trivial.  Note the limitation so people aren't surprised.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-irc

diff -ru linux-orig/net/ipv4/netfilter/Kconfig linux-new/net/ipv4/netfilter/Kconfig
--- linux-orig/net/ipv4/netfilter/Kconfig	2005-03-02 02:38:20.000000000 -0500
+++ linux-new/net/ipv4/netfilter/Kconfig	2005-04-05 18:22:29.883866472 -0400
@@ -73,6 +73,9 @@
 	  chats.  Note that you do NOT need this extension to get files or
 	  have others initiate chats, or everything else in IRC.
 
+	  Known limitation: DCC SEND filenames with spaces are not currently
+	  supported.
+
 	  To compile it as a module, choose M here.  If unsure, say Y.
 
 config IP_NF_TFTP

--lrZ03NoBR/3+SXJZ--
