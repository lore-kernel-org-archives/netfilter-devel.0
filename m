Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4937326938
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770095274; cv=none; b=HZEYsQt6L7jw0I+wXMY7taCqt7pzAturIg2dT05IZq7TXEGiI03TnEado7+AgSbHzx2zl0ncYTIcEu1txA3FR/Ur6L5pN4M19XJgAVDX6qeWRiOzTh7P3/SxbxBO0lOpzIEDo7+moe5NXCixt1aH0qSENTN45//ChyAaE8aPR4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770095274; c=relaxed/simple;
	bh=Gz6j1I2OY8MefZAl3RtsTEBAH/r7vAlDvIDVI3VwlGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ad3eSCkdLfWP1H6nJ8tL8So42rFcvptZDaVFN4yxfTAKu9hamZWHQ3677NgckRz8llhAiGSPvdFFUjJ7It28usIOFbHhVeOJemzblw7Cy9BWBdT3G9dPlebCZy2+cyEqPBaWdc0DRPnLKZo4Nb++nJNpTVTGPfXWPB82T+rrVDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=ku2rd3rB; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="ku2rd3rB"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id 237AEEA2;
	Tue,  3 Feb 2026 06:07:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1770095263;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=8rxQ/h1F4ImiqF/L9pNxUDxuEjfxwdZ5GvCiFTPF2fk=;
	b=ku2rd3rBZ9gAL4g7JQ+sqQ5ExPnEo5jvGQ4EfUuVGQUB8na+soz1Wp0M6ZgdRDZx
	aDrFAeylKadBrjO+k2v6UNef6KebDSeKvyMbAPAe26PSdx/5N0ahip3t0qaNoK5kcU+
	MJmLOnrVZiPXy0TMUQE8hCgex/NUSgzonsHRqL/zR2BZnaAcAvJaCx7c3hfskog1jSd
	Sm7bxGMFKjQAqmSV25MK0ZgLg6T7WwSbHz9oMdBoR/l0kvh47c2may1ndvxAL+oPQcG
	tDwriaNTHYSGPR9k48DZId7K+DALNxj2asdLqFySfxqLvuCHR5AADR4WtdJmyc59Ny1
	9Hazxd1fQw==
Received: by smtp.mailfence.com with ESMTPSA ; Tue, 3 Feb 2026 06:07:40 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v4 nf-next 0/2] netfilter: nf_tables: fix reset request deadlock
Date: Mon,  2 Feb 2026 23:07:21 -0600
Message-ID: <20260203050723.263515-1-brianwitte@mailfence.com>
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

v4:
  - Push spinlock down into nft_counter_reset() instead of holding it
    across entire dump iteration, per Florian's review
  - Store struct net in counter priv to access the per-net spinlock
    during reset, avoiding skb->sk dereference which is NULL in
    single-element GET paths such as nft_get_set_elem
  - Use atomic64_xchg() for quota reset instead of spinlock, which is
    simpler per Pablo's suggestion

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

Brian Witte (2):
  Revert nf_tables commit_mutex in reset path
  netfilter: nf_tables: serialize reset with spinlock and atomic

 include/net/netfilter/nf_tables.h |   1 +
 net/netfilter/nf_tables_api.c     | 249 ++++++------------------------
 net/netfilter/nft_counter.c       |  17 +-
 net/netfilter/nft_quota.c         |  12 +-
 4 files changed, 63 insertions(+), 216 deletions(-)

--
2.47.3

