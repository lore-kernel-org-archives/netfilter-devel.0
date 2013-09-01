From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 0/2] ipset: rework extension handling to be more manageable.
Date: Sun,  1 Sep 2013 21:58:40 +0200
Message-ID: <1378065522-65492-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:55062 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab3IAUG6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Sep 2013 16:06:58 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id C85F5A2CAD
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Sep 2013 20:59:30 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id D-o7dSThFDwn for <netfilter-devel@vger.kernel.org>;
	Sun,  1 Sep 2013 20:58:43 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Earlier today I sent a patch that cleaned up the hash extension, not noticing
that the bitmap family is in a similar state.

This series cleans up the code for both the hash and bitmap families. Patch 1 is
identical to the one I sent earlier today but has a different commit message that
specifically mentions that it applies to the hash family.

Oliver Smith (2):
  netfilter: ipset: rework hash ext. handling to be more manageable.
  netfilter: ipset: rework bitmap ext. handling to be more manageable.

 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   8 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  55 ++++++++++
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |  68 ++----------
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  63 ++---------
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |  57 +---------
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 121 ++++++++-------------
 6 files changed, 129 insertions(+), 243 deletions(-)

-- 
1.8.3.2

