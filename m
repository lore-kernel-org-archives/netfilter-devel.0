Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3350A304BB3
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 17:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764782716; cv=none; b=AWKv6Ghq1WZHwIKpUsfN16YD+8RX5AyZVyZ8tUJ6QWYmUiEjKo1zazX8vqkjj60Gev7DipPJUMgFPw8YiUSxJsEIOx3WSYXVKBpKx0QBNDP5gMpop60oyZn0OShUuT+LG3uOyzHWegvVUDwDb0Shzp8XXtak9tRwXkqG+kOcALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764782716; c=relaxed/simple;
	bh=6Axqs9IPw0YwAnWoNjVtTkvsZvxQHVFol95ADcEf9nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnOktij1LkizZA1/jGy7PFJMgeVX5nvA9KNsOnUOlKaEyCeN8RKe97u0xGadNPJY4ziw80IK2KTDZKYYVrGb6V1/8+Aid/5XD4ycL07Gy6fBxiimR94bQKi3ynEHWgwIjY6OR9+hKO8d3SEIBXzGeHVelyFUhat5oBYGpSh7mec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 5AB98605DD; Wed, 03 Dec 2025 18:25:11 +0100 (CET)
Date: Wed, 3 Dec 2025 18:25:11 +0100
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: pipapo with element shadowing, wildcard support
Message-ID: <aTBydxPbKZnh-iUw@strlen.de>
References: <aS8D5pxjnGg6WH-2@strlen.de>
 <20251203150849.0ea16d5f@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203150849.0ea16d5f@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> > Question would be if it makes sense to relax the -EEXIST checks so that in
> > step 1 the wider key could be inserted first and then allow it to be
> > (partially) shadowed later.
> 
> The reason why I implemented it this way was to avoid possible
> ambiguity because entries inserted first are anyway matched first.
> Details with example at:
> 
>   https://lore.kernel.org/all/20200226115924.461f2029@redhat.com/

Thanks.

> It might make sense to change that, but that's not entirely trivial as
> you would need to renumber / reorder entries in the buckets on
> insertion, so that more specific entries are always added first.

Right, it needs a reorder step.

> I guess you assumed this was already implemented, which is a reasonable
> assumption, but unfortunately I didn't add that, it looked good enough
> as it was, back then.

No, I realized this was missing, the -EEXIST tests would not have
made sense otherwise.

What I did not know if it was omitted due to 'not feasible/too hard' or
'good enough for now'.

> See that same thread for some discussion about it, in particular around:
> 
>   https://lore.kernel.org/all/20200225184857.GC9532@orbyte.nwl.cc/
> 
> other than that I'm not aware of previous discussions.

Thanks for the pointer!
