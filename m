From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] man page: alphabetize extensions + add physdev entry
Date: Thu, 13 Feb 2003 20:39:58 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302132039.58656.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_MMI99RJTO2KD7OTS9RFV"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_MMI99RJTO2KD7OTS9RFV
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello Harald,

here's the patch.

--=20
cheers,
Bart

--------------Boundary-00=_MMI99RJTO2KD7OTS9RFV
Content-Type: text/x-diff;
  charset="us-ascii";
  name="iptables_man_update.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iptables_man_update.diff"

--- iptables.8.old	Wed Feb 12 18:55:55 2003
+++ iptables.8	Thu Feb 13 20:33:25 2003
@@ -376,71 +376,75 @@
 be preceded by a
 .B !
 to invert the sense of the match.
-.SS tcp
-These extensions are loaded if `--protocol tcp' is specified. It
-provides the following options:
+.SS ah
+This module matches the SPIs in AH header of IPSec packets.
 .TP
-.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
-Source port or port range specification. This can either be a service
-name or a port number. An inclusive range can also be specified,
-using the format
-.IR port : port .
-If the first port is omitted, "0" is assumed; if the last is omitted,
-"65535" is assumed.
-If the second port greater then the first they will be swapped.
-The flag
-.B --sport
-is a convenient alias for this option.
+.BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
+.SS conntrack
+This module, when combined with connection tracking, allows access to
+more connection tracking information than the "state" match.
+(this module is present only if iptables was compiled under a kernel
+supporting this feature)
 .TP
-.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
-Destination port or port range specification.  The flag
-.B --dport
-is a convenient alias for this option.
+.BI "--ctstate " "state"
+Where state is a comma separated list of the connection states to
+match.  Possible states are
+.B INVALID
+meaning that the packet is associated with no known connection,
+.B ESTABLISHED
+meaning that the packet is associated with a connection which has seen
+packets in both directions,
+.B NEW
+meaning that the packet has started a new connection, or otherwise
+associated with a connection which has not seen packets in both
+directions, and
+.B RELATED
+meaning that the packet is starting a new connection, but is
+associated with an existing connection, such as an FTP data transfer,
+or an ICMP error.
+.B SNAT
+A virtual state, matching if the original source address differs from
+the reply destination.
+.B DNAT
+A virtual state, matching if the original destination differs from the
+reply source.
 .TP
-.BR "--tcp-flags " "[!] \fImask\fP \fIcomp\fP"
-Match when the TCP flags are as specified.  The first argument is the
-flags which we should examine, written as a comma-separated list, and
-the second argument is a comma-separated list of flags which must be
-set.  Flags are: 
-.BR "SYN ACK FIN RST URG PSH ALL NONE" .
-Hence the command
-.br
- iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
-.br
-will only match packets with the SYN flag set, and the ACK, FIN and
-RST flags unset.
+.BI "--ctproto " "proto"
+Protocol to match (by number or name)
 .TP
-.B "[!] --syn"
-Only match TCP packets with the SYN bit set and the ACK and RST bits
-cleared.  Such packets are used to request TCP connection initiation;
-for example, blocking such packets coming in an interface will prevent
-incoming TCP connections, but outgoing TCP connections will be
-unaffected.
-It is equivalent to \fB--tcp-flags SYN,RST,ACK SYN\fP.
-If the "!" flag precedes the "--syn", the sense of the
-option is inverted.
+.BI "--ctorigsrc " "[!] \fIaddress\fP[/\fImask\fP]"
+Match against original source address
 .TP
-.BR "--tcp-option " "[!] \fInumber\fP"
-Match if TCP option set.
+.BI "--ctorigdst " "[!] \fIaddress\fP[/\fImask\fP]"
+Match against original destination address
 .TP
-.BR "--mss " "\fIvalue\fP[:\fIvalue\fP]"
-Match TCP SYN or SYN/ACK packets with the specified MSS value (or range),
-which control the maximum packet size for that connection.
-.SS udp
-These extensions are loaded if `--protocol udp' is specified.  It
-provides the following options:
+.BI "--ctreplsrc " "[!] \fIaddress\fP[/\fImask\fP]"
+Match against reply source address
 .TP
-.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
-Source port or port range specification.
-See the description of the
-.B --source-port
-option of the TCP extension for details.
+.BI "--ctrepldst " "[!] \fIaddress\fB[/\fImask\fP]"
+Match against reply destination address
 .TP
-.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
-Destination port or port range specification.
-See the description of the
-.B --destination-port
-option of the TCP extension for details.
+.BI "--ctstatus " "[\fINONE|EXPECTED|SEEN_REPLY|ASSURED\fP][,...]"
+Match against internal conntrack states
+.TP
+.BI "--ctexpire " "\fItime\fP[\fI:time\fP]"
+Match remaining lifetime in seconds against given value
+or range of values (inclusive)
+.SS dscp
+This module matches the 6 bit DSCP field within the TOS field in the
+IP header.  DSCP has superseded TOS within the IETF.
+.TP
+.BI "--dscp " "value"
+Match against a numeric (decimal or hex) value [0-32].
+.TP
+.BI "--dscp-class " "\fIDiffServ Class\fP"
+Match the DiffServ class. This value may be any of the
+BE, EF, AFxx or CSx classes.  It will then be converted
+into it's according numeric value.
+.SS esp
+This module matches the SPIs in ESP header of IPSec packets.
+.TP
+.BR "--espspi " "[!] \fIspi\fP[:\fIspi\fP]"
 .SS icmp
 This extension is loaded if `--protocol icmp' is specified.  It
 provides the following option:
@@ -451,17 +455,11 @@
 .br
  iptables -p icmp -h
 .br
-.SS mac
+.SS length
+This module matches the length of a packet against a specific value
+or range of values.
 .TP
-.BR "--mac-source " "[!] \fIaddress\fP"
-Match source MAC address.  It must be of the form XX:XX:XX:XX:XX:XX.
-Note that this only makes sense for packets coming from an Ethernet device
-and entering the
-.BR PREROUTING ,
-.B FORWARD
-or
-.B INPUT
-chains.
+.BR "--length " "\fIlength\fP[:\fIlength\fP]"
 .SS limit
 This module matches at a limited rate using a token bucket filter.
 A rule using this extension will match until this limit is reached
@@ -478,6 +476,27 @@
 Maximum initial number of packets to match: this number gets
 recharged by one every time the limit specified above is not reached,
 up to this number; the default is 5.
+.SS mac
+.TP
+.BR "--mac-source " "[!] \fIaddress\fP"
+Match source MAC address.  It must be of the form XX:XX:XX:XX:XX:XX.
+Note that this only makes sense for packets coming from an Ethernet device
+and entering the
+.BR PREROUTING ,
+.B FORWARD
+or
+.B INPUT
+chains.
+.SS mark
+This module matches the netfilter mark field associated with a packet
+(which can be set using the
+.B MARK
+target below).
+.TP
+.BR "--mark " "\fIvalue\fP[/\fImask\fP]"
+Matches packets with the given unsigned mark value (if a mask is
+specified, this is logically ANDed with the mask before the
+comparison).
 .SS multiport
 This module matches a set of source or destination ports.  Up to 15
 ports can be specified.  It can only be used in conjunction with
@@ -498,16 +517,6 @@
 .BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.
-.SS mark
-This module matches the netfilter mark field associated with a packet
-(which can be set using the
-.B MARK
-target below).
-.TP
-.BR "--mark " "\fIvalue\fP[/\fImask\fP]"
-Matches packets with the given unsigned mark value (if a mask is
-specified, this is logically ANDed with the mask before the
-comparison).
 .SS owner
 This module attempts to match various characteristics of the packet
 creator, for locally-generated packets.  It is only valid in the
@@ -535,35 +544,48 @@
 Matches if the packet was created by a process with the given command name.
 (this option is present only if iptables was compiled under a kernel
 supporting this feature)
+.SS physdev
+This module matches on the bridge port input and output devices enslaved
+to a bridge device. This is only useful if the input device or output device
+is a bridge device. This module is a part of the infrastructure that enables
+a transparent bridging IP firewall and is only useful for kernel versions
+above version 2.5.44.
+.TP
+.B --physdev-in name
+Name of a bridge port via which a packet is received (only for
+packets entering the
+.BR INPUT ,
+.B FORWARD
+and
+.B PREROUTING
+chains). If the interface name ends in a "+", then any
+interface which begins with this name will match.
+.TP
+.B --physdev-out name
+Name of a bridge port via which a packet is going to be sent (for packets
+entering the
+.BR FORWARD ,
+.B OUTPUT
+and
+.B POSTROUTING
+chains).  If the interface name ends in a "+", then any
+interface which begins with this name will match. Note that in the
+.BR nat " and " mangle
+.B OUTPUT
+chains one cannot match on the bridge output port, however one can in the
+.B "filter OUTPUT"
+chain.
+.SS pkttype
+This module matches the link-layer packet type.
+.TP
+.BI "--pkt-type " "[\fIunicast\fP|\fIbroadcast\fP|\fImulticast\fP]"
 .SS state
 This module, when combined with connection tracking, allows access to
 the connection tracking state for this packet.
 .TP
 .BI "--state " "state"
 Where state is a comma separated list of the connection states to
-match.  Possible states are 
-.B INVALID
-meaning that the packet is associated with no known connection,
-.B ESTABLISHED
-meaning that the packet is associated with a connection which has seen
-packets in both directions,
-.B NEW
-meaning that the packet has started a new connection, or otherwise
-associated with a connection which has not seen packets in both
-directions, and
-.B RELATED
-meaning that the packet is starting a new connection, but is
-associated with an existing connection, such as an FTP data transfer,
-or an ICMP error.
-.SS conntrack
-This module, when combined with connection tracking, allows access to
-more connection tracking information than the "state" match.
-(this module is present only if iptables was compiled under a kernel
-supporting this feature)
-.TP
-.BI "--ctstate " "state"
-Where state is a comma separated list of the connection states to
-match.  Possible states are 
+match.  Possible states are
 .B INVALID
 meaning that the packet is associated with no known connection,
 .B ESTABLISHED
@@ -577,52 +599,59 @@
 meaning that the packet is starting a new connection, but is
 associated with an existing connection, such as an FTP data transfer,
 or an ICMP error.
-.B SNAT
-A virtual state, matching if the original source address differs from 
-the reply destination.
-.B DNAT
-A virtual state, matching if the original destination differs from the 
-reply source.
-.TP
-.BI "--ctproto " "proto"
-Protocol to match (by number or name)
-.TP
-.BI "--ctorigsrc " "[!] \fIaddress\fP[/\fImask\fP]"
-Match against original source address
-.TP
-.BI "--ctorigdst " "[!] \fIaddress\fP[/\fImask\fP]"
-Match against original destination address
-.TP
-.BI "--ctreplsrc " "[!] \fIaddress\fP[/\fImask\fP]"
-Match against reply source address
+.SS tcp
+These extensions are loaded if `--protocol tcp' is specified. It
+provides the following options:
 .TP
-.BI "--ctrepldst " "[!] \fIaddress\fB[/\fImask\fP]"
-Match against reply destination address
+.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
+Source port or port range specification. This can either be a service
+name or a port number. An inclusive range can also be specified,
+using the format
+.IR port : port .
+If the first port is omitted, "0" is assumed; if the last is omitted,
+"65535" is assumed.
+If the second port greater then the first they will be swapped.
+The flag
+.B --sport
+is a convenient alias for this option.
 .TP
-.BI "--ctstatus " "[\fINONE|EXPECTED|SEEN_REPLY|ASSURED\fP][,...]"
-Match against internal conntrack states
+.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
+Destination port or port range specification.  The flag
+.B --dport
+is a convenient alias for this option.
 .TP
-.BI "--ctexpire " "\fItime\fP[\fI:time\fP]"
-Match remaining lifetime in seconds against given value
-or range of values (inclusive)
-.SS dscp
-This module matches the 6 bit DSCP field within the TOS field in the
-IP header.  DSCP has superseded TOS within the IETF.
+.BR "--tcp-flags " "[!] \fImask\fP \fIcomp\fP"
+Match when the TCP flags are as specified.  The first argument is the
+flags which we should examine, written as a comma-separated list, and
+the second argument is a comma-separated list of flags which must be
+set.  Flags are:
+.BR "SYN ACK FIN RST URG PSH ALL NONE" .
+Hence the command
+.br
+ iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
+.br
+will only match packets with the SYN flag set, and the ACK, FIN and
+RST flags unset.
 .TP
-.BI "--dscp " "value"
-Match against a numeric (decimal or hex) value [0-32].
+.B "[!] --syn"
+Only match TCP packets with the SYN bit set and the ACK and RST bits
+cleared.  Such packets are used to request TCP connection initiation;
+for example, blocking such packets coming in an interface will prevent
+incoming TCP connections, but outgoing TCP connections will be
+unaffected.
+It is equivalent to \fB--tcp-flags SYN,RST,ACK SYN\fP.
+If the "!" flag precedes the "--syn", the sense of the
+option is inverted.
 .TP
-.BI "--dscp-class " "\fIDiffServ Class\fP"
-Match the DiffServ class. This value may be any of the 
-BE, EF, AFxx or CSx classes.  It will then be converted
-into it's according numeric value.
-.SS pkttype
-This module matches the link-layer packet type.
+.BR "--tcp-option " "[!] \fInumber\fP"
+Match if TCP option set.
 .TP
-.BI "--pkt-type " "[\fIunicast\fP|\fIbroadcast\fP|\fImulticast\fP]"
+.BR "--mss " "\fIvalue\fP[:\fIvalue\fP]"
+Match TCP SYN or SYN/ACK packets with the specified MSS value (or range),
+which control the maximum packet size for that connection.
 .SS tos
 This module matches the 8 bits of Type of Service field in the IP
-header (ie. including the precedence bits). 
+header (ie. including the precedence bits).
 .TP
 .BI "--tos " "tos"
 The argument is either a standard name, (use
@@ -630,30 +659,77 @@
  iptables -m tos -h
 .br
 to see the list), or a numeric value to match.
-.SS ah
-This module matches the SPIs in AH header of IPSec packets.
+.SS ttl
+This module matches the time to live field in the IP header.
+.TP
+.BI "--ttl " "ttl"
+Matches the given TTL value.
+.SS udp
+These extensions are loaded if `--protocol udp' is specified.  It
+provides the following options:
+.TP
+.BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
+Source port or port range specification.
+See the description of the
+.B --source-port
+option of the TCP extension for details.
+.TP
+.BR "--destination-port " "[!] \fIport\fP[:\fIport\fP]"
+Destination port or port range specification.
+See the description of the
+.B --destination-port
+option of the TCP extension for details.
+.SS unclean
+This module takes no options, but attempts to match packets which seem
+malformed or unusual.  This is regarded as experimental.
+.SH TARGET EXTENSIONS
+iptables can use extended target modules: the following are included
+in the standard distribution.
+.SS DNAT
+This target is only valid in the
+.B nat
+table, in the
+.B PREROUTING
+and
+.B OUTPUT
+chains, and user-defined chains which are only called from those
+chains.  It specifies that the destination address of the packet
+should be modified (and all future packets in this connection will
+also be mangled), and rules should cease being examined.  It takes one
+type of option:
+.TP
+.BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
+which can specify a single new destination IP address, an inclusive
+range of IP addresses, and optionally, a port range (which is only
+valid if the rule also specifies
+.B "-p tcp"
+or
+.BR "-p udp" ).
+If no port range is specified, then the destination port will never be
+modified.
 .TP
-.BR "--ahspi " "[!] \fIspi\fP[:\fIspi\fP]"
-.SS esp
-This module matches the SPIs in ESP header of IPSec packets.
+You can add several --to-destination options.  If you specify more
+than one destination address, either via an address range or multiple
+--to-destination options, a simple round-robin (one after another in
+cycle) load balancing takes place between these adresses.
+.SS DSCP
+This target allows to alter the value of the DSCP bits within the TOS
+header of the IPv4 packet.  As this manipulates a packet, it can only
+be used in the mangle table.
 .TP
-.BR "--espspi " "[!] \fIspi\fP[:\fIspi\fP]"
-.SS length
-This module matches the length of a packet against a specific value
-or range of values.
+.BI "--set-dscp " "value"
+Set the DSCP field to a numerical value (can be decimal or hex)
 .TP
-.BR "--length " "\fIlength\fP[:\fIlength\fP]"
-.SS ttl
-This module matches the time to live field in the IP header.
+.BI "--set-dscp-class " "class"
+Set the DSCP field to a DiffServ class.
+.SS ECN
+This target allows to selectively work around known ECN blackholes.
+It can only be used in the mangle table.
 .TP
-.BI "--ttl " "ttl"
-Matches the given TTL value.
-.SS unclean
-This module takes no options, but attempts to match packets which seem
-malformed or unusual.  This is regarded as experimental.
-.SH TARGET EXTENSIONS
-iptables can use extended target modules: the following are included
-in the standard distribution.
+.BI "--ecn-tcp-remove"
+Remove all ECN bits from the TCP header.  Of course, it can only be used
+in conjunction with
+.BR "-p tcp" .
 .SS LOG
 Turn on kernel logging of matching packets.  When this option is set
 for a rule, the Linux kernel will print some information on all
@@ -690,9 +766,64 @@
 table.  It can for example be used in conjunction with iproute2.
 .TP
 .BI "--set-mark " "mark"
+.SS MASQUERADE
+This target is only valid in the
+.B nat
+table, in the
+.B POSTROUTING
+chain.  It should only be used with dynamically assigned IP (dialup)
+connections: if you have a static IP address, you should use the SNAT
+target.  Masquerading is equivalent to specifying a mapping to the IP
+address of the interface the packet is going out, but also has the
+effect that connections are
+.I forgotten
+when the interface goes down.  This is the correct behavior when the
+next dialup is unlikely to have the same interface address (and hence
+any established connections are lost anyway).  It takes one option:
+.TP
+.BR "--to-ports " "\fIport\fP[-\fIport\fP]"
+This specifies a range of source ports to use, overriding the default
+.B SNAT
+source port-selection heuristics (see above).  This is only valid
+if the rule also specifies
+.B "-p tcp"
+or
+.BR "-p udp" .
+.SS MIRROR
+This is an experimental demonstration target which inverts the source
+and destination fields in the IP header and retransmits the packet.
+It is only valid in the
+.BR INPUT ,
+.B FORWARD
+and
+.B PREROUTING
+chains, and user-defined chains which are only called from those
+chains.  Note that the outgoing packets are
+.B NOT
+seen by any packet filtering chains, connection tracking or NAT, to
+avoid loops and other problems.
+.SS REDIRECT
+This target is only valid in the
+.B nat
+table, in the
+.B PREROUTING
+and
+.B OUTPUT
+chains, and user-defined chains which are only called from those
+chains.  It alters the destination IP address to send the packet to
+the machine itself (locally-generated packets are mapped to the
+127.0.0.1 address).  It takes one option:
+.TP
+.BR "--to-ports " "\fIport\fP[-\fIport\fP]"
+This specifies a destination port or range of ports to use: without
+this, the destination port is never altered.  This is only valid
+if the rule also specifies
+.B "-p tcp"
+or
+.BR "-p udp" .
 .SS REJECT
 This is used to send back an error packet in response to the matched
-packet: otherwise it is equivalent to 
+packet: otherwise it is equivalent to
 .B DROP
 so it is a terminating TARGET, ending rule traversal.
 This target is only valid in the
@@ -705,7 +836,7 @@
 returned:
 .TP
 .BI "--reject-with " "type"
-The type given can be 
+The type given can be
 .BR icmp-net-unreachable ,
 .BR icmp-host-unreachable ,
 .BR icmp-port-unreachable ,
@@ -720,35 +851,10 @@
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
-.SS TOS
-This is used to set the 8-bit Type of Service field in the IP header.
-It is only valid in the
-.B mangle
-table.
-.TP
-.BI "--set-tos " "tos"
-You can use a numeric TOS values, or use
-.br
- iptables -j TOS -h
-.br
-to see the list of valid TOS names.
-.SS MIRROR
-This is an experimental demonstration target which inverts the source
-and destination fields in the IP header and retransmits the packet.
-It is only valid in the
-.BR INPUT ,
-.B FORWARD
-and 
-.B PREROUTING
-chains, and user-defined chains which are only called from those
-chains.  Note that the outgoing packets are
-.B NOT
-seen by any packet filtering chains, connection tracking or NAT, to
-avoid loops and other problems.
 .SS SNAT
-This target is only valid in the 
+This target is only valid in the
 .B nat
-table, in the 
+table, in the
 .B POSTROUTING
 chain.  It specifies that the source address of the packet should be
 modified (and all future packets in this connection will also be
@@ -771,102 +877,6 @@
 than one source address, either via an address range or multiple
 --to-source options, a simple round-robin (one after another in
 cycle) takes place between these adresses.
-.SS DNAT
-This target is only valid in the 
-.B nat
-table, in the 
-.B PREROUTING
-and
-.B OUTPUT
-chains, and user-defined chains which are only called from those
-chains.  It specifies that the destination address of the packet
-should be modified (and all future packets in this connection will
-also be mangled), and rules should cease being examined.  It takes one
-type of option:
-.TP
-.BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
-which can specify a single new destination IP address, an inclusive
-range of IP addresses, and optionally, a port range (which is only
-valid if the rule also specifies
-.B "-p tcp"
-or
-.BR "-p udp" ).
-If no port range is specified, then the destination port will never be
-modified.
-.TP
-You can add several --to-destination options.  If you specify more
-than one destination address, either via an address range or multiple
---to-destination options, a simple round-robin (one after another in
-cycle) load balancing takes place between these adresses.
-.SS MASQUERADE
-This target is only valid in the 
-.B nat
-table, in the 
-.B POSTROUTING
-chain.  It should only be used with dynamically assigned IP (dialup)
-connections: if you have a static IP address, you should use the SNAT
-target.  Masquerading is equivalent to specifying a mapping to the IP
-address of the interface the packet is going out, but also has the
-effect that connections are 
-.I forgotten
-when the interface goes down.  This is the correct behavior when the
-next dialup is unlikely to have the same interface address (and hence
-any established connections are lost anyway).  It takes one option:
-.TP
-.BR "--to-ports " "\fIport\fP[-\fIport\fP]"
-This specifies a range of source ports to use, overriding the default 
-.B SNAT
-source port-selection heuristics (see above).  This is only valid
-if the rule also specifies
-.B "-p tcp"
-or
-.BR "-p udp" .
-.SS REDIRECT
-This target is only valid in the 
-.B nat
-table, in the 
-.B PREROUTING
-and
-.B OUTPUT
-chains, and user-defined chains which are only called from those
-chains.  It alters the destination IP address to send the packet to
-the machine itself (locally-generated packets are mapped to the
-127.0.0.1 address).  It takes one option:
-.TP
-.BR "--to-ports " "\fIport\fP[-\fIport\fP]"
-This specifies a destination port or range of ports to use: without
-this, the destination port is never altered.  This is only valid
-if the rule also specifies
-.B "-p tcp"
-or
-.BR "-p udp" .
-.SS ULOG
-This target provides userspace logging of matching packets.  When this
-target is set for a rule, the Linux kernel will multicast this packet
-through a
-.IR netlink 
-socket. One or more userspace processes may then subscribe to various 
-multicast groups and receive the packets.
-Like LOG, this is a "non-terminating target", i.e. rule traversal
-continues at the next rule.
-.TP
-.BI "--ulog-nlgroup " "nlgroup"
-This specifies the netlink group (1-32) to which the packet is sent.
-Default value is 1.
-.TP
-.BI "--ulog-prefix " "prefix"
-Prefix log messages with the specified prefix; up to 32 characters
-long, and useful for distinguishing messages in the logs.
-.TP
-.BI "--ulog-cprange " "size"
-Number of bytes to be copied to userspace.  A value of 0 always copies
-the entire packet, regardless of its size.  Default is 0.
-.TP
-.BI "--ulog-qthreshold " "size"
-Number of packet to queue inside kernel.  Setting this value to, e.g. 10
-accumulates ten packets inside the kernel and transmits them as one
-netlink multipart message to userspace.  Default is 1 (for backwards
-compatibility).
 .SS TCPMSS
 This target allows to alter the MSS value of TCP SYN packets, to control
 the maximum size for that connection (usually limiting it to your
@@ -900,24 +910,45 @@
 Automatically clamp MSS value to (path_MTU - 40).
 .TP
 These options are mutually exclusive.
-.SS DSCP
-This target allows to alter the value of the DSCP bits within the TOS
-header of the IPv4 packet.  As this manipulates a packet, it can only
-be used in the mangle table.
+.SS TOS
+This is used to set the 8-bit Type of Service field in the IP header.
+It is only valid in the
+.B mangle
+table.
 .TP
-.BI "--set-dscp " "value"
-Set the DSCP field to a numerical value (can be decimal or hex)
+.BI "--set-tos " "tos"
+You can use a numeric TOS values, or use
+.br
+ iptables -j TOS -h
+.br
+to see the list of valid TOS names.
+.SS ULOG
+This target provides userspace logging of matching packets.  When this
+target is set for a rule, the Linux kernel will multicast this packet
+through a
+.IR netlink 
+socket. One or more userspace processes may then subscribe to various 
+multicast groups and receive the packets.
+Like LOG, this is a "non-terminating target", i.e. rule traversal
+continues at the next rule.
 .TP
-.BI "--set-dscp-class " "class"
-Set the DSCP field to a DiffServ class.
-.SS ECN
-This target allows to selectively work around known ECN blackholes.
-It can only be used in the mangle table.
+.BI "--ulog-nlgroup " "nlgroup"
+This specifies the netlink group (1-32) to which the packet is sent.
+Default value is 1.
 .TP
-.BI "--ecn-tcp-remove"
-Remove all ECN bits from the TCP header.  Of course, it can only be used
-in conjunction with
-.BR "-p tcp" .
+.BI "--ulog-prefix " "prefix"
+Prefix log messages with the specified prefix; up to 32 characters
+long, and useful for distinguishing messages in the logs.
+.TP
+.BI "--ulog-cprange " "size"
+Number of bytes to be copied to userspace.  A value of 0 always copies
+the entire packet, regardless of its size.  Default is 0.
+.TP
+.BI "--ulog-qthreshold " "size"
+Number of packet to queue inside kernel.  Setting this value to, e.g. 10
+accumulates ten packets inside the kernel and transmits them as one
+netlink multipart message to userspace.  Default is 1 (for backwards
+compatibility).
 .br
 .SH DIAGNOSTICS
 Various error messages are printed to standard error.  The exit code
@@ -928,10 +959,10 @@
 Bugs?  What's this? ;-)
 Well... the counters are not reliable on sparc64.
 .SH COMPATIBILITY WITH IPCHAINS
-This 
+This
 .B iptables
 is very similar to ipchains by Rusty Russell.  The main difference is
-that the chains 
+that the chains
 .B INPUT
 and
 .B OUTPUT
@@ -940,7 +971,7 @@
 passes through one of the three chains; previously a forwarded packet
 would pass through all three.
 .PP
-The other main difference is that 
+The other main difference is that
 .B -i
 refers to the input interface;
 .B -o
@@ -967,7 +998,7 @@
 .BR iptables-restore (8),
 .BR ip6tables (8),
 .BR ip6tables-save (8),
-.BR ip6tables-restore(8).
+.BR ip6tables-restore (8).
 .P
 The packet-filtering-HOWTO details iptables usage for
 packet filtering, the NAT-HOWTO details NAT,

--------------Boundary-00=_MMI99RJTO2KD7OTS9RFV--
