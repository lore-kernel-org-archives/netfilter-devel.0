Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289343EFD00;
	Tue, 20 Jan 2026 22:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768948615; cv=none; b=KQNefdsOisotOa7ZSjZP1THosjiLs1Iovu3U2Pj5UlLzMWbpoupZgag+gp7gpobmlxgmBMWPRuxAhJbynjT/iSarnWUDBpzDdtX68EQJIZroRl5kozo+AFx2d7mGMmEvJjIp5xDYZbT5xERm+7UKy/txtJfT+RYz2SPCb5lOopo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768948615; c=relaxed/simple;
	bh=1+Hjze2npYaFHb/6Dg7nq8s4zL+x2G5RZM4zTw37/uM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nBMEnqxm5+o2e886BKGm12CW6wv9v+UPA2Buqt7DWymfvYFhLivLoNpB1FS1HvSS3IS/t3nvE5cgFaRj1Wua8qZya4q/Dm2WEqW+LhkoelyJb6wKNpX6IZA+wA3kvD2p7a0LsNPkCK4c43Je9R0XEhoznJpt5zkiWYUkmq9yEKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 860BD602AB; Tue, 20 Jan 2026 23:36:50 +0100 (CET)
Date: Tue, 20 Jan 2026 23:36:50 +0100
From: Florian Westphal <fw@strlen.de>
To: Aleksei Oladko <aleksey.oladko@virtuozzo.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: netfilter: ensure conntrack is enabled for
 helper test
Message-ID: <aXADgghgiSBxYJpf@strlen.de>
References: <20260120220103.327771-1-aleksey.oladko@virtuozzo.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120220103.327771-1-aleksey.oladko@virtuozzo.com>

Aleksei Oladko <aleksey.oladko@virtuozzo.com> wrote:
> The nft_conntrack_helper.sh assumes that conntrack entries are created
> for the generated test traffic. This is not the case when only raw table
> rules are installed, as conntrack is not required and remains disabled.

If that were true the test should fail, it calls 'conntrack -L' to check for helper
presence.
