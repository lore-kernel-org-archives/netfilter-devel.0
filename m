Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A7E2641DE
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 10:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741860262; cv=none; b=XPa3MI7z/siireXNlhX6lJnDaxlvLgRWRTZydsC9ViGmhsFy5v7Ds71mRGTB7ZS2FylCuOCt9pe55KHXqA72Ny4fxI5dL4eSdQU4OVZ6FT2FBMHA6sNHN6vLaQqJfbwjPgVAJ91h4sNwrmdc6Petjjwc1s0WSONLfHJS8iJJVi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741860262; c=relaxed/simple;
	bh=EHSxhG1PkIEdi5v661jHsDd/DT1y6iyRJPoGDO0bT9s=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFejrnrRJstvZatBThM70ZubGEssziCaq54yk4vvqm4nBONFek7axNwc28G5jy2NDqc/s4uDfGeXDiTioxtocoChoQm7gmI5KBOpnoqG+xv5j8Iio1NlTZii0jiV67mKhIAeiasGh59ydLcft+PQ+Rlop/PqeYVuLTZ/y01NGVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dATEmXMe; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dATEmXMe"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fef5c978ccso1293438a91.1
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Mar 2025 03:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741860259; x=1742465059; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDCdU5Y4qd2i6nDJI6Q4tcLfntu7NHQ3EbXxtF62Cvs=;
        b=dATEmXMe4ANHp9jLMrDbaf3S831h4gWkHpxAlFiDctNU+pkm5eLNORCsLxXzXugBcT
         vmM24DjIQL84TABpPXTAV7A1EshZGmjNhOogyLKBLjGvKxWNeP77MqgsKrdrky9kBxrN
         znfsDtKkGOXhftGNAw1/aYezVBXc0JuCHwXr3C8g809dIEtA6sEKINCiRTqiKWYQT8iE
         PcVy+9MyYYpqykizSWaYtJ48ulVNObPcMCsHg34/C2eDmwp0JPqn/54OyN7p4mLy1U5Y
         eDNteovbKTP8cOOoEfq7K9lr2rtZinbqFB6uqgZFH3syMnZOlzm/CReUw7ib+LKQIWYh
         AHyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741860259; x=1742465059;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDCdU5Y4qd2i6nDJI6Q4tcLfntu7NHQ3EbXxtF62Cvs=;
        b=BkkRrMP6IhxwtYWWd8i4+nSkd5u/UpOwDMjaH21Y5vlyQ3JwkOJZGwRm+hAeo4ASZe
         YMwptOzZGisIRH+ajslUaU3rajWx+BpT8u557e2xrpUbxMYK3EWzkrEi6u0cFxXCDPFG
         32aXQm16nG49cQrdAeYs/RGUNCmyL0ppIC0WawFFU7D4okEiOyX6sjjtCIeJUvzLyuly
         xnpQe8qY5pncZVROpDMANjyBFfU9w9u5ae6kFOEZz0i6/o35OGNto5yl/afriyQ/1Kl7
         lTDWh9ExiuyMkpBJc6UZfbKyodOSG5L/lHfiL+2SGdYuwAHrl2G70Kh1TjY/zIXaPdQy
         ZTqQ==
X-Gm-Message-State: AOJu0Yy3jwMb+6tQBG8ehzlhyTwITjNa1sTQ56ALbAp6m1WkPJ30oAD2
	3es43At0ZcV6yxJx5hEe/Z+2sP3pCXQvVGv2X28u1Ajj9nsc61DVjpAkPg==
X-Gm-Gg: ASbGnctAWLDl7SnjCVlGl2Ws2iIia2t5IvdQpt9DskvvRYnDNr+PXJSpAbhzAUMbGE2
	EjfMFTkaz53IUNdGdsGm3i8m93c3TvYTJYbvAjC2vt3GzqSJCZGAy8h/rB2Y//RVtac3o9J94k6
	6ScHy+59JC0LrfB6Zrf787d7EbqnSiWDx34M2kC1An5gUQmwhdRVi5HsIeDavtsrGwSa+HuUtZo
	dZBlFZzXJKUrMBU6534hw04A7Ot14beWZB+aBoHEcdRr4wcjjpb1G150N3ECaCCenaNJaIiIITI
	jIrEHCBSXJ1ZZsOGSyI0TMQh5N1DlQul97JK4UPrYxUHrMioDjUNoHxGIguFaQIvZ5Si478EpvN
	AJdGBcdPbb2g4aNviUshQhg==
X-Google-Smtp-Source: AGHT+IFGyPA/aYREd1HqM6JozLxtG2h0EzrWBZvVuLJYTjviXyoQGqnNVy4NQuzFtMth0fnikyPwWg==
X-Received: by 2002:a17:90b:1d0a:b0:2ea:aa56:499 with SMTP id 98e67ed59e1d1-2ff7ce4f019mr32856935a91.1.1741860259241;
        Thu, 13 Mar 2025 03:04:19 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c688846csm9755315ad.33.2025.03.13.03.04.17
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 03:04:18 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Thu, 13 Mar 2025 21:04:15 +1100
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Documentation oddity.
Message-ID: <Z9Ktn9/lQlcxovkX@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
References: <9190a743-e6ac-fa2a-4740-864b62d5fda7@jubileegroup.co.uk>
 <bda3eb41-742f-a3c3-f23e-c535e4e461fd@blackhole.kfki.hu>
 <4991be2e-3839-526f-505e-f8dd2c2fc3f3@jubileegroup.co.uk>
 <Z899IF0jLhUMQLE4@slk15.local.net>
 <99edfdb-3c85-3cce-dcc3-6e61c6268a77@jubileegroup.co.uk>
 <Z9EoA1g/USRbSufZ@slk15.local.net>
 <e0ebeec6-7b3b-c976-734e-9f2bbecaa6a@jubileegroup.co.uk>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0ebeec6-7b3b-c976-734e-9f2bbecaa6a@jubileegroup.co.uk>

On Wed, Mar 12, 2025 at 09:48:00AM +0000, G.W. Haywood wrote:
> Hi Duncan,

> On Wed, 12 Mar 2025, Duncan Roe wrote:
> > On Tue, Mar 11, 2025 at 10:00:04AM +0000, G.W. Haywood wrote:
> > >
> > > Debian 11, gcc version 10.2.1-6 here.
> > >
> > > 8<----------------------------------------------------------------------
> > > $ gcc -g3 -gdwarf-4 -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> > > /usr/bin/ld: /tmp/ccbLJv89.o: in function `nfq_send_verdict':
> > > /home/ged/nf-queue.c:30: undefined reference to `nfq_nlmsg_put'
> > > ...
> > > ...
> > > collect2: error: ld returned 1 exit status
> > > 8<----------------------------------------------------------------------
> > >
> > nf-queue.c has compiled fine.

> Quite so, but it hasn't linked and no executable has been produced... :/

> However, with the object and source file args at the beginning of the
> command line, there are no linker errors and the executable is produced.

Ok I can reproduce this on x86_64 in Debian 11.5. This is the first report in
almost 5 years, so I think the problem may be Debian-specific. But I will submit
a patch to change the argument order.

> # uname -a
> Linux laptop3 4.19.0-27-amd64 #1 SMP Debian 4.19.316-1 (2024-06-25) x86_64 GNU/Linux

That's *old*. Linux 4.19 came out in October 2018

> # apt-get install libmnl-dev libmnl0 libnetfilter-queue-dev libnetfilter-queue1 libnftnl11 libnftnl-dev
> Reading package lists... Done
> Building dependency tree Reading state information... Done
> libmnl-dev is already the newest version (1.0.4-2).
> libmnl0 is already the newest version (1.0.4-2).
> libnetfilter-queue-dev is already the newest version (1.0.3-1).
> libnetfilter-queue1 is already the newest version (1.0.3-1).
> libnftnl-dev is already the newest version (1.1.2-2).
> libnftnl11 is already the newest version (1.1.2-2).
> 0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
> #

You fetched libnetfilter-queue-dev 1.0.3 but 1.0.5 is current since June 2020.

> $ gcc -g3 -gdwarf-4 -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> nf-queue.c: In function `nfq_send_verdict':
> nf-queue.c:30:8: warning: implicit declaration of function `nfq_nlmsg_put'; did you mean `nfq_nlmsg_parse'? [-Wimplicit-function-declaration]
>   nlh = nfq_nlmsg_put(buf, NFQNL_MSG_VERDICT, queue_num);
>         ^~~~~~~~~~~~~

Somehow the Debian folks updated the example to at least 1.0.4. nfq_nlmsg_put()
was in 1.0.4 but not 1.0.3.

Cheers ... Duncan.
