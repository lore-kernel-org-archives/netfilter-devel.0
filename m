From: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Subject: Re: [ANNOUNCE] Feature Freeze for iptables-1.2.7
Date: Sat, 22 Jun 2002 19:12:30 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020622171230.GC399@eychenne.org>
References: <20020615115909.M2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20020615115909.M2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Jun 15, 2002 at 11:59:09AM +0200, Harald Welte wrote:

 Hi,

> I'm announcing a feature freeze for the iptables-1.2.7 release starting
> at 24 Jun 2002. After this date, only bugfixes will be accepted.  The
> 1.2.7 release will most likely be out by Jul 01.

So here are minor manpage updates.

 RV

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="manpages.patch"

--- iptables.8.cvs	Sat Jun 22 18:06:42 2002
+++ iptables.8	Sat Jun 22 19:10:00 2002
@@ -25,23 +25,23 @@
 .SH NAME
 iptables \- administration tool for IPv4 packet filtering and NAT
 .SH SYNOPSIS
-.BR "iptables -[ADC] " "chain rule-specification [options]"
+.BR "iptables [-t table] -[ADC] " "chain rule-specification [options]"
 .br
-.BR "iptables -I " "chain [rulenum] rule-specification [options]"
+.BR "iptables [-t table] -I " "chain [rulenum] rule-specification [options]"
 .br
-.BR "iptables -R " "chain rulenum rule-specification [options]"
+.BR "iptables [-t table] -R " "chain rulenum rule-specification [options]"
 .br
-.BR "iptables -D " "chain rulenum [options]"
+.BR "iptables [-t table] -D " "chain rulenum [options]"
 .br
-.BR "iptables -[LFZ] " "[chain] [options]"
+.BR "iptables [-t table] -[LFZ] " "[chain] [options]"
 .br
-.BR "iptables -N " "chain"
+.BR "iptables [-t table] -N " "chain"
 .br
-.BR "iptables -X " "[chain]"
+.BR "iptables [-t table] -X " "[chain]"
 .br
-.BR "iptables -P " "chain target [options]"
+.BR "iptables [-t table] -P " "chain target [options]"
 .br
-.BR "iptables -E " "old-chain-name new-chain-name"
+.BR "iptables [-t table] -E " "old-chain-name new-chain-name"
 .SH DESCRIPTION
 .B Iptables
 is used to set up, maintain, and inspect the tables of IP packet
@@ -80,7 +80,7 @@
 is matched, the target specified by the chain policy determines the
 fate of the packet.
 .SH TABLES
-There are current three independent tables (which tables are present
+There are currently three independent tables (which tables are present
 at any time depends on the kernel configuration options and which
 modules are present).
 .TP
@@ -93,7 +93,8 @@
 The tables are as follows:
 .TP
 .B "filter"
-This is the default table.  It contains the built-in chains
+This is the default table (if no -t option is passed).  It contains
+the built-in chains
 .B INPUT
 (for packets coming into the box itself),
 .B FORWARD
@@ -595,7 +596,7 @@
 .IR syslogd (8)).
 This is a "non-terminating target", i.e. rule traversal continues at
 the next rule.  So if you want to LOG the packets you refuse, use two
-separate rules with the same matching criterias, first using target LOG
+separate rules with the same matching criteria, first using target LOG
 then DROP (or REJECT).
 .TP
 .BI "--log-level " "level"
@@ -683,7 +684,8 @@
 .B POSTROUTING
 chain.  It specifies that the source address of the packet should be
 modified (and all future packets in this connection will also be
-mangled), and rules should cease being examined.  It takes one option:
+mangled), and rules should cease being examined.  It takes one type
+of option:
 .TP
 .BR "--to-source  " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
 which can specify a single new source IP address, an inclusive range
@@ -696,6 +698,11 @@
 mapped to other ports below 512: those between 512 and 1023 inclusive
 will be mapped to ports below 1024, and other ports will be mapped to
 1024 or above. Where possible, no port alteration will occur.
+.TP
+You can add several --to-source options.  If you specify more
+than one source address, either via an address range or multiple
+--to-source options, a simple round-robin (one after another in
+cycle) takes place between these adresses.
 .SS DNAT
 This target is only valid in the 
 .B nat
@@ -707,7 +714,7 @@
 chains.  It specifies that the destination address of the packet
 should be modified (and all future packets in this connection will
 also be mangled), and rules should cease being examined.  It takes one
-option:
+type of option:
 .TP
 .BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
 which can specify a single new destination IP address, an inclusive
@@ -718,6 +725,11 @@
 .BR "-p udp" ).
 If no port range is specified, then the destination port will never be
 modified.
+.TP
+You can add several --to-destination options.  If you specify more
+than one destination address, either via an address range or multiple
+--to-destination options, a simple round-robin (one after another in
+cycle) load balancing takes place between these adresses.
 .SS MASQUERADE
 This target is only valid in the 
 .B nat
@@ -827,6 +839,7 @@
 other errors cause an exit code of 1.
 .SH BUGS
 Bugs?  What's this? ;-)
+Well... the counters are not reliable on sparc64.
 .SH COMPATIBILITY WITH IPCHAINS
 This 
 .B iptables
--- ip6tables.8.cvs	Sat Jun 22 19:03:42 2002
+++ ip6tables.8	Sat Jun 22 19:10:40 2002
@@ -27,23 +27,23 @@
 .SH NAME
 ip6tables \- IPv6 packet filter administration
 .SH SYNOPSIS
-.BR "ip6tables -[ADC] " "chain rule-specification [options]"
+.BR "ip6tables [-t table] -[ADC] " "chain rule-specification [options]"
 .br
-.BR "ip6tables -I " "chain [rulenum] rule-specification [options]"
+.BR "ip6tables [-t table] -I " "chain [rulenum] rule-specification [options]"
 .br
-.BR "ip6tables -R " "chain rulenum rule-specification [options]"
+.BR "ip6tables [-t table] -R " "chain rulenum rule-specification [options]"
 .br
-.BR "ip6tables -D " "chain rulenum [options]"
+.BR "ip6tables [-t table] -D " "chain rulenum [options]"
 .br
-.BR "ip6tables -[LFZ] " "[chain] [options]"
+.BR "ip6tables [-t table] -[LFZ] " "[chain] [options]"
 .br
-.BR "ip6tables -N " "chain"
+.BR "ip6tables [-t table] -N " "chain"
 .br
-.BR "ip6tables -X " "[chain]"
+.BR "ip6tables [-t table] -X " "[chain]"
 .br
-.BR "ip6tables -P " "chain target [options]"
+.BR "ip6tables [-t table] -P " "chain target [options]"
 .br
-.BR "ip6tables -E " "old-chain-name new-chain-name"
+.BR "ip6tables [-t table] -E " "old-chain-name new-chain-name"
 .SH DESCRIPTION
 .B Ip6tables
 is used to set up, maintain, and inspect the tables of IPv6 packet
@@ -82,9 +82,9 @@
 is matched, the target specified by the chain policy determines the
 fate of the packet.
 .SH TABLES
-There are current three independent tables (which tables are present
+There are currently two independent tables (which tables are present
 at any time depends on the kernel configuration options and which
-modules are present).
+modules are present), as nat table has not been implemented yet.
 .TP
 .BI "-t, --table " "table"
 This option specifies the packet matching table which the command
@@ -95,7 +95,8 @@
 The tables are as follows:
 .TP
 .B "filter"
-This is the default table.  It contains the built-in chains
+This is the default table (if no -t option is passed).  It contains
+the built-in chains
 .B INPUT
 (for packets coming into the box itself),
 .B FORWARD

--VS++wcV0S1rZb1Fb--
