Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793714618;
	b=UwT7EBHVPHPHlKBRUbmBsPlMwlNGOFgoDBf2TLC5T1JPcXiBZvvvvZxdTh/X87uATXnz
	 1hDQgPn+9qrLAjFnUQ+ddwvTWWB21nQrvStBmREvtNessiOra1VgF3K5WUTxv+LsGUlZp
	 hFPV6q1q6Q+fnbGjEanxFbfG4iEfc76HoCv7DDLx4KLOtNuKTKHuNgxERMbUpyqVnGRJd
	 6tfIOC1ybdc0wJKK0xxUKMCkVwd4K6k46se8tQbAc/bAe9/YTz+WQc+C27lfgJLFsu7k+
	 v/SifG3wn9jWA0kVmRHL2eBgDtkjj3rAgUXMbfMBo+gMfjiv3/EafNvXjwKX1d5oSBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793714618;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=TaFMJ0UW3LigUoc0s6WNECoAhHhD44ITTyoS2M06BTs=;
	b=IIaBSC8KZykw+hiiPIPpKSh1TDq/03Ye3DC3JEjmigLo6/eqS4BPFcGZwtNuEzZj9CKP
	 OYWGTanW9b7rEV3sycX0JA0pa5VXf/lhgzXHltcTm3f/I2LxfWtW1mqhf6ez5iBNcdMQR
	 upEw0OkcoSA4y43PqTwwGxeRH1bkWDJDVTcK1R/Rdckd9Ja5jUoA3EJP37lwRKZHWBgWt
	 XW86YCozQyzNK8pg0CERcl78eq/BkvOWwjdImYNC9Q+geYs3VCTs+I0o5j/+IoxtchPuW
	 ExsBuDphm5czovtSWvsx/CO7l+4EhDT+N/X3LG7FSdHh90yclhQ8h9EOuVQSKNIeAcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="P/+lB6EP";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B176085083;
	Tue,  3 Nov 2026 14:03:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49B176085083
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=P/+lB6EP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793714616;
	bh=TaFMJ0UW3LigUoc0s6WNECoAhHhD44ITTyoS2M06BTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/+lB6EPgJCOlaqb6UOn4HaTUVagijQgzxohYYguhaTyqbMcV3opOfwD3jRHq/4Xe
	 tLrQ88rVIc+KVAHZ5D1r73dDv3L2FrbzPu1Thvl4g4O7+rmqBtFICQ4bNbIPNW2ZEj
	 qfhLB38q0F1LnvKBFM9waj3XjObJrLoYrAJEP8R4XX3da4UaWDU72oF1OnxvH9BcLA
	 qvYHiMuJY0psph5UyGU819eJDGwFDQ8IiPJzuLdwfcEjk8XSYotew0pNHqeUhdqVdt
	 a5aDseMS20VMXuwoUimN3vK77AKDJcHgHqmx+dcsFuSmd1A7d/DsGv68JSvOE0Yr5n
	 MaY/W5seTiS1A==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 252A260085;
	Tue,  3 Nov 2026 15:03:36 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 14/15] netfilter: xt_recent: do not call remove_proc_entry() under recent_lock
Date: Tue,  3 Nov 2026 15:03:07 +0100
Message-ID: <20261103140308.591690-16-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103140308.591690-1-pablo@netfilter.org>
References: <20261103140308.591690-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>

recent_proc_net_exit() removes the /proc/net/xt_recent/<name> entries of
a dying network namespace while holding spin_lock_bh(&recent_lock).
remove_proc_entry() may sleep: proc_entry_rundown() waits until every
task that is still inside the entry's file operations has left. A reader
of such an entry is counted in by proc_reg_read() before
recent_seq_start() takes recent_lock. So if a read is in flight when the
namespace is torn down, cleanup_net() sleeps in atomic context holding
the spinlock that the reader is spinning on, and neither side can ever
make progress.

An unprivileged user can trigger this from a user namespace by adding a
rule with the "recent" match and reading its proc file while the
namespace is being destroyed. As recent_lock is global, every later
attempt to take it spins forever too: the spinning can spread to all
CPUs, and network namespace teardown stops system-wide.

  BUG: sleeping function called from invalid context at
    kernel/sched/completion.c:116
   #3: (recent_lock){+...}-{3:3}, at: recent_net_exit+0x2b/0x140
  Workqueue: netns cleanup_net
  Call Trace:
   proc_entry_rundown+0x185/0x1b0
   remove_proc_entry+0x21a/0x520
   recent_net_exit+0x7f/0x140
   cleanup_net+0x414/0x8f0
  ...
  rcu: INFO: rcu_preempt self-detected stall on CPU
  Call Trace:
   queued_spin_lock_slowpath+0x313/0xc20
   recent_seq_start+0x87/0x1b0
   seq_read_iter+0x265/0x11e0
   proc_reg_read+0x1ab/0x270

Fix by taking recent_mutex instead of recent_lock. According to
commit a0e889bb1bdc ("[NETFILTER]: recent match: fix "sleeping function
called from invalid context""), recent_mutex is the lock to use here: it
protects recent_net->tables and was introduced so that proc entries are
created and removed without recent_lock held, because those calls may
sleep. hashlimit_proc_net_exit() does the same for xt_hashlimit.

Fixes: 665e205c16c1 ("netfilter: xt_recent: fix namespace destroy path")
Cc: stable@vger.kernel.org
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_recent.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 55f1f2d89952..00cccf003cff 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -650,14 +650,15 @@ static void __net_exit recent_proc_net_exit(struct net *net)
 
 	/* recent_net_exit() is called before recent_mt_destroy(). Make sure
 	 * that the parent xt_recent proc entry is empty before trying to
-	 * remove it.
+	 * remove it. Use recent_mutex instead of recent_lock since
+	 * remove_proc_entry() may sleep.
 	 */
-	spin_lock_bh(&recent_lock);
+	mutex_lock(&recent_mutex);
 	list_for_each_entry(t, &recent_net->tables, list)
 	        remove_proc_entry(t->name, recent_net->xt_recent);
 
 	recent_net->xt_recent = NULL;
-	spin_unlock_bh(&recent_lock);
+	mutex_unlock(&recent_mutex);
 
 	remove_proc_entry("xt_recent", net->proc_net);
 }
-- 
2.47.3

