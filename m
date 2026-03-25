Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1F43E1228;
	Wed, 25 Mar 2026 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774460594; cv=none; b=WlLKbPgrdJdm8FcSMZC34DFYsJXJpFeU5LPA5dZUlzkOoAClA5A9Ps6iAttErd6GK6y2ONoyCP/I0bo0gV2c8DNBmBSlFVTBmQYvTenGMX28bNlXw/bU2faHZluGARK1GML3kP4dY96+imRjrA8qlbhbfZJhtm/490lq9lUGEcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774460594; c=relaxed/simple;
	bh=9nOzvTOWDYHYjqWZEIDiCZjN6zoOgRNM98wjdmmg10M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HzFFNBNlSeuKf1ik+DC1wAgV3LgdEBv81beQQxKUhrKkS7SNgzRyrTfkz+FJp3leuQ7dBoyoajRyZcae5qXRkj5yZlmMxvNvXu5VacpqAtIp2PRm3ApBN62zdVn0H/P33u45Yy9EVXwUw2aNhnVkic2/BN4uWXj0E9Nr09eQeiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7D32D608BD; Wed, 25 Mar 2026 18:43:10 +0100 (CET)
Date: Wed, 25 Mar 2026 18:42:50 +0100
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Subject: Re: [PATCH net 00/14] netfilter: updates for net
Message-ID: <acQemtlq03AZvjL7@strlen.de>
References: <20260325131108.23045-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325131108.23045-1-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for *net*.
> Note that most bugs fixed here stem from 2.6 days, the large PR
> is not due to an increase in regressions.

please toss this.  I'm not sending a new PR.

I hate my life.
