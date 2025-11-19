Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE611E0083
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 00:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763512333; cv=none; b=CiunBlWW44R9lPeoddOksWxVU3YM/CpmBpFTGf1m3TI8kfOIqWf5WrrmZcFNGGY9wq9HakDV9VvIg8ofd2kLpCbyPccsI4ud4HsmHQb+0qiEN9Fnnj3kUWCKG/wxEbKSDdz59ucUfLqqqUPXzCbvufQan3HEpwoGW/J4CU1Imeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763512333; c=relaxed/simple;
	bh=8o5VmqKUMpIL0sxtHB90JYuGVsM6In9BaBnk3PDqbYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMVEuNoeECMr6ACCmiGWPpr4OlsYMg1tYU0tKyLC5A9oEnG6qXVEjKeOnBVo6mgPJN20Ml/+kvcePTrYsZkiJS/KydcLzMn3t9K+1SW6C9553nCA5CQ3yuMDO3cae/HcZPPo/Zz9+EzkkuQ9ds4L4S2FiG3+BrY+GWYLOuUHuc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PBjzYgIe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PBjzYgIe"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EC2E860255;
	Wed, 19 Nov 2025 01:32:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763512326;
	bh=5ArgKVlvBILz+OK7lo4XJJXMwvELmg8rnbHNwdxQggE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PBjzYgIeN3o3hQskPuOdjrpsF8YxmkaAQNRWucepKTjyX2xzXUEo1XoDBkboat4OY
	 zS3qkQA8jVZhwZf8JMJDlyQ7AYcPJROrxcpl8VIKStaiWhsncbnduskFVp312JrRwR
	 MlQgykHE1UzNzvy5VEYZOVl1K9EOLz7fQNEA+nnPbQAvyZGruWnuE0NnZPwQGSHJMy
	 0HpJMdcqG5EcIEzLBwekKYaOhwbNp77oTD0z2+TfKv871M8KzrupVyvluL9466RnQD
	 CrD2NXNXYQoBhzjck/+5W5vc5fu6eWn6zXp+ALEmHg2+3hCa8PpMo40tMzkBz0gpjd
	 SndcS6zmU6gYg==
Date: Wed, 19 Nov 2025 01:32:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nfnetlink: bail out batch
 processing with EMLINK
Message-ID: <aR0QA3kPzZssXSkm@calendula>
References: <20251118235009.149562-1-pablo@netfilter.org>
 <20251118235009.149562-2-pablo@netfilter.org>
 <aR0Kq9G-MD-Cvvdk@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aR0Kq9G-MD-Cvvdk@strlen.de>

On Wed, Nov 19, 2025 at 01:09:15AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Stop batch evaluation on the first EMLINK error, ruleset validation is
> > expensive and it could take a while before user recovers control after
> > sending a batch with too many jump/goto chain.
> 
> ok, but...
> 
> > Fixes: 0628b123c96d ("netfilter: nfnetlink: add batch support and use it from nf_tables")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nfnetlink.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index 811d02b4c4f7..315240b2368e 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -558,6 +558,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
> >  			 */
> >  			if (err)
> >  				status |= NFNL_BATCH_FAILURE;
> > +
> > +			/* EMLINK is fatal, stop processing batch. */
> > +			if (err == -EMLINK)
> > +				goto done;
> 
> ... but -EINVAL, -ERANGE or any other validation error is also
> fatal, so why do we make an exception for -EMLINK?
>
> Is it because -EMLINK indicates we already spent lots of time
> hogging cpu in chain validation and continuing will burn more cycles?

Yes, you can create stupid rulesets with lots of EMLINK to burn
cycles.

> But even if thats the case, I'm not sure its the right choice,
> we could also spend lots of time without hitting -EMLINK.
> 
> Maybe count errors instead and stop after n fatal errors?

For other errors, such limit should be possible.

> Would also help with rcv buffer overflow on too many
> netlink errors.

Error messages are still in the queue, buffer overflow only means in
this case that more errors have been omitted.

Limiting the number of messages in a different topic.

For the attempt to support synchronous sockets for simple third party
applications, actually limiting it is requirement to ensure buffer
does not overflow.
