Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78A430FF2A
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Dec 2025 14:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764943468; cv=none; b=EBEkWcPY2pwYBV+VDtk2RM8ViP+Hj3dNuCPjYADUyWYAekO1r4jEifpWm4Z8eH7A2OYi5FgWTM7r3GG93K0PLoomwGqNdEc1e6YMuIe/rXmV9jhpTxEgW7wdG8ejGr6oVHkhLdYo/ngTtOZR72Dph5nNS1Ni0H1OKG7BSGmw0qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764943468; c=relaxed/simple;
	bh=1eRwoHuzJ33g7WN1F4MVujC8eovAygj3LOZvjYd+Xlc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qWw0TAfgoUPM+gMxZY5DBxgQPyDyyGj1kz8D6xWPAMPsGhWhSR4pO77p6JPzGSM8NTW5+L0GszfQd5arEPqmhkTCQIhuvo++DNUFe+g2jkro4hmQAyGv7jTJ0Z8zrn/5//RNc4/hcjrfOA8+WxdpqlOJXw2bFEnyl4QyQ43UQxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id EC0ED60336; Fri, 05 Dec 2025 15:04:16 +0100 (CET)
Date: Fri, 5 Dec 2025 15:04:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nf v2] netfilter: nf_conncount: fix leaked ct in error
 paths
Message-ID: <aTLmYIdg2xQgrDsj@strlen.de>
References: <20251205115801.5818-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205115801.5818-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> There are some situations where ct might be leaked as error paths are
> skipping the refcounted check and return immediately. In order to solve
> it make sure that the check is always called.
> 
> Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks, I placed this in nf:testing and plan to push this to netdev
maintainers next week.
