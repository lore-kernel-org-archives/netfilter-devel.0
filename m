Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0777C215F4E
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 20:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730838952; cv=none; b=kMetcZQ2AfNIjsruKYq9mdTUFyqUrO8W5b9iXFy9cUaftbBds6uhLNJpp6IM7fl27guFFjdfHNaaShsA3nkMKStgfB4KAIR8mxIbV2aoRnAXUVGeNh8cDuUQ0kloVY8lyVLs1ezn0kzUQp33aBvcT1fonvmZeTw/Ef8qzDU3mmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730838952; c=relaxed/simple;
	bh=4rpYrCYf3R7d7lo0cEd0k8U0ZeWVmrzQ2Z/DQu+815I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hB4mHghbL9X2OdlsNzOjCvybaPRIk+dR+nhH5urKmt4tZDDdqBTjUTcpaXvjp8HLPRSlvFUJsG1o6doY4r3Kfh+udsrAxlEPnZSKLN9thELLsSwzxfHqKfzgjS8WAt469Wi9wh9P8EK1QScFf8XY5FHnkPjrqLYFjy8ULYwbwWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=L9Ce1+72; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="L9Ce1+72"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lFh7lzAe6L3UJHEEfG5+u+PDO8Wya/w//V2o4CG8EVw=; b=L9Ce1+72GQEByGsPKYt0iqaMt+
	zsHj0U3tznT7oz6f6DIVwVfR2+HWoAhfrH3QNtSpbaebkKG9J3MEty46xghEy0jh0YRTOs5322ngR
	RErj0Sjb6ate9FbAEAXfJNSa03UbubF2TmUWQ2vmPWhRLfV0dQfeMgpSdYa+XU5PU74dERwy9Unyt
	K2HbDFT6ipVn6I3JQvY6NO3hL5IMGFkpLcMvq+447oaiO2B9VNNflJOMPzXPzgperBxLou3BLGXBI
	YrXunpb4ce2aTQCeb7VGqXLEPC8owSnQox1gcW6EA4Wv3YIsXfQ/dwYNwQYDkIUUZybJPpDvhgU+L
	Bk1mNa6g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t8QHD-000000002vo-3R83
	for netfilter-devel@vger.kernel.org;
	Tue, 05 Nov 2024 21:35:47 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] ebtables: Clone extensions before modifying them
Date: Tue,  5 Nov 2024 21:35:41 +0100
Message-ID: <20241105203543.10545-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upon identifying an extension option, ebt_command_default() would have
the extension parse the option prior to creating a copy for attaching to
the iptables_command_state object. After copying, the (modified)
initial extension's data was cleared.

This somewhat awkward process breaks with among match which increases
match_size if needed (but never reduces it). This change is not undone,
hence leaks into following instances. This in turn is problematic with
ebtables-restore only (as multiple rules are parsed) and specifically
when deleting rules as the potentially over-sized match_size won't match
the one parsed from the kernel.

A workaround would be to make bramong_parse() realloc the match also if
new size is smaller than the old one. This patch attempts a proper fix
though, by making ebt_command_default() copy the extension first and
parsing the option into the copy afterwards.

No Fixes tag: Prior to commit 24bb57d3f52ac ("ebtables: Support for
guided option parser"), ebtables relied upon the extension's parser
return code instead of checking option_offset, so copying the extension
opportunistically wasn't feasible.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.h |  8 ++++----
 iptables/xtables-eb.c | 16 ++++++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index 13b077fc4fbf3..54b473ebff6b0 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -108,10 +108,10 @@ static inline const char *ebt_target_name(unsigned int verdict)
 })								\
 
 void ebt_cs_clean(struct iptables_command_state *cs);
-void ebt_add_match(struct xtables_match *m,
-			  struct iptables_command_state *cs);
-void ebt_add_watcher(struct xtables_target *watcher,
-                     struct iptables_command_state *cs);
+struct xtables_match *ebt_add_match(struct xtables_match *m,
+				    struct iptables_command_state *cs);
+struct xtables_target *ebt_add_watcher(struct xtables_target *watcher,
+				       struct iptables_command_state *cs);
 int ebt_command_default(struct iptables_command_state *cs,
 			struct xtables_globals *unused, bool ebt_invert);
 
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 658cf4b98c04d..06386cd90830c 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -367,8 +367,8 @@ static void ebt_load_match_extensions(void)
 	ebt_load_watcher("nflog");
 }
 
-void ebt_add_match(struct xtables_match *m,
-		   struct iptables_command_state *cs)
+struct xtables_match *ebt_add_match(struct xtables_match *m,
+				    struct iptables_command_state *cs)
 {
 	struct xtables_rule_match **rule_matches = &cs->matches;
 	struct xtables_match *newm;
@@ -397,10 +397,12 @@ void ebt_add_match(struct xtables_match *m,
 	for (matchp = &cs->match_list; *matchp; matchp = &(*matchp)->next)
 		;
 	*matchp = newnode;
+
+	return newm;
 }
 
-void ebt_add_watcher(struct xtables_target *watcher,
-		     struct iptables_command_state *cs)
+struct xtables_target *ebt_add_watcher(struct xtables_target *watcher,
+				       struct iptables_command_state *cs)
 {
 	struct ebt_match *newnode, **matchp;
 	struct xtables_target *clone;
@@ -425,6 +427,8 @@ void ebt_add_watcher(struct xtables_target *watcher,
 	for (matchp = &cs->match_list; *matchp; matchp = &(*matchp)->next)
 		;
 	*matchp = newnode;
+
+	return clone;
 }
 
 int ebt_command_default(struct iptables_command_state *cs,
@@ -476,8 +480,8 @@ int ebt_command_default(struct iptables_command_state *cs,
 		if (cs->c < m->option_offset ||
 		    cs->c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
 			continue;
+		m = ebt_add_match(m, cs);
 		xtables_option_mpcall(cs->c, cs->argv, ebt_invert, m, &cs->eb);
-		ebt_add_match(m, cs);
 		return 0;
 	}
 
@@ -491,8 +495,8 @@ int ebt_command_default(struct iptables_command_state *cs,
 		if (cs->c < t->option_offset ||
 		    cs->c >= t->option_offset + XT_OPTION_OFFSET_SCALE)
 			continue;
+		t = ebt_add_watcher(t, cs);
 		xtables_option_tpcall(cs->c, cs->argv, ebt_invert, t, &cs->eb);
-		ebt_add_watcher(t, cs);
 		return 0;
 	}
 	if (cs->c == ':')
-- 
2.47.0

