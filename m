Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1227633985
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 20:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742416939; cv=none; b=pC2iVgySIZ9vktYwWzKjOPBU3BK1LS8CH9uVnhwk96reV9Zj1lu25WQeN26qT9YWFLQFLxkZkNoeQ+/UeK/p+c/rEX+Bnln2MahCSigXpGHnnlY1wrUy8a5U+t9EdFUbUnCnKpf19ReipG0hDA8LOLIyM9p6SzCvlkirzyW2j7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742416939; c=relaxed/simple;
	bh=DyWabLCHW7ECqj4VMrxFQ1Z4JmYo130gVPgezunVmKY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQqSvlpTQEcGd3Aoub6qz8fj+JDbLMJrjfD5rllI4+/RHzJikJOhf2UI7PErRPgC5olWmcg3w12ktS75J63rmAWQa/qh72q9KHnyRKxVq/3Euwt5g8D0/Z6DwqYy7GEmI1abXWUBw0MAYqSCwZcwcdyOQwORdP61p3XEGbVFBzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMXXS6TW; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMXXS6TW"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-22622ddcc35so37379795ad.2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Mar 2025 13:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742416936; x=1743021736; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j4IsSoDf0H5mgSBjipLDaP6yBjw/ZFjNwantAaT3zP4=;
        b=iMXXS6TWgNNgvWV2+DFt3QzultEuJwPStVPRz/yDktX/C7jIvVgVmkZYWOhlWhiK1a
         ImWWPmGw3FHW1LIoTFT5no4HAL4IRkJPiliSdKTYxzdeyIFtvQ/YzxXuERjX6Or/rGy4
         LxeF43Ecpo8/cs8murNzg/6blOhJlorDoVTxGmbjO73h1UcEIlwl4vsi6ZrIwUQEhBgW
         55kTFqsA90+GqUau99A6SzesQDlxqrWJpwETQdvptnnKBzrkEsNRM62O5NwHH0RvMZ6o
         Z/qiefkoi5noSYSgcKvqfmfSzUx8/Gq+U4Xnxtcoo1kplMhu+ngE+iRG6wpxcT/LbldT
         e3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742416936; x=1743021736;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4IsSoDf0H5mgSBjipLDaP6yBjw/ZFjNwantAaT3zP4=;
        b=e8WTSsMacsppz0CIE924tL9JeItl9bekLGdHP3w5dRUmqZkS5ngACnxxhiFNnnzuXy
         GAeLHj5+Zht/6a5su9HI0pEwtannGKbje7k2gsnjjYvnTvuzCYQ8UDnLTC6BIsFZVD63
         dw2B7+yPijbH5QZsyHAB2wAGjjqyOqL7gUT50vXLyeMX4TgGoY3iXOoIUndaaNQV3w+U
         FCs3rNPUxLR7n6HUQFjZK+cpk/PYwNbLJlw7HBneb2GtvaeXfN5kaeN7KyGwCo74fVWO
         Dr/ndignf/HuiD4nhgOZ+iBtkweTnCUdM7gpEnyEz6v+/KlKjynljwFnXy1j2odyBsdF
         kjKQ==
X-Gm-Message-State: AOJu0YwpRVX9TrZEXicZPvGu1mKCHNybgLrvbnBWkhiBSzG+l4BjKfuc
	MHl4oJlZvCY8M+d/bvlSngpZSI/pC2QaRdd9j7Pu7VgMmm+Xi7xat8X1wQ==
X-Gm-Gg: ASbGncuICM9jChfu+Qb4Cl7vuI0jQISBzdc/qDp4RXIoixyj3lhXy6dkeslNpMvxPaZ
	bt3srg1lJtXS6slQQiCo4CZGm0mYB8b1OJd2//eyignSPvfICflXDh+mLiIvorN7idagvc7i6gD
	CRxhLYNcSogZFxxdrr+1Yt7b1diWyDbwVB3Fy6Dl2K/Di1Nz6AkqiIBHabx/xfxHV2oRlyxuy2p
	0XO4BsFWUmLM1osufNut8+XZxgPwQ8c4j/pBCQKsyK2DaEXXaFL4RnVh4Uu0eShbQk3IHky2vUQ
	PFOE3CND3LnnGZWtyjuN7LLAhwCV++XGwCLYcpkRh7tFDAci/bnMKwBkgrhb6M7fN8kbjPIW9JA
	XV+5LRSUi6EaGjtndC9B9HA==
X-Google-Smtp-Source: AGHT+IEWPRedNfI4lYQbRuPSjPGNRdO4E9klaVUkkfr3VjAzGBh+A1/7u11u5V0f4vKv2EBPm48EGA==
X-Received: by 2002:a17:902:c94e:b0:215:94eb:adb6 with SMTP id d9443c01a7336-22649a80a38mr63483205ad.40.1742416936174;
        Wed, 19 Mar 2025 13:42:16 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711578d15sm12162570b3a.82.2025.03.19.13.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 13:42:15 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Thu, 20 Mar 2025 07:42:12 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] src: doc: Re-order gcc args so
 nf-queue.c compiles on Debian systems
Message-ID: <Z9ssJMKDJDetdYV2@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20250319005605.18379-1-duncan_roe@optusnet.com.au>
 <Z9qOVEObhFzmVKx6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9qOVEObhFzmVKx6@calendula>

Hi Pablo,

On Wed, Mar 19, 2025 at 10:28:52AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 19, 2025 at 11:56:05AM +1100, Duncan Roe wrote:
> > Change the order of gcc arguments following the discussion starting at
> > https://www.spinics.net/lists/netfilter-devel/msg90612.html.
> > While being about it, update the obsolete -ggdb debug option to -gdwarf-4.
> >
> > Reported-by: "G.W. Haywood" <ged@jubileegroup.co.uk>
> > Fixes: f0eb6a9c15a5 ("src: doc: Update the Main Page to be nft-focussed")
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> > ---
> >  src/libnetfilter_queue.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/src/libnetfilter_queue.c b/src/libnetfilter_queue.c
> > index f152efb..99799c0 100644
> > --- a/src/libnetfilter_queue.c
> > +++ b/src/libnetfilter_queue.c
> > @@ -86,7 +86,7 @@
> >   * nf-queue.c source file.
> >   * Simple compile line:
> >   * \verbatim
> > -gcc -g3 -ggdb -Wall -lmnl -lnetfilter_queue -o nf-queue nf-queue.c
> > +gcc -g3 -gdwarf-4 -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl
>
> I am going t remove -g3 and -gdwarf-4, so it ends up with:
>
> gcc -Wall nf-queue.c -o nf-queue -lnetfilter_queue -lmnl

That makes nonsense of the previous line:

| you should start by reading (or, if feasible, compiling and stepping through with gdb) nf-queue.c

You can only step through nf-queue.c if you compile with the debug options.

Please leave them there.

Cheers ... Duncan.
