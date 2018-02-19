From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: bridge: ebt_among: add missing match
	size checks
Date: Mon, 19 Feb 2018 03:01:45 +0100
Message-ID: <20180219020145.30899-1-fw@strlen.de>
References: <001a1144b3d60d448f0565848646@google.com>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <001a1144b3d60d448f0565848646@google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/bridge/>
List-Post: <mailto:bridge@lists.linux-foundation.org>
List-Help: <mailto:bridge-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/bridge>,
	<mailto:bridge-request@lists.linux-foundation.org?subject=subscribe>
Sender: bridge-bounces@lists.linux-foundation.org
Errors-To: bridge-bounces@lists.linux-foundation.org
List-Id: netfilter-devel.vger.kernel.org

ebt_among is special, it has a dynamic match size and is exempt
from the central size checks.

Therefore it must check that the size of the match structure
provided from userspace is sane by making sure em->match_size
is at least the minimum size of the expected structure.

The module has such a check, but its only done after accessing
a structure that might be out of bounds.

tested with: ebtables -A INPUT ... \
--among-dst fe:fe:fe:fe:fe:fe
--among-dst fe:fe:fe:fe:fe:fe --among-src fe:fe:fe:fe:ff:f,fe:fe:fe:fe:fe:fb,fe:fe:fe:fe:fc:fd,fe:fe:fe:fe:fe:fd,fe:fe:fe:fe:fe:fe
--among-src fe:fe:fe:fe:ff:f,fe:fe:fe:fe:fe:fa,fe:fe:fe:fe:fe:fd,fe:fe:fe:fe:fe:fe,fe:fe:fe:fe:fe:fe

Reported-by: <syzbot+fe0b19af568972814355@syzkaller.appspotmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebt_among.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index ce7152a12bd8..c5afb4232ecb 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -172,18 +172,35 @@ ebt_among_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
+static bool poolsize_invalid(const struct ebt_mac_wormhash *w)
+{
+	return w && w->poolsize >= (INT_MAX / sizeof(struct ebt_mac_wormhash_tuple));
+}
+
 static int ebt_among_mt_check(const struct xt_mtchk_param *par)
 {
 	const struct ebt_among_info *info = par->matchinfo;
 	const struct ebt_entry_match *em =
 		container_of(par->matchinfo, const struct ebt_entry_match, data);
-	int expected_length = sizeof(struct ebt_among_info);
+	unsigned int expected_length = sizeof(struct ebt_among_info);
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	int err;
 
+	if (expected_length > em->match_size)
+		return -EINVAL;
+
 	wh_dst = ebt_among_wh_dst(info);
-	wh_src = ebt_among_wh_src(info);
+	if (poolsize_invalid(wh_dst))
+		return -EINVAL;
+
 	expected_length += ebt_mac_wormhash_size(wh_dst);
+	if (expected_length > em->match_size)
+		return -EINVAL;
+
+	wh_src = ebt_among_wh_src(info);
+	if (poolsize_invalid(wh_src))
+		return -EINVAL;
+
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
 	if (em->match_size != EBT_ALIGN(expected_length)) {
-- 
2.16.1
