From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [conntrack-tools PATCH 2/4] conntrackd.8: refresh file
Date: Tue, 30 Aug 2016 14:20:40 +0200
Message-ID: <147255964026.17411.7049644478920588118.stgit@nfdev2.cica.es>
References: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:37033 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758262AbcH3MUh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 08:20:37 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 94A0651F14A
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 12:20:34 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dXVBiVL_u-qD for <netfilter-devel@vger.kernel.org>;
        Tue, 30 Aug 2016 14:20:28 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id BFDDE51EC20
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 14:20:28 +0200 (CEST)
In-Reply-To: <147255963490.17411.649527820452381341.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Refresh conntrackd.8 manpage to match the help message in the binary.

Changes are related to the syntax and options of conntrackd,
the syntax of the manpage itself and clarification of some aspects.

Also, break lines at 80 characters.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 conntrackd.8 |  158 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 104 insertions(+), 54 deletions(-)

diff --git a/conntrackd.8 b/conntrackd.8
index 3bb4335..bd195ec 100644
--- a/conntrackd.8
+++ b/conntrackd.8
@@ -1,86 +1,111 @@
-.TH CONNTRACKD 8 "Nov 19, 2015" "" ""
+.TH CONNTRACKD 8 "Aug 30, 2016" "" ""
 
 .\" Man page written by Pablo Neira Ayuso <pablo@netfilter.org> (Dec 2007)
 
 .SH NAME
 conntrackd \- netfilter connection tracking user-space daemon
+
 .SH SYNOPSIS
 .BR "conntrackd [options]"
+
 .SH DESCRIPTION
-.B conntrackd
-is the user-space daemon for the netfilter connection tracking system. This daemon synchronizes connection tracking states between several replica firewalls. Thus,
-.B conntrackd 
-can be used to deploy highly available stateful firewalls. The daemon supports Primary-Backup and Multiprimary setups. The daemon can also be used as statistics collector.
+\fBconntrackd\fP is the user-space daemon for the netfilter connection
+tracking system. This daemon synchronizes connection tracking states between
+several replica firewalls. Thus, \fBconntrackd\fP can be used to deploy highly
+available stateful firewalls.
+
+The daemon supports Primary-Backup and Multiprimary setups and can also be used
+as statistics collector.
+
 .SH OPTIONS
-The options recognized by
-.B conntrackd
-can be divided into several different groups.
-.SS MODES
-These options specify the particular operation mode in which conntrackd runs. Only one of them can be specified at any given time.
-.TP
-.BI "-d "
-Run conntrackd in daemon mode.
+The options recognized by \fBconntrackd\fP can be divided into two different
+groups.
+
+.SS GEMERAL OPTIONS
+General options for the \fBconntrackd\fP daemon.
+
+.TP
+.BI "-d"
+Run \fBconntrackd\fP in daemon mode (fork to background).
+
+.TP
+.BI "-C <path>"
+Load config file specified in \fIpath\fP. See \fBconntrackd.conf(5)\fP for
+details.
+
+.TP
+.BI "-v"
+Display version information.
+
+.TP
+.BI "-h"
+Display help information.
+
 .SS CLIENT COMMANDS
-.B conntrackd 
-can be used in client mode to request several information and operations to a running daemon
+\fBconntrackd\fP can be used in client mode to request several information and
+operations to a running instance of the daemon.
+
 .TP
-.BI "-i " "[ct|expect]"
+.BI "-i [ct|expect]"
 Dump the internal cache, i.e. show local states
+
 .TP
-.BI "-e " "[ct|expect]"
+.BI "-e [ct|expect]"
 Dump the external cache, i.e. show foreign states
+
 .TP
-.BI "-x "
+.BI "-x"
 Display output in XML format. This option is only valid in combination
-with "\-i" and "\-e" parameters.
+with \fB\-i\fP and \fB\-e\fP parameters.
+
 .TP
-.BI "-f " "[internal|external]"
+.BI "-f [internal|external]"
 Flush the internal and/or external cache
+
 .TP
 .BI "-F [ct|expect]"
 Flush the kernel conntrack table (if you use a Linux kernel >= 2.6.29, this
 option will not flush your internal and external cache).
 .TP
-.BI "-c "
+.BI "-c"
 Commit external cache to conntrack table.
 .TP
-.BI "-B "
+.BI "-B"
 Force a bulk send to other replica firewalls. With this command, you will
 ask conntrackd to send the state-entries that it owns to others.
 .TP
-.BI "-n "
+.BI "-n"
 Request resync with other node (only FT-FW and NOTRACK modes).
 .TP
-.BI "-k "
+.BI "-k"
 Kill the daemon
 .TP
-.BI "-s " "[network|cache|runtime|link|rsqueue|process|queue|ct|expect]"
+.BI "-s [network|cache|runtime|link|rsqueue|process|queue|ct|expect]"
 Dump statistics. If no parameter is passed, it displays the general statistics.
+.br
 If "network" is passed as parameter it displays the networking statistics.
+.br
 If "cache" is passed as parameter, it shows the extended cache statistics.
+.br
 If "runtime" is passed as parameter, it shows the run-time statistics.
+.br
 If "process" is passed as parameter, it shows existing child processes (if any).
+.br
 If "queue" is passed as parameter, it shows queue statistics.
+.br
 If "ct" is passed, it displays the general statistics.
+.br
 If "expect" is passed as parameter, it shows expectation statistics.
 .TP
-.BI "-R " "[ct|expect]"
+.BI "-R [ct|expect]"
 Force a resync against the kernel connection tracking table
 .TP
-.BI "-t "
+.BI "-t"
 Reset the in-kernel timers (See PurgeTimeout clause)
-.TP
-.BI "-v "
-Display version information.
-.TP
-.BI "-h "
-Display help information.
-.TP
-.BI "-C config file"
-Configuration file path. See \fBconntrackd.conf(5)\fP for details.
-.TP
+
 .SH DIAGNOSTICS
 The exit code is 0 for correct function. Errors cause an exit code of 1.
+
 .SH EXAMPLES
 The following example are illustrative, for a real use in a firewall fail-over,
 check the primary-backup.sh script that comes with the sources.
@@ -89,33 +114,58 @@ check the primary-backup.sh script that comes with the sources.
 Runs conntrackd in daemon and synchronization mode
 .TP
 .B conntrackd \-i
-Dumps the states held in the internal cache, i.e. those handled by this firewall
+Dumps the states held in the internal cache, i.e. those handled by this
+firewall
 .TP
 .B conntrackd \-e
-Dumps the states held in the external cache, i.e. those handled by other replica firewalls
+Dumps the states held in the external cache, i.e. those handled by other
+replica firewalls
 .TP
 .B conntrackd \-c
-Commits the external cache into the kernel connection tracking system. This is used to inject the state so that the connections can be recovered during the failover.
+Commits the external cache into the kernel connection tracking system.
+This is used to inject the state so that the connections can be recovered
+during the failover.
+
 .SH DEPENDENCIES
-This daemon requires a Linux kernel version >= 2.6.18. TCP window tracking support requires >= 2.6.22, otherwise you have to disable it. Helpers are fully supported since >= 2.6.25, however, if you use any previous version, depending on the protocol helper and your setup (e.g. if you setup performs NAT sequence adjustments or not), your help connection may be successfully recovered.
-.TP
-There are several unsupported stateful iptables matches such as recent, connbytes and the quota matches which gather internal information to operate. Since that information does not belong to the domain of the connection tracking system, connections affected by those matches may not be fully recovered during the takeover.
-.TP
-The daemon requires a Linux kernel version >= 2.6.26 to support kernel-space event filtering. Otherwise, all the event filtering is done in userspace with the corresponding extra overhead. If you are not using the Filter clause in the configuration file, ignore this notice.
+This daemon requires a Linux kernel version >= 2.6.18. TCP window tracking
+support requires >= 2.6.22, otherwise you have to disable it.
+Helpers are fully supported since >= 2.6.25, however, if you use any previous
+version, depending on the protocol helper and your setup (e.g. if you setup
+performs NAT sequence adjustments or not), your help connection may be
+successfully recovered.
+
+There are several unsupported stateful iptables matches such as recent,
+connbytes and the quota matches which gather internal
+information to operate. Since that information does not belong to the
+domain of the connection tracking system, connections affected by
+those matches may not be fully recovered during the takeover.
+
+The daemon requires a Linux kernel version >= 2.6.26 to support kernel-space
+event filtering. Otherwise, all the event filtering is done in userspace with
+the corresponding extra overhead. If you are not using the Filter clause in
+the configuration file, ignore this notice.
+
 .SH INCOMPATIBILITIES
-During the 0.9.9 development, some important changes in the replication message format were introduced. Therefore, conntrackd >= 0.9.9 will not work appropriately with conntrackd <= 0.9.8. This should not be a problem if you use the same
-conntrackd version in all the firewall replica nodes.
+During the 0.9.9 development, some important changes in the replication message
+format were introduced. Therefore, \fBconntrackd\fP >= 0.9.9 will not work
+appropriately with \fBconntrackd\fP <= 0.9.8.
+
+This should not be a problem if you use the same conntrackd version in all
+the firewall replica nodes.
+
 .SH SEE ALSO
-.BR conntrack (8), iptables (8), conntrackd.conf (5)
+.BR conntrackd.conf(5)
+.BR conntrack(8)
+.BR iptables(8)
+.BR nft(8)
 .br
-See
-.BR "http://conntrack-tools.netfilter.org"
+.BR http://conntrack-tools.netfilter.org
+
 .SH BUGS
-Please, report them to netfilter-devel@vger.kernel.org or file a bug in
-Netfilter's bugzilla (https://bugzilla.netfilter.org).
+Please, report them to netfilter-devel@vger.kernel.org (subscription required)
+or file a bug in Netfilter's bugzilla (https://bugzilla.netfilter.org).
+
 .SH AUTHORS
 Pablo Neira Ayuso wrote and maintains the conntrackd tool
-.TP
-Please send bug reports to <netfilter-devel@lists.netfilter.org>. Subscription is required.
 .PP
 Man page written by Pablo Neira Ayuso <pablo@netfilter.org>.

