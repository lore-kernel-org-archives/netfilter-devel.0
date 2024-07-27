Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9A136AEC
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Jul 2024 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722116221; cv=none; b=kkV2l2gf536VzEPFFqkJxWXmkep1APjgj2MWTiuta2gDC71FQyzvTz+ZlUN7imjaOJxeCkbcTO1acyLGDVxhXOJIcT6hh998nsUvKjLmiNrqmv5dAvBM0GhvZGMNvom/IzuF1UVQODvLh7NKlIx3mrcnm03rOyYHjs3A32WC9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722116221; c=relaxed/simple;
	bh=Tku/gJLOqdRz70FSc6heW0xKcANEYLenFosoe34JPsU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkYp6+/aRxwcP+TQPWA7RCj++1vEXLC8RTv+ulSFnr1bdwFnxd24Os5nBEM8ih3GZ5wng+AyrmqtV3RWli76nr4q9LTKpGsCvxVUNuMp1SmIMYugp6+8SE89GdvOL1GltWcXZ3K5Uyrm0vyxJHw5DZaEJxONnuE/TRu3sB8nxKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Djt4splI; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Djt4splI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EEtdWKAx9USIdSuEytvlfADj88qjfU1+8BCfXEgO+SU=; b=Djt4splIFp6Ga6rx6+g9LpFj3E
	Sc9f8n7sC8mDsPWpHSc6Q9W+Ow6XUyh5dvBPzY9XzX/+xuWGElIjBC/x8Ki2c9lp3U9k3bjohI/yE
	WWbuLeTc2PB9el4/IR09nY+tr7NXym7+B/G82UIXBB9XmW/TSxSoARdmwOw87yob3MUghKT/e4IIS
	jZMAPWOjU98YNoUH4WYErmwpppyFdH2QEXMtjnaA0BpGsX1l6uayfKXKRDO8zJmZtv/xvkYuyOjfF
	h5dAG821fsBNmRUJbKtdfNb2Myrocwm1+29Qd8dP3IEFpL2wCLx2F1jNpW0VSYrMuOB78qNl55kpV
	Cv8o9z/w==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sXp63-000000002V3-0bEh
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Jul 2024 23:36:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 10/14] xshared: Make save_iface() static
Date: Sat, 27 Jul 2024 23:36:44 +0200
Message-ID: <20240727213648.28761-11-phil@nwl.cc>
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

Since commit 22f2e1fca127b ("xshared: Share save_rule_details() with
legacy"), there are no callers outside of xshared.c anymore.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 2 +-
 iptables/xshared.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 8c7df3c986eed..1070fea42c8cf 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -757,7 +757,7 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 	printf(FMT("%-6s ", "out %s "), iface);
 }
 
-void save_iface(char letter, const char *iface, int invert)
+static void save_iface(char letter, const char *iface, int invert)
 {
 	if (!strlen(iface) || (!strcmp(iface, "+") && !invert))
 		return;
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 26c492ebee9ec..0018b7c70bd83 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -216,7 +216,6 @@ void save_ipv6_addr(char letter, const struct in6_addr *addr,
 
 void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 		  unsigned int format);
-void save_iface(char letter, const char *iface, int invert);
 
 void print_fragment(unsigned int flags, unsigned int invflags,
 		    unsigned int format, bool fake);
-- 
2.43.0

