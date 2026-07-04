Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3512B433E7A
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2026 06:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783146810; cv=none; b=no+APyNSWxsjnoqL87TGnDk20VO/GzgKtkFQC/hXInHxwRDpRgpZf0TVWzKDKfUMUFORu/ylTGySFlyunU5Aan0QDpelxi02RA4NSnDK0eY4KyhLYohAvV6aqBkH1awtJZtfrzg/fqa8joySLiCVSYh6IeGzSCPrri8PjgSpWZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783146810; c=relaxed/simple;
	bh=T5SF1J7aAnQN//4ZhgRnXa8Snz3OmZlhjDy1Vpk1s+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=niZrnLdkNKsiVyIrcvOV8Ql2tRmlcOljTYM0gOPmehuRzS8r/xiTmmwuq+bFTI1OtGEEcpF8VzvTfLgyvyCEjkiCFoTBxFIyIPzryCrhYY0JjjcnjOPVjTIhmoidh9Xd3eltnAOPj7+NIZPq4ipfbaWyolUckSIMixXYaPqbaP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3E2B46038C; Sat, 04 Jul 2026 08:33:27 +0200 (CEST)
Date: Sat, 4 Jul 2026 08:33:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH net-next 00/12] netfilter: updates for net-next
Message-ID: <akipL8JELutFTGoo@strlen.de>
References: <20260702105003.13550-1-fw@strlen.de>
 <5439da45-f8f5-4fea-a21f-580c753a188c@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5439da45-f8f5-4fea-a21f-580c753a188c@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> > 1) Update nfnetlink_hook to dump the individual NAT type chains
> > instead of the nat base chains to userspace. From Phil Sutter.
> Sashiko gemini says that patch 1 may require a follow-up:
> 
> https://sashiko.dev/#/patchset/20260702105003.13550-2-fw%40strlen.de

Phil, please follow up, thanks!
