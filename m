From: Herve Eychenne <rv@wallfire.org>
Subject: Re: modified iptables manpage
Date: Thu, 8 Jul 2004 20:10:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040708181030.GB5877@eychenne.org>
References: <20040705115740.GD21294@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DKU6Jbt7q3WqK7+M"
Content-Transfer-Encoding: 8bit
Cc: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040705115740.GD21294@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Jul 05, 2004 at 01:57:40PM +0200, Hervé Eychenne wrote:

 Hi,

> I saw that the last iptables Debian package version (1.2.9-10) includes
> patches to iptables, in particular to the original manpage. Did I miss
> your requests in order to make these changes in the upstream manpage?
> The nature of the patches doesn't matter (they are small)... but don't
> you think that the fair way to do things is to forward wishes to upstream,
> so that everyone could benefit from the improvements, instead of keeping
> them for Debian users only?

> Note: I'll submit a patch to the manpage (with other small changes as well)
> during the week.

Here it is:
- fixed weird characters handling in interface name
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=102771&archive=yes
- fixed typo in manpage (the fix was wrong in Debian...)
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=197619&archive=yes
- added the default logging level (target LOG) to the manpage
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=246037

There are still some patches in the iptables Debian package, that the
coreteam may want to apply... it's up to you.

Sebastien Chaumontet reported that the ability to change only port in
DNAT was not documented in the manpage. The attached patch fixes that
as well.

The patch also reflects the status of the new (ok, this one is pending
for a few months) emeritus members status.

Over time, a few people told me that they first had looked for a
netfilter man page, before finding the iptables one... and I agree
there should definitely be a small man page about netfilter,
containing only a little information about the very basic concepts
and the kernel part, just to clarify things.
Of course, it is not intended to grow too much, as it would overlap
with the howto, which is clearly not its goal.
So I joined a netfilter.7 manpage, as it was pending (too) in
my tree for a long time. Feel free to include it (and correct by bad
english) if you find it useful.

Note: the patch is against current CVS.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/

--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables.patch"

diff -ruN iptables.old/extensions/libip6t_LOG.man iptables/extensions/libip6t_LOG.man
--- iptables.old/extensions/libip6t_LOG.man	2004-01-22 16:04:24.000000000 +0100
+++ iptables/extensions/libip6t_LOG.man	2004-07-08 15:09:14.000000000 +0200
@@ -11,7 +11,9 @@
 then DROP (or REJECT).
 .TP
 .BI "--log-level " "level"
-Level of logging (numeric or see \fIsyslog.conf\fP(5)).
+Level of logging (numeric or see \fIsyslog.conf\fP(5)).  The default 
+level is
+.IR warning .
 .TP
 .BI "--log-prefix " "prefix"
 Prefix log messages with the specified prefix; up to 29 letters long,
diff -ruN iptables.old/extensions/libipt_DNAT.man iptables/extensions/libipt_DNAT.man
--- iptables.old/extensions/libipt_DNAT.man	2004-01-22 16:04:24.000000000 +0100
+++ iptables/extensions/libipt_DNAT.man	2004-07-08 19:29:46.000000000 +0200
@@ -10,9 +10,12 @@
 also be mangled), and rules should cease being examined.  It takes one
 type of option:
 .TP
-.BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
+.BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP[-\fIport\fP]]"
+.ns
+.TP
+.BR "--to-destination " ":\fIport\fP[-\fIport\fP]"
 which can specify a single new destination IP address, an inclusive
-range of IP addresses, and optionally, a port range (which is only
+range of IP addresses, and/or a port, or a port range (which is only
 valid if the rule also specifies
 .B "-p tcp"
 or
diff -ruN iptables.old/extensions/libipt_LOG.man iptables/extensions/libipt_LOG.man
--- iptables.old/extensions/libipt_LOG.man	2004-01-22 16:04:24.000000000 +0100
+++ iptables/extensions/libipt_LOG.man	2004-07-08 15:08:37.000000000 +0200
@@ -11,7 +11,9 @@
 then DROP (or REJECT).
 .TP
 .BI "--log-level " "level"
-Level of logging (numeric or see \fIsyslog.conf\fP(5)).
+Level of logging (numeric or see \fIsyslog.conf\fP(5)).  The default 
+level is
+.IR warning .
 .TP
 .BI "--log-prefix " "prefix"
 Prefix log messages with the specified prefix; up to 29 letters long,
diff -ruN iptables.old/extensions/libipt_physdev.c iptables/extensions/libipt_physdev.c
--- iptables.old/extensions/libipt_physdev.c	2003-04-27 12:01:44.000000000 +0200
+++ iptables/extensions/libipt_physdev.c	2004-07-08 14:55:08.000000000 +0200
@@ -63,8 +63,9 @@
 		for (i = 0; vianame[i]; i++) {
 			if (!isalnum(vianame[i])
 			    && vianame[i] != '_'
+			    && vianame[i] != '-'
 			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
+				printf("Warning: weird character in interface"
 				       " `%s' (No aliases, :, ! or *).\n",
 				       vianame);
 				break;
diff -ruN iptables.old/ip6tables.8.in iptables/ip6tables.8.in
--- iptables.old/ip6tables.8.in	2004-01-22 16:04:24.000000000 +0100
+++ iptables/ip6tables.8.in	2004-07-08 19:15:08.000000000 +0200
@@ -58,7 +58,7 @@
 
 .SH TARGETS
 A firewall rule specifies criteria for a packet, and a target.  If the
-packet does not match, the next rule in the chain is the examined; if
+packet does not match, the next rule in the chain is examined; if
 it does match, then the next rule is specified by the value of the
 target, which can be the name of a user-defined chain or one of the
 special values 
@@ -450,8 +450,9 @@
 .PP
 Harald Welte wrote the ULOG target, TTL match+target and libipulog.
 .PP
-The Netfilter Core Team is: Marc Boucher, Martin Josefsson, Jozsef Kadlecsik,
-James Morris, Harald Welte and Rusty Russell.
+The Netfilter Core Team is: Martin Josefsson, Jozsef Kadlecsik, 
+Patrick McHardy, and Harald Welte.
+Core Team Emeritus Members are: Marc Boucher, James Morris, and Rusty Russell.
 .PP
 ip6tables man page created by Andras Kis-Szabo, based on
 iptables man page written by Herve Eychenne <rv@wallfire.org>.
diff -ruN iptables.old/ip6tables.c iptables/ip6tables.c
--- iptables.old/ip6tables.c	2004-05-26 18:04:48.000000000 +0200
+++ iptables/ip6tables.c	2004-07-08 14:54:38.000000000 +0200
@@ -854,9 +854,10 @@
 		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
 		for (i = 0; vianame[i]; i++) {
 			if (!isalnum(vianame[i]) 
-			    && vianame[i] != '_' 
+			    && vianame[i] != '_'
+			    && vianame[i] != '-'
 			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
+				printf("Warning: weird character in interface"
 				       " `%s' (No aliases, :, ! or *).\n",
 				       vianame);
 				break;
diff -ruN iptables.old/iptables.8.in iptables/iptables.8.in
--- iptables.old/iptables.8.in	2004-03-17 15:26:08.000000000 +0100
+++ iptables/iptables.8.in	2004-07-08 19:14:35.000000000 +0200
@@ -56,7 +56,7 @@
 
 .SH TARGETS
 A firewall rule specifies criteria for a packet, and a target.  If the
-packet does not match, the next rule in the chain is the examined; if
+packet does not match, the next rule in the chain is examined; if
 it does match, then the next rule is specified by the value of the
 target, which can be the name of a user-defined chain or one of the
 special values 
@@ -454,8 +454,9 @@
 .PP
 Harald Welte wrote the ULOG target, TTL, DSCP, ECN matches and targets.
 .PP
-The Netfilter Core Team is: Marc Boucher, Martin Josefsson, Jozsef Kadlecsik, 
-Patrick McHardy, James Morris, Harald Welte and Rusty Russell.
+The Netfilter Core Team is: Martin Josefsson, Jozsef Kadlecsik, 
+Patrick McHardy, and Harald Welte.
+Core Team Emeritus Members are: Marc Boucher, James Morris, and Rusty Russell.
 .PP
 Man page written by Herve Eychenne <rv@wallfire.org>.
 .\" .. and did I mention that we are incredibly cool people?
diff -ruN iptables.old/iptables.c iptables/iptables.c
--- iptables.old/iptables.c	2004-07-04 17:20:53.000000000 +0200
+++ iptables/iptables.c	2004-07-08 14:54:48.000000000 +0200
@@ -794,9 +794,10 @@
 		memset(mask + vialen + 1, 0, IFNAMSIZ - vialen - 1);
 		for (i = 0; vianame[i]; i++) {
 			if (!isalnum(vianame[i]) 
-			    && vianame[i] != '_' 
+			    && vianame[i] != '_'
+			    && vianame[i] != '-'
 			    && vianame[i] != '.') {
-				printf("Warning: wierd character in interface"
+				printf("Warning: weird character in interface"
 				       " `%s' (No aliases, :, ! or *).\n",
 				       vianame);
 				break;
diff -ruN iptables.old/netfilter.7 iptables/netfilter.7
--- iptables.old/netfilter.7	1970-01-01 01:00:00.000000000 +0100
+++ iptables/netfilter.7	2004-07-08 19:18:27.000000000 +0200
@@ -0,0 +1,130 @@
+.TH NETFILTER 7 "Jan 20, 2004" "" ""
+.\"
+.\" Man page written by Herve Eychenne <rv@wallfire.org> (Jan 2004)
+.\"
+.\"	This program is free software; you can redistribute it and/or modify
+.\"	it under the terms of the GNU General Public License as published by
+.\"	the Free Software Foundation; either version 2 of the License, or
+.\"	(at your option) any later version.
+.\"
+.\"	This program is distributed in the hope that it will be useful,
+.\"	but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\"	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\"	GNU General Public License for more details.
+.\"
+.\"	You should have received a copy of the GNU General Public License
+.\"	along with this program; if not, write to the Free Software
+.\"	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+.\"
+.SH NAME
+netfilter \- the firewalling framework for Linux 2.4 and 2.6
+.SH DESCRIPTION
+The
+.B netfilter
+framework enables packet filtering, network address translation (NAT)
+and other packet mangling.
+.br
+It is a set of hooks inside the Linux kernel that allows kernel modules
+to register callback functions within the network stack.  A registered
+callback function is called for every packet that traverses the respective
+hook in the network stack.
+.P
+Many applications can use the netfilter API, and
+.B iptables
+is currently the main one.  Iptables is the native firewalling functionnality
+that was developped on top of netfilter, as a generic table structure for
+the definition of rulesets.  Each rule within an IP table consists out
+of a number of classifiers (iptables matches) and one connected action
+(iptables target).
+.P
+.B Connection tracking
+is a kernel module which stores state information about a connection
+in kernel memory, such as source and destination IP address and port
+numbers, protocol types, connection state and timeouts.
+Netfilter and iptables can use connection tracking to implement
+stateful firewalling.  Note that it is not mandatory, but it is inherently
+more secure as it allows to write much tighter rulesets.
+.P
+The mainstream kernel comes with a given set of netfilter/iptables
+functionnalities, but those can be extended by patches, packaged by
+the netfilter developers.
+.B Patch-o-matic
+contains those extensions, as well as a script that enables you to select
+the patches you want, and apply them to the kernel source automatically.
+
+.SH NETFILTER
+.SS HOOKS
+Here are the hooks currently set by netfilter:
+.TP
+.B PREROUTING
+for altering packets as soon as they come in (before routing), but after
+connection tracking (if enabled)
+.TP
+.B INPUT
+for packets coming into the box itself
+.TP
+.B OUTPUT
+for locally-generated packets (before routing)
+.TP
+.B FORWARD
+for packets being routed through the box
+.TP
+.B POSTROUTING
+for altering packets as they are about to go out (after routing)
+
+.SH IPTABLES
+.SS FILES
+.TP
+.B /proc/net/ip_tables_names
+outputs the list of iptables tables names available at runtime
+.TP
+.B /proc/net/ip_tables_matches
+outputs the list of kernel iptables matches available at runtime
+.TP
+.B /proc/net/ip_tables_targets
+outputs the list of kernel iptables targets available at runtime
+
+.SH CONNECTION TRACKING
+.SS FILES
+.TP
+.B /proc/net/ip_conntrack
+gives a listing of connections currently stored in conntrack.
+.br
+It prints the protocol name, the protocol number, the timeout before the
+expiration of the entry, informations regarding the protocol (such as
+source and destination IP addresses and ports, the status of the
+connection) in both directions, and eventually the reference counter
+of the entry.
+.TP
+.B ip_conntrack_max
+outputs and sets the maximum number of allowed conntrack entries
+.TP
+.B ip_conntrack_*_timeout_*
+allows to change default conntrack timeout values for tcp, udp, and icmp
+protocols, as well as the generic timeout value.
+
+.SH BUGS
+Bugs?  What's this? ;-)
+Well... Ok. Just see
+.BR "http://bugzilla.netfilter.org/" .
+.SH SEE ALSO
+.BR iptables (8),
+.BR ip6tables (8).
+.P
+The packet-filtering-HOWTO details iptables usage for
+packet filtering, the NAT-HOWTO details NAT,
+the netfilter-extensions-HOWTO details the extensions that are
+not in the standard distribution,
+and the netfilter-hacking-HOWTO details the netfilter internals.
+.br
+See
+.BR "http://www.netfilter.org/" .
+.SH AUTHORS
+The Netfilter Core Team is: Martin Josefsson, Jozsef Kadlecsik, 
+Patrick McHardy, and Harald Welte.
+Core Team Emeritus Members are: Marc Boucher, James Morris, and Rusty Russell.
+.PP
+Rusty Russell is the original author of netfilter/iptables, and
+Harald Welte is the current maintainer.
+.PP
+This man page was written by Herve Eychenne <rv@wallfire.org>.

--DKU6Jbt7q3WqK7+M--
