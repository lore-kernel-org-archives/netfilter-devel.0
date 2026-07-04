Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1F52F7EEF
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 06:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783146163; cv=none; b=US+4aXKIgto+bXnC8PfjzNbe4mV9cAinCZZ98q4K7zr0T5ccExwHivYgnKiTCkk+4SSdBYpLw2HS7QFDkcNyINQq74v0mPvgiH3vx3hX6QeEuiKanuKxJfAdGeGKpKjh7RoQ+Fn2yR/B1Qz9j/FFmZb9mw/Q4RsrbPvaW5nP9BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783146163; c=relaxed/simple;
	bh=PnJrAFYi+mj1ieNKLV2GXIZw3gO7mdCTwfIOv48ITqU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pLC0JqcRyVrPgQSDK6/o2IsYDyNfmdOR4ifn7khQuWQUf7IZWuJX9wQAm/RpW9dkfVJdzbdkGNWUARt1pCuR3zHlebQywvSFnHCF1ibYv2Qp5mHu/c1u+j5lwJnUwzKHFRCzoqnQ54q3fNe9+ZnknmHM7HBQdMRvU/40Rz7ZszQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aY66fWrH; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aY66fWrH"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c8fee9f63d5so625102a12.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jul 2026 23:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783146161; x=1783750961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q6Y3yMjx6909BBBSsLtnHC5GrGrYvCid6v9Tt9MQtbg=;
        b=aY66fWrH/A0Lz1YSnOhkTehXX6xaOSlCmRsfhgIrFwnw6q1SGuBnl2eMNEUphg8ts5
         0umS7/ynuDFzRXalHs+8BHFtknhdHPbMQh3gCSgeTuIrlY91V+oXa05/k0T9A96+7K+L
         4xb+v+frU+LicBtc5U98rL8O4JsDi5iqFDskq+rv0ExB7vQ6bKTiSuPS5j5N3iBUsl6D
         TZ6mZ6Wi8FA6I9JjMcM7hvtruuFc1J4jYyb6db7cQ+ZIQZalRssiKSg9ZA0XupPjLWnz
         mZnvpHSi2cG2g1dRnNu/hdqNmdx93AMJfxU/zle+oPCKUBQpYnLGhCouB1hRoQBEp64U
         sz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783146161; x=1783750961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q6Y3yMjx6909BBBSsLtnHC5GrGrYvCid6v9Tt9MQtbg=;
        b=rTc72xz3ES4nD6y8mImuGEDdK+4lGCtZ3iuY7m0y51xTrNq6E1m6Uz9ltw6Ki92F1/
         ZrKlqEahecpxD8JzsCmtE59g/rK+OZnwjfp5ttkR14cC15vfurejGYppvSINu0JlDQoH
         X+3xzEnYYPvpcYYe5TnKPxkzTnaw7pbed2UPmDBhjECEc5LzjuPb4z3fG9Sy/5TclmZy
         mLej57beebHRxIBLsfbUtcqRnX4n9uDNb7XlZkGZT5Ha1bt4JYbzaEyAjzbUSw5MfcZ4
         ER+Dxb/Ut/i2t3KKayfjRF9kdNA/ZYoXS0QT8R+G8JOv5yiZRMVn/4cIpyiIpG2vXV0Z
         bi2A==
X-Gm-Message-State: AOJu0YyBxa0rQz75+N/TVm5Oqre9Jdo78i5utlY4kMtn0XGxPYZR8ZVm
	xI6e+1tpjgmLXxot1A2LI3ooLWK1jqAVg+xWPXDuuGw+Tw0+Ye8rHLek
X-Gm-Gg: AfdE7ck6YmLroGMBTq7gyDH24nppRTKpdtJpIw2UDRqE900SkO5yEomorWx3jRJgD98
	adK3dIpBGZE1oXr4nRNYRfSMsE3PiB/lvN97MmF8Xc6ilT0JJxPYbDw6QPL5/HDKZtn0wMxATs0
	yT8r+7+qsRdZbcXh0BjirYTkfBFrXsvatu2vFefa/j6diUZkzysxGXDM1CC/kg49ElCUwrY1NfT
	LQPSfmA4tgMi139SaTX2Jt2qQDuctndcZF7bKtMvoObPWINCr7jnUQph+cessoeOPVUazJhr40L
	IIU4+awYcmYSmDEDTCH+43MYaLapDr8UKiOjdcwmz63TxgM76sH69hRCg5xMfSzAieRbnhS3iZE
	1qHdEAl7SaVTgsst2C9BoqjYrmtMe9wvolgc3WZLOIX/yd3AbF5mPDk06vnlh3fjYZWOT+B8FNl
	DBOwd2NZAzlihm9hBqgeyZp9Tbi7hJgsAu4SieA7NXfpXuF6QUbBmmoi082Q==
X-Received: by 2002:a05:6a21:390:b0:3bd:4698:e7c4 with SMTP id adf61e73a8af0-3c03e5747ccmr2328719637.42.1783146160612;
        Fri, 03 Jul 2026 23:22:40 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f44581df4sm3898287eec.16.2026.07.03.23.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 23:22:39 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: ipset: skip extension destroy on hash resize replay
Date: Fri,  3 Jul 2026 23:22:34 -0700
Message-ID: <20260704062234.2625208-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During a hash set resize, mtype_resize() copies each element into the
new table with memcpy(), so the new-table element shares the old-table
element's comment extension.  An xt_SET delete on the old table during
the resize destroys that shared comment via ip_set_ext_destroy() and
queues a replayed delete on h->ad.  After the table swap mtype_resize()
replays it with mtype_del() on the new table, whose copy still points at
the freed comment, so ip_set_ext_destroy() frees it a second time:

 ODEBUG: activate active (active state 1) object: ... object type: rcu_head
 WARNING: CPU: 3 PID: 5311 at lib/debugobjects.c:514 debug_print_object
 Call Trace:
  <IRQ>
  kvfree_call_rcu (kernel/rcu/tree.c:3825)
  ip_set_comment_free (net/netfilter/ipset/ip_set_core.c:397)
  hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1098)
  hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
  ip_set_del (net/netfilter/ipset/ip_set_core.c:813)
  set_target_v3 (net/netfilter/xt_set.c:412)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:346)
  __ip_local_out (net/ipv4/ip_output.c:119)
  icmp_push_reply (net/ipv4/icmp.c:397)
  __icmp_send (net/ipv4/icmp.c:804)
  __udp4_lib_rcv (net/ipv4/udp.c:2521)
  ip_local_deliver (net/ipv4/ip_input.c:254)
  ip_rcv (net/ipv4/ip_input.c:569)
  </IRQ>

The replay passes a NULL ext (the kernel-side delete that queued it
already destroyed the extensions), so skip ip_set_ext_destroy() when ext
is NULL.  This also avoids the NULL ext->target dereference that was only
kept safe by the new table's ref being zero.

Reachable from an unprivileged user namespace.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix \"INFO: rcu detected stall in hash_xxx\" reports")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 5e4453e9e..bc909ae2d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1080,9 +1080,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			mtype_del_cidr(set, h,
 				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
 #endif
-		ip_set_ext_destroy(set, data);
+		/* On a resize replay the extensions were already destroyed. */
+		if (ext)
+			ip_set_ext_destroy(set, data);
 
-		if (atomic_read(&t->ref) && ext->target) {
+		if (ext && atomic_read(&t->ref) && ext->target) {
 			/* Resize is in process and kernel side del,
 			 * save values
 			 */
-- 
2.43.0

