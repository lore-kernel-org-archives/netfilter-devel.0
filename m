From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: export rule-set generation
 ID
Date: Tue, 9 Sep 2014 19:20:16 +0100
Message-ID: <20140909182014.GA25039@acer.localdomain>
References: <1410282105-12880-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47275 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaIISUb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:20:31 -0400
Content-Disposition: inline
In-Reply-To: <1410282105-12880-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 09, 2014 at 07:01:45PM +0200, Pablo Neira Ayuso wrote:
> This patch adds the NFT_MSG_GENID command to nf_tables that exposes
> the 16-bits ruleset generation ID. This ID is incremented in every
> commit. The generation ID is also exposed to userspace through the
> nfnetlink res_id header field when dumping object lists.
> 
> This generation ID allows a userspace client to detect that an update
> has happened between two consecutive object list dumps, so it can
> retry from scratch.
> 
> This is complementary to the NLM_F_DUMP_INTR approach, which allows
> us to detect an interference in the middle one single list dumping.
> There is no way to explicitly check that an interference has occurred
> between two list dumps from the kernel, since it doesn't know how
> many lists the userspace client is actually going to dump.

Well, the obvious question is, are we sure that 16 bit is enough?
I mean, sure, it most likely is for almost any usecase, but if you
want to write a reliable piece of software using it, can you be
sure and how could you handle the case that it overflows?

If we for instance consider an optimization algorithm that wants to
perform an update and has to dump all objects, perform its change,
reoptimize the resulting ruleset and then insert it. This might take
some considerable amount of time. I guess its at least possible that
2^16 updates could be performed in the same period.
