Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613B139E9D5
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2026 21:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780954610; cv=none; b=cPQ1wD/xjHyL9WbM4IcKkeHKp/HLTDjcWjcx3+cROP4dMLuEtFbRCzE0buZZucw+/MoHEzQh1vPPX0L6n2N8pOKxShGIQptqUJqDVSq3+13RO7uM+be16qAVz/ITaeBTLM4VUsnQHs5R1LPNzlLeVpeMC5O66JHvQwXl+X+t1Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780954610; c=relaxed/simple;
	bh=ifPlikER/a9tdzGFgsssFDIP1wHLdthQ2ZhC/TUrs/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mn/b2x9zCcW/3xoqFt4Bn8iIMjZ7TCePF4vkoRI8AqRptdT1ctnsEpUxv6KvinSAUNlIOWVjtUcutgOQxFBgBdyj06zRwJeH0XBs63wrpZoTXcskNVyc0Dk7+tDmnAzc0j0FGSM+2iNkefe7+oM6h1SYaHxvXtRdHHyYBMvz7Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MRPvNEZE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MRPvNEZE"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B4E6660181;
	Mon,  8 Jun 2026 23:36:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780954607;
	bh=TQypTEqc0+m7yV9EhZMqG5bA2PrG1mAXiQO6LxvyoOU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MRPvNEZE3nBwLpRNQGdRkkoMRWH08kKIZ4yk0jKgwy0E4xECRWK3LbKOTvfKkEEec
	 BmTD6W8L8RGu1wnxvKrP5nf7Ug9aTeodypOfpsh8EfHNuIw7nbJic6snHe0y4O9b8o
	 So8diSIAjIEnSrAlJXCCH5UncHIkReKX+YgmonUbcXL8AUoMQcM5tk7nw/YBSbjSu1
	 7XXFmHi/cFS5tJZ2awr2+/O/nggtyX8r0jhQ+nA3pijIQLQFjNzAGq5iMf/tpahRH2
	 oiN53PLrnQC5MRFSufj2yPBCJSBYz0uUMbwv2IF8aldT502QDa+IK0+5PbTSk/tbnb
	 0sMQ6X5rIoRhg==
Date: Mon, 8 Jun 2026 23:36:45 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: conntrack: check NULL when calling
 nf_ct_ext_find()
Message-ID: <aic17bHQFhPshKlH@chamomile>
References: <20260608212120.68828-1-pablo@netfilter.org>
 <aiczgrv5J-m-7jo8@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aiczgrv5J-m-7jo8@strlen.de>

On Mon, Jun 08, 2026 at 11:26:29PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > nf_ct_ext_find() might return NULL since ct extensions may be declared
> > stale because of object dependencies or modules that are going away.
> > 
> > When helper is removed, nf_ct_iterate_destroy() unhelps the conntrack
> > entries. Then, the nf_ct_ext_find() might return NULL if the extension
> > is stale for unconfirmed conntracks if the genid validation fails.
> > 
> > Add the null check to:
> > 
> > - nfct_help()
> > - nfct_help_data()
> > - nfct_seqadj()
> > 
> > that call this function since packet path could be walking over helper
> > while it is being removed.
> > 
> > While at it, fetch ct helper area in nf_ct_expect_related_report() only
> > once and pass it on to other ancilliary functions. Replace WARN_ON()
> > by WARN_ON_ONCE() in nf_ct_unlink_expect_report().
> > 
> > Fixes: c56716c69ce1 ("netfilter: extensions: introduce extension genid count")
> 
> I'm not sure this tag is correct.
> 
> The genid checks are only for unconfirmed entries, not in hash.
> 
> nfct_help() and nfct_help_data() can return NULL as you say, but
> I don't see how this relates to the above commit either.
> 
> That said, I agree with the patch.

No problem, I will remove the tag.
