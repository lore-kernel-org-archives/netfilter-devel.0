Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965372;
	b=mxfOZAEVxioFfzGinupYETesxWAt5DGzIgkzChnBSMwcAJzTP+DUwUgFXeKu1tqr9wzy
	 7y0OuKazkm5Vd2zjJXn+g9XeP80khGGQC6kmI5O9madNthLQkidbKFJsMHlxUv0OGgXkL
	 fCvtxKuRPo6muzWP60buT+Di/YU+bLTQp/AOst6s1YpJu6yot3RIu/rofZFdsJ2VEYGLt
	 uxHDqhFuqrZOGOeK3+WJbwFkRz+QrGr9A1MnBWlHIs17qMvuLxpWCgDUKUeXn1az3Nowb
	 GKQz37YE1AfOW507L7fPpJl4uxbDpGF+yafmpERnwSz3F9QpoNNLZh4c0tmcGn5rYRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965372;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=fcCnOw+Qr+S5uQ+MRojJJQS8TzyKP9X9UMuKjYDlDwo=;
	b=GVW6NCEmBScDlCQ17/sZAVfMPoZ78fV54A6RGoKVuuU6MQuxlgFOEHprtNTZ27pRy9W1
	 2NFmFWI4XNtojHi0zBmlvj7YDRP5wPhwB+bL7MABwJN6NZZdDXj9dwtv43FwCVX+ZG1/G
	 sClPE7H/tAtbg9lQUkDCI1byzJNX6MMfmpU+KHjn8+TvpCOrq5wpwnTEl4jUTRsDGoMQx
	 mwP8XF6/oWXS2xsbpgR47urpI97mRtY7WEZamiDRGwZPadvoojttQdJosjq7VT8YU2XUH
	 3fw8XDBkiwW7D/+Z5/iFcB1Qi60ppXDsnlupsCndyOEYGmD2N82+knXCOuAhuRmyqMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=S+CB7DF7;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D4B04606A907;
	Fri,  6 Nov 2026 11:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4B04606A907
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=S+CB7DF7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793965370;
	bh=fcCnOw+Qr+S5uQ+MRojJJQS8TzyKP9X9UMuKjYDlDwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S+CB7DF7gGzH9g4SC/PkPjBLOug2oHYficD7j4snQI4Uzui3qrZN1yyqI6IVicsLH
	 xBkKA66wKpHMHhThQETcndw7QaDFxErrYdOkBN8coKA41s8eHsbhkDJBJONENe06BT
	 4RM2vJ2vxrMApSp14fzRFqQ//Cuels+X6tvsmHVOT9NP/+MwKyeL6+/K0T0H8Bf3BI
	 wDEjc27CxB604CWQeX7Clr54pTcrOKW6Q+ATET0Yx6J74ZHNQuperS/gfd632qZ6BK
	 VpwElfuhmPoobmYrJaGWHQxJ9eVDmjtik7H8RotPLS8+GJ8LmWW4JVcIsNVXKxQMN8
	 CzyShYjSIclWw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E50DA6005D;
	Fri,  6 Nov 2026 12:42:49 +0100 (CET)
Date: Fri, 6 Nov 2026 12:42:47 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@kernel.org,
	horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net,v4 00/12] Netfilter/IPVS fixes
Message-ID: <au29N1V8ogEUKDyd@chamomile>
References: <20261105124536.1009301-1-pablo@netfilter.org>
 <20261105154808.48fa2a97@kernel.org>
 <au26c2NFsX6gCCPo@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <au26c2NFsX6gCCPo@chamomile>

On Fri, Nov 06, 2026 at 12:30:59PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 05, 2026 at 03:48:08PM -0800, Jakub Kicinski wrote:
> > On Thu,  5 Nov 2026 13:45:24 +0100 Pablo Neira Ayuso wrote:
> > > v4: - Drop "ipvs: do not create conns from packets with port 0".
> > > 
> > >       This PR was already reviewed in its v2 by netdev-ai-bots.
> > >       I have dropped all the patches that LLM flagged as needing
> > >       more work even since.
> > > 
> > >       But I really think v3 was good enough and a follow up for
> > >       "ipvs: do not create conns from packets with port 0"
> > >       was just fine to proceed.
> > > 
> > >       Maybe patchbot will ban this pull request again, v3 was
> > >       blocklisted for not fulfulling the 24 hours rule, that is
> > >       why it was not reviewed.
> > > 
> > >       But, as said, this was all reviewed in PR v2 already, this
> > >       is just keeping back 3 patches included in PR v1 needing
> > >       more work.
> > 
> > netdev CI keeps hitting a kmemleak since this morning, lines up with
> > this series, tho TBH I have done 0 investigating...

To clarify further: I think it is just a coincidence, I don't see
anything in this PR related to this.

There is a known bug related to this in the pernetns exit path, I post
a patch already but is flawed, I'm looking at improving the situation
with a bug fix :-)

> > $ cat /sys/kernel/debug/kmemleak
> > unreferenced object (percpu) 0xc0ffff86522458 (size 12):
> >   comm "modprobe", pid 17854, jiffies 4295218150
> >   hex dump (first 12 bytes on cpu 0):
> >     00 00 00 00 00 00 00 00 00 00 00 00              ............
> >   backtrace (crc 0):
> >     pcpu_alloc_noprof+0x76b/0xd70
> >     nf_flow_table_pernet_init+0x46/0x90 [nf_flow_table]
> 
> This is not handled by this PR.
> 
> I will submit a patch for this asap.
> 
> >     ops_init+0x187/0x570
> >     register_pernet_operations+0x395/0x8e0
> >     register_pernet_subsys+0x28/0x40
> >     nft_masq_dump+0x66/0x190 [nft_masq]
> >     do_one_initcall+0x124/0x4f0
> >     do_init_module+0x2ad/0x8a0
> >     load_module+0x154b/0x1d60
> >     init_module_from_file+0x11f/0x1a0
> >     idempotent_init_module+0x37b/0x7c0
> >     __x64_sys_finit_module+0xdf/0x190
> >     do_syscall_64+0x10e/0x570
> >     entry_SYSCALL_64_after_hwframe+0x4b/0x53
> > 
> 
