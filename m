From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH-2.4] NF_REPEAT was ignored !
Date: Thu, 23 Oct 2003 18:03:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031023160302.GA13255@alpha.home.local>
References: <20031008094447.GL25743@sunbeam.de.gnumonks.org> <Pine.LNX.4.33.0310090854360.22077-100000@blackhole.kfki.hu> <20031022102556.GA10540@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@gnumonks.org
Content-Disposition: inline
In-Reply-To: <20031022102556.GA10540@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald !

Just replying to myself to state that vanilla 2.4.23-pre8 has the same problem
(linux-kernel cc'd for this matter), and the patch applies to it too. There is
a difference, though, because I found no user of NF_REPEAT in 2.4.23-pre8, so
as of today, no mainline code seems affected, but the bug is waiting for
someone to bite :-)

Please review, comment and/or apply.

Regards,
Willy

==== original mail below ====

On Wed, Oct 22, 2003 at 12:25:56PM +0200, Willy Tarreau wrote:
Hi,

after updating the production firewalls to handle the CW->CL state, I saw the
rate of drops decrease, but not as much as I would have expected it to.

I captured lots of data (/p/n/ip_conntrack, logs, tcpdump) and discovered
another problem with tcp_window_tracking that I could easily reproduce on
a lab : if a client reused a port too early, then the SYN/ACK from the
server was dropped, and the client could only connect after the next SYN
retransmit. I simply checked it with nc -p 1234 server 80. The first one
succeeds immediately, the second one needs 3 seconds to establish. There
is a logical explication to this :

The client completes a first connection to server:80 with spt=1234. A few
seconds later, he reuses the same port to initiate a new connection to the
server. The firewall still sees the connection in TIME_WAIT state, so its
state matrix switches it to SYN_SENT  (orig:sTW--(SY)-->sSS).

In ip_conntrack_proto_tcp.c:tcp_packet(), there is a test for this case. The
existing session is deleted and NF_REPEAT is returned so that the caller tries
again (here, ip_conntrack_core.c:ip_conntrack_in()). This one simply returns
the same code NF_REPEAT to its caller which will call it again (nf_iterate()).

The problem is that once ip_conntrack_in() is called again with the same pskb,
it already has its ->nfct filled, so ip_conntrack_in() immediately returns
NF_ACCEPT without doing any lookup. The result is that the SYN is passed to
the server, and the deleted session is not recreated. When the server replies
with a SYN/ACK, this one has no matching session it is blocked by the firewall
rules. Then, 3 seconds later, the client retransmits its SYN, which reaches
the firewall without any matching session, and correctly initiates a new one.

The solution is to correctly clear the ->nfct field in ip_conntrack_in() if
we return NF_REPEAT. This is what the following patch does. It's to be applied
to 2.4+POM-20030912, but I'm confident it may be easily applied and/or ported
to later versions.

I've not checked yet if the mainline conntrack code is also affected, but this
could be possible.

Regards,
Willy


--- ./net/ipv4/netfilter/ip_conntrack_core.c.orig	Tue Oct 21 14:21:08 2003
+++ ./net/ipv4/netfilter/ip_conntrack_core.c	Tue Oct 21 16:14:53 2003
@@ -856,6 +861,14 @@
 	IP_NF_ASSERT((*pskb)->nfct);
 
 	ret = proto->packet(ct, (*pskb)->nh.iph, (*pskb)->len, ctinfo);
+
+	if (ret == NF_REPEAT) {
+		/* we must loop here again */
+		nf_conntrack_put((*pskb)->nfct);
+		(*pskb)->nfct = NULL;
+		return ret;
+	}
+
 	if (ret == -1) {
 		/* Invalid */
 		nf_conntrack_put((*pskb)->nfct);
