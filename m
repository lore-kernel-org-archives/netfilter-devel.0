Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F1113BAC3;
	Tue, 22 Oct 2024 07:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729583068; cv=none; b=biLE/+K70pUiKaa0dd/1H9Ianjhd2KY6lCiQZCeMC+Y2vSqc/k9M8WvS98oJt+bn4hZsJAGbsS9/DzJN5N/o/rAtqt6cYS5OqoLMaPR6IlGcexKXAAVZs83iQwIDP3dfxWu8xkRQ/ObADYfgARwNetT4jBWq2hAszRXVBCIVVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729583068; c=relaxed/simple;
	bh=utPcZviRkad0Vup0P+ypNJsbQjBR/6KpT/yTDoXMWdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kp8JJMpH/K3rXNl03M7rPsW0oxYAEfE573l6MT7J0lNiOCrJz5Gpmm2iMI55mgu8+lh1rGy4u9MO8dyHcHYoODBUQvUfu+L7RjtWF7ldhGfJr1a0zlobdXjATNwNSYmk4CmeqjjTwkclw+TIt39GREqwi+fp5gP4JsKJKq0nz40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glJIm/bT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glJIm/bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DDFC4CEC3;
	Tue, 22 Oct 2024 07:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729583068;
	bh=utPcZviRkad0Vup0P+ypNJsbQjBR/6KpT/yTDoXMWdw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=glJIm/bT6eCyOXnm1Hgn2QSb4QGRvJ6VA2H+UncvoqJ8EISbDyw+Kw6k2oXjtnjpm
	 RT4AItjaLPSTllFW2024iEdqAxENrOyi3EnU0HL39vxGsw5Fs24IQcTBGElZrp+W6d
	 SdFUhTSI5LM/LemISasUArjwJVWDLIHLXGtVMiFs=
Date: Tue, 22 Oct 2024 09:44:19 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net 2/2] netfilter: xtables: fix typo causing some
 targets not to load on IPv6
Message-ID: <2024102259-armadillo-riveter-0e7d@gregkh>
References: <20241021094536.81487-1-pablo@netfilter.org>
 <20241021094536.81487-3-pablo@netfilter.org>
 <8cd31ad2-7351-4275-ab11-bca6494f408a@leemhuis.info>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cd31ad2-7351-4275-ab11-bca6494f408a@leemhuis.info>

On Tue, Oct 22, 2024 at 09:39:38AM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
> [CCing Greg and the stable list, to ensure he is aware of this, as well
> as the regressions list]
> 
> On 21.10.24 11:45, Pablo Neira Ayuso wrote:
> > - There is no NFPROTO_IPV6 family for mark and NFLOG.
> > - TRACE is also missing module autoload with NFPROTO_IPV6.
> > 
> > This results in ip6tables failing to restore a ruleset. This issue has been
> > reported by several users providing incomplete patches.
> > 
> > Very similar to Ilya Katsnelson's patch including a missing chunk in the
> > TRACE extension.
> > 
> > Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
> > [...]
> 
> Just FYI as the culprit recently hit various stable series (v6.11.4,
> v6.6.57, v6.1.113, v5.15.168) quite a few reports came in that look like
> issues that might be fixed by this to my untrained eyes. I suppose they
> won't tell you anything new and maybe you even have seen them, but on
> the off-chance that this might not be the case you can find them here:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=219397
> https://bugzilla.kernel.org/show_bug.cgi?id=219402
> https://bugzilla.kernel.org/show_bug.cgi?id=219409

Is this commit in linux-next yet?  I looked yesterday but couldn't find
it anywhere...

thanks,

greg k-h
