Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAC91A0BCF
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Oct 2024 17:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728494870; cv=none; b=fh3DXJUZsWNmHzKDjl6Lf8x4pdM0pU2OEbEaC3ol5Z4tWehBNaQNc1wIypbR8B/K2T6MGOLFcG80tBxgt048JM8abgT1rHEug6mjSjGjHDW7xphScAzNZrO3yRHAG4D+L5HB8SuVgXupDwBsdaDa6OAg/hNQIJ+uT5sijKaIBEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728494870; c=relaxed/simple;
	bh=oUphxd9K9rgWjCEd9U3IF3GUW28JGIWoxp3yHLHQHI0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ROMwu1a6y+djf0+WDnOoKQdQg3ENgrnT61go+QwPv4FNiBoRtcSYqAdd6PiWkDGK8LJP+IsARguBifWJMPjHSq01xO+8PiGnevh+Yzu1EdzrqpZkbXzyT8Ec5Qg9vG9KyQEzftp7aV+4TIDV4S2lyNZlyDsXk0jJszPUVrXrLbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aKLDGZR/; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aKLDGZR/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CvrzWvzQRHvyHlMTkq2uKofGkO503kqJADpSQVLgZLg=; b=aKLDGZR/LBvV8NntV0roreBmgV
	WnUUmc7hkv1XW+z3XdGejs94wYnIUXUtq8ySkwW5gjrqXOKvsLWapu81N6jVM12/MSEq8fSD16wUv
	mMgw9rQLsYoHLITzKXBLGv1BMCzjL/T7L4udyDd+3guA7lc3erSnxuzs3InJLyIDel9YG8teO738k
	0h1E2tTEtIkcreQZhYDDt7yNI6oHJQmaOTg1dI4v6c3c1mIVE4Z0UV5hCtofbMqqV5MdDnPdwENaf
	ZiA4EEos5X3ejD4MZUzxrnOkhK5Cu2ugiwnnBsY/jBkiEYflXSvxgQoMKoRnMVZITv3brs0gxmHGR
	S5nC9QbA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1syaTR-000000007Cq-1Uw0
	for netfilter-devel@vger.kernel.org;
	Wed, 09 Oct 2024 19:27:45 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] ebtables: Fix for -S with rule number
Date: Wed,  9 Oct 2024 19:27:38 +0200
Message-ID: <20241009172740.2369-1-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For NFT_COMPAT_RULE_SAVE, one has to store the rule number, not its
index in nft_cmd object.

Fixes: 58d364c7120b5 ("ebtables: Use do_parse() from xshared")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index ff364ec76191f..08c9cbf0ead72 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -623,7 +623,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 					 cs.options&OPT_LIST_C);
 		else if (p.command & CMD_LIST_RULES)
 			ret = nft_cmd_rule_list_save(h, p.chain, p.table,
-						     p.rulenum - 1,
+						     p.rulenum,
 						     cs.options & OPT_VERBOSE);
 		if (ret && (p.command & CMD_ZERO))
 			ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
-- 
2.43.0

