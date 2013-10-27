From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ipset patches for nf-next
Date: Sun, 27 Oct 2013 19:31:57 +0100
Message-ID: <1382898719-7003-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:40648 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487Ab3J0ScB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:32:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows two patches for nf-next.

- Fix memory allocation for bitmap:port: at the restructuring of
  the bitmap types creation in ipset, for the bitmap:port type wrong
  (too large) memory allocation was copied. Reported by Quentin Armitage,
  the patch is from me.
- Remove a duplicate define from net/netfilter/ipset/ip_set_hash_gen.h,
  submitted by Michael Opdenacker.

Please apply them.

Best regards,
Jozsef

The following changes since commit f2020b27be94222eb25c39ff46eb9917cb92897b:

  netfilter: ip6t_REJECT: skip checksum verification for outgoing ipv6 packets (2013-10-23 11:20:00 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next master

for you to fetch changes up to 1e56555ee1f3d04d89bdaa3df57ad2da9fbc0999:

  netfilter: ipset: remove duplicate define (2013-10-27 19:24:45 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      netfilter:ipset: Fix memory allocation for bitmap:port

Michael Opdenacker (1):
      netfilter: ipset: remove duplicate define

 net/netfilter/ipset/ip_set_bitmap_port.c |    2 +-
 net/netfilter/ipset/ip_set_hash_gen.h    |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)
