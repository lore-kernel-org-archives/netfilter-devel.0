Received: from mail-yx2-f5.google.com (mail-yx2-f5.google.com [74.125.224.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ECF2BE656
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475322; cv=pass; b=V67l6fqZbtW6v994H38kKbHA8cikrfARvQtd7bYdbTN2ep1/7sYqtGHHPXK1AIPPD1L4BUl4Crjf7yFygSY3tuFmNuHOvKpfqDu1WD47anOLnwmR68RupBtyR86yYdukSBWas1UMH3D7V1XovanSIpJgYCR0zdqIbMPwk8M4s/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475322; c=relaxed/simple;
	bh=zKZrGNVIyZXHBRCxfwfOKfxmv9vpaw+fFtJmZfucaZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qCD8pEEvnxly5LoXaU7+Pza6qjX3/++rD3J7r292/gAD/31ayMXxAUERQIHlxD+BRmSXdjiZnWvZxRFj50OrygjV9dtsA4dOVhNIOaGoiXLw7NTsVp2O/0XHgVLeXBK40nEGEqLYXQRpUDh23+ed7jpT2mYqFBAEBlGa/NTw2To=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rPbrEW6i; arc=pass smtp.client-ip=74.125.224.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rPbrEW6i"
Received: by mail-yx2-f5.google.com with SMTP id 956f58d0204a3-672d92bbfd3so2289619d50.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 09:02:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791475320; cv=none;
        d=google.com; s=arc-20260327;
        b=LuC/sGHfXi+dZLxueLIsWpGG9XrsZA2WjL5T42KJmGQvLOQLKgX1e5DijZMB1w/+i5
         4LfZATpQdVDcerbIlWPpAMwiaSZ9vXoWCYs2UF3Q+9BdXgye7JpUUa/sxB/O+pqxU7jK
         JOOw/wXh4w5HCdo6cB8jngS+RCegqHhwIuejzA1mA5LO7CABLOoVRm0VWaHJrFdf91eh
         GleWwe1ZL+k55akFAKbG4MsEgkejnmPF7ZH8puf4CEfy6Qk5H+tu8tFSsUlSAVThGS3P
         6CGGYY66o02OOWVrNDL/C4xPxLtPSYmFRI+FjmL7RcG5dOf8QLy/zoPKFCg0eKrg5ooz
         T5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zKZrGNVIyZXHBRCxfwfOKfxmv9vpaw+fFtJmZfucaZk=;
        fh=hP84dkpPZ4eEH2uOku8PEYFkplzYOgzqYqMo1Xz8auE=;
        b=kowF26npiB3Af5sb1tzmZ3qiU0LQ6/gCj5n6+bX7ZO2iqdnBhPtnnefuDl8CIyYTRU
         nFD4YpJGNa6BQ+b3BOfTNiLHSRcVXrT2n0OoIflipoppzNKZyWKlT+jszsCAeLzSE3yK
         ckup8Ck2bHaazPQ5JCXtiMkCC9CjyY/zUZ/EQD/jxvGOiDSZ/C1sVUAnW0LlpYA/ZPjp
         mmHBML0i7U6roZBQ8uDAkA40NMRxR4xOwMeE/bImR9vu3bSDWSwdYRMU5ImKH5sSU40S
         EyWc61r7QC3/8IcfqRja2w7BwQ9MmtPjaNgllE/QCq3sjHAxk23GyDJTFTmFsoMc2Fj9
         tq8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791475320; x=1792080120; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zKZrGNVIyZXHBRCxfwfOKfxmv9vpaw+fFtJmZfucaZk=;
        b=rPbrEW6ivPSw46LZCDhFByYnqU725sPKroIph5mMvWVRZilBEy0fTTjEAbyoXClQIS
         5P6fp6UFH4ZDAdrkW7D7hhXnWmL/2t3e/fXyF8b8IM4VK/97MbVY8+CJuqykGtyJbSAo
         9MpYw/zdCkIUkvTW2NaCi++oU6h7EFOWorcbEdZcZOYG11aVKMK1V3fOUsVhvrYw9bs7
         VY5xQpJyWk+7H8RrBOOusZPS3z2//n6CRypgvW63wD0X//eRh40EA29D9apIyDpOMp7F
         etQUd8aA2xGE/IQ05vkcr05Qwwn7axR61sqPPo052SV60yFdE2WM19ydU0lwc5v4gNRh
         CRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791475320; x=1792080120;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zKZrGNVIyZXHBRCxfwfOKfxmv9vpaw+fFtJmZfucaZk=;
        b=0V9lkZy99GDXiNjMN89K7xGlItfDhOYm9wWKhhEgvYmxjFcDEqy3jv9oLiFNK/0igG
         uE//WcSwh6kKzrARS7sil0MbEsrxvU/fZt9kfg02SF091VBm64IssZqWljkFY4dIPzUZ
         5GawYtBzDeWpDDzsDnQQo5ZDkpJlxH5MbiXbn8Gx/LYIeGgxJx1knSUeOyK6sZwydg0i
         KGsrXyVdmruSgWjmhogpH8IPvG7QvhZuPcr3Wf+bCMc0BwRuIbkyBlSYaNKQQCPbPmpc
         2qu8hag7ZsBQkPtq5kpcCk8WyxzOZlBHOYA3C65Oyd5hSzOkdFbKFOjEAy/RqaIeQDKs
         wTDw==
X-Forwarded-Encrypted: i=1; AKwUvBx/J05bN2wqiWi1jHCtKKSidFWC//9RNtn6n/i76CCxgEXuOPV+SToDTO6X1bTTk7f2b4HT+WWaYm5UjW7O8oA=@vger.kernel.org
X-Gm-Message-State: AFuF++m4RFH+wkRdR6eKK5+pgxkkllOVXCMu6JkeUTXkupdzR98qhDcI
	Vp0bOPMnDU2cyeEFK8/va82dW21D3XxrAhyMuTmt69DYLHiQLyZpiVNqQ84jXPe8R3K93+uhdCb
	InxCrP/dqtkWORdyM3OfFbY71o3ahjMk=
X-Gm-Gg: AYBFou2dAEprgiwlKI3/5ikfXaLULmF65q9AS/ebC2zfM+Z9LXjK/7Js59YTU4RJZFj
	8oONG1bYoZSrKnHnn0k1+1d4Y3L5H7O2nwEfjlXqRYJpqAVM4dIldElZ2sjhoNwmtHPwdd91/wX
	5sAr2KJps+0SgFnMen73BqcvKlOf6smSq95LmhVoIlEfHn2UX/zJModZaBIo/vhQvEDIHTyQlAH
	sh8q/4fJHK+orWbU2TRuE1g1Jp/MklTVkVIggrJF+mdbLMSWXy3vP5C7kEnKZijq/4CVJ5jaPrn
	u3bmzYbLWIff+ft1OobiEs/E4PkrtIBH0rDhFAMzb/86xyVeSNbl1ITrtg==
X-Received: by 2002:a05:690e:1c0a:b0:677:f14f:33f2 with SMTP id
 956f58d0204a3-6790a4d9cdfmr2932381d50.126.1791475319873; Thu, 08 Oct 2026
 09:01:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789660425.git.petalzu987@gmail.com> <aq0UpHHbvxjR2jLb@strlen.de>
 <aq1HaYS96SNn7HJY@strlen.de>
In-Reply-To: <aq1HaYS96SNn7HJY@strlen.de>
From: Zixuan Chai <petalzu987@gmail.com>
Date: Fri, 9 Oct 2026 00:01:47 +0800
X-Gm-Features: AclHuK8-Il12ejrwcstANC4jvFXQSbJsfw_17QYwSou1NMz09fzwAMpGdKRV0Wg
Message-ID: <CADTzadLvrvqbnUipgw4YG+ssa78vm5aUpDSoFZCnwQoOoeMYog@mail.gmail.com>
Subject: Re: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum offset
To: Florian Westphal <fw@strlen.de>
Cc: Ren Wei <weir@nebusec.ai>, netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	phil@nwl.cc, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net, vega@nebusec.ai
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Sept 2026 at 22:15, Florian Westphal <fw@strlen.de> wrote:
>
> Florian Westphal <fw@strlen.de> wrote:
> > > We will provide detailed information about the bug in this email,
> > > along with a PoC to trigger it.
> >
> > patch is fine, but could you make another patch that either fixes
> > ipv6_find_hdr() or ip6_packet_match() / nft_set_pktinfo_ipv6() as well?
>
> To clarify, I agree with this patch, I don't mean that the other
> patch should replace this one. I see them as separate issues, so:

When you have a moment, could you please let me know if any further
changes would be helpful for this patch? I would be happy to send a
revised version if needed.

>
> Acked-by: Florian Westphal <fw@strlen.de>
>
> > If I read this right then ipv6_find_hdr() returns nexthdr 'TCP',
> > but its clear packet is malformed and that header isn't there.
>
> ipv6_skip_exthdr() may have the same issue.

I have also been looking into the ipv6_skip_exthdr() issue you
mentioned. I think it needs further evaluation, but so far I have
not been able to construct a PoC similar to the one for the
checksum issue.

One attempt is this series:
https://lore.kernel.org/all/cover.1790082243.git.petalzu987@gmail.com/

I am not sure whether this issue warrants a fix, so I would
appreciate your thoughts on whether it is worth pursuing.

Thanks,
Zixuan
