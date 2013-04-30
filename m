From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: net/netfilter/nf_log.c:373:38: error: 'struct netns_nf' has no
 member named 'proc_netfilter'
Date: Tue, 30 Apr 2013 20:01:18 +0200
Message-ID: <20130430180118.GA28315@localhost>
References: <517f72cc.fRNNPd+CdJx0ePvu%fengguang.wu@intel.com>
 <20130430140552.GA8837@localhost>
 <20130430175951.GA28292@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Cc: Gao feng <gaofeng@cn.fujitsu.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, kbuild-all@01.org,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53511 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab3D3SB3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:01:29 -0400
Content-Disposition: inline
In-Reply-To: <20130430175951.GA28292@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 30, 2013 at 10:05:52PM +0800, Fengguang Wu wrote:
> 
> FYI, kernel build failed on
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next master
> head:   d7c35d45ce991ae01b6008abef120173fc9c3814
> commit: dba554cc481ab6582202dd954f927e7657ee453a Merge remote-tracking branch 'net-next/master'
> date:   5 hours ago
> config: i386-randconfig-r05-0429 (attached as .config)
> 
> All error/warnings:
> 
>    In file included from net/netfilter/nf_log.c:4:0:
>    include/linux/proc_fs.h:58:20: error: redefinition of 'proc_set_size'
>    include/linux/proc_fs.h:51:20: note: previous definition of 'proc_set_size' was here
>    include/linux/proc_fs.h: In function 'proc_net_mkdir':
>    include/linux/proc_fs.h:69:2: error: implicit declaration of function 'proc_mkdir_data' [-Werror=implicit-function-declaration]
>    include/linux/proc_fs.h:69:2: warning: return makes pointer from integer without a cast [enabled by default]
>    net/netfilter/nf_log.c: In function 'nf_log_net_init':
> >> net/netfilter/nf_log.c:373:38: error: 'struct netns_nf' has no member named 'proc_netfilter'
>    net/netfilter/nf_log.c: In function 'nf_log_net_exit':
> >> net/netfilter/nf_log.c:381:37: error: 'struct netns_nf' has no member named 'proc_netfilter'
>    cc1: some warnings being treated as errors

I have attached a patch to resolve the issue. Thanks.


--huq684BweRXVnRxX
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-fix-compilation-without-CONFIG_PROC_FS.patch"

>From 4c5f54174742db8227ef117c78710a45b25368ce Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 30 Apr 2013 19:50:54 +0200
Subject: [PATCH] netfilter: nf_{log,queue}: fix compilation without CONFIG_PROC_FS

This patch fixes the following compilation error:

net/netfilter/nf_log.c:373:38: error: 'struct netns_nf' has no member named 'proc_netfilter'

if procfs is not set.

The netns support for nf_log, nfnetlink_log and nfnetlink_queue_core
requires CONFIG_PROC_FS in the removal path of their respective
/proc interface since net->nf.proc_netfilter is undefined in that
case.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c               |    5 ++++-
 net/netfilter/nfnetlink_log.c        |    2 ++
 net/netfilter/nfnetlink_queue_core.c |    2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 388656d..757951d 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -368,17 +368,20 @@ static int __net_init nf_log_net_init(struct net *net)
 	return 0;
 
 out_sysctl:
+#ifdef CONFIG_PROC_FS
 	/* For init_net: errors will trigger panic, don't unroll on error. */
 	if (!net_eq(net, &init_net))
 		remove_proc_entry("nf_log", net->nf.proc_netfilter);
-
+#endif
 	return ret;
 }
 
 static void __net_exit nf_log_net_exit(struct net *net)
 {
 	netfilter_log_sysctl_exit(net);
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("nf_log", net->nf.proc_netfilter);
+#endif
 }
 
 static struct pernet_operations nf_log_net_ops = {
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index faf1e93..d83d881 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1045,7 +1045,9 @@ static int __net_init nfnl_log_net_init(struct net *net)
 
 static void __net_exit nfnl_log_net_exit(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_log", net->nf.proc_netfilter);
+#endif
 }
 
 static struct pernet_operations nfnl_log_net_ops = {
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 2e0e835..4e27fa0 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -1285,7 +1285,9 @@ static int __net_init nfnl_queue_net_init(struct net *net)
 
 static void __net_exit nfnl_queue_net_exit(struct net *net)
 {
+#ifdef CONFIG_PROC_FS
 	remove_proc_entry("nfnetlink_queue", net->nf.proc_netfilter);
+#endif
 }
 
 static struct pernet_operations nfnl_queue_net_ops = {
-- 
1.7.10.4


--huq684BweRXVnRxX--
