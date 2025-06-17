Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA04169AE6
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2025 22:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750198185; cv=none; b=gtBWaMDIQQLrULMc9gWWxJuKn0+rh3F8VDuD61e1nS9OP5xGWwoCGe8ppJZT6ixa5SPNhjs2ut+FM+1L/Pzu1GNzroNmVyzkDZlgHoL14m00/nDpz8HY9+92peyaH5aRKK/CUibvsCEc47KlgOenHibRzWQg+yi1TDJC8hD72xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750198185; c=relaxed/simple;
	bh=A3NeCdZl8QiyjDJ/jzmUPVF3KQ5cMSdT+Dr8mAYHkkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vk7G6y6L72mZDJ1y1qQbcQPD0wvX9p5so30jqrgYPbF9nIaOsGqCJ0l7fjYaiShCnj0FmpOsnH9nFr8fRwZLn5iEaFTUqQZ6n5T7wetfWS6cGRo/RJPiuYZlyeBU0SYRXksALG/Ro2RBrjpnkW230fWb5JxUtv7V5p58YKHRKAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PMJL3g4W; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PMJL3g4W; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PMJL3g4W";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PMJL3g4W"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id D36CE602A4; Wed, 18 Jun 2025 00:09:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750198172;
	bh=5AgFJ31VeEi7WuU4UOhqMKNZ40CaY7PHFnZnPElTl8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PMJL3g4W+1CZxQik4bd/+zbqdOEwhvZSsPEwn2ES1Eesko0H7llyrj5flZPCVlXHu
	 Rx9GeeLGC5VQ4jxku+fXcok5Pjzy9MOrU1kKwYlEt0DrKVb8AOF7W4ExNMNbm5nXj5
	 dUxpZPuhGeqIZeM00IeMnqsozMKuC32jRMBFBkSKYz5lDpSbyDPJUKRZrC9ZCovekX
	 7sPeeEDHo2rKLutHKqrOWu9/FMPkBPBKgfPkiVMxSQLFcwupWpSsTX+ZEfvD5Cy/Tl
	 lJNfT6j+XdcmJ7MQv4vXkdT+f34bjWjnY9bXr2/kE1qEG9un8D1JupqxXSsFRJm3mh
	 qA8gVJVx5emfA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EEDC26029F;
	Wed, 18 Jun 2025 00:09:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1750198172;
	bh=5AgFJ31VeEi7WuU4UOhqMKNZ40CaY7PHFnZnPElTl8M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PMJL3g4W+1CZxQik4bd/+zbqdOEwhvZSsPEwn2ES1Eesko0H7llyrj5flZPCVlXHu
	 Rx9GeeLGC5VQ4jxku+fXcok5Pjzy9MOrU1kKwYlEt0DrKVb8AOF7W4ExNMNbm5nXj5
	 dUxpZPuhGeqIZeM00IeMnqsozMKuC32jRMBFBkSKYz5lDpSbyDPJUKRZrC9ZCovekX
	 7sPeeEDHo2rKLutHKqrOWu9/FMPkBPBKgfPkiVMxSQLFcwupWpSsTX+ZEfvD5Cy/Tl
	 lJNfT6j+XdcmJ7MQv4vXkdT+f34bjWjnY9bXr2/kE1qEG9un8D1JupqxXSsFRJm3mh
	 qA8gVJVx5emfA==
Date: Wed, 18 Jun 2025 00:09:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evalute: don't BUG on unexpected base datatype
Message-ID: <aFHnmH-4ZlV5PQdJ@calendula>
References: <20250613144612.67704-1-fw@strlen.de>
 <aExGZDqWdNgG0_BD@orbyte.nwl.cc>
 <aE3vUEmr6Ua291dK@calendula>
 <aE_gwzl1Fagv0jcz@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aE_gwzl1Fagv0jcz@strlen.de>

Hi Florian,

On Mon, Jun 16, 2025 at 11:16:18AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >  I wonder if we should just replace all BUGs in evaluate.c
> > > >  with expr_error() calls, it avoids constant whack-a-mole.
> > 
> > I think that can help uncover bugs, or are those json induced bugs?
> 
> This one is bison, see included bogon input.

For this particular case I think it makes sense to turn it into error.

Nitpick for this patch: I'd suggest this error:

+               return expr_error(ctx->msgs, *expr, "Unexpected datatype %s",
+                                 (*expr)->dtype->name);

Which results in:

[...]
ruleset:3:61-67: Error: Unexpected datatype verdict
               type ipv4_addr . inet_service : ipv4_addr .  verdict
                                                            ^^^^^^^
> I meant in general.

It's not so straight forward, I have quickly browsed the existing
BUG() calls and, unlike this one, they are mostly trapping nonsense,
I guess we can find a way to keep them around while not invoking
assert().

> How do these BUGs help at all?

Maybe you can turn them into error record adding "BUG:" prefix if
you prefer, I guess that will not crash a daemon process which is your
concern?

ie. add expr_bug() to highlight an input is triggering a buggy internal
state so this can still be reported without crashing the daemon
process?
