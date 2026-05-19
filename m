Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C43C367B81
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779219496; cv=none; b=ch2AcTBfPafpVrugIS82F8vD4BOxOVfCKc59YJSXhT0VlfKHEQ68S1FxLfyq5bv1mIC9IPeActrD8jh2GvuSydUDviNMooUF4ZFSd3GiyMElYZ8eTn8bk7JtqeEV9TTxFGPrD8U/6YYKHQyFDVticSXA/wHnmuKz7A0F9LVPtu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779219496; c=relaxed/simple;
	bh=8vDURQvobHAVFN9s/LzQ7RFMeHEUZ40/G2jwXhUARF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sCD3/0kIagtNXx9J2zyk8Np3HaS1dgruc4HRgqZY5RGc1+GuwaxtKk1ZgzLbRjn85BusfUPE2S+R9TwSFNB43qbnO9Nven8fD5Q35w7FKiqNRM2w9rwl+QrIXXnfXW7MCb1OJ8Rbkura17OPb3ruhmUOErUTfycqTy7iZQ0LC7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BEF29607BD; Tue, 19 May 2026 21:38:12 +0200 (CEST)
Date: Tue, 19 May 2026 21:38:12 +0200
From: Florian Westphal <fw@strlen.de>
To: =?iso-8859-1?Q?=C0lex_Fern=E1ndez?= <tomaquet18@protonmail.com>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v4] netfilter: conntrack: fix integer overflow in
 expectation timeout
Message-ID: <agy8JBZYvx54GYfL@strlen.de>
References: <20260504112300.715192-1-tomaquet18@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260504112300.715192-1-tomaquet18@protonmail.com>

Àlex Fernández <tomaquet18@protonmail.com> wrote:
>  		x->timeout.expires = jiffies +
> -			ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;
> +			(u64)ntohl(nla_get_be32(cda[CTA_EXPECT_TIMEOUT])) * HZ;

https://sashiko.dev/#/patchset/20260504112300.715192-1-tomaquet18%40protonmail.com

Does this fully resolve the overflow on 32-bit architectures?
The expires field in struct timer_list is an unsigned long, which is 32 bits
wide on 32-bit systems. Assigning the 64-bit multiplication result directly
to expires will silently truncate it back to 32 bits, causing the same
wraparound this patch intends to fix.
Additionally, does providing a timeout delta larger than INT_MAX break the
kernel's signed timer comparisons?
If the delta exceeds INT_MAX, macros like time_after() will evaluate the
timer as being in the past, causing it to expire immediately.
Should the computed timeout delta be explicitly clamped to a safe maximum
(such as INT_MAX or MAX_JIFFY_OFFSET), similar to the logic used for
standard conntrack timeouts?
