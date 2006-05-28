From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: PPTP helper: fix sstate/cstate typo
Date: Mon, 29 May 2006 01:06:34 +0200 (MEST)
Message-ID: <20060528230634.6318.81427.sendpatchset@localhost.localdomain>
References: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
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

[NETFILTER]: PPTP helper: fix sstate/cstate typo

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f80ffe2d3c9364404f4545196c70784c70fa8d28
tree 70a63104f71218daca622539cb73b5872fb0f0be
parent b82323a2dfb5b58b9ca3e3687b35bae0ac90b503
author Alexey Dobriyan <adobriyan@gmail.com> Mon, 29 May 2006 00:47:57 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 29 May 2006 00:47:57 +0200

 net/ipv4/netfilter/ip_conntrack_helper_pptp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
index 7d3ba43..8ccfe17 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
@@ -469,8 +469,8 @@ pptp_inbound_pkt(struct sk_buff **pskb,
 			DEBUGP("%s but no session\n", pptp_msg_name[msg]);
 			break;
 		}
-		if (info->sstate != PPTP_CALL_IN_REP
-		    && info->sstate != PPTP_CALL_IN_CONF) {
+		if (info->cstate != PPTP_CALL_IN_REP
+		    && info->cstate != PPTP_CALL_IN_CONF) {
 			DEBUGP("%s but never sent IN_CALL_REPLY\n",
 				pptp_msg_name[msg]);
 			break;
