Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90944366074;
	Thu, 16 Apr 2026 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776374204; cv=none; b=LNtJ2w3r935qkxIzlkkzItUG3VADYpDKklQhIECs22L2f9WkJM7uD1+ErbZEd5ZWmJWfFkDtXDgFuJWDLzrDv0OCc94oguPmltPFL+zoIUAEKOTrMvhuc+TqsVJs/3Bzho216TTPmKliber8qvuaoP28b957R85ST/JCqASTU30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776374204; c=relaxed/simple;
	bh=6miqvBmfpw2Wg1FrOkiiGof9qQ8TWV2AWeQ/FSnQICM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mRlppNjVZX18QYjm9ScuSE8OSxU0Z4yCf7T5H2ZhE4b8tHNCU1v9F95inYYhPAXgPWnJxfBUdgrY9gL6VJmklqnvjimOJY9DiAr9CQz3HRgF7LR9ZV4RNCs/3OFYSgjquhhYcm4xmj6XDHDL1Hn7E9WLDJZBl/spAkCAwYBiuUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A5BE360923; Thu, 16 Apr 2026 23:16:39 +0200 (CEST)
Date: Thu, 16 Apr 2026 23:16:39 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net,v2 00/11] Netfilter/IPVS fixes for net
Message-ID: <aeFRt__YQqJ84ZaN@strlen.de>
References: <20260416131453.308611-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260416131453.308611-1-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> v2: Keep back patches that have lengthy feedback by AI, they might
>     need more work.

sashiko findings response:
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 01/11] netfilter: arp_tables: fix IEEE1394 ARP payload parsing in arp_packet_match()

yes, arpt_mangle.c has same bug pattern, will follow up.

  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 02/11] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 03/11] netfilter: nft_osf: restrict it to ipv4
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 04/11] netfilter: nfnetlink_osf: fix null-ptr-deref in nf_osf_ttl

yes, osf has more issues, I asked Fernando to investigate. Brief glance
the reports are accurate but these are NOT new issues added by these 3
fixes.

 ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 07/11] netfilter: nat: use kfree_rcu to release ops

shashiko wants /kfree/kfree_rcu/ in error unwind path and I think we
should just do it.  Its an error path so it makes no practical
difference.  Also, with upcoming -next patch to dump the nat
hooks too it would be required.

  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 11/11] netfilter: nf_tables: join hook list via splice_list_rcu() in commit phase

report is accurate BUT this issue is already known and not a regression
added here.

The fix for this bug was in v1 PR but it needs more work and will come
in a followup batch.

If you don't want to take this v2 because of above issues, please
consider at least applying

  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 08/11] ipvs: fix MTU check for GSO packets in tunnel mode
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 09/11] netfilter: nf_tables: use list_del_rcu for netlink hooks
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 10/11] rculist: add list_splice_rcu() for private lists
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 05/11] netfilter: conntrack: remove sprintf usage
  ↳ [2026-04-16] Pablo Neira Ayuso <pablo@netfilter.org>: [PATCH net 06/11] netfilter: xtables: restrict several matches to inet family

manually.  nf:main always tracks net:main, applying them manually
doesn't cause issues.

I hope we get shashiko to also digest netfilter-devel;
otherwise this situation will persist forever or can
dissolve nf-devel and spam netdev@ directly :-|
