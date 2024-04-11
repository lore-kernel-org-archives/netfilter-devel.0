Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3ED144D34
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Apr 2024 10:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830286; cv=none; b=K6JivVm2XYvZycVHzF5ZL4hR5tFKHY9nwRz4yETTgoHAubAQn/FF9Zb8JxNHMTmx0fUbnEYRG6KQT/qfXqLETjMMNGu0eIK2zP+NpLuazv2+3NdWWMiWN41QPRGXzr12uBwwCUL76yH2MPRZQ6bvuPV+iShiN8RPH+ZFIiiTySU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830286; c=relaxed/simple;
	bh=CbgE2cCmxXbp9ez5+bIoO3vH0Jv9l+WfEVldD0AiAmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZKjrH9DGDf/7CcN6JhQsqJOlCFmu4y2B1YVmGpXk5H5U5tPjylJaI/VN1s0O1TyL6O8M9w7RNQQTU+Vxon4sg+JsYiRIQIxaJ/B3ASUCBxLFSsoGitQqVrfEQWXTrnIIkyO7sSB+jvRXAxWKFJeuYq7Cr0FHzqCUpiyh8SJloG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=iquO3wo7; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="iquO3wo7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=YJeuYibclledV2QD7Be+yZSpetdqQT/ZYEj6NG3jPcY=; b=iquO3wo71OfjJ4KZT/yOskOdHv
	xRVHoPaRB2b8+VpI8fr0iGuS18KiPu6jQWUPPt92JUCkJKQOHpPawHAkW6TJQxSLPIVPjlmP7dkTU
	h0+hbDZYp1m0hTpFfgZL5dRpmrWqq0YqrxNELVM3lVsv9ihLnoVz3H284cvryP4bbqc5SQrzS51hK
	ifO98gTs1F6ulcJt/BsVtJfR6XvEhqpNGoAPxUFFIDrGC6/g2OJbSi05iOSE2GqTP6lwYTkkeaGMx
	O9MZ+Nn9yKWERnTJ/0oN1VLWyJIIKB+3j5YSZYbXGQPZlGb1Vr4dB3O+NR7waO8kcbslKrenKwdf7
	iQ54l4aA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rurOm-000000001Eq-0pK6;
	Thu, 11 Apr 2024 12:11:16 +0200
Date: Thu, 11 Apr 2024 12:11:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 00/17] obj: Introduce attribute policies
Message-ID: <Zhe3ROSn0rCq_iYH@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240319171224.18064-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319171224.18064-1-phil@nwl.cc>

On Tue, Mar 19, 2024 at 06:12:07PM +0100, Phil Sutter wrote:
> Just like with the recent change in expr_ops, this series reuses
> obj_ops::max_attr field (patch 11) for validating the maximum attribute
> value and implements an 'attr_policy' field (patch 13) into struct
> obj_ops to verify maximum attribute lengths when dispatching to specific
> object type setters in nftnl_obj_set_data().
> 
> Patches 1-6 add missing attributes to existing validation arrays.
> Patches 7-9 fix for various more or less related bugs.
> Patch 10 enables error condition propagation to callers, missing already
> for ENOMEM situations and used by following patches.
> Patches 11-14 contain the actual implementation announced above.
> The remaining patches fix for the other possible cause of invalid data
> access, namely callers passing too small buffers.
> 
> To verify this won't break users, I ran nftables' shell testsuite in
> nftables versions 0.9.9, 1.0.6 and current HEAD and compared the results
> with and without this series applied to libnftnl.
> 
> Phil Sutter (17):
>   chain: Validate NFTNL_CHAIN_USE, too
>   table: Validate NFTNL_TABLE_USE, too
>   flowtable: Validate NFTNL_FLOWTABLE_SIZE, too
>   obj: Validate NFTNL_OBJ_TYPE, too
>   set: Validate NFTNL_SET_ID, too
>   table: Validate NFTNL_TABLE_OWNER, too
>   obj: Do not call nftnl_obj_set_data() with zero data_len
>   obj: synproxy: Use memcpy() to handle potentially unaligned data
>   utils: Fix for wrong variable use in nftnl_assert_validate()
>   obj: Return value on setters
>   obj: Repurpose struct obj_ops::max_attr field
>   obj: Call obj_ops::set with legal attributes only
>   obj: Introduce struct obj_ops::attr_policy
>   obj: Enforce attr_policy compliance in nftnl_obj_set_data()
>   utils: Introduce and use nftnl_set_str_attr()
>   obj: Respect data_len when setting attributes
>   expr: Respect data_len when setting attributes

Series applied.
