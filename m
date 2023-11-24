Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="JiseBQme"
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C96D46;
	Fri, 24 Nov 2023 02:59:15 -0800 (PST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1700823553; bh=hQv1mFn0xf2droBvF8tHfDYDAZXFwZfl7wiNr1flmI8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JiseBQmeqh9av05ZxnOz2/iu9m8oniFN9hqR8xAPBUQdIMYNF/mkc96qv6guifQER
	 rnf8gERnNT996BZtBp8lsYWxKbXrTvgjals6KllWR+1ik0V+LryNfYAuPnRbmGePuf
	 r+kZI9RStw3QWvoIQmwVXbGYbFHG5KL+zpM3NAW1ncHVen5qWwPsK72w8Uwws4REFL
	 Z7qCixahKlgjy3+4y+hdka4yeobztQqdIvG4VcXEeZyzjLcdh6KG07HB8TC4b3ITxn
	 kkpqgaq1qEHLAKQ1QJEhjfsZQoIt06TASoWFc0aR0Z5jzUq4J3x/RsG2AyLVeaN7ku
	 vY6WHFFXiDEFQ==
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org, netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add flowtable map for
 xdp offload
In-Reply-To: <20231121122800.13521-8-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
 <20231121122800.13521-8-fw@strlen.de>
Date: Fri, 24 Nov 2023 11:59:13 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87il5re7su.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Florian Westphal <fw@strlen.de> writes:

> A device cannot be added to multiple flowtables, the mapping needs
> to be unique.  This is enforced when a flowtables with the
> NF_FLOWTABLE_XDP_OFFLOAD was added.
>
> Exposure of this NF_FLOWTABLE_XDP_OFFLOAD in UAPI could be avoided,
> iff the 'net_device maps to 0 or 1 flowtable' paradigm is enforced
> regardless of offload-or-not flag.
>
> HOWEVER, that does break existing behaviour.

I am not a huge fan of this flag, especially not as UAPI. Using the XDP
offload functionality is already an explicit opt-in by userspace (you
need to load the XDP program). So adding a second UAPI flag that you
have to set for the flowtable to be compatible with XDP seems to just
constrain things needlessly (and is bound to lead to bugs)?

If we can't change the behaviour, we could change the lookup mechanism?
BPF is pretty flexible, nothing says it has to use an ifindex as the
lookup key? The neatest thing would be to have some way for userspace to
directly populate a reference to the flowtable struct in a map, but a
simpler solution would be to just introduce an opaque ID for each
flowtable instance and use that as the lookup key (userspace could
trivially put that into a map for the BPF program to find)?

-Toke
