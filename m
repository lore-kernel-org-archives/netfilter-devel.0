From: Greg KH <gregkh@suse.de>
Subject: [patch 19/37] nf_conntrack: padding breaks conntrack hash on ARM
Date: Tue, 13 May 2008 13:12:16 -0700
Message-ID: <20080513201216.GT31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Philip Craig <philipc@snapgear.com>,
	Patrick McHardy <kaber@trash.net>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38128 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762245AbYEMUPF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 16:15:05 -0400
Content-Disposition: inline; filename="nf_conntrack-padding-breaks-conntrack-hash-on-arm.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Philip Craig <philipc@snapgear.com>

[NETFILTER]: nf_conntrack: padding breaks conntrack hash on ARM

Upstream commit 443a70d50:

commit 0794935e "[NETFILTER]: nf_conntrack: optimize hash_conntrack()"
results in ARM platforms hashing uninitialised padding.  This padding
doesn't exist on other architectures.

Fix this by replacing NF_CT_TUPLE_U_BLANK() with memset() to ensure
everything is initialised.  There were only 4 bytes that
NF_CT_TUPLE_U_BLANK() wasn't clearing anyway (or 12 bytes on ARM).

Signed-off-by: Philip Craig <philipc@snapgear.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/net/netfilter/nf_conntrack_tuple.h     |   10 ----------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    4 ++--
 3 files changed, 3 insertions(+), 13 deletions(-)

--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -101,16 +101,6 @@ struct nf_conntrack_tuple_mask
 	} src;
 };
 
-/* This is optimized opposed to a memset of the whole structure.  Everything we
- * really care about is the  source/destination unions */
-#define NF_CT_TUPLE_U_BLANK(tuple)                              	\
-        do {                                                    	\
-                (tuple)->src.u.all = 0;                         	\
-                (tuple)->dst.u.all = 0;                         	\
-		memset(&(tuple)->src.u3, 0, sizeof((tuple)->src.u3));	\
-		memset(&(tuple)->dst.u3, 0, sizeof((tuple)->dst.u3));	\
-        } while (0)
-
 #ifdef __KERNEL__
 
 #define NF_CT_DUMP_TUPLE(tp)						     \
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -305,7 +305,7 @@ getorigdst(struct sock *sk, int optval, 
 	const struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
 
-	NF_CT_TUPLE_U_BLANK(&tuple);
+	memset(&tuple, 0, sizeof(tuple));
 	tuple.src.u3.ip = inet->rcv_saddr;
 	tuple.src.u.tcp.port = inet->sport;
 	tuple.dst.u3.ip = inet->daddr;
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -104,7 +104,7 @@ nf_ct_get_tuple(const struct sk_buff *sk
 		const struct nf_conntrack_l3proto *l3proto,
 		const struct nf_conntrack_l4proto *l4proto)
 {
-	NF_CT_TUPLE_U_BLANK(tuple);
+	memset(tuple, 0, sizeof(*tuple));
 
 	tuple->src.l3num = l3num;
 	if (l3proto->pkt_to_tuple(skb, nhoff, tuple) == 0)
@@ -153,7 +153,7 @@ nf_ct_invert_tuple(struct nf_conntrack_t
 		   const struct nf_conntrack_l3proto *l3proto,
 		   const struct nf_conntrack_l4proto *l4proto)
 {
-	NF_CT_TUPLE_U_BLANK(inverse);
+	memset(inverse, 0, sizeof(*inverse));
 
 	inverse->src.l3num = orig->src.l3num;
 	if (l3proto->invert_tuple(inverse, orig) == 0)

-- 
