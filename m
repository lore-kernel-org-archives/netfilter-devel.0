Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F782199B0
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 22:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712961725; cv=none; b=uY7SRrpx5+NOJgYHQFH3Ymdd4FFiQ3Nt4Joo/X1WmlocR8gNZNJ/6HLM1kqAxJ6+eiFSjsNB4XFLU16VaWFJQZciy8/O8l7nxn/hlC13mABLl8FIikJfjPs+GOxyjFSBbjHv/xEnQXxQ5uqPSRZCB9h4JTB5HoEiusFbfakqP54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712961725; c=relaxed/simple;
	bh=+3AT1IZ7Ojor5yHHPPhRfDwpTP+H8tbX7eJujFWkgi8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0UI3hOZZziCbadzuLlQyr//gcfoNGEVkyESXW5kf+93bO9lgBKR8LOvZlLQJkjkMy1M+e0BKMSOtJu0gNCC7IV+7mAdg0SgmWzX0aTBcr7J2874NKL7si7laZGlPIBVnlIZwh7Zen4QaGZB0IAtIMcT0SPywipSEkminQdCoRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aruXH1bx; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aruXH1bx"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2a4df5d83c7so866215a91.0
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2024 15:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712961722; x=1713566522; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+3AT1IZ7Ojor5yHHPPhRfDwpTP+H8tbX7eJujFWkgi8=;
        b=aruXH1bxulJabbEgBYR/YSdIv2nARkl0jE0CCOENOY1itdy04P55i+G/TqRVklXAAz
         C5zv/KMw+T66tdo9mwsUJVoITsDOBC3EwX+0NJACu/a5FQg8yqf9Ef1TnrTev17rpZSN
         QKz3WIX8TGfRxhaw45+n17mUzapOS84hpYdQeE20U9aloA9ONvm30I67id7Ek1fzkWWP
         tbi2MKiNC/VEz7REYtxtN8fWmOhhgZNQqfyFoJXtH4AdkReWIBxLEBv4KTZTPsl4R72R
         6ihPe3G39ardOXZnKgELfF/1jWNZaTFIzLPdKNc6JEuNW9kUnwi3Qsxg4ICLio4c/41o
         CCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712961722; x=1713566522;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+3AT1IZ7Ojor5yHHPPhRfDwpTP+H8tbX7eJujFWkgi8=;
        b=cvl1/mhIDqm4uxOEWTxbH863RnXq7f2KuIOA71NfYOnVU4maZUDYRdE8t4exEBVPGc
         Ge/IFuqIPIwl7eTfmdTjec/csZtubdm41jpf0TTHP984SdqQW+TBBjliTYv4GhRsCKxq
         C04sgKf61begwalHB3XE49Jj5gga4h/gAAFqMBKh+9w9zl4LaD8iBu7LWhKzzlQIhX7N
         PQ99i4mtelpBN2oY5LA2mLuftms4iYxfrxnToecvqDoaq79gI8LN7AWDqO/ns8nxFu6M
         RR5X3/3bovAsF+yYF0czKTJCQRq9A49RZPiSLIoq3Kc77x3i+XB0qj6eOnx5XhkFXUui
         5AmQ==
X-Gm-Message-State: AOJu0YwKuiWZUbtKHu7WqLFiQjgxVyBrM5n5DKPApsvdpp18+stn05zT
	pUGkMJSvctAczFLzFU+3DQvSxDue+jyfVUqrK8whnEYdKGK8O2rGYVAOFA==
X-Google-Smtp-Source: AGHT+IG5qVgr3HG2q8S1ZU8S57iJP8rGPgVzO9/9qVK2K29K2YDCemlUyIirbw7n9SDzoeBjiRe8ag==
X-Received: by 2002:a17:90a:89:b0:2a2:39ac:abf1 with SMTP id a9-20020a17090a008900b002a239acabf1mr3675212pja.49.1712961722595;
        Fri, 12 Apr 2024 15:42:02 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id n16-20020a17090aab9000b002a46c730a5csm3203915pjq.39.2024.04.12.15.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Apr 2024 15:42:02 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 13 Apr 2024 08:41:58 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: (re-send): Convert libnetfilter_queue to not need libnfnetlink]
Message-ID: <Zhm4tuJA6NQsh//4@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZgXhoUdAqAHvXUj7@slk15.local.net>
 <Zgc6U4dPcoBeiFJy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zgc6U4dPcoBeiFJy@calendula>

Hi Pablo,

On Fri, Mar 29, 2024 at 11:01:56PM +0100, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
[SNIP]
>
> ... Then, document how to migrate from
> the old API to the new API, such documentation would be good to
> include a list of items with things that have changed between old and
> new APIs.

Waste of time I think. People are not going to migrate - what's in it for them?

*We* have to do the migration, because *we* then get to ditch libnfnetlink.

Over the years you have mentioned a desire to do that. Now it's done.
>
> Would you consider feasible to follow up in this direction? If so,
> probably you can make new API proposal that can be discussed.

Actually yes. It would make things easier for new users of libnetfilter_queue.
Will detail in another email.
>
> I hope this does not feel discouraging to you, I think all this work
> that you have done will be useful in this new approach and likely you
> can recover ideas from this patchset.
>
> Thanks for your patience.
>
Cheers ... Duncan.

PS Sorry if you got this twice - D
