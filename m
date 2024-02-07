Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09B25569;
	Wed,  7 Feb 2024 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.237.130.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707301655; cv=none; b=lf7t+LQ5hEtyAgRFFI9iaAOVpr9cFxucndHDLihfzVF9M77I15JmpiOwmeFrh89q5tZ8AR93W7tqHRKt5Wd52VJTeocwhfiiBD0Z0QvzCBVXe6bXslh/+8T3FXa35uuQp66z/X2sBr4eDJliCj2ZMdSCnWuBl59OLxtkh65vuHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707301655; c=relaxed/simple;
	bh=gyXT7kHm+VgTEEpItBch3H7VFzSe5+2oZspO1evS+sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XiQLArAt6YNBMTmfiwgGvVOvMpDB7dYsI98bM3my5cuFenR2n8lOV0zwpRuCPLN/4/YgTgipNCV7ooox97pv0b/tJt25Mk/o/gE143nMZVAcUyqv2ZH7i2Y7jobUNhgBB8+oSJCvkLufVONm97/ZbZhBstKINZd9pwkpe5dt5rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; arc=none smtp.client-ip=80.237.130.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1rXf9N-0003Ga-EQ; Wed, 07 Feb 2024 11:27:29 +0100
Message-ID: <07cf1cf8-825e-47b9-9837-f91ae958dd6b@leemhuis.info>
Date: Wed, 7 Feb 2024 11:27:28 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] netfilter: ipset: Missing gc cancellations fixed
Content-Language: en-US, de-DE
To: Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Ale Crismani <ale.crismani@automattic.com>,
 David Wang <00107082@163.com>, Sasha Levin <sashal@kernel.org>,
 =?UTF-8?B?0KHRgtCw0YEg0J3QuNGH0LjQv9C+0YDQvtCy0LjRhw==?=
 <stasn77@gmail.com>, Linux Regressions <regressions@lists.linux.dev>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20240204152642.1394588-1-kadlec@netfilter.org>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <20240204152642.1394588-1-kadlec@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1707301653;bc2a2b27;
X-HE-SMSGID: 1rXf9N-0003Ga-EQ

On 04.02.24 16:26, Jozsef Kadlecsik wrote:
> The patch fdb8e12cc2cc ("netfilter: ipset: fix performance regression
> in swap operation") missed to add the calls to gc cancellations
> at the error path of create operations and at module unload. Also,
> because the half of the destroy operations now executed by a
> function registered by call_rcu(), neither NFNL_SUBSYS_IPSET mutex
> or rcu read lock is held and therefore the checking of them results
> false warnings.
> 
> Reported-by: syzbot+52bbc0ad036f6f0d4a25@syzkaller.appspotmail.com
> Reported-by: Brad Spengler <spender@grsecurity.net>
> Reported-by: Стас Ничипорович <stasn77@gmail.com>
> Fixes: fdb8e12cc2cc ("netfilter: ipset: fix performance regression in swap operation")

That afaics should be 97f7cf1cd80e ("netfilter: ipset: fix performance
regression in swap operation").

Side note in case anyone cares: I first didn't add the problem to the
regression tracking as I assumed the fix would get quickly reviewed and
merged to mainline (for some patches going through -net that's the
case), but now added it as nothing happened yet.

Ciao, Thorsten
