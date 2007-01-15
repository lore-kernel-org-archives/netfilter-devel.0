From: esr@thyrsus.com
Subject: problems in iptables.8
Date: Mon, 15 Jan 2007 17:06:19 -0500
Message-ID: <200701152206.l0FM6Jv4016138@snark.thyrsus.com>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is automatically generated email about problems in a man page for which
you appear to be responsible.  If you are not the right person or list, tell
me and I will attempt to correct my database.

See http://catb.org/~esr/doclifter/problems.html for details on how and
why these patches were generated.  Feel free to email me with any questions.
Note: These patches do not change the mod date of any manual page.  You
may wish to do that by hand.

Problems with iptables.8:

1. Ambiguous or invalid backslash.  This doesn't cause groff a problem.
but it confuses doclifter and may confuse older troff implementations.

--- iptables.8-orig	2007-01-14 21:38:58.000000000 -0500
+++ iptables.8	2007-01-14 21:39:16.000000000 -0500
@@ -649,7 +649,7 @@
 list of packet types.  Packet types are: 
 .BR "REQUEST RESPONSE DATA ACK DATAACK CLOSEREQ CLOSE RESET SYNC SYNCACK INVALID" .
 .TP
-\fB--dccp-option\fR [\fB!\fR\] \fInumber\fP
+\fB--dccp-option\fR [\fB!\fR] \fInumber\fP
 Match if DCP option set.
 .SS dscp
 This module matches the 6 bit DSCP field within the TOS field in the
-----------------------------

--
                             Eric S. Raymond
