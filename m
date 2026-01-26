Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6533AD90;
	Mon, 26 Jan 2026 13:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769435798; cv=none; b=FO2Deyrzn4OiweA+zm80iltHzfLCJnoHGFHEJIMgbp9rNwmkEwVm7DVCN3RtoyWKd9g1KumFkesICld5IiRnc6k96Le2Oo0ekISQPxfJE92Us2hSRAneTL61mAIJ3/LhPds86FM41A0c0J3ljY7jlO6cv+d1wkrlgmq3gThrwDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769435798; c=relaxed/simple;
	bh=04a/VV6VOmIqWD5Ds4BSeW2LLTscE1DzMTZgVcCLQ7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQ9+5vQaw8m7aDJ1BJdoyXLCTRLgHWs82TWurUaaLhyO7Ov3d9VgB71G1l48wpCm3DyY7zqR6dis8/CHAu4XKPw4C9XAz7TTGc2AA+4+8vGBItGPFt6cLRPi5vJNBVggfxepntFkvCCOEzvDCbPgPw95/C4tHTHPXpIrjuOXs0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzYV1yNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzYV1yNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BDFC116C6;
	Mon, 26 Jan 2026 13:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769435798;
	bh=04a/VV6VOmIqWD5Ds4BSeW2LLTscE1DzMTZgVcCLQ7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KzYV1yNgmvuvADWNKqbnyENwBhcMumCmSutGhY22rioGcEBGF+n27MPP98HjU5QSe
	 CHC3Ko8o64gvk8IN+2WKsG5gmhvv0Z7NndRvu3TO4T6uIiw7EwDLMPkULf1X/skWtG
	 qewKnenKjv0QMLvjcw9jRqrWf6aSo4Gh0A8yaSY2Mxt0+17hF4dHlMGvHK+WFYzTZr
	 eBg33pEyA3amS1R3YVSghXig+W/wWO/AHeWrI8ya4J/yt5A1j1jbXjzyqdQlSlCJRm
	 q9zirG3UgzzwAigAZEBqi2G8Cgv0SZQkA2ynGuxNeyod4G5b+p0UDwp387jU6gEvUC
	 Kjvj2Wl2VMb6A==
Date: Mon, 26 Jan 2026 13:56:33 +0000
From: Simon Horman <horms@kernel.org>
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: xt_time: use is_leap_year() helper
Message-ID: <aXdykTYHStzwgNTt@horms.kernel.org>
References: <20260123081051.336239-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123081051.336239-1-ruanjinjie@huawei.com>

On Fri, Jan 23, 2026 at 04:10:51PM +0800, Jinjie Ruan wrote:
> Use the is_leap_year() helper from rtc.h instead of
> writing it by hand
> 
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Reviewed-by: Simon Horman <horms@kernel.org>

