From: Martin Topholm <mph@one.com>
Subject: [PATCH] extensions: libxt_SYNPROXY: initial manual page
Date: Thu, 30 Jan 2014 14:47:26 +0100
Message-ID: <1391089646-6048-1-git-send-email-mph@one.com>
Cc: fwestpha@redhat.com, jbrouer@redhat.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kontorsmtp2.one.com ([195.47.247.17]:59450 "EHLO
	kontorsmtp2.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaA3N4f (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:56:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Martin Topholm <mph@one.com>
---
 extensions/libxt_SYNPROXY.man | 64 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 extensions/libxt_SYNPROXY.man

diff --git a/extensions/libxt_SYNPROXY.man b/extensions/libxt_SYNPROXY.man
new file mode 100644
index 0000000..d10561a
--- /dev/null
+++ b/extensions/libxt_SYNPROXY.man
@@ -0,0 +1,64 @@
+This target will process TCP three-way-handshake parallel in netfilter
+context to protect either local or backend system. The netfilter system
+will need to be inline because sequence numbers need to be translated.
+.TP
+\fB\-\-mss\fP \fImaximum segment size\fP
+Maximum segment size announced to clients. This must match the backend.
+.TP
+\fB\-\-wscale\fP \fIwindow scale\fP
+Window scale announced to clients. This must match the backend.
+.TP
+\fB\-\-sack\-perm\fP
+Pass client selective acknowledgement option to backend (will be disabled
+if not present).
+.TP
+\fB\-\-timestamps\fP
+Pass client timestamp option to backend (will be disabled if not present,
+also needed for selective acknowledgement and window scaling).
+.PP
+Example:
+.PP
+Determine tcp options used by backend, from an external system
+.IP
+tcpdump -pni eth0 -c 1 'tcp[tcpflags] == (tcp-syn|tcp-ack)'
+.br
+    port 80 &
+.br
+telnet 192.0.2.42 80
+.br
+18:57:24.693307 IP 192.0.2.42.80 > 192.0.2.43.48757:
+.br
+    Flags [S.], seq 360414582, ack 788841994, win 14480,
+.br
+    options [mss 1460,sackOK,
+.br
+    TS val 1409056151 ecr 9690221,
+.br
+    nop,wscale 9],
+.br
+    length 0
+.PP
+Switch tcp_loose mode off, so conntrack will mark out\-of\-flow
+packets as state INVALID.
+.IP
+echo 0 > /proc/sys/net/netfilter/nf_conntrack_tcp_loose
+.PP
+Make SYN packets untracked
+.IP
+iptables \-t raw \-A PREROUTING \-i eth0 \-p tcp \-\-dport 80
+    \-\-syn \-j CT \-\-notrack
+.PP
+Catch UNTRACKED (SYN packets) and INVALID (3WHS ACK packets) states
+and send them to SYNPROXY. This rule will respond to SYN packets with
+SYN+ACK syncookies, create ESTABLISHED for valid client response (3WHS ACK
+packets) and drop incorrect cookies. Flags combinations not expected
+during 3WHS will not match and continue (e.g. SYN+FIN, SYN+ACK).
+.IP
+iptables \-A INPUT \-i eth0 \-p tcp \-\-dport 80
+    \-m state \-\-state UNTRACKED,INVALID \-j SYNPROXY
+    \-\-sack\-perm \-\-timestamp \-\-mss 1460 \-\-wscale 9
+.PP
+Drop invalid packets, this will be out\-of\-flow packets that were not
+matched by SYNPROXY.
+.IP
+iptables \-A INPUT \-i eth0 \-p tcp \-\-dport 80 \-m state \-\-state INVALID \-j DROP
