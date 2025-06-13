Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3394628D8F5
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Jun 2025 21:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749850883; cv=none; b=e+WCPUOGOx9ocve3dso7nJoO/faTslv5GjbrYADvFs0HIQFli2tiUA4jf/yVK2Vtz0FhF+IqkxlbCBS461nuESAvjyj8XuCCsIza6cfbFBHkKsNO360KpGRF/lk3oJrFXYZVtzbF9XWQjrPC8XZvFjNc4jenhWTN9zNJVz7pJlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749850883; c=relaxed/simple;
	bh=ySMnrilvMZdCFabetCjKnurXqDAx/tm2PqDuEXl8Awc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aqmh+HoFQVDgt2Xp/O0hdhtLYt3pUb8Le9PqrCy0iblcHj3E2DY8wqX/9OyrH53uhAxXAZsP+WfWvlDt14DdK24IpQr58gvGudX7MBzEtOOA9/KKhjcjsNDQSIZnl2qTV3xElCwxeWMNK/+uww8hOaCJ9/Lxa4RgCg9PQfo5l2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BAB8C612E9; Fri, 13 Jun 2025 23:41:16 +0200 (CEST)
Date: Fri, 13 Jun 2025 23:41:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Christoph Heiss <c.heiss@proxmox.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack-tools] conntrack: introduce --labelmap option
 to specify connlabel.conf path
Message-ID: <aEya_IffeWY8RmKr@strlen.de>
References: <20250613102742.409820-1-c.heiss@proxmox.com>
 <aEwXADKlOKotEVRi@strlen.de>
 <DALEXBLBOPWN.2DL1A7GBBBVQ8@proxmox.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DALEXBLBOPWN.2DL1A7GBBBVQ8@proxmox.com>

Christoph Heiss <c.heiss@proxmox.com> wrote:
> But it's used for indexing into `optflags`, which in turned is used by
> generic_opt_check().
> 
> As `--labelmap` can only be used with `--label{-add,-del}` and thus
> `-L`, `-E`, `-U` and `-D`, this is appropriately reflected in
> `commands_v_options`.
> 
> Based on that, generic_opt_check() will then throw an error/abort if
> `--labelmap` is used with any other command, e.g.:
> 
>   conntrack v1.4.8 (conntrack-tools): Illegal option `--labelmap' with this command
>   Try `conntrack -h' or 'conntrack --help' for more information.

Makes sense, thanks.

> > Should this exit() if labelmap_path != NULL?
> 
> Don't have a strong preference on this, but probably makes sense to
> abort in case the user ever specifies the option multiple times. I'll
> add that.

Thanks!

> Can do that. Will just entail a bit more refactoring around the
> --label{-add,-del} option parsing, as that relies on an already
> initialized labelmap.

Right, if this becomes too convoluted then another alternative
is to error out if the --labelmap option is seen but the initalisation
was already done with an error message indicating that the labelmap
option must come first.
