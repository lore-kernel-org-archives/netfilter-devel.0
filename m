Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A459647
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Nov 2024 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894247; cv=none; b=NWSPLZO+1ue9jq7KSWYKqzCVXC2hyXlEeUB9HO6UqPrh9p3+afvE7H+MN8bFSpbLY++66ByCsekO25Mz0wejFBlm0ystRgIyZueCTZj2ItAZvpemw4NWAI81JMoZC+C4R4u87Nd4BzUDZgDj0mM4yErXdoDC2FQe/cR83uU9AQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894247; c=relaxed/simple;
	bh=CmCCGMXonfKskOh8a4bnmDGi7cPzl2HkHpprtf41Mus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=excWVIdDelUm2jdAV2bBcW0Swje4NIbWUeVq2q2faaI0KLQwFFSEPkXjsIoh5Iv4AGUz8Bc5AYzMbQMKQXr0cc0m511/P4hl62TKWcsI+erO4izNlSQ3VZGd1vMwC5EIS3RzRMsFmH6EUFVrhcH+w5MG2b0XgK3GiFrHJlei6pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FtU7P79w; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FtU7P79w"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Lu3BlP4kIRuw9Phy83svBKQdaOZZLPnO3L14Mk7bWDI=; b=FtU7P79wyQvRwH8kimif15FiQ8
	idviJLZXhWJ+msLhvFEo5pLcIxZ3p8h1eniNmfp1ahwkZ94SXQdiOrjxuVvbvdOyh4RfErZWvAVKN
	qaLaCTtRe8xhonMdb8VUu2ZHUL/uw77MzgAg85IK4R8qxas8eG34jEjLdej0jZdaTePAwETEs/K3r
	1LmdRWZ4EIRl42QCP8DfgSF4G/ZbgvR0fGZ0K17Ipe7tLANlGrjMOkXqFGi7RIpUwr9xGFmXhv+y1
	HeY719P+dhwsNnT3Pc2aqK0bjR2crinmkOoC+ZYjPZHh8pYbOjdXFhtTzT2m7U4eNMDzBbJFmq2V6
	ZcDLYZjg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tH2x1-000000001zw-345z;
	Fri, 29 Nov 2024 16:30:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: [nf PATCH] ipset: core: Hold module reference while requesting a module
Date: Fri, 29 Nov 2024 16:30:38 +0100
Message-ID: <20241129153038.9436-1-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User space may unload ip_set.ko while it is itself requesting a set type
backend module, leading to a kernel crash. The race condition may be
provoked by inserting an mdelay() right after the nfnl_unlock() call.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/ipset/ip_set_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 61431690cbd5..cc20e6d56807 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -104,14 +104,19 @@ find_set_type(const char *name, u8 family, u8 revision)
 static bool
 load_settype(const char *name)
 {
+	if (!try_module_get(THIS_MODULE))
+		return false;
+
 	nfnl_unlock(NFNL_SUBSYS_IPSET);
 	pr_debug("try to load ip_set_%s\n", name);
 	if (request_module("ip_set_%s", name) < 0) {
 		pr_warn("Can't find ip_set type %s\n", name);
 		nfnl_lock(NFNL_SUBSYS_IPSET);
+		module_put(THIS_MODULE);
 		return false;
 	}
 	nfnl_lock(NFNL_SUBSYS_IPSET);
+	module_put(THIS_MODULE);
 	return true;
 }
 
-- 
2.47.0

