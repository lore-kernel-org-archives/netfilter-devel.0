Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5EE16D33D
	for <netfilter-devel@vger.kernel.org>; Wed, 31 Jul 2024 22:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722464832; cv=none; b=P/54fDVMp/WrGnHl3uVtouVcBnSw9x+Uws2rDeopzHVL1wfdYt9aMGSSqLsbRxW/UQDbO4ZMc6ReA2d8AFuZZkx/QOXP8MSc4PXZysMVvGq+DONUMwufYs+lHeB+oWgO1u2jG0VmLbsJpaTKACCtSAU3zWRx1ejFyZhJojcRlL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722464832; c=relaxed/simple;
	bh=LwCrtzR4aTJnl8GdN8giubDEnjxIUeCTAYL/OoPJD/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvdfSMPtXrQdJueFdKwqO4UtXLNw68XKtck96+zDPN54+8Frzw/vfZrg6gpLGlTJ7cynJGYRFPUXYk3UJbbahtjqPZjI+TWcAvoxzneQiu6SYJbdbYuQXI61H0SOvI+ff9DxIgh1CAXB3ivwlf3O3YLKADxCxrflmrSRjsyLVWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=qqHZ9E0T; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="qqHZ9E0T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=aJz19JxKWRis7mgTkcmCtU9RI1nXoc7Geak4FB0/+Gk=; b=qqHZ9E0TmZu7a+Ne1Wx8kTUi/7
	SBqn1NQgK2ua4mRHfIhb/jJxsOrynFZT/ZW8vE20qxHqANRs1BSOy3hNr68issJC/T7ePccx9AEs6
	1bCvuzDQ8fAsPUHO+igS+qS8LXUEGZ7KBfLXEUyMfli14oIEfcmJsxaMJjeaaUuUU9d7CUUpm4LCS
	nU4r+W4hF1ND+MCl/KnuW9e96IKPUNwcbkxIKT/F+NuJb6aVDtAnC7tjuz5rhCPj2hHZrQp31S8HB
	4qhKuvGZ005NCKcV6o7pQrDI3JJSAHnP1mLLWSVum2xIlkmoQW5XjwQJhaWdRHxi5OYQrM3/eh9a8
	sOT7yG/g==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sZHmn-000000003iV-0Ca5;
	Thu, 01 Aug 2024 00:27:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 1/8] ebtables: Zero freed pointers in ebt_cs_clean()
Date: Thu,  1 Aug 2024 00:26:56 +0200
Message-ID: <20240731222703.22741-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240731222703.22741-1-phil@nwl.cc>
References: <20240731222703.22741-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trying to recycle an iptables_command_state object by calling first
clear_cs then init_cs callbacks causes invalid data accesses with
ebtables otherwise.

Fixes: fe97f60e5d2a9 ("ebtables-compat: add watchers support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 0f85e21861cde..f75a13fbf1120 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -46,6 +46,7 @@ void ebt_cs_clean(struct iptables_command_state *cs)
 		free(m);
 		m = nm;
 	}
+	cs->match_list = NULL;
 
 	if (cs->target) {
 		free(cs->target->t);
-- 
2.43.0

