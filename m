Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A122D40DB32;
	Wed, 29 Jul 2026 23:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785366467; cv=none; b=KrzqqCBlE8jJ4nsFr/dAZnUtFM/Jkq9WW3H/TOC4LJkh0lg+oTa/glRxxLm8qmUNBTqVAC7dLDpSaIrQ6hROqCY+5pyTxeSVI+xxqGOERU7i1t+6GEzqdu53rx5Sg/McwPqzhKdHLjzHHTa+hq44WPCCFypEpK3pMj3wfs0+ALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785366467; c=relaxed/simple;
	bh=rdmG6yp05gQHxe+lqv4pQpNBEUssKvGi7ipbvGC2TjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXNP7w6ul7EAator6oaeehl1rvDJ3LBwbVCLTiZR35MmDIXAITOv0xTz0TL0JyUfk8EtOsECmAXslqueo+v3m5v5A+L4FBlBs+d6azjq9Eqs3lkY/2nBfnLzzr0p3IanCUoeeNTYsnliu8G05ImQ12r+uj+JBWTOupD0E6ZmK5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mQa8EfmQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mQa8EfmQ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B002A60191;
	Thu, 30 Jul 2026 01:07:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785366461;
	bh=8XUrG4xoVcf+zD32+/LksVUfhMtKplZQtZLCg9xnRqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mQa8EfmQQbmLwHCR9xIVsSRVFFLMGqwIBCH1dAZhtbbsoswHshwMqG7gJJ0yOEJdI
	 9U4Q+2uSllmu1I6lFIb0sL7cxIS1egPdYI1u01aHTD9R2N4vFu/I+Ix3FlJSth9QwP
	 1swK0IwqIlfZHcQ2V0pe40fff9xGCe95EPTMnjXOEAF5e8CQq9JvxctR/O5WW8cqX6
	 /y/GL2iK2/l28d9DjlEP308f+rBXa3UNjA5oWJIZ9NhhQ8mPOCRtaf0IIMXdQ45EYw
	 qzZ9/yoL4jBCOHRMDWx/ekErcbvZ2QI0WTCHfe2pUEIqcfNIGJpgqrWtuYlmdU4A40
	 r+E6l3Vnexqnw==
Date: Thu, 30 Jul 2026 01:07:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: Backport request: "netfilter: nf_conntrack_expect: restore
 helper propagation via expectation"
Message-ID: <amqHu5H6xu02Izo8@chamomile>
References: <ee95f6ac-181e-4315-a2ae-e4d1388c5e69@ovn.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ee95f6ac-181e-4315-a2ae-e4d1388c5e69@ovn.org>

On Wed, Jul 29, 2026 at 11:38:17PM +0200, Ilya Maximets wrote:
> Hi.  The mentioned commit dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a
> was backported to 7.0, but not further, while two commits it is fixing
> were backported down to 6.1.
> 
> Admittedly, the patch is not very important as far as functionality
> goes (at least for FTP), but the issue does change the user visible
> behavior and that makes all the FTP system tests in openvswitch
> project (in userspace) to fail.  This makes it harder to validate OVS
> on kernels below 7.0 and makes it unnecessarily harder to validate
> changes for the openvswitch kernel module on stable kernels.
> 
> So, it would be really nice to have the fix backported to the same
> branches where the commits it fixes were (6.1).
> 
> AFAICT, cherry-pick works without conflicts down to 6.6.  For 6.1
> there is a minor conflict, 6.1.y has the extra debug message:
> 
> diff --cc net/netfilter/nf_conntrack_core.c
> index f5c466ea1e7d,8ba5b22a1eef..000000000000
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@@ -1800,8 -1811,8 +1800,10 @@@ init_conntrack(struct net *net, struct 
>   		spin_lock_bh(&nf_conntrack_expect_lock);
>   		exp = nf_ct_find_expectation(net, zone, tuple, !tmpl || nf_ct_is_confirmed(tmpl));
>   		if (exp) {
> + 			struct nf_conntrack_helper *assign_helper;
> + 
>  +			pr_debug("expectation arrives ct=%p exp=%p\n",
>  +				 ct, exp);
>   			/* Welcome, Mr. Bond.  We've been expecting you... */
>   			__set_bit(IPS_EXPECTED_BIT, &ct->status);
>   			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
> ---
> 
> WDYT?

I am fine with getting dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a into
-stable release < 7.0 if that is what you mean.
