Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34808142E67;
	Thu,  2 Jan 2025 17:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.212.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735840525; cv=none; b=LEy+/zcPePG6Dj13AG2fKlIM6PuMRqlO1+cc1AFm+Ujy565/DRuWPkhy+KUDkuR8+qX/wLvOjuhNjSS6g2t3GFFBtPaE1GFiCI6b14O8zrIrnipP6vcwcJZkJmMTRxMXbU9JSuKdTf2OpnVErfnV8oEUyeqEAw46tWXubO6cv+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735840525; c=relaxed/simple;
	bh=buN6q+P/VvAMepaeTXXz6FtqlFIdScxLboX7dCpO3Yk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=pLyKtUI9PoHgzyULtf+l9bBXJ3oAHZl5zyEx6kUTuu1wqmUQUThehiRcwFD0259ksBQru7YG9n/uxGeqhYmdGKkdgNgScEL11+wxNrD1mJ/5vvKe3AVEYhncCQ7xtwsA8DUludiONG1SynzUVtretjAX9KKVhkovqq2fmhP8cU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de; spf=fail smtp.mailfrom=inai.de; arc=none smtp.client-ip=144.76.212.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id CEE261003D14F8; Thu,  2 Jan 2025 18:55:19 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id CD21D11006526F;
	Thu,  2 Jan 2025 18:55:19 +0100 (CET)
Date: Thu, 2 Jan 2025 18:55:19 +0100 (CET)
From: Jan Engelhardt <ej@inai.de>
To: =?UTF-8?Q?Benjamin_Sz=C5=91ke?= <egyszeregy@freemail.hu>
cc: fw@strlen.de, pablo@netfilter.org, lorenzo@kernel.org, 
    daniel@iogearbox.net, leitao@debian.org, amiculas@cisco.com, 
    kadlec@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
    edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
    netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
    linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: uapi: Merge xt_*.h/c and ipt_*.h which
 has same name.
In-Reply-To: <20250102172115.41626-1-egyszeregy@freemail.hu>
Message-ID: <0qn5r7sp-ssr2-p10n-0816-p771s94p8086@vanv.qr>
References: <20250102172115.41626-1-egyszeregy@freemail.hu>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2025-01-02 18:21, egyszeregy@freemail.hu wrote:
> include/uapi/linux/netfilter/xt_CONNMARK.h  |   7 -

Same problem as before.
You have not addressed the fact that xt_CONNMARK.h _cannot_ go away
(for a case-sensitive POSIX-based system).
