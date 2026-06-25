Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB79335E923
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2026 01:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782349212; cv=none; b=V3GFA5qtLJ89r+1bTptghNgKIvK/e2JUl4wwpkEk136WapDXtuYVP/P1e0wcTh+a3VfalwXM+t3e4RKd6P+chgUhRhZDpOgPR9o+OdXcc+JWT/3yB13yFDGWd7K3SxAKDBHr0/aU8gSODoSUn3GBVv6iQhSjDT8/5cRdfQfImQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782349212; c=relaxed/simple;
	bh=7ttSot8uvmbmDr25iVgapfOaLEdfFBfLqnBp0maLbAU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U47XXyvuaUVNsd9XzJld0U4RmI6DbndDM/f1scXHvzTFhscEuXi8x3A7tW+7xM98D4NN8d3OwqkYXtCf2eNSIhOYQ5vqqn9elfK3ug5ijlZ9v4qY6yiK8bOI0sVCV/3LK2i7zLNVuAREiEMUj4eqfsmIVqfx7rXBIJyKTrCF/Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=tHudH2uU; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="tHudH2uU"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so1246408a91.1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 18:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782349210; x=1782954010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VkxKh8nTClgJ/GNm28h2Td42bPvA3cruY4e1e4dfTZQ=;
        b=tHudH2uUFaqqpB8oiVfFEQ7K5ojiwKOXNCJr54C1FXQ/xs5VJzoCuqs2vtxnL/y2J+
         PvFLm/AhbpD0roggq70qDk5nc1AoTK5NfVATfGxzketQAAxcCS8+MBcEho2BR7LBx2Lb
         yTdCtE1qrbL6yqRA+qKzs29ROB1r2DKX+iLETsZMsJKxcUu3CBGzPSCEq0y4LXqjhHYt
         8UERmYBYW5OdnshDLRzoTVBMnetYIYQOVWFXTY79Gwp4VYlR661jA3adoGgdMs7/T7L7
         FiKI48j12RzFcp6sILu1qK8Twrt9jhQboCyVB68ydYD0J0iBShJMOjKObYu+wXRbIEs1
         TJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782349210; x=1782954010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkxKh8nTClgJ/GNm28h2Td42bPvA3cruY4e1e4dfTZQ=;
        b=Mu1g4oHLHyOrB3ujGCP383hhhx53Izqkl1j7zTVWTvKSPtS8+u19kt8ng9YE1IzNyY
         nyukOPdAvzh4PWyh26tdGtkS5BTovlahg2BmyZBtPanTuiu5ZoeCCHgrYPF1qsInuyO7
         C+NnHLCDNcjPzxzXrWpyArBB9iA/q0U5YRvntvHJT+oYCoGOxRtCdkEvhbdz5GugXmod
         cXvdUn6dEtPkCIM4QMnl7uCSvncIVymAxprew8iHPMriDb2+Xoa6xQ5MZjBoLX4/HqHd
         RE+egjlPuRZ5c2OLeQHOm46F/aSEfrqkyFX/ZxVOET+0noybbWpekX18RJdlab6LMCPz
         XKeg==
X-Forwarded-Encrypted: i=1; AFNElJ8Gk7MSeLz5j5wXY1JQQHvcR/V1me6TRNIDJrGT/CZNhjnGjQBxjCumlyLtXVyHw8d8A+hMz0N1ux9Yeyq24FA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjlzET0XT4uBWMhLbv7mBbpi/yxocYBJfMNRpJMV8gxO+oSWHH
	nWkfXAV/VaQ883ADJNzU+W8828OM26fa2+gUqUMTf+B82SEYzg/HD/TG7dSxo4wlew==
X-Gm-Gg: AfdE7cmVb0y7qr1Uyb3crhepx+SvlkpZnvkJgIJ7uKMojSo2bdKFTQ8oDwp1ofmwSd6
	ID2OvHx1xWNoJ7oaAC3OIvFnTKckr2HHH5nyjLG7CeU2vvgazI2CANiJkdEX3oPoy7YzW9/khk5
	MZ+obOGyoVB0YCqFpv2PJi4bBSZEoIwHlF3XIrk0agNAazOgMFoJ5cJt0UV7pp+Mz8lTWfJNZaj
	cpxB9OANHL+s80lhOVB6CN525WUgEX8vUdND1bmkam4Vge7KMGnuF40Q7I43CT7U/dLVmR1AKEZ
	lO+vC9S9brUnQ6w8OZmTlkBoc6obzI06Ops/Es8D6P0G5zIm9+6zObK9bFIbysc+DcVUnU3jJNg
	QYECd5F6wGyGA/vKoBF+/HFQAEC7lGZmw71vBvIvCZ7khWAZZPirBvD1tVS1X4MvL4nK70gv3
X-Received: by 2002:a05:6a20:72a8:b0:3b4:8b89:9fac with SMTP id adf61e73a8af0-3bd4ae35d18mr422542637.23.1782349209864;
        Wed, 24 Jun 2026 18:00:09 -0700 (PDT)
Received: from p1.. ([2607:fb90:ec8f:cfa:df4a:3751:5684:c96f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bc1e0a90sm656279a12.15.2026.06.24.18.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 18:00:09 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
Cc: kees@kernel.org,
	horms@kernel.org,
	Weiming Shi <bestswngs@gmail.com>,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH nf] netfilter: ipset: fix race between dump and ip_set_list resize
Date: Wed, 24 Jun 2026 18:00:06 -0700
Message-ID: <20260625010006.1448558-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The release path of ip_set_dump_do() and ip_set_dump_done() read
inst->ip_set_list via ip_set_ref_netlink(), a plain rcu_dereference_raw()
of the array pointer. These run from netlink_recvmsg() without the nfnl
mutex and without an RCU read-side critical section.

A concurrent ip_set_create() can grow the array: it publishes the new
array, calls synchronize_net() and then kvfree()s the old one. Since the
dump paths read the array outside any RCU reader, synchronize_net() does
not wait for them and the old array can be freed while they still index
into it, causing a use-after-free.

The dumped set itself stays pinned via set->ref_netlink, so only the
array load needs protecting. Take rcu_read_lock() around it, matching
ip_set_get_byname() and __ip_set_put_byindex().

  BUG: KASAN: slab-use-after-free in ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1697)
  Read of size 8 at addr ffff88800b5c4018 by task exploit/150
  Call Trace:
   ...
   kasan_report (mm/kasan/report.c:595)
   ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1697)
   netlink_dump (net/netlink/af_netlink.c:2325)
   netlink_recvmsg (net/netlink/af_netlink.c:1976)
   sock_recvmsg (net/socket.c:1159)
   __sys_recvfrom (net/socket.c:2315)
   ...
  Oops: general protection fault, probably for non-canonical address ... KASAN NOPTI
  KASAN: maybe wild-memory-access in range [0x02d6...d0-0x02d6...d7]
  RIP: 0010:ip_set_dump_do (net/netfilter/ipset/ip_set_core.c:1698)
  Kernel panic - not syncing: Fatal exception

Fixes: 8a02bdd50b2e ("netfilter: ipset: Fix calling ip_set() macro at dumping")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/netfilter/ipset/ip_set_core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index a531b654b8d9..6cfad152d7d1 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1480,7 +1480,11 @@ ip_set_dump_done(struct netlink_callback *cb)
 		struct ip_set_net *inst =
 			(struct ip_set_net *)cb->args[IPSET_CB_NET];
 		ip_set_id_t index = (ip_set_id_t)cb->args[IPSET_CB_INDEX];
-		struct ip_set *set = ip_set_ref_netlink(inst, index);
+		struct ip_set *set;
+
+		rcu_read_lock();
+		set = ip_set_ref_netlink(inst, index);
+		rcu_read_unlock();
 
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
@@ -1686,7 +1690,9 @@ ip_set_dump_do(struct sk_buff *skb, struct netlink_callback *cb)
 release_refcount:
 	/* If there was an error or set is done, release set */
 	if (ret || !cb->args[IPSET_CB_ARG0]) {
+		rcu_read_lock();
 		set = ip_set_ref_netlink(inst, index);
+		rcu_read_unlock();
 		if (set->variant->uref)
 			set->variant->uref(set, cb, false);
 		pr_debug("release set %s\n", set->name);
-- 
2.43.0

