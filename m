From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] update multiport manpage
Date: Wed, 18 May 2005 16:38:08 -0700
Message-ID: <20050518233808.GA14638@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
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


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Since 1.3.2 is hopefully around the corner (hint,hint) the multiport
manpage should be updated to reflect reality.

Phil



--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-multiportman

diff -ru iptables-1.3.1/extensions/libip6t_multiport.man iptables-new/extensions/libip6t_multiport.man
--- iptables-1.3.1/extensions/libip6t_multiport.man	2004-10-10 02:56:24.000000000 -0700
+++ iptables-new/extensions/libip6t_multiport.man	2005-05-18 16:36:27.000000000 -0700
@@ -1,19 +1,20 @@
 This module matches a set of source or destination ports.  Up to 15
-ports can be specified.  It can only be used in conjunction with
+ports can be specified.  A port range (port:port) counts as two
+ports.  It can only be used in conjunction with
 .B "-p tcp"
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.
diff -ru iptables-1.3.1/extensions/libipt_multiport.man iptables-new/extensions/libipt_multiport.man
--- iptables-1.3.1/extensions/libipt_multiport.man	2004-10-10 02:56:26.000000000 -0700
+++ iptables-new/extensions/libipt_multiport.man	2005-05-18 16:36:19.000000000 -0700
@@ -1,19 +1,20 @@
 This module matches a set of source or destination ports.  Up to 15
-ports can be specified.  It can only be used in conjunction with
+ports can be specified.  A port range (port:port) counts as two
+ports.  It can only be used in conjunction with
 .B "-p tcp"
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.

--6TrnltStXW4iwmi0--
