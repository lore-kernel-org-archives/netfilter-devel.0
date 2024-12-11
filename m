Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CABD23FD14
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733923307; cv=none; b=DKdn+TFpdg3Ye6VfffSDFOQyqimqn6LQW7LrzDcBHLCyirU3j/PvBCBg8YynITGue9ALzmcm1R39eRKu6WKVYvIUliE06PSPNM85A3Es+hF1NyvG0mjHU8DulFhHy4Zfex6QBjxhS+625YIzPuro5O3uSnH6g5Y4AA10s2c91TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733923307; c=relaxed/simple;
	bh=RPEBjQP0OcwhX3nUIQE9WuQDD87s2+IGYDhtmJcS9js=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lbiK3drJpr+KnCP4ocog9e7Fsvj/oU76iGI4UAcB2pQdEpRaYLo90ThujxoxCqj6ylFZsgPIiby9X+5irCVlNBstMuBzcJMtST6RMYIEmMmrLXrXIqiHWYLIfF/bmrWT0St13EdO9LTWxNRX5KyUYDbPuTMnWHtAzj9ZYNkXoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q1TVn5oB; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q1TVn5oB"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-385dece873cso3253515f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Dec 2024 05:21:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733923304; x=1734528104; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9eKaWxEhhuVWvBsU53E8KZ6fOQTi8MzTOfznqa4xjH0=;
        b=q1TVn5oBp1lb1YK/sKlZ2+h2xr8WrHLpSdvnm0FmkUDJFYAwZuhk3gmakBaKOQDy5E
         vo+uEWPdNJacjhF07wY3+WCwhsZAQ6u5queozgf5Z3OUiUDK1La1AcAoYe8FAXt/QJRI
         YMGyCoUpTgRKUlwRCRhzGnJKvOdO+MGO5rSFq67xllvm8ABXMEeqHxo9BP6s5ZLQfwZ2
         Q+70wCJrYD9q555dkmebY7N/Eq4ZkHBNsC17R3ey2zAb/vjgF1N1HaGi0v8vDyVsrioH
         zPO5Ot0D4701bbv08jEJsMHHHFwmNt+JgfTgp7ezXdyvGhl5vLnMbBi8f//HgJju00Xl
         AlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733923304; x=1734528104;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9eKaWxEhhuVWvBsU53E8KZ6fOQTi8MzTOfznqa4xjH0=;
        b=bsGfrBo/1rZKh2X0YvMo1XCXV/fi8EJe4/G6+y3vusk6yp2OBfNCY7BXwp7Aeh19IK
         rJ+gw8ifsiNygtg20UfMyOPFN/0Sofxc9Z9IAK+oH+f+kTEu4xrheQ7+6qbAquspck6Z
         AWMOFVTzK+SX0rvnDh0rD9RkW0nxfsk8MV+HNYUf81zrHKEfk6TDvHbZB/SEXUXVEocA
         fsW/s4zmYJzpnNSCuzcsHh1umHIQGSy+PF5pWJwOX6DLS6L6VbDxQSDsS+wrGQcAy3c2
         bcKPWBSVsJhG5XFueHe8JIT4OPDqyt0entBQZEgxWf9rZa9H+aLUv9Qcpn6OTkC4vSoh
         zHVg==
X-Forwarded-Encrypted: i=1; AJvYcCU+ViNuXLUMRG2QD48Iji4W8D+XVKTats5QWRrBzx06ge4kmfYnW08RcO0/hKXSNH8oJ9GkcDyDvi77ttwdj38=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaVzIGYA5wYSpIw0iEBi/BENw13/uTpcphX5shjjZJSqyuUOV7
	ba2ZkDfnu9zGxRPKIHL2EBjp9EM/B5LE/2fvtDeTuVsvBPqllntg6za0AEGzBHQ=
X-Gm-Gg: ASbGncvLIyqvaK78fXcKtqw4VeT/Kt1vve9yKhPRUVKN9Lg4miyGIBf3KZKCvnOGjjO
	Pz/J7ZjLaRrkvlnqgX/h3Oo2BFab0F7odPsloqA+jcQlAftKc32IAdBZjyBgwP2A0WOV3nX9rhf
	p+g7zwb+GLwyeH9MKX0iUbZKqciXWgIn+H2tnwN8q1vekpFgi+5ZWMcOJzm6zN58VbAf1h5eE1/
	Fk0A4Oo358rCfkKjmym9n/aXl1ZXBwmqUZ3dJfnZxWItc0twywD6QoGk+8=
X-Google-Smtp-Source: AGHT+IFfC29j6czTll9rOLSqjnFeJosj8hGWZx1V8FqolEsDfwkRoQYubFcSENWm0L8tfipl6WqLzA==
X-Received: by 2002:a5d:6486:0:b0:386:4a60:6650 with SMTP id ffacd0b85a97d-3864cec5bd0mr2542328f8f.42.1733923303738;
        Wed, 11 Dec 2024 05:21:43 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38782514d97sm1260997f8f.64.2024.12.11.05.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 05:21:43 -0800 (PST)
Date: Wed, 11 Dec 2024 16:21:40 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: David Laight <David.Laight@aculab.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	open list <linux-kernel@vger.kernel.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	Linux Regressions <regressions@lists.linux.dev>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>,
	"toke@kernel.org" <toke@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"kernel@jfarr.cc" <kernel@jfarr.cc>,
	"kees@kernel.org" <kees@kernel.org>
Subject: Re: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
Message-ID: <49a14c12-a452-4877-aedf-94bac6ed2b7b@stanley.mountain>
References: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>
 <8dde5a62-4ce6-4954-86c9-54d961aed6df@stanley.mountain>
 <CA+G9fYv5gW1gByakU1yyQ__BoAKWkCcg=vGGyNep7+5p9_2uJA@mail.gmail.com>
 <bd95d7249ff94e31beb11b3f71a64e87@AcuMS.aculab.com>
 <CAMRc=Mf8CmKs-_FddnLFU7aoOAPU6Xv8MqyZo8x9Uv-Eu+hs_g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMRc=Mf8CmKs-_FddnLFU7aoOAPU6Xv8MqyZo8x9Uv-Eu+hs_g@mail.gmail.com>

On Wed, Dec 11, 2024 at 01:46:11PM +0100, Bartosz Golaszewski wrote:
> On Fri, Dec 6, 2024 at 3:20 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > From: Naresh Kamboju
> > > Sent: 05 December 2024 18:42
> > >
> > > On Thu, 5 Dec 2024 at 20:46, Dan Carpenter <dan.carpenter@linaro.org> wrote:
> > > >
> > > > Add David to the CC list.
> > >
> > > Anders bisected this reported issue and found the first bad commit as,
> > >
> > > # first bad commit:
> > >   [ef32b92ac605ba1b7692827330b9c60259f0af49]
> > >   minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
> >
> > That 'just' changed the test to use __builtin_constant_p() and
> > thus gets checked after the optimiser has run.
> >
> > I can paraphrase the code as:
> > unsigned int fn(unsigned int x)
> > {
> >         return clamp(10, 5, x == 0 ? 0 : x - 1);
> > }
> > which is never actually called with x <= 5.
> > The compiler converts it to:
> >         return x < 0 ? clamp(10, 5, 0) : clamp(10, 5, x);
> > (Probably because it can see that clamp(10, 5, 0) is constant.)
> > And then the compile-time sanity check in clamp() fires.
> >
> > The order of the arguments to clamp is just wrong!
> >
> >         David
> >
> 
> The build is still failing with today's next, should the offending
> commit be reverted?
> 

It's a simple fix.  I've sent a patch.

regards,
dan carpenter

