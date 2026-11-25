Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591346;
	b=W0gcmiso6oVyOnSJ4M+ygzaN1CZvWDrFKyAd0bzE1FUlZXzOxb6WSatibvh+7AYthgpM
	 EktTnRl/D79t0G/It5PFYhNUX1laI5H7smW1mmoDsVJpTLF6er4DTAb0hjy/6+glk4OEo
	 MPRePCAg1dEF89z4ZasxSC4HZQuJPM46jgToIMFWlmRBRAHaJ4AEdXJ2CXc1u0Vl4c3YP
	 dlEI8YIW+feXlRatUEB+03u0MX0hwVykgJGtKgCC1BbuYxuYl91L8ugTtb3iaOqM9Ptx0
	 hQY/f4iH2QAy8JH3+Zz30GVCo2Ahw+8tTEd1OOei6a0zA+TH7rWE5RtVM9tP7/cTOrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=A8YWHJiG1dFBKApi6atkgKH4fcG+bMxDeaeH3bqC40E=;
	b=NKRcO1TEgNXORUb9+lZwF0WcdmVd5vG+r4PqbK237mJ9RenecUntf4sQhoPlGBz0EuxG
	 xEtWv5uNqfPAAAP9zQr8hCckYKuBm6yvlaahE94C4Q4amOQHfj9DitRRopg2M6XPbUno0
	 ZcarEOXLuDdNXdoyEWUwZ0zBrchdEgLsVfNGuRTf6NjbjFtj7ZXaV+7mRQpyDtMGVjiDO
	 FEK8ALLnaq8agydODJkbf7/mFkByCDsHS79OK0ss6UfwsM7LvRlPJJZdRyKYgv/rQX2SC
	 zQ6+ltPh2k2Y8usfOyC/Qps1BXCor/25BL5HR9ODnRGdd97UbftfQ0w1J3XO/36fSWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4DosacG;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED452606A329
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 07:22:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED452606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B4DosacG
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so2377701a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 23:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795591345; x=1796196145; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=A8YWHJiG1dFBKApi6atkgKH4fcG+bMxDeaeH3bqC40E=;
        b=B4DosacGPy5rJ3rVJkUoO06/qefJUsnywqjoPsz+OwDCE4Kh0kms0gh/katoopEiR2
         TqPb6BuNFe0yutUthc+GkppfhDAwy5iug54Mh2imLNmbtzkoAXDMBxKxeZBWF53Gqprv
         znUZsCQPLIn7MaNMt/n7JrZPJiwkJIryHKueWZhkCR69LCERji9bJbdbqfKvlv+475Xq
         RWWikYI2TkF5HCeUxsXkk7vsHiZ6xrJ005uNQw3LyXQ+Dttdmte4cG1z8YdFH0JUYhzO
         21RY+oC02h4+beAaRYJ9FpFcMdm0TuMBCAl2iype+gUdXoWSoNwkS1YuDTiVFezbfFjF
         cEHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795591345; x=1796196145;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A8YWHJiG1dFBKApi6atkgKH4fcG+bMxDeaeH3bqC40E=;
        b=d8ErF8AGWVobFpPfVD+0Zs7f1QKfCTgl4/09coPrqGc9V76hQ8io7nJhZmRkZdA6pt
         dKiszm+EzJLe6FMTmQyFlqOY8Uw/ff3JLuTSaFj4hYK6686qZHcfhCT1sfuZg8b5VgM3
         U3K4miqBaiHPQ+NEt0YrRhodCKcp2c5kcJqzT1Ic7jlpycxvQMsYzLVEDHyUYhgytyMH
         ZjXLmTBeA5IqnCSzf2ira1qd63cH3A/bb86Xxee5kFbE23VKzOaDoKK4SK8qdcLEdwB3
         R2R/pXjN/n9rPtGKRrhdCUydkB5Msxg6/rqBSJR6h6xDpE5wwakHyV1+0Q2ElTLDZlrH
         2sfQ==
X-Forwarded-Encrypted: i=1; AL+hErECENsTf8rLddHr2KL2q+TSQbhrPoPpHXhhd3kTSwkLv46Wt48VfhzP7Gdq2oS99TKt24p+bxSNkCRowJzSZ1M=@vger.kernel.org
X-Gm-Message-State: APuU4Z877YKlPJR7xFGx/s+2syq5MC9RgAg5JeIq790K22w0ia4Fp7KZ
	iGII8ZgNIBkGb0Nbl3Av9yG9jafSx5RnTxp6WAccxc//8FjQu/bGDAAl
X-Gm-Gg: AZFdTZciwrgXD3Kwu11dxON+r48KOhUzt3rfJzAZxJrNLmv7tObYi5Tj3jGV+5Hu3rq
	nJR2FLmc1MwktDsQP+7X8RXAaSzuGfunCgDY1cguspl7LnwwCIvGLVVjyD0r5PiTcDPnk31mFbZ
	69MBUTiQNqDDmcph+JNdsn1HOBFodxvIteKcHAHz13F0EXkBjp3FpkvXh6co2QFce1X2hROenHc
	Um66+U4kubN7m5/E6Gg2hNvIQ+DPNFiiyYVW78EMUZ+t1+iaBQPm5JcUrKzfM2t/70qN+faOLIz
	SHFcjHqQFYyyNcU/zGcjCiHnK2cNnwSDQ1VSO9PdzjzagrNuA/WXSF1mKc4fwTGeA8SWTRlpNoF
	TkzVA+Ah0VrxoXku3bdpkH8Hp6x6lNFbX21bD1KnMHpTun72lY8LR6rgN15VTZeX4Dx+zYVzusB
	CQhP0452ip5uBdUN5/XLzkhI8MhOcTpTxNOnmnOMuFAc7xVg72UfReeEf2wS/hvySoIU3fURLyf
	FEZQfzeBjloSWFpP8Fr8MF8Ux1mfFBDmvlulhTPQzmDdCmi3fvLxt85joB2Vh0pvxjH+EtCGua7
	Objkkq+8YAs5lfM0kwnABgivzPrX+R+zskYFL0votaLJYzrUkBYzO7m7WXGhg6MrGZcrBxzkaKZ
	WQDYgbV3BqlofROxtCRLZOofadAT0rL4JBmv4
X-Received: by 2002:a17:90b:3b8f:b0:3b3:b36e:8c3d with SMTP id 98e67ed59e1d1-3b41cb466f4mr15056657a91.62.1795591345008;
        Tue, 24 Nov 2026 23:22:25 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b703530sm11053284a91.1.2026.11.24.23.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 23:22:24 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de, phil@nwl.cc, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: flowtable: interlock NF_FLOW_TEARDOWN
 with NF_FLOW_PENDING
Date: Wed, 25 Nov 2026 15:22:19 +0800
Message-ID: <179559133958.36524.598452056230313951@gmail.com>
In-Reply-To: <awWMcRVhzciy1gIw@chamomile>
References: <179550685613.38700.16148920957970479663@gmail.com>
 <awWMcRVhzciy1gIw@chamomile>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi Pablo,

No - my tree is based on v7.4-rc4 mainline, which does not have
0abb54363974 yet.

I have now stack-tested my patch on top of your commit on net-next:
all hunks apply cleanly, and the two changes complement each other.

Your commit rechecks NF_FLOW_TEARDOWN in the nf_flow_offload_refresh()
caller after nf_flow_offload_work_alloc(). My patch performs the same
check inside nf_flow_offload_work_alloc() for all FLOW_CLS_REPLACE
callers, which covers nf_flow_offload_refresh() and also the
flow_offload_add() path, and bails before the kmalloc.

The other half of my patch adds the GC-side interlock that is still
missing: gc_step() reads NF_FLOW_PENDING at function entry, before
flow_offload_teardown() sets NF_FLOW_TEARDOWN later in the same pass.
Without the barrier the following interleaving still frees the flow via
RCU while a work item is queued on it:

  GC reads PENDING=0 -> refresh sets PENDING and reads TEARDOWN=0 ->
  queues work -> GC sets TEARDOWN -> flow_offload_del()

I will rebase onto net-next with your commit included and send v3.
Your refresh-side check still works as a second-chance bail there, or
it can be folded into the work_alloc-side check - whichever you prefer.

Thanks,
Qican Ma
