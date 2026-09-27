Received: from mail-pz2-f39.google.com (mail-pz2-f39.google.com [74.125.228.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA57F35C190
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 04:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790483585; cv=none; b=UVPpiYY2mgMhQAmXHgs8U4BwXaCM5vur8dQ6Pw2tnKHDKYEIqIyWgtFWtUg2lsttFGXshEXiZNSWZGjh2S6JF9XTz9ndQ5QTZ0+x0P48A5VkSIon2osqoHj+f5nJe1w0CSzsrsqrvX94UIWm+XsTWYqHSFMaW9OVB0nGn44Sk4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790483585; c=relaxed/simple;
	bh=xsqrqLWroDkt+w1dqsgyfN6gAao12TVQ/8rQ99qoPcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfVQh5P7iui68n2Eicy/8IPjgga43inVrZ1z18YmT93+uRKhZ8NSPbav3W1kkUXFiPyOUHqXV/4zxTvcaQfiQDXCuRtAigo9FdC2yYjjVPo62L6byBDRCU1kA578rS+lU0B+tVKizgRBsQoxlwHELzURCJF1N3HciMdDFD8ItnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=RIg+98Mx; arc=none smtp.client-ip=74.125.228.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="RIg+98Mx"
Received: by mail-pz2-f39.google.com with SMTP id 41be03b00d2f7-cc794a06e5fso788704a12.3
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 21:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790483583; x=1791088383; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IZ59yV8zdea81Xxgtr1IK2wKbEz0g8t+HVq9txC7QJA=;
        b=RIg+98MxKtMuT31Vml/K2w4cJhnogjSktF9rKyob/QbfdT343GyNxkeSTo+vayTNcq
         aeODI/7YJqBHxwrqf499glU2mjjHoyZ+fIOR+jQ2H88wws9G8OKpuzc1tVtFpxexloIv
         bz9rRqiNW+EPDECziwGpSZy3ZUL49NdgevmKYgjeLKnEsdd+qJOoZAzsIDSongFKmEKw
         0SnG+71H+3l78g6ZrNCVUY1dn+bBm1va14JSH+Q3cpLymyxlIx9X8ZM/h2NWTIRMYduV
         qTHmV2KPYJPLsoof/eF1qZWpv13NAzNeqXQgdk/Cf+hXOnFaW6mbeQI4mfH13sBRtLoJ
         lArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790483583; x=1791088383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IZ59yV8zdea81Xxgtr1IK2wKbEz0g8t+HVq9txC7QJA=;
        b=MUZY8cNZeYooFMWbVV6ix8UY+wYlU2VlmpCN+ku9MaSJU9f1KiqZGoZvsPj5LJviAK
         8m1v5Ai40wpyab7iDWpjt0+XvAH79mgp94ZEnXHveuU3RLghxc2nd80y46REhMBkXhKa
         QO+x0SZ3xhTUlpRa5WvLm6ehYVyrJIcUh+Yt9GY6sb87FuiXGN0SqrVEPLYENw8uT4ca
         mv1Ewivdo/EdWyvsJTS+nzs4JuX6RJ+ZRkxtavHb5V3khhI5CBkJFhIpOCvIX99sl9uW
         fRW8go7j9J8UJpr7gAsSn3GF0Tap+Mfiu1rGzIthKH+aIr6QgHLpAPobkBt4kvlCk3Yq
         /JKA==
X-Gm-Message-State: AFq9FYLPcrEanJQMZ3KZfbAokWkiys8o/VH1n20yDoYAgERqmNqjRbk8
	c0dL5M8OhgYTvq0wzAEZdwyWsBkkCRPl0pk0pI93Mrwq4EurwYcumH2/W936seuGgEy5nZck/J8
	sW+UpLA==
X-Gm-Gg: AYBFou3tswWmYQvlKon6aPOZdLVVT9hu2LgmDU81udbk56Nd5sGR7SJMdij9UFRznMd
	FXp20vCE09QHu22jq5oYzA6jFshwRQgHr8NJArxeIerpC71UxHkkl8OHxa59zOj5JAtfOEq9wwx
	0Yw55idE8HN3GksXEBuAn0b10IdSC6Drbxd6bigAiOQhJfexwf8v7gWoOLgFkbvDQ2/8MSKG8mT
	QUuAL48AoEAZqaEiWy+uPDLNhmQtbv51qTefTnS+IGMeCoDFvf7XPofwmvyLhb5oktm3fO9GmA9
	neFdx0qD8SKjC5w4awwUjvwgX2ggc7Ud6KC9N4M6D0fWP0CTerpfVyBKmzfzIJdXZfENu7HgHyO
	UhCQOvNHmGXxVPGGWd6wItxL8JlkJj8Sp5qgLP07gQ2KIWFhnvtAIuHWFcwtGAt9SfYrp2mPVF2
	qTHOidg2FRVnIbL3dagYHCZKynuT+FGfZeK1aJC7GmmQT6ZC63T/ofaBx1m/O+ueA5FJvyPiNYI
	7tyliJJjx5w/saMoM4KOCxh2qHbRw==
X-Received: by 2002:a17:90b:548c:b0:39e:6c6a:656c with SMTP id 98e67ed59e1d1-3a0bb63224amr4948403a91.47.1790483582796;
        Sat, 26 Sep 2026 21:33:02 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0e05d674dsm2795629a91.4.2026.09.26.21.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 21:33:02 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zihanx@nebusec.ai,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH nf v4 1/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Sun, 27 Sep 2026 04:31:39 +0000
Message-ID: <8e83886fd57c91bc2aede89ec7a10392be7bcaef.1790439054.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790439054.git.zihanx@nebusec.ai>
References: <cover.1790439054.git.zihanx@nebusec.ai>
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
index db307fa49..a857e67f9 100644
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
index 809441ced..90f4a263d 100644
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
index 313c4aac3..a737c5b37 100644
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
2.43.0

