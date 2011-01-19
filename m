From: kaber@trash.net
Subject: [PATCH 11/79] netfilter: nf_ct_frag6_sysctl_table is static
Date: Wed, 19 Jan 2011 20:14:11 +0100
Message-ID: <1295464519-21763-12-git-send-email-kaber@trash.net>
References: <1295464519-21763-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1295464519-21763-1-git-send-email-kaber@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 3a3f129..eb9f1c0 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -73,7 +73,7 @@ static struct inet_frags nf_frags;
 static struct netns_frags nf_init_frags;
 
 #ifdef CONFIG_SYSCTL
-struct ctl_table nf_ct_frag6_sysctl_table[] = {
+static struct ctl_table nf_ct_frag6_sysctl_table[] = {
 	{
 		.procname	= "nf_conntrack_frag6_timeout",
 		.data		= &nf_init_frags.timeout,
-- 
1.7.2.3

