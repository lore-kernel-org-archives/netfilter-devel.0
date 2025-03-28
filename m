Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4CD2AEED
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Mar 2025 16:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743179960; cv=none; b=BBa4GZyz9tnJ+ZxcXn0tLpQnNFykYWViqmJs9bwKwAKvrbVSGmvTR5O6+AX0j5pGYiINGLQOgxNfr0+eoIFHqCkREcFcAuRPczsS907lvTEuI/5Tsw1KTfkA2EXVsvsFDYkel8p0GGNxdtAmD34L0Y45/RiWAxvmdYWNk4zwh1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743179960; c=relaxed/simple;
	bh=SpOSMuAPmqQe7R9qZ4FQC5nNUAfV2UcPlVLFbmTo5AE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=YaNVPh8HCik20vZz7xHn+5G3YKsWb4U9IBMoEvpj3QjCtcnnKiE0awtjVvIb3RNiSDnuZiCNFxXXVv5ycYNiLVy9wNQ1/011o0v1UL4cQTXgoNsRJ3zWJRKwvNM/cuU4dGc2eJVWBJKp3nYyYBIYZYnYHuQunOwHuP0s5WTPWoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Cfdx1yeP; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Cfdx1yeP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zB79qkPUUKv2d7grtOCCAfGv/asp+dqezQ/XOqamxpU=; b=Cfdx1yeP2Pxy8TvVGFPsq7iJ1B
	ZmDrqegk6y6XyDkQK5stt2mikimXDBRTFZs8lRCVMgXdYQ2ggBSZTWqJaiOhximYx/RqzC9KsXgnk
	NG59vOf2FCS6DzkNdybnJ/7Vt80RHZvYbW8hcDMPKSGeBpOPsSbaFJ0GaBvI+75BJaGjT9u7uRFr3
	NDzy/sooN7ytMXVlXPwbP+QcI3Rx0KKJPMOuLAfihR+xjbVvkAYi+NZ8Iu5A4A4Q3w1EPzkez78WY
	Q363pfdT2vhCYp32W/B5DiX7JV4/E2QafpUvQVjfbb03NM8Fvdq+7UjpIlyF1wGJK8eApoXwTUPUl
	ftk3RauA==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tyCjh-000000001Xw-1cAz
	for netfilter-devel@vger.kernel.org;
	Fri, 28 Mar 2025 17:39:13 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] extensions: icmp: Support info-request/-reply type names
Date: Fri, 28 Mar 2025 17:39:08 +0100
Message-ID: <20250328163908.31678-1-phil@nwl.cc>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The intended side-effect here is that iptables-translate will accept
them too. In nftables, the names are supported since basically day 1.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libipt_icmp.txlate | 6 ++++++
 extensions/libxt_icmp.h       | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/extensions/libipt_icmp.txlate b/extensions/libipt_icmp.txlate
index e7208d8b874c7..4315875bb1eb7 100644
--- a/extensions/libipt_icmp.txlate
+++ b/extensions/libipt_icmp.txlate
@@ -9,3 +9,9 @@ nft 'add rule ip filter INPUT icmp type != destination-unreachable counter accep
 
 iptables-translate -t filter -A INPUT -m icmp --icmp-type any -j ACCEPT
 nft 'add rule ip filter INPUT ip protocol icmp counter accept'
+
+iptables-translate -t filter -A INPUT -m icmp --icmp-type info-request -j ACCEPT
+nft 'add rule ip filter INPUT icmp type info-request counter accept'
+
+iptables-translate -t filter -A INPUT -m icmp --icmp-type 16 -j ACCEPT
+nft 'add rule ip filter INPUT icmp type info-reply counter accept'
diff --git a/extensions/libxt_icmp.h b/extensions/libxt_icmp.h
index 7a45b4bd2ec6d..c44aa4b106557 100644
--- a/extensions/libxt_icmp.h
+++ b/extensions/libxt_icmp.h
@@ -52,6 +52,9 @@ static const struct xt_icmp_names {
 
 	{ "timestamp-reply", 14, 0, 0xFF },
 
+	{ "info-request", 15, 0, 0xFF },
+	{ "info-reply", 16, 0, 0xFF },
+
 	{ "address-mask-request", 17, 0, 0xFF },
 
 	{ "address-mask-reply", 18, 0, 0xFF }
-- 
2.48.1

