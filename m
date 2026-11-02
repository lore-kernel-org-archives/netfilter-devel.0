Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793581048;
	b=z8naQo6X40u3+KVkCoAEWu57w6iGfzjOq2toD+KMrvX3fRVE5gMkt1KMNnc8n+ugkEqR
	 KEQr6WKMPo5QYHGNXDK550latcc/iExa61O705eFGc2QiqCn1i8BH1cDbzNcTafMkSICp
	 oreruiYvjpmmQUFzDU+rNe07Hm2Tlau1JtZqpAL8sk23dqh6oEvS2i65MUoUhpou8v1lK
	 k8e0j7NK8hbAaaTCv5jp9ikYjpolBmA+lVerC7bCT88jCaxAMVI6pit5LmAgKPEjrzI86
	 1mNZ8Pk/yK3Cr1EEMZbalg3HEl/g+JxkZAtkXFTZUi9irtjrnofMcGPFoqGJ2AnLl1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793581048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=TaFMJ0UW3LigUoc0s6WNECoAhHhD44ITTyoS2M06BTs=;
	b=WZoBD6d73EQRQtv+7E9NYSklbVBepBUS+wf/lFNkLmVA2XRReuUmnvJLsLuSLg+XU8Y5
	 7V5z5o/BWMh156r2Ha+ntwp0eQYFLzSCf/1aH/7wSmrfmBl42BrD37IYkHMtQlEKSh/qa
	 s18isXKWhX8ITwJ/4NUn5Jv9WNTCiPStpRXcqnLELNbKdM8scgfwGGX6nnNemFQNgINXZ
	 uZ/3/lL8vTlujdaRAJZ8wVZ5P1/LQzhSkz/Be9qIWmetUbY5oS9kBw9/TqejMUjBD+3wr
	 TLTaQQDzySGvW1908xJV8qW9Z4wV9E/j1xGxXXG3kqkzz3577p4zk3KvEXjIGqTA7Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TNO635yC;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4322260A261A;
	Mon,  2 Nov 2026 00:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4322260A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=TNO635yC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793581046;
	bh=TaFMJ0UW3LigUoc0s6WNECoAhHhD44ITTyoS2M06BTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNO635yC7orMvNzksFBDp/Ky5/DW3RGwnzo1hbeOaazG9I9hJnltQjkJ4ufuX5LqW
	 cWg+Q6qElnHPelzmogLXE2JUb9Dxi21iV/VnNeDpMQy7Jcur6rPvjn479n0DNGAUOk
	 HBlgc1bn0jOLh3wIVLuSXTjlZ8x9BfTIEmWNWaY6qTuP/KQU/fHbT78JnJ4AjqUl3Y
	 MyYoAOE8TDjGvb+lHeIYadOJdD6YR5CH49xZS07gJkUkp+oCWO6oMo0yhp1AjOVmK2
	 q1/ZbnFBcBdVznSUNrOmg9PcHSss16XFPoZC0Wf+Z/RlRBK4Y4w5JrzDNs4h4jY67h
	 kL7I9wOTnkTog==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E486B6007C;
	Mon,  2 Nov 2026 01:57:25 +0100 (CET)
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
Date: Mon,  2 Nov 2026 01:56:53 +0100
Message-ID: <20261102005654.532438-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102005654.532438-1-pablo@netfilter.org>
References: <20261102005654.532438-1-pablo@netfilter.org>
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

