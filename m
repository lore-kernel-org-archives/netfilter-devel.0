From: Rene Herman <rene.herman@keyaccess.nl>
Subject: [PATCH] ip_conntrack_irc, allowance for quoted filenames
Date: Mon, 12 May 2003 03:38:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBEFB08.4070903@keyaccess.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090708070001000807070502"
Cc: Rene Herman <rene.herman@keyaccess.nl>,
 Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------090708070001000807070502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Resend, this time _with_ patch ...

[ please keep me in CC, not subscribed ]

When the irssi (www.irssi.org) IRC client is asked to DCC SEND a file
with a filename containing spaces, it does so by leaving the spaces
intact and quoting the filename (""). ip_conntrack_irc.c:parse_dcc()
however can't handle the embedded spaces.

I haven't checked other clients but I assume they might do the same. Is
the attached hack (against 2.4.20) acceptable? Should this be solved
differently and/or elsewhere?

Rene.


--------------090708070001000807070502
Content-Type: text/plain;
 name="linux-2.4.20-ip_conntrack_irc.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.20-ip_conntrack_irc.diff"

--- linux-2.4.20/net/ipv4/netfilter/ip_conntrack_irc.c.orig	2002-12-01 02:32:52.000000000 +0100
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_irc.c	2003-05-12 02:10:01.000000000 +0200
@@ -82,6 +82,12 @@
 	ad_beg_p	returns pointer to first byte of addr data
 	ad_end_p	returns pointer to last byte of addr data */
 {
+	/* handle quoted arguments containing spaces */
+	if (*data == '"')
+		/* at least 14: "\" AAAAAAAA P\1\n" */
+		while (*++data != '"')
+			if (data > data_end - 14)
+				return -1;
 
 	/* at least 12: "AAAAAAAA P\1\n" */
 	while (*data++ != ' ')

--------------090708070001000807070502--
