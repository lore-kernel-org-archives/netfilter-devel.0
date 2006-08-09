From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: xt_hashlimit: fix limit off-by-one
Date: Wed, 09 Aug 2006 11:41:27 +0200
Message-ID: <44D9ADC7.30006@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: xt_hashlimit: fix limit off-by-one

Hashlimit doesn't account for the first packet, which is inconsistent with
the limit match.

Reported by ryan.castellucci@gmail.com, netfilter bugzilla #500.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit afe7e5033e79c86de718cb7fce5961a50b1352d3
tree 3c02c7e82f9471ccf72712dc7d8d2f030cbda4fc
parent 71c55528be7cf1199376a1b1c5489f60bf2b2617
author Patrick McHardy <kaber@trash.net> Wed, 09 Aug 2006 11:08:26 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 09 Aug 2006 11:08:26 +0200

 net/ipv4/netfilter/ipt_hashlimit.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 6b66244..3bd2368 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -454,15 +454,12 @@ hashlimit_match(const struct sk_buff *sk
 		dh->rateinfo.credit_cap = user2credits(hinfo->cfg.avg * 
 							hinfo->cfg.burst);
 		dh->rateinfo.cost = user2credits(hinfo->cfg.avg);
-
-		spin_unlock_bh(&hinfo->lock);
-		return 1;
+	} else {
+		/* update expiration timeout */
+		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
+		rateinfo_recalc(dh, now);
 	}
 
-	/* update expiration timeout */
-	dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
-
-	rateinfo_recalc(dh, now);
 	if (dh->rateinfo.credit >= dh->rateinfo.cost) {
 		/* We're underlimit. */
 		dh->rateinfo.credit -= dh->rateinfo.cost;
