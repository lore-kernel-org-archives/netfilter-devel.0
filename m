From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/5] [NETFILTER]: annotate {nf,ip,ip6}_queue with const
Date: Sat, 26 Jan 2008 17:17:47 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801261717260.15243@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39909 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbYAZQRt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:17:49 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 582ce1bdcc93998503c9d51d6159f189af2dc50a
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Fri Jan 25 20:52:56 2008 +0100

    [NETFILTER]: annotate {nf,ip,ip6}_queue with const
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/net/ipv4/netfilter/ip_queue.c b/net/ipv4/netfilter/ip_queue.c
index 5109839..9e911a9 100644
--- a/net/ipv4/netfilter/ip_queue.c
+++ b/net/ipv4/netfilter/ip_queue.c
@@ -284,7 +284,7 @@ ipq_mangle_ipv4(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 {
 	int diff;
 	int err;
-	struct iphdr *user_iph = (struct iphdr *)v->payload;
+	const struct iphdr *user_iph = (const void *)v->payload;
 
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
@@ -496,7 +496,7 @@ static int
 ipq_rcv_nl_event(struct notifier_block *this,
 		 unsigned long event, void *ptr)
 {
-	struct netlink_notify *n = ptr;
+	const struct netlink_notify *n = ptr;
 
 	if (event == NETLINK_URELEASE &&
 	    n->protocol == NETLINK_FIREWALL && n->pid) {
diff --git a/net/ipv6/netfilter/ip6_queue.c b/net/ipv6/netfilter/ip6_queue.c
index 56b4ea6..3604179 100644
--- a/net/ipv6/netfilter/ip6_queue.c
+++ b/net/ipv6/netfilter/ip6_queue.c
@@ -286,7 +286,7 @@ ipq_mangle_ipv6(ipq_verdict_msg_t *v, struct nf_queue_entry *e)
 {
 	int diff;
 	int err;
-	struct ipv6hdr *user_iph = (struct ipv6hdr *)v->payload;
+	const struct ipv6hdr *user_iph = (const void *)v->payload;
 
 	if (v->data_len < sizeof(*user_iph))
 		return 0;
@@ -499,7 +499,7 @@ static int
 ipq_rcv_nl_event(struct notifier_block *this,
 		 unsigned long event, void *ptr)
 {
-	struct netlink_notify *n = ptr;
+	const struct netlink_notify *n = ptr;
 
 	if (event == NETLINK_URELEASE &&
 	    n->protocol == NETLINK_IP6_FW && n->pid) {
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index bfc2928..1e5ae6b 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -309,7 +309,7 @@ static void seq_stop(struct seq_file *s, void *v)
 static int seq_show(struct seq_file *s, void *v)
 {
 	int ret;
-	loff_t *pos = v;
+	const loff_t *pos = v;
 	const struct nf_queue_handler *qh;
 
 	rcu_read_lock();

