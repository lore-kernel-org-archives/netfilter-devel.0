Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBE129A31C;
	Sun, 12 Apr 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776016426; cv=none; b=jcDAET69AB7NnfcA6sn5RD/khKBsZPWerVcrMDVWp9KekOVYKZDEPp3siMPklrwLoF7NM9ah1ZLpvAn4b5/lJtx1T1qLf1jmoVS+Djzr4ZicN2ul23hS7srU/asFx4iDF/ztE/Z8ExY/T+BGhNgqzNEtDCEw2OMf57GUi5NOz5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776016426; c=relaxed/simple;
	bh=FRke6uFOzqmVr6CV9Wltmx8AT2pOkPD4BOcGv3qORn8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h0w5pqLm/HugspK7EOFZ+roaKqVwqvMzPC/PMYDvF6d2HBOwg7fuS4zAbOXx6xwvlnI9ttGhCy1GzZXFmOZQlxk6IBWjqIUyUPAyZceBAF8EERLlYzV/AjQiVC+CF0Tz0kpiW8jlQ78UuxtNyjGjiZw+pvZOeElNz5pzZT5O2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YDAHeH4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YDAHeH4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774F7C19424;
	Sun, 12 Apr 2026 17:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776016425;
	bh=FRke6uFOzqmVr6CV9Wltmx8AT2pOkPD4BOcGv3qORn8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YDAHeH4fE9/7Ktt2ugNcmV12dxHxP1QZSEd5xsSaUQJm0JHpNuiHY349xM/TpBCXu
	 1y0JBKUjMFPHpa5sk+qJRI6zGpfqTi/5opvdKbUQ2h03xeVR6ZGCHMZCR/rt1MY2yv
	 IbUTetsAjBioYnXY282zWmTRnPFIt/8bqsbzva4cRDs9eCg7Umgt1LeQbwEq+Wxyg6
	 zZMk0UaupV4XCn2HfoYBGG2OzjFfLby/YcQlcckrtaWTy/jt6Zqg50yTv74H5YbIUV
	 k6zmJsmPLwGZGnSWTgTw+M+X6OR6BSephh3ueDjKt4c7Mdv2vzHiLJ7JnUqUgt3WX/
	 QNUjfn32L20jw==
Date: Sun, 12 Apr 2026 10:53:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 00/11] netfilter: updates for net-next
Message-ID: <20260412105344.5e14fe70@kernel.org>
In-Reply-To: <advOUl92VLlqaiCJ@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
	<20260412094049.7b01dd7b@kernel.org>
	<advOUl92VLlqaiCJ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 12 Apr 2026 18:54:49 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 10 Apr 2026 13:23:41 +0200 Florian Westphal wrote:  
> > > 1-3) IPVS updates from Julian Anastasov to enhance visibility into
> > >      IPVS internal state by exposing hash size, load factor etc and
> > >      allows userspace to tune the load factor used for resizing hash
> > >      tables.  
> > 
> > Someone should take a look at the Sashiko reports for those, please?  
> 
> https://sashiko.dev/#/patchset/20260410112352.23599-1-fw%40strlen.de
> 
> Sorry Pablo I am dumping this on you.  Already wasted 3h on saturday
> on LLM crap 8-(

Sorry, I was quoting the IPVS section of the PR because I meant that
someone should look at the IPVS portion. The rest looked like a waste
of time, indeed. The netns dismantle vs ipvs smelled like it could be
legit.
