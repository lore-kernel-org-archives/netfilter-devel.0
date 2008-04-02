From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/24] [NETFILTER]: nf_nat: autoload IPv4 connection tracking
Date: Wed,  2 Apr 2008 13:11:55 +0200
Message-ID: <2d8abd69594fd12d2e8eeece42cc957749d37322.1207134547.git.jengelh@computergmbh.de>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43168 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbYDBLMK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 07:12:10 -0400
In-Reply-To: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
References: <455b3b0ee249d17dff621933f163b8d5e377eb8f.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Without this patch, the generic L3 tracker would kick in
if nf_conntrack_ipv4 was not loaded before nf_nat, which
would lead to translation problems with ICMP errors.

NAT does not make sense without IPv4 connection tracking
anyway, so just add a call to need_ipv4_conntrack().

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/ipv4/netfilter/nf_nat_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 9c8aa8d..37b7125 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -629,6 +629,8 @@ static int __init nf_nat_init(void)
 	size_t i;
 	int ret;
 
+	need_ipv4_conntrack();
+
 	ret = nf_ct_extend_register(&nat_extend);
 	if (ret < 0) {
 		printk(KERN_ERR "nf_nat_core: Unable to register extension\n");
-- 
1.5.4.4

