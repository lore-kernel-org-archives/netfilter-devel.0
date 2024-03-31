Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2008479
	for <netfilter-devel@vger.kernel.org>; Sun, 31 Mar 2024 22:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711925620; cv=none; b=WKw9U3gV1du5mm6glcuJ3JIocFZIjDM5XPxWGsm1z46KR56W9i0ok3cJy0LwDAgMJ7QUYmMRnTdZxyRMQB+1cfeUuGhZNQWEHIPhaknmispfKFpJDo4a+XVKrVo6/oj7umYbIal7cYDVte97mnmJvzr1fHdOf6JpbU1ZMym0naI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711925620; c=relaxed/simple;
	bh=zyAUa/2yxokn+UbDZdpV3vJ8Il6g1jwj7SWtPEmYCPk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rRiJeOAJCP8d4v3CcuCD/jDsGhLnaXNymqGu54r1unGYsrEo6Vkpzgq0eigFo2lyq5U2eT8hIn7usmaw5d4s0fqavPisjewa+4zMG+WAtaQZDI4kCLhNrMKeEuNPPp/9UVK9jvu/+hnQ4gS7TgWSlrHpLfIbnIrm3AQzkcGfViw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrfoZwXs; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrfoZwXs"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-5bdbe2de25fso2614211a12.3
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Mar 2024 15:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711925617; x=1712530417; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zyAUa/2yxokn+UbDZdpV3vJ8Il6g1jwj7SWtPEmYCPk=;
        b=WrfoZwXsXiwT33pPsDQtBqitaZ6bIgTk39H7XnvUa8rdnZ9Mji96fvXp1fR4HHlY1W
         FyFQowX2EMSdlpRRXKXILV462oq/Ay4G7M+itUuy+c4WmWi/pOCWjxS4119NiDCuwAT1
         rLe77NDqDY0nY2AYtq/4WkX7782/GZv9k7/sViPsdLL+bR9ytolXUYnU/HvcJM2CyVeC
         mLvI43YJH7w3GpbBIOXwgA1ops3k9qrR8xU16VWBjDq5k1ZfOofezI8g3QbbH+G76UmE
         p1tkbn65OT/okCtnOBnOsrIY9yMqc2IOygtt/IiXkrakoQDUOSjmqCEO5qSX/ohNt4Ys
         6l7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711925617; x=1712530417;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zyAUa/2yxokn+UbDZdpV3vJ8Il6g1jwj7SWtPEmYCPk=;
        b=ZWyxD8LBubRZYaeUEal0vgDuKuS289hFZ5LvRr0QTWjT06++D/gObQBAGfOKG/4GRJ
         R6op3mLU+6bYQQAy3GmC5pzkRtdd8mK2b6zoiGoGU5IVfnAhjpf4b7ya5pf3G2+woL/G
         uI1DwkJSVR1sDtsZqJGnxOGjpYe0Ja8I1CIfRLiCmvyo7hJKPSxpD6Od2Hwpyr7bfysS
         k30o6cJYCpJ1ytToBkIXn2etDv5qsABjzER2m+6QjzEHXSR/xPFOfZbnBuNRMByGjXiY
         fqDWBCMCOLG8qtxFhRYAuKFG+8xkYc6EWHDwxvXFY/f0JS4VoL2ujRx1FOI0pe/6HXkq
         hivg==
X-Gm-Message-State: AOJu0YyfTjinKmTC1g9OjBIhveo0dVy014IrxLfZgWYIZg5epNbqXfAO
	P5794TkGiA3nVA5Thh1KHwsSlngNGvor9e7SkoKG+fMotWy+SELTzK6Z3/iL
X-Google-Smtp-Source: AGHT+IGyvAT3yAuzLJgTGyQpNlCg+jqeFKzCHLyDNKMI/yU/GvLBj3hkaxDDOSojNQJYz7d6eeMsow==
X-Received: by 2002:a05:6a20:43a9:b0:1a3:bc78:fd1 with SMTP id i41-20020a056a2043a900b001a3bc780fd1mr10076601pzl.59.1711925617262;
        Sun, 31 Mar 2024 15:53:37 -0700 (PDT)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id d9-20020a170902b70900b001db37fd26bcsm7400351pls.116.2024.03.31.15.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Mar 2024 15:53:36 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 1 Apr 2024 09:53:33 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: (re-send): Convert libnetfilter_queue to not need libnfnetlink]
Message-ID: <ZgnpbZfHCMZnXmIT@slk15.local.net>
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
> On Fri, Mar 29, 2024 at 08:31:13AM +1100, Duncan Roe wrote:
> > Hi Pablo,
> >
> > On Mon, Sep 11, 2023 at 09:51:07AM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Sep 11, 2023 at 03:54:25PM +1000, Duncan Roe wrote:
> > [SNIP]
> > > > libnetfilter_queue effectively supports 2 ABIs, the older being based on
> > > > libnfnetlink and the newer on libmnl.
> > >
> > > Yes, there are two APIs, same thing occurs in other existing
> > > libnetfilter_* libraries, each of these APIs are based on libnfnetlink
> > > and libmnl respectively.
> > >
> > [SNIP]
> > >
> > > libnfnetlink will go away sooner or later. We are steadily replacing
> > > all client of this library for netfilter.org projects. Telling that
> > > this is not deprecated without providing a compatible "old API" for
> > > libmnl adds more confusion to this subject.
> > >
> > > If you want to explore providing a patch that makes the
> > > libnfnetlink-based API work over libmnl, then go for it.
> >
> > OK I went for it. But I posted the resultant patchset as a reply to an
> > earlier email.
> >
> > The Patchwork series is
> > https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=399143
> > ("Convert nfq_open() to use libmnl").
> >
> > The series is "code only" - I kept back the documentation changes for
> > spearate review. These documentation changes present the "old API" as
> > merely an alternative to the mnl API: both use libmnl.
>
> Thanks for explaining.
>
> > Do you think you might find time to look at it before too long? I know you
> > are very busy but I would appreciate some feedback.
>
> This update is large

Yes, there are 32 patches. Unlike in my first attempt at this conversion,
you can apply these patches one at a time without breaking anything.

P1 is the critical patch: it sets up the private structures used by
libnfnetlink (using copied code) and libnetfilter_queue (by calling
mnl_socket_open()) so that calls to either library work. You would want to
carefully review the copied code that sets up the libnfnetlink private
structures. Once you are satisfied that part is sound, patches up to p10
convert all other nfq_* functions.

p11 - p32 do pretty much what their titles say. Mostly they implement and
document the nlif_* functions from libnfnetlink.

N.B. nfq_close() will leak memory until you apply p3. It might be best to
treat p1 - p3 as a single patch. I can re-issue the series that way if you
would prefer.

> it comes with its own risks and I see chances
> that existing applications might break with this "transparent"
> approach (where user is not aware that libnfnetlink is not used
> anymore).

Hmm. You do say above that "libnfnetlink will go away sooner or later". For
it to go away, you will need something like this patchset.
>
> So far main complains with the new API is that it is too low level
> (some users do not want to know about netlink details). The old API is
> popular because it provides an easy way for users to receive packets
> from the nfnetlink subsystem without dealing with netlink details.
>
> My suggestion is to extend the new API with more functions to make it
> ressemble more like the old API. Then, document how to migrate from
> the old API to the new API, such documentation would be good to
> include a list of items with things that have changed between old and
> new APIs.
>
> Would you consider feasible to follow up in this direction? If so,
> probably you can make new API proposal that can be discussed.
>
> I hope this does not feel discouraging to you, I think all this work
> that you have done will be useful in this new approach and likely you
> can recover ideas from this patchset.

Will address these points in a separate email.
>
> Thanks for your patience.
>
Cheers ... Duncan.
