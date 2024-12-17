Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1F31F8F0C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2024 20:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734466942; cv=none; b=hXE9iwKkoHtYTRFYlZUYk31h3ThdV+r7+vzutcQb0Sxy1m2Rxj/6q7QPaL1py2gEZjIGbT7dpmtNJA1wIYR/oM1mBRPVQah+xZqlKNTIa+h+ZmfC3PAZ1kUHMB35bL48/6bLkbTx6iauFjyRsmPi2zKQ9ns255DabCB212xz6AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734466942; c=relaxed/simple;
	bh=jwDcYRPDFvtIzRTtG0dYegM4uUjuB5NqBD6sWL0eas4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=morddoB41J0vaDWTggcbCfFzLKb4YIJJRZ2P/3yd3D1diX1MXSff5lAKYpI1Kq/842focf8++e7hLRl2KFLvbz/wJBsPEn2/RIUpmfAUxc9XFjF50rfmWdt88sqsYFMUxQbSeCZTJLea+n7UYR62d7hH0eeXVJewWE74OtcNnto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qt/GGUZA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qt/GGUZA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uo0jZGFDFyWtHaZ4laEgjG2K5EtHowLXB0YO2ZZz36A=; b=qt/GGUZASLHm9A1p3WGaBufjD3
	16XnnAk0k/M9iT3ee7HvxF9Cyqx91H6xsP2mX09vJCWrK9vNZfLTr0KekjZ41kxoZHebkxsFuRwWb
	5HA5tLvwdMvSWb70Xm42kITVo94+GLcykWtOharRjMc1jeuiZbk3VkLekx58lPMjKghi8UGBoNaHu
	5qIBiK2EkCEw4JyC2uqE/JrnIeAD04NvvLnhDKCVru0hD8898+v5iwhVM2MtXfWPKvP6wZoqnqNzr
	Vmvs51dnLCMk/wFWvohWqSB3FPvqF1EzU/YxgZe7C6yMjg0t/j3O7Lw/oOsmgkEsnIYfoUez1o0po
	08Y/9OPw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tNdgd-000000008W5-12Fz;
	Tue, 17 Dec 2024 20:56:55 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: ipset: Fix for recursive locking warning
Date: Tue, 17 Dec 2024 20:56:55 +0100
Message-ID: <20241217195655.23186-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With CONFIG_PROVE_LOCKING, when creating a set of type bitmap:ip, adding
it to a set of type list:set and populating it from iptables SET target
triggers a kernel warning:

| WARNING: possible recursive locking detected
| 6.12.0-rc7-01692-g5e9a28f41134-dirty #594 Not tainted
| --------------------------------------------
| ping/4018 is trying to acquire lock:
| ffff8881094a6848 (&set->lock){+.-.}-{2:2}, at: ip_set_add+0x28c/0x360 [ip_set]
|
| but task is already holding lock:
| ffff88811034c048 (&set->lock){+.-.}-{2:2}, at: ip_set_add+0x28c/0x360 [ip_set]

This is a false alarm: ipset does not allow nested list:set type, so the
loop in list_set_kadd() can never encounter the outer set itself. No
other set type supports embedded sets, so this is the only case to
consider.

To avoid the false report, create a distinct lock class for list:set
type ipset locks.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/ipset/ip_set_list_set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index bfae7066936b..db794fe1300e 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -611,6 +611,8 @@ init_list_set(struct net *net, struct ip_set *set, u32 size)
 	return true;
 }
 
+static struct lock_class_key list_set_lockdep_key;
+
 static int
 list_set_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		u32 flags)
@@ -627,6 +629,7 @@ list_set_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 	if (size < IP_SET_LIST_MIN_SIZE)
 		size = IP_SET_LIST_MIN_SIZE;
 
+	lockdep_set_class(&set->lock, &list_set_lockdep_key);
 	set->variant = &set_variant;
 	set->dsize = ip_set_elem_len(set, tb, sizeof(struct set_elem),
 				     __alignof__(struct set_elem));
-- 
2.47.0

