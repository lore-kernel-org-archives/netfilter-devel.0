From: <gregkh@suse.de>
Subject: patch netfilter-nf_conntrack_tcp-fixing-to-check-the-lower-bound-of-valid-ack.patch added to 2.6.25-stable tree
Date: Wed, 16 Jul 2008 22:42:38 -0700
Message-ID: <20080717054639.481371454459@imap.suse.de>
References: <487220AF.5070204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
To: kadlec@blackhole.kfki.hu, davem@davemloft.net, kaber@trash.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYGQFql (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:46:41 -0400
In-Reply-To: <487220AF.5070204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a note to let you know that we have just queued up the patch ti=
tled

     Subject: netfilter: nf_conntrack_tcp: fixing to check the lower bo=
und of valid ACK

to the 2.6.25-stable tree.  Its filename is

     netfilter-nf_conntrack_tcp-fixing-to-check-the-lower-bound-of-vali=
d-ack.patch

A git repo of this tree can be found at=20
    http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-queue=
=2Egit;a=3Dsummary


=46rom stable-bounces@linux.kernel.org  Wed Jul 16 22:28:33 2008
=46rom: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Mon, 07 Jul 2008 15:57:03 +0200
Subject: netfilter: nf_conntrack_tcp: fixing to check the lower bound o=
f valid ACK
To: stable@kernel.org
Cc: Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>=
, "David S. Miller" <davem@davemloft.net>
Message-ID: <487220AF.5070204@trash.net>

=46rom: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Upstream commit 84ebe1c:

Lost connections was reported by Thomas B=C3=A4tzler (running 2.6.25 ke=
rnel) on
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
   accepting a valid ack. Therefore in this patch we check the rightmos=
t
   SACK edge instead of the ACK value in the lower bound of valid (S)AC=
K
   test.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/netfilter/nf_conntrack_proto_tcp.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -332,12 +332,13 @@ static unsigned int get_conntrack_index(
=20
    I.   Upper bound for valid data:	seq <=3D sender.td_maxend
    II.  Lower bound for valid data:	seq + len >=3D sender.td_end - rec=
eiver.td_maxwin
-   III.	Upper bound for valid ack:      sack <=3D receiver.td_end
-   IV.	Lower bound for valid ack:	ack >=3D receiver.td_end - MAXACKWIN=
DOW
+   III.	Upper bound for valid (s)ack:   sack <=3D receiver.td_end
+   IV.	Lower bound for valid (s)ack:	sack >=3D receiver.td_end - MAXAC=
KWINDOW
=20
-   where sack is the highest right edge of sack block found in the pac=
ket.
+   where sack is the highest right edge of sack block found in the pac=
ket
+   or ack in the case of packet without SACK option.
=20
-   The upper bound limit for a valid ack is not ignored -
+   The upper bound limit for a valid (s)ack is not ignored -
    we doesn't have to deal with fragments.
 */
=20
@@ -607,12 +608,12 @@ static int tcp_in_window(const struct nf
 		 before(seq, sender->td_maxend + 1),
 		 after(end, sender->td_end - receiver->td_maxwin - 1),
 		 before(sack, receiver->td_end + 1),
-		 after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+		 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
=20
 	if (before(seq, sender->td_maxend + 1) &&
 	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
 	    before(sack, receiver->td_end + 1) &&
-	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
+	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
 		/*
 		 * Take into account window scaling (RFC 1323).
 		 */


Patches currently in stable-queue which might be from kadlec@blackhole.=
kfki.hu are

queue-2.6.25/netfilter-nf_conntrack_tcp-fixing-to-check-the-lower-bound=
-of-valid-ack.patch
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
