From: Greg KH <gregkh@suse.de>
Subject: [patch 23/23] netfilter: restore lost ifdef guarding defrag
	exception
Date: Fri, 7 Nov 2008 15:16:13 -0800
Message-ID: <20081107231613.GX1108@kroah.com>
References: <20081107224818.593212310@mini.kroah.org>
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
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753854AbYKGXXT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:23:19 -0500
Content-Disposition: inline; filename="netfilter-restore-lost-ifdef-guarding-defrag-exception.patch"
In-Reply-To: <20081107231457.GA1108@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

netfilter: restore lost #ifdef guarding defrag exception

Upstream commit 38f7ac3eb:

Nir Tzachar <nir.tzachar@gmail.com> reported a warning when sending
fragments over loopback with NAT:

[ 6658.338121] WARNING: at net/ipv4/netfilter/nf_nat_standalone.c:89 nf_nat_fn+0x33/0x155()

The reason is that defragmentation is skipped for already tracked connections.
This is wrong in combination with NAT and ip_conntrack actually had some ifdefs
to avoid this behaviour when NAT is compiled in.

The entire "optimization" may seem a bit silly, for now simply restoring the
lost #ifdef is the easiest solution until we can come up with something better.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -150,10 +150,12 @@ static unsigned int ipv4_conntrack_defra
 					  const struct net_device *out,
 					  int (*okfn)(struct sk_buff *))
 {
+#if !defined(CONFIG_NF_NAT) && !defined(CONFIG_NF_NAT_MODULE)
 	/* Previously seen (loopback)?  Ignore.  Do this before
 	   fragment check. */
 	if (skb->nfct)
 		return NF_ACCEPT;
+#endif
 
 	/* Gather fragments. */
 	if (ip_hdr(skb)->frag_off & htons(IP_MF | IP_OFFSET)) {

-- 
