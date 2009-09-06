From: Michal Soltys <soltys@ziu.info>
Subject: [PATCH] xt_u32.c - make negative offsets work near / at the end of packet
Date: Sun,  6 Sep 2009 02:36:37 +0200
Message-ID: <1252197398-23863-1-git-send-email-soltys@ziu.info>
Cc: netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.ppgk.com.pl ([80.53.243.36]:11506 "EHLO relay.ppgk.com.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbZIFAr0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Sep 2009 20:47:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the older version of u32 match there was a possibility to succesfully
use negative offsets while being at or near the end of the packet.

For example - a method presented in:

http://www.stearns.org/doc/iptables-u32.v0.1.7.html

... to find a tcp packet with no payload :

0>>22&0x3C @ 12>>26&0x3C @ -3&0xFF=0:255

But with current xt_u32.c code this is impossible due to subsequent
sanity checks:

        if (at + val < at)
                return false;
        at += val;
        pos = number;
        if (at + 4 < at || skb->len < at + 4 (#3) ||
            pos > skb->len - at - 4 (#4) )
                return false;

        if (skb_copy_bits(skb, at + pos, &n,
            sizeof(n)) < 0)

In particular, condition (#3) will make the function return false, if
'at' is at / near the end of packet, regardless of the 'pos' value used.
Furthermore, (#4) would inhibit any "negative" 'pos' value anyway.

If I haven't missed anything, the whole sequence could be changed to:

        at += val;
        if (at + number + 4 < 4 || skb->len < at + number + 4)
                return false;

        if (skb_copy_bits(skb, at + number, &n,
                            sizeof(n)) < 0)

This allows both 'pos' and 'val' to be interpreted in any (+/-) way.
Sanity checks will keep the read in bounds, and the first condition will
be fine for unsigned values. I'm not sure how that approach would behave
on non-x86 architectures though.

Iptables doesn't complain about using negative values with -m u32, so I
assumed that original intent was to allow them.

Tiny patch below implements proposed changes.

Michal Soltys (1):
  xt_u32.c - make negative offsets work near / at the end of packet

 net/netfilter/xt_u32.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

