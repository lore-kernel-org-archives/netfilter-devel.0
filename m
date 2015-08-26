From: Arturo Borrero Gonzalez <aborrero@cica.es>
Subject: [conntrack-tools PATCH] tcp: use MSG_NOSIGNAL in sendto() to avoid
 SIGPIPE
Date: Wed, 26 Aug 2015 14:14:00 +0200
Message-ID: <20150826121400.14339.57368.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:34294 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751887AbbHZMOI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 08:14:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

When running a pair of conntrackd nodes, in NOTRACK/tcp sync mode, and one
conntrackd instance is shut down this can happen:

[...]
Program received signal SIGPIPE, Broken pipe.
0x00007ffff6ef99d3 in __sendto_nocancel () at ../sysdeps/unix/syscall-template.S:82
(gdb) bt
#0  0x00007ffff6ef99d3 in __sendto_nocancel () at ../sysdeps/unix/syscall-template.S:82
#1  0x0000000000416744 in tcp_send (m=0x657470, data=0x656e90, size=1436) at tcp.c:304
#2  0x0000000000416b8c in channel_tcp_send (channel=<optimized out>, data=<optimized out>, len=<optimized out>) at channel_tcp.c:47
#3  0x00000000004159ac in channel_send (c=0x656e60, net=0x64b3a0) at channel.c:241
#4  0x00000000004184ee in internal_bypass_ct_event_del (ct=<optimized out>, origin=<optimized out>) at internal_bypass.c:148
#5  internal_bypass_ct_event_del (ct=0x654940, origin=6647440) at internal_bypass.c:139
#6  0x00000000004103c2 in event_handler (nlh=0x7fffffffb330, type=NFCT_T_DESTROY, ct=0x654940, data=<optimized out>) at ctnl.c:198
#7  0x00007ffff79c1afb in __callback (nlh=0x7fffffffb330, nfa=<optimized out>, data=0x654860) at callback.c:60
#8  0x00007ffff71ab06f in nfnl_step (h=h@entry=0x658e50, nlh=nlh@entry=0x7fffffffb330) at libnfnetlink.c:1341
#9  0x00007ffff71ab813 in nfnl_process (h=h@entry=0x658e50, buf=buf@entry=0x7fffffffb330 "\214", len=len@entry=140) at libnfnetlink.c:1386
#10 0x00007ffff71abb86 in nfnl_catch (h=0x658e50) at libnfnetlink.c:1540
#11 0x00007ffff79c2a2d in nfct_catch (h=<optimized out>) at api.c:1024
#12 0x0000000000410570 in event_cb (data=<optimized out>) at ctnl.c:330
#13 0x000000000040ddb4 in select_main_step (next_alarm=0x7fffffffd390) at fds.c:126
#14 select_main_loop () at fds.c:147
#15 0x0000000000409104 in main (argc=<optimized out>, argv=<optimized out>) at main.c:428
[...]

>From sendto(2):
 EPIPE  [...] the process will also receive a SIGPIPE unless MSG_NOSIGNAL is set

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 src/tcp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tcp.c b/src/tcp.c
index c8f2544..07f3e6d 100644
--- a/src/tcp.c
+++ b/src/tcp.c
@@ -301,7 +301,7 @@ ssize_t tcp_send(struct tcp_sock *m, const void *data, int size)
 			m->state = TCP_CLIENT_CONNECTED;
 		}
 	case TCP_CLIENT_CONNECTED:
-		ret = sendto(m->fd, data, size, 0,
+		ret = sendto(m->fd, data, size, MSG_NOSIGNAL,
 			     (struct sockaddr *) &m->addr, m->sockaddr_len);
 		if (ret == -1) {
 			if (errno == EPIPE || errno == ECONNRESET) {

