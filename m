From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: fix format specifier for netfilter log targets
Date: Wed, 17 May 2006 09:40:53 +0200
Message-ID: <446AD385.2090501@trash.net>
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

[NETFILTER]: fix format specifier for netfilter log targets

The prefix argument for nf_log_packet is a format specifier,
so don't pass the user defined string directly to it.

Signed-off-by: Philip Craig <philipc@snapgear.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4c2e54ad6dc1f0086f7eec94f8fbb57f91866f8b
tree 5f52982e53f964beffa33c1500d54613596a0723
parent 6bf69b5660fafbbb8bfeebcfd53efee8ab419ff1
author Philip Craig <philipc@snapgear.com> Wed, 17 May 2006 09:36:30 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 17 May 2006 09:36:30 +0200

 net/bridge/netfilter/ebt_log.c |    2 +-
 net/ipv4/netfilter/ipt_LOG.c   |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index d159c92..466ed34 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -168,7 +168,7 @@ static void ebt_log(const struct sk_buff
 
 	if (info->bitmask & EBT_LOG_NFLOG)
 		nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
-		              info->prefix);
+		              "%s", info->prefix);
 	else
 		ebt_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li,
 		               info->prefix);
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 39fd4c2..b98f7b0 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -428,7 +428,7 @@ ipt_log_target(struct sk_buff **pskb,
 
 	if (loginfo->logflags & IPT_LOG_NFLOG)
 		nf_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
-		              loginfo->prefix);
+		              "%s", loginfo->prefix);
 	else
 		ipt_log_packet(PF_INET, hooknum, *pskb, in, out, &li,
 		               loginfo->prefix);
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index a96c0de..73c6300 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -439,7 +439,7 @@ ip6t_log_target(struct sk_buff **pskb,
 
 	if (loginfo->logflags & IP6T_LOG_NFLOG)
 		nf_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
-		              loginfo->prefix);
+		              "%s", loginfo->prefix);
 	else
 		ip6t_log_packet(PF_INET6, hooknum, *pskb, in, out, &li,
 		                loginfo->prefix);
