From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 0/2 v2] cleanup and shrink ipset handling code.
Date: Tue,  3 Sep 2013 13:03:23 +0200
Message-ID: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:32784 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab3ICLDz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:03:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 20106A2DE9
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2013 12:03:52 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 7i4XmovE_SGk for <netfilter-devel@vger.kernel.org>;
	Tue,  3 Sep 2013 12:03:25 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Following on from my previous patch, I noticed that the existing way
of managing the extensions could actually be trivially reworked by
simply checking each flag bit in series and setting up the size and
offsets incrementally. This makes adding new extensions as simple as
throwing a new case into the switch, no set file changes needed. It
also avoids having to do any unpleasant upheaveal of timeout.

This patch is intended to apply directly against the current HEAD of
master in the ipset repo.

One caveat to note is that since we now define each extension
independently, it is important to ensure a proper alignment value so
that each subsequent struct ends up on a "nice" boundary in memory.
Since both timeout and counter should align on their own nicely, I
didn't bother adding alignment statements to them. Anyone writing a
new extension should ensure they're a good codizen and align appropriately.

On that note, there is the option of simply aligning everything to the GCC
value __BIGGEST_ALIGNMENT__, on my 64-bit box that comes out at 16 bytes,
perhaps that's overkill - although there are instructions that can do a 16
byte load. Perhaps I'm just going overboard though... in6_addr doesn't even
align to 64 bits, so maybe nobody cares but me. <breaks out the violin>

Cheers!

Oliver Smith (2):
  netfilter: ipset: rework hash ext. handling to be more manageable.
  netfilter: ipset: rework bitmap ext. handling to be more manageable.

 kernel/include/linux/netfilter/ipset/ip_set.h      |   4 +
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   8 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  34 +++++++
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |  87 ++----------------
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  96 ++-----------------
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  76 +--------------
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 102 ++++++---------------
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |  36 +-------
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  54 +----------
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  58 +-----------
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  66 +------------
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |  54 +----------
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  67 +-------------
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  60 +-----------
 14 files changed, 106 insertions(+), 696 deletions(-)

-- 
1.8.3.2

