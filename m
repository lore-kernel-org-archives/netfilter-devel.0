Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974EFC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 13:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358532AbiBDN1K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiBDN1J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 08:27:09 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067B7C06173D
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 05:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EEEEsK+zWsg3zbpOyq5pjJJRjAshuNda/9rS1H2vqcI=; b=EbEjEWT6Q3+jTdp3fY8UJwvmnr
        wE02jdljZMNJ4M97C7CFRmBiO7NI+87SWzqZR+hVbIbMugXDrC51iDjnQCW2cmGvH51FMCVla8IKX
        UITvLM+/RwOGs4D7Ua3krFS1Dv35VYZ8+7+rdH6RR9e2/ALqB0FXH5xCPBBqeYYRR+2kp40XibZbb
        2cjIHVLHVQH2z6zX49fw2SWfeHAKY5WP/lgqDMoYu1a3AxA0dTCmW2Tb1g5t3fEXL0XqQNLUiNXwy
        C1ru6OWyZ4ifqchBytXldmTgGsb46ywPKWKMYo7fwLUWcwZBa3Bfln8hGpcvnOg6Vg65/iyxwAr1L
        GS9eWBEQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nFycF-00BLdH-0x; Fri, 04 Feb 2022 13:27:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [xtables-addons PATCH 1/2] extensions: replace `PDE_DATA`
Date:   Fri,  4 Feb 2022 13:26:42 +0000
Message-Id: <20220204132643.1212741-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204132643.1212741-1-jeremy@azazel.net>
References: <20220204132643.1212741-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `PDE_DATA` function for retrieving private data from a procfs inode
has been replaced by `pde_data` in 5.17.  Replace all instances of the
former with the latter, but add a macro to xtables_compat.h in order to
preserve compatibility with older kernels.

Link: https://lore.kernel.org/lkml/20211124081956.87711-1-songmuchun@bytedance.com/
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/compat_xtables.h   | 4 ++++
 extensions/pknock/xt_pknock.c | 2 +-
 extensions/xt_DNETMAP.c       | 6 +++---
 extensions/xt_condition.c     | 4 ++--
 extensions/xt_quota2.c        | 4 ++--
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/extensions/compat_xtables.h b/extensions/compat_xtables.h
index eff3bde91c32..5ea2af6a4a79 100644
--- a/extensions/compat_xtables.h
+++ b/extensions/compat_xtables.h
@@ -27,6 +27,10 @@
 #	define ip6_route_me_harder(xnet, xsk, xskb) ip6_route_me_harder((xnet), (xskb))
 #endif
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5, 17, 0)
+#define pde_data(inode) PDE_DATA(inode)
+#endif
+
 static inline struct net *par_net(const struct xt_action_param *par)
 {
 	return par->state->net;
diff --git a/extensions/pknock/xt_pknock.c b/extensions/pknock/xt_pknock.c
index 3c304e0b20c7..287d525f27d5 100644
--- a/extensions/pknock/xt_pknock.c
+++ b/extensions/pknock/xt_pknock.c
@@ -277,7 +277,7 @@ pknock_proc_open(struct inode *inode, struct file *file)
 	int ret = seq_open(file, &pknock_seq_ops);
 	if (ret == 0) {
 		struct seq_file *sf = file->private_data;
-		sf->private = PDE_DATA(inode);
+		sf->private = pde_data(inode);
 	}
 	return ret;
 }
diff --git a/extensions/xt_DNETMAP.c b/extensions/xt_DNETMAP.c
index b850918325da..47cf704a2fd5 100644
--- a/extensions/xt_DNETMAP.c
+++ b/extensions/xt_DNETMAP.c
@@ -576,14 +576,14 @@ static int dnetmap_seq_open(struct inode *inode, struct file *file)
 	if (st == NULL)
 		return -ENOMEM;
 
-	st->p = PDE_DATA(inode);
+	st->p = pde_data(inode);
 	return 0;
 }
 
 static ssize_t
 dnetmap_tg_proc_write(struct file *file, const char __user *input,size_t size, loff_t *loff)
 {
-	struct dnetmap_prefix *p = PDE_DATA(file_inode(file));
+	struct dnetmap_prefix *p = pde_data(file_inode(file));
 	struct dnetmap_entry *e;
 	char buf[sizeof("+192.168.100.100:200.200.200.200")];
 	const char *c = buf;
@@ -793,7 +793,7 @@ static int dnetmap_stat_proc_show(struct seq_file *m, void *data)
 
 static int dnetmap_stat_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, dnetmap_stat_proc_show, PDE_DATA(inode));
+	return single_open(file, dnetmap_stat_proc_show, pde_data(inode));
 }
 
 static const struct proc_ops dnetmap_stat_proc_fops = {
diff --git a/extensions/xt_condition.c b/extensions/xt_condition.c
index cf07966e71b7..41639c317e7f 100644
--- a/extensions/xt_condition.c
+++ b/extensions/xt_condition.c
@@ -83,14 +83,14 @@ static int condition_proc_show(struct seq_file *m, void *data)
 
 static int condition_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, condition_proc_show, PDE_DATA(inode));
+	return single_open(file, condition_proc_show, pde_data(inode));
 }
 
 static ssize_t
 condition_proc_write(struct file *file, const char __user *buffer,
                      size_t length, loff_t *loff)
 {
-	struct condition_variable *var = PDE_DATA(file_inode(file));
+	struct condition_variable *var = pde_data(file_inode(file));
 	char newval;
 
 	if (length > 0) {
diff --git a/extensions/xt_quota2.c b/extensions/xt_quota2.c
index 70bf0957e815..182771e26ca0 100644
--- a/extensions/xt_quota2.c
+++ b/extensions/xt_quota2.c
@@ -73,14 +73,14 @@ static int quota_proc_show(struct seq_file *m, void *data)
 
 static int quota_proc_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, quota_proc_show, PDE_DATA(inode));
+	return single_open(file, quota_proc_show, pde_data(inode));
 }
 
 static ssize_t
 quota_proc_write(struct file *file, const char __user *input,
                  size_t size, loff_t *loff)
 {
-	struct xt_quota_counter *e = PDE_DATA(file_inode(file));
+	struct xt_quota_counter *e = pde_data(file_inode(file));
 	char buf[sizeof("+-18446744073709551616")];
 
 	if (size > sizeof(buf))
-- 
2.34.1

