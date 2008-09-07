From: Jan Engelhardt <jengelh@medozas.de>
Subject: doc: remove mentions of NAT in ip6tables manpage
Date: Sun, 7 Sep 2008 15:44:49 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809071544360.16247@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37036 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYIGTow (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 15:44:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8a260b2683132291c7e690e1c352ee38307903be
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Sep 7 15:32:29 2008 -0400

doc: remove mentions of NAT in ip6tables manpage

ip6tables does not support NAT at this time.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.8.in |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/ip6tables.8.in b/ip6tables.8.in
index 7142b4a..669a961 100644
--- a/ip6tables.8.in
+++ b/ip6tables.8.in
@@ -156,10 +156,8 @@ fail.  Rules are numbered starting at 1.
 \fB-L\fP, \fB--list\fP [\fIchain\fP]
 List all rules in the selected chain.  If no chain is selected, all
 chains are listed. Like every other ip6tables command, it applies to the
-specified table (filter is the default), so NAT rules get listed by
-.nf
- ip6tables -t nat -n -L
-.fi
+specified table (filter is the default).
+.IP ""
 Please note that it is often used with the \fB-n\fP
 option, in order to avoid long reverse DNS lookups.
 It is legal to specify the \fB-Z\fP
@@ -368,19 +366,6 @@ would pass through all three.
 The other main difference is that \fB-i\fP refers to the input interface;
 \fB-o\fP refers to the output interface, and both are available for packets
 entering the \fBFORWARD\fP chain.
-.\" .PP The various forms of NAT have been separated out; 
-.\" .B iptables 
-.\" is a pure packet filter when using the default `filter' table, with
-.\" optional extension modules.  This should simplify much of the previous
-.\" confusion over the combination of IP masquerading and packet filtering
-.\" seen previously.  So the following options are handled differently:
-.\" .br
-.\" -j MASQ
-.\" .br
-.\" -M -S
-.\" .br
-.\" -M -L
-.\" .br
 There are several other changes in ip6tables.
 .SH SEE ALSO
 .BR ip6tables-save (8),
@@ -391,7 +376,7 @@ There are several other changes in ip6tables.
 .BR libipq (3).
 .P
 The packet-filtering-HOWTO details iptables usage for
-packet filtering, the NAT-HOWTO details NAT,
+packet filtering,
 the netfilter-extensions-HOWTO details the extensions that are
 not in the standard distribution,
 and the netfilter-hacking-HOWTO details the netfilter internals.

