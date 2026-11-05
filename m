Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793922490;
	b=XCbyZk1StaDBeImKkg2MnQgw4xPonBJ7PbkgE2Wq4XU5rqo5VoZL/vk/lu7vIMiaQrKN
	 io0X+4r+hWj6eg/5D7wvZ04dbv7cenJ4UtYlnUZPGjfrZcl07nTULkX6QKh+hPPbuPOjC
	 F9KtQZ6GvcdYyQ7dduFApiSw+98h6Iq1y098dKDoLmGSKZDVHyHb7etbm+UzWGHZJY6gr
	 XfgfOXEj8rXPMrWTE5gRVVX7Wv6U66gxM97GsqKQuusK8OL4oDVgNRIHlijtAythuLYDn
	 3AxxLmUISx2K+NM4PxfoesrtxVYiWDweMb4sFuVLdU+97C5KWCKC9qnBPIHqAv/ZbWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793922490;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=nrwWftTY0nW1OtVHwLcoMlFahm3Lvr8LEJONSYVihg4=;
	b=3ljKhk+9VIT9SzvO6FTNtiAlKEZENADvq387edqSq2Y/a75hXWtL3fxrVzzJXcCJ+Ji4
	 CPRdTVJ5Z+QT9c4rgeTI++M4XPr6MsmhuoR+pcFf6wc9j2XttR4B1Z8vg9Adbwn1053RV
	 hRs4n501RIcSKZTflioPooID7p4bB4ojJsYoiMdTTooC/K8zxfAPkuvN2PKm/RBMzbNS2
	 p3O8MqBVLK96XFTqeoNqM+cOjFxKAnPMMaiEajSokW22sP88l1txEhsJ3ZbsjvvQIQOiZ
	 WC/DIeA4WZFTSE1EGTxv76NFm83fInAJRFtjdqhK1t9sMXAbYquwDrxBtQhAsW+ygPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwED+haR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9EB606D834;
	Thu,  5 Nov 2026 23:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwED+haR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BF81F0089F;
	Thu,  5 Nov 2026 23:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793922489;
	bh=nrwWftTY0nW1OtVHwLcoMlFahm3Lvr8LEJONSYVihg4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kwED+haRkaS78y/e6PVfg34OVWh1hQ6tiDsJNQX4PVkQPf645GcbPlSz3ECYP5Klj
	 npHJG/Ej6Z9PsOVcsFCejv1FPLnmfFaoAwQBdlnSV/0NMz/LtRzOL9a1oZOSfcR/m3
	 wcgUlg3k7k3u4zAoCp5Sjc8ziM4aSzLiAacKt+m30o9pdVxPF73FLSsRWzOznKGQL2
	 7p/+3uBknSZ9EOGgGjEwuqFmtBcsgEOoXSeYCGyrw1l3LKaOGO3LkcstFcsdCZx0XN
	 bWUlgr376a/spy4UoVXwQ5ZtVNkRqXX/F/hLscj1b/vkOFgwotg4MYOp5uPiuRNEAR
	 3VUXc0RCAnWMw==
Date: Thu, 5 Nov 2026 15:48:08 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net,v4 00/12] Netfilter/IPVS fixes
Message-ID: <20261105154808.48fa2a97@kernel.org>
In-Reply-To: <20261105124536.1009301-1-pablo@netfilter.org>
References: <20261105124536.1009301-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  5 Nov 2026 13:45:24 +0100 Pablo Neira Ayuso wrote:
> v4: - Drop "ipvs: do not create conns from packets with port 0".
> 
>       This PR was already reviewed in its v2 by netdev-ai-bots.
>       I have dropped all the patches that LLM flagged as needing
>       more work even since.
> 
>       But I really think v3 was good enough and a follow up for
>       "ipvs: do not create conns from packets with port 0"
>       was just fine to proceed.
> 
>       Maybe patchbot will ban this pull request again, v3 was
>       blocklisted for not fulfulling the 24 hours rule, that is
>       why it was not reviewed.
> 
>       But, as said, this was all reviewed in PR v2 already, this
>       is just keeping back 3 patches included in PR v1 needing
>       more work.

netdev CI keeps hitting a kmemleak since this morning, lines up with
this series, tho TBH I have done 0 investigating...

$ cat /sys/kernel/debug/kmemleak
unreferenced object (percpu) 0xc0ffff86522458 (size 12):
  comm "modprobe", pid 17854, jiffies 4295218150
  hex dump (first 12 bytes on cpu 0):
    00 00 00 00 00 00 00 00 00 00 00 00              ............
  backtrace (crc 0):
    pcpu_alloc_noprof+0x76b/0xd70
    nf_flow_table_pernet_init+0x46/0x90 [nf_flow_table]
    ops_init+0x187/0x570
    register_pernet_operations+0x395/0x8e0
    register_pernet_subsys+0x28/0x40
    nft_masq_dump+0x66/0x190 [nft_masq]
    do_one_initcall+0x124/0x4f0
    do_init_module+0x2ad/0x8a0
    load_module+0x154b/0x1d60
    init_module_from_file+0x11f/0x1a0
    idempotent_init_module+0x37b/0x7c0
    __x64_sys_finit_module+0xdf/0x190
    do_syscall_64+0x10e/0x570
    entry_SYSCALL_64_after_hwframe+0x4b/0x53
