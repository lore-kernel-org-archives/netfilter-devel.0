Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1B02BDC0C
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 16:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758989231; cv=none; b=nXwa7lRg9dkr/sTxnAAaDD2XXA7RoR9egZlYZjrJ6oJDfo2pilzKNAHMS98wLeom13p2rbVRofLUVcEvRIS6AkxcPEmjpUxxuTjta/pHFyniYcrqcC5TuymUMVLxxBtUCRUsnjDXSdOTnprhG8yQUVTFkTRzFwTvQiNTXiJQMDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758989231; c=relaxed/simple;
	bh=wnfmHJlJ70W8+AW5lRw7CxAoVR/869ID+pWSQXjS3w8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUa3h4M2azMgTbnh45m0unGl/wPIgJj3V/XDYgfxfoRB6dD0CDa+xviiSZsBGXmBqxefX0h4cbkyY/6ZsiVJLg5wrwFwHJaGsgVUWfyc2f+Vg2U3d+X9Nt6hhK4PLVXHjP2YLZdT+6R+br37PTuQShBP0Ysa6Xn3y+0r0PANPcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpNUjKzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpNUjKzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849B2C4CEE7;
	Sat, 27 Sep 2025 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758989230;
	bh=wnfmHJlJ70W8+AW5lRw7CxAoVR/869ID+pWSQXjS3w8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cpNUjKzcsydjg9AEv7v9aG+PuOcKTRzK99I0VoOcUr2osdHxFCSqqxCofflNTESMI
	 FxwHR8YAjq8+BUX1XZmuIQoMlPO3dQSQBCFUkIac4n5cZVFCb1eKr5jHmjiU7bE7QD
	 /HHA+/P1jNDHNteRN73Vk3az3dJcxYaTPdJ1g96HuGd1D2qzYkjb38UmvNIgT4jFqQ
	 8/473LOciTabo46BnFD6LJSCWz/D0fltVYcmaOtvug1AY8I4Y+1kWPm1nVtflbtTdy
	 E/rX7HG50DbN8GClx9vWTXPj5MYqD+kJzAvR9MNZpxSC7hChINmMw/C009rCchCTx0
	 7QnL86FrZG19A==
Date: Sat, 27 Sep 2025 09:07:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [TEST] nf_nat_edemux.sh flakes
Message-ID: <20250927090709.0b3cd783@kernel.org>
In-Reply-To: <aNfAv4Nkq_j9FlJS@strlen.de>
References: <20250926163318.40d1a502@kernel.org>
	<aNfAv4Nkq_j9FlJS@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 27 Sep 2025 12:47:27 +0200 Florian Westphal wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> > nf_nat_edemux.sh started flaking in NIPA quite a bit more around a week ago.
> > 
> > https://netdev.bots.linux.dev/contest.html?pass=0&test=nf-nat-edemux-sh&ld_cnt=400  
> 
> Weird, I don't recall changes in nat engine.
> I'll have a look sometime next week.

Thanks! Sometimes tests flip from flaking to not flaking after we pull
from Linus after Thursday's PR. There's probably an intelligent
explanation to this but it eludes me :$

While you're looking, nft-fib-sh also flakes occasionally:
https://netdev.bots.linux.dev/contest.html?pass=0&executor=vmksft-nf-dbg&test=nft-fib-sh
