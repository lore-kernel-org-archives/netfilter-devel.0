Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB4879C4
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 01:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741571363; cv=none; b=mveiCT96Ml8iBg5Cb0gMYaHbnk+6F+guXfSQ2aKe2WvnKrjgyqF8POj1HliMXIQ558IbtfRiHTrzCOWgUBEcZ1KyrOwBQ4MvR6ZRPOyGJ8zeig1OYtrdXU4uSmsLWha1M3gExV1/9a8iFxR+t/tt55xsA84by9TlJ92Ij/L254w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741571363; c=relaxed/simple;
	bh=JLJTNwcDwD02w9U8RtyfYilnyW+/ohBpG+XOvIL0R8k=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYDcWpYjgmJ5DVD28wPZbT2UOyayl68A7+i6qTLsGxJkcby/Q+5isuR9Q2HJV9mABargQmxYXryXPmo3USBzmZCjUUFFTo/6OMoN7v7sOtPTgBdkqE7UrEKI9BVKcTTP4tvwFwz06ATtixIMrpoIGn8BcVjyn8Hj+rC91r1FDK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8YWqiER; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8YWqiER"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-223f4c06e9fso60481695ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Mar 2025 18:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741571360; x=1742176160; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjqxQxe1FyXRHxVxpUi4QlsQydWyqZrkC/Fh6NLA6i4=;
        b=l8YWqiERAHvfFkgR8EHJEZfzH/OtbKN7W2iR4dcWtNOcMOwUbViwv+hFyaY9sNgIk0
         wY9ROhe04jiuucPTMz34cTDRPMWqvrPZQ0ZQtZO0s7v49qZH4drRx6HYOwBiWKR6BJJu
         /wFnYLmof5CaYB254mSKuatPHVFdE2e+CAPKCoGCv3fMp19FQPBs6Q2m9At2db4RIgNM
         9IAxUyCQUHCvhND0r1gQeZ9rKqxUsOOjJdO4hLeWs1BOoxkHYNi24/FYQ7gwD4uwtAhs
         VKbXTOc2PvYCXPmqd0d5cFgwVb+yh4sc9q3N0KDm1RmcaQZKCcb3KhU9zPjsgejGUQnc
         5UKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741571360; x=1742176160;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjqxQxe1FyXRHxVxpUi4QlsQydWyqZrkC/Fh6NLA6i4=;
        b=l1t5a6v2yxj4JfrIdFzJU/ZjA4njhp0BpBZ+NibmS/+DIQ1QChST5VzJCWDJq/VGA4
         R6RSy4ZQO6+y2cYFux3UDENax5BtyylzJqNwvHu2NmbfD2yF9PO2PBIRirMBraBV52nZ
         ADRzKN4SZKpXmXuFKH8OC8622Om50pMwSlUtTtYoyHeCQyY8fxa3LPUr17A97VEyCqBA
         /XJhlvbx+2k9GFcIwWvIoV4MH05/Xf68wWW5McI2IFLFlVjI0apEiQWFIOteze5oDipu
         HUB1m9aoos5I6GnFJRAYd81dI8kzDqHzWeTI3+cHreYkEzz7/tm6vpRj8U/TPPQrGfOk
         5OZQ==
X-Gm-Message-State: AOJu0Yzw1O7wEdJHqlBmIT6OGHyYwH9c9sR9Jym1gE7ZcO4o0mL0kxPY
	RdVLzAWvVPBZgKqo01GvFI4BgXC4k+qdXLwAtd5q2U3Fa6LqVi1BjUz1FQ==
X-Gm-Gg: ASbGnctRoPE5SjaKnEomRmCjBoY9+S9Y4WWWfY/zVhXTbqtD+SLLWaLfhTTSRT9hzDj
	Bykfy24WT14YlYH9pP0HxsiIS8llWM6W+1E8SjHUvaK/rngF/CWekC0kMOnnKSm/fjlIUNJuF9N
	c8908o5tAtLRcV0B/eigPyEygNrVmvtLyuXItsIVBznUZ7bfQK2CPRzW9taf4PNfSah2X7Rf2vJ
	fCIEDp5BT0HBKusxiuzeLBnwtTlDzMBh35GVMEDdXV6pKD7mtn4pzaJPs0AiDN5QmmamB8oGChI
	C8kRXfEZuuEFjhYcyqMltOu2CvvkwMAupIaCNJcty8LetECrDeH3RsOvTXTbT8Onl+FGkhxQaKE
	BIY7Ah5O0aRtWhJVsrmt9FQ==
X-Google-Smtp-Source: AGHT+IFvCngrNgYOkmAg/hEYCpzc2bdyLMlN75MiKNbSI4353uWnicGalGfkEQM/u1/akXAramxykQ==
X-Received: by 2002:a17:902:ce09:b0:21f:2e:4e4e with SMTP id d9443c01a7336-2244f057fd4mr133845665ad.5.1741571360113;
        Sun, 09 Mar 2025 18:49:20 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22410a91babsm65773305ad.196.2025.03.09.18.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 18:49:19 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 10 Mar 2025 12:49:15 +1100
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_log] autoconf: don't curl build script
Message-ID: <Z85FG/1qImu3tiSS@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Florian Westphal <fw@strlen.de>,
	Netfilter Development <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20250309105529.42132-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250309105529.42132-1-fw@strlen.de>

Hi Florian,

On Sun, Mar 09, 2025 at 11:55:19AM +0100, Florian Westphal wrote:
> This is a bad idea; cloning repo followed by "./autogen.sh" brings
> repository into a changed state.
>
> Partial revert of 74576db959cb
> ("build: doc: `make` generates requested documentation")
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  autogen.sh | 8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/autogen.sh b/autogen.sh
> index 93e2a23135d4..5e1344a85402 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -1,12 +1,4 @@
>  #!/bin/sh -e
>
> -BUILD_MAN=doxygen/build_man.sh
> -
> -# Allow to override build_man.sh url for local testing
> -# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
> -curl ${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}/$BUILD_MAN\
> -  -o$BUILD_MAN
> -chmod a+x $BUILD_MAN
> -
>  autoreconf -fi
>  rm -Rf autom4te.cache
> --
> 2.48.1
>
>
| This is a bad idea; cloning repo followed by "./autogen.sh" brings
| repository into a changed state.

Agree with the above, except IMHO the "bad idea" is to have a frozen version of
build_man.sh in the repository at all.

Pablo did that - I didn't like to quibble at the time but I thought no good
would come of it.

I've sent in an alternative patch to remove build_man.sh from the repo and add
it to .gitignore.

With this patch git clone followed by "./autogen.sh" behaves as it should.

Cheers ... Duncan.
