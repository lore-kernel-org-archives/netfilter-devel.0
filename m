Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A6C749C;
	Sun,  6 Oct 2024 00:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728174517; cv=none; b=TByYBtsrC0yqq0GmwWkJzgXhYEgbe0KJ29lMAjGro7eJVFr2qzmKua28RcyZqkOKItVNW75eDCJOJ0cXRknRhow3DfoJyXaNSAsIjjdMlufq0bzmxAgteFGwPjhFUTZVR3ung3Ff52for16EHjdq9TnsWnbvyhpe40ksXXLr050=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728174517; c=relaxed/simple;
	bh=msK4PyFxyLJqk2iRjq18icdvb7lMwHkPOHByGpZdx1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQlirKVRxP49xwNGhq4cyR4S6nrI77mHYwCp3X8Yhd0I2BGwfCtE342k++B8eSxCGD6XHdubnQPguJbVfyB3fD2hf0I86jsWQsXg7JuG3YlAQsVvC/EdMABWKktQpZ+XSypuKXKofB5LSfWx4EEURjc7veba/Vwq9mnnfpqouX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p36XlHIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p36XlHIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5A7C4CEC2;
	Sun,  6 Oct 2024 00:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728174517;
	bh=msK4PyFxyLJqk2iRjq18icdvb7lMwHkPOHByGpZdx1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p36XlHInlhsHeolBwaUesQ4VHvJ3t7BgLR0g5NiujmQ1kOi3ceRQkiJYduAQ0XaIU
	 6M02Xon6HSZDx6u9zll9EJ/9fHBy6EzETCnpHrGJgUA0EYCDc+p2Ki4hnvSkV51g0m
	 7URgkiUhxQSYJ20lVLXp219jDSpNclpkIz3HPLRRCkhULwIziDf6CCGvYc0bT1uHMG
	 KaU5PPxO7EsQXpaPfwDYsVakyjDXkVmTX9T/ujbJ4jjrjo0iv2YhPPjm6+Sz6n1j3y
	 Xc8E6pVzYpiy5bHe0XIqfJINAqm+zIESYIHgdUelaMC4ZT2Frp6GqnftX9efOvUnA8
	 t1rXPaXu+ohag==
Date: Sat, 5 Oct 2024 20:28:35 -0400
From: Sasha Levin <sashal@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.11 049/244] netfilter: nf_tables: don't
 initialize registers in nft_do_chain()
Message-ID: <ZwHZs99aQl9FP7v-@sashalap>
References: <20240925113641.1297102-1-sashal@kernel.org>
 <20240925113641.1297102-49-sashal@kernel.org>
 <ZvP6-utbwqWmP5_0@calendula>
 <20240925122041.GA8444@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240925122041.GA8444@breakpoint.cc>

On Wed, Sep 25, 2024 at 02:20:41PM +0200, Florian Westphal wrote:
>Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Hi Sasha,
>>
>> This commit requires:
>>
>> commit 14fb07130c7ddd257e30079b87499b3f89097b09
>> Author: Florian Westphal <fw@strlen.de>
>> Date:   Tue Aug 20 11:56:13 2024 +0200
>>
>>     netfilter: nf_tables: allow loads only when register is initialized
>>
>> so either drop it or pull-in this dependency for 6.11
>
>It should be dropped, its crazy to pull the dependency into
>stable.
>
>Is there a way to indicate 'stable: never' in changelogs?

There is a way to indicate we shouldn't pick something up with our
regular flows. See
https://docs.kernel.org/process/stable-kernel-rules.html#option-1.

-- 
Thanks,
Sasha
