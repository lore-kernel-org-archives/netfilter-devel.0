From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: [conntrack-tools PATCH] conntrack.8: refresh manpage
Date: Tue, 26 Sep 2017 16:13:11 +0200
Message-ID: <150643519168.18491.3930073686511669659.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57118 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966668AbdIZON0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2017 10:13:26 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id DD12651F44C
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 14:13:23 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TLGbrzE_E3hH for <netfilter-devel@vger.kernel.org>;
        Tue, 26 Sep 2017 16:13:12 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:13::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 5322451F438
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2017 16:13:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refresh manpage, fixing typos, rearranging some sentences, introducing line
breaks at max. 80 columns, markup fixes, and so on.

Apart of some minor cosmetics fixes, no actual content is changed.

Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
---
 conntrack.8 |  167 ++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 101 insertions(+), 66 deletions(-)

diff --git a/conntrack.8 b/conntrack.8
index e8e4480..e069dfe 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -1,4 +1,4 @@
-.TH CONNTRACK 8 "Aug 24, 2015" "" ""
+.TH CONNTRACK 8 "Sep 26, 2017" "" ""
 
 .\" Man page written by Harald Welte <laforge@netfilter.org (Jun 2005)
 .\" Maintained by Pablo Neira Ayuso <pablo@netfilter.org (May 2007)
@@ -24,17 +24,20 @@ conntrack \- command line interface for netfilter connection tracking
 .br
 .BR "conntrack -S "
 .SH DESCRIPTION
-.B conntrack
-provides a full featured userspace interface to the netfilter connection tracking system that is intended to replace the old /proc/net/ip_conntrack interface. This tool can be used to search, list, inspect and maintain the connection tracking subsystem of the Linux kernel.
-Using 
-.B conntrack
-, you can dump a list of all (or a filtered selection of) currently tracked
-connections, delete connections from the state table, and even add new ones.
-.PP
+The \fBconntrack\fP utilty provides a full featured userspace interface to the
+Netfilter connection tracking system that is intended to replace the old
+/proc/net/ip_conntrack interface. This tool can be used to search, list,
+inspect and maintain the connection tracking subsystem of the Linux kernel.
+
+Using \fBconntrack\fP, you can dump a list of all (or a filtered selection of)
+currently tracked connections, delete connections from the state table, and
+even add new ones.
+
 In addition, you can also monitor connection tracking events, e.g. show an
 event message (one line) per newly established connection.
+
 .SH TABLES
-The connection tracking subsystem maintains two internal tables:
+The connection tracking subsystem maintains several internal tables:
 .TP
 .BR "conntrack" :
 This is the default table.  It contains a list of all currently tracked
@@ -44,30 +47,31 @@ through the system.
 .TP
 .BR "expect" :
 This is the table of expectations.  Connection tracking expectations are the
-mechanism used to "expect" RELATED connections to existing ones.  Expectations
-are generally used by "connection tracking helpers" (sometimes called
-application level gateways [ALGs]) for more complex protocols such as FTP,
-SIP, H.323.
+mechanism used to "expect" \fBRELATED\fP connections to existing ones.
+Expectations are generally used by "connection tracking helpers" (sometimes
+called application level gateways [ALGs]) for more complex protocols such as
+FTP, SIP or H.323.
 .TP
 .BR "dying" :
 This table shows the conntrack entries, that have expired and that have been
-destroyed by the connection tracking system itself, or via the conntrack utility.
+destroyed by the connection tracking system itself, or via the \fBconntrack\fP
+utility.
 .TP
 .BR "unconfirmed" :
-This table shows new entries, that are not yet inserted into the conntrack table.
-These entries are attached to packets that are traversing the stack,
+This table shows new entries, that are not yet inserted into the conntrack
+table. These entries are attached to packets that are traversing the stack,
 but did not reach the confirmation point at the postrouting hook.
-.PP
-The tables "dying" and "unconfirmed" are basically only useful for debugging purposes.
-Under normal operation, it is hard to see entries in any of them.
+
+The tables "dying" and "unconfirmed" are basically only useful for debugging
+purposes. Under normal operation, it is hard to see entries in any of them.
 There are corner cases, where it is valid to see entries in the
 unconfirmed table, eg. when packets that are enqueued via nfqueue, and
-the dying table, eg. when conntrackd runs in event reliable mode.
-.PP
+the dying table, eg. when \fBconntrackd(8)\fP runs in event reliable mode.
+
 .SH OPTIONS
-The options recognized by 
-.B conntrack
-can be divided into several different groups.
+The options recognized by \fBconntrack\fP can be divided into several different
+groups.
+
 .SS COMMANDS
 These options specify the particular operation to perform.  Only one of them
 can be specified at any given time.
@@ -98,6 +102,7 @@ Show the table counter.
 .TP
 .BI "-S, --stats "
 Show the in-kernel connection tracking system statistics.
+
 .SS PARAMETERS
 .TP
 .BI "-z, --zero "
@@ -107,9 +112,9 @@ combination with the "\-L, \-\-dump" command options.
 .BI "-o, --output [extended,xml,timestamp,id,ktimestamp,labels] "
 Display output in a certain format. With the extended output option, this tool
 displays the layer 3 information. With ktimestamp, it displays the in-kernel
-timestamp available since 2.6.38 (you can enable it via echo 1 >
-/proc/sys/net/netfilter/nf_conntrack_timestamp).
-The labels output option tells conntrack to show the names of connection
+timestamp available since 2.6.38 (you can enable it via the \fBsysctl(8)\fP
+key \fBnet.netfilter.nf_conntrack_timestamp\fP).
+The labels output option tells \fBconntrack\fP to show the names of connection
 tracking labels that might be present.
 .TP
 .BI "-e, --event-mask " "[ALL|NEW|UPDATES|DESTROY][,...]"
@@ -119,58 +124,66 @@ by the kernel to those types to those that you are actually interested in.
 .
 This option can only be used in conjunction with "\-E, \-\-event".
 .TP
-.BI "-b, --buffer-size " "value (in bytes)"
-Set the Netlink socket buffer size. This option is useful if the command line
-tool reports ENOBUFS errors. If you do not pass this option, the default value
-available at /proc/sys/net/core/rmem_default is used. The tool reports this
-problem if your process is too slow to handle all the event messages or, in 
-other words, if the amount of events are big enough to overrun the socket 
-buffer. Note that using a big buffer reduces the chances to hit ENOBUFS, 
-however, this results in more memory consumption.
+.BI "-b, --buffer-size " "value"
+Set the Netlink socket buffer size in bytes. This option is useful if the
+command line tool reports ENOBUFS errors. If you do not pass this option, the
+default value available at \fBsysctl(8)\fP key \fBnet.core.rmem_default\fP is
+used. The tool reports this problem if your process is too slow to handle all
+the event messages or, in other words, if the amount of events are big enough
+to overrun the socket buffer. Note that using a big buffer reduces the chances
+to hit ENOBUFS, however, this results in more memory consumption.
 .
 This option can only be used in conjunction with "\-E, \-\-event".
+
 .SS FILTER PARAMETERS
 .TP
 .BI "-s, --src, --orig-src " IP_ADDRESS
-Match only entries whose source address in the original direction equals the one specified as argument.
-Implies "--mask-src" when CIDR notation is used.
+Match only entries whose source address in the original direction equals the
+one specified as argument. Implies "--mask-src" when CIDR notation is used.
 .TP
 .BI "-d, --dst, --orig-dst " IP_ADDRESS
-Match only entries whose destination address in the original direction equals the one specified as argument.
-Implies "--mask-dst" when CIDR notation is used.
+Match only entries whose destination address in the original direction equals
+the one specified as argument. Implies "--mask-dst" when CIDR notation is used.
 .TP
 .BI "-r, --reply-src " IP_ADDRESS
-Match only entries whose source address in the reply direction equals the one specified as argument.
+Match only entries whose source address in the reply direction equals the one
+specified as argument.
 .TP
 .BI "-q, --reply-dst " IP_ADDRESS
-Match only entries whose destination address in the reply direction equals the one specified as argument.
+Match only entries whose destination address in the reply direction equals the
+one specified as argument.
 .TP
 .BI "-p, --proto " "PROTO "
 Specify layer four (TCP, UDP, ...) protocol.
 .TP
 .BI "-f, --family " "PROTO"
 Specify layer three (ipv4, ipv6) protocol
-This option is only required in conjunction with "\-L, \-\-dump". If this option is not passed, the default layer 3 protocol will be IPv4.
+This option is only required in conjunction with "\-L, \-\-dump". If this
+option is not passed, the default layer 3 protocol will be IPv4.
 .TP
 .BI "-t, --timeout " "TIMEOUT"
 Specify the timeout.
 .TP
 .BI "-m, --mark " "MARK[/MASK]"
 Specify the conntrack mark.  Optionally, a mask value can be specified.
-In "\-\-update" mode, this mask specifies the bits that should be zeroed before XORing
-the MARK value into the ctmark.
-Otherwise, the mask is logically ANDed with the existing mark before the comparision.
-In "\-\-create" mode, the mask is ignored.
+In "\-\-update" mode, this mask specifies the bits that should be zeroed before
+XORing the MARK value into the ctmark.
+Otherwise, the mask is logically ANDed with the existing mark before the
+comparision. In "\-\-create" mode, the mask is ignored.
 .TP
 .BI "-l, --label " "LABEL"
 Specify a conntrack label.
-This option is only available in conjunction with "\-L, \-\-dump", "\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
+This option is only available in conjunction with "\-L, \-\-dump",
+"\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
 Match entries whose labels match at least those specified.
 Use multiple \-l commands to specify multiple labels that need to be set.
 Match entries whose labels matches at least those specified as arguments.
+.TP
 .BI "--label-add " "LABEL"
 Specify the conntrack label to add to to the selected conntracks.
-This option is only available in conjunction with "\-I, \-\-create" or "\-U, \-\-update".
+This option is only available in conjunction with "\-I, \-\-create" or
+"\-U, \-\-update".
+.TP
 .BI "--label-del " "[LABEL]"
 Specify the conntrack label to delete from the selected conntracks.
 If no label is given, all labels are deleted.
@@ -183,10 +196,10 @@ Specify the conntrack selinux security mark.
 Specify the conntrack status.
 .TP
 .BI "-n, --src-nat "
-Filter source NAT connections. 
+Filter source NAT connections.
 .TP
 .BI "-g, --dst-nat "
-Filter destination NAT connections. 
+Filter destination NAT connections.
 .TP
 .BI "-j, --any-nat "
 Filter any NAT connections.
@@ -212,12 +225,15 @@ Implies "--mask-dst" when CIDR notation is used.
 .TP
 .BI "--mask-src " IP_ADDRESS
 Specify the source address mask.
-For conntrack this option is only available in conjunction with "\-L, \-\-dump", "\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
-For expectations this option is only available in conjunction with "\-I, \-\-create".
+For conntracks this option is only available in conjunction with
+"\-L, \-\-dump", "\-E, \-\-event", "\-U \-\-update" or "\-D \-\-delete".
+For expectations this option is only available in conjunction with
+"\-I, \-\-create".
 .TP
 .BI "--mask-dst " IP_ADDRESS
 Specify the destination address mask.
 Same limitations as for "--mask-src".
+
 .SS PROTOCOL FILTER PARAMETERS
 .TP
 TCP-specific fields:
@@ -234,8 +250,10 @@ Source port in reply direction
 .BI "--reply-port-dst " "PORT"
 Destination port in reply direction
 .TP
-.BI "--state " "[NONE | SYN_SENT | SYN_RECV | ESTABLISHED | FIN_WAIT | CLOSE_WAIT | LAST_ACK | TIME_WAIT | CLOSE | LISTEN]"
-TCP state
+.BI "--state " "state"
+TCP state, one of NONE, SYN_SENT, SYN_RECV, ESTABLISHED, FIN_WAIT, CLOSE_WAIT,
+LAST_ACK, TIME_WAIT, CLOSE or LISTEN.
+
 .TP
 UDP-specific fields:
 .TP
@@ -250,6 +268,7 @@ Source port in reply direction
 .TP
 .BI "--reply-port-dst " "PORT"
 Destination port in reply direction
+
 .TP
 ICMP-specific fields:
 .TP
@@ -261,6 +280,7 @@ ICMP Code. Has to be specified numerically.
 .TP
 .BI "--icmp-id " "ID"
 ICMP Id. Has to be specified numerically (non-mandatory)
+
 .TP
 UDPlite-specific fields:
 .TP
@@ -275,6 +295,7 @@ Source port in reply direction
 .TP
 .BI "--reply-port-dst " "PORT"
 Destination port in reply direction
+
 .TP
 SCTP-specific fields:
 .TP
@@ -290,14 +311,16 @@ Source port in reply direction
 .BI "--reply-port-dst " "PORT"
 Destination port in reply direction
 .TP
-.BI "--state " "[NONE | CLOSED | COOKIE_WAIT | COOKIE_ECHOED | ESTABLISHED | SHUTDOWN_SENT | SHUTDOWN_RECD | SHUTDOWN_ACK_SENT]"
-SCTP state
+.BI "--state " "state"
+SCTP state, one of NONE, CLOSED, COOKIE_WAIT, COOKIE_ECHOED, ESTABLISHED,
+SHUTDOWN_SENT, SHUTDOWN_RECD, SHUTDOWN_ACK_SENT.
 .TP
 .BI "--orig-vtag " "value"
 Verification tag (32-bits value) in the original direction
 .TP
 .BI "--reply-vtag " "value"
 Verification tag (32-bits value) in the reply direction
+
 .TP
 DCCP-specific fields (needs Linux >= 2.6.30):
 .TP
@@ -313,10 +336,13 @@ Source port in reply direction
 .BI "--reply-port-dst " "PORT"
 Destination port in reply direction
 .TP
-.BI "--state " "[NONE | REQUEST | RESPOND | PARTOPEN | OPEN | CLOSEREQ | CLOSING | TIMEWAIT]"
-DCCP state
-.BI "--role " "[client | server]"
+.BI "--state " "state"
+DCCP state, one of NONE, REQUEST, RESPOND, PARTOPEN, OPEN, CLOSEREQ, CLOSING,
+TIMEWAIT.
+.TP
+.BI "--role " "[client|server]"
 Role that the original conntrack tuple is tracking
+
 .TP
 GRE-specific fields:
 .TP
@@ -331,24 +357,27 @@ Source key in reply direction (in hexadecimal or decimal)
 .TP
 .BI "--reply-key-dst " "KEY"
 Destination key in reply direction (in hexadecimal or decimal)
-.TP
+
 .SH DIAGNOSTICS
 The exit code is 0 for correct function.  Errors which appear to be caused by
 invalid command line parameters cause an exit code of 2.  Any other errors
 cause an exit code of 1.
+
 .SH EXAMPLES
 .TP
 .B conntrack \-L
 Show the connection tracking table in /proc/net/ip_conntrack format
 .TP
 .B conntrack \-L -o extended
-Show the connection tracking table in /proc/net/nf_conntrack format
+Show the connection tracking table in /proc/net/nf_conntrack format, with
+additional information.
 .TP
 .B conntrack \-L \-o xml
 Show the connection tracking table in XML
 .TP
 .B conntrack \-L -f ipv6 -o extended
-Only dump IPv6 connections in /proc/net/nf_conntrack format
+Only dump IPv6 connections in /proc/net/nf_conntrack format, with
+additional information.
 .TP
 .B conntrack \-L --src-nat
 Show source NAT connections
@@ -361,17 +390,23 @@ Delete all flow whose source address is 1.2.3.4
 .TP
 .B conntrack \-U \-s 1.2.3.4 \-m 1
 Set connmark to 1 of all the flows whose source address is 1.2.3.4
+
 .SH BUGS
 Please, report them to netfilter-devel@vger.kernel.org or file a bug in
 Netfilter's bugzilla (https://bugzilla.netfilter.org).
+
 .SH SEE ALSO
-.BR iptables (8)
+.BR nftables (8), iptables (8), conntrackd(8)
 .br
 See
 .BR "http://conntrack-tools.netfilter.org"
+
 .SH AUTHORS
-Jay Schulist, Patrick McHardy, Harald Welte and Pablo Neira Ayuso wrote the kernel-level "ctnetlink" interface that is used by the conntrack tool.
+Jay Schulist, Patrick McHardy, Harald Welte and Pablo Neira Ayuso wrote the
+kernel-level "ctnetlink" interface that is used by the conntrack tool.
 .PP
-Pablo Neira Ayuso wrote and maintain the conntrack tool, Harald Welte added support for conntrack based accounting counters.
+Pablo Neira Ayuso wrote and maintain the conntrack tool, Harald Welte added
+support for conntrack based accounting counters.
 .PP
-Man page written by Harald Welte <laforge@netfilter.org> and Pablo Neira Ayuso <pablo@netfilter.org>.
+Man page written by Harald Welte <laforge@netfilter.org> and
+Pablo Neira Ayuso <pablo@netfilter.org>.

