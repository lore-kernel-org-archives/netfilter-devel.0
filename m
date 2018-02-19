From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: ebtables: CONFIG_COMPAT: don't trust
	userland offsets
Date: Mon, 19 Feb 2018 01:24:15 +0100
Message-ID: <20180219002415.18461-1-fw@strlen.de>
References: <94eb2c0efc1e07b3450565848616@google.com>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <bridge-bounces@lists.linux-foundation.org>
In-Reply-To: <94eb2c0efc1e07b3450565848616@google.com>
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

We need to make sure the offsets are not out of range of the
total size.
Also check that they are in ascending order.

The WARN_ON triggered by syzkaller (it sets panic_on_warn) is
changed to also bail out, no point in continuing parsing.

Briefly tested with simple ruleset of
-A INPUT --limit 1/s' --log
plus jump to custom chains using 32bit ebtables binary.

Reported-by: <syzbot+845a53d13171abf8bf29@syzkaller.appspotmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 02c4b409d317..3f536c7a3354 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2053,7 +2053,9 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
 		if (match_kern)
 			match_kern->match_size = ret;
 
-		WARN_ON(type == EBT_COMPAT_TARGET && size_left);
+		if (WARN_ON(type == EBT_COMPAT_TARGET && size_left))
+			return -EINVAL;
+
 		match32 = (struct compat_ebt_entry_mwt *) buf;
 	}
 
@@ -2109,6 +2111,15 @@ static int size_entry_mwt(struct ebt_entry *entry, const unsigned char *base,
 	 *
 	 * offsets are relative to beginning of struct ebt_entry (i.e., 0).
 	 */
+	for (i = 0; i < 4 ; ++i) {
+		if (offsets[i] >= *total)
+			return -EINVAL;
+		if (i == 0)
+			continue;
+		if (offsets[i-1] > offsets[i])
+			return -EINVAL;
+	}
+
 	for (i = 0, j = 1 ; j < 4 ; j++, i++) {
 		struct compat_ebt_entry_mwt *match32;
 		unsigned int size;
-- 
2.16.1
