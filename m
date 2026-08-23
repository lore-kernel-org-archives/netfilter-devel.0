Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED5E3A1D02;
	Sun, 23 Aug 2026 19:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787514020; cv=none; b=bCXogrXI2r8r6xrR1QHAscsznxUq9ZNvXt/2VawqyAKpEJzPXwReVHow9hp6VlRQmcDCNWFr4SNRkaPomAbiK7tOC3cgDgSHY35G+uuVq+0iZSlNSNPDNZZcsWjFcxPhVMwwTJeoL0k6dD6Y4aMZrUbVS/HMsBjk6ZBm64TDr48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787514020; c=relaxed/simple;
	bh=rgqzCJQu8gPbKqfuVaMw5ziRxD/SJ0mfwANpxBUAkG0=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=NgiP32vaNVAA9bnNuMP6pQjwMJOLUxkN6ChyZXXy5Ogmpd5c7Y5o6wduf/WrdgztTowJeXjX3cPKs1SfJZzM52kB0uDFNTdg87PeJuGJnSHdfwBK9BoJ3TiDoWUid1GqgXKK986RE2xYmXYeKDtwxOVUUuwwXNUO1O0goTcugRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=MB0wE10N; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="MB0wE10N"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3qEAzX+DfQca6vdvKFV3joFRrQQ3XK5yBMSP9yHeC6I=; b=MB0wE10N04O5PYHkaUBa9dwCp6
	PzPG2L7je5duLnbwQRra4gD7skmbUz/CrmIZiO+/ykrNfkl8z3q5NoI5H1XaiNwzsYwKmi0ZX1doj
	BCW8y5mUN42+oMW+QNQVAbmT8fjgEfVInIJ3HF7zvzS69lFk+oEweAus0kcJykjkqul/k9WdcQeLt
	OIsWmyvlIX3QL0ItgMs1ymc35GnlLLdxkHT/XUPTPQ9g5DUZqEcQabCCIk7sqDITvOyWd28l+z9yL
	3/4I6BNZ46CM0kJptDbvrefp092BzsgBTWOdZxr/fAh2F44r149Md2L66aG8/UFI+iqW2n3BU6nvK
	hoS/n5Pg==;
Received: from [::1] (port=42402 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1wyE38-000000068bZ-2vvK;
	Sun, 23 Aug 2026 21:40:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 23 Aug 2026 21:40:10 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] netfilter: bpf: disallow conntrack kfuncs for token
 programs
In-Reply-To: <DKWK8L9QBA37.2QGA0WNXIBV9C@gmail.com>
References: <20260822210945.1003967-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <DKWK8L9QBA37.2QGA0WNXIBV9C@gmail.com>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <fab86b47f4fcc7fa3f180f86c6e3f914@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

On 2026-08-23 21:12, Kumar Kartikeya Dwivedi wrote:
> On Sat Aug 22, 2026 at 11:09 PM CEST, Jérémy Jean wrote:
>> BPF tokens delegate BPF and network-admin capability checks to the 
>> token
>> owning user namespace. Conntrack kfuncs nevertheless accept a network
>> namespace ID relative to the program context without checking whether 
>> the
>> token has authority over the resolved namespace.
>> 
>> An XDP program attached to a veth in a child network namespace can use
>> the peer namespace ID for init_net. bpf_xdp_ct_alloc() then allocates 
>> an
>> entry in init_net, bpf_ct_insert_entry() publishes it, and the lookup 
>> and
>> mutation kfuncs can subsequently access that host state.
>> 
>> The verifier retains the token in prog->aux, but it cannot determine 
>> the
>> runtime namespace selected through bpf_ct_opts. Conservatively reject 
>> the
>> conntrack kfunc set for token-loaded programs. The kfunc interface is
>> explicitly unstable, and ordinary token-authorized XDP programs remain
>> available.
>> 
>> Fixes: caf8f28e036c ("bpf: Add BPF token support to BPF_PROG_LOAD 
>> command")
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> 
> So your solution is to just begin rejecting its use? Proper scoping and
> containerization of programs is a bigger project that needs more 
> thought.
> It needs to be addressed properly across the API surface, we probably 
> have
> several other helpers/kfuncs that have similar ns-unaware behavior.
> 
> If we went on to simply reject each case programs using BPF tokens 
> would
> basically become useless.
> 
> pw-bot: cr
> 
>> [...]

Hello,

Thanks for your answer.
I merely raised the issue to you; there indeed may exist more similar 
ones.
However, I unfortunately don't have enough time to allocate to a broader 
fix.

Regards,
Jérémy
