Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4670C36167B
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 21:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790630568; cv=none; b=Fh62C/dVGuuOSbYqnl6Tw6liQTI2JGAs8w8W95wf+0Ch9xakGGArKLGogZ3/qARDvlzWzb+jZQOKtICZF1ii6VIVzZOXQRrI3nz9tQn7jBvclFh3PQNQ1T9GrHlBL5gxY1OADHtey8WY4Lt7+9LNVG+kEtEUOyNToZqZtd8Ois4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790630568; c=relaxed/simple;
	bh=PRJZSSyJqu5Rx98WtPantqPASyvHBC3umk9fnXf6isI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5Mtw5AEMkprGF4IKTK6ufvAtqx0xtk7bYo30+a9Wy4GMX/Fl5Y4iKVQk2XBiQU5u/EYYyojvdMYHR7dC5l645h9Vy4lIDUD8w/Tgi4qGiwewsgmSIUeqJ4JwYzUKULgKs+UcVE1D02CGE+EyKtTru582PKWqPLSKOThfTOmunk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AB6C56094F; Mon, 28 Sep 2026 23:22:43 +0200 (CEST)
Date: Mon, 28 Sep 2026 23:22:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Matthieu Baerts <matttbe@kernel.org>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <arrao0GEl3eCV0OS@strlen.de>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arpn7_v8156iSc85@strlen.de>
 <f62b8394-9ead-45fe-bf26-998c0c822dcd@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f62b8394-9ead-45fe-bf26-998c0c822dcd@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 9/28/26 3:13 PM, Florian Westphal wrote:
> > > 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> > > (type 30) options in the TCP options. It looks like Netfilter doesn't
> > > handle that, because it stops processing other TCP options when the
> > > expected type is found:
> > 
> > Yes, this won't work. 'tcp option X' extracts the
> > option X.
> > 
> > I don't see how this could be fixed within the limitations of the
> > architecture.  Just use bpf.
> > 
> > > It looks like it shouldn't stop if the wrong subtype is found, but the
> > > subtype is not compared there if I'm not mistaken. Should there be a fix
> > > to support this case?
> > 
> > I don't know how, unless one would extend the kernel to make it aware of
> > mptcp, which also requires userspace to pass the suboption type to look
> > for in addition to 'mptcp option'.
> > 
> 
> This won't be easy neither fast but I added this to my TODO list. It sounds
> fun. Unless someone else does it first, I will take it.

Thanks Fernando.  I haven't looked at this at all.

I think the only sensible solution is to come up with a new syntax to clarify
that we want a specific mptcp subtype and not the first mptcp option.

The problem is that "tcp option mptcp subtype" really just tells kernel
"find the first mptcp option, if any, then place the subtype into dreg".

And kernel doesn't even know what a subtype is, it just extracts data
at given offset :-/
