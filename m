Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB87199233
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2024 12:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721132894; cv=none; b=Y+lGflYH86VDqu/VFxllqtwven8QsYTYUR2mzh7pKZSNO+8O/XXAmDQxZufqQCC6dQ5ruP7C1nP06J5yeAT4xNSVnNprH+vgrdwrAdqajcLwXMYDJ7Agy/qvTxvSV2xoSozRjfOkGkiVpPG4c/UbE1+a3WeVwa1WVS/FfSeLBnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721132894; c=relaxed/simple;
	bh=o21GVZJNW84A5GMBFIbfCSrEzTIt2TryUybmiex1pIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N39ncnv/29JO1NGM3zNYdcXG19LexjGhw3i0L3USdvpOQkBjKHY4MtZPrDz6BNgBvrTPCplHFaL5TrR+kDhkbdcG5bzdbSrEb12aUF1wSTSwh4Tug9i23kEZnl/jac4Ram8lIbyHZY8fw50d4qI3r1egFhFBb8D7RW6O+qZX6j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=PmhKU1hY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="PmhKU1hY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1dLEXydO5CuNrfEL7lgghAkbu8K2fNhpgqpaiTQZXe8=; b=PmhKU1hYeyr6aeb67zlrEQ1bQX
	kuSN4TjGCZ5QiqhD/zbhUmaiVE5lbH1LojWyXdGYuaVeojJXvxlxKcgBrvs+PvQFTPoVvUE0V9Jcw
	9lgWWpoEC0s12p0hw8QeN8Y+8QDTntG/cUq8UdnGZtxI3uCH56ChO680luBH0hyb+zsx/+SG+awfd
	o5iKfjBSKPURWzlpCOau7FqsjRGd/DbwW2suG9X/PPEs5Qu8fmpvo/5ApE0QMFKdSAn1Dw/cusaUC
	wfwXV6XRix3B8C9gyV59z4xR00rPJD//AZovAvNZ+ZJ3a8+OnUtIy4ihHg+NVdNNEoSNJwByWY1lo
	XOyEXyoA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sThHt-000000007su-0IjM;
	Tue, 16 Jul 2024 14:28:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 2/8] xtables-monitor: Flush stdout after all lines of output
Date: Tue, 16 Jul 2024 14:27:59 +0200
Message-ID: <20240716122805.22331-3-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240716122805.22331-1-phil@nwl.cc>
References: <20240716122805.22331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Writing an xtables-monitor testsuite is pretty much impossible without
this due to unreliable output flushing. Just move the fflush() call from
trace_cb() to its caller so monitor events benefit from it as well.

Fixes: 07af4da52ab30 ("xtables-monitor: fix rule printing")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-monitor.c b/iptables/xtables-monitor.c
index cf92355f76f8a..90d1cc5e37f31 100644
--- a/iptables/xtables-monitor.c
+++ b/iptables/xtables-monitor.c
@@ -544,7 +544,6 @@ static int trace_cb(const struct nlmsghdr *nlh, struct cb_arg *arg)
 err_free:
 	nftnl_trace_free(nlt);
 err:
-	fflush(stdout);
 	return MNL_CB_OK;
 }
 
@@ -576,6 +575,7 @@ static int monitor_cb(const struct nlmsghdr *nlh, void *data)
 		break;
 	}
 
+	fflush(stdout);
 	return ret;
 }
 
-- 
2.43.0

