From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 19/19]: bridge: remove broken netfilter binary sysctls
Date: Fri, 28 Sep 2007 18:31:03 +0200 (MEST)
Message-ID: <20070928163103.8394.72098.sendpatchset@localhost.localdomain>
References: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757191AbXI1QbF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:31:05 -0400
In-Reply-To: <20070928163036.8394.36374.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: bridge: remove broken netfilter binary sysctls

The netfilter sysctls in the bridging code don't set strategy routines:

 sysctl table check failed: /net/bridge/bridge-nf-call-arptables .3.10.1 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-call-iptables .3.10.2 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-call-ip6tables .3.10.3 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-filter-vlan-tagged .3.10.4 Missing strategy
 sysctl table check failed: /net/bridge/bridge-nf-filter-pppoe-tagged .3.10.5 Missing strategy

    These binary sysctls can't work. The binary sysctl numbers of
other netfilter sysctls with this problem are being removed.  These
need to go as well.

Signed-off-by: Joseph Fannin <jfannin@gmail.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 313f81325be8fb197bd64c0647d3bb3c69876cb4
tree 6176c1ce4b3bce10abe5d6427ed39dcadd953c80
parent b0a6584d6df0608e19c06edc42504aef7e58e213
author Joseph Fannin <jfannin@gmail.com> Fri, 28 Sep 2007 18:09:18 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 28 Sep 2007 18:09:18 +0200

 net/bridge/br_netfilter.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index fc13130..8245f05 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -904,7 +904,6 @@ int brnf_sysctl_call_tables(ctl_table * ctl, int write, struct file *filp,
 
 static ctl_table brnf_table[] = {
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_ARPTABLES,
 		.procname	= "bridge-nf-call-arptables",
 		.data		= &brnf_call_arptables,
 		.maxlen		= sizeof(int),
@@ -912,7 +911,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_IPTABLES,
 		.procname	= "bridge-nf-call-iptables",
 		.data		= &brnf_call_iptables,
 		.maxlen		= sizeof(int),
@@ -920,7 +918,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_CALL_IP6TABLES,
 		.procname	= "bridge-nf-call-ip6tables",
 		.data		= &brnf_call_ip6tables,
 		.maxlen		= sizeof(int),
@@ -928,7 +925,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_FILTER_VLAN_TAGGED,
 		.procname	= "bridge-nf-filter-vlan-tagged",
 		.data		= &brnf_filter_vlan_tagged,
 		.maxlen		= sizeof(int),
@@ -936,7 +932,6 @@ static ctl_table brnf_table[] = {
 		.proc_handler	= &brnf_sysctl_call_tables,
 	},
 	{
-		.ctl_name	= NET_BRIDGE_NF_FILTER_PPPOE_TAGGED,
 		.procname	= "bridge-nf-filter-pppoe-tagged",
 		.data		= &brnf_filter_pppoe_tagged,
 		.maxlen		= sizeof(int),
