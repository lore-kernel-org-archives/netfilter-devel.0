Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EBB2A1CF
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 10:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754564252; cv=none; b=LrXVsqERzlWkw/uvdK5LvPZ5QwHV8fiXRv0xQJNrdHEJfCoNn/lOjLWxzQC0V4CoQ+emuyRzd2Z8Ra8fQ4Qv8HkiFo4R5YogV46KjS+1RPQcm+qZv2wK1TLMq7FWdrXdLYF57x5PEeEEsOsMLgwsxbqcemNmuR2OzBqjul6zckA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754564252; c=relaxed/simple;
	bh=XdA21fINN4x7YaOZPWWsezbUSG2aSud6HV17/2z+bAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bQIlgkJ7OhVqOWwVgmliDaiCa5Krpn9PcjTOpRNAYrI8qJ/XwnOQXbn9BGUUcG8J550see7kP7LIRP/cGLILWC+XpO0teqOiponMlWJQKSLzBz8qOQn58QbBsQlfPNWBjTFFuZOBvN4eqONVKg5VChIgFbqNLJFPVbUkPRSk1LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GDjy8f/T; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fKpjYfc9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GDjy8f/T";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fKpjYfc9"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5B3B060A80; Thu,  7 Aug 2025 12:57:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754564248;
	bh=5CcqnI9kdM1nnrTgT4rNcwO9znGed53Kme+vPVoYQkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GDjy8f/TPg3lEw4cPyZwoPRLhwIlnSGOI6hjWJBeGjnqUFkV3Pgszg39+rcKxU/GO
	 Qh1U6L9+6dPCGgCrMYJytiEJHziMmgbGrnmpXVfLFL6ImEI7Go5zbzuKGlHePv3YFg
	 VFt7D4ZLiOi8xXbhTZ7/8eGZAhf7NesQxuvPJeJ7ZUTyj6MQBPFpdzxfm0nVCZJRak
	 jCnWffxNm80UlTTip0axRWZhX1s5Gy3UjQGYSCjJEYReEyO36yAqywtAXJIxUr9F5N
	 U2rGNFoG25NMBmkIaoHLsq97oFqm5oX/VLH0+y3eov5v3QmrEuPrytutLODHkm8wri
	 ITqPTp9FGj48Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9C0FB60A80;
	Thu,  7 Aug 2025 12:57:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754564247;
	bh=5CcqnI9kdM1nnrTgT4rNcwO9znGed53Kme+vPVoYQkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fKpjYfc9B6cynZm4+S6ZWiCLVDKpFvl9KjESmkO7y01msq+W9LKJf0tRji6fUrJQP
	 r/t/WN6Hej0Q7Wgi45AjMsbgGNbiRwHp/QDlrTfSnL7HGdika23hJbaHpkK9A3hzgl
	 uTq4ONvvT+fdsa6HmxElcjzi2tQ52Q8y3Bl4Sx+Ip4XGpaq72uWU72MUOaeAk7v00W
	 CKvE6XTzxu8LVAHX6/YosD1JLLtnQcsTKF5RNEQahQQUC9CAujkIo18Jp3U/7Mh29O
	 fyc3D43I1TxWd1YBYL+zoqc2zV/CMHsrSzY9xLFQtOiPj1Gk0N0hBnKdKK8SINLyQy
	 J/Y0aQiUWmBEA==
Date: Thu, 7 Aug 2025 12:57:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/2] netfilter: ctnetlink: fix refcount leak on table
 dump
Message-ID: <aJSGlBD36tgRNWpT@calendula>
References: <20250801152515.20172-1-fw@strlen.de>
 <20250801152515.20172-2-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250801152515.20172-2-fw@strlen.de>

Hi Florian,

On Fri, Aug 01, 2025 at 05:25:08PM +0200, Florian Westphal wrote:
> There is a reference count leak in ctnetlink_dump_table():
>       if (res < 0) {
>                 nf_conntrack_get(&ct->ct_general); // HERE
>                 cb->args[1] = (unsigned long)ct;
>                 ...
                  goto out;

>
> While its very unlikely, its possible that ct == last.

out:
        ...
        if (last) {
                /* nf ct hash resize happened, now clear the leftover. */
                if ((struct nf_conn *)cb->args[1] == last) {
                        cb->args[1] = 0;
                }

                nf_ct_put(last);
        }

I think problem was introduced here:

  fefa92679dbe ("netfilter: ctnetlink: fix incorrect nf_ct_put during hash resize")

> If this happens, then the refcount of ct was already incremented.
> This 2nd increment is never undone.
> 
> This prevents the conntrack object from being released, which in turn
> keeps prevents cnet->count from dropping back to 0.
> 
> This will then block the netns dismantle (or conntrack rmmod) as
> nf_conntrack_cleanup_net_list() will wait forever.
> 
> This can be reproduced by running conntrack_resize.sh selftest in a loop.
> It takes ~20 minutes for me on a preemptible kernel on average before
> I see a runaway kworker spinning in nf_conntrack_cleanup_net_list.
> 
> One fix would to change this to:
>         if (res < 0) {
> 		if (ct != last)
> 	                nf_conntrack_get(&ct->ct_general);
> 
> But this reference counting isn't needed in the first place.
> We can just store a cookie value instead.

cookie is indeed safer approach.

IIRC, the concern is that cookie could result in providing a bogus
conntrack listing due to object recycling, which is more likely to
happen with SLAB_TYPESAFE_BY_RCU.

nf_ct_get_id() is adding using a random seed to generate the conntrack
id:

u32 nf_ct_get_id(const struct nf_conn *ct)
{
        static siphash_aligned_key_t ct_id_seed;
        unsigned long a, b, c, d;

        net_get_random_once(&ct_id_seed, sizeof(ct_id_seed));

Then, it should be very unlikely that such recycling that leads to
picking up from the wrong conntrack object because two conntrack
objects in the same memory spot will have different id.
