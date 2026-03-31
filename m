Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44EE2BF3D7
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 06:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774937842; cv=none; b=g+MbiHifDSK6gDZYjd8PkEfhtAX4/LYUP3AyqjiD3V4PLRNrMdVPzEy+3FhXmv5lEzzlivYHM9iFu9+YTIMnMhMfot2L3KdViCVJ3YS+4DECT5GxEP0QZ0XZnkhS6YVnLuEE1Tl/f7uO+M1qPQZlKiJu+a7fHbX8Y0DvHvTPXhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774937842; c=relaxed/simple;
	bh=+MVwa06bQ80jTsJAxdYTPPItAkzHNOIIwQDDMrjTfLk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tCthXFfwnmDEO08UFZG17VWuIUUaYX/O2Y+v6W4OMtg2IWWtDJS0XWPG8SuMnVs5hnOUmKkbiQj28l50vOvO+I+inXBfggJXOUITNZ7LP49cTCp2yFD2vHXBzVF99RA9R0m9c6HOvo7WRX82u7Mp1dBg0xw/mlIdR5TCUuR5aOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SWQiRofA; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SWQiRofA"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b258576d8cso9616135ad.0
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 23:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774937840; x=1775542640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bkzyJ4oLOwweestkp4e2+gtljA8YSDiok5IOKRVAFxc=;
        b=SWQiRofAKkGjqPfXCm5gjRdeLdi78+27ZTwJKQifuOlhXyRHa4NzFEIFj25Q9AlTCr
         DsMsdzYTcUi34q/h2h5G0E/V+194WBNjwSLZKL/qmtbxI+9D/Qbq+xnTYht7OwF1KrEh
         qFBEJFrMrspfU3QXoEaYz4XGqtIdWFn5E6V7yRefT54D9U7+6HkJEh4UDxFIT7gXEbeX
         kU99dNgITl8F6W081WHukjqikKobxz6Ne2op61eHGETg2a4sR3lW0870/hfkp1HZ65fu
         5c+bO/raqzGrqO+Ca7eOLauFMbPi6PMkAv5NpJ4EwJZ5DzCRzLn/zbv290TWDNkZtJNg
         3faw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774937840; x=1775542640;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bkzyJ4oLOwweestkp4e2+gtljA8YSDiok5IOKRVAFxc=;
        b=hrcaZmvWjMuD++G1QxLC9dkLyxWCoNLzEIkj4J1NzhwfYARLlbp/uYwb1nyI0VWUKK
         +cjFhnJUu0ovhFvwSTcv9JyZ8NDGJyXDsgt7HUKR8tyb5/8ZbxOPEZ7VzDo147tsFRI3
         9Uz+XLoBQ6cDD279l/6TKShzvZc49FlwfZ8tYopjQ7La5bke/84CLXLGAAGZDe/Ys60v
         pc2X0QwrVrbriWJyU1sm8nhion2eFY7r0dINttRUMHvhob8N318HnrIjuQe/A83nIpGp
         B9KXpd7HpLtDp9NPXXtBLLpfP2Or74ape9klaBYGUy4DhRXb+D9pfLiQw//zOzm4hafp
         jLxw==
X-Forwarded-Encrypted: i=1; AJvYcCWBKRhFjOvEy6GopVKpoy62ohuKKpI37K69jKdggiGvZPfBqenx4jteO5pAk7VOLVRJXxhJsWjkyz1QOmeLMuM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz29al6N6XXnVkPGVqud5ePGrWhw7ZoRfqNmoIb/lHWRS2dZ51l
	rqrNNpq+8Wb8o3SJGyNZjpVnl2hI5NFKNdP/kpIPa5Qd99th/fU7Fh2p
X-Gm-Gg: ATEYQzygeudidJv2LRqmrcbUrYOzrd66WnjFD0AYPDCU/1Pu2vxv1D5eZ+lqMsiPo58
	VcZ1OmSn5XUJRJE7OcS3I7mqMuX8iv61wsWdjSITosXW6v50nWWFMJu8lIuNUHUSbZZ7mHZhFUS
	Z9atdGYK9aRCE+DV/AGmQSbHQ5VbHQ0iC6Bcjya8Zx13vztuMhUHDupJ0jeb/V8iM0TKN7oiKtt
	b0rCpZqJfpcwoCmzrNzB3Jp7DMK6COcTmt/hzs483qDBjhFy1zmiLRwzhMQMkEZ6svLi/X14ZoQ
	lotfjwqfhCMoLl8JmBxhbhE8/4kFvGVWvI8YmY5JV6nZVgymdO7opdJR8BknMsJcCeBkH1UWaiH
	sCuhNAaEMyqiio1cBLYzb5kx9f5bAfTaKCHrQjhH7COFIXlpTiB4W5H6yZyFlL6Xavvti/Bb7TT
	OQ+9MyF9tisnsgdNQVbnEnOFeaMZWJbwKUX1w=
X-Received: by 2002:a17:903:1c9:b0:2b0:608d:d8a8 with SMTP id d9443c01a7336-2b0cdc76509mr162648985ad.1.1774937839921;
        Mon, 30 Mar 2026 23:17:19 -0700 (PDT)
Received: from localhost.localdomain ([47.236.127.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24267397bsm108101525ad.27.2026.03.30.23.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 23:17:19 -0700 (PDT)
From: Qi Tang <tpluszz77@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	kernel test robot <lkp@intel.com>,
	Qi Tang <tpluszz77@gmail.com>
Subject: [PATCH v2] netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent
Date: Tue, 31 Mar 2026 14:17:12 +0800
Message-ID: <20260331061712.85484-1-tpluszz77@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ctnetlink_alloc_expect() allocates expectations from a non-zeroing
slab cache via nf_ct_expect_alloc().  When CTA_EXPECT_NAT is not
present in the netlink message, saved_addr and saved_proto are
never initialized.  Stale data from a previous slab occupant can
then be dumped to userspace by ctnetlink_exp_dump_expect(), which
checks these fields to decide whether to emit CTA_EXPECT_NAT.

The safe sibling nf_ct_expect_init(), used by the packet path,
explicitly zeroes these fields.

Zero saved_addr, saved_proto and dir in the else branch, guarded
by IS_ENABLED(CONFIG_NF_NAT) since these fields only exist when
NAT is enabled.

Confirmed by priming the expect slab with NAT-bearing expectations,
freeing them, creating a new expectation without CTA_EXPECT_NAT,
and observing that the ctnetlink dump emits a spurious
CTA_EXPECT_NAT containing stale data from the prior allocation.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603310541.XVM8V7WG-lkp@intel.com/
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
---

Changes in v2:
  - Wrap zeroing in #if IS_ENABLED(CONFIG_NF_NAT) to fix build
    when CONFIG_NF_NAT is disabled (kernel test robot)

Link: https://lore.kernel.org/all/20260329165217.241038-1-tpluszz77@gmail.com/
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c57c665363e0..6d7eab7e8cf8 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3593,6 +3593,12 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 						 exp, nf_ct_l3num(ct));
 		if (err < 0)
 			goto err_out;
+#if IS_ENABLED(CONFIG_NF_NAT)
+	} else {
+		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
+		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+		exp->dir = 0;
+#endif
 	}
 	return exp;
 err_out:
-- 
2.43.0

