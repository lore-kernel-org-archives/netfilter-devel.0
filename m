Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792540547;
	b=kf9/9UU1Tn3JQolvkkAKbE+4alA4yfqIkTxQWCq2DQPhSPBGM5+vApFoVHc7AiPhzkBW
	 cIYdhqUOW9D1DuS/mxcKTpqyrCKOrYZ51JLEUFaGMh0cfrsmAeSPmm+ykgMfsJqQ0AulM
	 ZcYAlxiUtdsXmo0tCojo/C4eToykaDTLgVDXt93rEhI7HQ4Zcoyp8Z0uZJC72FpX8dkyO
	 dTRklL2jeYJzQmr/42y+76YVYJXrjnnLyvXa/FhLWICXkLaN3Rh/GUmunOjMkbc9ePPvd
	 U/GjA3QIvWPxGxIGoV0P4OhTuLjZ4/yFa0hykpCXzKIBZxyYhChDbQn9uE+HgWRItsA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792540547;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:In-Reply-To:
	 References:MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=+tvpXm/HoR6a+N1wVoXUE6+RvsWF7QO2f3t2mrdjdV8=;
	b=udugwAnFM1L5o+AzueKNusXZCLSfdKssMiJ6ybpaG3yPA45q4GO5uU7ck7ekx/i6ikyr
	 p9yFB64kXmRkGqJRXSQWjcDgfdo51+mfw6L+FU9tpOngpuk2PXwh5RqVoI1ogJMndGrQv
	 p12MDS5RqSpHT/eNzc0R0+fvLYnKGDo9f+smP3oOGGIoU4DtOt2FLubl9UP8C+qyUi6eK
	 UqjKgK5vayeVwbSW86ZQ4IyU+cYL0qFs0Gv5jdrcpthLxDMjhw5YqWwYNB23FYQgjVF8Q
	 T+MTH3hemamFcknYh6EmRPvCZ+t/3UYrvAP8dMjVxfRdUOJiFyLEcT/nLgJTgtkTvcg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lxe3pSJb;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED782606A319
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 23:55:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED782606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Lxe3pSJb
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso132059a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 16:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792540545; cv=none;
        d=google.com; s=arc-20260327;
        b=FfgPdNF3myuoe+uKmudMKd/3bvrsx+9NhAsPB6BKLkajqem3hQ3vT7ZiQTb+Egnq80
         8i6OIBebAOP3x5YMCGG1vL+qnXdZhY8V0LdYHfYFFnImmaDhRNJA7BBot5aIzuhJpB/+
         5Rss3S+YZ62u8KckTblimqDT/TAIG+y5RddxtRT451MVPTHddox4ln0mg63Sz5l9I+3U
         3Tb6osSuN+75MaeZPA/0kBku/T4h8NsjKbiWaO/al2oELABLE/QTP517dbIBwAIX3sOm
         dE2t+DN0ErPrO24vVICXzjyQryVPVaaEpWv4OWcfza4EUn0AvzVmH+pmB20eH9BArgtB
         jbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:references
         :in-reply-to:dkim-signature;
        bh=+tvpXm/HoR6a+N1wVoXUE6+RvsWF7QO2f3t2mrdjdV8=;
        fh=iqt0OOJiLPNqomUKVXftm2yPl/A7LLRZouru+XLY+N4=;
        b=kRSW5riHiW9xd4UhBFyWhE0qpe8VR6+aD9ikglFk1BYBVhBMvOF9dYAszcTk3q43gX
         bfAeWWAY8gBMpFLtm/enQyRLf6k+05RqdHkLkk+vDUgBvlIxOe3EaylanEvczlPev3jK
         5jl9+Uu4LkICRAKJzJEgRKEkgV+g/m5pgbu9sQTDfGtSVVLyheLfUTYsruDZj7Zm+pSf
         YTFRCxCL2s8hiP1v0+zTUBwpu2b1z23DzSU31/A/dd1ONCWjORwbBzH2pOlZv5fhgTho
         9SJz4hFRRBZXiaB5CYBslhIFVr2j9eVHH03F+0EZoCPz44qEJokMIDhL6vbQLhBYDDGn
         9Fow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792540545; x=1793145345; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+tvpXm/HoR6a+N1wVoXUE6+RvsWF7QO2f3t2mrdjdV8=;
        b=Lxe3pSJbg1u5z8tLTcoXVfJD7AcG0ZlVbOiOJUcCRnsNBP7Mq61IBycnujGz2ZUMGq
         /DWXiI8MV7PX6EufhAa51hcoi7OkHKxGKa/4aAw/fHe5C0Sp/qdOQpxvST//zg0zzy12
         vGeVSAAMar419d2anerPSKUAi5Yb8Z9SgfHRcOZbZWsiaLaKtXXFH3MXlJMR63RAA3y5
         vCCdCfCZdLwtbdIUCzghPjoEiDVC8mEAr+4ggMi7kYsLckC0p9jYrCplBZ52GsYUjbjz
         NKZs50DnHSOkvHRbrxvTcjuPcCCQ/hqGS3p6kOAs35VXIpxvgTdig/s/aD0TNplLzjcA
         Otnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792540545; x=1793145345;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :references:in-reply-to:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+tvpXm/HoR6a+N1wVoXUE6+RvsWF7QO2f3t2mrdjdV8=;
        b=AT4qEjFj1TNG4kdvlk5kH4coBK3w8eUVFCgmarqXO6ekxLEFqkEi0Eb+YlHM1szwFj
         gC+7FIGwry1qveOgEb7ILrnkIQoojXyctS5p8t8037x3dDsrR0GyaeTaFQR345SYp94c
         BY9SxMT6yskOAt6YADEBYe48IqIILCUmNzxG6047/P9VP+LcxE9DVTQPyJDvnPoYXrl0
         0bZ9CP5BBVmugRZSaTs704SbhFcBtduGKN1+rY+BHrlXzNm1XYKNxEgleqIITy7RTQDJ
         aeYpqRgEzy2CeYv0FngC9ibtw04rNJYeqRM1BvGuoMUixpvQsP4L6auic6yDR4IYXD5d
         Ph6w==
X-Gm-Message-State: AFq9FYK6GguoOMCVG64u4RLxl1qtlaFMribYl2y87sSbjZdkAk+gthRf
	WS25EDL9lOO4yUalw2i3JQ0g7+e3+qwthN/yjfVZtgql5zWyK3jSBMux9KetRkIusIrdu6Ywhju
	PTvCY0TWMNd9cbNqCzlP29G+Y+5RIyn+mPU/n
X-Gm-Gg: AYBFou3RY5DPfOoldAI4XtqCV/53fmhWWtlvouykHnSAU/cQsCqFQ1ow5r9tGZnX3x3
	4n+qmtr5LzmNPEziOHl7nuddTgx3GAFkCJ4umzOKRri2YhBtNnn9D9qqXQZPaA3FoxjJP8TD18z
	uD4PF2eHxzQ1hYW6xAuGQ4wP6Al5rJecMHad5ok9SSxFFIprGQ4C/ATLUemdJmVgJ2g9o/Jj3OO
	QaeeqhOB359dYf/DxBukjwMBP0IHYa7tv7EuE8WEwZfprmugm+lrZHMJoiBnzTwLPWTGOZ1LAkJ
	WWZdkg0NsDwWgrOwV3usBksV8Q3BpwFfcWnPJWsp9cW+G9r8Ec4qOGaTmwadbgi2MMPDnm4zGyD
	tCR5OCewpvag3/7dBI93ryAx+HLbrI1QHI/3E
X-Received: by 2002:a05:6402:434b:b0:6ac:b9b5:8e8b with SMTP id
 4fb4d7f45d1cf-6b408e8acfdmr139114a12.15.1792540545150; Tue, 20 Oct 2026
 16:55:45 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 20 Oct 2026 19:55:43 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 20 Oct 2026 19:55:43 -0400
In-Reply-To: <atf25JhLxwTY8kha@chamomile>
References: <CAC9WPdyPZNTHOMmm+C2shvJntRytoD6Zj17Q3MWFmjZQTv5+QA@mail.gmail.com>
 <atf2bRP7z2j8gogm@chamomile> <atf25JhLxwTY8kha@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Pulse Zy <zypulsecore@gmail.com>
Date: Tue, 20 Oct 2026 19:55:43 -0400
X-Gm-Features: AclHuK_v0oWqQn6GFygdMl2FkTFbxyhiqpG6NFecMCJvhYNfXEduaIcEltFk1BE
Message-ID: <CAC9WPdzTfkn+-XyJ+_9n8Y03KHhaATQYnegt6nPQ5rcFHx=+qA@mail.gmail.com>
Subject: Re: [PATCH conntrack-tools] conntrack: apply the receive buffer size
 to the event socket
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Thanks for applying the patch!

I checked the commit and noticed that both the author and committer
are set to you. Would it be possible to correct the author to Yuen Su
<zypulsecore@gmail.com>?

I also noticed an unexpected "Signed-off-by: LLM" line that wasn't in
my original patch.

Sorry about the formatting issues. I'll use git send-email for future
submissions.

On Wed, 21 Oct 2026 01:19:00 +0200, Pablo Neira Ayuso
<pablo@netfilter.org> wrote:
> On Wed, Oct 21, 2026 at 01:17:04AM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Oct 17, 2026 at 09:03:09PM -0700, Yuen Su wrote:
> > > CT_EVENT receives notifications on event_sock after socket
> > > consolidation, but --buffer-size still configures and queries the
> > > separate control socket. A larger value therefore leaves the active
> > > event receive buffer unchanged while reporting success. Use event_sock
> > > for the forced setting, fallback setting and effective-size readback.
> > >
> > > Add an isolated real-kernel regression that traces all event masks and
> > > two requested sizes. The original fails because the option targets fd 3
> > > while the multicast listener is fd 4; the fix passes all eight cases.
> > > The existing conntrack CLI suite also passes 286 cases. Prepared with AI
> > > assistance and verified against actual netlink syscalls.
> >
> > Applied, but I stripped off the test, a bit too specific for this bug.
>
> BTW, author in git shows incorrect because patch was garbled by MUA
> and I had to manually fix it.
