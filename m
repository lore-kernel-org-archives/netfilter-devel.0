Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B2D547051;
	Fri,  9 Oct 2026 00:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791504899; cv=none; b=FPu0MLyHeq9qjb1WvZ3h94znpJU+d5US7Ukkqj4rK7HbmxE+bBTZe12K3GXTRCUlzh0eBxph2zuP/rGUEWQJI8108QlqsRacFw6DbnbbQb8N5XW5EEE7I7qfMiM7JF4z7O1hPI2Iqnkj5usVG6rbz2kgSS/qdln2Jw1FgT3m4nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791504899; c=relaxed/simple;
	bh=bT7t3sZO8HjFKm1nLPP7C8IVRQrsLUe9JWzXFmN02Hs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l+x+Hu3QA1kqk3rgPHATXXd+1nYRIEWeH+ruPiLmo0tNZceeogmviPurhocjUFhVWwDJiqhtu75l5PFucNltbS+2FMXrDzn37Dk2407VcS7UrZGM5cZPtbnb4kYOLhlFLLKXJmSkkeJDywJORjk7l+sTJw39R/myWT3Ep5axz6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SFvYi/Be; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SFvYi/Be"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791504895;
	bh=stHzPEe/3zG/BGUkH4YbG9woUvhrkMpvZ2T5OnK+cJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SFvYi/Berca+ikvpGDeaQIQS4014mosKvlSkQ8JMWOILPkDbhUVAT2D1bjM1/PNsE
	 7rs3Fe7iPtrDLGWxs+bEyptC97VwlWcbkuVHJIFxnNzC5fSq4EteCWYwZ1oqyQjPUw
	 beoeVo1yCmxGJ0fi9bY4MdudmGAUqfcSpMXiusAVSE4JF4bAlak6q3jCiN7aSkHAWC
	 G4+3jg6Vms8+kC7dhlRhv9xOIIPxhjx5ot8eRL02I6B2uzNqQ2QbPx7IHKx29eizLV
	 uO56BHDnJWvqQOQaYbJQVDD72JrbEib4blk+MYL/84etQ4i7gvicd2OQYbZDoQvX8b
	 JqvwTKFhE+t5g==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 20D0260057;
	Fri,  9 Oct 2026 02:14:55 +0200 (CEST)
Date: Fri, 9 Oct 2026 02:14:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Zihan Xi <zihanx@nebusec.ai>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, phil@nwl.cc, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org
Subject: Re: [PATCH nf v3 1/1] netfilter: x_tables: avoid holding mutex over
 faultable user copies
Message-ID: <asgx_COtYd1PifN2@chamomile>
References: <cover.1789885804.git.zihanx@nebusec.ai>
 <f88fc502b17b4022105a99eea407525807ee573e.1789885804.git.zihanx@nebusec.ai>
 <asgtQ3E2LVWqfV8D@chamomile>
 <asgwR9LsGCEMolQX@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <asgwR9LsGCEMolQX@strlen.de>

On Fri, Oct 09, 2026 at 02:07:35AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > The ebtables GET paths use a separate ebt_mutex and are outside this
> > > IPv4/IPv6/ARP series.
> > 
> > I keep spinning on this, and I am not sure this fix is the right thing
> > to do. There is no single caller of this pagefault_disable/enable() mm
> > subsystem function in the net folder.
> 
> See:
> 
> https://lore.kernel.org/all/CAL4Wiir+CBGE=hXxHEBkyk0Au9B6G3=AdHFd5botrC-FF5BM5w@mail.gmail.com/raw
> 
> Quote:
> | We have many places where copy_{from,to}_user() runs while a mutex or
> | a socket lock is held, and some of these locks are global.

Indeed.

> So I would not spend too much time on this, especially not for the
> xtables get/setsockopt APIs.

OK, I'll drop this patch in patchwork then.

Thanks Florian.
