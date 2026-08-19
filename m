Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2433A4F4B;
	Wed, 19 Aug 2026 21:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787176251; cv=none; b=MufRSUoPCvyizRodx3JHQJ3AdC6HLVH6CqP/awOPXEAR2CDVqNjA96SbJhsaN/tb0/njBc7klz+Fgt2Seqp6UFXCM8g+cB6+/aRuaTNymwZ0YMLGqZoeej8Oe4MERXbwmKGuj7j9xnAGAlFN2+K1AD6Lq9GoNvQXZUkd/Hlef3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787176251; c=relaxed/simple;
	bh=Y2NIjvsedjRYR1SCxwQ51gGchsCYoLkJc9jlPfATTJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U0FOrDlMxvPs3E3wEFa8INcsyn59WZ2c5ILKmDiKQCTAjRyi+LscBIa0dw3d6sK6Z5TZujWJ+Giq5AfoSjfwie4eVqBZt8d1v2S/DJFjeKmw52H/3zhwIXTqX07AVCuCMeZ0GcbyAq9Y7AYacOtdbXyjIRNMgTE3YEyeT9p5udo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Uex7j1Kh; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Uex7j1Kh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787176246;
	bh=4gpYNfPeuAMpVu8sW4sj7NReGmBq9Aoc1L9135qgF7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uex7j1Kh5fHjeAH8mTOs7EXSiQHNs12wgrDosOOGIRQaNxFTs+Oneh5hGVjA8zQai
	 0d5hHBzjNtSC9xe1rmBr0k/bE9WORLLqKdyAYtnPK1bYsvoIQxVo5liUizIImAmoqs
	 fq0h78KOV9izYlw6Ganz+QAcDP9/KkId6ziSY072fgzu4763TpSASlUacOX+IgouwS
	 bVMubFnej60PtUIr8wT35JU1SfxWsLaUmklhdZDacPu8CRL8nt989FO9GmXLBHh1c6
	 3HkpEzWR6g/lobSoYIamWmr+Rl6TvlRl6iNLh0H+VG5VElImrqC2NP4t2+GMoKBBp7
	 AAYCKZsHsLRUw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 050BF6008A;
	Wed, 19 Aug 2026 23:50:45 +0200 (CEST)
Date: Wed, 19 Aug 2026 23:50:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, horms@kernel.org, ja@ssi.bg
Subject: Re: [PATCH net-next 0/8] Netfilter/IPVS fixes for net-next
Message-ID: <aoYlM3J0SP51Kpoh@chamomile>
References: <20260817232957.1281637-1-pablo@netfilter.org>
 <aoTzAYyHk7E-HTE_@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aoTzAYyHk7E-HTE_@strlen.de>

TLDR; I can post new v2 for this PR if needed, the left-over of
LIST_HEAD(set_update_list) in patch #6 is a bit embarrasing from
cosmetic standpoint because I will need a oneliner patch to remove it.
And I can re-target to net.git as Paolo already mentioned.

Anything else can be addressed by follow ups.

See below my comments (extending Florian's) for more details.

On Wed, Aug 19, 2026 at 02:04:17AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 1) Validate layer 4 header mangling done via nfnetlink_queue and
> >    nft_payload, this is a follow up to recent similar validation
> >    at layer 3. From Zhiling Zou.
> 
> This needs a followup patch to add validation of the checksum field.
> 
> > 2) Do not allocate memory on delete operations in ipset hash:net
> >    type, delete operation must always succeed. From Florian Westphal.
> 
> The AI feedback should be ignored for this one.
> The missing check for the error is valid, it is added in the pending
> rhashtable patchset.

3) Deliver nft_obj overquota packet path notification directly via
   nfnetlink, do not use the control plane batch logic.
   From Fourie Zhang.

AI feedback is not an issue. The overquita events is triggered from
packet path, reordering wrt. to transaction handling is not an issue.

5) Do not expose expectation dead flag to userspace via ctnetlink.

This isn't a bug introduced by this patch but...
ctnetlink_exp_ct_dump_table(), reached via IPCTNL_MSG_EXP_GET with
NLM_F_DUMP plus CTA_EXPECT_MASTER, has no such filter..."

Yes, nf_ct_exp_is_expired() can be added to that path too.

"This is a pre-existing issue ... should the read of exp->flags in
ctnetlink_exp_dump_expect() be READ_ONCE()?"

Yes, there are a few spots in the tree missing READ_ONCE(exp->flags),
including this one in this patch.

6) Make commit set_update_list per-netns to prepare to publish
   set clone earlier.

Yes, there is a left-over LIST_HEAD(set_update_list) that needs to be
removed in nf_tables_commit() path.

7) Publish the set clone earlier from commit path to address set
   lookup failures during table re-creation, this is targetting
   the rbtree and pipapo set backends.

Yes, set->dead flag is not set on now and an issue that was fixed
recently can pop up again.

"Does this open a window where the old ruleset is evaluated against
next-generation set contents?"

Yes, this is know and this patch is a step forward improving the
situation in this regard.

Regarding the check in nft_set_do_lookup(), it is only useful at this
stage to set backends with no .commit interface.

Let me know, thanks.
