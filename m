Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3A191F98
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747258953; cv=none; b=WrVWHMwD3OyK0SzmKG/saoRHwKdAUWrULyH3RawuJcF2Z03Tlzvh/wgZxTVpC1K5FkY1c9k2VozR9fJ7HuwfEUfiaMkzXsulxCMCXmmA4Ot93URRgPCS3KZ52INwzOSxEKZHSXym+ohVcUyh5Y3ERVOr5KxmS1vtDhmej8J81k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747258953; c=relaxed/simple;
	bh=DGSH2T49Tk9DPvNLdd8tfgdsIKJBgKX7s+6JZRL3G/c=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=dlCUoCvHEglUChdnAOszV5ARwSY5dG5sVvZh3/bNN+Z2F3yRI6ogUY5CiMQs27XfrYRvb+q1VKSGPY2UrKufqGa2N/SQ4tB61RYF649WCB3TS0pYr42lYbXDivTPi7P0M1tbL89aCW1Dm/H01jZXLtVVdlNmjQOpftOK4jZtEyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MOlxJUt4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MOlxJUt4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MOlxJUt4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MOlxJUt4"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7629B60741; Wed, 14 May 2025 23:42:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258948;
	bh=IDJgxFonol/WS/zsxWtjQznn1JIENMsZMpVmolcnxi4=;
	h=From:To:Subject:Date:From;
	b=MOlxJUt4azhBw6H8hN5I3dRLMfRRSX/uSSb/YHTvAuIWjcTTdk9RHmZOAn5IWC9p1
	 kG4ekAC0j5jY4HT+ItjR7Xuogq3wRLs66RNfUCFr9EPy59O0IG3TVACvvc023L6xjP
	 rb2aF5tdFwDsIx+6c0mjw80cgu1XuJHFMwiCZ3DBPZaYm53RDOUfixA245/iAQ5KBK
	 cKmkYknave5/7rF1Q8+fi9/F4XrbAGhzXQdZ0hgN/DUU/eiLr0QgsD0sKLiCXliYIO
	 M3TCU9Q2SirTncqUFz0rSbCc0tDouMWzT2W4pD0O7AbRG5+eDTwfcTj6tLAB2UUZyJ
	 fMz6OfAfwdNqQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E24076073E
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 23:42:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747258948;
	bh=IDJgxFonol/WS/zsxWtjQznn1JIENMsZMpVmolcnxi4=;
	h=From:To:Subject:Date:From;
	b=MOlxJUt4azhBw6H8hN5I3dRLMfRRSX/uSSb/YHTvAuIWjcTTdk9RHmZOAn5IWC9p1
	 kG4ekAC0j5jY4HT+ItjR7Xuogq3wRLs66RNfUCFr9EPy59O0IG3TVACvvc023L6xjP
	 rb2aF5tdFwDsIx+6c0mjw80cgu1XuJHFMwiCZ3DBPZaYm53RDOUfixA245/iAQ5KBK
	 cKmkYknave5/7rF1Q8+fi9/F4XrbAGhzXQdZ0hgN/DUU/eiLr0QgsD0sKLiCXliYIO
	 M3TCU9Q2SirTncqUFz0rSbCc0tDouMWzT2W4pD0O7AbRG5+eDTwfcTj6tLAB2UUZyJ
	 fMz6OfAfwdNqQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 0/6] revisiting nf_tables ruleset validation
Date: Wed, 14 May 2025 23:42:10 +0200
Message-Id: <20250514214216.828862-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

The following patchset adds a new infrastructure to validate incremental
updates on rulesets.

This new validation approach is based on a the following observations:

- New rules always require validation since they could come with
  expressions that are not supported by the basechain type,
  eg. masquerade on the filter chain.
- New rules that jump/goto target chain result in the validation of
  such target chain and subsequent chains that are connected this
  target chain. Same applies to new elements that jump/goto target
  chain.

Such target chains that need validation are stored in a validation list.
Then, for each chain, the binding graph is used to perform the
validation from the commit/abort phase. Sets and chains provide a list
of bindings backwards (to reach the basechain) and forward (to validate
subsequent chains that are connected to the target chain.

The new binding object stores is composed of a tuple that describes the
origin set/chain and the target set/chain, valid binding combinations
are:

1) chain-to-chain, eg. rule performs jump/goto target chain
2) chain-to-set, eg. rule performs lookup to set (verdict map).
3) set-to-chain, eg. set element performs jump/goto target chain (verdict map)

Adding bindings for 1) and 2) is relatively easy, 3) requires a bit more
new code to deal with set deletion and aborting new set element, as well
as netlink/netns exit path, to release bindings.

This patchset uses a hashtable of bindings to look up for existing
bindings when adding new jump/goto chain from rules and set elements.

Patches #1 and #2 prepare for this infrastructure by disabling chain
validation from preparation phase when validation state is _SKIP as well
as avoiding a replay of the transaction on EINTR.

Patches #3 to #6 add the infrastructure to collect chains that need
valudation, add the new binding infrastructure and finally use it.

This is passing tests/shell with debugging instrumentation.

On my TODO list:

- If the hashtable of bindings is per-netns (instead of per table as in
  this series), then I think that limiting the maximum number of jump/goto
  chain should be relatively trivial by adding a counter of total existing
  bindings in this per-netns (as counterproposal to Shaun Brady's patch
  to limit the number of jumps per-netns).

- I did not explore yet the replacement of the (old) set binding logic
  (struct nft_set_binding) by this new infrastructure.

Comments welcome, thanks.

Pablo Neira Ayuso (6):
  netfilter: nf_tables: honor EINTR in ruleset validation from commit/abort path
  netfilter: nf_tables: honor validation state in preparation phase
  netfilter: nf_tables: add infrastructure for chain validation on updates
  netfilter: nf_tables: add new binding infrastructure
  netfilter: nf_tables: use new binding infrastructure
  netfilter: nf_tables: add support for validating incremental ruleset updates

 include/net/netfilter/nf_tables.h |  52 +-
 net/netfilter/nf_tables_api.c     | 800 ++++++++++++++++++++++++++++--
 net/netfilter/nft_immediate.c     |  25 +-
 3 files changed, 844 insertions(+), 33 deletions(-)

-- 
2.30.2

