Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED232F6918;
	Fri, 13 Mar 2026 02:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773367762; cv=none; b=ODW5E1HbpA5ReYFBDUHNJMJsOd1Yw6SuYNapAA8gPs8hb2KfDWiIMuGkx+6my9kCZMIXvMwr7IhF3YD3GCy2/tHEMkpsaViCThzvy6AlczyG1hGyTl+ALFCuz+G4FDWMwhQodIV8nauPG3ygEFj83LT914oPs8WM3dN0JNL2uXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773367762; c=relaxed/simple;
	bh=R86LUqmopu7TAWDxKl5ENh6Ga5kt+ql44C+aY7LNBZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MmJCWt/saoYZMhaNfwGUi4BDqq6K57sDYnpFLkMPQ28e1W7Nup/0o46jxTh3l97B2XuGAnhN2PCHGxyRPQmd7lKRWmmZA40A6WYQAHviDtHCWQTJ1bafpueyuFShT8LTD5QKgzasGDRVqr+hUAATW7ANpO/4lcboYwJuY8oSz8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3C97460735; Fri, 13 Mar 2026 03:09:18 +0100 (CET)
Date: Fri, 13 Mar 2026 03:09:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Prasanna S Panchamukhi <panchamukhi@arista.com>
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next v2] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
Message-ID: <abNxz9T_XB-JtBCj@strlen.de>
References: <20260312223157.25083-1-panchamukhi@arista.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312223157.25083-1-panchamukhi@arista.com>

Prasanna S Panchamukhi <panchamukhi@arista.com> wrote:
> The conntrack garbage collection worker uses an adaptive algorithm that
> adjusts the scan interval based on the average timeout of tracked
> entries.  The upper bound of this interval is hardcoded as
> GC_SCAN_INTERVAL_MAX (60 seconds).

I already said that I'm not keen on this approach.
Its a 'we can't do any better' type "solution".

If anything I'd be more inclined to make a change that allows to
more easily override the next_run computation via bpf.
