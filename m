Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A3349482D
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 10:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455639; cv=none; b=UsjgZ+Bk6VYHBfRa37UaCjU+VEfPc+IOqPeB2+CmouquteXM+0h6MEmMW+Kc43GaiufnLM2jn+kxllofFZZ2FeKfVShYU7DZb+gwDvA2TnCG6S48j8V4EwMLTmhIPByt4IdRaZBHMSAvZ7hSoF0kNxYZMqFjiy5317NpwNg7jUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455639; c=relaxed/simple;
	bh=DjGwBfZSvd8btbI/p2gYfDliUcOIulkFdDUCKy8yYuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GE+p7tmKQhSmTiyGGGpqL1afzfSBxsmz5lDWW2QeigfpoKwt/UudjgvBug9nV8v5le+q5uBwOXcqH/f+ozg7rBQx7inTS4LToFdXX6nULbsIqA1PDBWK1sVPZnk6u1qxWy30HT4mNr1p9g6pzz5mJfWBMZH9NyfjdrZOeMtlWwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=u1nr0poJ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="u1nr0poJ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-887beafb714so1544120b3a.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 03:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791455637; x=1792060437; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zatC3v9UrRkDPdYCnEVUhes38YTr7DH6qxsj5dYxtsw=;
        b=u1nr0poJWEDCoren6C+hbHZDZtTP46asq+oHkbYZLx+L/PTqKVXYyOWNuRCySQS7gv
         +LXBMXD2M4rbClc0861Wo+/CVBA35N0U7Cb0xkY3mCNXd4ZtV17/oh/VOcPKYlmXZ3za
         temLH7WbUFAEOKHvsOhyoMApCrmNRxlou+ykE2+AANkpTRSpJGOj5ZYh4zUhWkn9GEp1
         grcWWbaM9DeCA5k0TSfmINgqufSIypBLOwCPdvYbaPY6slNRakalj9LBuqh7uj00Q9t9
         fq+Vxp1N9rLnjVfipUqLwe5Oxlz4OZbigLJMCiwhNeZGVeRKZDS10lCTtZBbkEsLvZuY
         FoZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455637; x=1792060437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zatC3v9UrRkDPdYCnEVUhes38YTr7DH6qxsj5dYxtsw=;
        b=TRbvUXzicYeIwmWwutkJ0ZGg3espZ1JYsNgYr275QAi1cKe1/qfN5GObxZtEUTSmjn
         nXdLFICgzwdSFMAV2eoiN5p+uUlKrp/RTdujuff1NzGSubBi538Ob3Ygovaew8aBOeDl
         t38MjSE3t3rqipEp8zPf+zx7pHAxcGy+50Nrsiv0djnSElAtXXH2idnBSu4EoJ4GCpG+
         lWHmRbn9s3EwdFOG3G6PRdUjB60ML7+HTs8xtQU4Xf+avSnzKFpL5shkRLx6OzB0I60y
         rukAiMJ0Xa7rCXtIiLj3paLFIX09rKNnsqwwm9z7HdJ7CsqORIApI3QfrJi0VMpknWlg
         4HcQ==
X-Gm-Message-State: AFuF++mcfIQsy7XS5Mx/1KqB0mxeCuWHc6Ozy3ukybh16rg/jorWPXSw
	RB5MoGB2Ibo0oiJY9DM7Q7HyNzWax0bHX3UDzYOUSXcHV9veqfz4zxdrFZ6oqcLWGW3YNeEKRVP
	M4CutGe++
X-Gm-Gg: AYBFou3FFoPRUElg/pZQMROqBAOApXx3yyKig6/JKEWEKgu5rNsor1PdwOqNNcpZP9i
	j9/zZbXGlRxKrfsuNhjhkKjQnLOloXxuzRR3RTCHNPuXIXGYB2sKq3cAELNVdqQ9drqyXl6PTek
	NlePtfpZtw4z2Pu8oK5uogUisFlJV5wTHdxeJtv8jGxvyl6HHB/3CronkQWEYgse5uL8FYp75na
	AtEXVSMZiXQjJCFlUmNJ2frZgKuQ3sy0TB5AJeC6w4EO8frhP5RtWoqragOffwa4/w0bgeISMuU
	mSY0diEDUEJzTIz/u0Nq1bjg4iAgBBUAiY0B5MURNZrJd6vh5H5vvcNKQ+n+AjcSvx9YgfC+u+U
	A7HfsN+eFuRjHJh9rIaPyy93KgOtkMYK8fi5mVDrIdy+5JaRgG8NlK8i74Xcy8BMc60YDJjjlBI
	H3U3ZzrVqrOlkG+dSmdF3oErohFT0Ta9QrbwJsuvLpte2GMe+ghJAHvzTxUjqAHN8FIzsBLrDfK
	g9KN/YcDMm7TCyywCWAk7p5sCZSDA==
X-Received: by 2002:a05:6a21:3b90:b0:3e0:e60f:2e4c with SMTP id adf61e73a8af0-3e13410d924mr5344280637.66.1791455637088;
        Thu, 08 Oct 2026 03:33:57 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0a8bfd740sm2780663a12.5.2026.10.08.03.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:33:56 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf v5 1/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Thu,  8 Oct 2026 10:33:47 +0000
Message-ID: <55fb98c47498e0756e17f8d07e82cfcd5022a4b4.1791422956.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791422956.git.zihanx@nebusec.ai>
References: <cover.1791422956.git.zihanx@nebusec.ai>
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
changes in v5:
  - Rebase the unchanged three-file fix onto nf.git main at
    ab699d296e06 ("Merge branch
    'net-always-dissect-gso-packets-in-__virtio_net_hdr_to_skb'").
  - Resend as a new thread because the v4 series has aged; retain the
    v4 lore link in the cover and below.
  - v4 Link:
    https://lore.kernel.org/all/cover.1790439054.git.zihanx@nebusec.ai/
changes in v4:
  - Keep the source diff unchanged from v3 while rebasing it onto refreshed
    nf.git main at 9c572a83037a ("net/sched: fix potential stack infoleak in
    em_text_dump()").
  - Replace the detailed v3 cover text with a concise summary and add the v3
    link:
    https://lore.kernel.org/all/cover.1789885804.git.zihanx@nebusec.ai/
changes in v3:
  - Validate the table and requested size before fault-in, then revalidate
    both after lock reacquisition in native and IPv4/IPv6 compat GET_ENTRIES.
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
index 313c4aa..a737c5b 100644
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
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1035,20 +1038,50 @@ get_entries(struct net *net, struct ip6t_get_entries __user *uptr,
 
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
 
@@ -1575,12 +1608,14 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 
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
@@ -1593,6 +1628,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 	int ret;
 	struct compat_ip6t_get_entries get;
 	struct xt_table *t;
+	unsigned int retries = 0;
 
 	if (*len < sizeof(get))
 		return -EINVAL;
@@ -1605,6 +1641,32 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 
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
@@ -1620,10 +1682,17 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
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
2.25.1

