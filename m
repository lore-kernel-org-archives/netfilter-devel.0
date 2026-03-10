Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF6240DFC1
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 13:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773149193; cv=none; b=WHy/BgAP83Q+wTIFdo7pFglCdvaVE1cJ5u3XhVwyi6C3cKO+tYdAatCNCdaAW06Au7GPfS4ar2uAPgg/l41P6PWNsJluMXUGglT29VgFp+Qij4HbP4hLkS+TFg73kVkIe3YVPAf2Pb4Ua9DL09Gh1RZWQnFdYnml36JgXkQQymg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773149193; c=relaxed/simple;
	bh=0/Ia4Whajtv70iLXdWI5dMG8Uq0JC4uVnV+xrfkhciM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ix6pf0mR6Svl622TMCKJoTvOK3OogX2wH/NDmkG9pz7MbXVpAzYqSHHwzc3d27rYY+e8gw6GRFQqXMQBcLa15e7QuOuew567IYnAuf2Opq+hufW+ZAnazns1Ei+urJgBH4L16t4BPNGF1D/Go5wmr6KLTqJ/9sUaAfa15cOj3lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1A974608BD; Tue, 10 Mar 2026 14:26:30 +0100 (CET)
Date: Tue, 10 Mar 2026 14:26:30 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v19 nf-next 5/5] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <abAcBtV9WbEIDgCt@strlen.de>
References: <20260224065307.120768-1-ericwouds@gmail.com>
 <20260224065307.120768-6-ericwouds@gmail.com>
 <76b3546a-37c5-4dab-9074-4df0cbe48524@gmail.com>
 <abAOwZDmHjcLIbj1@chamomile>
 <f69a9456-5047-4044-aa8d-1bad3bd81f4b@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f69a9456-5047-4044-aa8d-1bad3bd81f4b@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> I misunderstood, as Florian pointed out he is waiting for a response on
> the AI generated review.

Yes, I also try to keep patchwork somewhat up to date.

If its not listed anymore, its been dropped from my radar.
If its in new or 'under review' state, then its still on my list
and I will get to it.

> I now understand it was not forgotten at all.

Well, it was forgotten, sort of.
I depend on patchwork tracking (and on submitters checking
back when they are unsure (so this ping isn't bad)).

Would it help to add a netfilter process document to
Documentation/process/ to explain the expectations and
nf specific patch workflow?
