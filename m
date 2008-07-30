From: Greg KH <gregkh@suse.de>
Subject: [patch 28/29] netfilter -stable: nf_conntrack_tcp: fix endless loop
Date: Wed, 30 Jul 2008 16:27:45 -0700
Message-ID: <20080730232745.GC30670@suse.de>
References: <20080730231003.655833364@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761878AbYG3XnG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 19:43:06 -0400
Content-Disposition: inline; filename="netfilter-stable-nf_conntrack_tcp-fix-endless-loop.patch"
In-Reply-To: <20080730232451.GA30670@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


2.6.25-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Patrick McHardy <kaber@trash.net>

netfilter: nf_conntrack_tcp: fix endless loop

Upstream commit 6b69fe0:

When a conntrack entry is destroyed in process context and destruction
is interrupted by packet processing and the packet is an attempt to
reopen a closed connection, TCP conntrack tries to kill the old entry
itself and returns NF_REPEAT to pass the packet through the hook
again. This may lead to an endless loop: TCP conntrack repeatedly
finds the old entry, but can not kill it itself since destruction
is already in progress, but destruction in process context can not
complete since TCP conntrack is keeping the CPU busy.

Drop the packet in TCP conntrack if we can't kill the connection
ourselves to avoid this.

Reported by: hemao77@gmail.com [ Kernel bugzilla #11058 ]
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nf_conntrack_proto_tcp.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -845,9 +845,15 @@ static int tcp_packet(struct nf_conn *ct
 			/* Attempt to reopen a closed/aborted connection.
 			 * Delete this connection and look up again. */
 			write_unlock_bh(&tcp_lock);
-			if (del_timer(&ct->timeout))
+			/* Only repeat if we can actually remove the timer.
+			 * Destruction may already be in progress in process
+			 * context and we must give it a chance to terminate.
+			 */
+			if (del_timer(&ct->timeout)) {
 				ct->timeout.function((unsigned long)ct);
-			return -NF_REPEAT;
+				return -NF_REPEAT;
+			}
+			return -NF_DROP;
 		}
 		/* Fall through */
 	case TCP_CONNTRACK_IGNORE:

-- 
