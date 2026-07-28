Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09EA3A83BF
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 20:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785270683; cv=none; b=KWmDyZ/K+JoWHXhlJtiuGrRBzVoIXYQf9KdCSDf/dRPAF5wG9Od7XhJJSLCmbNSBDVE3P53/yDVuokfsCIn+CS/OoH/bpvO5FJuqAUxwFRdxwAeUUSUSZZQL3/XvsHKoR4NYR9Ess9RPWPt5rNQZTzrUvRlp/KZFRg9WQqkT8bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785270683; c=relaxed/simple;
	bh=tKUkz/C+BHKxJpjS9mqGGM9yU5c7gkYwYtgCjL3IPZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZD9IC+q9mQYLcesfcI5RpsnE4dwBKIJeEvXsCLgqE3gF6nldRFHMfCXFTyblP/xPPNW8asbIQAk8TxDeB3qcBQyUvFf5OGHBNUX7/vznZWznuDyrTI5Qagf5BWXMK5+chAWufZLjyE4+dD+0pAuhIK7tvGm0MJbkmJHBv4kh74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wRPWWMiH; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wRPWWMiH"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id CDA64601A6;
	Tue, 28 Jul 2026 22:31:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785270678;
	bh=cfhXpyTPzwYo1207Kai4hmioGw6G9gsS9W/EJQeTWhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wRPWWMiH5UGkCT5FltkNCRKXvxHFtVsduKLk+JS5bJ5vL9IlJ1/ytz746F8k6OMEl
	 ZMfzdloPg+mI8wbGnw+rVbdh045x2/COLiqIMt1wtpkcUpPJXYinxeB4KLrZvMdKyy
	 S9SCBTaHH5AtReCMlMdmsCjuZz2Q+HT7xlahxkKYmXCxcI+ZPK9UFcQlChuyXB9Iyd
	 mYWlhdXutu8oHI48bGMcHr9U9JRZv8zbR4imBxCcyVp+UVxBaaNhEN5mrlM7yhPqeb
	 3P+/ZFrDwDVK2ee1FouUg8x7J+DaMMoFxWSohc2H02puWlTRP2tVnCUG7vGVF4TvmD
	 eGmjUciX16kiw==
Date: Tue, 28 Jul 2026 22:31:16 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Avinash Duduskar <avinash.duduskar@gmail.com>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] datatype: accept a numeric cgroupsv2 id on input
Message-ID: <amkRlAy1nz2KMx5N@chamomile>
References: <20260727082427.740789-1-avinash.duduskar@gmail.com>
 <amjWjTkt1Dsh66Xv@orbyte.nwl.cc>
 <amkAJuVZmpGy7pvY@chamomile>
 <20260728201909.1773000-1-avinash.duduskar@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260728201909.1773000-1-avinash.duduskar@gmail.com>

On Wed, Jul 29, 2026 at 01:49:09AM +0530, Avinash Duduskar wrote:
> On Tue, Jul 28, 2026 at 09:16:54PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Jul 28, 2026 at 06:19:25PM +0200, Phil Sutter wrote:
> > > So with nft printing non-existent cgroup names using PRIu64 and parsing
> > > code still performs the path lookup first, what is all the fuss about
> > > non-decimal number input?
> >
> > They claim they cannot delete entries via numeric value, it seems.
> 
> Correct, the earlier example proves it.
> 
> A typo'd id can collide with a live inode and then list as another
> cgroup's path. Fine with dropping the checks if you prefer.
> 
> > > Is this AI output?
> 
> Yes. Point taken on the length.
> 
> > > Can't this just be something like (untested):
> > > [...]
> 
> Yes. v2, keeping the two checks:
> 
> 	if (stat(cgroupv2_path, &st) == 0) {
> 		ino = st.st_ino;
> 	} else if (isdigit((unsigned char)sym->identifier[0])) {
> 		char *end;
> 
> 		errno = 0;
> 		ino = strtoull(sym->identifier, &end, 10);
> 		if (*end != '\0' || errno == ERANGE)
> 			return error(&sym->location, "invalid cgroupv2 id");
> 	} else {
> 		return error(&sym->location, "cgroupv2 path fails: %s",
> 			     strerror(errno));
> 	}

Did you consider to parse this via integer_parse() for consistency?

Thanks.
