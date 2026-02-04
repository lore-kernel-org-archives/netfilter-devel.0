Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2823C34A3DA
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Feb 2026 20:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770236824; cv=none; b=oIpEnNm6aOUM8illvJA0ko7bARoj5ZfjeUM20YfbOBKrTQRMCrWxE+e4GCgXoaSLx+s/2kcbXPMlmRhyHtGMtD7U5kFMG/lsAP864AG6gwJzYvWpl1FW3FcgTk35JuB2BfGbccOBXOS59Blly9VFdc8P0OEXllleOV9A+WPScTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770236824; c=relaxed/simple;
	bh=lUbhMgdtUtoMByYhlHFn1RFiV0tRjuwlKWjPqcVkB0I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fgyg6FfxPIPNRvh/m1vlBUWIQ2UmD1NNRESAP6dSaZCSNZnTJAkUpPNntwK7ZGGgH/3w2L1RAkMqBG53e+Yme9IdlO5YAepthp+pqvhkQekrHDxQpXLXFMZjEI8utCgGTHxZBx3SZijaKgRA/n5aDP0030C+w9XC51MGFoZPctY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=eFjLj/dD; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="eFjLj/dD"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 3C7D74943;
	Wed,  4 Feb 2026 21:27:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770236822;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=XmZ5CWMpVqfWhuO4UtsHORX8cDV1PY0Kp08hYtiKHTE=;
	b=eFjLj/dDL9RvYOjLg9JEN/2a8bEeXZcLziSv4EpYMdU70hywrODgS0wbB2bQdxMQ
	pGsKrGQp3xeGk/pRf7xgBsvjEmtO7tvwZpwLZbq59H1MMc850rhFRB/1Xg4qiOTKy9K
	6+MQ2H4EVwL5p3fSMWagDU2wsEV4or9mgoANAhGn1FuQVfqW9XP+7+nu6aBut+UgxNU
	0g4iKM1r15PNbE6pZ15ANwAQ4uCmOXRZXEuO6Bj/FC2Uu2ctZkoL6ZsYTgO8kVI9Lod
	QTv2NfPAbPoTkSXdGoK8ArLj0+uCmUaxMVPVMD24Z/EpxO+nSv7GoJLiAEU38VsSw6O
	9daHosNOqA==
Received: by smtp.mailfence.com with ESMTPSA ; Wed, 4 Feb 2026 21:27:00 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v5 nf-next 0/3] netfilter: nf_tables: fix reset request deadlock
Date: Wed,  4 Feb 2026 14:26:35 -0600
Message-ID: <20260204202639.497235-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

syzbot reported a possible circular locking dependency between
commit_mutex, nfnl_subsys_ipset and nlk_cb_mutex-NETFILTER:

  WARNING: possible circular locking dependency detected
  syz.3.970/9330 is trying to acquire lock:
  ffff888012d4ccd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_obj+0x6f/0xa0

  but task is already holding lock:
  ffff88802bce36f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990

  Chain exists of:
    &nft_net->commit_mutex --> nfnl_subsys_ipset --> nlk_cb_mutex-NETFILTER

   Possible unsafe locking scenario:

         CPU0                    CPU1
         ----                    ----
    lock(nlk_cb_mutex-NETFILTER);
                                 lock(nfnl_subsys_ipset);
                                 lock(nlk_cb_mutex-NETFILTER);
    lock(&nft_net->commit_mutex);

Link: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448

The bug was introduced by commits that added commit_mutex locking to
serialize reset requests.

v5:
  - Split counter and quota changes into separate patches
  - counter: use global static spinlock wrapping fetch+reset
    atomically to prevent parallel reset underrun, instead of
    per-net spinlock taken too late (after fetch)
  - Drop struct net from counter priv (no longer needed with
    global spinlock)
  - quota: unchanged from v4, atomic64_xchg() for reset

v4:
  - Push spinlock down into nft_counter_reset() instead of holding it
    across entire dump iteration, per Florian's review
  - Store struct net in counter priv to access the per-net spinlock
    during reset, avoiding skb->sk dereference which is NULL in
    single-element GET paths such as nft_get_set_elem
  - Use atomic64_xchg() for quota reset instead of spinlock, which is
    simpler per Pablo's suggestion
  Link: https://lore.kernel.org/netfilter-devel/20260203050723.263515-1-brianwitte@mailfence.com/

v3:
  - Restructured as 2-patch series per Florian's suggestion:
    1. Revert the 3 commits that added commit_mutex locking
    2. Add spinlock-based serialization for reset requests
  Link: https://lore.kernel.org/netfilter-devel/20260201195255.532559-1-brianwitte@mailfence.com/

v2:
  - Switched to a spinlock in nft_pernet instead of mutex
  - Spinlock doesn't sleep, so we stay in RCU read-side critical section
  - Removes the try_module_get/module_put and rcu_read_unlock/lock dance
  Link: https://lore.kernel.org/netfilter-devel/20260201062517.263087-1-brianwitte@mailfence.com/

v1:
  - Proposed using a dedicated reset_mutex instead of commit_mutex
  Link: https://lore.kernel.org/netfilter-devel/20260127030604.39982-1-brianwitte@mailfence.com/

Brian Witte (3):
  Revert nf_tables commit_mutex in reset path
  netfilter: nft_counter: serialize reset with spinlock
  netfilter: nft_quota: use atomic64_xchg for reset

 net/netfilter/nf_tables_api.c | 248 ++++++----------------------------
 net/netfilter/nft_counter.c   |  20 ++-
 net/netfilter/nft_quota.c     |  12 +-
 3 files changed, 65 insertions(+), 215 deletions(-)

-- 
2.47.3

