Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="V+TLyLKy"
X-Greylist: delayed 347 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Nov 2023 02:54:00 PST
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA28D127;
	Fri, 24 Nov 2023 02:54:00 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1700822889; bh=ob2LQCkdRRVJVhFxnDtSSlxr7qwHzAzTS5rpGACd0V4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=V+TLyLKy8JDomAFV/YRVPKU86XHcGMfCtf75cUP055Fy5WAxzOPqwYStakhmGCKgF
	 Wd6qzNdLBFySe+wo6ERE3x9+HrcvwWyyrvfw1mh66NWdO2pBNLwEoknnOR7Wi0k0/b
	 JSIfEi9v7DeSVkGThrvTtk+9dxJa8G3Y6vUpUtfxfGko62FyGSzVxqb21hU3iJ/s76
	 gRKBQDka+s1iV1rWkzei8tk8AeoWHjoPDL+y3+aAFAkSgDSK3GydJL2s6PXSuy8A1f
	 CR/3hIB5l7iX2lZLSW+jWTPJy2IgbszmIEV5IBcQVcIjsE1V1IHzNUzWo2/bkGbzgl
	 YlnuWhAGmmqLg==
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, lorenzo@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 0/8] netfilter: make nf_flowtable lifetime
 differ from container struct
In-Reply-To: <ZWBx4Em+8acC3JJN@calendula>
References: <20231121122800.13521-1-fw@strlen.de> <ZWBx4Em+8acC3JJN@calendula>
Date: Fri, 24 Nov 2023 11:48:09 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87leane8ba.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

> My understand is that XDP is all about programmibility, if user
> decides to go for XDP then simply fully implement the fast path is the
> XDP framework? I know of software already does so and they are
> perfectly fine with this approach.

Yes, you can do that. But if you're reimplementing everything anyway,
why bother with XDP at all? Might as well go with DPDK and full bypass
then.

The benefit of XDP as a data path is the integration with the kernel
infrastructure: we have robust implementations of a bunch of protocols,
a control plane API that works with a bunch of userspace utilities
(e.g., routing daemons), and lots of data battle-tested data structures
for various things (e.g., the routing table fib). With XDP, you can use
this infrastructure in a pick-and-choose manner and implement your fast
path using just the features you care about for your use case, gaining
performance while still using the kernel path for the slow path to get
full functionality.

The first example of this paradigm was the bpf_fib_lookup() helper. With
this you can accelerate the forwarding fast path and still have the
kernel stack handle neighbour lookup, etc. Adding flowtable lookup
support is a natural extension of this, adding another integration point
you can use for a more complete forwarding acceleration, while still
integrating with the rest of the stack.

This was the "making XDP a magical go faster button" thing I was talking
about at Netconf (and again at Netdevconf), BTW: we should work towards
making XDP a complete (forwarding) acceleration solution, so we can
replace all the crappy hardware "fast path" and kernel bypass
implementations in the world :)

-Toke
