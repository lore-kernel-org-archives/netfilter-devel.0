Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F8D2C0F90
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 11:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769513026; cv=pass; b=THnxQcMkyMf16sYMZHbiWNSmOpUCmeCZW0TeuheJL5WvghHq52kqRcOIUSich3xUDQL7fWovqeGrydWBNGQZpn2dlrhgBeUMs0dhOjy/ho2DHxQbQPwUmiGRfDE6pwWTdd5dCZ6Q/8ZchTnpOXn2rhS90ijwcfa44eHpEG09Y8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769513026; c=relaxed/simple;
	bh=HrWfwvYHG+lp8lBanydsMN+slzlGPV0oN36crkRHcLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtusM7pQWJtyjWuFFL+pEyLlFkeYnz9LLFhbQ7Y2cPiKUlD5wvELX9ze8rr606g031IvBPKb/RFMxxyAzwF+2dwDm4/6A1yk2PNcAmFHQN3WBAffx2RXW/Nc8OZB3SXX0mibCTY8xSRX1r4jSovScpaZs3UYifcDhfJb0V3SHfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T+6BPDzM; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T+6BPDzM"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59de6abf324so3628409e87.3
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 03:23:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769513023; cv=none;
        d=google.com; s=arc-20240605;
        b=kYCUOoLtv922aDHclidwGoK198jocRun86/+2xVCQzf0sewMz5De6JcdvtbEINemnh
         HmUYPHwRCIxrzprWIe6bweWy7h8d8TLiVuEJ0fo5L8Ani+Vh06N/8aipzV8SaGoHX/Vm
         mWxMTmskdQ//kG4I6SJqNgWAxfl9KwcPromuyh2vRtEGAtvHTJfV6foHelolLwHY8Zhn
         LqUbGCjWUse7SOfi2poB/WMhkN0YAy5OJHohiaYndptHYVJpS6N5f+9rMb/YdBmbUxlk
         tEaqVWuazdi5u0Tomc3XgQr3tJv8OyqclsPB3d8D9nwCMtJMkBGYwzikNuqLl45orI06
         cNjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HrWfwvYHG+lp8lBanydsMN+slzlGPV0oN36crkRHcLQ=;
        fh=0eJpv5TZ+/Nd/LRAN89wxeEbVjWATmWosqU4eTwS+NA=;
        b=YFtL886BNiqILVahmwoMluhlueYXuOhYGRV40084v4UIhrxvSFlkDmDojLnPAU8HhT
         vu6v8K+9dsoye3b8f7d3TGsZrvhLVKuP7ftiPiO3mkbqEkvZVrrxsQEbCsy87dvY2Bwk
         9cR2HMTIadSZTMrzf8xEMJRVfSZo3Zy4Duy8MIjpgcBJ0AG3eYED0IddytFHujFhPGGB
         VMxqJRVWbaw+3fZiUr1BHetDOpuYJRNVyRt0hlawmUsmqwgcHFjmvwtn5VG6hq6VB0L4
         ks578wAvC4nRUxJU4vBXHrLPIGmO80GtW0+RLM+lwHXnr3+64t30cW2nq5rNVm1yWzdP
         v+MQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769513023; x=1770117823; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HrWfwvYHG+lp8lBanydsMN+slzlGPV0oN36crkRHcLQ=;
        b=T+6BPDzMAIXgcwSHD5LfziPrNhCsdVNvTeYriKGBzhhqdQVHTiIQAjTSgG4jGdXLRn
         j0Pt+aaUrAdEXWZot1cuP1LI8KalVClIKNSqt3Sm+lXzr2k4FRvoxI61N6rV3zU+y+uW
         wmseFlY/PGvxc7EZcY+L90Ahrps6r5429nurDTJdcyevONvLd1QKhXERu/Fj2+20Ec1J
         9bce2xMSMIgTYyM8z8842f1TScS4+Cx/q3PMjZ8aIF6V2xwf7saWZxqeWOSLW/EZE38w
         Nuc6NPEDbFKuV9ZiCwM3skyGm6pKpPimtKNZKfNR9I1DpYIk9Uu2RV5RrdvCN54XTPE5
         yvqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769513023; x=1770117823;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HrWfwvYHG+lp8lBanydsMN+slzlGPV0oN36crkRHcLQ=;
        b=TWNK99IRd/eQW9m0mA28j5JJXroSZZZid3BbHv3QS2B4/LDzAeqFMpTuW0iU3c6Ry5
         ktjCVtp4ib7Cv5vUDCWBIHb3Atp54OxiX/sBhy6J26KAU6xHbVUPBsLeGNQQvZlyXbJh
         4Mx8HzIGyk68kouNCWojpe4IppSP/xSUuikK1/UNn5imGgaQKOhK8fcqUyFsi5jcsK6J
         JNQU2WH40EqxEMA3iaTtGFzsW5n3Un0bHjc2pcQsnGdKcn6lvDHrB6AFzTY/1ZQrt0P+
         /68zBsqYmSiG4J0bgD7FRmf2/5so8qPa7yLNnHgKPWDw5mpPoy1YSDGX49LTVO25Hq2L
         HDig==
X-Forwarded-Encrypted: i=1; AJvYcCVLCq/sKEUlLkFwhpV1ktIjoExmbfUJLLN/+fuA1aX1LsowGN2veLh9CnazB9f46N3GeUxEax3JWjE394BeE1o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUKrs9supXCXW3SkbFNwNVVXmz/A9FjKcgXfh3VPLkY3+dL+Qa
	sbrrT8/UjtJracTBEl1wTRJslbUMUeYMLsPQ5dsI97xqlgj16dKjsDj6+epOxQqfrNW+bIfhnx9
	pMhdk9B9wIUegYiN9cwn30lKaFH9C7RU=
X-Gm-Gg: AZuq6aI2dhyvpqFP8egH+S7PqDs9anhCNWtTQXjSJYlLopELfUYzwNifvOX5BsCpvl9
	8DIGt9gMNc/pvw+K7ILwCzCOgNCfyB8lLDwelKP1mj1xcc85moiPaKkRGDf1sJ0egEHaAaro6Kf
	lBzGFcucWlnm1z9F/BnpHwNM2y5yY2xpmLfre9dw10QoJ4iMcdedKIYFJzZWWDXh2anLGL2UdO/
	8u1039cU2HYLN5KK+IaNio7IZhc+mNPOM4azsA4lwJ1BH0WhidYWlSWegUcrFuBZ5ucTHmbucOH
	oWfVFRBnXMpJTV4rLlmBHFBkWw==
X-Received: by 2002:a05:6512:23a4:b0:59d:f3c4:489a with SMTP id
 2adb3069b0e04-59e040153b8mr580196e87.6.1769513023391; Tue, 27 Jan 2026
 03:23:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-4-one-d-wide@protonmail.com>
In-Reply-To: <20260121184621.198537-4-one-d-wide@protonmail.com>
From: Donald Hunter <donald.hunter@gmail.com>
Date: Tue, 27 Jan 2026 11:23:32 +0000
X-Gm-Features: AZwV_Qj6aiETfCOD944jEASzrWR6auE_ZCpfK6dMNt_z6sx3Hpco322dSmLyqOQ
Message-ID: <CAD4GDZyMtxz4EjRMqAiP2wR+csLEY61gDhBO=3HUWt=rOgZTTg@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] doc/netlink: nftables: Update attribute sets
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Jan 2026 at 18:47, Remy D. Farley <one-d-wide@protonmail.com> wrote:
>
> New attribute sets:
> - log-attrs
> - numgen-attrs
> - range-attrs
> - compat-target-attrs
> - compat-match-attrs
> - compat-attrs
>
> Added missing attributes:
> - table-attrs (pad, owner)
> - set-attrs (type, count)
>
> Added missing checks:
> - range-attrs
> - expr-bitwise-attrs
> - compat-target-attrs
> - compat-match-attrs
> - compat-attrs
>
> Annotated doc comment or associated enum:
> - batch-attrs
> - verdict-attrs
> - expr-payload-attrs
>
> Fixed byte order:
> - nft-counter-attrs
> - expr-counter-attrs
> - rule-compat-attrs
>
> Signed-off-by: Remy D. Farley <one-d-wide@protonmail.com>

Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
