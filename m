Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160271CEAD5
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412517; cv=none; b=e1b68Dcyq3EUTyYpfC0FougNnxKwY2TPvTIZDRS/hb95gh6wei367UAjiQZepGgD92lMv9SJkB23URbEgyiRzRdvz9eIlHYnZ+Vl2L6FgGW7+yd61/XI0yyXhb8xVPcaceeF9o9hiZEOW6flfWk2/r61JgSBP1WC4hiZqiDrjqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412517; c=relaxed/simple;
	bh=TKRclqnnG09NG8MpGfRUqO25Wx878spKvl6m+ws43Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7jSj+mzOhkRQDL8uPingpBK/tYls7D8j2NVYRiroyQDlWVjbHyCqiZ8JMw+vxFjmPAtnUiubzBluz54TdYhjBzmYfnk7HOSr2KTEQFfaStrbyFO1ATnX4VSoeeiFa7eUbmn9tz5Xc5Qh3r/ylETcVQxyN9MoAfV+h1q3Kgl/ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6dL5-0001OR-L6; Thu, 31 Oct 2024 23:08:23 +0100
Date: Thu, 31 Oct 2024 23:08:23 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/9] Support wildcard netdev hooks and events
Message-ID: <20241031220823.GA5312@breakpoint.cc>
References: <20241002193853.13818-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002193853.13818-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> This series is the second (and last?) step of enabling support for
> name-based and wildcard interface hooks in user space. It depends on the
> previously sent series for libnftnl.
> 
> Patches 1-4 are fallout, fixing for deficits in different areas.

These look good, happy to see typeof support on json side, feel free to
push them out.
