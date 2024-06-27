Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0260A3F;
	Thu, 27 Jun 2024 01:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719450837; cv=none; b=QWNlBhgr6MmH5tenwCDSi7ZCRiDZPv3CRv4C/OFrDPs0XSFPe+aDikASXIZET4+QcL6TUXZmsyjrnULU5CIL0iEaY/ZLZIOmT7SRdrUWaYpSgoMItRqGGyREsB2RUGCQ8jzqchPCxVg4g2kl3OqVCuF5A8UozLT97jnUAiw6EpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719450837; c=relaxed/simple;
	bh=rpDClx8smJfl1ft3RGmjP89E6SMy7BQoBFWHBj0H7fQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvrg3Z0Wbi72RVvLZhvLphdM7bQJzlJPwG8hLVPA1cwiDSSc4VxQpTUrLQQbX1YwQoHzLTar/8Ew5OK/rVD+dnEGgrqVG4tqrJ/abeH5wUJ3qC8qSOp8HbZ7RGcOrDPMPZuEPvBLqFSUKSfGtasTek68d5DAZP6C7hvoz+xqLxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=41726 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sMdht-008qYP-47; Thu, 27 Jun 2024 03:13:51 +0200
Date: Thu, 27 Jun 2024 03:13:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, fw@strlen.de
Subject: Re: [PATCH net 2/2] netfilter: nf_tables: fully validate
 NFT_DATA_VALUE on store to data registers
Message-ID: <Zny8zPf1UAYNKL0E@calendula>
References: <20240626233845.151197-1-pablo@netfilter.org>
 <20240626233845.151197-3-pablo@netfilter.org>
 <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wibyec=ObQrd3pR+cUUchDGXFk3bTp435jOz+NP0xEzXw@mail.gmail.com>
X-Spam-Score: -1.9 (-)

On Wed, Jun 26, 2024 at 05:51:13PM -0700, Linus Torvalds wrote:
> On Wed, 26 Jun 2024 at 16:38, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Reported-by: Linus Torvalds <torvalds@linuxfoundation.org>
> 
> Oh, I was only the messenger boy, not the actual reporter.
> 
> I think reporting credit should probably go to HexRabbit Chen
> <hexrabbit@devco.re>

I would not have really know if you don't tell me TBH, else it would
have taken even longer for me to react and fix it. Because they did
not really contact me to report this issue this time.

But if you insist, I will do so.

Thanks.
