From: Eric Leblond <eric@regit.org>
Subject: [RFC PATCH 0/2] nft: improve reject support
Date: Wed, 11 Dec 2013 01:42:32 +0100
Message-ID: <1386722554-4827-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:45347 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3LKAm7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Dec 2013 19:42:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

Here's a small patchset implementing IPv6 reject as well as TCP RST based
reject. It uses the same factorisation technique as the one used for
nft_queue. I've tested ICMP reject and still need to fix nftables to be
able to test TCP reset. This explains in part the RFC status of the patch.

Patchset statistics:
 include/net/netfilter/nf_reject.h    | 297 +++++++++++++++++++++++++++++++++++
 net/ipv4/netfilter/Kconfig           |   4 -
 net/ipv4/netfilter/Makefile          |   1 -
 net/ipv4/netfilter/ipt_REJECT.c      | 124 +--------------
 net/ipv4/netfilter/nft_reject_ipv4.c | 123 ---------------
 net/ipv6/netfilter/ip6t_REJECT.c     | 177 +--------------------
 net/netfilter/Kconfig                |   4 +
 net/netfilter/Makefile               |   1 +
 net/netfilter/nft_reject.c           | 143 +++++++++++++++++
 9 files changed, 455 insertions(+), 419 deletions(-)

BR,
--
Eric
