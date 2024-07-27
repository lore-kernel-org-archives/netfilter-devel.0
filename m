Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EEAC38396
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116218; cv=none; b=pvqA7UB5R8YILSE7GejDFfmF5fD38FLHrZAj4PDjoIUvu2ORgM4jeDS/MCht2yE1TrV1BU1AxT4eOuReQ9z0yLzeTtmxUFK5xtIyHkN9lH/TKmBOxC2sVVexS6wwfjmbsiPFEpscO1B+XKFyOdkQKA/Tyo02VFj0RdrajU74hVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116218; c=relaxed/simple;
	bh=N451ICJEqJQ22Esxd06MPY2ryXl0sZEKeSrmmky2ihg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYILu9SEw9MYEQzYGikr68NBYN7yfsKVJXjsS8wQANJaz0HFgwbsIgASv3PsezUgOwV8VO7LcglxEC7PNTXTEXrrYcnVUbgSOh65AEZ+RySAEWg5gKsKLKz4yHvmyNBtt0BfjTMkftPN7J4NQU1H9njnPXrdjdWEJ0dbJd/6G0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Xf94iET8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Xf94iET8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3/htYBKMcf8S9ScnUwoUsJKMdGGpbL7kchvyl0WVuZA=; b=Xf94iET8YBs9cjcVfczw7falJ5
	E2Dovv1LWIUqx0od3uWCKIlVwS3dKU79d1PBx/L7cWpZy85FEWrYs5L7IYqBdXAxSPHftAnOOJ5G8
	WB9uygDHw78gKHj/Xgpepp8ypkYUU+TBVVTR8ooB+PlNRrAk7ib2QVUrx14DofO9hX0YNvk+x6ki3
	FWDwKNTW2AHAYt2HvJiOgegihsJ31qFJbz86gVGWrtGtIrdANbXqTgm20xutkcONAzSYfIh+iHjrW
	ZiHZtkFMs1w931XiYUQN5zDzFPNzH49IijIAZjpkLDlvNMlwaGrLaiQYO2gOXlSQWdXaKzQJyBh89
	nycFwvKw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp5z-000000002Uf-3KTl
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 14/14] ebtables: Omit all-wildcard interface specs from output
Date: Sat, 27 Jul 2024 23:36:48 +0200
Message-ID: <20240727213648.28761-15-phil@nwl.cc>
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

Regular code path doesn't hit this because the conversion to
libnftnl_rule takes care of it already. Future changes though will cause
iptables_command_state objects to be printed directly, making this
relevant.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index f4a3c69ac1660..0f85e21861cde 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -212,7 +212,7 @@ static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
 
 static void print_iface(const char *option, const char *name, bool invert)
 {
-	if (*name)
+	if (*name && (strcmp(name, "+") || invert))
 		printf("%s%s %s ", invert ? "! " : "", option, name);
 }
 
-- 
2.43.0

