Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6873628504D;
	Wed,  1 Jul 2026 05:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782882588; cv=none; b=GMfYXLlCwodXdpPzvjms3WRf6JuZ4L4xTjAWqCfaBzoEM65VScA/PXz3T1DJEiQbkXB49CzRUfBTAh58Rxjj/tP4AXdJOIXMk7Beh/7jU3ggAt0aGO3miVIQY7tQvo3DOMP18WLC1la36CoFWyG2+HtwTRdB0tcbangyFpnmy3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782882588; c=relaxed/simple;
	bh=YSsZg+c+BnNF1ejIYyeW42itqUAnXek/1ip1UwY7Hwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pkOUcuZHgg500gA1vxDrfh8DmahgsFH9i0vXsV2eLyC+72Yv3qEdac837kBPRaEu4RRM2DeesMXnvp+D3Q6qt96H+8kzr3s2BHYlerUsxZ7HLPvyP4FTcry5mGaY9Zu3nywuWu0wqN4OLwT9nwJPSL+dYEQaFE0O6bzseNjMo5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 49B456038C; Wed, 01 Jul 2026 07:09:45 +0200 (CEST)
Date: Wed, 1 Jul 2026 07:09:44 +0200
From: Florian Westphal <fw@strlen.de>
To: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org, xmei5@asu.edu
Subject: Re: [PATCH net 3/9] netfilter: ipset: fix race between dump and
 ip_set_list resize
Message-ID: <akShGOr3YKg1bs3r@strlen.de>
References: <20260630045243.2657-1-fw@strlen.de>
 <20260630045243.2657-4-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630045243.2657-4-fw@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> From: Xiang Mei <xmei5@asu.edu>

Xiang, Jozsef, could you please have a look at

https://sashiko.dev/#/patchset/20260630045243.2657-1-fw%40strlen.de

AFAICS it's correct but should be handled in a followup patch rather
than a v2.

Thanks!
