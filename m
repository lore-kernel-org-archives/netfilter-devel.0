From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 29/79: netns nf_conntrack: per-netns /proc/net/stat/nf_conntrack, /proc/net/stat/ip_conntrack
Date: Wed,  8 Oct 2008 12:47:00 +0200 (MEST)
Message-ID: <20081008104700.10423.58155.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45944 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbYJHKrC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:02 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8e9df80180b73d4107bf8fbf28b1633c541d2770
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Wed Oct 8 11:35:08 2008 +0200

    netfilter: netns nf_conntrack: per-netns /proc/net/stat/nf_conntrack, /proc/net/stat/ip_conntrack
    
    Show correct conntrack count, while I'm at it.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index fdc85b3..313ebf0 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -285,6 +285,7 @@ static const struct file_operations ip_exp_file_ops = {
 
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
+	struct net *net = seq_file_net(seq);
 	int cpu;
 
 	if (*pos == 0)
@@ -294,7 +295,7 @@ static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
-		return per_cpu_ptr(init_net.ct.stat, cpu);
+		return per_cpu_ptr(net->ct.stat, cpu);
 	}
 
 	return NULL;
@@ -302,13 +303,14 @@ static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *ct_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct net *net = seq_file_net(seq);
 	int cpu;
 
 	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu+1;
-		return per_cpu_ptr(init_net.ct.stat, cpu);
+		return per_cpu_ptr(net->ct.stat, cpu);
 	}
 
 	return NULL;
@@ -320,7 +322,8 @@ static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
 
 static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 {
-	unsigned int nr_conntracks = atomic_read(&init_net.ct.count);
+	struct net *net = seq_file_net(seq);
+	unsigned int nr_conntracks = atomic_read(&net->ct.count);
 	const struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
@@ -360,7 +363,8 @@ static const struct seq_operations ct_cpu_seq_ops = {
 
 static int ct_cpu_seq_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &ct_cpu_seq_ops);
+	return seq_open_net(inode, file, &ct_cpu_seq_ops,
+			    sizeof(struct seq_net_private));
 }
 
 static const struct file_operations ct_cpu_seq_fops = {
@@ -368,7 +372,7 @@ static const struct file_operations ct_cpu_seq_fops = {
 	.open    = ct_cpu_seq_open,
 	.read    = seq_read,
 	.llseek  = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_net,
 };
 
 static int __net_init ip_conntrack_net_init(struct net *net)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index a4fdbbf..169760d 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -194,6 +194,7 @@ static const struct file_operations ct_file_ops = {
 
 static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
+	struct net *net = seq_file_net(seq);
 	int cpu;
 
 	if (*pos == 0)
@@ -203,7 +204,7 @@ static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu + 1;
-		return per_cpu_ptr(init_net.ct.stat, cpu);
+		return per_cpu_ptr(net->ct.stat, cpu);
 	}
 
 	return NULL;
@@ -211,13 +212,14 @@ static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 
 static void *ct_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct net *net = seq_file_net(seq);
 	int cpu;
 
 	for (cpu = *pos; cpu < NR_CPUS; ++cpu) {
 		if (!cpu_possible(cpu))
 			continue;
 		*pos = cpu + 1;
-		return per_cpu_ptr(init_net.ct.stat, cpu);
+		return per_cpu_ptr(net->ct.stat, cpu);
 	}
 
 	return NULL;
@@ -229,7 +231,8 @@ static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
 
 static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 {
-	unsigned int nr_conntracks = atomic_read(&init_net.ct.count);
+	struct net *net = seq_file_net(seq);
+	unsigned int nr_conntracks = atomic_read(&net->ct.count);
 	const struct ip_conntrack_stat *st = v;
 
 	if (v == SEQ_START_TOKEN) {
@@ -269,7 +272,8 @@ static const struct seq_operations ct_cpu_seq_ops = {
 
 static int ct_cpu_seq_open(struct inode *inode, struct file *file)
 {
-	return seq_open(file, &ct_cpu_seq_ops);
+	return seq_open_net(inode, file, &ct_cpu_seq_ops,
+			    sizeof(struct seq_net_private));
 }
 
 static const struct file_operations ct_cpu_seq_fops = {
@@ -277,7 +281,7 @@ static const struct file_operations ct_cpu_seq_fops = {
 	.open	 = ct_cpu_seq_open,
 	.read	 = seq_read,
 	.llseek	 = seq_lseek,
-	.release = seq_release,
+	.release = seq_release_net,
 };
 
 static int nf_conntrack_standalone_init_proc(struct net *net)
