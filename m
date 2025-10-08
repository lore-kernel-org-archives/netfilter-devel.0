Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827C62F0C6D
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 07:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759908512; cv=none; b=cQBRNBt9VVspiErbqWoXs6YPmdEbM8LVRTSoKGcTLzVc8nLUlhr7xJJ/9WQiJpNoPjoBEFyM+p3ZPzRiS8Nff2mLorZ7vMvTI2cX8jQ6H6yMGSh9U7xy6VkTaXp7tR4LB/c1Qu1H5mmR10H9poPSqP6FWhMRn8Kh0+oCOkHqMSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759908512; c=relaxed/simple;
	bh=FTV2uNOh1UACnMzWevDMqKhuNZn7R5uS9dAZdXg/2zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9uaMfW7KzpPS3hvojjeYIgJvlwz4uIHhunAuaExXXV4rxekouJ/qhJaORtr59VG9INEDu4iX/ebrdU6wA+dWknc72wLxzB26BijlKz+/dxBPHEQFtgoJLxa0KJW3+0isiWSne+MtTth4oboHPTZsdmzUDPyJ1GrgCTqdVki0c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 53E8C60614; Wed,  8 Oct 2025 09:28:26 +0200 (CEST)
Date: Wed, 8 Oct 2025 09:28:26 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Nikolaos Gkarlis <nickgarlis@gmail.com>,
	netfilter-devel@vger.kernel.org, donald.hunter@gmail.com
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Message-ID: <aOYSmp_RQcnfXGDw@strlen.de>
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <aOV47lZj6Quc3P0o@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOV47lZj6Quc3P0o@calendula>

[ Cc Donald Hunter ]

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Oct 01, 2025 at 11:15:03PM +0200, Nikolaos Gkarlis wrote:
> > Before ACKs were introduced for batch begin and batch end messages,
> > userspace expected to receive the same number of ACKs as it sent,
> > unless a fatal error occurred.
> 
> Regarding bf2ac490d28c, I don't understand why one needs an ack for
> _BEGIN message. Maybe, an ack for END message might make sense when
> BATCH_DONE is reached so you get a confirmation that the batch has
> been fully processed, however...

... which (BATCH_DONE reached) would be made moot by this proposed
patch, as we would ACK it even if its not reached anymore.

> I suspect the author of bf2ac490d28c is making wrong assumptions on
> the number of acknowledgements that are going to be received by
> userspace.
> 
> Let's just forget about this bf2ac490d28c for a moment, a quick summary:
> 
> #1 If you don't set NLM_F_ACK in your netlink messages in the batch
>    (this is what netfilter's userspace does): then errors result in
>    acknowledgement. But ENOBUFS is still possible: this means your batch
>    has resulted in too many acknowledment messages (errors) filling up
>    the userspace netlink socket buffer.
> #2 If you set NLM_F_ACK in your netlink messages in the batch:
>    You get one acknowledgement for each message in the batch, with a
>    sufficiently large batch, this may overrun the userspace socket
>    buffer (ENOBUFS), then maybe the kernel was successful to fully
>    process the transaction but some of those acks get lost.

Right, 1:1 relationship between messages and ACKs is only there for
theoretical infinite receive buffer which makes this feature rather limited
for batched case.

> In this particular case, where batching several netlink messages in
> one single send(), userspace will not process the acknowledments
> messages in the userspace socket buffer until the batch is complete.

OK, from what I gather you'd like for
"netfilter: nfnetlink: always ACK batch end if requested"
to not be applied.

I would still like to apply the nfnetlink selftest however (even
if it has to be trimmed/modified), because it does catch the issue
fixed by Fernando
 [ 09efbac953f6 ("netfilter: nfnetlink: reset nlh pointer during batch replay") ]:

ok 1 nfnetlink_batch.simple_batch
#  RUN           nfnetlink_batch.module_load ...
# nfnetlink.c:239:module_load:[seq=1759907514] ACK
# nfnetlink.c:239:module_load:[seq=1759907512] ACK
# nfnetlink.c:244:module_load:Out of order ack: seq 1759907512 after 1759907514
# nfnetlink.c:239:module_load:[seq=1759907513] ACK
# nfnetlink.c:239:module_load:[seq=1759907514] ACK
# nfnetlink.c:239:module_load:[seq=1759907515] ACK
# nfnetlink.c:254:module_load:Expected 0 (0) == out_of_order (1)
# module_load: Test terminated by assertion
#          FAIL  nfnetlink_batch.module_load

If the decision is that there should NOT be an ACK for the BATCH_END if
there was an error, then the test only needs minor adjustment:

-       // Expect 5 acks: batch_begin, table, invalid_table(error), chain, batch_end
-       validate_res(self->nl, seq - 5, 5, _metadata);
+       // Expect 4 acks: batch_begin, table, invalid_table(error), chain
+       validate_res(self->nl, seq - 4, 4, _metadata);

So, what is the 'more useful' behaviour?  Choices are all equally bad:

1. If we want to always include it, it might not be there due to
   -ENOBUFS, which will always happen if the batch was large (triggers
   too many acks).
2. If we only include it on success, it might not be there for the
   same reason, so absence doesn't imply failure.

HOWEVER, if the batch was small enough then 2) gives slightly more
useable feedback in the sense that the entire batch was processed.

So I am leaning towards not applying the nfnetlink patch but applying
the (adjusted) test case.

Other takes?
