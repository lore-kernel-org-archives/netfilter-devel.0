Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE45F1CF5EE;
	Mon, 14 Oct 2024 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728936629; cv=none; b=FxpNlKZX77ZnaGJsfY+6j5qVI7X929al6fTa5Edt70vKRs3M00AhlJlsdNVay2K3hueQpsoB0WOKqfn4bkLH8HZoJWc+x0y3GTyXgK3EzJNC1AoLwVxVq3v3X0Op3y+ZmtzF4MihD1yVUxlbAANgegNS43joNl7obfEF5E9T0zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728936629; c=relaxed/simple;
	bh=vEn4m9waBM0pwb9EoGuHyHoQ7+1no5tRr2PNgfO5AZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bzwTjDJNVImb32p8WB0NqexvveypfHptr4mgqVOkdMNq0x1aBoraN1n41oZBCeUUmQeuROF+HHbwbFdwcTmOr8xKZv7ZfcDSOVobbu+8Mczt7yn3/XOrPEWf67J0ahOjcPSqvU9ffPtwQu6ymTR49Ljww0lVnVyLVz6VWJb9fZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDoPWG4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDoPWG4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC78C4CEC3;
	Mon, 14 Oct 2024 20:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728936627;
	bh=vEn4m9waBM0pwb9EoGuHyHoQ7+1no5tRr2PNgfO5AZ8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IDoPWG4tx2OQ9b/Nm4C0/k1gTe/Qp446Zrqtq5E5hSCIqBaApV217BeHBq15HybjN
	 T+mcTTm44ae9OLTWHjeTR9784xv5b5VCUE0XbL7EWadUmKxnF1piI/sQrOiqoAIKaf
	 PSDN0eC+MTnG04S/GkAecYaI0NvdoVSyH7uGed3j4SrliJ2ibjCwSUq3t/9onG97EG
	 hbbuekggq39ulCjSpoPK9DHF4xFToXIFXKWytEMN3a3fosNR4VXc2+Y93moGIetfBZ
	 7LcDQI7/x7+zUmeF0dFR+fDhnXOb7Bpgg+rz6Jwu5OCO23aNsZ1keL+kh0ZFzuZFZw
	 bXk0mXJPNKb3Q==
Date: Mon, 14 Oct 2024 13:10:26 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de
Subject: Re: [PATCH net-next 0/9] Netfilter updates for net-net
Message-ID: <20241014131026.18abcc6b@kernel.org>
In-Reply-To: <20241014111420.29127-1-pablo@netfilter.org>
References: <20241014111420.29127-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Oct 2024 13:14:11 +0200 Pablo Neira Ayuso wrote:
> Hi,
> 
> The following series contains Netfilter updates for net-next:
> 
> 1) Fix sparse warning in nf_tables related to use of percpu counters,
>    from Uros Bizjak.
> 
> 2) use strscpy_pad in nft_meta_bridge, from Justin Stitt.
> 
> 3) A series from patch #3 to patch #7 to reduce memory footprint of set
>    element transactions, Florian Westphal says:
> 
>    When doing a flush on a set or mass adding/removing elements from a
>    set, each element needs to allocate 96 bytes to hold the transactional
>    state.
> 
>    In such cases, virtually all the information in struct nft_trans_elem
>    is the same.
> 
>    Change nft_trans_elem to a flex-array, i.e. a single nft_trans_elem
>    can hold multiple set element pointers.
> 
>    The number of elements that can be stored in one nft_trans_elem is limited
>    by the slab allocator, this series limits the compaction to at most 62
>    elements as it caps the reallocation to 2048 bytes of memory.
> 
> 4) Document legacy toggles for xtables packet classifiers, from
>    Bruno Leitao.
> 
> 5) Use kfree_rcu() instead of call_rcu() + kmem_cache_free(), from Julia Lawall.

Hi! Are you seeing any failures in nft_audit? I haven't looked closely
but it seems that this PR causes: 

<snip>
# testing for cmd: nft reset quotas t1 ... OK
# testing for cmd: nft reset quotas t2 ... OK
# testing for cmd: nft reset quotas ... OK
# testing for cmd: nft delete rule t1 c1 handle 4 ... OK
# testing for cmd: nft delete rule t1 c1 handle 5; delete rule t1 c1 handle 6 ... OK
# testing for cmd: nft flush chain t1 c2 ... OK
# testing for cmd: nft flush table t2 ... OK
# testing for cmd: nft delete chain t2 c2 ... OK
# testing for cmd: nft delete element t1 s { 22 } ... OK
# testing for cmd: nft delete element t1 s { 80, 443 } ... FAIL
# -table=t1 family=2 entries=2 op=nft_unregister_setelem
# +table=t1 family=2 entries=1 op=nft_unregister_setelem
# testing for cmd: nft flush set t1 s2 ... FAIL
# -table=t1 family=2 entries=3 op=nft_unregister_setelem
# +table=t1 family=2 entries=1 op=nft_unregister_setelem
# testing for cmd: nft delete set t1 s2 ... OK
# testing for cmd: nft delete set t1 s3 ... OK
not ok 1 selftests: net/netfilter: nft_audit.sh # exit=251

https://netdev-3.bots.linux.dev/vmksft-nf-dbg/results/815301/10-nft-audit-sh/stdout
