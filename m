From: Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables next 1/4] extensions: libxt_socket: update man page
Date: Mon, 15 Jul 2013 00:29:59 +0200
Message-ID: <1373841002-19071-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50933 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab3GNWaM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:30:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Document --nowildcard option and its implications when using -m socket
to intercept packets.

While at it, update man page with Balazs Scheidlers comments from
nf_tproxy_core.h in kernel tree to better explain how lookup is performed.

Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_socket.man | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_socket.man b/extensions/libxt_socket.man
index 41e8d67..2ef32ce 100644
--- a/extensions/libxt_socket.man
+++ b/extensions/libxt_socket.man
@@ -1,5 +1,22 @@
-This matches if an open socket can be found by doing a socket lookup on the
-packet.
+This matches if an open TCP/UDP socket can be found by doing a socket lookup on the
+packet. It matches if there is an established or non\-zero bound listening
+socket (possibly with a non\-local address). The lookup is performed using
+the \fBpacket\fP tuple of TCP/UDP packets, or the original TCP/UDP header
+\fBembedded\fP in an ICMP/ICPMv6 error packet.
 .TP
 \fB\-\-transparent\fP
 Ignore non-transparent sockets.
+.TP
+\fB\-\-nowildcard\fP
+Do not ignore sockets bound to 'any' address.
+The socket match won't accept zero\-bound listeners by default, since
+then local services could intercept traffic that would otherwise be forwarded.
+This option therefore has security implications when used to match traffic being
+forwarded to redirect such packets to local machine with policy routing.
+When using the socket match to implement fully transparent
+proxies bound to non\-local addresses it is recommended to use the \-\-transparent
+option instead.
+.PP
+Example (assuming packets with mark 1 are delivered locally):
+.IP
+\-t mangle \-A PREROUTING \-m socket \-\-transparent \-j MARK \-\-set\-mark 1
-- 
1.8.1.5

