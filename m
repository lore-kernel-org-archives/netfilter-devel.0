Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F3041D125
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790601211; cv=none; b=e1N8gW7RezqgMpwVCVrWoNnaLYUsoZmhub8fJMP/pjKmEypDamGM44H6UpHBEF/zKOog7GkbN4QMhhteIWaPyz6FbylUHXiADcx+js+5pvW1pU/M/C6zB9Bw4SjqMm3PoppStwlLuvpGE5PZ0fiaXv+5yVxSm4bgqC8GqFszkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790601211; c=relaxed/simple;
	bh=zAyxit8Zhi4sBijJUqmL3JmcWMtCw8pYi6Q99BoTFvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFQ2fz8RElf+uLYPQ/gFN3lb0KVI4C4Fy7vmEoiGzMs0jl5abElFr+rL2ZdyFIXRcKy3vamSLV9dCt8oXeeht5fpC3ozucV1PQzFA9q3roik9uR5aNW9DpOBJECv96CjB31nv/t5d5bcg0zk+ftiTKFk7r8bIB3Y4B/96jlxp5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D78E360DEE; Mon, 28 Sep 2026 15:13:19 +0200 (CEST)
Date: Mon, 28 Sep 2026 15:13:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <arpn7_v8156iSc85@strlen.de>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>

Matthieu Baerts <matttbe@kernel.org> wrote:
> Hello Netfilter devs,
> 
> First, thank you for maintaining Netfilter in the kernel and the
> userspace tools.
> 
> The MPTCP selftests are switching from IPTables to NFTables, and
> Clashiko reported that this part of a rule wouldn't match anything:
> 
>   tcp option mptcp subtype remove-addr drop
> 
> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> added to the TCP options, it is added after an MPTCP DSS option (type
> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> (type 30) options in the TCP options. It looks like Netfilter doesn't
> handle that, because it stops processing other TCP options when the
> expected type is found:

Yes, this won't work. 'tcp option X' extracts the
option X.

I don't see how this could be fixed within the limitations of the
architecture.  Just use bpf.

> It looks like it shouldn't stop if the wrong subtype is found, but the
> subtype is not compared there if I'm not mistaken. Should there be a fix
> to support this case?

I don't know how, unless one would extend the kernel to make it aware of
mptcp, which also requires userspace to pass the suboption type to look
for in addition to 'mptcp option'.

> BTW, I'm probably missing something, but adding the following doesn't
> seem to have any effect on my side:
> 
>   nft add table ip filter
>   nft add chain ip filter OUTPUT \
>     { type filter hook output priority filter; policy accept; }
>   nft insert rule ip filter OUTPUT tcp option mptcp exists counter drop
> 
> Same with "mptcp subtype mp-capable", other subtypes or other types like
> "timestamp". But if I use ...
> 
>   nft insert rule ip filter OUTPUT meta l4proto tcp counter drop
> 
> ... then the drop is effective. Any idea what I'm missing here? :)

No idea.
cd git/netfilter.org/nftables/tests/shell; ./run-tests.sh -k testcases/packetpath/tcp_options

passes here.
Even tried adding 'tcp option timestamp exists...' to the test, also
passes.

nft --debug=netlink list ruleset displays the rule like this:

inet t c 15 14
  [ exthdr load tcpopt 1b @ 8 + 0 present => reg 1 ]
  [ cmp eq reg 1 0x01 ]
  [ objref type 1 name tsc ]

Linux 7.3.0-rc3+
nftables v1.1.6 (Commodore Bullmoose #7)

