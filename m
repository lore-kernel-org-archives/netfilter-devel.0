Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E63234CFAC;
	Tue, 21 Oct 2025 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761064456; cv=none; b=kTYQF17Nn8lOnPpyRfhM4hseghZbC/P4u6D9mSj59Z3R1MvhuX1F+JO6WpveKTXvySHGwXkdCc00/IbT4Djdoprj6hPWPrs+GZeK5l6Be+kMu0gS898NBN9sH+jnsS0oEoAd4UdzyUjh1jxo+hlXgNFOS1MdFq4uToynAlZgnUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761064456; c=relaxed/simple;
	bh=VjqtBIUPiuMVY4lCtpLflCWS91uQUJQpCgx63EVksdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8mWickyvD9rMMIg5udm0/A7JJDGY3qXTVDYHsTJtN8OCDim3SPBaSOHW5CYQbLumWDisuHflBaoA1uLl2FYsIB5DhrpRpv4j459jT41koc8xbeqVR/SGXnKveuu/Gpx2/DfrjjYqtYkpIrp+QSpxXiy97pagZXWiPlK562N6NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ACD32605E0; Tue, 21 Oct 2025 18:34:11 +0200 (CEST)
Date: Tue, 21 Oct 2025 18:34:06 +0200
From: Florian Westphal <fw@strlen.de>
To: Andrii Melnychenko <a.melnychenko@vyos.io>
Cc: pablo@netfilter.org, kadlec@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] nft_ct: Added nfct_seqadj_ext_add() for NAT'ed
 conntrack.
Message-ID: <aPe1_kECjXm3Ydfb@strlen.de>
References: <20251021133918.500380-1-a.melnychenko@vyos.io>
 <20251021133918.500380-2-a.melnychenko@vyos.io>
 <aPeZ_4bano8JJigk@strlen.de>
 <CANhDHd8uEkfyHnDSWGrMZyKg8u2LsaMf-YXQtvTGgni7jetdZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANhDHd8uEkfyHnDSWGrMZyKg8u2LsaMf-YXQtvTGgni7jetdZg@mail.gmail.com>

Andrii Melnychenko <a.melnychenko@vyos.io> wrote:
> Hi all,
> 
> > I think this needs something like this:
> >
> >       if (!nfct_seqadj_ext_add(ct))
> >            regs->verdict.code = NF_DROP;
> 
> Okay - I'll update it. I'm planning a proper test.
> 
> Apparently, I need to provide a simple test FTP server/client, not
> fully functional,
> but sufficient to "trigger" nf_conntrack_ftp.

Argh, I forgot we do have an ftp test case in the nftables repo, even
with NAT.

tests/shell/testcases/packetpath/nat_ftp

in nftables.git repo from git.netfilter.org.

So it would be easier to extend that instead of a new kselftest for the
kernel.

From a short glance I guess it works because the address rewrite doesn't
need to expand the packet, else this should have failed and found this
bug...
