Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="mJfwc69D"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA14D44
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Dec 2023 05:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KAgd1d8ftfSgEydQPQxbT+qo5AHNyFYwo8z3hI+J1Ng=; b=mJfwc69DjboZUh6JqiKBzSs8+N
	vx6AbrVkMI341Ec+lQo4bjynfMJhHMkkntshEugabFz/yqCp8bggXf6LI+e3K7TXPYfrcViXmRuaA
	fNyQolqyqESgGTHwZ0ehMGCGslEOdE9DoJRnY1kbRrD6t/WYgW7gLWEN17w7j0w+or0M/0HpSmUUW
	ojKIsRnJbRQnivgtQ+Q1DbNbp6IvnuFNzCOYcHEY8CC8bvYm6fV2sR1VmmjD17cLuStzwD0TSkQHM
	zua8V/r2IMthTBV5xzo2IOACtwsQS8FOPnMQyfVA2Ru8AVtJ+83lEtiHpXOy4ikxmoUPcgXuo11kD
	0DHiAtIQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rArzG-00084U-HT; Wed, 06 Dec 2023 14:30:50 +0100
Date: Wed, 6 Dec 2023 14:30:50 +0100
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] initial support for the afl++ (american fuzzy lop++)
 fuzzer
Message-ID: <ZXB3ikEXjBz9r1pS@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231201154307.13622-1-fw@strlen.de>
 <ZW/YVpeUtn5dfcmA@orbyte.nwl.cc>
 <20231206074342.GC8352@breakpoint.cc>
 <ZXBxKEhprUVUvG7m@orbyte.nwl.cc>
 <20231206131340.GL8352@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206131340.GL8352@breakpoint.cc>

On Wed, Dec 06, 2023 at 02:13:40PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Hmm. Probably I miss the point regarding struct nft_afl_input. IMO, if
> > save_candidate() writes data into the file despite called savebuf()
> > setting use_filename = false, nft_afl_run_cmd() will try to read from
> > ->buffer when it should read from ->fname.
> 
> In that case buffer should have same content as the on-disk file,
> so there is no need to open/read/close.

Ah, heh. I managed to ignore the mandatory snprintf() call in savebuf().
So it's indeed just "file backed buffer storage". Thanks for explaining!

Cheers, Phil
