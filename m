Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B23E3D3CFB
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 09:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774604866; cv=none; b=JKQNwRRJh09B850eexZrIMkZhKvztlI1VBWIW69HP637YgoheVIIi/wTIWcclzCDOU+95NnIiRTzKBIBhiWdyfyyAsblxGUNYqTvaOfSdYWjtFQY+0JjB+UEzA/Lqkg6ERXLMKWQz4OTstS83b8TmM6PeoQhWZl9UTodK2POSXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774604866; c=relaxed/simple;
	bh=E6E2z4FS73XjsMfcdTdAK6V4UK7Fr/CAf1sLTo8wqPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y8thl6j1kA1z9W7xhZOgh8eM7+Piu2cHbBuU2kTwFfde5JuHOdI+emZx9W2FR294SernH0QrFsAu9Iy2p3EgRisWCiBlymHJCWyFwjxSv10XOHMJ2tNQEn+bQL/JKj+c2aXPMdTrAOs7R6pSFOayieZeh/hoBA8WIDbZSVlY7TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U5TUWOg5; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U5TUWOg5"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48700b1ba53so17994685e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 02:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774604864; x=1775209664; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2mdluSqt1yk4k5MVkcX8zZG5tNI3T4/zHh0y72VEmZo=;
        b=U5TUWOg5d8cHyanp+3uJebuL3p9oGXAOSXqYe7auYwtoKOHflKfmNuHk6dZKkyBSCZ
         au7VrkXiaf3Jg6f8HpbLNcO68Ya644FUo7tr3pceOnEQnkKNu/9LK/dDocMGBAMYpQX9
         COBBc82QROH2Gqva3TyFlCRAbCth1c8qn40jpJp2lQy4qXZXnaqAO8mBnzpChHdr7OyZ
         s/D3MJ8F0TakSgjZdfJqafE+F/kJVHBVPetytwSWpajACLrU8bqIdOV/saoBBNG6JCXv
         pjRjSsV+Tdoc6RhcSRJPPJvXPsPV2qnqDNtctU2X2NpK3hLYyKewq8dtghsgWj/09TDB
         2mgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774604864; x=1775209664;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2mdluSqt1yk4k5MVkcX8zZG5tNI3T4/zHh0y72VEmZo=;
        b=duN/U9hyDs5dgGqHKSko8njUZ/CA6MOp32Qede20Xh4v2xZZ4iNdMcH1KrK9w3ksYQ
         zQZWxTKe9sqamxcxOxnovuYM0LTgrM60VTuyxA8m7D7wqjN8bHi+8+uj/3jRUgGP99W7
         4kkgNqgQ2JS8GSMSCJRJs0cX3r1QoY4Qjn6SucQEYTfeguW2rqeEhdsu2JUDSwpOyWjj
         3bJoXwxJVHxMK9AMZmkmqdMNsAzCcm0xVqyRfQjoEiVMKFU2AJe2shNXXyjL1CsDx3ag
         Je5COR6uzkuZTcTETF8+FgrfxIe+4Mmus7VHg1syW8JxNPAdGalH42vjpq5NutxYsxgq
         jnhw==
X-Forwarded-Encrypted: i=1; AJvYcCXobwT0ssS5g8tJX8U3Wbzr0HZSDjVn9NYCCKoNxcVYqCNQ/PSVr28YtBwpeltqNIOBTPj39fbttTudCIIAPJY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWUVB+Sj1SS51KVcrSsp5R65A/mpCzuF60oB/IfWQHi6VfGbms
	pD2R+y9E0CWdeZ2hKGhJrMylJ3kZbHdKYYLsjESpd9oBeMgvcOS8oMjX4vEJw0nGKKg=
X-Gm-Gg: ATEYQzwDlTPASJekD1xajRg5y+6lPmM7+++VLn6I6EHkyh0WI5UkKz/VeUkmekV803t
	ouQufPGw+hz0GktqBVICW3abL4HOzpWDxL4IPR/tTaQk/A2jDoCoTUGOdXD9/2qg6x20aUHEu5O
	eWW4MkW+4uVLO/AV38rsaGW5cqBbOAvbgsHxZuzOOsywGZixOlDMKI+QV9im191g6zz3hcosQue
	Yz+i0EnVwbUYxdov4O7YncqiDdTfLHn0Eer70qJ/afsrZ9sJ1z1LLQVVq8HReneR3vZBd1eUWHJ
	aIT4WU8L7Tk03pYpQgY8V8aWUhjOqok6AtxyMODqd1kAQgw28XiQj4ZW3cYQWNp8ytVGBnlmvnI
	zLUTfrREM6YrPDzYFNZlNXQcZiNMnOhMd/tJNUt6NuDtodaeH6ZgxOHcEwjg7zXD/RPCbxQeMNp
	cUmr54jaC/X30PSbHTW59pHmZAOQ==
X-Received: by 2002:a05:600c:8489:b0:485:39b2:a47c with SMTP id 5b1f17b1804b1-4872809fdb3mr29506825e9.25.1774604863667;
        Fri, 27 Mar 2026 02:47:43 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c9f58fsm133350695e9.11.2026.03.27.02.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 02:47:43 -0700 (PDT)
Date: Fri, 27 Mar 2026 10:47:41 +0100
From: Petr Mladek <pmladek@suse.com>
To: david.laight.linux@gmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation
 when H323_TRACE defined
Message-ID: <acZSPeowuYC7ivgA@pathway.suse.cz>
References: <20260326201819.3900-1-david.laight.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326201819.3900-1-david.laight.linux@gmail.com>

On Thu 2026-03-26 20:18:19, david.laight.linux@gmail.com wrote:
> From: David Laight <david.laight.linux@gmail.com>
> 
> The trace lines are indented using PRINT("%*.s", xx, " ").
> Userspace will treat this as "%*.0s" and will output no characters
> when 'xx' is zero, the kernel treats it as "%*s" and will output
> a single ' ' - which is probably what is intended.
> 
> Change all the formats to "%*s" removing the default precision.
> This gives a single space indent when level is zero.
> 
> Signed-off-by: David Laight <david.laight.linux@gmail.com>
> ---
>  net/netfilter/nf_conntrack_h323_asn1.c | 38 +++++++++++++-------------
>  1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
> index 7b1497ed97d2..287402428975 100644
> --- a/net/netfilter/nf_conntrack_h323_asn1.c
> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
> @@ -276,7 +276,7 @@ static unsigned int get_uint(struct bitstr *bs, int b)
>  static int decode_nul(struct bitstr *bs, const struct field_t *f,
>                        char *base, int level)
>  {
> -	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
> +	PRINT("%*s%s\n", level * TAB_SIZE, " ", f->name);
>  
>  	return H323_ERROR_NONE;
>  }

The change is important for making the kernel %*.s handling POSIX
compliant. The dot '.' without any following number is handled
a zero precision by POSIX. It would print no space "" when
also the field width was zero, aka when level == 0.

It has no efect if the field width (@level) is always > 0 because
vsprintf() would add the required emptry spaces ' ' anyway.

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

