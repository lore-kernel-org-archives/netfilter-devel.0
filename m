Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE648289D
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 17:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707413472; cv=none; b=V8I5c/QzE6U8h49wdelAMUfpfYyRKWmOkTaKhBs9QGvu/6KN2s0FWz81wNhbwjWyRWuqvKbMwtYAor9TUmn/sgwvL8SyAZhocnlds+OAD6g/6Kzzw0sRBaXFOYCn+cZvqUwKL9fHLVkAk6kFgzFpdbSaQKwlB4mb6IoOKndT7F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707413472; c=relaxed/simple;
	bh=sO5eqdpLIkrTULrF8B0dPAo9Tz9R/vqmj6o+3lUvLR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXAGAPjP7gaLVROdYkdw22Egc14PiKefySYS1di4bdMuP/WPEA5mJ7F3duGc7tK2oTWJtNGgLSrf5U7jolxC+xwRMeh1WfgxRY2sjV7XrOxOYKV+wiwLwEGykTjwxoy7WgfHXRA9Mlv0/Z7/a7icLTG1A5uGi8wCiQ1fjqPyLkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Aq27Mp+5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Aq27Mp+5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nBtxVPCgfFC21JQk4Ze4bgffZkSCj63yo8+Cemsc5rc=; b=Aq27Mp+5emfPcYEQykjTUQ3iu3
	SfOD3XmcTCZBWEifr1qcHWjJELDsKLd7u6rsIpQ7rq+qepCH9FofXQNWKCbGXa3tAYDq2G96WxsO9
	BusvNH5f8wuQa9ujBfh1jthf5egpcLmhoj7WyncWhVqIeeuX2oG59c1xh8qyKFg7grhRqaREBrhiB
	abwP9D2AbKqej7tAIBjgFcqN7iJWYvquwKYNGil+EE6LaIrlxQxZ1UpqBRtHWYDyDB4P0OgKLyVl2
	TWjq/tCRDEMg1PpctKVxKh5bZeY+timvFaNBE+QO/4fVQqRr7VOVmBLF/fG8R0UaazBC6m3ya6vJs
	RF65KAmw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rY8En-000000004oi-1mH2;
	Thu, 08 Feb 2024 18:31:01 +0100
Date: Thu, 8 Feb 2024 18:31:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: Thomas Haller <thaller@redhat.com>
Cc: NetFilter <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2 v2] tests/shell: have .json-nft dumps prettified
 to wrap lines
Message-ID: <ZcUP1XPfrGtH4Mm5@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Thomas Haller <thaller@redhat.com>,
	NetFilter <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20231124124759.3269219-3-thaller@redhat.com>
 <20231207091226.562439-1-thaller@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231207091226.562439-1-thaller@redhat.com>

On Thu, Dec 07, 2023 at 10:08:50AM +0100, Thomas Haller wrote:
> Previously, the .json-nft file in git contains the output of `nft -j
> list ruleset`. This is one long line and makes diffs harder to review.
> 
> Instead, have the prettified .json-nft file committed to git.
> 
> - the diff now operates on the prettified version. That means, it
>   compares essentially
> 
>      - `nft -j list ruleset | json-sanitize-ruleset.sh | json-pretty.sh`
>      - `cat "$TEST.json-nft" | json-pretty.sh`
> 
>   The script "json-diff-pretty.sh" is no longer used. It is kept
>   however, because it might be a useful for manual comparing files.
> 
>   Note that "json-sanitize-ruleset.sh" and "json-pretty.sh" are still
>   two separate scripts and called at different times. They also do
>   something different. The former mangles the JSON to account for changes
>   that are not stable (in the JSON data itself), while the latter only
>   pretty prints it.
> 
> - when generating a new .json-nft dump file, the file will be updated to
>   use the new, prettified format, unless the file is in the old format
>   and needs no update. This means, with DUMPGEN=y, old style is preserved
>   unless an update becomes necessary.
> 
> This requires "json-pretty.sh" having stable output, as those files are
> committed to git. This is probably fine.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>

Patch applied and pushed along with a bulk dump file conversion to
pretty format.

Thanks, Phil
