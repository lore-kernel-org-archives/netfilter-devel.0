Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCD2701B6
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Apr 2025 12:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745410786; cv=none; b=q2RqeWsGyJwfMov34Wb2mB2HHCVVFPYtUWlIwpY3iWXGa236H3l5M26J9asQrnktU5TMfRMfU393OsK3O+Wt3p4Ake73VnzCK5l6Zzr26jXM5KFXr4p6bd0C2+d7Wkgb+iUXLOTznoEF/FlhqryvPHtk8KFPYN36YbFulcxG17w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745410786; c=relaxed/simple;
	bh=w5SfRvVkqFoV0hCLwlf9SgkIGi/+3fYF7t7FaoHj80c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ldsvsc1N9oHDbgb3+cb9DC9uGkxQHkBrqQUANwJGFyfj84JaNVaIzwOTcHaUJ0ZsqD0BzjhyN+B243lMA8GW/Vn3o+OdnBID0GAbyTHL8SSR/e0LzHIIWDBkJlO9gGFPQ7tq8iDw+eAlq/QuUJbrburAEkTb4uPTqfTLRZBvmMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=I37lHgYp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="I37lHgYp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vvZqXcrXAjjZ3eg5Xsi/GpR29t5v9X7jkJUdAff86b0=; b=I37lHgYpHYElgdWEG+X4V7AxNs
	fjZE6QxA+Yx99JWC/ginyaEgIAPV5dvoCJOGiQLYgYX2f0Dau/jz0JPG7D8oiTAJfeS07kiH5DON/
	euJLWb8sJBzJ8PmLS3KMeg6gTyNWH6/EWruzbMnFG4f3gph2O8dvMo6mb41XqQhz4gaQJjlMC813R
	EyHwLo/K4htSXxhiifkJvu3NURncmphQ4Y19lW+W+AdhOVPPFsBZPkhPq48L+G9hIm+SVNKlMoER9
	+vvuvf4SO/VzjCqvZ0lIaTM8EPU+4WHknDfjXR5HFGWUdPmy/Ojxd93qAf8bqtX7OzhdiIlWo/Ooc
	BwazNu0w==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1u7Z4h-000000004nG-0QEW;
	Wed, 23 Apr 2025 14:19:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Adam Nielsen <a.nielsen@shikadi.net>
Subject: [iptables PATCH] xshared: Accept an option if any given command allows it
Date: Wed, 23 Apr 2025 14:19:29 +0200
Message-ID: <20250423121929.31250-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed commit made option checking overly strict: Some commands may be
commbined (foremost --list and --zero), reject a given option only if it
is not allowed by any of the given commands.

Reported-by: Adam Nielsen <a.nielsen@shikadi.net>
Fixes: 9c09d28102bb4 ("xshared: Simplify generic_opt_check()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index cdfd11ab2f279..fc61e0fd832bd 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -980,7 +980,7 @@ static void generic_opt_check(struct xt_cmd_parse_ops *ops,
 	 */
 	for (i = 0, optval = 1; i < NUMBER_OF_OPT; optval = (1 << ++i)) {
 		if ((options & optval) &&
-		    (options_v_commands[i] & command) != command)
+		    !(options_v_commands[i] & command))
 			xtables_error(PARAMETER_PROBLEM,
 				      "Illegal option `%s' with this command",
 				      ops->option_name(optval));
-- 
2.49.0

