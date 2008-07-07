From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH -stable 02/02]: netfilter: nf_conntrack_tcp: fixing to check
 the lower bound of valid ACK
Date: Mon, 07 Jul 2008 15:57:03 +0200
Message-ID: <487220AF.5070204@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060809080707000904000401"
Cc: "David S. Miller" <davem@davemloft.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61403 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbYGGN5G (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 09:57:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060809080707000904000401
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------060809080707000904000401
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="02.diff"

netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid ACK

Upstream commit 84ebe1c:

Lost connections was reported by Thomas Bätzler (running 2.6.25 kernel) on
the netfilter mailing list (see the thread "Weird nat/conntrack Problem
with PASV FTP upload"). He provided tcpdump recordings which helped to
find a long lingering bug in conntrack.

In TCP connection tracking, checking the lower bound of valid ACK could
lead to mark valid packets as INVALID because:

 - We have got a "higher or equal" inequality, but the test checked
   the "higher" condition only; fixed.
 - If the packet contains a SACK option, it could occur that the ACK
   value was before the left edge of our (S)ACK "window": if a previous
   packet from the other party intersected the right edge of the window
   of the receiver, we could move forward the window parameters beyond
   accepting a valid ack. Therefore in this patch we check the rightmost
   SACK edge instead of the ACK value in the lower bound of valid (S)ACK
   test.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 9524a965e043b5aac8770b39a0d444da30655ec4
tree 6f88f35682e10fad204228331ec89b50c6477577
parent 44e450bf173eee791911a56f7e65a30d94608cea
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Mon, 07 Jul 2008 15:52:48 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 07 Jul 2008 15:52:48 +0200

 net/netfilter/nf_conntrack_proto_tcp.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6256795..fc43e22 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -332,12 +332,13 @@ static unsigned int get_conntrack_index(const struct tcphdr *tcph)
 
    I.   Upper bound for valid data:	seq <= sender.td_maxend
    II.  Lower bound for valid data:	seq + len >= sender.td_end - receiver.td_maxwin
-   III.	Upper bound for valid ack:      sack <= receiver.td_end
-   IV.	Lower bound for valid ack:	ack >= receiver.td_end - MAXACKWINDOW
+   III.	Upper bound for valid (s)ack:   sack <= receiver.td_end
+   IV.	Lower bound for valid (s)ack:	sack >= receiver.td_end - MAXACKWINDOW
 
-   where sack is the highest right edge of sack block found in the packet.
+   where sack is the highest right edge of sack block found in the packet
+   or ack in the case of packet without SACK option.
 
-   The upper bound limit for a valid ack is not ignored -
+   The upper bound limit for a valid (s)ack is not ignored -
    we doesn't have to deal with fragments.
 */
 
@@ -607,12 +608,12 @@ static int tcp_in_window(const struct nf_conn *ct,
 		 before(seq, sender->td_maxend + 1),
 		 after(end, sender->td_end - receiver->td_maxwin - 1),
 		 before(sack, receiver->td_end + 1),
-		 after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+		 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
 
 	if (before(seq, sender->td_maxend + 1) &&
 	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
 	    before(sack, receiver->td_end + 1) &&
-	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
+	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
 		/*
 		 * Take into account window scaling (RFC 1323).
 		 */

--------------060809080707000904000401--
