Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B721433CD8;
	Fri, 24 Nov 2023 16:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIP/2vBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34A1C433C7;
	Fri, 24 Nov 2023 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700843043;
	bh=cqkzBVnzAOUHRxUPbbIR8KFU106DKU3hJwtJMI7vK24=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xIP/2vBz3NSF47hw6/mv7M3wu3WqiWFBYrC7pouQiOPTYvtOhtaJPEVH4M2uqEqjb
	 XfyoYR1Rm2yclWS8rZH6R/KSKHEnDpdudYcq5I4pydL+JHKePmkFD+nugJvM0LbroM
	 nwn56adN5FrRHOfzZI2qlakHOTK5jaNHJIKRoHNQ=
Date: Fri, 24 Nov 2023 16:23:43 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Sasha Levin <sashal@kernel.org>, netfilter-devel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.4 23/26] netfilter: nftables: update table
 flags from the commit phase
Message-ID: <2023112437-obliged-tilt-546c@gregkh>
References: <20231121121333.294238-1-pablo@netfilter.org>
 <20231121121333.294238-24-pablo@netfilter.org>
 <ZV4qn2RI8a8cg3bL@sashalap>
 <ZV47LThJC3LMXmFp@calendula>
 <ZV8rNDHAdttpYrAJ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZV8rNDHAdttpYrAJ@calendula>

On Thu, Nov 23, 2023 at 11:36:36AM +0100, Pablo Neira Ayuso wrote:
> Hi again Sasha,
> 
> On Wed, Nov 22, 2023 at 06:32:32PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Nov 22, 2023 at 11:21:51AM -0500, Sasha Levin wrote:
> > > On Tue, Nov 21, 2023 at 01:13:30PM +0100, Pablo Neira Ayuso wrote:
> > > > commit 0ce7cf4127f14078ca598ba9700d813178a59409 upstream.
> > > > 
> > > > Do not update table flags from the preparation phase. Store the flags
> > > > update into the transaction, then update the flags from the commit
> > > > phase.
> > > 
> > > We don't seem to have this or the following commits in the 5.10 tree,
> > > are they just not needed there?
> > 
> > Let me have a look at 5.10, 23/26, 24/26 and 25/26 are likely
> > candidates.
> > 
> > But not 26/26 in this series.
> > 
> > Let me test them and I will send you a specific patch series in
> > another mail thread for 5.10 if they are required.
> 
> You can apply 23/26, 24/26 and 25/26 to 5.10 -stable coming in this
> series for -stable 5.4. I haved tested here on -stable 5.10, they also
> apply cleanly.

Now done, thanks.

greg k-h
