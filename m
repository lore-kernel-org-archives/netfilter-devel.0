Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF44C331EC3
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 03:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789788864; cv=none; b=fua/Kj7Xiw1WxVWO9pdojKBVjBsh0PBZxhIMNiWMXJNyJNgyNU4aW7q5B2IDatrGeZ1eg9ApYQ2lw0jbpCe2l0svAoHYpm1fnTdvWyiS8G4h/BExSM2m22xFlJXhhp1mF4ZCccN3BFCy/1nXw9G9vrrYdEGOic7iPTdfSY+atSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789788864; c=relaxed/simple;
	bh=Mjm+u1p75mFRLkvZFTf5dwnqY7Fg+z8VjFahbelkFCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8kJaquWFEMqHnc6fgGoTKVZlZIAmbmIRamoc01aK+f1P7TWATWAOl9QB87pENKo8eCPsAEXZOkjSXhMfDkbqAP8B8cfZyAoU6k0vR2gp4L4kKo9kT28mA3lcgAoRsxyDtaK1Ih0TIT7/SA5wnWx5y3OCAzck/yCocrKcCzzBsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M5q2NJRw; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M5q2NJRw"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccafb751so1174446a91.2
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 20:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789788862; x=1790393662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BAJlgrBRZ5OuM1n3rZmR1mVZuClmJsamQ0VjEnP9+oo=;
        b=M5q2NJRwrYVBlHh2XYl2DcN7248Y7W0Mc99kVmYJ6FM7XIB5hNJpe3iF5HpoFvWqZh
         AcjmOgaDFIf25gVTBSg9Z0lm0F2iSdvc3CVPbolignYspaNsv4fo5IFpJLRZ7vXchMrx
         dIBVS/GOFO/dH51APK6D5PxK/NTsCJtoOB+j/f2yTcQM41Vp/f3PcdygqVaPQJO5cf6k
         yQMf4pAWBvQ9FkivFSa9E9f0MKwqPlj0h2AJd5XKYxvFKF8+mPvMdzrGZLUQ8J+TB+ji
         66OhW31FKKms7TY7luo9592pOj0AYSuuQT4JraCl+g2Y5ixG6jqzdy4xR9piBcuScpgU
         NW1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789788862; x=1790393662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BAJlgrBRZ5OuM1n3rZmR1mVZuClmJsamQ0VjEnP9+oo=;
        b=CNyL4I8QzsEWvPCTyUIVTZLeIZPhuRzZcacrEvl0tO8SAx5TOCDNdSEPSZ/OdmmSYJ
         F6pTRlorZtlZhjuCuai06HvAJiYwaWohBlG+J2GJeCiKfkUVXFfNOZU1zb3vBqHURlWc
         7tMbcqpcNiY0LD+LfwljdjqsZ61vPDkMW5zP0dK9xOXE70JxPtvv4BHGwR0++6vJoty0
         oaZGwEX79YZ3Kwo6Z9jJBsFDF1pi5QM3VSbZVmCgcwH0DwRFzU+ZDyWGTlFLJhXaz1ou
         Nu2LxN37kN3WgQE1eMm0rLKkHv/5attsNUkx2AIc2DjYKcto6DhDZzGbR/6Trb3JLrg7
         iLRw==
X-Forwarded-Encrypted: i=1; AKwUvByh130+h10QNaFUVGKuSPjxcq5uEiQIGqDfR/faz6G6+2gQ1QTyqXXxaE27DGSd125aK03dJA0uquB667jCN6g=@vger.kernel.org
X-Gm-Message-State: AFuF++kkqqeLf6cE9p/zGzz+Oh5mlB3LrbDs7uH/8CyLmGwpZ+rQAClz
	w012qfhZxNDi81fAxugEE5fFpf9+FdcdW/wNspmg2U0RNoegNyIn6YY7v9upWA==
X-Gm-Gg: AYBFou2aeYMfVNeD5Tt5t3naEnD+H0dDMdzmWYGgiEkFxVObosoCb6O8evBcFucsanG
	pD7znxRe7aB4SxdeUtkWm26MXK3WF+O5WDBUf5NjbxJW83rla24ZN3fN5vgnZLmhrzg8zvQvLnO
	3CYUmB/AyJmhwPIaMS9R96xOfOx9nOERkpiBX8LwGSh3uyjidzgES5AV5JOR9rTXsOdKbyTzMyU
	GRHc8mOymIlmkhQq3AXCbozY3HURmlVDJkNOxE8K0ZZRCIPFs6Pdouj8UHoVkOn9iQqP3tfNudi
	uqxwQoEsXqdD1D7ZYG92O/kZ4ZFdibZ6vWCJXAdFunj1Hs6rWhQ3vdmxyelAKo4lCFX5exV/ase
	8RS3z0QxBSJAzSNT+rzDDKlCy2ECQbfGtGBfV+9Z43R/qCzAPeh6sZ6LVcLAdAiSDP739zYdtPO
	daxDq/WIyR8VyDLPdV60wEL25In1QQa1VTgZfHSRkIfdUw7cU8Srb4OtPh3/boavpv/jFyg5zQc
	qHAHoxMKwrawFJi
X-Received: by 2002:a17:90b:5403:b0:39e:6a7f:eeed with SMTP id 98e67ed59e1d1-39e6a7ff0b0mr4607745a91.18.1789788862096;
        Fri, 18 Sep 2026 20:34:22 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d4a:e90:814e:e9d3:767e:9a2a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c3145e5sm2313913a91.5.2026.09.18.20.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 20:34:21 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+83439cb981624bd8d068@syzkaller.appspotmail.com
Subject: [PATCH v2] netfilter: nf_tables: defer object destruction on abort past commit_mutex
Date: Sat, 19 Sep 2026 10:34:15 +0700
Message-ID: <20260919033415.79813-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260919032928.78841-1-ngocthang2710.1999@gmail.com>
References: <20260919032928.78841-1-ngocthang2710.1999@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__nf_tables_abort() calls synchronize_rcu() while holding
nft_net->commit_mutex, on every aborted batch. The commit path had
the same problem and was already fixed by deferring destruction to
nft_net->destroy_work so the mutex is dropped before waiting for the
grace period (see the comment in nf_tables_commit_release()). The
abort path was never given the same treatment.

On syzbot's images every synchronize_rcu() runs as
synchronize_rcu_expedited(), because CONFIG_CMDLINE bakes in
rcupdate.rcu_expedited=1. Under fuzzing-rate aborted batches this
turns each abort into an expedited grace-period wait taken while
commit_mutex is held, serializing every other nf_tables netlink
request behind it. syzbot reports this as a hung task in
nf_tables_valid_genid(), whose lockdep "locks held" dump shows the
commit_mutex owner parked inside synchronize_rcu_expedited() rather
than deadlocked on a lock.

Reuse the existing destroy_work machinery for the abort path too:
splice the still-mutex-protected commit_list onto destroy_list and
schedule the work, instead of waiting for the grace period inline.
Since abort transactions carry NEW*-type objects (versus DEL*/DESTROY*
for commits), nf_tables_abort_release() gains the put_net() handling
nft_commit_release() already had, and a new trans->aborted bit tells
the shared work function which of the two release paths to use for
each transaction.

nft_trans_list_del() also unlinks bindable NEWSET/NEWCHAIN
transactions from nft_net->binding_list, a list only ever walked
under commit_mutex. That unlink is kept synchronous, under the mutex,
in __nf_tables_abort() itself; only the RCU-gated free is deferred to
the workqueue.

Root cause identified from syzbot's crash report (lockdep holder vs.
waiter pair) and code inspection, cross-checked against syzkaller's
own dashboard/config/linux/bits/base.yml for the rcu_expedited=1
CONFIG_CMDLINE.

Verified by booting both the unpatched and patched kernel in QEMU
(2 vCPUs, rcupdate.rcu_expedited=1, CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=140
to match syzbot's environment) and driving nf_tables abort with a
script that forces a guaranteed abort-with-content every iteration
(a freshly-named table + chain + rule, then a delete of a nonexistent
chain in the same nft(8) batch, so the whole batch is always rolled
back with a brand-new, never-committed table/chain transaction still
on commit_list). Measuring the time commit_mutex is held across this
path, same script and iteration count on both kernels:

                  unpatched          patched
  avg               72.8 us            20.2 us
  max                2.2 ms             1.4 ms
  min               18.1 us             8.1 us

The unpatched number is the full inline synchronize_rcu_expedited()
wait; the patched number is what's left once that wait is off the
mutex (splice + schedule_work() only), which is scheduling noise in a
2-vCPU VM, not a grace-period wait -- the deferred path never calls
synchronize_rcu() while holding commit_mutex, by construction.

Reported-by: syzbot+83439cb981624bd8d068@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83439cb981624bd8d068
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
---
v2: shortened two in-code comments that were needlessly long for what
    they explain; no functional change from v1.

 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 40 +++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9d597482363d..e77831e3494c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1672,6 +1672,7 @@ struct nft_trans {
 	u16				flags;
 	u8				report:1;
 	u8				put_net:1;
+	u8				aborted:1;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c0b754a2d45b..a8b3bf969bd8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -146,6 +146,7 @@ static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
 }
 
 static void nf_tables_trans_destroy_work(struct work_struct *w);
+static void nf_tables_abort_release(struct nft_trans *trans);
 
 static void nft_trans_gc_work(struct work_struct *work);
 static DECLARE_WORK(trans_gc_work, nft_trans_gc_work);
@@ -10288,8 +10289,12 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 	synchronize_rcu();
 
 	list_for_each_entry_safe(trans, next, &head, list) {
-		nft_trans_list_del(trans);
-		nft_commit_release(trans);
+		/* binding_list unlink, if any, already done under commit_mutex. */
+		list_del(&trans->list);
+		if (trans->aborted)
+			nf_tables_abort_release(trans);
+		else
+			nft_commit_release(trans);
 	}
 }
 
@@ -11278,6 +11283,10 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
+
+	if (trans->put_net)
+		put_net(trans->net);
+
 	kfree(trans);
 }
 
@@ -11482,12 +11491,29 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
 	nft_set_abort_update(nft_net);
 
-	synchronize_rcu();
+	/* Defer past the GP like nf_tables_commit_release(); keep the
+	 * binding_list unlink here, under commit_mutex (see nft_trans_list_del()).
+	 */
+	if (!list_empty(&nft_net->commit_list)) {
+		LIST_HEAD(head);
+
+		list_for_each_entry_safe_reverse(trans, next,
+						 &nft_net->commit_list, list) {
+			trans->aborted = 1;
+			nft_trans_list_del(trans);
+			list_add_tail(&trans->list, &head);
+		}
+
+		trans = list_last_entry(&head, struct nft_trans, list);
+		get_net(trans->net);
+		WARN_ON_ONCE(trans->put_net);
+		trans->put_net = true;
+
+		spin_lock(&nf_tables_destroy_list_lock);
+		list_splice_tail(&head, &nft_net->destroy_list);
+		spin_unlock(&nf_tables_destroy_list_lock);
 
-	list_for_each_entry_safe_reverse(trans, next,
-					 &nft_net->commit_list, list) {
-		nft_trans_list_del(trans);
-		nf_tables_abort_release(trans);
+		schedule_work(&nft_net->destroy_work);
 	}
 
 	return err;
-- 
2.43.0

