Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0609928BAA5;
	Thu, 22 May 2025 14:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747924745; cv=none; b=V5ZG68TDX7oED9bnAisMl1hI0jRIjhyELrhcpPPHJHpVBOqDnCwZX9+5JB33iKPAM8TFgms7wQI5HWpiiOPkP3er8DDKd66tFDS4H7kHWCk0fqExuGVar90CZnw4EOClBYZ/kC6HXSJVjXX4il2Cjr15gsjnXqOXcVwZoRCIAfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747924745; c=relaxed/simple;
	bh=oqAz4JmjtntNYi+D7LpyRyjTfHkwu/saf8HvdmNPyJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAj3ubv088cIzDPA8ct+tZ6OxPCG52xFrc8W3ZtlmpJ00QH4wpU8wZ0wquX1wQyYEzEbwjvzxSo9Q5tuPQApbp5uO+t3sjalV/uSMXxrAtayOwwW/EyJBnPsry/me+o5dSyn//VKxvAOmXDh/oSZuMnQ6VC4R5qHPESi+2wXS9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9FB4A602AC; Thu, 22 May 2025 16:38:59 +0200 (CEST)
Date: Thu, 22 May 2025 16:35:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: nft_queues.sh failures
Message-ID: <aC82JEehNShMjW8-@strlen.de>
References: <584524ef-9fd7-4326-9f1b-693ca62c5692@redhat.com>
 <20250522065335.1cc26362@kernel.org>
 <649e3d9a-48b4-4660-99c5-1609e3cd06cf@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <649e3d9a-48b4-4660-99c5-1609e3cd06cf@redhat.com>

Paolo Abeni <pabeni@redhat.com> wrote:
> On 5/22/25 3:53 PM, Jakub Kicinski wrote:
> > On Thu, 22 May 2025 12:09:01 +0200 Paolo Abeni wrote:
> >> Recently the nipa CI infra went through some tuning, and the mentioned
> >> self-test now often fails.
> >>
> >> As I could not find any applied or pending relevant change, I have a
> >> vague suspect that the timeout applied to the server command now
> >> triggers due to different timing. Could you please have a look?
> > 
> > Oh, I was just staring at:
> > https://lore.kernel.org/all/20250522031835.4395-1-shiming.cheng@mediatek.com/
> > do you think it's not that?

It is, thanks Jakub!

With my updated test case, it does pass, but see for yourself:
# PASS: sctp and nfqueue in forward chain (duration: 118s)
# PASS: sctp and nfqueue in output chain with GSO (duration: 56s)

(the old timeout was 60s, so this would FAIL without the updated test).

plain net-next/main:
# PASS: sctp and nfqueue in forward chain (duration: 42s)
# PASS: sctp and nfqueue in output chain with GSO (duration: 21s)

I haven't debugged yet but i'd guess that some packets get corrupted
when nfqueue segments gso skbs, thus forcing retransmits.

> It's not obvious to me. The failing test case is:
> 
> tcp via loopback and re-queueing
> 
> There should be no S/W segmentation there, as the loopback interface
> exposes TSO.

The nfqueue test also forces software segmentation, even for lo, so that
the userspace listener gets non-aggregated packets (its possible to
disable this so 'large packets' get queued to userspace, this is also
tested for tcp by this selftest).

> @Florian, I'm sorry I should have mentioned explicitly the failing test
> before. Sample failures:
> 
> https://netdev-3.bots.linux.dev/vmksft-nf/results/131921/2-nft-queue-sh/stdout
> https://netdev-3.bots.linux.dev/vmksft-nf/results/131741/2-nft-queue-sh/stdout

both show sctp failing:

# PASS: tcp via loopback and re-queueing

---> tcp loopback passes

# 2025/05/22 05:11:46 socat[32441] E write(7, 0x55ca6b34e000, 8192): Connection reset by peer
# cmp: EOF on /tmp/tmp.1LVNFztWUK after byte 50208768, in line 1
# FAIL: sctp forward: input and output file differ
#  Input file-rw------- 1 root root 209715200 May 22 05:10 /tmp/tmp.teqIUO7Jfh
# Output file-rw------- 1 root root 50208768 May 22 05:11 /tmp/tmp.1LVNFztWUK
# 2025/05/22 05:12:46 socat[32459] E write(7, 0x561110e23000, 8192): Connection reset by peer
# cmp: EOF on /tmp/tmp.1LVNFztWUK after byte 36528128, in line 1
# FAIL: sctp output: input and output file differ

so its sctp+nfqueue thats failing.
And it does seem to be related to the pending patch pointed out by
Jakub.
> > I'll hide both that patch and Florian's fix from the queue for now, 
> > for a test.
> 
> Fine by me.

I'll resend the update tomorrow, keeping the OLD timeout of 60s, I think
keeping track of the 'transmit time' in the test log archives could be
useful in the future.

> I was wondering about this timeout specifically:
> 
> https://elixir.bootlin.com/linux/v6.15-rc7/source/tools/testing/selftests/net/netfilter/nft_queue.sh#L329

5s isn't so short, lo is supposed to be fast (the userspace prog
asks for GSO packets, so no s/w segmentation should happen but even
with GSO segmentation I would not expect it to fail).

I would prefer to keep the 5s for tcp; I don't recall this was a problem
in the past.
