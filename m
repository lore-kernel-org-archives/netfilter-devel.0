Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AAE33507E
	for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 09:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774605123; cv=none; b=T4PjQSoekeVnh29twypCyNGyy2VT+L5nx19oO2AEIbWU21dRfP/8wOExavZ1Ji37fANPfqPj0ka3wiYemkviDXpmgjDMS1VHf8C8/oCdq3IJKmGWSuEzUDeggi7nx7pcMfw5TU3FwWXsm3zLF5v48XVvUuqkb/bpoV4zodBY1Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774605123; c=relaxed/simple;
	bh=Dp3MNtbG2Ra9D72qFSlN6BDBrNLkOm82BcB2DQzMSic=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ruaSlEP5yho2eDTFFsAFNazOoRRw7sou9NNPUV4hACneDcI9oVTCh+A3RI+91sezDKOFF2k1C/b2PIUgdvOBn5yMYxFUGDwVuWyZGTInh6//m97AA/0jcINpEkUbOHzt5lcxZCpwW2r1JDdZpIVJVYNMNmcL3EO7y+By3rVdADc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EHAxITSf; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EHAxITSf"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so17077415e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Mar 2026 02:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774605120; x=1775209920; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSyUmVr4YfJQ06RNZPzlXo9OSQ4ExGfoU6kw5PEeudY=;
        b=EHAxITSfOxYp09Bf9cxlozZ/4Ro0+hOe19GQnmU9L8oSnBppCxcgpemDarS/mR7/K1
         GuvFA7FrjTFTogP3WOXoxPai5B4Oy0IzO+yOxOP8H/5czi6/Uisr6B1W1wzhszyohyEj
         mkTXr/b63vMCxJLOw3esatdPf/BguT2zHmo8PKp4iEKn+xWoZqsKOqgop1QtTJJhC/8C
         dXbpA2gybSXtG/kWygY6rAdcVzu9UXqwiVuHxNl/kJE8bs/dP0XxDEVAZtYZ46xdt4xx
         AOQGusltHEXtYMHiRkGZXVIxS3Uu2ChWZNozwwVGe+JnFyVbEpzf/6DeIi7lFpIvZlOw
         tHxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774605120; x=1775209920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oSyUmVr4YfJQ06RNZPzlXo9OSQ4ExGfoU6kw5PEeudY=;
        b=YWYeKKNAviDCarY8bZsqiQpmbEN6ldDcxpLHYfTKJ94V7YsoUMrM4B7rQWRbcZlxHb
         zmejAInHAlv5KRnT88elHVgSCOnn2v3LC2bAaKGKJjWvQYak3BS+X2xP2zv03nJsEAG8
         iOkh4pQEaORy5lm5vG0lY2NFtdZY58qVMjRv9AhiWKDQsn784EOAiC1i5wiWV98J2s2E
         Obc6k5BxaNjvKehu3EATUsV312E9/JOCbkZlH9JyfaVNb7H8yj5CCNEPpYVNJ7UgXSYk
         TCrx7G/yDx89MFNrQhkg5VABtRk8cXR62Q2dutysFc4KfKjuuPgCml10DLqmiRihltky
         xmAQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi2ebOfcdVNjlZ/h/sKJ+lYzSb7uUG4ayfPuG7/P8pz6R2KwEGu09Dgp940LkFJGGqJu5DLsExIhl9pYgHW1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPAVyIK7NwxYiDvbR+b0gA/2YuURWOnqLeWegZwMhuIO/E15T6
	wtu6bwoFIXeu9JOdTWX9s0h/fqjeHf5YWs2NcOIGxvLXMAYyOeUxivtn
X-Gm-Gg: ATEYQzwIaXZX2f051SZyyZxIGs4VALSSM6uBlGuawDsWF0jFbTKakylXpD56enYMAim
	ETA+asgSoCmaM5+B+WJFYZTa098NrXIP0T5Bt/g8UzpiNaZNIE3Jx9KXR2cnt/w4sxAwxZP/4jf
	1FvGDwSmXcicOxbPlR8jzacTqeQtG5fcEGR+ycJH48nhBXFsPFN6G/yqyZH+Z+5SUPtKh96DL/f
	6EHrLKjEvdyDBpCUvaV6fV2l/X+Xt3zNWabkCJ+LMuB/pyho5Y0LoiWlpaN2UyFowl67Eu/qc+q
	UVJFGAysWkRhF0Bkt5e6rysbhNNW5uIfSEuQb/ogP2GxtJNhCH7Pjvdw9i6x9JOTDtixaMtUTzB
	6Gto9YqbgFcGQ6o+p84lsKZ1GZ9gvcw32SiBtU1i/XXTu9mFSla8EMtHs+tLBY1MbZgvAH+xePG
	gIo1GuJdRdDWGnH+PjQQOTstQPmmv3QNtAN7TD+sApPG88Dl46/liI9hTuyMfjVO8e
X-Received: by 2002:a05:600c:4e0b:b0:485:fbd2:f72 with SMTP id 5b1f17b1804b1-487290a9254mr22274755e9.1.1774605120105;
        Fri, 27 Mar 2026 02:52:00 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c7cec3sm82055945e9.6.2026.03.27.02.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 02:51:59 -0700 (PDT)
Date: Fri, 27 Mar 2026 09:51:58 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal
 <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>, Petr
 Mladek <pmladek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH next] netfilter: nf_conntrack_h323: Correct indentation
 when H323_TRACE defined
Message-ID: <20260327095158.74c87ddf@pumpkin>
In-Reply-To: <acZM4qwEtWqANece@ashevche-desk.local>
References: <20260326201819.3900-1-david.laight.linux@gmail.com>
	<acWWBxmPd_BNqUHF@chamomile>
	<20260326221809.0b99df3f@pumpkin>
	<acZM4qwEtWqANece@ashevche-desk.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Mar 2026 11:24:50 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> On Thu, Mar 26, 2026 at 10:18:09PM +0000, David Laight wrote:
> > On Thu, 26 Mar 2026 21:24:39 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:  
> > > On Thu, Mar 26, 2026 at 08:18:19PM +0000, david.laight.linux@gmail.com wrote:  
> > > > 
> > > > The trace lines are indented using PRINT("%*.s", xx, " ").
> > > > Userspace will treat this as "%*.0s" and will output no characters
> > > > when 'xx' is zero, the kernel treats it as "%*s" and will output
> > > > a single ' ' - which is probably what is intended.
> > > > 
> > > > Change all the formats to "%*s" removing the default precision.
> > > > This gives a single space indent when level is zero.    
> > > 
> > > Do you have a setup using this helper? Or you just found this via
> > > visual inspection?  
> > 
> > Found with grep looking for places which might be affected by 'fixing'
> > the kernel printf code to be POSIX compliant.  
> 
> Do we have the respective test case in printf_kunit?
> 

There are definitely related ones and this comment:

static void
test_string(struct kunit *kunittest)
{
[...]
	/*
	 * POSIX and C99 say that a negative precision (which is only
	 * possible to pass via a * argument) should be treated as if
	 * the precision wasn't present, and that if the precision is
	 * omitted (as in %.s), the precision should be taken to be
	 * 0. However, the kernel's printf behave exactly opposite,
	 * treating a negative precision as 0 and treating an omitted
	 * precision specifier as if no precision was given.
	 *
	 * These test cases document the current behaviour; should
	 * anyone ever feel the need to follow the standards more
	 * closely, this can be revisited.
	 */
	test("    ", "%4.*s", -5, "123456");
[...]
}

I suspect whoever wrote the tests found the code was non-conformant.
But there isn't a comment in the snprintf() code itself.
I've not checked what the kernel code does (I've just written/fixed all
this for nolibc - the kernel will fail the nolibc tests).

	David

