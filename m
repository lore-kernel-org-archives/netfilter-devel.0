Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2B12E1C79
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Jun 2025 14:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751034509; cv=none; b=kCW87W5G/4PdopFeXaJGWQT0bqT9QV06Z/VxGlX+ssBTGt17P3pyaD7cZ7347tzbLorQ6I08C/+0mXFiftffbM2lAq2Gmkxzrn8jQyX7QcHWRaG3KZcXXJyA46bACDIulrgxnXG1l6nT7DNmTHsRV24j6uKUtj5J1vN4Nhojo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751034509; c=relaxed/simple;
	bh=RU/CzSiUMXAYLaeVlBvB40Ibm79TujQ3TI2MvUzY+qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8Qq7CgB5Z4R5jXX94QsjDYKqrnFjMTfCIBctgl9CDzbzZ1/kpbzU2Rqe4dm35bFs0ce1GJnUDsAJwF5pA7k8iZjnKUBMWHzu8TYDZKMnPrexjVRf/qmYxF+HEXrr7+pIum1+C457lc9YCxMI+bFzD29BGwSAlPuNCvH3LADFt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8F194608B7; Fri, 27 Jun 2025 16:28:25 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 4/4] netfilter: nf_conntrack: fix crash due to removal of uninitialised entry
Date: Fri, 27 Jun 2025 16:27:53 +0200
Message-ID: <20250627142758.25664-5-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250627142758.25664-1-fw@strlen.de>
References: <20250627142758.25664-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A crash in conntrack was reported while trying to unlink the conntrack
entry from the hash bucket list:
    [exception RIP: __nf_ct_delete_from_lists+172]
    [..]
 #7 [ff539b5a2b043aa0] nf_ct_delete at ffffffffc124d421 [nf_conntrack]
 #8 [ff539b5a2b043ad0] nf_ct_gc_expired at ffffffffc124d999 [nf_conntrack]
 #9 [ff539b5a2b043ae0] __nf_conntrack_find_get at ffffffffc124efbc [nf_conntrack]
    [..]

The nf_conn struct is marked as allocated from slab but appears to be in
a partially initialised state:

 ct hlist pointer is garbage; looks like the ct hash value
 (hence crash).
 ct->status is equal to IPS_CONFIRMED|IPS_DYING, which is expected
 ct->timeout is 30000 (=30s), which is unexpected.

Everything else looks like normal udp conntrack entry.  If we ignore
ct->status and pretend its 0, the entry matches those that are newly
allocated but not yet inserted into the hash:
  - ct hlist pointers are overloaded and store/cache the raw tuple hash
  - ct->timeout matches the relative time expected for a new udp flow
    rather than the absolute 'jiffies' value.

If it were not for the presence of IPS_CONFIRMED,
__nf_conntrack_find_get() would have skipped the entry.

Theory is that we did hit following race:

cpu x 			cpu y			cpu z
 found entry E		found entry E
 E is expired		<preemption>
 nf_ct_delete()
 return E to rcu slab
					init_conntrack
					E is re-inited,
					ct->status set to 0
					reply tuplehash hnnode.pprev
					stores hash value.

cpu y found E right before it was deleted on cpu x.
E is now re-inited on cpu z.  cpu y was preempted before
checking for expiry and/or confirm bit.

					->refcnt set to 1
					E now owned by skb
					->timeout set to 30000

If cpu y were to resume now, it would observe E as
expired but would skip E due to missing CONFIRMED bit.

					nf_conntrack_confirm gets called
					sets: ct->status |= CONFIRMED
					This is wrong: E is not yet added
					to hashtable.

cpu y resumes, it observes E as expired but CONFIRMED:
			<resumes>
			nf_ct_expired()
			 -> yes (ct->timeout is 30s)
			confirmed bit set.

cpu y will try to delete E from the hashtable:
			nf_ct_delete() -> set DYING bit
			__nf_ct_delete_from_lists

Even this scenario doesn't guarantee a crash:
cpu z still holds the table bucket lock(s) so y blocks:

			wait for spinlock held by z

					CONFIRMED is set but there is no
					guarantee ct will be added to hash:
					"chaintoolong" or "clash resolution"
					logic both skip the insert step.
					reply hnnode.pprev still stores the
					hash value.

					unlocks spinlock
					return NF_DROP
			<unblocks, then
			 crashes on hlist_nulls_del_rcu pprev>

In case CPU z does insert the entry into the hashtable, cpu y will unlink
E again right away but no crash occurs.

Without 'cpu y' race, 'garbage' hlist is of no consequence:
ct refcnt remains at 1, eventually skb will be free'd and E gets
destroyed via: nf_conntrack_put -> nf_conntrack_destroy -> nf_ct_destroy.

To resolve this, move the IPS_CONFIRMED assignment after the table
insertion but before the unlock.

It doesn't matter if other CPUs can observe a newly inserted entry right
before the CONFIRMED bit was set:

Such event cannot be distinguished from above "E is the old incarnation"
case: the entry will be skipped.

Also change nf_ct_should_gc() to first check the confirmed bit.

The gc sequence is:
 1. Check if entry has expired, if not skip to next entry
 2. Obtain a reference to the expired entry.
 3. Call nf_ct_should_gc() to double-check step 1.

nf_ct_should_gc() is thus called only for entries that already failed an
expiry check. After this patch, once the confirmed bit check passes
ct->timeout has been altered to reflect the absolute 'best before' date
instead of a relative time.  Step 3 will therefore not remove the entry.

Without this change to nf_ct_should_gc() we could still get this sequence:

 1. Check if entry has expired.
 2. Obtain a reference.
 3. Call nf_ct_should_gc() to double-check step 1:
    4 - entry is still observed as expired
    5 - meanwhile, ct->timeout is corrected to absolute value on other CPU
      and confirm bit gets set
    6 - confirm bit is seen
    7 - valid entry is removed again

First do check 6), then 4) so the gc expiry check always picks up either
confirmed bit unset (entry gets skipped) or expiry re-check failure for
re-inited conntrack objects.

This change cannot be backported to releases before 5.19. Without
commit 8a75a2c17410 ("netfilter: conntrack: remove unconfirmed list")
|= IPS_CONFIRMED line cannot be moved without further changes.

Fixes: 1397af5bfd7d ("netfilter: conntrack: remove the percpu dying list")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h | 15 +++++++++++++--
 net/netfilter/nf_conntrack_core.c    | 18 ++++++++++++------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 3f02a45773e8..ca26274196b9 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -306,8 +306,19 @@ static inline bool nf_ct_is_expired(const struct nf_conn *ct)
 /* use after obtaining a reference count */
 static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 {
-	return nf_ct_is_expired(ct) && nf_ct_is_confirmed(ct) &&
-	       !nf_ct_is_dying(ct);
+	if (!nf_ct_is_confirmed(ct))
+		return false;
+
+	/* load ct->timeout after is_confirmed() test.
+	 * Pairs with __nf_conntrack_confirm() which:
+	 * 1. Increases ct->timeout value
+	 * 2. Inserts ct into rcu hlist
+	 * 3. Sets the confirmed bit
+	 * 4. Unlocks the hlist lock
+	 */
+	smp_acquire__after_ctrl_dep();
+
+	return nf_ct_is_expired(ct) && !nf_ct_is_dying(ct);
 }
 
 #define	NF_CT_DAY	(86400 * HZ)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 201d3c4ec623..442a972a03d7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1124,6 +1124,7 @@ static int nf_ct_resolve_clash_harder(struct sk_buff *skb, u32 repl_idx)
 
 	hlist_nulls_add_head_rcu(&loser_ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
 				 &nf_conntrack_hash[repl_idx]);
+	loser_ct->status |= IPS_CONFIRMED;
 
 	NF_CT_STAT_INC(net, clash_resolve);
 	return NF_ACCEPT;
@@ -1260,8 +1261,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * user context, else we insert an already 'dead' hash, blocking
 	 * further use of that particular connection -JM.
 	 */
-	ct->status |= IPS_CONFIRMED;
-
 	if (unlikely(nf_ct_is_dying(ct))) {
 		NF_CT_STAT_INC(net, insert_failed);
 		goto dying;
@@ -1293,7 +1292,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 		}
 	}
 
-	/* Timer relative to confirmation time, not original
+	/* Timeout is relative to confirmation time, not original
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
 	ct->timeout += nfct_time_stamp;
@@ -1301,11 +1300,18 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	__nf_conntrack_insert_prepare(ct);
 
 	/* Since the lookup is lockless, hash insertion must be done after
-	 * starting the timer and setting the CONFIRMED bit. The RCU barriers
-	 * guarantee that no other CPU can find the conntrack before the above
-	 * stores are visible.
+	 * setting ct->timeout. The RCU barriers guarantee that no other CPU
+	 * can find the conntrack before the above stores are visible.
 	 */
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
+
+	/* IPS_CONFIRMED unset means 'ct not (yet) in hash', conntrack lookups
+	 * skip entries that lack this bit.  This happens when a CPU is looking
+	 * at a stale entry that is being recycled due to SLAB_TYPESAFE_BY_RCU
+	 * or when another CPU encounters this entry right after the insertion
+	 * but before the set-confirm-bit below.
+	 */
+	ct->status |= IPS_CONFIRMED;
 	nf_conntrack_double_unlock(hash, reply_hash);
 	local_bh_enable();
 
-- 
2.49.0

