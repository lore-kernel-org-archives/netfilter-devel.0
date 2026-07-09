Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CAE54763
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 17:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783616690; cv=none; b=WSY5ltoObrzTAyISxh7p+FZf5+YX4SJifNaE0a9w5wZMJYDw4G/wxPKFtFdF7K0A6ba2xVqvtdVV3AV4u+eMGbxRkMc+8RbSEmgQwiENFQimwmgVDrNhGpSCnjjCJaNzczoNQxUpiJ5vMrOk3JiT5IqF7zzu/bY0xzG+MuII+z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783616690; c=relaxed/simple;
	bh=9Xd3DNCP/LKOsDgJDv05AwEnahDZh9vQsFXycB/aLW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpyJIEUCaS/VhP5hYarx77YRAXZjHv0Ptri9kz2F4lvMHUiNteSYGw2LNchwrNPSS16uQd82yTp88VtHxaX/NMYCY5msAeH9eBp+zkuxeM1GrXyo9vQNDacT2CKpnX23MefIAiRVl3fcNDfqxRRlTBvpKOkIVqSjHWOq4cmJB6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v1+/XOoy; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v1+/XOoy"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5BA76602A9;
	Thu,  9 Jul 2026 19:04:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783616685;
	bh=ydlsbGz9DLUQatIF3qxfMX6fA5GFmCYDC0agSHPUTO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=v1+/XOoyhsMKUOx9pwId468PlfY2ddK8xk0tkXFjj5MGx+JISg0WTFygovD/gFjMo
	 xyE/IyPuZSReH9ELeXGg4eWPL/ZR6kcffBfKPwLiXhEzMQLNfeAWTJJu2OQHnTKIG/
	 HYuOB9lxsHzmUD70eXdPy3UTHgOGrqahCrykbaH3rCtIGMPXZjI8bh0wQBOd8p3pP2
	 i8c78mjfnttEyknTUfVS35Nnmv1NbCNubv1w+H4jTdY6nuj5frUqtDvrJSkD/R6gHR
	 ihu8FadiE4ILSlCuutrpa803GVYnoUz+36ijEYsbI1sGEkiP7wmfB/veTJzB2eyA5l
	 55k4xh8r8/35w==
Date: Thu, 9 Jul 2026 19:04:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [nf-next PATCH 2/4] netfilter: nfnetlink_hook: Deref hook entry
 using READ_ONCE()
Message-ID: <ak_Uqs2vUMK8XPIU@chamomile>
References: <20260708161940.1477671-1-phil@nwl.cc>
 <20260708161940.1477671-3-phil@nwl.cc>
 <ak-PECbcevqjy91_@chamomile>
 <ak-VvHgZDCI5nIzv@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ak-VvHgZDCI5nIzv@strlen.de>

On Thu, Jul 09, 2026 at 02:36:12PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Are we sure net/netfilter/core.c is safe to be walked over rcu in its
> > current state? Could the dummy_ops be exposed through nfnetlink_hook?
> 
> What do you mean with 'safe'?
> The walk is safe from memory safety point of view.
> 
> dummy_ops *can* be exposed.
> 
> Otherwise, hook unregister can fail when low on memory:
> ATM, in case we unregister hook and then fail to alloc the replacement
> blob (that is same as live one minus the removed hook) we leave the
> dummy stub in so old hook function is no longer executed and leave the
> outdated/stale blob in place.
> 
> One alternative to dummy-ops usage is to keep a spare blob around so we
> can avoid the new memory allocation when a hook goes away.
> 
> Then, on delete:
> 
> 1. use the spare (which is large enough) instead
>    and prepare the new blob (without removed fn).
> 2. swap the spare with live version.
> 3. attempt to allocate a new spare.
>    if that fails, force a synchronize_rcu() and make
>    the 'old' live the new spare.
>    Else, use the new spare and avoid the,
>    synchronize_rcu(), old-live is handed off to call_rcu.
> 
> Hook-add would always have to keep the size of the spare
> up to date, so it is always large enough to hold the
> current amount of live hooks.
> 
> Its a bit more work, but it avoids the need for dummy_ops.
> LLM should be able to generate the transformation patches.

Maybe a more simple way is to skip dummy_ops in the netlink dump so it
is not exposed to userspace, that's all.
