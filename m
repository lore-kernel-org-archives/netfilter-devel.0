Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF806337BB5;
	Fri,  3 Apr 2026 19:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775245469; cv=none; b=sUt2HFDkIOIyE/iveXAmVF31YjBnviBFvfqNwezx3K2TWaOlSzjgkXkYxVpnSKetLHQBO4ypQN2F/Sr5wMXOcZRc/zg88K6bO71xbogtN9T1iq+XFV9Y9a28gsMP5Au5UJVqRXBiPSaCKm5dOiCChKBtoCDeYEofvudrlfYFcAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775245469; c=relaxed/simple;
	bh=R0dKMEEN+1FaU3xTIXRdqAmp6Y6V+svvcwk60Pu0QOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPNAeHdqwJwXCBifeD5qeeIhwsICplOMG/h2sP7yC8f8bJREsrErFRCO63eSYJedvayAq9/WdfXN6vGw6VysCr3ShtSPtNNDaErRkvfg33CIiZhnMK4igw/0CFtF5JHmk972NyXyQW67KP71namZhJZn7vhXdwjRS5XvTDj2c6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DE8AD60913; Fri, 03 Apr 2026 21:44:25 +0200 (CEST)
Date: Fri, 3 Apr 2026 21:44:25 +0200
From: Florian Westphal <fw@strlen.de>
To: Marino Dzalto <marino.dzalto@gmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Marino Dzalto <marino.dzalto@icloud.com>
Subject: Re: [PATCH] netfilter: xt_dscp: replace -EDOM with -EINVAL and unify
 match functions
Message-ID: <adAYmfP8XBYu-q0M@strlen.de>
References: <20260403185337.87676-1-marino.dzalto@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403185337.87676-1-marino.dzalto@gmail.com>

Marino Dzalto <marino.dzalto@gmail.com> wrote:
> From: Marino Dzalto <marino.dzalto@icloud.com>

This is where you add the explanation why you make this change.

AFAICS this patch provides no benefit.
