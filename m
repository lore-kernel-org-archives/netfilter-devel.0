Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EDD2FF66A;
	Thu, 14 Aug 2025 01:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755133400; cv=none; b=X1pY5Q8sX6mRLwWLefg7LxV9SKKkzPS6jHw7YKbb7ebR0sLPHekewLNDJrgDv1ng++/1Lf4olN5AbBvfFDcUArrsYZMcrILJ5shDvrFioOOCWoRf16SXGvYk+eBL/CqyV4VHrdMerYasdU1dI/n2Wui24bZ4Yre33/IQWTP+htY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755133400; c=relaxed/simple;
	bh=a9cPTPnhk0B0MV87JUqmN62I77LB1AsQD8P49IZxTR0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/0uMwsMq9yD8YNKt8+psyHygyNkE9Ue/qdDjrC3+xOH/MbvTGMVqokvLi0ImlL3WTIhGXIBqn1BUPftCxxKKiar0w63J/BqmWWn/WavkoDXmNMKLNDFf3shcYK93O4cNDJq3pQf8TWYWPGh6AJVQ9ruEiNcsI/WqE4m+Bw8r2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8/iOo2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q8/iOo2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081C5C4CEEB;
	Thu, 14 Aug 2025 01:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755133399;
	bh=a9cPTPnhk0B0MV87JUqmN62I77LB1AsQD8P49IZxTR0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Q8/iOo2vkUI95kSX1lTlNIW+ts6FuOTThX7PWqgAwutXn3igOgWbCMwgfpbJhZ0ww
	 x9BU+gBEFcL+8523fkc/LUfo712nw8uIVL2D3Pl7gKaO96A0r9/TZKPVWuWH1cP77x
	 dACXvkJ1HMAJqEKQmr+zcp2UoK/Zi52LY5Q7yXmqvgunCu+TzJS8nf+qNz4JEv8QWg
	 Lf6WwMk3W6HaMGZmFEH2x1LLMSuLel3ZdRxcgzPrYuquOneksZkgMjY3oO1GAvAX62
	 mJpEWJlW0aiNmz7011j4uceFf2g83k9DCcq2vPIYXjczk6FnJpa2TKsS6SaxFqUD2M
	 1/HQqNPoildqg==
Date: Wed, 13 Aug 2025 18:03:18 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, ayush.sawal@chelsio.com, andrew+netdev@lunn.ch,
 gregkh@linuxfoundation.org, horms@kernel.org, dsahern@kernel.org,
 pablo@netfilter.org, kadlec@netfilter.org, steffen.klassert@secunet.com,
 mhal@rbox.co, abhishektamboli9@gmail.com, linux-kernel@vger.kernel.org,
 linux-staging@lists.linux.dev, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH net-next 1/7] net: Add skb_dst_reset and skb_dst_restore
Message-ID: <20250813180313.284432a8@kicinski-fedora-PF5CM1Y0>
In-Reply-To: <20250813175740.4c24e747@kernel.org>
References: <20250812155245.507012-1-sdf@fomichev.me>
	<20250812155245.507012-2-sdf@fomichev.me>
	<20250813175740.4c24e747@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 13 Aug 2025 17:57:40 -0700 Jakub Kicinski wrote:
> On Tue, 12 Aug 2025 08:52:39 -0700 Stanislav Fomichev wrote:
> > +/**
> > + * skb_dst_reset() - return current dst_entry value and clear it
> > + * @skb: buffer
> > + *
> > + * Resets skb dst_entry without adjusting its reference count. Useful in
> > + * cases where dst_entry needs to be temporarily reset and restored.
> > + * Note that the returned value cannot be used directly because it
> > + * might contain SKB_DST_NOREF bit.
> > + *
> > + * When in doubt, prefer skb_dst_drop() over skb_dst_reset() to correctly
> > + * handle dst_entry reference counting.  
> 
> thoughts on prefixing these two new helpers with __ to hint that
> they are low level and best avoided?

Looking at the uses -- maybe skb_dstref_steal() or skb_steal_dstref()
would be a better name? We have skb_steal_sock() (et.al.) already,
same semantics.
