Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D017266A7
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2024 12:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710420978; cv=none; b=lsEHaZG86il50SqgE/Ih4zy5YEVRA5ec9CibS3UByG3vUfN95XjmUSXZdEy8B2xDzVR9aX/5clI9OJiSg23L4QuWmu701PwowLxScy+wKP0EZEE6N44oQo25xMMYy5732XMC5gcymcLyNMYrX7U7gn6GEyziyQk0XcNekrDJZwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710420978; c=relaxed/simple;
	bh=3nfmXhGwj/u4nanqdKEbQoSxuZPbj0TkVpNy/oaEeS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddnz73oLTIDQPdUkWbRhaDw4q26UneMyx+O+QH1uVHwa9OmrePdVZHU9hP8lJUG1YaLEa903U7wAF3QcH7hhykKhbODmA7x7nik8Cuy+3xgVCu4UBivzrEVIOmVKXIP8x4aqaB/LnWz0+SAklDNKPiQO6eiYgwwyu2UdvXqqZYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 14 Mar 2024 13:56:12 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sven Auhagen <sven.auhagen@voleatech.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: Flowtable race condition error
Message-ID: <ZfLz7NEwUnY_BEYZ@calendula>
References: <x6s4ukl7gfgkcap6b56o6wv6oqanyjx4u7fj5ldnjqna7yp6lu@2pxdntq2pe5f>
 <ZfLc33WgQPKdv2vG@calendula>
 <2lv2ycmvwqpzw2etorhz32oxxnzgnpmi7g7ykm3z5c2cnqcilk@zmixunfs4sjz>
 <ZfLv3iQk--ddRsk2@calendula>
 <4tq2bj2nylpqkkqep2v47dnb3nfismzbdzv42jj2ksdll4figl@scwfgkdwyuks>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4tq2bj2nylpqkkqep2v47dnb3nfismzbdzv42jj2ksdll4figl@scwfgkdwyuks>

On Thu, Mar 14, 2024 at 01:43:52PM +0100, Sven Auhagen wrote:
> On Thu, Mar 14, 2024 at 01:38:54PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Mar 14, 2024 at 12:30:30PM +0100, Sven Auhagen wrote:
[...]
> > > I found this out.
> > > The state is deleted in the end because the flow_offload_fixup_ct
> > > function is pulling the FIN_WAIT timeout and deducts the offload_timeout
> > > from it. This is 0 or very close to 0 and therefore ct gc is deleting the state
> > > more or less right away after the flow_offload_teardown is called
> > > (for the second time).
> > 
> > This used to be set to:
> > 
> >         timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> > 
> > but after:
> > 
> > commit e5eaac2beb54f0a16ff851125082d9faeb475572
> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
> > Date:   Tue May 17 10:44:14 2022 +0200
> > 
> >     netfilter: flowtable: fix TCP flow teardown
> > 
> > it uses the current state.
> 
> Yes since the TCP state might not be established anymore at that time.
> Your patch will work but also give my TCP_FIN a very large timeout.

Is that still possible? My patch also fixes up conntrack _before_
the offload flag is cleared, so the packet in the reply direction
either sees the already fixed up conntrack or it follows flowtable
datapath.

> I have successfully tested this version today:
> 
> -	if (timeout < 0)
> -		timeout = 0;
> +	// Have at least some time left on the state
> +	if (timeout < NF_FLOW_TIMEOUT)
> +		timeout = NF_FLOW_TIMEOUT;
>
> This makes sure that the timeout is not so big like ESTABLISHED but still enough
> so the state does not time out right away.

This also seems sensible to me. Currently it is using the last conntrack
state that we have observed when conntrack handed over this flow to the
flowtable, which is inaccurate in any case, and which could still be low
depending on user-defined tcp conntrack timeouts (in case user decided
to tweaks them).
