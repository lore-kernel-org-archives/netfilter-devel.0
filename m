From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ip6tables multiport does not support x:y
Date: Sat, 1 Jul 2006 14:35:33 -0700
Message-ID: <20060701213533.GA28395@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
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


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Update the manpage for ip6tables multiport match to reflect
reality -- it does not (yet) support x:y syntax.  I looked at
adding it, but adding revision support to ip6tables seems a
waste at this point, since once xtables support is added to
iptables, this problem will resolve itself.

Closes bug #451.

Phil


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ip6tmultiport

diff -ru ipt-orig/extensions/libip6t_multiport.man ipt-new/extensions/libip6t_multiport.man
--- ipt-orig/extensions/libip6t_multiport.man	2006-01-30 00:50:09.000000000 -0800
+++ ipt-new/extensions/libip6t_multiport.man	2006-07-01 14:30:10.000000000 -0700
@@ -1,21 +1,20 @@
 This module matches a set of source or destination ports.  Up to 15
-ports can be specified.  A port range (port:port) counts as two
-ports, but range isn't supported now. It can only be used in conjunction
+ports can be specified.  It can only be used in conjunction
 with
 .B "-p tcp"
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+.BR "--source-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+.BR "--destination-ports " "\fI[!] port\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport:port\fP...]]"
+.BR "--ports " "\fI[!] port\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.

--qDbXVdCdHGoSgWSk--
