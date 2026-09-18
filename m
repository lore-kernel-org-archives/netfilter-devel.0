Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBC04AF67F;
	Fri, 18 Sep 2026 08:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721783; cv=none; b=LTD7X50Y5HZRjE08c7bnWUYsxeTESisT4WDLbGi+7yKEHUfCtVz4nHL2LrUvgkEPxU30v/oM1Ong1sp1gN4ElP/qyeoVoCmnOHs2KTTWyOxajTaBNCbnLiUkn2u/m1ortUvu6GxouwR0jXE8v2BVAoPQmQ9P/6VOcHeBE6obZF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721783; c=relaxed/simple;
	bh=fn48125rKcPC3pOW5NKUmZ9FAgGxT8YpuG96UZBY/dM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFX+kwhM3/7CitvKb8UJ5LROBC+/C+zd0VBe4BpCyKyx7oQ53jTqJcmRbUJ02dHGQMu1rbd+PpmvGAz5PjiWY9dGyE/2VgaUtgrmO8ZcvQZ7Zm42e83swE2IdytiIS/7CJKmnyjQohnMev0Wb/eloD8Q+dh9lD8IjPXRf0D62ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KJq2/or0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KJq2/or0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1789721778;
	bh=fn48125rKcPC3pOW5NKUmZ9FAgGxT8YpuG96UZBY/dM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KJq2/or0mWc0PhnolRAlSowcb5WkQlPCfyIbcgsCPdFNAL/NMj4qj57H5wTBmiPgs
	 ruJPVnsBiNrl4FhuYQ3tSqkUvyft5avsdSnk4avmkRfRjRj68JrfnnGt12H9ah+PN9
	 JNUtiR2e5HZsLB4nJKCFhdlDm9WyZM5s+GBMzjM9Kf/HbI8nZespKf/PelWchIuvLn
	 p9bg655I9pn+oA3qXPqTy/+zhyjgrZNERtQUDZohSZ9F3hxjTWFjohGcnAD1SMTilb
	 RdUg+Y/AC0BzHIr+yqH2szhRiuyAF4rybYR48xXg9HXSggY7Kt/agMfmWm4H5ynvt4
	 1Jkn9qKNitVnQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4F2D460052;
	Fri, 18 Sep 2026 10:56:18 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:56:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: my summary of LLM judgement in this PR [was Re: [PATCH net 01/10]
 netfilter: flowtable: publish HW_DEAD after worker is done]
Message-ID: <aqz8rw-6wovytXle@chamomile>
References: <20260916231652.127456-2-pablo@netfilter.org>
 <20260918020406.3513303-1-kuba@kernel.org>
 <aqz4cRSbfcJI1Gvs@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aqz4cRSbfcJI1Gvs@chamomile>

Hi Jakub,

I will be posting a v2 of this PR in a few minutes.

LLM found one real issue in the last, it also refer to two
pre-existing issues that I can address.

One of the reported pre-existing issues in nfnetlink_queue, Florian
hesitates if it is theoretical.

Julian also wants to send a v2 for its IPVS patch to ... write a
better commit description to please the LLM, it seems.

In summary, one real issue in this PR I would say, which is my fault
because I misguided the patch submitter.

I'm sure these tools can help us get things better, I understand too
we have to try them all so we can evaluate. But I'm starting to wonder
if it is worth stalling the pipeline and retrigger a PR continuosly,
when we can follow up for those that we deem to be addressed.

Thanks.
