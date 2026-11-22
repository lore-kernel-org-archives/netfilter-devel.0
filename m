Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795385771;
	b=QnwR/74tVH5PfPTpg93DMdCLEwvgbm3OG9BXimActxhUw8iwWRI0tmuh0SUlLdadMsB+
	 Ujn+gAUwkWSzodLh3jRhKZAcLx3cyJsGZgL2ff4js5EmF+hIgMK9lJZiPpJD8yWu4snQW
	 cQPjKGmJU0LMrYawmYoWKbpoJwH81mzbViefufV9c8xwbNFg14TVPfuL6/Kbpb5bqcAz1
	 X9iucB3sI90487dslMdB+2TC+3UgcuF4QYnC5ManuR8tzf/G+nXTuCBTLaN/7ANL2pzIr
	 vHRFosrXGRQF4R2WUfVLdPEdSNRDP0w1wv3JhIEZ2YXV+I+ZVIxGN1TiDByFTjGqT2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795385771;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=mGwepXW7KYcugk4KqQl//W14cGi7/Nr85LEGwhqP424=;
	b=xTs2VzkC2nM/WU/P6f/J/wOQJ67xFDrnBdCgfYDOrnRakhQMwD/i6dN3IWE0Hlbye4ID
	 yPChqzjjDC5TIEJu3JPUEhsVCuXK8Es0ho2RjVD+EZ2hCHY9biZYlvpsYQFrm97JSkSdQ
	 U+LyAYRY+oOqFcJUAVNExxCQ6jJCVsgUIung51YXLCHA7kCWi4v5nZugqNQxvbfV7QITn
	 j3bHTuJDgsVQvOVDz3txpf4kHp9v0SR225SCreex250JaNo2co503L05G+m3yabFaTTTp
	 T0zH7/bULyz3OZ5Cict+MDHi7zLV9n8NuwC8vF/YlJJcMTmIU+Js+PiFUE7sl0byY8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=H9n1IhWH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E7DF9606A31D;
	Sun, 22 Nov 2026 22:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7DF9606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=H9n1IhWH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795385766;
	bh=mGwepXW7KYcugk4KqQl//W14cGi7/Nr85LEGwhqP424=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H9n1IhWHv1woomfQ4RYoN0aTrHZKsx66x92zf49O4WXZTDPfZR5uRcOmj9b1u7nPS
	 SzVxBfv/9KfIUXGTkoe3CIrX8izXn5N2R6liLtCxn+GwqD4ooemjTXnbuXgaT0v6VG
	 ZKqkSYfjj58Wiq/T4K10EpWIPoO8bM9/nwBcxPtnkTQDH8aSEC4Fp7ghKui38SetBc
	 ppo3TttVJaBEgWeE/QPYjbL0vPkKumMUd9pqsk0lU5fW+Qi9KpxR90HjTo6R6bpFoZ
	 B3HfShERHX7nZzn6Ba96/5if5Nah8/OU0hocxVEL11e96qS4aAOmoY5+swze3qbh3y
	 vFobbihZY1r1w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id ACE4F60056;
	Sun, 22 Nov 2026 23:16:06 +0100 (CET)
Date: Sun, 22 Nov 2026 23:16:03 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: florian.fainelli@broadcom.com, netdev@vger.kernel.org, fw@strlen.de,
	phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
	shuah@kernel.org, toshiaki.makita1@gmail.com,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 1/4] netfilter: flowtable: do not queue offload work
 after DESTROY
Message-ID: <awNpo-FYuOlgfP5a@chamomile>
References: <20261118201250.2075007-2-florian.fainelli@broadcom.com>
 <179538224441.3135.6950839726802616846@kernel.org>
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
In-Reply-To: <179538224441.3135.6950839726802616846@kernel.org>

On Sun, Nov 22, 2026 at 09:17:24PM +0000, netdev-bot+sashiko@kernel.org wrote:
> The creating CPU then carries on:
> 
> CPU1 (creator)                       CPU2 (GC)
> flow_offload_add()
>   rhashtable_insert_fast(REPLY)
>   rhashtable_insert_fast(ORIGINAL)
>                                      nf_flow_offload_gc_step()
>                                        teardown, NF_FLOW_HW clear
>                                        flow_offload_del()
>                                          flow_offload_free()
>                                            call_rcu()
>   nf_flow_offload_add()
>     set_bit(NF_FLOW_HW)
>     nf_flow_offload_refresh()
>       nf_flow_offload_work_alloc()
>         test_and_set_bit(NF_FLOW_PENDING) succeeds
>         NF_FLOW_HW_DYING clear, new check passes
>       queue FLOW_CLS_REPLACE

Yes, PENDING needs to be held from flow_offload_add() path for this.
