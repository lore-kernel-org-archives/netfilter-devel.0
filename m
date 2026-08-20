Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AE61D89EF
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 01:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787187981; cv=none; b=HFzs7rkpfCjN4BdtoHyiw7YKBKMEk6os8qJK4sJqjVHKQz6KnBQfMouhY+Ry/BSs8jBlZlNXcutHXT9BfOanBY68iCLruiegjDXpGYfSY2mho2M6vtz3U6QiiSpnT4DSJufT+GxF5ZTewclfzVzqE/Rpg3mTEV2YEdqU+sMTlFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787187981; c=relaxed/simple;
	bh=6n/uZQR5aUanqHSqO5R7Kh+SBqhfqON4fmhIll6OHqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IZ2Nyrb1AtbromQvR5yoj31ZM1g94/yYsf1Z2++wYkbhI2xBiEhN2b4UnqU9ubFl3XSUhtZwto3RS3nrUPniFnMJtBsfah1hRTpmbnprTGk9UrbG/qC82ul88x6pqKnYzCb4TJb8ZyrD1MwuQwai2Q2O3CDL7a2EavCrfDZonn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MjuF76uJ; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjuF76uJ"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66b2c08803cso2030896d50.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2026 18:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787187979; x=1787792779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o36bXNM2ARffm3iLy4WlKgnd3gxGay/ODxd6X4i877s=;
        b=MjuF76uJ7Z3vgt68EHJBnR1BO4TG9iFtvFYMhzjue2x2q78vNlOExgdCUIJ9BTtOu+
         IAbaGVTV9Q3N/A9zTgPLQvqbwMpslJUp2YOKSNGQtD01Id8wvV9iFJH6ybjiRH+py6dy
         YPuyTn+VgFxx1Seei8tuDwDtfGMW98Dl8rFqfqpvnlmTR7MRabQJPkHGhgf5oQVf1lk7
         QNTRynpSVfhTkfNafI6kte2jvVjz4NGB7KHqJeSkc907yxPZmMK2MaORngKemO0l+X/y
         AptXQ1kxpYcGd6bqJC3hScubhBJbAI0miuWbAX24VeRNFf0aJSfiEi9cdBG0rQ9j6pSk
         gtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787187979; x=1787792779;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o36bXNM2ARffm3iLy4WlKgnd3gxGay/ODxd6X4i877s=;
        b=RbMcReRVOiT0ZSraqUZuFG8/tn4VU81BrAY2v2n170FL+hWzzANGi+GE7QWhEH7pKQ
         K4Q5MtKhldjcbtaiHbVc3iWbjMsTCl0ckqKnLYKUb+++jfRwskRCxGHgeYpZShdohCz8
         E6tqzviHXtAmFwOOs4VuTlS5xBg2OhWYdS5LpnPicZPVQ8nz0thGuGEbKgqghx0dswL4
         ts2r+4N045i5vdSOokJUybOLMhpxuSvBvN31nyiQEu4vQ3pI87ARv1ACkHQDtvBLNQAB
         /l7LQU9lwdb0E3syRbbZeZIgIu/ULqhA+6ZEBm/B6W/zjGOon2clQ818JaF/VqWdLFe8
         xqHA==
X-Forwarded-Encrypted: i=1; AHgh+Rqg+PBnCj4beYo6lUI1ZEisC6UZwNpdymSgc0xnpA9cilLyGP1zjrUxk0fexhnQ4YHu4g07nCGNbvRkASYU2IE=@vger.kernel.org
X-Gm-Message-State: AFuF++nuho7FjvAw3STe8XKSbtfAZAf7FMNnoaGn8ElRHXE1fKuxpiJz
	XGCDMlih0btqaDAYUjlLztrWNm9M8hYFDTIYP05N3B/hwfuCw4QiGQm7
X-Gm-Gg: AR+sD13Ei3mfD1KuIissh8h1f96GquXroPe48Eaty+fuZvt6uXEtOXrgdg6jxEyxTkB
	a7BOjp7s53OO1dJZiEM516XAd/VT0axWMyHMKsB91rmJGeRvdAnNvq3Ffdbj1myz+OYql/CR4ns
	aPfLHS4vUNISnJAFrD8XV1KofWXUZFI7oReVcl8NmcguQwP7D5vOVO69bH29zXGzAEAHcj4wnK0
	2gFwTU3i5shu0wHqZPQDOE/3NroGDKo5lkPPQ38Z/N0tDlFi4ym96a70MV+VWFFo6TUG1uSmwf8
	o93vtr82KiN/h5V9dtXbEf6rulaL6baD9QGaGsNIPClzP8GrUxzx44KuYBlnQ02RZUgglKbVuRF
	9c3f3I5n9ZTeDFFoHy18+xAT+X0muZRSnfUt8x4GrBTE0rYCgWLTG3XGfCRgThVY0tkHul0f6Kr
	820zeqbHSESLsmSH0NO8MHMzS0MBZMhSGlbR9jbo/FaJmbbKU1ZFHLItL1NqBSH8TXRoi3n6sdk
	s+P2w==
X-Received: by 2002:a05:690e:450a:10b0:668:9fa5:b9cc with SMTP id 956f58d0204a3-66ccb4070bcmr2684977d50.0.1787187979411;
        Wed, 19 Aug 2026 18:06:19 -0700 (PDT)
Received: from mac.lan ([136.55.173.105])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84511abb205sm17428687b3.6.2026.08.19.18.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 18:06:18 -0700 (PDT)
From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: phil@nwl.cc,
	horms@kernel.org,
	kadlec@netfilter.org,
	kees@kernel.org,
	enrico.pozzobon@dissecto.com,
	sbrivio@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	AutonomousCodeSecurity@microsoft.com,
	xmei5@asu.edu,
	tgopinath@linux.microsoft.com,
	kys@microsoft.com,
	blbllhy@gmail.com
Subject: [PATCH net] netfilter: ipset: list:set: defer ip_set_put_byindex to RCU callback
Date: Wed, 19 Aug 2026 21:06:17 -0400
Message-ID: <20260820010617.46851-1-blbllhy@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

list_set_del() and list_set_replace() call ip_set_put_byindex() before
call_rcu(), dropping the child set refcount to zero. Meanwhile,
list_set_ktest() on another CPU may have already read e->id under
rcu_read_lock(). A concurrent ip_set_destroy() sees refcount zero,
NULLs ip_set_list[index], and frees the child set. list_set_ktest()
then passes the now-dangling index to ip_set_test(), ip_set_rcu_get()
returns NULL, and BUG_ON(!set) fires at ip_set_core.c:746.

 kernel BUG at net/netfilter/ipset/ip_set_core.c:746!
   ip_set_test+0x329/0x590
   list_set_kadt+0x2a6/0x810
   ip_set_test+0x24f/0x590
   set_match_v1+0x1a9/0x280
   ipt_do_table+0x83d/0x1360
   nf_hook_slow+0xac/0x1e0

Move ip_set_put_byindex() from list_set_del()/list_set_replace() into
the __list_set_del_rcu() callback so the refcount is not decremented
until all RCU readers have finished.

Fixes: 439cd39ea136 ("netfilter: ipset: list:set: Decrease refcount synchronously on deletion and replace")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
---
 net/netfilter/ipset/ip_set_list_set.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index f070088742d6..aeee0c6c314d 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -144,7 +144,9 @@ __list_set_del_rcu(struct rcu_head * rcu)
 {
 	struct set_elem *e = container_of(rcu, struct set_elem, rcu);
 	struct ip_set *set = e->set;
+	struct list_set *map = set->data;
 
+	ip_set_put_byindex(map->net, e->id);
 	ip_set_ext_destroy(set, e);
 	kfree(e);
 }
@@ -152,21 +154,15 @@ __list_set_del_rcu(struct rcu_head * rcu)
 static void
 list_set_del(struct ip_set *set, struct set_elem *e)
 {
-	struct list_set *map = set->data;
-
 	set->elements--;
 	list_del_rcu(&e->list);
-	ip_set_put_byindex(map->net, e->id);
 	call_rcu(&e->rcu, __list_set_del_rcu);
 }
 
 static void
 list_set_replace(struct ip_set *set, struct set_elem *e, struct set_elem *old)
 {
-	struct list_set *map = set->data;
-
 	list_replace_rcu(&old->list, &e->list);
-	ip_set_put_byindex(map->net, old->id);
 	call_rcu(&old->rcu, __list_set_del_rcu);
 }
 
-- 
2.52.0

