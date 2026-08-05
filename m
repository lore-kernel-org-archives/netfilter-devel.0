Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F13947ECC8
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 21:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964243; cv=none; b=jTp0evdItgwwzIPmjitCwvWjsoQj4pxJagAIoCSkDtJnwNz4ypEyqqEVPgKzvQm2cOcNf/TZsshI1bimHL79WkE//Nt+Au6azXeRskasLxUa6hjFvOjQfP5vJgFuHURsrktHdH034YxPiC0vdu8mce+MwxYsSiysWXIrdkJWqi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964243; c=relaxed/simple;
	bh=wHQQxcOAsLG6dAp55NkD6PDyePshKXUJUAUyHZztgF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PghcQaq/RkwvDUuGgz6cR/NUb4j0hWvtzcZjpr6WWTCAHXG7OoWHBwwkCqfCzzOZDnF1V/T4e9zRCok+A2Y9x3m5imTVP/bgbGMKSTdlQon0wNECjc0fLiI9dF5Tew0D0BqOETEaOOBHjdoQFyaQGrDAM02kIwvgQYc0fsqSyVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gIU07NnY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gIU07NnY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 068F260194;
	Wed,  5 Aug 2026 23:10:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785964227;
	bh=j8rA5zNp5Yiv4bGdCKXk70cNjzEDAYhrfgRTvNuXL3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIU07NnYeYLSDXH/UmoboxxZsZvNGuUWawhVEYfDmiBMQeNgXK6/hVX74Cm0JAQRc
	 EiwspHM2FxSxfbk9yuG9etKy+AtKUNU5cYG2gw6f5RNvq0obgH9GysX5qYVw5iVh4u
	 n4NZ6QSqvLIf1NEX0B0RR37WH9Mvvnz1mxjtVCz/OUnAWWXVsVYYGrSZojh8VhK6Mc
	 w77ofyWjlxN3lHOWLG9ryKJauFgUbOEg/M4gm/KV6FKhImWub9foh8FIx650xehAom
	 5fDHMT26cMD3VxlAxmFl8NkEpn4TB+q5YSq4MLsOE4tACbSicnLgDIJdvNNgrPdJ3E
	 LCVDLy0IR6Hyw==
Date: Wed, 5 Aug 2026 23:10:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v3] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <anOmwIoDMaE-Aodr@chamomile>
References: <20260801072747.75504-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260801072747.75504-1-avinash.duduskar@gmail.com>

On Sat, Aug 01, 2026 at 12:57:47PM +0530, Avinash Duduskar wrote:
> nft prints non-existent cgroup names as the raw id using PRIu64, but
> cgroupv2_type_parse() only stats /sys/fs/cgroup/<identifier>, so the
> listing does not load back:
> 
>   # nft list set ip t s
>   table ip t {
>           set s {
>                   type cgroupsv2
>                   elements = { 50834 }
>           }
>   }
>   # nft delete element ip t s { 50834 }
>   Error: cgroupv2 path fails: No such file or directory

Thanks, I have applied this v3.

I made a few minimal changes to the script, add a .nodump file instead
of the empty stubs.
