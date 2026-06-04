Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A013C3EA66
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780600667; cv=none; b=oH3HUq+3TgJHG0hxYcb8NNJlmV6XQwUpjnjCChrwSXZoSgQy4z0Jd+XWmjaI5YoMgrAUZp0tDYUC5WeBPi+RAK6IkpclZcnCHIB/m5J/0aBOT9YnGfhoOJQu/mA1s+v82Qb89kKCyDT53z2O9GqDX42bTadbB4euda28boDfTHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780600667; c=relaxed/simple;
	bh=pugH9HMpPNbkawsKgIOGZRStLhijJaUyGx4fUYNRon4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=QN7B1VeXKNuaLOPL5TruW8oxfzLE4cuZsr20As+tFBoU/pUvb2lHvK94xXxs+VBTvrfeMp5VtT8TmMX2D62yp6x/gM88WVTM7PbpD0JFhYq19nfO0YY5m05km03rt1qwFPsA0TmUgD3IadSRdebTYW4x5/4LJTpCUGE9+ZufKjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5BABA60551; Thu, 04 Jun 2026 21:17:43 +0200 (CEST)
Date: Thu, 4 Jun 2026 21:17:42 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Possible device resouce leak in nf_offload infra
Message-ID: <aiHPPts-fb3oG9Sx@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo

net/netfilter/nf_dup_netdev.c :

 70 int nft_fwd_dup_netdev_offload(struct nft_offload_ctx *ctx,
 71                                struct nft_flow_rule *flow,
 72                                enum flow_action_id id, int oif)
 73 {
 74         struct flow_action_entry *entry;
 75         struct net_device *dev;
 76
 77         /* nft_flow_rule_destroy() releases the reference on this device. */

This comment is no longer true.

 78         dev = dev_get_by_index(ctx->net, oif);
 79         if (!dev)
 80                 return -EOPNOTSUPP;
 81
 82         entry = nft_flow_action_entry_next(ctx, flow);
 83         if (!entry)
 84                 return -E2BIG;

... because nft_flow_rule_destroy() cannot drop the device
ref when we return here, as dev is not assigned to entry
yet (and we got no entry).

AFAICS its safe to just swap this and have
lines 77/78 moved after line 82.

nft_fwd_dup_netdev_offload() could also use some debug
check to make sure this doesn't get called for actions
other than FLOW_ACTION_REDIRECT/FLOW_ACTION_MIRRED as
those are the only ones where nft_flow_rule_destroy() takes
action.

(or accessors and comments that say that accesses to the
 hidden union are illegal).

Is the analysis correct?  I can make a patch.
