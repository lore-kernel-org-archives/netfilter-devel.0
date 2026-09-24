Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFED94718C3
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 10:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246782; cv=none; b=WFwpcRqRBMXLjfky8JgSpcn+9qMOjeS/WpiME1Wnq3j4bTMh/Gb0fl30aP6Ofcv4mP9+DeXsIJQBM5s0c9OCkodNNScyp25tYssaeJpbb+jiZf9SXyAlMqJzyMQWb7Xka57RkljFexpEGZO10BGAX9AVxtmSbcJeIBx9FpIcJ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246782; c=relaxed/simple;
	bh=znOxCj8486MYrWJaS0SHAyr8akLo+IkGK/2igxvF0W0=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=n4xn7+M9u6f1BPBw02p4h4fl2KjnGk+rkvOVLKJZlUcDJB523Mw8WISkvf4Dc2OcCOqZXuzHQ+R8yOLzmFcTUnN/TJK+/L7V7IcmlV/6iPV8APU+yAxmbpgFczZtwvX+rQMDfpoxbFUBJO8UzTOy0kYzfpQiZjm2Gfvhzwi9HSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 948DE60460; Thu, 24 Sep 2026 12:46:17 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:46:16 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Subject: conntrack extension preallocation problems
Message-ID: <arT_eE_oV2ZEx-Zm@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

TL;DR: simple prellocation is not possible, it will result in at least
192 bytes ct->ext allocation for most use-cases which is hardly
desirable.

Following extensions exist in tree:

Extension                 |size| activation
---------------------------------------------
struct nf_conn_act_ct_ext |  8 | act_ct/ovs only, could be converted to template
struct nf_conn_acct	  | 32 | sysctl only
struct nf_conn_labels     | 16 | ruleset (sysctl-like)
struct nf_conn_seqadj     | 24 | dependency of helper and synproxy
struct nf_conn_synproxy   | 16 | template
struct nf_conn_timeout    |  8 | template OR nft_ct objref
struct nf_conn_tstamp     | 16 | sysctl
struct nf_conntrack_ecache| 32 | sysctl or template or nft_ct
struct nf_conn_nat	  |  8 | nft_masq/MASQUERADE/PPTP helper
struct nf_conn_help       | 56 | expectation / template / nft_ct objref
                                 (ct helper set X, ct expectation set)

Simple extensions are all those that get enabled based on sysctl
setting or template. For those init_conntrack() will know they are
going to be added anyway. This is true for:

struct nf_conn_acct	  | 32
struct nf_conn_labels     | 16
struct nf_conn_synproxy   | 16
struct nf_conn_tstamp     | 16
                            80 bytes

Almost-Trivial: could convert to template with a bit of refactoring, no
backwards compat issues / breakage that I can see:

struct nf_conn_act_ct_ext | 8

The remaining extensions are all problematic, I can't find any other
solution other than "speculative preallocation if used in ruleset" (can
be pernet):

Extension                 |size| problematic case
-----------------------------------------------------------------------
struct nf_conn_seqadj     | 24 | depends on helper resp. synproxy
struct nf_conn_timeout    |  8 | nft_ct objref
struct nf_conntrack_ecache| 32 | nft_ct expr
struct nf_conn_nat	  |  8 | masq/-j MASQUERADE or PPTP helper
struct nf_conn_help       | 56 | nft_ct objref (ct helper set X) nft_ct expr (ct expectation set)

128 bytes total, this means kmalloc-192 (due to ext header size).

NAT: single rule (-j MASQUERADE or rule add ... masq) forces this
extension to on for all.
NAT: PPTP helper existence also needs this as dependency

ecache: single "ct event set .." is enough to force prealloc for all.

help: same, single "ct expectation set", "ct helper set " is enough.
timeout: same, via "ct timeout set ...".
seqadj: required when "help" extension is used.

I cannot come up with a (backwards compatible) solution for these
so far (aside from preallocating them all on first rule add).

Even if we would decide to break existing setups, nft_ct is hard to solve,
we would have to make this "-j CT" alike, where all required extensions
are passed in one go to a single objref instance.

"ct helper set" is definitely the worst offender:
While most conntracks do not need the helper extension in normal
deployments, we would add the extra baggage for every conntrack.

I think we have to consider going back to old times, i.e. rcu protected
ext storage, plus additional locking to cope with the "cloned unconfirmed
conntracks" offenders, at least for sake of these remaining 5 extensions,
else we end up allocating large ct->ext whenever a single conntrack
helper is used...

Unless anyone has a better idea, I will work on this, i.e.:

- prealloc for trivial cases (sysctl and/or attached template)
- prealloc for "let's assume most will need it" (masquerade)
- realloc for all others: helper/seqadj and the existing nft_ct
  use cases.

Because of "clone problem" realloc will become more expensive:
lock + rcu + dealing with list_head move inside helper area.
