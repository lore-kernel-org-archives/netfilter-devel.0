Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D153E2E64A
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116219; cv=none; b=jYuUP4nt/f6ucyFH0r4ZvpYNP6OgJwTeBOQsiIeo/haFS7iG/sxMytyMA6p2eXT4o6AJGxDyfl/l5ms8F9JIHqm/afZpBPA+x5/LeAmrStvppxMye61GIu5wIgdxwtH+JAj91MfE0u/j2hdXbMt7UykpJdRtP6d9pMpjDdVPQFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116219; c=relaxed/simple;
	bh=YpRnN060Qy047rb2x4iXuNS9SIL/KFZIYPo5zqkRFCI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6mc4TGrZHZgvVhTTlxwwaiueMgBfZpor9ABUpak1MjuQeKe+ycM3kqbG4GDuA9tEOaylq6qhoOrFS077LJ4CQWSpQFxt77ZpcuDWVsAfIzNCWzivAy5xxMpAiDDF2suEkXEtn5nW6xHXlJFcdE2K3f5adquo/efG/t3OhKpGPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YS3u+Od7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YS3u+Od7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7pJwyzTPmro5mcrsLMZ1EA9tOljqBptaDDW16Zh5mJM=; b=YS3u+Od7zwu6omqzJ4JYD5iq/P
	6M+ht6abzrLCfNUB+W2BQZtlLy3w6P/0OmTXmPhGzIXkz1LYKb4JcSuUZGPycWSPmCqQve9+L01KZ
	J7zd4pp41dK5nmuYC9VGO9sDmfIUTkdVleattklmQelzrzoF8LGVZAgOQupP28EiieYtxesRFgqYf
	KM2lHiV1z32/pqesBMz5/JBQJpDlUmpe0gB3JLXbJR4THIPZhvJEuhFahzCuzc0gl82DDoGC31jyy
	kPGfHy2QorD+eDQbn08zwuTC3Bd+8If0NwUi3jqJPtvrIJuEuOoqPWX5a7x61qMwTnU+9vv2dp4my
	vkuHhjzg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5y-000000002US-0ODx
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/14] xshared: Move NULL pointer check into save_iface()
Date: Sat, 27 Jul 2024 23:36:45 +0200
Message-ID: <20240727213648.28761-12-phil@nwl.cc>
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

Simplify callers a bit, the function tests other conditions
disqualifying any output already.

While being at it, invert the conditional - it is more readable this
way.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 1070fea42c8cf..2a5eef09c75de 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -759,10 +759,8 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 
 static void save_iface(char letter, const char *iface, int invert)
 {
-	if (!strlen(iface) || (!strcmp(iface, "+") && !invert))
-		return;
-
-	printf("%s -%c %s", invert ? " !" : "", letter, iface);
+	if (iface && strlen(iface) && (strcmp(iface, "+") || invert))
+		printf("%s -%c %s", invert ? " !" : "", letter, iface);
 }
 
 static void command_match(struct iptables_command_state *cs, bool invert)
@@ -1095,12 +1093,8 @@ void print_rule_details(unsigned int linenum, const struct xt_counters *ctrs,
 void save_rule_details(const char *iniface, const char *outiface,
 		       uint16_t proto, int frag, uint8_t invflags)
 {
-	if (iniface != NULL) {
-		save_iface('i', iniface, invflags & IPT_INV_VIA_IN);
-	}
-	if (outiface != NULL) {
-		save_iface('o', outiface, invflags & IPT_INV_VIA_OUT);
-	}
+	save_iface('i', iniface, invflags & IPT_INV_VIA_IN);
+	save_iface('o', outiface, invflags & IPT_INV_VIA_OUT);
 
 	if (proto > 0) {
 		const char *pname = proto_to_name(proto, true);
-- 
2.43.0

