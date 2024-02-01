Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782E15CDFA
	for <netfilter-devel@vger.kernel.org>; Thu,  1 Feb 2024 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706795464; cv=none; b=sNk/WhPHkH1ICPZc18TK4V3XLrkwI9+q7BCHh900lpVRL2eZkY5z99ToIk/ajy4RcCyGRVFEKC1fNrc2B4EQW6HfxFwBzLKvc6b/G3B31SHvx5KoOKK+CLn3ggD3P4PtHh7702HHjFVe55sOQ5JX1CSkC/oU8SUvIGQV+zoKt3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706795464; c=relaxed/simple;
	bh=1L9Nn0TYL3zwSLJjPnzOWYNXqhFiw2amcae45rKvJrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxawf9HGss1cM8q5tEqL/YjVxNOfAHLUKfKfqTWxzeKtbYrX0d7Pghfdq3aIRO73K39OLhQi1hVwwXu5ShlDO5DMsgvNDqKgbGKADW8tJSDv9cvQWJdu4F4byS8IfMt5ENg8nCVyPiXd48otiHJqMCWjIHbeNd2tgNrKgOaZH0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fnInPuoC; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fnInPuoC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TtmnsUX176o13aGnLC8SbspPckhHCcrs37jizNx/MFw=; b=fnInPuoC3kNyaRKGE1x5aQk52m
	i1Ox61VJnc/8wNJGugVDj35sRyzifg/g2gPsP4DIHOq0+S+Th0TuglIuicDaZxJw6n+n2P5wqapuX
	qNbw2oIcRkBKLrGL2IFv9ugOEjwyWoR4QE4fTDctioXJQCzGnxDpWEVILc93sgIq86/LUD/+7Bc4s
	mWA/YQx+QJDKNilksRIQiKmm5qwf+RJlRKLpkf4aLdp2dBEn92SVQW8zzME/rHqSN5u2b3m4R7D3d
	mC1dTBW2LzdU/W1a1LjBYMYVkYhcwXGvH3Fv0MDFmWsVsMNk/w7f1YAJ/VmeRCfoOq6CrHBF4BbSl
	3NPBSMOw==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVXT2-000000001MG-3BIt;
	Thu, 01 Feb 2024 14:51:00 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 7/7] ebtables: Fix for memleak with change counters command
Date: Thu,  1 Feb 2024 14:50:57 +0100
Message-ID: <20240201135057.24828-8-phil@nwl.cc>
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

Just like with check command, change counters command creates a
temporary rule from rulespec on command line for a search by spec in
rule cache. It is not used anymore afterwards, so nft_cmd_free() should
free it.

Fixes: f340b7b6816be ("ebtables: Implement --change-counters command")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 8372d171b00c4..b38da9bdc1c0b 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -65,6 +65,7 @@ void nft_cmd_free(struct nft_cmd *cmd)
 	switch (cmd->command) {
 	case NFT_COMPAT_RULE_CHECK:
 	case NFT_COMPAT_RULE_DELETE:
+	case NFT_COMPAT_RULE_CHANGE_COUNTERS:
 		if (cmd->obj.rule)
 			nftnl_rule_free(cmd->obj.rule);
 		break;
-- 
2.43.0

