From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 38/39]: PPTP conntrack: fix GRE keymap leak
Date: Wed, 20 Sep 2006 10:24:40 +0200 (MEST)
Message-ID: <20060920082532.14636.42551.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP conntrack: fix GRE keymap leak

When destroying the GRE expectations without having seen the GRE connection
the keymap entry is not freed, leading to a memory leak and, in case of
a following call within the same session, failure during expectation setup.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0646fc2fe542b914d8d379c26f773854d9628815
tree ef3d357c1b271ebd9ad570c0fed49a822716b7e3
parent ba51b5a0b572b684c58b32391335d4a3e4a67c0b
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:05 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:39:05 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index b0225b6..98267b0 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -194,6 +194,7 @@ static void pptp_destroy_siblings(struct
 {
 	struct ip_conntrack_tuple t;
 
+	ip_ct_gre_keymap_destroy(ct);
 	/* Since ct->sibling_list has literally rusted away in 2.6.11,
 	 * we now need another way to find out about our sibling
 	 * contrack and expects... -HW */
