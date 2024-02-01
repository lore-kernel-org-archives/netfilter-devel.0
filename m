Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22765D468
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795466; cv=none; b=W07LL79xD+zgJuFgOiJdSfoZoY1c5N4nFsA/yEagoeqtX6A6zBcaTl0AcHifPyxKtGJP0C46HHpbTknTsxt0T3peBa1YTMXdiYx0hf/a6WlrJ5HYKtb86uV6fU/ZnWo02wEiocU6thiTRsDKfFc5ZRvTjmulfurNwQ2qMttFeZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795466; c=relaxed/simple;
	bh=Rj3l5c0wvBNRwQn4Aq8a8N8OV/rYZ/NmdJGZGNRQHqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppYcRR52HcqyWo8OVQNzwws6ivtmFwWZiVrmRTEAHRhkaNy3AwF9nZi6h4JV37P2ufDG/MRtYnLjRcNJmZD/RGN2UrK3fWwui6TON5A3HhACv7tk54HQuIGfeiSTv4KAcijokrOx/zg8qCPl1myDIosNTWCdFYUX0dwJtt1AZsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GSo/0CLB; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GSo/0CLB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=AJT80PESImMFcBo0V0PBaZDhtnw0ENM2HnAnqJvBc6w=; b=GSo/0CLBERWllRw+UIeQbYLYlc
	M1UWbuNvgbNIDNHBsg2k4X5vp0bKOCQK8uRVtim4kOGRYp3zBI2BFwftn1NzDwskylhrJa/jtoZQT
	ev1uTIYY9arP/HdyPH3kNHrGYrxCy1VBo8DQoD7rM+ZGCZ8kZ3zAmdw6Z/CnBojGBCCs9cUM6EsSG
	BKrr2tKo5/A/J4eAXMkpH5ADeSZ9J/2LzidmH5hsS82kNsSfTw3+DAk578DRTgFM/5LiLS06M+w+D
	X+aSU7zyQDuD3QqCxSZPeGBjykswHmKRKZ+762X1/kfUDasqOGVDm2b4dnBXT/1OWI+Dis8kClS4A
	CatPSIUA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT4-000000001MV-1XQi;
	Thu, 01 Feb 2024 14:51:02 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 4/7] xtables-eb: Eliminate 'opts' define
Date: Thu,  1 Feb 2024 14:50:54 +0100
Message-ID: <20240201135057.24828-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240201135057.24828-1-phil@nwl.cc>
References: <20240201135057.24828-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is more harm than good as it hides assignments to xt_params->opts
field and does funny things if statements actually use xt_params->opts
instead of the define.

Replace it by local variables where sensible (cf. command_match() and
command_jump() in xshared.c).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 250169c35d521..d197b37e81e9e 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -141,7 +141,6 @@ struct xtables_globals ebtables_globals = {
 	.compat_rev		= nft_compatible_revision,
 };
 
-#define opts ebtables_globals.opts
 #define prog_name ebtables_globals.program_name
 #define prog_vers ebtables_globals.program_version
 
@@ -281,6 +280,7 @@ static int list_rules(struct nft_handle *h, const char *chain, const char *table
 /* This code is very similar to iptables/xtables.c:command_match() */
 static void ebt_load_match(const char *name)
 {
+	struct option *opts = xt_params->opts;
 	struct xtables_match *m;
 	size_t size;
 
@@ -305,10 +305,12 @@ static void ebt_load_match(const char *name)
 					     m->extra_opts, &m->option_offset);
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
+	xt_params->opts = opts;
 }
 
 static void ebt_load_watcher(const char *name)
 {
+	struct option *opts = xt_params->opts;
 	struct xtables_target *watcher;
 	size_t size;
 
@@ -337,11 +339,12 @@ static void ebt_load_watcher(const char *name)
 					     &watcher->option_offset);
 	if (opts == NULL)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
+	xt_params->opts = opts;
 }
 
 static void ebt_load_match_extensions(void)
 {
-	opts = ebt_original_options;
+	xt_params->opts = ebt_original_options;
 	ebt_load_match("802_3");
 	ebt_load_match("arp");
 	ebt_load_match("ip");
@@ -358,7 +361,7 @@ static void ebt_load_match_extensions(void)
 
 	/* assign them back so do_parse() may
 	 * reset opts to orig_opts upon each call */
-	xt_params->orig_opts = opts;
+	xt_params->orig_opts = xt_params->opts;
 }
 
 void ebt_add_match(struct xtables_match *m,
@@ -528,6 +531,7 @@ int nft_init_eb(struct nft_handle *h, const char *pname)
 
 void nft_fini_eb(struct nft_handle *h)
 {
+	struct option *opts = xt_params->opts;
 	struct xtables_match *match;
 	struct xtables_target *target;
 
-- 
2.43.0

