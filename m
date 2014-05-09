From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH 03/15] br_netfilter: switch sysctl nf_call_arptables to init_brnf_net
Date: Sat, 10 May 2014 01:27:09 +0400
Message-ID: <536D482D.9030501@parallels.com>
References: <536A8054.90201@pandora.de> <cover.1399660706.git.vvs@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:27394 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241AbaEIV25 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 May 2014 17:28:57 -0400
In-Reply-To: <cover.1399660706.git.vvs@openvz.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Vasily Averin <vvs@openvz.org>
---
 net/bridge/br_netfilter.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 871f481..2b0dda80 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -63,14 +63,12 @@ static struct brnf_net init_brnf_net = {
 static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables __read_mostly = 1;
 static int brnf_call_ip6tables __read_mostly = 1;
-static int brnf_call_arptables __read_mostly = 1;
 static int brnf_filter_vlan_tagged __read_mostly = 0;
 static int brnf_filter_pppoe_tagged __read_mostly = 0;
 static int brnf_pass_vlan_indev __read_mostly = 0;
 #else
 #define brnf_call_iptables 1
 #define brnf_call_ip6tables 1
-#define brnf_call_arptables 1
 #define brnf_filter_vlan_tagged 0
 #define brnf_filter_pppoe_tagged 0
 #define brnf_pass_vlan_indev 0
@@ -850,7 +848,7 @@ static unsigned int br_nf_forward_arp(const struct nf_hook_ops *ops,
 		return NF_ACCEPT;
 	br = p->br;
 
-	if (!brnf_call_arptables && !br->nf_call_arptables)
+	if (!init_brnf_net.nf_call_arptables && !br->nf_call_arptables)
 		return NF_ACCEPT;
 
 	if (!IS_ARP(skb)) {
@@ -1027,7 +1025,7 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 static struct ctl_table brnf_table[] = {
 	{
 		.procname	= "bridge-nf-call-arptables",
-		.data		= &brnf_call_arptables,
+		.data		= &init_brnf_net.nf_call_arptables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
-- 
1.7.5.4

