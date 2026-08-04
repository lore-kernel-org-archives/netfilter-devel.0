Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EAA3CC7DB;
	Tue,  4 Aug 2026 06:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785823362; cv=none; b=H70BXVvPBZnQidnipz7J1MkMBnwXDYD+Gmpt8cLZlQ/ec946hwQmrE+TpOF2Qy6RBAF+dRUNePuOxoQEvZ8qy07qAD/EJ4GEvCmmqY4R+JScF22r96NStV6R5/LhyIu97eRxiuAuOkoiRe4zRw1/DAZtZpLImu0ON1a4KQf4/9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785823362; c=relaxed/simple;
	bh=jiNaDxNbUZSU+UYqrYxdn8HHVoxF7bMHJrZxXYbXFyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O9I62BiRYr4+bJkssrcnLfNInYwbMcS6R3yUNFvUnSBId8URgVENRv7lGwJ6OnHsnaZw+oPnOUwZ2K69i6i7YFBH9L1KtDVAX6ffSZ1oUfNXrv7RRIG4UTWCBlP2mDKN3W+uFcTGpzoHn5yF/F8laXBsEVc8zmLRDT3fwza0V/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IHmoPbN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IHmoPbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9F11F000E9;
	Tue,  4 Aug 2026 06:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785823361;
	bh=eqkmWOQL5IlExnP/Ya1lW7cAbHkCA+0+qwkykSqW6jI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0IHmoPbNQV8QSOW4BnrSRa/pxOCjTIvjfkdiyeWfU7/PsGy73whTuoMJvBKmQtyaL
	 85Ql1EUMJSaFUv2PBz0u2USzpt7DIU2zOejp6DPhAhoIKiR6OPQogOJsEgPo09Em+c
	 cHY7tfGcNICWrP3oTgnrKq4SG88ar+13n314+XYA=
Date: Tue, 4 Aug 2026 08:01:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Fahad Alharbi <fahad@codepure.com>
Cc: stable@vger.kernel.org, security@kernel.org, security@ubuntu.com,
	Sasha Levin <sashal@kernel.org>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: nft_set_pipapo: UAF and double free from a stranded GC batch in
 the 5.15.y / 6.1.y / 6.6.y backports of 9df95785d3d8
Message-ID: <2026080436-dyslexic-willfully-fb2e@gregkh>
References: <CACiD-V1TcRTcQotj-15KvpSr8hG26y6PDx=WU5MVAdHMEsgopA@mail.gmail.com>
 <2026080355-catcher-absurd-f9e2@gregkh>
 <CACiD-V2ymG+0DA2aLwHWeH7oejy0g=n1NUZ6Ce9NXvJFhwJP4Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACiD-V2ymG+0DA2aLwHWeH7oejy0g=n1NUZ6Ce9NXvJFhwJP4Q@mail.gmail.com>

On Mon, Aug 03, 2026 at 09:19:28PM +0300, Fahad Alharbi wrote:
> Hello,
> 
> 6.6.148 backported the pipapo on-demand-clone series, but two commits from
> the original 2024 series were not included.  Two consequences are visible in
> the source.  Both are straightforward to confirm; no reproducer is needed.
> 
> Requested trees: 6.6.y
> 
> Missing commits:
> 
>   8b8a2417558c ("netfilter: nft_set_pipapo: prepare destroy function for
>                  on-demand clone")
>   532aec7e878b ("netfilter: nft_set_pipapo: remove dirty flag")
> 
> Both are Florian Westphal, 2024-04-25, and both are present in 6.10.y
> through 7.1.y and in mainline.  Neither is in 6.6.y.

That is because they do not cleanly apply there.  Can you provide
working backports for that tree, and any other older tree that you think
needs it, so we can queue them up?

thanks,

greg k-h
