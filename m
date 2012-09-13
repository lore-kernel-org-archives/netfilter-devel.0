From: Cong Wang <amwang@redhat.com>
Subject: [PATCH net-next 0/4] ipv6: fix the reassembly expire code in nf_conntrack
Date: Thu, 13 Sep 2012 14:25:37 +0800
Message-ID: <1347517541-10653-1-git-send-email-amwang@redhat.com>
Cc: netfilter-devel@vger.kernel.org,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Cong Wang <amwang@redhat.com>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab2IMGZ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:25:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipv6: add a new namespace for nf_conntrack_reasm
ipv6: unify conntrack reassembly expire code with
ipv6: make ip6_frag_nqueues() and ip6_frag_mem() static
ipv6: unify fragment thresh handling code

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Cong Wang <amwang@redhat.com>

---

 include/net/inet_frag.h                 |    2 +-
 include/net/ipv6.h                      |   32 +++++-
 include/net/net_namespace.h             |    3 +
 include/net/netns/conntrack.h           |    6 +
 net/ipv4/inet_fragment.c                |    9 +-
 net/ipv4/ip_fragment.c                  |    5 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c |  196 ++++++++++++++++---------------
 net/ipv6/reassembly.c                   |   88 ++++----------
 8 files changed, 176 insertions(+), 165 deletions(-)

