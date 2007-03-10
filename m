From: Greg KH <gregkh@suse.de>
Subject: [patch 11/20] nfnetlink_log: fix crash on bridged packet
Date: Fri, 9 Mar 2007 22:17:55 -0800
Message-ID: <20070310061755.GL31412@kroah.com>
References: <20070310061234.465093436@mini.kroah.org>
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
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>, davem@davemloft.net
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752802AbXCJGUZ@vger.kernel.org>
Content-Disposition: inline; filename="nfnetlink_log-fix-crash-on-bridged-packet.patch"
In-Reply-To: <20070310061603.GA31412@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Patrick McHardy <kaber@trash.net>

[NETFILTER]: nfnetlink_log: fix crash on bridged packet

physoutdev is only set on purely bridged packet, when nfnetlink_log is used
in the OUTPUT/FORWARD/POSTROUTING hooks on packets forwarded from or to a
bridge it crashes when trying to dereference skb->nf_bridge->physoutdev.

Reported by Holger Eitzenberger <heitzenberger@astaro.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -491,7 +491,7 @@ __build_packet_message(struct nfulnl_ins
 			 * for physical device (when called from ipv4) */
 			NFA_PUT(inst->skb, NFULA_IFINDEX_OUTDEV,
 				sizeof(tmp_uint), &tmp_uint);
-			if (skb->nf_bridge) {
+			if (skb->nf_bridge && skb->nf_bridge->physoutdev) {
 				tmp_uint = 
 				    htonl(skb->nf_bridge->physoutdev->ifindex);
 				NFA_PUT(inst->skb, NFULA_IFINDEX_PHYSOUTDEV,

-- 
