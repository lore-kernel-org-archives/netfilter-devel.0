Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBF313BC2F;
	Thu,  6 Jun 2024 08:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717664037; cv=none; b=Z+B6H6xrxUr/+bdVrkTjRHD8rKkMjq5Xmjsf6ZgTwxOtKdajGMov6/idMoNNW3A8XUQ6dR2qtoSAWdB+gw5i/3u0cw97n2DiVvKgqLcQ57McgAhfk9MCzNmZIyGWElSbvLhzvUoiOD1u3FNPuxR3QSGMQMIV5Cst2tRgUeUgmSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717664037; c=relaxed/simple;
	bh=0vyITlsHbbFTeMaFtRqzmj/X30e3NP9hfIfh6whAf80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuiMTBj7LB1jc9nUvkEIT6LKkMW9+x9LJ9J/FoMB1eMGYlUwKJC+piakv9NFVaLjN1gpAnERr06JDviB2e4N8hjQWvJcH0QroMqiYPzL7GW6o1Gfxs5U0roVSsLBNRU/r5N5MazFL550j/94yEjLq9wLajGa8VWAJ7yIsbqIjE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sF8sa-0001Uh-OG; Thu, 06 Jun 2024 10:53:52 +0200
Date: Thu, 6 Jun 2024 10:53:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
Message-ID: <20240606085352.GB4688@breakpoint.cc>
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
 <ZmAn7VcLHsdAI8Xg@strlen.de>
 <c527582b-05dd-45bf-a9b1-2499b01280ee@6wind.com>
 <ZmCxb2MqzeQPDFZt@calendula>
 <1eafd4a6-8a7e-48d7-b0a5-6f0f328cf7db@6wind.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1eafd4a6-8a7e-48d7-b0a5-6f0f328cf7db@6wind.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> I understand it's "sad" to keep nf_conntrack_events=1, but this change breaks
> the backward compatibility. A container migrated to a host with a recent kernel
> is broken.
> Usually, in the networking stack, sysctl are added to keep the legacy behavior
> and enable new systems to use "modern" features. There are a lot of examples :)

Weeks of work down the drain.  I wonder if we can make any changes aside
from bug fixes in the future.
