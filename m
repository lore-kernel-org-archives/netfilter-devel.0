Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C525208D0;
	Sun,  7 Dec 2025 01:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765072297; cv=none; b=S10ipWn1Pvspm0D8Kt44XDWmyQA97B/799Bkw0k0LQHT/xql8V1UttNSq/v9qr+3o1okwG+yZ+Tw6ASWkQgnt/MdjR/rD7ha5TJT0MyutW1FgAUcJ2R2Qqp8maaosGWRvqLMV7KAgS0kWo64B2JwW990SrGRtcISleC0OXxHM9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765072297; c=relaxed/simple;
	bh=p6T4Cb6qYjPBXnqpTIXJ99LC4w8TAvfaEGhUElzK7q8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=bW/OilsyGAUoivKz5WrW9/PIryuKxk1coujLtS3Ete96X6/PvZsdrnlLTErGQFz2eXxsJ3FoQWQdgEzWbstA47IqHNOiSSvxLQ8GmfjjsVTstXeGKJycQjuj5EsKMPND2FnHL+0aM+AEL9716/Tmxyi7nYmgu6jjDFszKcZAx9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXQ9o9Su; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXQ9o9Su"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6209C4CEF5;
	Sun,  7 Dec 2025 01:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765072296;
	bh=p6T4Cb6qYjPBXnqpTIXJ99LC4w8TAvfaEGhUElzK7q8=;
	h=Date:From:To:Cc:Subject:From;
	b=QXQ9o9SuBE/pbxUv8eRa6+om+EBFlpXPdkB3B1+itUtdm6Bf2qM+DnD0Mf3Q7cwCe
	 5fmGXIp7PQt9yGz8eoWjT+e4H2dVCn6kohgHX/Rm2er8zBG7vhmB3cq/S91kyB+0o6
	 O2o2FtVfBSgsLKs1vGWzdgLrAhA8k+1ZkDG7fxyxYtxxDdnbiek+VvjfFcYQHeUjy2
	 foxyUIiMtkotb2NnMM5HjbCWnPA9ABmhDEOqmtbD5e+oyjsS2ogCcCM8Tv+AZecE3y
	 pxaUr4yPDwnGZY522f+wwwmTBEZEMqI6tCmv22mVMtEA91fXQMat/bJwv6bOMoOheo
	 i5lUneSBAi4lA==
Date: Sat, 6 Dec 2025 17:51:35 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [TEST] conntrack_reverse_clash.sh flakes
Message-ID: <20251206175135.4a56591b@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Florian!

We have a new faster NIPA setup, and now on non-debug builds we see 
a few (4 a week to be exact) flakes in conntrack_reverse_clash.sh

List of flakes from the last 100 runs:
https://netdev.bots.linux.dev/contest.html?pass=0&test=conntrack-reverse-clash-sh

Example:

# selftests: net/netfilter: conntrack_reverse_clash.sh
# Port number changed, wanted 56789 got 5950
# ERROR: SNAT performed without any matching snat rule
# kill: sending signal to 16051 failed: No such process
not ok 1 selftests: net/netfilter: conntrack_reverse_clash.sh # exit=1

Looks like the test also occasionally flaked on the old setup ("remote"
column with "metal" instead of "virt") which is now shut down:

# selftests: net/netfilter: conntrack_reverse_clash.sh
# Port number changed, wanted 56789 got 54630
# Port number changed, wanted 56790 got 25814
# ERROR: SNAT performed without any matching snat rule
not ok 1 selftests: net/netfilter: conntrack_reverse_clash.sh # exit=1

so this isn't new, just more likely now..

Could you TAL when you have spare cycles? (BTW the new setup is owned 
by netdev foundation so I can give you access if that helps).
