Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A2247277C
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2026 12:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787056083; cv=none; b=aB9JRNExgosSjQXuUAwNA9saFUIo/wcIf7jNbAIy6DCoklE8jOsRk8gPG5NgomTEK8LTsYmAIayxVaRCDbKcgeH9RmWUNTXTz/YC1/r109dIw4N1sXbGt9hkCSsQhEYMQ6rnZqrTMJadMymo5nLcXSpNFDEX7RQLJidbHk2DRGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787056083; c=relaxed/simple;
	bh=II5JoCPW3HLMlskf3/SsR5+SqkUSC4J6WiJiyiMMba4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ho6g1zVVvpRPtrifP8ewy8NAPooFacC7R+gQBXhYE8DhTDeErgT0UaKAK2/+Xc7FuN4+w1TjI142jp7Uv4O6ec99/McDo1PdAvU7izP21aN3QYY7OKz9I8u2vnT+I7GNQiunYIpG5yBwH6LRyodQGZneSZ055a7/qK7MOue7xBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LiC0WNAI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LiC0WNAI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787056078;
	bh=sn3LCXplqtWLOv+Fl8eFVSXtgDcPZ9TYxc+Uz7mpKaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LiC0WNAIzS2gHSQoO1UMP4mTf4GUJ98fRGRSUtjd+1nXSeUsTZF/cBxwbggWHTdWt
	 dJU1syr1fbZkiQbs7cRbdDystWac0QMBPTaohzzpbKG4n9PKlwVEClG7MBHYM0nfbB
	 l8OosWMyt2x40FbLI4jsoitdygkzyFp9ymkoC+Q9T68imvZtwiHDPp/SJ9vwhE3z1+
	 eeSXWkRthQ6ap2KKqVUXIZCeEjqfA4gYyMQzsnQtv0TOiX92lTL1UnDrrTWrwkE8YJ
	 8PHBEvV4K+6KCf5cPyAfH66xCHa5IlSe9JFusWQhFReKTAj8A4CAC+etGJS4bsBmoX
	 k3ySbP+6Vs9cQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C10F260077;
	Tue, 18 Aug 2026 14:27:57 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	fmancera@suse.de
Subject: [PATCH nf-next 4/4] netfilter: xt_cgroup: use pr_info_ratelimited()
Date: Tue, 18 Aug 2026 14:27:41 +0200
Message-ID: <20260818122741.1329660-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818122741.1329660-1-pablo@netfilter.org>
References: <20260818122741.1329660-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This seems to be the last xtables extension not using the ratelimited
version, update it.

Fixes: c38c4597e4bf ("netfilter: implement xt_cgroup cgroup2 path match")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_cgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/xt_cgroup.c b/net/netfilter/xt_cgroup.c
index 43d2ae2be628..ac1b7e71cd7f 100644
--- a/net/netfilter/xt_cgroup.c
+++ b/net/netfilter/xt_cgroup.c
@@ -33,7 +33,7 @@ static int cgroup_mt_check_v0(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -49,7 +49,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("xt_cgroup: no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -59,7 +59,7 @@ static int cgroup_mt_check_v1(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
@@ -89,7 +89,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 		return -EINVAL;
 
 	if (!info->has_path && !info->has_classid) {
-		pr_info("xt_cgroup: no path or classid specified\n");
+		pr_info_ratelimited("xt_cgroup: no path or classid specified\n");
 		return -EINVAL;
 	}
 
@@ -99,7 +99,7 @@ static int cgroup_mt_check_v2(const struct xt_mtchk_param *par)
 	}
 
 	if (info->has_classid && !IS_ENABLED(CONFIG_CGROUP_NET_CLASSID)) {
-		pr_info(NET_CLS_CLASSID_INVALID_MSG);
+		pr_info_ratelimited(NET_CLS_CLASSID_INVALID_MSG);
 		return -EINVAL;
 	}
 
-- 
2.47.3

