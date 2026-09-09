Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE74157F75B
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2026 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964637; cv=none; b=fBOHu1xA6it/XomdlqGNVK+PyruSbZdj724lbzy0Z/Wk2XYsMJ1s00W63Is8K4Xmh0TfPWP1sEC+V3aTGanG/FTADgTgPyZS9OBw9uvGSmzOInAQnZEQXsSghOLtTa9TI9W0ZhisHqv+Sq6G8b0kN2p6fCw9kbh69MtkjT24jqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964637; c=relaxed/simple;
	bh=XAeMdlYimKGJc3ti1ha2/ZiCzFnirh7Ki5zeO+6i5EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0TZod1hkddDK90lt++gqKo52/UPFm77vpvX+6GQWZSY2DjyQQ0E3F3Zfi6Z6VjjjGpk9Zdh4IhwcDwUVczpTFYiR6mEps4x7H6phon2WGCh9WOnC7nm15HPBzDLv3vGbVBsS3mjArI7LPhUD3fvtdAxlt6MsDGsd0rNARIt7qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=deNyLPCn; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="deNyLPCn"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-ca12086c06eso4610130a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2026 07:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788964635; x=1789569435; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AnZ/fPcgKjflxJLFmbxeWbpyuVjiHN/0svFus5OARoM=;
        b=deNyLPCnVC45lXwiavvPNs8bP4zE7WZrH3r+8kHERiqCqLVAo+C1oKVQG1fTtOJfYH
         iFKzXg52EgmSmmU/Y9lW/+5N4U64GKbKnzzClpu0W5o9AS+DYexqK8eDR7EMFekMFu4d
         P9SS8IBe8q4hgD2yrcgQ/ZwOpRbsC6nPIsr6biaqW5r3bqNIkAm0/d7PU/OhubnNzeaf
         R+P82BIFPo8r75nlsqoEwT1qVXWP9asgjyyusblRGF7pnJ9d+aorhLnbzHu9082vPUz3
         7m/g4qCBorig7B24GN6yMFr9ojFZEQCQRZUzv1YDnA8g+qaLl20UrdZAzi/X96f3Mse2
         sNng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788964635; x=1789569435;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AnZ/fPcgKjflxJLFmbxeWbpyuVjiHN/0svFus5OARoM=;
        b=PU9TtFfOaNRxd0kr6Waw7uPwU1kdPeJXi/EHxljspP7YnkI4dI2JFBJqlm4aNN2LN3
         ewZvy1qmjIrEesQK7gidgtK3b6DiZkl1w44siX9T7N0BHotCheRV3TvTDgoKNB0ehbzn
         xAz8Sg8vfmDX8lU08Ca4w9ArxxAL0czcStqde2U3D5SxG26LfU2H3NWUa5HIqMN7o8JL
         ZKBXgngEjfLWVispPQt9tYl0XE8W2xRKp5ZkCkpsZ3tCVRITnisuYTp1X0LakYBKpFiQ
         ChXKe1+fFiS+mpaunuREdxy+gfsTsY4t2VveVx/q4rHqHgQBC7MLBU9LLsoFjRuu2rii
         tecw==
X-Forwarded-Encrypted: i=1; AKwUvBwduCFdQCq/c7L7wwD63a3gjHWvpXQuIZ6SiMRZHRFSE3yUZOfQcuYxuzVo0arYM4upmGyW0Fk7bxLTw7NEmmI=@vger.kernel.org
X-Gm-Message-State: AFuF++mqAHOTdXuf9OF218mvi08/FGemaZLOzitOhlS952pak7slHGOc
	Ysxz+t0lRCtQcmMtgtwzMyJ3VJKesMnePRwo2LmxqfVagbeYvOsPndIMPyO9n+azi1Yt
X-Gm-Gg: AYBFou0hvgM0WbzHeZ+yFJy0YM0A3WaXPyn3kmPpBe28m1OfLzTTghiGHI5z+E8gTul
	OWNkbx3WxmoSJ/B2Y45DY1E2KbMJbTftaspeN86tTmFtKpe5ehitIYVk7jPHBNzYbAqc/MPXD+z
	rp6jwOkiQfQkwK5IggkbEDiwKYbzYmMo6eIxv+KUGfsElCWMmPTbn019UrlYZoM2s7Kq5KpHWzq
	I4F2LRjP5wJeZ+Jpq4scvmc3MNYm2qP7lY12gLP0D6ic0be7zTcxvFT3o0EcIQgC27Xgir20dzQ
	gFTwZt3oIbEgavt8L+cw8UKgh04oVKQ7CcGXU8RAAiapFnIkI+dS2pyMbDjjxmrqretaUbNokan
	pdEzJZqZyJDginaR34EKz2yLESqRx0jbJSy6HQ3/wlGwVPaiDAq01XjUyRjd/tv62mvShyVxVop
	5UpHwz0lrwILlbJnqZ9BGtM9nPIy9p+yT7/zyIVbUJVJVfMie0EuhrP3VktJEY61qnld29Z2fF+
	XWUoHIjefov3YOnDg0vyZMcbGm/gg==
X-Received: by 2002:a05:6300:6cc3:10b0:3da:755f:a031 with SMTP id adf61e73a8af0-3da755fa627mr22358075637.12.1788964635053;
        Wed, 09 Sep 2026 07:37:15 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc455451b46sm6784762a12.18.2026.09.09.07.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 07:37:14 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>
Subject: [PATCH nf v2 1/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Wed,  9 Sep 2026 14:36:58 +0000
Message-ID: <bef677757277dc3c29f503eddc74cf1fbc5fb5fd.1788961415.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1788961415.git.zihanx@nebusec.ai>
References: <cover.1788961415.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The legacy IPv4, IPv6 and ARP table GET_INFO and GET_ENTRIES paths hold
the per-family xtables mutexes while copying table data to userspace. A
faultable destination can therefore sleep indefinitely with the mutex held,
blocking unrelated table and registry operations.

Disable page faults during the locked copy, release the lock, fault in the
output range, and retry once. Move GET_INFO's fixed-size copy outside the
table locks and apply the same retry handling to the remaining IPv4/IPv6
compat GET_ENTRIES paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Rebase onto current nf.git after 0bd7ed1a3263c ("netfilter:
    arp_tables: remove the 32bit compat interface"). ARP GET_INFO
    and GET_ENTRIES are updated on the native paths only. IPv4 and
    IPv6 still include the compat GET_ENTRIES retry.
  - Drop hung_task_panic and the 10-second hung_task timeout from the
    reproducer, as pointed out by Pablo Neira Ayuso. Observe the stall
    through holder/waiter wchan instead.
  - v1 Link: https://lore.kernel.org/all/cover.1788244146.git.zihanx@nebusec.ai/

 net/ipv4/netfilter/arp_tables.c | 22 +++++++++++++++++-----
 net/ipv4/netfilter/ip_tables.c  | 33 ++++++++++++++++++++++++++++-----
 net/ipv6/netfilter/ip6_tables.c | 33 ++++++++++++++++++++++++++++-----
 3 files changed, 73 insertions(+), 15 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index db307fa49f3f6..7b43269aa6b21 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
+#include <linux/pagemap.h>
 #include <net/sock.h>
 #include <linux/uaccess.h>
 
@@ -695,6 +696,7 @@ static int copy_entries_to_user(unsigned int total_size,
 
 	loc_cpu_entry = private->entries;
 
+	pagefault_disable();
 	/* FIXME: use iterator macros --RR */
 	/* ... then go back and fix counters and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
@@ -719,12 +721,14 @@ static int copy_entries_to_user(unsigned int total_size,
 	}
 
  free_counters:
+	pagefault_enable();
 	vfree(counters);
 	return ret;
 }
 
 static int get_info(struct net *net, void __user *user, const int *len)
 {
+	struct arpt_getinfo info;
 	char name[XT_TABLE_MAXNAMELEN];
 	struct xt_table *t;
 	int ret;
@@ -738,7 +742,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	name[XT_TABLE_MAXNAMELEN-1] = '\0';
 	t = xt_request_find_table_lock(net, NFPROTO_ARP, name);
 	if (!IS_ERR(t)) {
-		struct arpt_getinfo info;
 		const struct xt_table_info *private = t->private;
 
 		memset(&info, 0, sizeof(info));
@@ -751,15 +754,14 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		info.size = private->size;
 		strscpy(info.name, name);
 
-		if (copy_to_user(user, &info, *len) != 0)
-			ret = -EFAULT;
-		else
-			ret = 0;
+		ret = 0;
 		xt_table_unlock(t);
 		module_put(t->me);
 	} else
 		ret = PTR_ERR(t);
 
+	if (!ret && copy_to_user(user, &info, *len) != 0)
+		ret = -EFAULT;
 	return ret;
 }
 
@@ -769,6 +771,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 	int ret;
 	struct arpt_get_entries get;
 	struct xt_table *t;
+	bool faulted = false;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -779,6 +782,7 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+ retry:
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
@@ -794,6 +798,14 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 	} else
 		ret = PTR_ERR(t);
 
+	if (ret == -EFAULT && !faulted) {
+		faulted = true;
+		if (fault_in_writeable((char __user *)uptr->entrytable,
+				       get.size))
+			return -EFAULT;
+		goto retry;
+	}
+
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 809441cedcedc..e029072b07501 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -21,6 +21,7 @@
 #include <linux/proc_fs.h>
 #include <linux/err.h>
 #include <linux/cpumask.h>
+#include <linux/pagemap.h>
 
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -824,6 +825,7 @@ copy_entries_to_user(unsigned int total_size,
 
 	loc_cpu_entry = private->entries;
 
+	pagefault_disable();
 	/* FIXME: use iterator macros --RR */
 	/* ... then go back and fix counters and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
@@ -861,6 +863,7 @@ copy_entries_to_user(unsigned int total_size,
 	}
 
  free_counters:
+	pagefault_enable();
 	vfree(counters);
 	return ret;
 }
@@ -943,6 +946,7 @@ static int compat_table_info(const struct xt_table_info *info,
 
 static int get_info(struct net *net, void __user *user, const int *len)
 {
+	struct ipt_getinfo info;
 	char name[XT_TABLE_MAXNAMELEN];
 	struct xt_table *t;
 	int ret;
@@ -960,7 +964,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
 #endif
 	t = xt_request_find_table_lock(net, AF_INET, name);
 	if (!IS_ERR(t)) {
-		struct ipt_getinfo info;
 		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
@@ -981,10 +984,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		info.size = private->size;
 		strscpy(info.name, name);
 
-		if (copy_to_user(user, &info, *len) != 0)
-			ret = -EFAULT;
-		else
-			ret = 0;
+		ret = 0;
 
 		xt_table_unlock(t);
 		module_put(t->me);
@@ -994,6 +994,8 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	if (in_compat_syscall())
 		xt_compat_unlock(AF_INET);
 #endif
+	if (!ret && copy_to_user(user, &info, *len) != 0)
+		ret = -EFAULT;
 	return ret;
 }
 
@@ -1004,6 +1006,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 	int ret;
 	struct ipt_get_entries get;
 	struct xt_table *t;
+	bool faulted = false;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1013,6 +1016,7 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 		return -EINVAL;
 	get.name[sizeof(get.name) - 1] = '\0';
 
+ retry:
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
@@ -1027,6 +1031,14 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 	} else
 		ret = PTR_ERR(t);
 
+	if (ret == -EFAULT && !faulted) {
+		faulted = true;
+		if (fault_in_writeable((char __user *)uptr->entrytable,
+				       get.size))
+			return -EFAULT;
+		goto retry;
+	}
+
 	return ret;
 }
 
@@ -1561,12 +1573,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 
 	pos = userptr;
 	size = total_size;
+	pagefault_disable();
 	xt_entry_foreach(iter, private->entries, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
 						&size, counters, i++);
 		if (ret != 0)
 			break;
 	}
+	pagefault_enable();
 
 	vfree(counters);
 	return ret;
@@ -1579,6 +1593,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	int ret;
 	struct compat_ipt_get_entries get;
 	struct xt_table *t;
+	bool faulted = false;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1591,6 +1606,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+ retry:
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
@@ -1610,6 +1626,13 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 		ret = PTR_ERR(t);
 
 	xt_compat_unlock(AF_INET);
+	if (ret == -EFAULT && !faulted) {
+		faulted = true;
+		if (fault_in_writeable((char __user *)uptr->entrytable,
+				       get.size))
+			return -EFAULT;
+		goto retry;
+	}
 	return ret;
 }
 #endif
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 313c4aac377aa..a64fcd3a9948c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -25,6 +25,7 @@
 #include <linux/proc_fs.h>
 #include <linux/err.h>
 #include <linux/cpumask.h>
+#include <linux/pagemap.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
@@ -845,6 +846,7 @@ copy_entries_to_user(unsigned int total_size,
 
 	loc_cpu_entry = private->entries;
 
+	pagefault_disable();
 	/* FIXME: use iterator macros --RR */
 	/* ... then go back and fix counters and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
@@ -882,6 +884,7 @@ copy_entries_to_user(unsigned int total_size,
 	}
 
  free_counters:
+	pagefault_enable();
 	vfree(counters);
 	return ret;
 }
@@ -964,6 +967,7 @@ static int compat_table_info(const struct xt_table_info *info,
 
 static int get_info(struct net *net, void __user *user, const int *len)
 {
+	struct ip6t_getinfo info;
 	char name[XT_TABLE_MAXNAMELEN];
 	struct xt_table *t;
 	int ret;
@@ -981,7 +985,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
 #endif
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
-		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
@@ -1002,10 +1005,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		info.size = private->size;
 		strcpy(info.name, name);
 
-		if (copy_to_user(user, &info, *len) != 0)
-			ret = -EFAULT;
-		else
-			ret = 0;
+		ret = 0;
 
 		xt_table_unlock(t);
 		module_put(t->me);
@@ -1015,6 +1015,8 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	if (in_compat_syscall())
 		xt_compat_unlock(AF_INET6);
 #endif
+	if (!ret && copy_to_user(user, &info, *len) != 0)
+		ret = -EFAULT;
 	return ret;
 }
 
@@ -1025,6 +1027,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 	int ret;
 	struct ip6t_get_entries get;
 	struct xt_table *t;
+	bool faulted = false;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1035,6 +1038,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+ retry:
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
@@ -1049,6 +1053,14 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 	} else
 		ret = PTR_ERR(t);
 
+	if (ret == -EFAULT && !faulted) {
+		faulted = true;
+		if (fault_in_writeable((char __user *)uptr->entrytable,
+				       get.size))
+			return -EFAULT;
+		goto retry;
+	}
+
 	return ret;
 }
 
@@ -1575,12 +1587,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 
 	pos = userptr;
 	size = total_size;
+	pagefault_disable();
 	xt_entry_foreach(iter, private->entries, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
 						&size, counters, i++);
 		if (ret != 0)
 			break;
 	}
+	pagefault_enable();
 
 	vfree(counters);
 	return ret;
@@ -1593,6 +1607,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	int ret;
 	struct compat_ip6t_get_entries get;
 	struct xt_table *t;
+	bool faulted = false;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1605,6 +1620,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+ retry:
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
@@ -1624,6 +1640,13 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		ret = PTR_ERR(t);
 
 	xt_compat_unlock(AF_INET6);
+	if (ret == -EFAULT && !faulted) {
+		faulted = true;
+		if (fault_in_writeable((char __user *)uptr->entrytable,
+				       get.size))
+			return -EFAULT;
+		goto retry;
+	}
 	return ret;
 }
 #endif
-- 
2.43.0

