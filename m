Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EABF9E8;
	Fri, 13 Feb 2026 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770999471; cv=none; b=PnXtoO/v6q2Y698oJQNtcCH6pbXS5mD1a90FshPIe7IUIYz+eQ7qpRm2nveFSIuQ8fWZNRb9QaX89k3TTgdrCP6ppHL5dGWTP2VGVLfUU3y4EQgkvVwJsrkmQzCInQg6sp/du9YVOxhiXiEvGVajW+pBQeacdTBe32NtPQheXUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770999471; c=relaxed/simple;
	bh=fflz7xRV/W8b2JMbzZPg73LMsPYHlAdeskPHt4ArEn8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZudwWCYkYakNm+uU1doPhipTLmTCPw9wu4087IWlMPTt4U83TUhd5zJP++Pq4AoF0EdLDNhwx9eM3++GX4BoJjlfOBIF8HT0jcGUW3W7a2qBoihXDolkHjPeGqHDmT3D9S3j/fGit38I/Ujii3wtYfIHTf6NNXOAdZwJ+p0DDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVfGLi6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVfGLi6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC35C116C6;
	Fri, 13 Feb 2026 16:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770999470;
	bh=fflz7xRV/W8b2JMbzZPg73LMsPYHlAdeskPHt4ArEn8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qVfGLi6gfVD2aFSKXQC3V4ckMyBk5ICSTNaYfpdf2WPEEc+vxGWMoAXNOI4aPCbWr
	 Z4pyfab38EvxQy0UoAyT1LT1bq1RhcRZpWRiTbDYvStXa35nCr860tu7p0KcN97LQO
	 WsB9klZvjkB7CXfIlbIf35zMeryD06kZGz9cUL2TqgXklo0fiPdVzfZ+uW7eWyNmpI
	 EOOZdIRBdCOVlIv+Cti0ZxaCcM+3PEMeeSymRMamqEA/4BuTK0J7bD9PRF7+d4mSG5
	 gk6mR/M4eShorEpBdinKelpGE5gMg4ZnKkkYi+XfUypf7GoqKXCIrOjldaDIYwyxUh
	 0M7aMSra9oVkA==
Date: Fri, 13 Feb 2026 08:17:49 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Shigeru Yoshida <syoshida@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net] net: flow_offload: protect driver_block_list in
 flow_block_cb_setup_simple()
Message-ID: <20260213081749.3b3ede9c@kernel.org>
In-Reply-To: <aY8LcgPsoYYGEH5s@strlen.de>
References: <20260208110054.2525262-1-syoshida@redhat.com>
	<aYxw2CpxOKLh1wOz@strlen.de>
	<20260212183447.2d577f5b@kernel.org>
	<aY8LcgPsoYYGEH5s@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 13 Feb 2026 12:30:58 +0100 Florian Westphal wrote:
> > > Looking at the *upper layer*, I don't think it expected drivers to use
> > > a single global list for this bit something that is scoped to the
> > > net_device.  
> > 
> > Maybe subjective but the fix seems a little off to me.
> > Isn't flow_block_cb_setup_simple() just a "simple" implementation 
> > for reuse in drivers locking in there doesn't really guarantee much?  
> 
> Not sure what you mean.  I see the same pattern as netdevsim in all
> drivers using this API. 

Grep for flow_block_cb_add(). Not all drivers use 
the flow_block_cb_setup_simple() helper, it's just a convenience helper,
not a mandatory part of the flow. We should probably add a helper for
add like the one added for  flow_block_cb_remove_driver() instead of
taking the lock directly in flow_block_cb_setup_simple()?
