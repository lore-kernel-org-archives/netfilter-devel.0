Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01447173;
	Thu,  8 May 2025 00:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746662679; cv=none; b=jT3IcbQ4BFp9jybFakmTlEezD/Q/28ZEdMLW0GVZneiTaBKDUUiG9ZMfDVBUA9ilBoKw32/Hfcw9veisONxoYRJH80xihPqbCMQXVqVNk76o+0LqH4i4eb/HE59ydKuZP1xe5N5y9ulosMR749Frg1cU0cgxuv0YjIqH4m+5t8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746662679; c=relaxed/simple;
	bh=tsLgvYDsTTn+lct3eqEnQ/C8qUE0TseZs2FG9kGs7CM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V/LCqRrtB1hp5IzfKNQFkmryPLt1qhXms6oRpCh0aNzy1uqoww/JE6r0ry10LQfTbvUXMy1H9osgf7nFqMd7Ie6Qo/pySyXnt2o3PBelzGuo07IYBtu8xzcDzVRAR1Ogs09IaT3K97+dVyt2ls+qExEJYfD4kbLpZrOfnK9qK0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vBP5QAph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vBP5QAph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38E0DC4CEE2;
	Thu,  8 May 2025 00:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746662678;
	bh=tsLgvYDsTTn+lct3eqEnQ/C8qUE0TseZs2FG9kGs7CM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vBP5QAphIOZhc0/9eanPXFDZGo2w2PWFEdUtiVPdkAqX0wYBYhksdk8T99e6pBjFJ
	 oa/VnQTu8DQoVlMwTTUExAxsQvicOEPzn4OyX/jChihxE7VaA0VMZmETVPuGOMaXkZ
	 8Ao4lt5jVSB26MiuVU04rvBlR2eLi7AV6ypOHnqLNX5Hekof4sQ7XtSsMCRmZTDXpp
	 mmG7MiQmAI8Zwb1nPrTQZgKd2J0j56OLLdFpC6xGlxuqDxEZD8Z51AcfpMytLOECRL
	 ljhWSboSxyjRbQ2DST4jIQlJjr6hQ3x45Cv+42n4dednWBtBU3gv7ofG3BJdTeb5vk
	 OS7m6whGm9NGw==
Date: Wed, 7 May 2025 17:04:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, netfilter-devel
 <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net-next] selftests: netfilter: fix conntrack stress
 test failures on debug kernels
Message-ID: <20250507170437.0ed28860@kernel.org>
In-Reply-To: <20250507075000.5819-1-fw@strlen.de>
References: <20250507075000.5819-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 May 2025 09:49:55 +0200 Florian Westphal wrote:
> Jakub reports test failures on debug kernel:
> FAIL: proc inconsistency after uniq filter for ...
> 
> This is because entries are expiring while validation is happening.
> 
> Increase the timeout of ctnetlink injected entries and the
> icmp (ping) timeout to 1h to avoid this.
> 
> To reduce run-time, add less entries via ctnetlink when KSFT_MACHINE_SLOW
> is set.
> 
> also log of a failed run had:
>  PASS: dump in netns had same entry count (-C 0, -L 0, -p 0, /proc 0)
> 
> ... i.e. all entries already expired: add a check and set failure if
> this happens.
> 
> While at it, include a diff when there were duplicate entries and add
> netns name to error messages (it tells if icmp or ctnetlink failed).
> 
> Fixes: d33f889fd80c ("selftests: netfilter: add conntrack stress test")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Closes: https://lore.kernel.org/netdev/20250506061125.1a244d12@kernel.org/
> Signed-off-by: Florian Westphal <fw@strlen.de>

Great! Run 6 times since and 100% green. Thanks for the quick reaction.
