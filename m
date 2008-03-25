From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:21 +0100
Message-ID: <1206468391-368-19-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52542 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759230AbYCYSGh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:37 -0400
In-Reply-To: <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: nf_nat: autoload IPv4 connection tracking
    
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
