Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B97327FE1
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751616048; cv=none; b=jkuAGOyODItK4DYgfZSdAkfAxb0y8zAFL2Vg20ai1Hhjpd8DJZ9jg/iqAhx4OghwJA10f1H1MtFs5JdMrhjANf2fmRzplB4E4cH+QKXSwZ8bXG1rtXVBRyAGhQA+R3VjvWteddeJ66ItHWUQMOCc7zIEhm1DCcfSceH2RCm8tZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751616048; c=relaxed/simple;
	bh=+RVxNuhP/UwJbysupJkQNbnWzzlY2guFGZS7kDDQBjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGt17iD6862/U7gGIvRmPJsK793JrZR2wkSx6d1AdO641Lh5Y6LD1RRXUhwrNHWwYJ+a90ZmgGa5GUz9VtUGyawgJb5Kxc/8hJPaKfNbwVKIbPQtPWoegjXV8wxMnVk7HnwcedlkDboXgNu6pA5TjdQ98vS5Ml9EndlWH1xCRTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NUMC/+C1; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ddIuTRGD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NUMC/+C1";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ddIuTRGD"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 35F7E60265; Fri,  4 Jul 2025 10:00:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751616044;
	bh=2KJEW4U7ThbEU5Ok5tAPRJVC/drpIbcrm1fGNy3+rUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NUMC/+C1na9cpWTJII1F/T6RWbU9z3raRFUF5fjqnMNQliljME2e5QYBz8+KvOJiJ
	 vkgBL06zXipRChm3aXer2EXptnv6M+hGkr+wNszgI01GK0D3KK3VzNGAkL8Ao/Uiw0
	 /timGlBtrWfTPCwAUgjahF3AaaX/sLLV9PkRlMqaGfbWvFNU/dHcUw38q+fu6AxwvR
	 wR8aeY0c8PI3YTeOfD+wSXYQKF1VsHJwxqzhLKUHsrO4KH3rdqgU27UOW59mxKphKL
	 sHLoF2pv7vOhcGmuq27GB7oqrjbZr5/dgQDZt5BemyFrJ36X1s14QKuir54LZZfYda
	 MZCfzKWdYAD3w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8468D60265;
	Fri,  4 Jul 2025 10:00:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751616043;
	bh=2KJEW4U7ThbEU5Ok5tAPRJVC/drpIbcrm1fGNy3+rUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ddIuTRGDlw+o5jUg+5VCPMkFbaHx3874kmJMASjPfHJC87mWvJnGFhIUIMBqSHtwf
	 eUjL+noDRudvtJs4ITsN8614ZRL04Zr6QgkiB010SKESIXxNTjdLZS/NvpW1CIDO1M
	 TllH5YP6Xx40wKAcakPwLEzN/fKkluUluhpQyY6xAzJ6YSMU/nCcIt4vGKU1bAxEMX
	 q4EbLfuycBe4Qqq6U0PzFSghozX7oVmttzaF5ze/5fUzhKYjrEalKN+169TxgMk6EQ
	 bfZz691SFOXVDOZzOvjUKcgQDL8q2XKq0DU3WDLzHz9zkhBh/8dX0cCvb4xhrjro5b
	 kP7u657Y52oKA==
Date: Fri, 4 Jul 2025 10:00:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH 0/3] netfilter: nf_tables: Report found devices
 when creating a netdev hook
Message-ID: <aGeKKXVmGjS2YVMu@calendula>
References: <20250612133416.18133-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250612133416.18133-1-phil@nwl.cc>

On Thu, Jun 12, 2025 at 03:34:13PM +0200, Phil Sutter wrote:
> Previously, NEWDEV/DELDEV notifications were emitted for new/renamed
> devices added to a chain or flowtable only. For user space to fully
> comprehend which interfaces a hook binds to, these notifications have to
> be sent for matching devices at hook creation time, too.
> 
> This series extends the notify list to support messages for varying
> groups so it may be reused by the NFNLGRP_NFT_DEV messages (patch 1),
> adjusts the device_notify routines to support enqueueing the message
> instead of sending it right away (patch 2) and finally adds extra notify
> calls to nf_tables_commit() (patch 3).

Fine with these series, I am preparing a nf-next pull request, I plan
to include them.

As this goes ahead in providing NEWDEV/DELDEV events for ruleset
updates, I think GETDEV is needed to complete things.

Regarding userspace, I think there only one item remaining to be
discussed, which is how to expose device notifications.

I would suggest to add a separated:

        monitor devices

Thanks.
