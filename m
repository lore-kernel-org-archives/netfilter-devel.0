From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/18]: ipt_recent: add module parameter for changing
	ownership of /proc/net/ipt_recent/*
Date: Tue, 22 Aug 2006 00:52:22 +0200 (MEST)
Message-ID: <20060821225222.10288.38763.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt_recent: add module parameter for changing ownership of /proc/net/ipt_recent/*

Signed-off-by: Daniel De Graaf <danield@iastate.edu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 55eeb35cfb789640cc0d3b179398b196286c5991
tree 7e5c77fd3c21372eeacca1c456a2c9bd49044517
parent aee6e3b681f66196cf3ec43b53b252b61f870f1a
author Daniel De Graaf <danield@iastate.edu> Fri, 11 Aug 2006 21:01:03 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:03 +0200

 net/ipv4/netfilter/ipt_recent.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 61a2139..682c094 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -35,14 +35,20 @@ static unsigned int ip_list_tot = 100;
 static unsigned int ip_pkt_list_tot = 20;
 static unsigned int ip_list_hash_size = 0;
 static unsigned int ip_list_perms = 0644;
+static unsigned int ip_list_uid = 0;
+static unsigned int ip_list_gid = 0;
 module_param(ip_list_tot, uint, 0400);
 module_param(ip_pkt_list_tot, uint, 0400);
 module_param(ip_list_hash_size, uint, 0400);
 module_param(ip_list_perms, uint, 0400);
+module_param(ip_list_uid, uint, 0400);
+module_param(ip_list_gid, uint, 0400);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remember (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
 MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* files");
 
 
 struct recent_entry {
@@ -274,6 +280,8 @@ #ifdef CONFIG_PROC_FS
 		goto out;
 	}
 	t->proc->proc_fops = &recent_fops;
+	t->proc->uid       = ip_list_uid;
+	t->proc->gid       = ip_list_gid;
 	t->proc->data      = t;
 #endif
 	spin_lock_bh(&recent_lock);
