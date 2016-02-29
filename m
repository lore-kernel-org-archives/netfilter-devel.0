From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2] netfilter: meta: add PRANDOM support
Date: Mon, 29 Feb 2016 13:57:59 +0100
Message-ID: <20160229125759.GA16173@salvia>
References: <1455639848-2454-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58775 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbcB2M6F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:58:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C53474B9ED
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:58:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B0CECDA8FA
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:58:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A147CDA8FB
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:58:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1455639848-2454-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 16, 2016 at 05:24:08PM +0100, Florian Westphal wrote:
> Can be used to randomly match packets e.g. for statistic traffic sampling.
> 
> See commit 3ad0040573b0c00f8848
> ("bpf: split state from prandom_u32() and consolidate {c, e}BPF prngs")
> for more info why this doesn't use prandom_u32 directly.
> 
> Unlike bpf nft_meta can be built as a module, so add an EXPORT_SYMBOL
> for prandom_seed_full_state too.

Applied, thanks for your patience Florian.

