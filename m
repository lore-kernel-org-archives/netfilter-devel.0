Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD55314D06
	for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 03:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789788579; cv=none; b=u+oGOCgmj+zUhrTivV6+wdGDkuGJl4DoX2wWEFaBBUfHcv9ZYVd55VzcQA6tr4UI9tp2hlZxIK7cMviYZAGyiDc4I7t7taEKuCjjEEc1iezyJbeaXhk74LPrRNBb3uaFdNLdKwRDYBkLXzCM6z0cW4LrITXv4auhFhHvzjJSoxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789788579; c=relaxed/simple;
	bh=Kpjx1RIkavXK32hKs8VpAOoak/OwV60NfDZF48LiohY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FfdFt/ThyCmoVTbTzGeHsT1VChvP0/JZK/xoJnBr450rGiID/p0/q75WaNV7KOPLqg4G969pdA1vj2qxpxnxyHn7ss7joDUkM7m8eC30umX3Ve0fpHUqB3au5JEANBAcXp7c1cm+UdFqcqbh5/ScZ5xe0gwi5S2Jto8u47p4S50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wz0v+fZa; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wz0v+fZa"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469b35611so930429b3a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 20:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789788576; x=1790393376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=muMIYjiiSeBsL1eUzeEwgPRRBWkaPT6ZobNvYIG+NcA=;
        b=Wz0v+fZa12YeWq9CupoXbd4g3Heuy2vo9dBdZTECWgIqd8MCQF10K48hf5g8FZK/S0
         daeOvREp/qm0QJt87mvmmbD5jQjoSLpr6BhjJYr2USmeaR4K1E8ZT2G2jd/eJI6Ts+9Q
         7I/jvtO8erNqdru1r4k+MzVlazxOwctuXs6Ceczsl1RYDUs0bcWqKE5zyVEP4/qautnZ
         rVeUiuej1QX9EIzRz4U0NTxjNnUVFlIOeIQFPVhOyLbpeQz9cdFfhTmGmXLKEWdwCEXe
         kwwigLQg43umaGHHqnOcG7nLuxhJkFKLy0tlAOugi8ZNKXtWLEmsfq0ulnGck+OTKBJc
         O16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789788576; x=1790393376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=muMIYjiiSeBsL1eUzeEwgPRRBWkaPT6ZobNvYIG+NcA=;
        b=PBllYfyt7Qbs3c2joZRspVOBytlvai5AXvKYA/ctdNUD7JzewXnhW0uiUYM54Qf1T6
         oVZGPZNYpnNY45ELrd4BN6jwnXjh24+6wGX02gljv8f/724CIBuJy253mASlXg4f3fYV
         jI+BpoNxKa848oU5Rn5v7j1aH8rDurg0QWiPMoksjaZCgt9diyW+vAOcKqCoi0PqR1Xs
         fYdq+bJEuxbDbjZzTgPTIzCwFcNoUcZdTy4M+hlmAfKYO87qUS4szL0W35t8kiWcOTLx
         eUlTn95fZRAoCS0MXVb+j7jtWqOg9NvXlFC/RU/DpLWtye7Xbh7Wk2jrIoimo1DXguEa
         bVYQ==
X-Forwarded-Encrypted: i=1; AKwUvBzVev5Ikp4JjUimS6ILl8EHyodkAPK/ifUlFnzYJUbY8nzcNUCvMjkZtWo/Xxl2GOLp8WraJIDzM4Iq8tr0eAk=@vger.kernel.org
X-Gm-Message-State: AFuF++nEP/RAA3pYq+l8YAuDZ/jhTpUkjU1dtGaBKBOCVwDEYO2YBIzb
	3qd+lSdbZ+bm/ylBl0b5WmUrEl+fwmZnTz9Q3goIuPXmLle43fiLtX1P
X-Gm-Gg: AYBFou29euWzrcKv/nG+f8AJw2uETrXiqxdNS109jrfOCWpobPvcwh8g6GnpMbJFtBn
	ew/gklKQMQEjyHNXqYCCYP4vpnhKCKwKEJgzIDuFkWB2+efumC4iSiYzlcWTuwREQ6WgO7J1WHz
	hq7jD3WbFUgWxsUMYiOFY2oCYCTzDwhnHQxIaK99kAhXSl/jvzEv1k4XXu3VWtHBArLJJFUwuwY
	Y2fsp3RrlhH7W3+zgS39Zx8nX72S5LbvJsZHjVo07RhhMn6pMlRVruYHma/QrxBdFtunq8/6K3w
	3scLT0EmP83KqZ5vwHu6Gip9rK3eucP2m6Sb+RRdfyEqFdMqEE6HOws9hfF+LQpt+GRlPynVW7P
	Qu7jFn5JuWUrVvDr4draXdsnnPy+1Z+n3ZhTl4R4QQpZTxymBPx4ynJijIwunIr2shD/B1sFGZL
	t88GAhdMdQAzW3UbXT27wHUT3SN20Z5Rjf9scKQUUOEX7r71VPCJBgNOSyI0fVjU5Awc5l9ufjB
	3yPv3Z0dyuyySPu
X-Received: by 2002:a05:6a00:3e22:b0:851:8394:1696 with SMTP id d2e1a72fcca58-874dbfee622mr7775440b3a.12.1789788576058;
        Fri, 18 Sep 2026 20:29:36 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d4a:e90:814e:e9d3:767e:9a2a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-877a6be0d58sm489281b3a.7.2026.09.18.20.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 20:29:35 -0700 (PDT)
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
Subject: [PATCH] netfilter: nf_tables: defer object destruction on abort past commit_mutex
Date: Sat, 19 Sep 2026 10:29:28 +0700
Message-ID: <20260919032928.78841-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
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
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 55 +++++++++++++++++++++++++++----
 2 files changed, 49 insertions(+), 7 deletions(-)

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
index c0b754a2d45b..04bb3d4f16ad 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -146,6 +146,7 @@ static bool nft_chain_vstate_valid(const struct nft_ctx *ctx,
 }
 
 static void nf_tables_trans_destroy_work(struct work_struct *w);
+static void nf_tables_abort_release(struct nft_trans *trans);
 
 static void nft_trans_gc_work(struct work_struct *work);
 static DECLARE_WORK(trans_gc_work, nft_trans_gc_work);
@@ -10288,8 +10289,19 @@ static void nf_tables_trans_destroy_work(struct work_struct *w)
 	synchronize_rcu();
 
 	list_for_each_entry_safe(trans, next, &head, list) {
-		nft_trans_list_del(trans);
-		nft_commit_release(trans);
+		/*
+		 * binding_list is already unlinked here: for commit-origin
+		 * transactions it was never linked to begin with, and for
+		 * abort-origin ones nft_trans_list_del() unlinked it under
+		 * commit_mutex before this trans was queued (see
+		 * __nf_tables_abort()) since that list is only ever walked
+		 * under that mutex. Only detach from the local work list.
+		 */
+		list_del(&trans->list);
+		if (trans->aborted)
+			nf_tables_abort_release(trans);
+		else
+			nft_commit_release(trans);
 	}
 }
 
@@ -11278,6 +11290,10 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 			nf_tables_flowtable_destroy(nft_trans_flowtable(trans));
 		break;
 	}
+
+	if (trans->put_net)
+		put_net(trans->net);
+
 	kfree(trans);
 }
 
@@ -11482,12 +11498,37 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 
 	nft_set_abort_update(nft_net);
 
-	synchronize_rcu();
+	/*
+	 * Defer destruction past an RCU grace period, same as the commit
+	 * path (see nf_tables_commit_release()): an abort must not block
+	 * on synchronize_rcu() while holding commit_mutex, since every
+	 * other nf_tables netlink request queues up behind that mutex.
+	 *
+	 * nft_trans_list_del() also unlinks bindable NEWSET/NEWCHAIN
+	 * transactions from nft_net->binding_list, which is only ever
+	 * walked under commit_mutex (see nf_tables_commit()), so that
+	 * unlink has to happen here and not from the unlocked workqueue.
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

