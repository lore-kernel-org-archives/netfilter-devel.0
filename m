Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099FD3FADFA
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 11:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789905532; cv=none; b=ah0OMQehPvprtOYddc4bnMVVo+NbgJrP+lPmVZGzzO15BldPshY9etirou+ag6dB3kK2rPzsFEh9Jfpbi6TO+B7hxCf48vL1VRvMcVI/7M39XZ/Er1FjK4ovyUeY7PQJmw5jUWreiumaFosR4SeFOF997sVMLXTlQEQAa08RtFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789905532; c=relaxed/simple;
	bh=K2evip5lAYAUyG00/cvTpPdWp2OUU13HAtu556M56Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gv7o/Tu8GlhJS9poYyrXMbKegr/SJGEvdLawnibqkJXkfeVQnNtRZdVHyVC7oRZk05FC735pli2IurWmiEc5rTNTdz27BUupAe3atSVmvQwfqqH+z2BHO6Go8bCW95qzBdBib6W+GATgwZe3pPzDihJpt578EmGsRvdB94K5U3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=qC9Tcye+; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="qC9Tcye+"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4aa0f1766so1667968a12.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 04:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789905530; x=1790510330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v1FW1MUX7B6vj5sqw5FVAUbuehSAGc/bp168fvHBMyA=;
        b=qC9Tcye+IhrYk81sMRqeQf+t8wBhZelkVfyorbK2tuy7xSEvMupNpNYJRCVGnPHvTo
         A8kQ9BqWKMxc3lBdQyDZZtUc5O7w++V40CfYKT1FrEqN5ELDj4f5dbl9pulfzIvfJdGx
         HYq7H4jzUcCZl4S7rTGEwMLYBfpN/t2CZ2bLl6nspMmGtmrkY5EVQR0COo/SR8fXOnQB
         jl9KbVHsgRRwK9HEg4jwLC6ew66tfhVEtv+fVjh6g3QloZTS7qZN5uGlmq5U4t/A/+Pj
         aCdSQiHZZ+S/QXZIxJUT0QKo4rwbJ10ojNYFjrkfwQ3fTHHW5dAHBvqs3oeTyoktEAVw
         j87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789905530; x=1790510330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v1FW1MUX7B6vj5sqw5FVAUbuehSAGc/bp168fvHBMyA=;
        b=vtTkzYQ0CAOoT3k2urzCJ1MufOF7jCNnlf/wfojElDpmqYFG9+qH9rn3Q30iuC4286
         Y0mD/aOTFjUHDzk4vpNsS0RuczM0bO6F1KyWUl2H9pKFc+2LY7FlqGiq4fyrDQ7rTjuI
         Upun5UoJOeWRscsvApEWI6hP1xhvW+CAo2pZh8AdHWDeCqxs81V35s6NDlzUA4zTxX1w
         wAxMkHRZKvDc7XcF7+GTIt5HwROAQIHRm1mQrGVQzOid/10VILNw1qhnmIKVVSo3fEmV
         t0q+UDSkSgG8tKOXVWYh/+pAkpYny+lUPBG2oZ2hqXxrKwEpVLEXhOhTWGXeqixKBbs1
         RjKA==
X-Gm-Message-State: AFuF++m4vN5DrMDul+PHI+Wlrtyg9d7mIEYcZ7y5S6Wd/V/0K/jx+P6i
	DWhXfbuISn99c925ojEys/6w2PkbSv/zx7JSvADpDNQiZEm2hLGJtv27oR8jmQQkU3iDy7w5ycY
	/46HtviUw
X-Gm-Gg: AYBFou2P3hrndTVcUAtzsE2et94Ul/YaNLH0qX2iocpZW5Vh8tUr3EZXuCaxXWWxcXE
	DOG37kyOx9vDcF3EEQVldMZxaP6tmB8zb65ZfMAghCsrtKRtRusEKcAIVqcYzOZMmqh+5WdJjKF
	aF6KoajkP3KqV+eddSHMC7Vp/Q9d3hlU991sPggkfcbaJVp35zJPQnz7me6/G5KJnQpEC7ASLi7
	l7zSXuA5WWWmh2fszMxNyHA+z/0/jJpQMVWzbP9OM4LqrukyPXmDvww9QqdSBiBOphV2OmNtGKY
	iurfs4qw57IKzpfrVt36NIr+NI9cmm3/Bt47fFbU0sK/jHejnd8xdcTn44e5BM5kUCtw3uJdby5
	ZWRAGBpSxxIEvQJvoZW6n5+uWVGlixtuzYWfdN0VH+Aj77tvNrg0FITdCVhCs7PaNY8J5Eu8gNC
	psvY0WmZCfz9AnPIGp5FMW0uyvfDQEWZfjEPvgHfRjK6hoS89rcLBR4B+2K5Om8/YFHIx52eNAh
	z98DY0zJRjRedvl+39IgHqQrrZaLg==
X-Received: by 2002:a17:90a:d64f:b0:39e:4c80:44b9 with SMTP id 98e67ed59e1d1-39e54dccbb8mr13643541a91.28.1789905530026;
        Sun, 20 Sep 2026 04:58:50 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c37c8e7sm8736746a91.9.2026.09.20.04.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 04:58:49 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: Zihan Xi <zihanx@nebusec.ai>,
	coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org
Subject: [PATCH nf v3 1/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Sun, 20 Sep 2026 11:58:22 +0000
Message-ID: <f88fc502b17b4022105a99eea407525807ee573e.1789885804.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789885804.git.zihanx@nebusec.ai>
References: <cover.1789885804.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The legacy IPv4, IPv6 and ARP table GET_INFO and GET_ENTRIES paths hold
the per-family xtables mutexes while copying table data to userspace. A
faultable destination may sleep indefinitely while the mutex is held,
blocking unrelated table and registry operations.

Disable page faults while each locked user copy runs. For GET_ENTRIES,
validate the table and requested size while holding the table mutex, then
release it before faulting in the output range. Reacquire the mutex and
revalidate the table and size before the nofault copy. If a nofault copy
fails, fault the range outside the lock and retry the operation up to three
times after the initial attempt. A failed fault-in returns -EFAULT;
repeated nofault failures are limited to four attempts in total and then
return -EFAULT. This avoids discarding a locked counter snapshot on the
common first fault. Move GET_INFO's fixed-size copy outside the table locks
and apply the same fault-safe handling to the IPv4/IPv6 compat GET_ENTRIES
paths.

The ebtables GET paths use a separate ebt_mutex and are outside this
IPv4/IPv6/ARP series.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v3:
  - Validate table and requested size before fault-in, then revalidate the
    table and size after lock reacquisition in native and IPv4/IPv6 compat
    GET_ENTRIES paths.
  - Make retry semantics explicit: one initial nofault attempt followed by
    at most three retries. Keep fault-in and retry decisions outside family
    mutexes; failed fault-in and exhausted retries return -EFAULT.
  - Keep the fixed-size GET_INFO copy outside table locks and brace compat
    lookup error arms.
  - Clarify ARP-only runtime coverage, privilege scope, helper build,
    holder/waiter evidence, QEMU configuration, and the NOT RUN
    crash-log status.
  - Regenerate the numbered patch and cover with LF line endings; use the
    standard 0001-*.patch filename.
  - v2 Link:
    https://lore.kernel.org/all/cover.1788961415.git.zihanx@nebusec.ai/
changes in v2:
  - Rebase onto current nf.git after 0bd7ed1a3263c
    ("netfilter: arp_tables: remove the 32bit compat interface").
    ARP GET_INFO and GET_ENTRIES use native paths only; IPv4 and IPv6
    retain compat handling.
  - Drop hung_task_panic and the 10-second hung_task timeout from the
    reproducer, as pointed out by Pablo Neira Ayuso; observe holder/waiter
    wchan instead.
  - v1 Link:
    https://lore.kernel.org/all/cover.1788244146.git.zihanx@nebusec.ai/

 net/ipv4/netfilter/arp_tables.c | 49 ++++++++++++++++---
 net/ipv4/netfilter/ip_tables.c  | 87 +++++++++++++++++++++++++++++----
 net/ipv6/netfilter/ip6_tables.c | 87 +++++++++++++++++++++++++++++----
 3 files changed, 197 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index db307fa..a857e67 100644
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
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -779,21 +782,51 @@ static int get_entries(struct net *net, struct arpt_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+retry:
+	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
+		goto out;
+	}
+
+	if (get.size != t->private->size) {
+		ret = -EAGAIN;
+		module_put(t->me);
+		xt_table_unlock(t);
+		goto out;
+	}
+
+	module_put(t->me);
+	xt_table_unlock(t);
+
+	/* Fault in only after validating the table and requested size. */
+	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
+				    get.size))
+		return -EFAULT;
+
 	t = xt_find_table_lock(net, NFPROTO_ARP, get.name);
 	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
 
-		if (get.size == private->size)
+		if (get.size != private->size) {
+			ret = -EAGAIN;
+		} else {
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
-		else
-			ret = -EAGAIN;
+		}
 
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
 		ret = PTR_ERR(t);
 
+out:
+	/* Allow three retries after the initial nofault copy. */
+	if (ret == -EFAULT && retries < 3) {
+		retries++;
+		goto retry;
+	}
+
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 809441c..90f4a26 100644
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
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1013,20 +1016,50 @@ get_entries(struct net *net, struct ipt_get_entries __user *uptr,
 		return -EINVAL;
 	get.name[sizeof(get.name) - 1] = '\0';
 
+retry:
+	t = xt_find_table_lock(net, AF_INET, get.name);
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
+		goto out;
+	}
+
+	if (get.size != t->private->size) {
+		ret = -EAGAIN;
+		module_put(t->me);
+		xt_table_unlock(t);
+		goto out;
+	}
+
+	module_put(t->me);
+	xt_table_unlock(t);
+
+	/* Fault in only after validating the table and requested size. */
+	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
+				    get.size))
+		return -EFAULT;
+
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
 		const struct xt_table_info *private = t->private;
-		if (get.size == private->size)
+		if (get.size != private->size) {
+			ret = -EAGAIN;
+		} else {
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
-		else
-			ret = -EAGAIN;
+		}
 
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
 		ret = PTR_ERR(t);
 
+out:
+	/* Allow three retries after the initial nofault copy. */
+	if (ret == -EFAULT && retries < 3) {
+		retries++;
+		goto retry;
+	}
+
 	return ret;
 }
 
@@ -1561,12 +1594,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 
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
@@ -1579,6 +1614,7 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 	int ret;
 	struct compat_ipt_get_entries get;
 	struct xt_table *t;
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1591,6 +1627,32 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+retry:
+	xt_compat_lock(AF_INET);
+	t = xt_find_table_lock(net, AF_INET, get.name);
+	if (!IS_ERR(t)) {
+		const struct xt_table_info *private = t->private;
+		struct xt_table_info info;
+
+		ret = compat_table_info(private, &info);
+		if (!ret && get.size != info.size)
+			ret = -EAGAIN;
+
+		xt_compat_flush_offsets(AF_INET);
+		module_put(t->me);
+		xt_table_unlock(t);
+	} else {
+		ret = PTR_ERR(t);
+	}
+	xt_compat_unlock(AF_INET);
+	if (ret)
+		goto out;
+
+	/* Fault in only after validating the table and requested size. */
+	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
+				    get.size))
+		return -EFAULT;
+
 	xt_compat_lock(AF_INET);
 	t = xt_find_table_lock(net, AF_INET, get.name);
 	if (!IS_ERR(t)) {
@@ -1606,10 +1668,17 @@ compat_get_entries(struct net *net, struct compat_ipt_get_entries __user *uptr,
 		xt_compat_flush_offsets(AF_INET);
 		module_put(t->me);
 		xt_table_unlock(t);
-	} else
+	} else {
 		ret = PTR_ERR(t);
+	}
 
 	xt_compat_unlock(AF_INET);
+out:
+	/* Allow three retries after the initial nofault copy. */
+	if (ret == -EFAULT && retries < 3) {
+		retries++;
+		goto retry;
+	}
 	return ret;
 }
 #endif
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f42fb96..4952bfd 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -25,6 +25,7 @@
 #include <linux/proc_fs.h>
 #include <linux/err.h>
 #include <linux/cpumask.h>
+#include <linux/pagemap.h>
 
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter/x_tables.h>
@@ -840,6 +841,7 @@ copy_entries_to_user(unsigned int total_size,
 
 	loc_cpu_entry = private->entries;
 
+	pagefault_disable();
 	/* FIXME: use iterator macros --RR */
 	/* ... then go back and fix counters and names */
 	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
@@ -877,6 +879,7 @@ copy_entries_to_user(unsigned int total_size,
 	}
 
  free_counters:
+	pagefault_enable();
 	vfree(counters);
 	return ret;
 }
@@ -959,6 +962,7 @@ static int compat_table_info(const struct xt_table_info *info,
 
 static int get_info(struct net *net, void __user *user, const int *len)
 {
+	struct ip6t_getinfo info;
 	char name[XT_TABLE_MAXNAMELEN];
 	struct xt_table *t;
 	int ret;
@@ -976,7 +980,6 @@ static int get_info(struct net *net, void __user *user, const int *len)
 #endif
 	t = xt_request_find_table_lock(net, AF_INET6, name);
 	if (!IS_ERR(t)) {
-		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
 #ifdef CONFIG_NETFILTER_XTABLES_COMPAT
 		struct xt_table_info tmp;
@@ -997,10 +1000,7 @@ static int get_info(struct net *net, void __user *user, const int *len)
 		info.size = private->size;
 		strcpy(info.name, name);
 
-		if (copy_to_user(user, &info, *len) != 0)
-			ret = -EFAULT;
-		else
-			ret = 0;
+		ret = 0;
 
 		xt_table_unlock(t);
 		module_put(t->me);
@@ -1010,6 +1010,8 @@ static int get_info(struct net *net, void __user *user, const int *len)
 	if (in_compat_syscall())
 		xt_compat_unlock(AF_INET6);
 #endif
+	if (!ret && copy_to_user(user, &info, *len) != 0)
+		ret = -EFAULT;
 	return ret;
 }
 
@@ -1020,6 +1022,7 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 	int ret;
 	struct ip6t_get_entries get;
 	struct xt_table *t;
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1030,20 +1033,50 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+retry:
+	t = xt_find_table_lock(net, AF_INET6, get.name);
+	if (IS_ERR(t)) {
+		ret = PTR_ERR(t);
+		goto out;
+	}
+
+	if (get.size != t->private->size) {
+		ret = -EAGAIN;
+		module_put(t->me);
+		xt_table_unlock(t);
+		goto out;
+	}
+
+	module_put(t->me);
+	xt_table_unlock(t);
+
+	/* Fault in only after validating the table and requested size. */
+	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
+				    get.size))
+		return -EFAULT;
+
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
 		struct xt_table_info *private = t->private;
-		if (get.size == private->size)
+		if (get.size != private->size) {
+			ret = -EAGAIN;
+		} else {
 			ret = copy_entries_to_user(private->size,
 						   t, uptr->entrytable);
-		else
-			ret = -EAGAIN;
+		}
 
 		module_put(t->me);
 		xt_table_unlock(t);
 	} else
 		ret = PTR_ERR(t);
 
+out:
+	/* Allow three retries after the initial nofault copy. */
+	if (ret == -EFAULT && retries < 3) {
+		retries++;
+		goto retry;
+	}
+
 	return ret;
 }
 
@@ -1570,12 +1603,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 
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
@@ -1588,6 +1623,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	int ret;
 	struct compat_ip6t_get_entries get;
 	struct xt_table *t;
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1600,6 +1636,32 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 
 	get.name[sizeof(get.name) - 1] = '\0';
 
+retry:
+	xt_compat_lock(AF_INET6);
+	t = xt_find_table_lock(net, AF_INET6, get.name);
+	if (!IS_ERR(t)) {
+		const struct xt_table_info *private = t->private;
+		struct xt_table_info info;
+
+		ret = compat_table_info(private, &info);
+		if (!ret && get.size != info.size)
+			ret = -EAGAIN;
+
+		xt_compat_flush_offsets(AF_INET6);
+		module_put(t->me);
+		xt_table_unlock(t);
+	} else {
+		ret = PTR_ERR(t);
+	}
+	xt_compat_unlock(AF_INET6);
+	if (ret)
+		goto out;
+
+	/* Fault in only after validating the table and requested size. */
+	if (fault_in_safe_writeable((char __user *)uptr->entrytable,
+				    get.size))
+		return -EFAULT;
+
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (!IS_ERR(t)) {
@@ -1615,10 +1677,17 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		xt_compat_flush_offsets(AF_INET6);
 		module_put(t->me);
 		xt_table_unlock(t);
-	} else
+	} else {
 		ret = PTR_ERR(t);
+	}
 
 	xt_compat_unlock(AF_INET6);
+out:
+	/* Allow three retries after the initial nofault copy. */
+	if (ret == -EFAULT && retries < 3) {
+		retries++;
+		goto retry;
+	}
 	return ret;
 }
 #endif
-- 
2.55.0.windows.3

