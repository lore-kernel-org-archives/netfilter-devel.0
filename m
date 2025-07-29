Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5062F1F4295
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 01:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753753987; cv=none; b=aYwA1rjlE4YNXJTE/zHCxLO4fPUYMe6SqOlFsZA/6EKbmG/tDvJOUJpeTGG0UCK39eXNyxQPEReDywpVQu8KQyz2JPDC8RanEtYpRKF+hjdV+P8LjjF82UqSq7czdV7eJ1481VEzsFFWICXey+wfvMl1XvF/3FPUkDmRl/H5DKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753753987; c=relaxed/simple;
	bh=eEG2yQKCk8onBaDcUYBI0yJrK4CURhRcu62xhiyR7JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhXfEeoHgzWQQvfAHepE/Sc3389bFuw9xf5b9mM2sTlT2RjANd0rcgEvInjOtL1djm3zqJUltlvCvPpeTHyKbqC1k8skuM7aj7D31PiIvYWYhFn+Dxbi3o6zdc13f0iMGINTT8vv97GiSIunahguEyFnvlcQ1Dyv95pzNxMGTr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P17xdHVD; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P17xdHVD"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6facf4d8e9eso33017876d6.1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Jul 2025 18:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753753985; x=1754358785; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bu280kVLguETsU+AUFgmzzF1kgZoWHPKcGHdvd6cUdM=;
        b=P17xdHVDXLxSxdf9cEuObhqdC23CsjwWv6c87WxAHN7Y72onGupkrea6ipiGCXiPpP
         zZ5jwQyvIZDzosqRIM+bgYur+8Igh9zDB2x+OUuGIpsppgH076NAByPCDQ1Z2gwnaDxt
         XLQZjfEOFDEnThVOhQjWhvQbOT/xiiUczfE2E35nanES1Qphkr5TbUvw4AmGtJllq1MF
         nVd0vst0bqRPEq8uEihE3nwHWywq8RORoH9MB3Z9Ky7sUe/kgktnCwvFdul8AMhfdEJn
         cjpdHyJl+PzB1ZQ1beMhE1rDbuwyfEHkCuqC10oeI68jcPCqz7aPyKm9y+lhQZecLjgg
         NvKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753753985; x=1754358785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu280kVLguETsU+AUFgmzzF1kgZoWHPKcGHdvd6cUdM=;
        b=jGBa1qrl5iYBmMfHjuIi96a4rIqgZcLwaI4ZFea3nY2PKfIw5v+U2A5bNYucp2mX+6
         4uAp9ECd8e6l1BcVw60tlLOduRuNc1b7rOHeCYpiIofndu4Va2D+eAqELtsqwfKoeelc
         /OPhZVLGM0jPWgYQfwrm6fe/FpzjIB6vpuBiSTUcNs2E8EqrJCPCZc52Ypi2xs8cDdSH
         VTZmerYMmOMOwivpPVdDBwo53+II5VcmvkUKMyfQIbHPzy/W6JlWipPLmBliQol8rb9f
         t+yHkfKm0AD3sXxspUXyoSDD+gdcrSdeI/1dBbt+DSQB7tOQDtcPci65NZfmuqP8Aojf
         m2HQ==
X-Gm-Message-State: AOJu0Yxkebet60iznk5Q+Ufhrilpy2yqk0kdy1VtrsKDzl50gvbPfLYJ
	AmyXSWLdvcnja8BW0lWf+UlTaorTY757Jk+W/YpC44jBTYO4PawvsR4g
X-Gm-Gg: ASbGnct34l0158xJ92oxGrBk1FTzwaKTFnYeW/P4ejtWUGEsMXrVYnM4rxNZbQHVthk
	MQuqcI9LO8wgRYtuOCZCJGFaQx6WRe/YcD99NWLaxncCngZeYBzpvx06V5mQWcg5Q7lANW0Cs6I
	cGys9H938dRhLS+kejnYOxIgeEdhyBMHA+th8XupSyxeTfQ3avE1pIhgRjNOdObDiPDVUMJkAhL
	s0+skEnhVLlWyZscbN9Ke/EFAo7e9xRxv4BVhceWUWEe9JSY4OEPzw8Ren8x0QgHg8QLbQKQlF/
	Q8abLjq6jyN2S2RNmgf9CvK8WY+ibU+VT0XNvPGpXC1sLGpnoHSb6IkrAoVqdyrXVVCeww53DFq
	0KNP6iVxNrWQsDhoPQgAuwvpYvxhV+Jc3KA3CYPZER3BvdIlNKPG2YUuaX+NBBums4w==
X-Google-Smtp-Source: AGHT+IFbr7dIBjDiiMM6OdBsY0H2nFJP6nTOmZZbS/ZoReYOTDISUJTQ/bs+tfDmJmEwhU6YkPBq0g==
X-Received: by 2002:a05:6214:2425:b0:707:590c:9651 with SMTP id 6a1803df08f44-707590c9f1bmr18747286d6.47.1753753985077;
        Mon, 28 Jul 2025 18:53:05 -0700 (PDT)
Received: from fedora (syn-075-188-033-214.res.spectrum.com. [75.188.33.214])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729c15a84sm37269076d6.48.2025.07.28.18.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 18:53:04 -0700 (PDT)
Date: Mon, 28 Jul 2025 21:53:03 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, ppwaskie@kernel.org, fw@strlen.de
Subject: Re: [PATCH v6 2/2] Add test for nft_max_table_jumps_netns sysctl
Message-ID: <aIgpf2bkG34lw0V6@fedora>
References: <20250728040315.1014454-1-brady.1345@gmail.com>
 <20250728040315.1014454-2-brady.1345@gmail.com>
 <aIgMMnl-2WMQlFH-@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIgMMnl-2WMQlFH-@calendula>

On Tue, Jul 29, 2025 at 01:48:02AM +0200, Pablo Neira Ayuso wrote:
> Would you rework this to a more elaborated torture test that exercises
> both commit and abort path?
> 
> It would be great to have something similar to
> nftables/tests/shell/testcases/transactions/30s-stress
> but to exercise loop detection.

I can, but I would see it as an additional stress test, where as the
existing test are more unit like, and test the sysctl for discrete
behavior.

Regarding the commit/abort paths, I ended up (in my testing, not the
final code) temporarily changing:

                if (status & NFNL_BATCH_FAILURE)
                        abort_action = NFNL_ABORT_NONE;
                else
                        abort_action = NFNL_ABORT_VALIDATE;


to


                if (status & NFNL_BATCH_FAILURE)
                        abort_action = NFNL_ABORT_VALIDATE;
                else
                        abort_action = NFNL_ABORT_VALIDATE;


to run over the validate path during an abort (as above, a batch failure
won't do it).  Would the else path be caused by an abort message from
the client, as in a Ctrl+C?  Is there a prescribed way to inject this
kind of fault as to naturally run over the path?

Further, are you wanting to test/stress the ability of transactions
(both committing and aborting) to intermingle/coexist/coordinate (at a
glance I don't see tests for that in the kernel tree), or specifically
the validation code in those paths?

Assuming it's just the validation code, roughly, would the following be
what you're thinking:

create N random nft input files, one part being valid commits, the
other with aborts injected.
Set the jump sysctl limit
Loop over the randon input files
	if valid
		we can or can not add jumps as expected by the limit (and included jumps)
	else (abort)
		we should be able not not add jumps as per the LAST file (we rolled back successfully)

Want to make sure I'm not imagining the wrong thing.


Thanks!



SB
