Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794570449;
	b=zaGU1+O2J2t2Yp1I3lH19mO45HOLEJSrwDCmka3F0yWio+EnYAiL8/GU2WRrBkxaU9vC
	 eEHjg1+tvFhd/Ol+WBcuVhslMfskZpd8JczljRRb6bJUGSYckAXOPT8idqd3W3NnMpWLr
	 nBjzHoGmjLCGTd/gmXqVQE8q1HjSSyKzPLLhA070g5iyJZN8PfxFTz/5WGTzAdJWOj9rr
	 wvbFJLOQdRAPa/gPXF6O25qPDBHpbxJk4SPaCKY5AldHSs9CSv/y8yzlIbCdvw6Q+IOCX
	 qaZbLNFRf/PO5MdThy7PioOv3t2hfysR+5Xp43lFiYGLtj3HdqMNru5vvdJAFBYTqGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794570449;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=L8Oxm/zXPBLhazILHETxILKKFO9UIid5BwUc3DXTOuk=;
	b=wWbUMcM3UUq4HGPI8Om8geDH07pU3mzE1Gnl1XOKTFg4KltVPxwIFS0YBCc/yn2yUI8x
	 G2Q7m1FLCzjk6BEs7u4py6JU4LzECXqKVRF4lCy8BRYax9HogIt+bw7+UH2n7124aSpA8
	 1fVS+1unbiwCRqHUJz/0yWfUOVKTGNggBicIdNbraBtLi1TKE56+kLL6+kq1Yj/skuT6i
	 BtrsFdZNv0Baf/LrxiPOng0EfnqGk5dtf21tGN2E1F1RkJgSTeD4U/PTA5B9d/0ELAm2v
	 Xu4x3W34BLFDYvIBdh4upGDlecya6MPknp3LFKhpVdkgNmktVciufcM004qwJDWS/5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WfrAlYuS;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id DF200606A32D
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 11:47:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF200606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WfrAlYuS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794570446;
	bh=L8Oxm/zXPBLhazILHETxILKKFO9UIid5BwUc3DXTOuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WfrAlYuSdyHnfAlyw1KM6k2SnEBqLaMKinYVX2vMwDaG/FPuf1vdrzlk17Hhcp9eF
	 ZTCk3/wXvTIv0NAEgxNGqPMU7bDbrt+ZVQodAg05V78qS0Tx0l5pLpuGWNhaMt4yKi
	 yzmTc6N0Ub1S4VPYvjujhofYlwdzryG00CROf5X2HB6/UBEdXsrMO4ej0AYWejaNP2
	 sXoaQ6MPcIEDNsSxftB7UZc2VKuGVOPN9yWAABE20BnmGZESgLGWaNZW3Ft1fUZ3gr
	 A5fZXKetiMHZ+A9JKyYYcr6eiTCY7bDNpvOrBKLc8APOvtUBhv7psMsB9FGoxGmnqL
	 bZD9iqs+HieTQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B249960056;
	Fri, 13 Nov 2026 12:47:26 +0100 (CET)
Date: Fri, 13 Nov 2026 12:47:23 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Stosse <florian.stosse@harvester.fr>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl 0/5] libmnl: fix memory safety issues found by
 static analysis
Message-ID: <avb4y4AJsR6LUqgz@chamomile>
References: <20261106191841.1645-1-florian.stosse@harvester.fr>
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
In-Reply-To: <20261106191841.1645-1-florian.stosse@harvester.fr>

On Fri, Nov 06, 2026 at 08:18:35PM +0100, Florian Stosse wrote:
> Hi,
> 
> This series fixes five bugs found while analysing libmnl with Frama-C
> (Eva, WP and E-ACSL-instrumented fuzzing). Each one was then confirmed
> on current master with a small standalone program under ASan/UBSan.
> 
> None of them can be triggered by netlink data received from the kernel
> through the usual parsing path. They all need a caller that uses the
> API in a less common, but valid or near-valid, way, so I am sending
> them as ordinary fixes.
> 
> Patch 1 is the most relevant one. When the message that overflowed a
> batch is larger than the messages already in it, mnl_nlmsg_batch_reset()
> memcpy()s it onto an overlapping range and then reads nlmsg_len back
> from the overwritten location. With limit = 100, a 20-byte message
> followed by a 92-byte one leaves mnl_nlmsg_batch_size() returning
> 0x97969594 on glibc/x86-64, and the next mnl_nlmsg_batch_next() uses
> b->buf + 0x97969594.
> 
> Patches 2 and 3 fix out-of-bounds accesses on unusual input:
> - The *_check() builders compare the unaligned nlmsg_len against
>   buflen while the attribute is written at MNL_ALIGN(nlmsg_len), so
>   they can write up to 3 bytes past the buffer.
> - mnl_attr_get_payload_len() wraps for nla_len < 4, which makes
>   mnl_attr_parse_nested() read past the end of the nest.
> 
> Patches 4 and 5 are minor:
> - mnl_nlmsg_fprintf() can read up to 3 bytes past an unaligned message.
> - mnl_cb_error() can compute -INT_MIN.
> 
> I can send the reproducers if they are useful.

I'm planning to apply 1-3.

Patch 4 and 5, it would be good to display in some way that unaligned
bytes has been ignored while printing. As for the -INT_MIN case, it is
probably safe to remove the workaround in userspace, IIRC this was
helping with a very old kernel where netlink was reported a negative
errno value in the error message, it can possibly be removed and the
need for this ugly corner case will not be needed anymore.

I am looking into adding

#ifdef __GNUC__
#define unlikely(x) __builtin_expect(!!(x), 0)
#define likely(x)   __builtin_expect(!!(x), 1)
#endif

so this can be used in patch 3 in the check there.
