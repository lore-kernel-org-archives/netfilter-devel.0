Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793223902;
	b=nAs2XCYgBJvuFytrJt5ZgYwFBO6NYrusaTM8dzoj5gW+R1Z3YqX411+rBb4N+UXuuY92
	 /f9nfLRTc7EvW6VZTWM6XqIfuvVunszjWYqYz+xL6V0DDtwltrrI8UUrucnOToYGmFnnp
	 URIwsqDXToVIgqBNiivg0PduuVhNpoL8K5INCwcsRTGoWBLiqyHSATFMVKa07YVEfr3OB
	 CFNFCgJOwdoNLTsxNnVrhc1/DeCVc/Y4PsoFVVwx3NxazeviCnFhru7Wp4npedMa1DXg1
	 PsACZQdFCaHJgXf6J75+v9OsZace38e1R70fvSFq0+apBBUhP1l2G4QaIJfA42tnlyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793223902;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Spam-Status:X-Spam-Checker-Version;
	bh=QzdVxfFMAudZH5Zx+gYGxfMat95oWqA670m1PqVNdIs=;
	b=IpfsSJEY2uBetPCeJdmybh0INb+lzufdP87cL4qQ/XYg6fa4wNGcnMi6O0JdsSUsQFNI
	 3hIfuDKfzzGaJUeXjff8BEoNXj0Yrlsl8mx+ejVoLgF6QHCjRlHMAhQahXeWqBtYwWhYZ
	 BU8jYN5k3pW+38bOvz7VvMDUiltVbmFPZ6bAdzOZlE5j/PKK93qjNgujNVMPwvI5ZsHf2
	 FxUuPQjiQBybLVkGzBCeVnZ5xA+rdU9y5N2I6XDCpaiXOQfsSRW+E8ov+s8MOFiDCutKa
	 e687IdB9okZ9LMF3e3yMXC22MCaPkix2md1546WBFOJWlVV2R7M8oDwaCgndV/4lfaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=EN8Wx5cX;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06730606A320;
	Wed, 28 Oct 2026 21:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06730606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=EN8Wx5cX
Received: from mac.lan (unknown [52.172.102.253])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3A9F620B7167;
	Wed, 28 Oct 2026 14:44:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3A9F620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1793223889;
	bh=QzdVxfFMAudZH5Zx+gYGxfMat95oWqA670m1PqVNdIs=;
	h=From:To:Cc:Subject:Date:From;
	b=EN8Wx5cXeJikQ7Oy47zjBGtBAX6F8v8XTrzHgttoY74GeuaW9CIukRb/9pwg/RXSF
	 She8lnGdoEeYxMWz9BFYioFHAr4M8PSXHD3Xdo/wUWcDB120nWjjk4KrI8Z1btzJZK
	 Ki8i2XbiVepQChoexg4X8NagfBV76spTqJ99Ri0Y=
From: "Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	"Vitaly E. Lavrov" <lve@guap.ru>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com,
	Cen Zhang <cenzhang@linux.microsoft.com>
Subject: [PATCH net] netfilter: xt_recent: do not call remove_proc_entry() under recent_lock
Date: Wed, 28 Oct 2026 17:44:43 -0400
Message-ID: <20261028214443.47335-1-cenzhang@linux.microsoft.com>
X-Mailer: git-send-email 2.55.0
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
2.55.0
