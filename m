Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C09221D87
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759923227; cv=none; b=mhEbw7JXl5s3SOEwW9Oancq49U3oZSBwUQ9Ie8YOdW8ALRs4q9vZzUafOCFVG0KA7ToJL7pWXjOFtqFCaLVWUErL5RdJa957AX8IW6rk/Pc7/HoBwl44yymeAdU5XS8DMq2cant1QW5c51zkKDcRjVyRFpT8NjuNSjX7LSQXKSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759923227; c=relaxed/simple;
	bh=2Z9/zfu3EDfdGKjkpJusFhZdSwVpEj2Sa3ULIp4I7f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9T2pye2wniEgX/325W4TLUgREY/a1MzNkpG8FFXPJRH9TtGTosaU1Slmq5M+pH3HoJrrTzf12NAayo9PIVjb0WVdsMx9YBfi2EYkDDop5pFA45qDbHxhstXTLcQEuv2tuumA7juJ1OhHBLpjHBvjfl7UZin4/m09fw1pqfXFoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H/lXfhMx; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SEBCLDVS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H/lXfhMx";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SEBCLDVS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 116A56026B; Wed,  8 Oct 2025 13:33:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759923223;
	bh=WNwFxbIdGXJW1lMZclmO/btPEqzB7EMDDruafq3UcnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H/lXfhMxUAT9pzEM1q3KFjr3itjIAB0oSGgji6jvb4+f1VUZvX/ytH61DidTgxvZB
	 ljivUDnI6SYqo3xxifUt76vlYiWjDt3mJ06a4xTrY/4bn9R/MBD12PNFapjGM0/40z
	 FnkvYk9tHMgiJOmhY4601Gd2zG1IjxxetkQEFu7lVlAibeaH3gymreqjYUGzrvn5n3
	 C9Md1K+ibR6h3vwH13iim+zDgl40mXV+0pw62WYVNYalgeeptWt4hvwF0bALxydPg9
	 ltJE9h/jXk3UPWAUTXgAoxqEUvb+GKgogtGZxwO9sowSp24p1o/JjYEMTK7fUG/1Rt
	 6YutZhjwThuTw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D77D760253;
	Wed,  8 Oct 2025 13:33:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1759923222;
	bh=WNwFxbIdGXJW1lMZclmO/btPEqzB7EMDDruafq3UcnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SEBCLDVSJ/j3hIfmG9LXuyShhdjOa+ulAxDdeXLLvNgVxGa421hrX6veuLe5++z1I
	 FijK5IwGnkZ8BEae3CZATgfMoG5I0PihRzUIO/rej+bb+bVAsHR+zMAqTv+zvZ13qn
	 PrnDuOTcvLekaRFU+FmCHcIitiDu7UOXlOSJcRvz6BNg2PukN1G1ViDsoWn4WXkYnB
	 kn0FJg9BaXaIKtnp1z2oUAFaXr5uBZHiCSKibX0DI7TgMTxnvk+vAnPUODNZ/UTwVG
	 R/40N93s1+fbTIDOOeX9OGxQqFv/K3pFm2r+vvov6GFSUbVgXuulHEkKU/69fIk4qg
	 yCbRDc4jvjl3A==
Date: Wed, 8 Oct 2025 13:33:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Nikolaos Gkarlis <nickgarlis@gmail.com>,
	netfilter-devel@vger.kernel.org, donald.hunter@gmail.com
Subject: Re: [PATCH] netfilter: nfnetlink: always ACK batch end if requested
Message-ID: <aOZMEsspSF3HBBpx@calendula>
References: <20251001211503.2120993-1-nickgarlis@gmail.com>
 <aOV47lZj6Quc3P0o@calendula>
 <aOYSmp_RQcnfXGDw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aOYSmp_RQcnfXGDw@strlen.de>

On Wed, Oct 08, 2025 at 09:28:26AM +0200, Florian Westphal wrote:
> [ Cc Donald Hunter ]
> 
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Oct 01, 2025 at 11:15:03PM +0200, Nikolaos Gkarlis wrote:
> > > Before ACKs were introduced for batch begin and batch end messages,
> > > userspace expected to receive the same number of ACKs as it sent,
> > > unless a fatal error occurred.
> > 
> > Regarding bf2ac490d28c, I don't understand why one needs an ack for
> > _BEGIN message. Maybe, an ack for END message might make sense when
> > BATCH_DONE is reached so you get a confirmation that the batch has
> > been fully processed, however...
> 
> ... which (BATCH_DONE reached) would be made moot by this proposed
> patch, as we would ACK it even if its not reached anymore.

Yes, I am inclined not to add more features to bf2ac490d28c (and
follow up fixes patches that came with it).

> > I suspect the author of bf2ac490d28c is making wrong assumptions on
> > the number of acknowledgements that are going to be received by
> > userspace.
> > 
> > Let's just forget about this bf2ac490d28c for a moment, a quick summary:
> > 
> > #1 If you don't set NLM_F_ACK in your netlink messages in the batch
> >    (this is what netfilter's userspace does): then errors result in
> >    acknowledgement. But ENOBUFS is still possible: this means your batch
> >    has resulted in too many acknowledment messages (errors) filling up
> >    the userspace netlink socket buffer.
> > #2 If you set NLM_F_ACK in your netlink messages in the batch:
> >    You get one acknowledgement for each message in the batch, with a
> >    sufficiently large batch, this may overrun the userspace socket
> >    buffer (ENOBUFS), then maybe the kernel was successful to fully
> >    process the transaction but some of those acks get lost.
> 
> Right, 1:1 relationship between messages and ACKs is only there for
> theoretical infinite receive buffer which makes this feature rather limited
> for batched case.

Exactly.

> > In this particular case, where batching several netlink messages in
> > one single send(), userspace will not process the acknowledments
> > messages in the userspace socket buffer until the batch is complete.
> 
> OK, from what I gather you'd like for
> "netfilter: nfnetlink: always ACK batch end if requested"
> to not be applied.

I think this at least needs more discussion, I think we are now
understanding the implications of bf2ac490d28c.

> I would still like to apply the nfnetlink selftest however (even
> if it has to be trimmed/modified), because it does catch the issue
> fixed by Fernando
>  [ 09efbac953f6 ("netfilter: nfnetlink: reset nlh pointer during batch replay") ]:
> 
> ok 1 nfnetlink_batch.simple_batch
> #  RUN           nfnetlink_batch.module_load ...
> # nfnetlink.c:239:module_load:[seq=1759907514] ACK
> # nfnetlink.c:239:module_load:[seq=1759907512] ACK
> # nfnetlink.c:244:module_load:Out of order ack: seq 1759907512 after 1759907514
> # nfnetlink.c:239:module_load:[seq=1759907513] ACK
> # nfnetlink.c:239:module_load:[seq=1759907514] ACK
> # nfnetlink.c:239:module_load:[seq=1759907515] ACK
> # nfnetlink.c:254:module_load:Expected 0 (0) == out_of_order (1)
> # module_load: Test terminated by assertion
> #          FAIL  nfnetlink_batch.module_load
> 
> If the decision is that there should NOT be an ACK for the BATCH_END if
> there was an error, then the test only needs minor adjustment:
> 
> -       // Expect 5 acks: batch_begin, table, invalid_table(error), chain, batch_end
> -       validate_res(self->nl, seq - 5, 5, _metadata);
> +       // Expect 4 acks: batch_begin, table, invalid_table(error), chain
> +       validate_res(self->nl, seq - 4, 4, _metadata);
>
> So, what is the 'more useful' behaviour?  Choices are all equally bad:
> 
> 1. If we want to always include it, it might not be there due to
>    -ENOBUFS, which will always happen if the batch was large (triggers
>    too many acks).

Yes.

> 2. If we only include it on success, it might not be there for the
>    same reason, so absence doesn't imply failure.

Yes.

> HOWEVER, if the batch was small enough then 2) gives slightly more
> useable feedback in the sense that the entire batch was processed.

Yes.

I think Nikolaos pointed out that _BEGIN+NLM_F_ACK could actually
provide an indication, with the assumption that the netlink userspace
queue is going to be empty because it will be the first
acknowledgement...

> So I am leaning towards not applying the nfnetlink patch but applying
> the (adjusted) test case.
> 
> Other takes?

Yes, I would start with this approach you propose, then keep
discussing if it makes sense to keep extending bf2ac490d28c or leave
it as is.
