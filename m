Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE76726F2B0
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Apr 2026 18:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775586939; cv=none; b=ZejqVyiidIULoajTdtd05nLE6pLQcJuLWt+v5DiLLl76YeyLB27V/i6/Px/gTqVXxWk+r+S78fA2Eug1929DZ9vvWkeau9haa1ZvXRzHiUse3WtDSha5OuQh+Fqn0b48fM3SFP3rU47n3CfFL2bmKP45sOoh2oX9jpempRhWoCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775586939; c=relaxed/simple;
	bh=RcSfW7BVL553lKbTf3prH24yb+XiZUw0mmz0Q+5e4Os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbM83tfaSjbTqvibn7dqmorV90mCL7EKCa6w2uuj6heI4Nm3t0b1K8oOpY7LiFve1NQfRUuaCDTrW4r/uKu+ZhBHCvsZqAeC1dDsm1OkCBgdHJ54R6eS9QOk30K8sfNv74Gtt/eqt7vJSJyBOa6yoGy/Ei3f2hiZ3yyWbSWv5cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wbinvd.org; spf=pass smtp.mailfrom=wbinvd.org; dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b=SumApEDL; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wbinvd.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wbinvd.org header.i=@wbinvd.org header.b="SumApEDL"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2c156c4a9efso7019401eec.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Apr 2026 11:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wbinvd.org; s=wbinvd; t=1775586937; x=1776191737; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eessS45c4d7a04OGsZRQetM2uu75g94y42hxsune8NQ=;
        b=SumApEDLqjM5oO+lZBfylVEo/xrFEJRxBukM94PfdKAw3xlu4lsPjIkko7r5vHQ2gq
         dovPz98PvB+1bC6E9oHpc9l6H1GcHxqmk8/QrZv6jf6QUPEV1qHRjd7yRNqCY+9vTifY
         m79Zleht9Sk2r5nAZLXxzyGtlqs7ENmw6PCVHYO5uQQSBH4iA+SsEfGaPlGN/urIXwv9
         U5A8bPU3oC13bX8ILhr8Rkk2+/FXYIVEtQU96FSr2tBLB5T3TO12pOxLdR0OLqvVyMeR
         DBkF+JNvrapyfUyPToSBdI2VyPlHq3YdQ+rhH3DGy+S2BSvPVwxyIPEyMzDCUu0Q0jDd
         6tOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775586937; x=1776191737;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eessS45c4d7a04OGsZRQetM2uu75g94y42hxsune8NQ=;
        b=Ia/Q4Pu9dw2yLUDzTa8R5vsYqta49dy1LZMO83gxWSc7cSBe6EWfOcbszrVsekm5gx
         6HX83R/BnX0pmEMF9w3coa3OwdxcZWQXRIaU0EUM1RdqlNuZtWQyjyP7jcMQyJvOlNj9
         8Xp5k/kFRf5zKk5ENPTnYsTKZohZc75iEV7AaWmApo7RUAKYRn9xc03Q1D2Y7wrf2a1U
         JLGaVI1vCvaEdrRl1togSnMsrlQJlTicCReaBJ7I1SqVzBDKLaHdqaXa3eSEXl400xeT
         1gg/82QWvYNIhjiNyBCQTZ9ytk9lilPjcM0q8YojzuimziEroWU9EaS04tq7aYhKTEzS
         tN5w==
X-Forwarded-Encrypted: i=1; AJvYcCWLE5kC2Z2GfdyETtCaL3Mq/tKKtIeiADzAKGG0P6NkHH5jZvm3ObChlpOnpoCD4r4aOyezrNKFj4MIjeopuCc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxdAkn5Og7qyxzkHOhElHwIT1zMvKvN0ZGQ14ISIMxRHO2XK5X
	BUQQ82IWGSHM0JIUoIJn2Cq0WOz9TvajzcubrnkChCEE7ZKyzGLKLuJACAUT0EJOqCs=
X-Gm-Gg: AeBDievQ6AnPoCiLvjfGYohUjeOKkIRFznYSMED992ZqT4ngwUZdlXhih9TRY8vURQp
	zOrEq5at3NMHkNVGh2MLfmY9E9I2NGYr2heCucHPOfWoXWaSkkM6DpQnXa0E6cJhVjLM+eV8oxY
	TAf9LkIVX/UWkeDWpayI+7e5RIP+EV69jbOk4gR2JzV84KLN6q7PV+MpqKZun1bXfJaZbv1vMVI
	+Kp76AXdv2GtpWtbfITs70krsD1A297lB8h01rmxtGPYKrsKo2vy5Ah2e0qEDqUPcZn+dDa7F5H
	1qYesUwpaeqrxn68FrIQIfH77e/k4qDTxFlsrcdo5+fvBE91XjUTC4Zxh3vPboRJohryjE2aky+
	h8buPh/bPyH0E6m95oSGfVda5qWC3lI/X543OZBknQOPAb7m6CSsFn7z2PLIeZEGDGZxGitBAGK
	AVBj1J3N57H0pwZ3MsIVhaRPJ9Wg==
X-Received: by 2002:a05:7300:bc97:b0:2c3:b172:83c2 with SMTP id 5a478bee46e88-2cbfb995295mr8671700eec.20.1775586936793;
        Tue, 07 Apr 2026 11:35:36 -0700 (PDT)
Received: from mozart.vkv.me ([2001:5a8:468b:d015:412a:9f09:7acb:b69f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2cba5df5c24sm15982022eec.27.2026.04.07.11.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 11:35:36 -0700 (PDT)
Date: Tue, 7 Apr 2026 11:35:33 -0700
From: Calvin Owens <calvin@wbinvd.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@kernel.org>, John Stultz <jstultz@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
	linux-pm@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [patch 00/12] hrtimers: Prevent hrtimer interrupt starvation
Message-ID: <adVOdTnyIbKz2F91@mozart.vkv.me>
References: <20260407083219.478203185@kernel.org>
 <adVA_uv1srA_bsKj@mozart.vkv.me>
 <87ika24phf.ffs@tglx>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ika24phf.ffs@tglx>

On Tuesday 04/07 at 20:03 +0200, Thomas Gleixner wrote:
> On Tue, Apr 07 2026 at 10:38, Calvin Owens wrote:
> > On Tuesday 04/07 at 10:54 +0200, Thomas Gleixner wrote:
> >> He provided a reproducer, which sets up a timerfd based timer and then
> >> rearms it in a loop with an absolute expiry time of 1ns.
> >
> > The original AMD machines survive the reproducer with this series.
> >
> > Tested-by: Calvin Owens <calvin@wbinvd.org>
> >
> > I'm happy to test subsets of it and stable backports too, if that's
> > helpful, just let me know.
> 
> We'll only backport the first patch, so confirming that it still
> prevents the issue would be nice. The rest is slated for upstream only.

Confirmed, [1/12] alone passes.

Thanks,
Calvin
