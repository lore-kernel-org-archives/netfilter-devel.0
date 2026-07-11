Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EC9495E5
	for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2026 05:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783747785; cv=none; b=kHdU7maiv3yHWKYeSGfbzjVrV8sxUFAKo/O1W6F+Gp5jxy0SQpsr1VqQKlW/gAN/Ig8Ova0rL1/VLEsCCaAksIocLeb7cgswK6FDR0ggE4MlhaTjL63Yi6WgjcBmLB8Kln/wYwrD58pekVhvo9VBuEViIcezrJa8KnEzbMPtgTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783747785; c=relaxed/simple;
	bh=yNeYlElKxqKHfm1D6vscwfvY7ckoOapW3juQCYhfHq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1QF5kY8TT5/fPmyP9m9j6mwzf1DWMYvTYYfNytEACSd1W4tOHrZWSBo0/IKV1r+UEUr0IptJlwuHLrEwWjAfIsj82AXAvRTG4kXeYzk+MBfpxCXHqmjDG97ZhHuecgkGV0GyA8Crr25B+Iu7ouA4jl0Hhzmrb2Ln6VWvFh2sZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9lB8qwl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9lB8qwl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D961F000E9;
	Sat, 11 Jul 2026 05:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783747784;
	bh=yNeYlElKxqKHfm1D6vscwfvY7ckoOapW3juQCYhfHq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P9lB8qwlT+ERGA+68PyiQVsZDW4fwkNKZ1zkPdOBJ8H60p+QUDFzXZkIo+SZGMqea
	 gqVjfVa2hntDtj43qMlAHd6Rfwu6+Hk3Y+XqexdnPm39jlklCady33ysxloAZzFuwD
	 XkC8uLjzXuZSf+UvCavUz2mNQzHaDK69kNPTQqA4=
Date: Sat, 11 Jul 2026 07:29:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaeyeong Lee <iostreampy@proton.me>
Cc: "pablo@netfilter.org" <pablo@netfilter.org>,
	"fw@strlen.de" <fw@strlen.de>, "phil@nwl.cc" <phil@nwl.cc>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"security@kernel.org" <security@kernel.org>
Subject: Re: netfilter: nf_nat_sip expectation UAF permits local privilege
 escalation
Message-ID: <2026071134-turkey-detonator-0d87@gregkh>
References: <aQrSf6maL27cH2V4V9ELFdSqdtCWQ-B5iZr8fjR2Wz7zAJ7L32oW50bdrePoTMnJ4CRjDrns-jNMNFHGWNUxYe3UcV91AK99Ilncjab2uDk=@proton.me>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQrSf6maL27cH2V4V9ELFdSqdtCWQ-B5iZr8fjR2Wz7zAJ7L32oW50bdrePoTMnJ4CRjDrns-jNMNFHGWNUxYe3UcV91AK99Ilncjab2uDk=@proton.me>

On Fri, Jul 10, 2026 at 11:19:54PM +0000, Jaeyeong Lee wrote:
> ## Vulnerability Summary

<snip>

As you sent this to a public mailing list, there's no need for
security@kernel.org to be involved in it.

Also, please just submit a patch to resolve this issue so that it gets
fixed and you get full credit for resolving it.

thanks,

greg k-h
