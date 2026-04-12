Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4012D8DA3;
	Sun, 12 Apr 2026 16:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776012050; cv=none; b=EGuGuMbohm9wnNghUDpiinx0xkCKapXklyOHkWTgMWRARnqScYn1H/MiTuVlwlbCQYMAJ4kEEeGazJ4Hr/KV6M17vKLMNeYR1bW9xPtqxjI904GBC+2Pr/+zFfJjNH5ytAIZzCndEuHi3OTBQJhImjiGAgq6zqe3gPShHdjuMys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776012050; c=relaxed/simple;
	bh=ykRAjh4Mbm+RQZsA622iVwa8kSHurZM4yvHxPWyXMOg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OSJALhycFhZfG474z9QlLaIEvjZGYZh07jXNTP0JaxJyKGOfALpfWVMcBZTTZT+QgDCYsHgFbJWKqv9nzct2CiOTHsmffawGA7dtKnWE0lTMBpm+SpjETfd9i1Lbhte4ibH2AFy9AuGdcEllHSZEU4E5UxbPekCU6XpRmQ5eZiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Myz7zT68; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Myz7zT68"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FF55C2BCB4;
	Sun, 12 Apr 2026 16:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012050;
	bh=ykRAjh4Mbm+RQZsA622iVwa8kSHurZM4yvHxPWyXMOg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Myz7zT681VuNeAfdBI70mvcxOObfrrmFEmOY8P45FWvGa1Cjej3MzDs6s/2CbzU04
	 oLr5xFJTLov29g2ePdP7BVXJ1nhS8hcOpPRAiafA7NJu2S9hiyjvL/YX3KeyoMV+dE
	 LlK0Nd+wTDcho/dgVj6HFAo61DPL+bT+hHE8tADLRvRfRhn6Rj9mSfbUAOpZqNOoj9
	 9sASdZ0nvT+nUysadSzL8AwwIgl4rC8lHs5yecxYhijLu4iiN9DY3czWmbeI/CUR7T
	 nXKI7v7jbcLcyMqDGlFIetadScrX7uVcAUx+h6p3Yj7hWa8QPnAhF0JJiqf9LyKtCv
	 HxfjWoOx0dErg==
Date: Sun, 12 Apr 2026 09:40:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 <netfilter-devel@vger.kernel.org>, pablo@netfilter.org
Subject: Re: [PATCH net-next 00/11] netfilter: updates for net-next
Message-ID: <20260412094049.7b01dd7b@kernel.org>
In-Reply-To: <20260410112352.23599-1-fw@strlen.de>
References: <20260410112352.23599-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Apr 2026 13:23:41 +0200 Florian Westphal wrote:
> 1-3) IPVS updates from Julian Anastasov to enhance visibility into
>      IPVS internal state by exposing hash size, load factor etc and
>      allows userspace to tune the load factor used for resizing hash
>      tables.

Someone should take a look at the Sashiko reports for those, please?
