Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F07331EC2;
	Mon, 19 Oct 2026 01:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792372892; cv=none; b=lMZcbigfWf2772hkfhQdWNtqMgwSIq2F2wlRkW7gEOXiy38D/EFa+b9DVDa7CrR0qamkiyPfYCLmOT2iix3rpLw2V5NhLGBo48kLJkPwcbiAENs0rmQvKrVnobOURX1UZAIR1Rl/QoVgADvtOgpTmtskpinKTpBKVbMSBor+/rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792372892; c=relaxed/simple;
	bh=Bx8upF6au11sO8EHH51XNaoELRgd+b6/GvlCGOXyngo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XAbYxfQ5+xOHzPV4VMd/V2Vd/kFw7Govw+380rdMqBQlF44m0nAgAYSPwzn+xI8vgoL/uW25/ATWkTLBkre1MesLk+NzIy6OLHOx5FWbcnsOa8cX1ZkjPzwK5dCoZIxknwCkFFFN4qjBcJGJrghZKE1BIz5kanAesx9zH6akNlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAqGANY5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAqGANY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547F81F000C6;
	Mon, 19 Oct 2026 01:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792372885;
	bh=/LSGs6M3uPrXkM/bJqRfMZmWfu0ucMnHmAXGUpocZZY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gAqGANY5bk/C2sHWboO1z0WYMdFV0UcH/gVAOrkjOOwRP90EjZuBY2fJ+m4giPWyX
	 94g5aQIT3T7eyTEjbO4B+g6ZjCTtlc8YrxIAGfotAIfey9IWfya1YabEUghzX5vRzB
	 /xJOjPqSb0zhWZnKse5DBtVh1Qp3y0Gj7dG3DgCLXBIVgmHDFjGjEP5bkWPj5T83hK
	 u+QI+Q69l/OmahEznOhfcEw1hi2pYjUzlYeWQUBaff10ryI7I/CqTyRf6nrQ4bOfBw
	 wkmZ75DZH4ARQMkQaNi8451K7j9EDBcXtIJx+4fNqN+uWPBZ4YjleFlZ+BtJTumqs/
	 7IYDdIyUyD7Hw==
Subject: Re: [PATCH net-next 07/15] netfilter: nf_tables: switch chain_types
 array to rcu
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Mon, 19 Oct 2026 01:21:24 +0000
Message-ID: <179237288492.3135.4070411587398264435@kernel.org>
In-Reply-To: <20261018005638.1776148-8-pablo@netfilter.org>
References: <20261018005638.1776148-8-pablo@netfilter.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] Commit "netfilter: nf_tables: switch chain_types array to rcu"
  fixes a module-memory use-after-free but has no Fixes: tag and no Cc:…

--

netfilter: nf_tables: switch chain_types array to rcu

This converts the global chain_type array in nf_tables_api.c to RCU and
takes the module reference on the chain type owner inside the RCU read
section. That closes a window where a transaction could dereference an
nft_chain_type freed by a concurrent rmmod of nft_chain_nat, and
nft_chain_nat_exit() now calls synchronize_rcu() after unregistering.

> Reported-by: Vega <vega@nebusec.ai>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

[Severity: Low]
Should this patch carry a Fixes: tag?

Before this patch, two lookups happened before try_module_get(type->owner),
with only the pernet commit_mutex held:

  - __nf_tables_chain_type_lookup() dereferenced t->name
  - nft_chain_parse_hook() read type->hook_mask and type->type

At the same time, nft_unregister_chain_type() cleared the slot under
nfnl_lock(NFNL_SUBSYS_NFTABLES) only.

The window seems to have been opened by commit f102d66b335a ("netfilter:
nf_tables: use dedicated mutex to guard transactions"). That commit moved
nfnl_unlock() ahead of the batch message loop in nfnetlink_rcv_batch().
It kept the nfnl mutex for chain type (un)registration.

Would this trailer be appropriate?

Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")

Without it, stable trees that carry f102d66b335a may not pick up this fix.
Other patches in the same series do have Fixes: tags, for example
"netfilter: conntrack: fix unlikely UaF in gc worker" (also an LLM finding
from the same reporter) and "netfilter: nft_compat: restrict raw table
targets/matches".

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261018005638.1776148-2-pablo%40netfilter.org
