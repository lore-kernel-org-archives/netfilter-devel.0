From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 07/59] NETFILTER: nf_conntrack_ipv6: fix crash when handling fragments
Date: Fri, 02 Feb 2007 18:35:11 -0800
Message-ID: <20070203023835.125598000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1946251AbXBCCga@vger.kernel.org>
Content-Disposition: inline; filename=netfilter-nf_conntrack_ipv6-fix-crash-when-handling-fragments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Patrick McHardy <kaber@trash.net>

When IPv6 connection tracking splits up a defragmented packet into
its original fragments, the packets are taken from a list and are
passed to the network stack with skb->next still set. This causes
dev_hard_start_xmit to treat them as GSO fragments, resulting in
a use after free when connection tracking handles the next fragment.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.19.2.orig/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ linux-2.6.19.2/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -835,6 +835,8 @@ void nf_ct_frag6_output(unsigned int hoo
 		s->nfct_reasm = skb;
 
 		s2 = s->next;
+		s->next = NULL;
+
 		NF_HOOK_THRESH(PF_INET6, hooknum, s, in, out, okfn,
 			       NF_IP6_PRI_CONNTRACK_DEFRAG + 1);
 		s = s2;

--
