Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B484259C82;
	Sat, 11 Jul 2026 05:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783748028; cv=none; b=Qd+9Ccex7S6rsoOItl7UZnxRGrKBBlERDkDhJuQyWX9JH2h28JpDJD3y6E26wLCSVshNqHA7hGk0Myqh0zwc7Ue2GbHZ2WWzbpDEOsXbJB0zaVSoqZ0Ax4gGnFwqBd6nmYZ5ij+xLIhwvrtGaWQKEYtGX3TL+Z+gl/FCcIRmUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783748028; c=relaxed/simple;
	bh=opE5NEWq3bToYe6XQSN51rpaZOWtxWIl1qFst6FmEKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rGG09Y7Y9yMvoe4v7EjvHeuDZcJ4BjpgdDLk2t679Ak/VoTxw5jTdsqoxyOUpUgMvuJpr35M1QLb89FJh85Q7dPN31zkBe9Z5bncrC2l6ROZwXRCKA756CaX5BY6n4aZXRbfTe4a+q4jc8JcL7ZE0QZT3lvQ+UE7xDqYUMrC+Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJzGi75P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJzGi75P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C161F000E9;
	Sat, 11 Jul 2026 05:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783748026;
	bh=JLNqoA4EMUbeTcKOWVfrxBUKnV6gFApbWfRSrcQeMMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kJzGi75Ph+TZ6t3Cq1Kbcte8yklMQdEokbProSnbuiBmd/ZpUUQklKAxJNOnNCZZA
	 JlB9YG/EOLQXsC+eDyXBUfpgbkl6cJEuUtSG9P5QO1PXhobObh5IS0ygaCUm1/zpCt
	 5lvsQfm6Tk8ZJzubkOw2SBcZ6eKJ0x9PJi3tbAKs=
Date: Sat, 11 Jul 2026 07:33:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yuan Tan <yuantan098@gmail.com>
Cc: andrew@lunn.ch, Paolo Abeni <pabeni@redhat.com>,
	laurent.pinchart@ideasonboard.com, hdanton@sina.com,
	linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
	jhs@mojatatu.com, sven@narfation.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [RFC] VEGA: a syzbot-like workflow for LLM-found kernel bugs
Message-ID: <2026071131-dweeb-quickstep-d550@gregkh>
References: <20260708092247.4188498-1-yuantan098@gmail.com>
 <2026070828-carried-extortion-789e@gregkh>
 <CAPuPA7Kdy_wghauOH5pggq+woLmtp4-BEyn8LoBJ2UhRExF+Xw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPuPA7Kdy_wghauOH5pggq+woLmtp4-BEyn8LoBJ2UhRExF+Xw@mail.gmail.com>

On Fri, Jul 10, 2026 at 07:14:36PM -0700, Yuan Tan wrote:
> > But hey, I could be totally wrong.  Maybe some generous company that is
> > involved in unleashing this hell on us would be so kind as to pony up to
> > do the work to create this and help fix the issues that their tools are
> > finding.  Just like Google did in the past, there is precedent, but for
> > some reason people don't like learning from history...
> 
> We have also received some bug bounty rewards from Google, which gives
> us some resources to put back into this effort.

That's good, but I don't want you to have to rely on Google's bug bounty
money, as that is not going to be reliable if past history is any
indication :(

> We are prepared to invest more engineering time in fixing these bugs,
> and we are also considering hiring engineers to help.
> 
> Will you also be attending NetDev in person? If so, perhaps we can chat there :)

Unfortunatly due to passport/visa issues, I can not attend this year,
but will be speaking remotely.  I will be in Prague later this year at
OSS and Plumbers.

thanks,

greg k-h
