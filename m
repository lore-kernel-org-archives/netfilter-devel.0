Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIj4cIbC"
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16081B2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 14:23:52 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cf98ffc257so5146205ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Nov 2023 14:23:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700778232; x=1701383032; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rbdq96Zrn48atWSv6nAf1XPGpZpXUdsy/3hXy0zwOD4=;
        b=iIj4cIbCekyd+IWQgg5g6qRcdZCBrDGKOGdyIi3yME1SbagOPXB5JYF2RVkyoCAOVC
         rrmffHo2/BI+Yc2+Uhj7Y2yV86vK/kb8CEWnCQ52hNF2aPVApnP2vpifUA6e4G7XBc9n
         kMzRxLJILofKsI/Stoj/tsVhyxrOJEa2ckABE3QIhrKKWq7GYs+wkuNfu4GNI1IS+vRS
         ZBovAWsudMeqCTZh05TwAT8A0phnEzKbFqIDjsbv1aIzOIwcvCy33qtS4chiaolPImtE
         nxz+qazqNyHeSgFcJyovmP/VuAb9/LAPxkrEt3TSsEaMSc0ohDBG/4thLwD7Y2SpjvE1
         5idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700778232; x=1701383032;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rbdq96Zrn48atWSv6nAf1XPGpZpXUdsy/3hXy0zwOD4=;
        b=rOqI7U8UWttsro44PlHg/ERUQlYkgitD8Qilfcvm+kBapUk+k0c0i7K2fAlbJeQvH4
         3Mfdt28UOTQFVxMtkjz5klR5FYWOdfjOlVRaiMvelxalpSrvv6fNYycKC25QEU9nwGY5
         3aDFzljypRbbp97gqBIhHwD9FWdBQKz2kdna7yXlafUzg5WeFuObp8GUcYltvQrMF2ab
         QbnFcxWC5xN/a/YvCYjAe1QWpv+gp3JmDX2rUxYNirhPtdf4oc2flujetDXFvP6mjin1
         lzvCBQRifzYgfIcidO7rOiiUJKt+1kOGSJaxKGLGVrMt2C8isET3sgd6i8/vhcNOaTKx
         37gg==
X-Gm-Message-State: AOJu0YwUwzVGOp802qS0iyWGqO1nXayWsspW00pHYeD7lTXH9nJ5AH7Z
	TOxzenDgBBKsCFfrmhanPIAIGNX6NwQ=
X-Google-Smtp-Source: AGHT+IE7IqdzO+lS0J3g9ByuYH2VPx4oZqNYSqcVx/H3mCZrvntdY6FNqBsnhrya5Q8P4MFEHQ2Fug==
X-Received: by 2002:a17:903:230c:b0:1cc:3fc9:7d09 with SMTP id d12-20020a170903230c00b001cc3fc97d09mr963986plh.15.1700778232072;
        Thu, 23 Nov 2023 14:23:52 -0800 (PST)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id n14-20020a170902e54e00b001bc675068e2sm1850307plf.111.2023.11.23.14.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Nov 2023 14:23:51 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Fri, 24 Nov 2023 09:23:48 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v4 1/1] src: Add nfq_nlmsg_put2() -
 user specifies header flags
Message-ID: <ZV/Q9M43rMOHyz7s@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZVSkE1fzi68CN+uo@calendula>
 <20231115113011.6620-1-duncan_roe@optusnet.com.au>
 <ZVSuTwfVBEsCcthA@calendula>
 <ZVg5jArFjdXUuzPN@slk15.local.net>
 <ZVkdn0wPWdUwgP4U@calendula>
 <ZVvO4v45kMwbti2K@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVvO4v45kMwbti2K@slk15.local.net>

Hey Pablo,

Are you too busy to reply to my emails? There will be a lot more. Have you
thought of passing management of this libmnl-conversion project to another core
team member?

On Tue, Nov 21, 2023 at 08:25:54AM +1100, Duncan Roe wrote:
> Hi Pablo,
>
> On Sat, Nov 18, 2023 at 09:25:25PM +0100, Pablo Neira Ayuso wrote:
> > On Sat, Nov 18, 2023 at 03:11:56PM +1100, Duncan Roe wrote:
> > > Hi Pablo,
> > >
> > > Can we please sort out just what you want before I send nfq_nlmsg_put2 v4?
> > >
> > > And, where applicable, would you like the same changes made to nfq_nlmsg_put?
> >
> > Just send a v4 with the changes I request for this patch, then once
> > applied, you can follow up to update nfq_nlmsg_put() in a separated
> > patch to amend that description too.
> >
> > So, please, only one patch series at a time.
> >
> > > On Wed, Nov 15, 2023 at 12:41:03PM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > > > + * attempt to configure NFQA_CFG_F_SECCTX on a system not runnine SELinux.
> > > > > + * \n
> > > > > + * NLM_F_ACK instructs the kernel to send a message in response
> > > > > + * to a successful command.
> > > >
> > > > As I said above, this is not accurate.
> > > > > + * The kernel always sends a message in response to a failed command.
> > >
> > > I dispute that my description was inaccurate, but admit it could be clearer,
> > > maybe if I change the order and elaborate a bit.
> > > propose
> > >
> > > > > + * The kernel always sends a message in response to a failed command.
> > > > > + * NLM_F_ACK instructs the kernel to also send a message in response
> > > > > + * to a successful command.
> >
> > LGTM, however:
> >
> > > > > + * This ensures a following read() will not block.
> >
> > Remove this sentence, because the blocking behaviour you observe is
> > because !NLM_F_ACK and no failure means no message is sent, and if
> > your application is there to recv(), it will wait forever because
> > kernel will send nothing.

"it will wait forever" i.e. it will block.

I could send a v5 with this:
> + * Use NLM_F_ACK to ensure a kernel response for your application to read.

[...]

Cheers ... Duncan.
