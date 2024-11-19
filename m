Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7ED1AE006
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 08:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732006379; cv=none; b=Oe6D+U+GTvHrmOVqJtuFmJaiqeMA/KkVt5DlAvIJ9DcGT9p6fh6vFYl3u2f9jKE0A2rN9nIgaTvtgfecF+qimU3+/tZK7EbBnYpizZso+1WnLUv/OaFjVnCf7EKTJmr1chxqa98QN82wUrLIcCCmNJPRYpHy51L6dP6kxXzuveM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732006379; c=relaxed/simple;
	bh=1PQE1f1xCJGY7Tky1gUdhI5mXqSifmAXMo1KKarsrpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPYdYP2QseFInDpHjYtaBPV/xFWY8HGbrrK/X4CkWwv7ZTs4/nmAgvSiHQc3Ebp5IynLNNQlH7tyL/vc9DnUKDa86fw7ImGb8/xqzb2rhwixrFxdR6tFUZUiUnRQjvJpTP6i0jShPIiiFoXWW+iKLwZNvfPDC5aZf59prp6z3so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YwX88J07; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YwX88J07"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3823eb7ba72so493757f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 00:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732006375; x=1732611175; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qaBG3Z7R9DOuiOybc185RSD4M8rIPEBBhrkZgjFmOxU=;
        b=YwX88J07/QkBNEkAjW82kPZVlFUMTCMLsjf6gwhsceK2l+pfQq+2IhMEYkPxcbHwhM
         iIQcYiE8dfVaomj+NhbmG33a7kOfZvnjheNotc1ehgHzsh9k5KiMvqplMIWd1Ktpn9J3
         Jl0NwUBhIo15kB0LHJKNp3KvnQt5IzMLrmOUt5OqKtW5fSa8heyxjOg/WBK+TsNjc4QK
         7m994E+mkEwkTIETkvQ3HV9EOmS6rF7kT/r6PvKAWOsvp3P9FDmpG8UYYfYu5j2pKTin
         nV23yVqo7cve/XHz6GfmTRniT88Dp7udY5CmrOUKjj10LxJKyDd7AoBmqCML/ASfnVOk
         i85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732006375; x=1732611175;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qaBG3Z7R9DOuiOybc185RSD4M8rIPEBBhrkZgjFmOxU=;
        b=ZOGzuqtunwdM6++oMU3DTl/7VzctfUfKyvTfHhw+VPW9mT7u3CKtWAYHR1FE4HSfPZ
         u+wsYFlJJ6l96Svr20fkFWREiAlcfIpbxxrFTWuh38ir0P2GsaxeYlaM0Hiad151fmAY
         4odzIVEhkqSu7D82lQyWPENCkbO4WErApzpHf5IGbNP520lbUiazJx/eFE2BfQjr5A8H
         dZW4bjlS+91qPParouVpCpZcFSuI+KDanHl4X9Pupd/PpBDkMng+DJ79W8hTn5biHars
         b2idQtJ5QciWloBFjp0KZa0lkfq2uSDtw5aKaz6auuM2tMxmW9WEcoQk0j1kYfJl+4kf
         IqwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHvFc17iEXtV2o0IQCXwX6j/mDduGNU9vV4Bni8zx0/VlaSFwz7chmFOtFQdpE+cFbawrptYIp7nPTwZi406s=@vger.kernel.org
X-Gm-Message-State: AOJu0YygExMDhB/mojDeEEdnFMclGcYrYbJq9l975GBNWmrwE893hZD+
	Z2bIRSz381T+qTr89J486VwcZjoiwG7306JGdtHe2nGk+mauzaOERCEi4QswUY8=
X-Google-Smtp-Source: AGHT+IHrqP9nC2rPwknktgIKbjWoIt1yh0m5e2N0IUvcTBAuP3H8V/AdHOWp2OIw94YWQU//ijQi/A==
X-Received: by 2002:a5d:6d0f:0:b0:382:2492:3218 with SMTP id ffacd0b85a97d-38225aaee39mr12773115f8f.47.1732006374705;
        Tue, 19 Nov 2024 00:52:54 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3824a8109a7sm3705943f8f.104.2024.11.19.00.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 00:52:54 -0800 (PST)
Date: Tue, 19 Nov 2024 09:52:46 +0100
From: Petr Mladek <pmladek@suse.com>
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>,
	Daniel Mack <daniel@zonque.org>,
	Haojian Zhuang <haojian.zhuang@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Russell King <linux@armlinux.org.uk>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ofir Bitton <obitton@habana.ai>, Oded Gabbay <ogabbay@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jeroen de Borst <jeroendb@google.com>,
	Praveen Kaligineedi <pkaligineedi@google.com>,
	Shailend Chand <shailend@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Roger Pau =?iso-8859-1?Q?Monn=E9?= <roger.pau@citrix.com>,
	Jens Axboe <axboe@kernel.dk>, Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ray Jui <rjui@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Russell King <linux+etnaviv@armlinux.org.uk>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Louis Peens <louis.peens@corigine.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Naveen N Rao <naveen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	cocci@inria.fr, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-scsi@vger.kernel.org,
	xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
	linux-mm@kvack.org, linux-bluetooth@vger.kernel.org,
	linux-staging@lists.linux.dev, linux-rpi-kernel@lists.infradead.org,
	ceph-devel@vger.kernel.org, live-patching@vger.kernel.org,
	linux-sound@vger.kernel.org, etnaviv@lists.freedesktop.org,
	oss-drivers@corigine.com, linuxppc-dev@lists.ozlabs.org,
	Anna-Maria Behnsen <anna-maria@linutronix.de>
Subject: Re: [PATCH v2 19/21] livepatch: Convert timeouts to secs_to_jiffies()
Message-ID: <ZzxR3uAcWFEPUIUK@pathway.suse.cz>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
 <20241115-converge-secs-to-jiffies-v2-19-911fb7595e79@linux.microsoft.com>
 <718febc4-59ee-4701-ad62-8b7a8fa7a910@csgroup.eu>
 <Zzsfuuv3AVomkMxn@pathway.suse.cz>
 <96f3b51b-c28c-4ea8-b61e-a4982196215f@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <96f3b51b-c28c-4ea8-b61e-a4982196215f@linux.microsoft.com>

On Mon 2024-11-18 10:18:49, Easwar Hariharan wrote:
> On 11/18/2024 3:06 AM, Petr Mladek wrote:
> > On Sat 2024-11-16 11:10:52, Christophe Leroy wrote:
> >>
> >>
> >> Le 15/11/2024 à 22:26, Easwar Hariharan a écrit :
> >>> [Vous ne recevez pas souvent de courriers de eahariha@linux.microsoft.com. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> >>>
> >>> Changes made with the following Coccinelle rules:
> >>>
> >>> @@ constant C; @@
> >>>
> >>> - msecs_to_jiffies(C * 1000)
> >>> + secs_to_jiffies(C)
> >>>
> >>> @@ constant C; @@
> >>>
> >>> - msecs_to_jiffies(C * MSEC_PER_SEC)
> >>> + secs_to_jiffies(C)
> >>>
> >>> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> >>> ---
> >>>   samples/livepatch/livepatch-callbacks-busymod.c |  2 +-
> >>>   samples/livepatch/livepatch-shadow-fix1.c       |  2 +-
> >>>   samples/livepatch/livepatch-shadow-mod.c        | 10 +++++-----
> >>>   3 files changed, 7 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/samples/livepatch/livepatch-callbacks-busymod.c b/samples/livepatch/livepatch-callbacks-busymod.c
> >>> index 378e2d40271a9717d09eff51d3d3612c679736fc..d0fd801a7c21b7d7939c29d83f9d993badcc9aba 100644
> >>> --- a/samples/livepatch/livepatch-callbacks-busymod.c
> >>> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
> >>> @@ -45,7 +45,7 @@ static int livepatch_callbacks_mod_init(void)
> >>>   {
> >>>          pr_info("%s\n", __func__);
> >>>          schedule_delayed_work(&work,
> >>> -               msecs_to_jiffies(1000 * 0));
> >>> +               secs_to_jiffies(0));
> >>
> >> Using secs_to_jiffies() is pointless, 0 is universal, should become
> >> schedule_delayed_work(&work, 0);
> > 
> > Yes, schedule_delayed_work(&work, 0) looks like the right solution.
> > 
> > Or even better, it seems that the delayed work might get replaced by
> > a normal workqueue work.
> > 
> > Anyway, I am working on a patchset which would remove this sample
> > module. There is no need to put much effort into the clean up
> > of this particular module. Do whatever is easiest for you.
> > 
> > Best Regards,
> > Petr
> 
> If we're removing the module, I'll drop it from the series. Just to
> clarify, do you mean to remove all of samples/livepatch/* or some
> particular file(s)?

To be precise, I am going to replace:

	samples/livepatch/livepatch-callbacks-demo.c
	samples/livepatch/livepatch-callbacks-mod.c
	samples/livepatch/livepatch-callbacks-busymod.c

with a completely different modules because I am reworking the
callbacks API.

All other sample modules are going to stay.

Feel free to remove livepatch-callbacks-busymod.c from the patchset.
But also feel free to keep it. The API rework goes slowly. I am not
sure if it would be ready for 6.14.

Best Regards,
Petr
