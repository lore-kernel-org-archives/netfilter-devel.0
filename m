Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97A12D60C
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116219; cv=none; b=lUDlCZzxw1/Vmhi92bDhOrRqe7bdfk0XGSStwxSZ+i+MEb2BePitYPpyDckeNxCQvG0ryIwXhVerZF2Ijx0K6HwpNAXmtiEzsMQ7T+dIxpORaWKg6hLvdu18fg/EMWBnVhk7IF0lv+GnvhTnKz8BZoynt2TwTVyTH5hTn49Tt2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116219; c=relaxed/simple;
	bh=UcBcd5GLwor4/IYBqG9gtzZ2sEsYIFp1lkpQXAj3dTU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh4KdPAfQzSROFRg4feaMKirfC7yYcMT2de1V8s8OI68eoZs45bF+GGZgPmr96S8j7Hk+VUyA3LVZZzQyoBc3rs1nq5SsGmfZ4Jir+VNUnco8OjwjD9+CIhMmWO2JrCDIfm7n23y96gsCPhZVHct/bFe8JPtdwZBRuQdsBt8dTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VB7Hgnfg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VB7Hgnfg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NjKhpMRe4a8Fjysag5QvCGho0UtUIh3P0WHGigoOe80=; b=VB7HgnfgkDGhopr2wYWNeagWhM
	10Kx5SftOwARLlS88Cd3tkvTHNvVNyVJUn8tOQGm/D8zMCtcAzrNOl7hXqlSPiQH2NF/p6XDU+dQx
	blYzb2HwQY2e2OymL40oU4QaVIXwvlZP5gUGqx6atx30BM9zCj1ePouGvmiv9Js6c4/uokEb7t/GB
	aqAVJa8pfIxsFEK2GxVfP/wqGiWK2ou2JN+/4CLIcC0Oj+GOzzc0jqU5YllkLkQRxzb73J87FnV8w
	0pWocTI21pKFodaERQMEVAXOjDvTDJy0Rlkr1Lfw7TGwEWbb7sBoVEy7mXc+TTzmsFlM2Zz45KJqQ
	uOrSR5Mw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp60-000000002Uj-1TBM
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 08/14] xshared: Do not omit all-wildcard interface spec when inverted
Date: Sat, 27 Jul 2024 23:36:42 +0200
Message-ID: <20240727213648.28761-9-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240727213648.28761-1-phil@nwl.cc>
References: <20240727213648.28761-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rule parses correctly, but the (never matching) part is lost on
output.

Looks like a day-1 bug, make it fix the change after which it applies
cleanly.

Fixes: b2197e7834f77 ("xshared: Entirely ignore interface masks when saving rules")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/iptables.t         | 2 ++
 extensions/libarpt_standard.t | 2 ++
 extensions/libebt_standard.t  | 2 ++
 iptables/xshared.c            | 2 +-
 4 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/extensions/iptables.t b/extensions/iptables.t
index 5d6d3d15cc5fd..2817c3fb8437f 100644
--- a/extensions/iptables.t
+++ b/extensions/iptables.t
@@ -4,6 +4,8 @@
 -i eth+ -o alongifacename+;=;OK
 ! -i eth0;=;OK
 ! -o eth+;=;OK
+-i + -j ACCEPT;-j ACCEPT;OK
+! -i +;=;OK
 -c "";;FAIL
 -c ,3;;FAIL
 -c 3,;;FAIL
diff --git a/extensions/libarpt_standard.t b/extensions/libarpt_standard.t
index 153540903f786..d6eaced3bd5e3 100644
--- a/extensions/libarpt_standard.t
+++ b/extensions/libarpt_standard.t
@@ -9,6 +9,8 @@
 -j ACCEPT ! -i lo;=;OK
 -i ppp+;=;OK
 ! -i ppp+;=;OK
+-i + -j ACCEPT;-j ACCEPT;OK
+! -i +;=;OK
 -i lo --destination-mac 11:22:33:44:55:66;-i lo --dst-mac 11:22:33:44:55:66;OK
 --source-mac Unicast;--src-mac 00:00:00:00:00:00/01:00:00:00:00:00;OK
 ! --src-mac Multicast;! --src-mac 01:00:00:00:00:00/01:00:00:00:00:00;OK
diff --git a/extensions/libebt_standard.t b/extensions/libebt_standard.t
index 3f1a459cb9814..4cf1f4cfa3ae5 100644
--- a/extensions/libebt_standard.t
+++ b/extensions/libebt_standard.t
@@ -17,8 +17,10 @@
 --logical-out br1;=;FAIL
 -i + -d 00:0f:ee:d0:ba:be;-d 00:0f:ee:d0:ba:be;OK
 -i + -p ip;-p IPv4;OK
+! -i +;=;OK
 --logical-in + -d 00:0f:ee:d0:ba:be;-d 00:0f:ee:d0:ba:be;OK
 --logical-in + -p ip;-p IPv4;OK
+! --logical-in +;=;OK
 :FORWARD
 -i foobar;=;OK
 -o foobar;=;OK
diff --git a/iptables/xshared.c b/iptables/xshared.c
index b1997ea35f8f8..8c7df3c986eed 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -759,7 +759,7 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 
 void save_iface(char letter, const char *iface, int invert)
 {
-	if (!strlen(iface) || !strcmp(iface, "+"))
+	if (!strlen(iface) || (!strcmp(iface, "+") && !invert))
 		return;
 
 	printf("%s -%c %s", invert ? " !" : "", letter, iface);
-- 
2.43.0

