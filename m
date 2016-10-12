From: Ulrich Weber <ulrich.weber@gmail.com>
Subject: [RFC] SIP conntrack handler and TCP fragmentation
Date: Wed, 12 Oct 2016 09:38:00 +0200
Message-ID: <c92b64f3-9f69-eb7c-402c-3e489f73a527@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------833A8543A2CD2A5331BB9591"
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37124 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753371AbcJLHii (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2016 03:38:38 -0400
Received: by mail-wm0-f47.google.com with SMTP id b201so14661403wmb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2016 00:38:02 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------833A8543A2CD2A5331BB9591
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi all,

we had a customer with a Cisco Phone using SIP over TCP
which subscribed to 15 Phone numbers.

Since 15 subscribe calls dont fit in one packet, these
requests were fragmented in multiple TCP packets.

One of these fragments gets rejected then by nf_conntrack_sip with:
nf_ct_sip: dropping packet: cannot parse cseq

The Cisco phone will send retransmits, which got dropped too,
times out after some time, reconnects and same games
starts again...

I know the proper solution would be TCP defragmentation
in the nf_conntrack_sip kernel module. However I'm not
sure if this is worth the effort.
What about just accepting unparsable TCP SIP packets?

Cheers
 Ulrich

--------------833A8543A2CD2A5331BB9591
Content-Type: text/x-patch;
 name="0001-nf_conntrack_sip-relax-SIP-validation-for-TCP.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-nf_conntrack_sip-relax-SIP-validation-for-TCP.patch"

=46rom 084a77a72bfc1c5c655f51618bfe885a216ce88b Mon Sep 17 00:00:00 2001
From: Ulrich Weber <ulrich.weber@riverbed.com>
Date: Wed, 12 Oct 2016 09:27:23 +0200
Subject: [PATCH] nf_conntrack_sip: relax SIP validation for TCP

Due TCP fragmentation we cant assume full SIP messages all the time.
Therefore Accept all packets, even unparsable.

Signed-off-by: Ulrich Weber <ulrich.weber@gmail.com>
---
 net/netfilter/nf_conntrack_sip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrac=
k_sip.c
index 621b81c..7700556 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1562,7 +1562,10 @@ static int sip_help_tcp(struct sk_buff *skb, unsig=
ned int protoff,
 			hooks->seq_adjust(skb, protoff, tdiff);
 	}
=20
-	return ret;
+	/* Due TCP fragmentation we cant assume full SIP messages all the time.=

+	 * Therefore Accept all packets, even unparsable.
+	 */
+	return NF_ACCEPT;
 }
=20
 static int sip_help_udp(struct sk_buff *skb, unsigned int protoff,
--=20
2.7.4


--------------833A8543A2CD2A5331BB9591--
