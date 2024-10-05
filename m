Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298B51798C;
	Sat,  5 Oct 2024 18:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728152582; cv=none; b=d8vTS8MOOXokS18nOahTJu/7mbE1iSIMqDB9RW0feLvY4LrzUJKZJkhA7ldvinc24EUXTnRGRm5nk2rRQ7xhTxKcQo6tu4tU+QNGavf1pS/2wsnJN0srxr4+8rlL4QMt3P7nDsPsXrb5SF0JBcV5vhKnGPAIad/Yia2m3RJwcU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728152582; c=relaxed/simple;
	bh=2vC7ZGx6N4XTlI98Fc4pDJ4we1lj8z+fyLZnvj/jHKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EDvbeiwntsIoeuKrR0lYxKbHnUnzbekoko9ULXrN2LkQbkt5sj9pjB+rhJ2TMFyScBkdcU7csB6GO6CK1b/rPW+wa/acog2ySgAFR6LD+8qx56u5RUg7s7tjlJVOMHZKz5WzY3r3cCq5vM6HeOfq8J5wLx4bvV7dSddhCHXMW4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYgexb6c; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYgexb6c"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c8af23a4fcso3762966a12.0;
        Sat, 05 Oct 2024 11:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728152579; x=1728757379; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Fg2B5McyqQ1FvD0AsheeXltyP/0qxdRQE36MLXD3lfs=;
        b=PYgexb6cS0w0gRYfCzx6cA0kjTKYGpEFp5z60M1wqCDUc5KAPQlp/QT+Bz4qsc/A+U
         iG8ToRz4IVICUIWdb5Bjv9dZhUlLUKtfUZEIFn+gKJ8vAbKS+iRYEkzBpPMf7SqcuAXb
         pgocRjqy/X4Aoro2bIwIwjG+8YAe6wFYSfdTijporA9escyLYcd+KgGBY2fRYGupAKd3
         yxwq0ROrgTnyXjWz1lt6rNJNGW8WmRbxRA4y6YyZF0qL6LbzEn1vmcLTIGnNJ1fkS4BK
         4+V97jjOC9GVAfY7T98xweYDNlGa6dIqkZceriC/TZ3+MvXssjEBc7OIg52PeNdzHXM9
         KRKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728152579; x=1728757379;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fg2B5McyqQ1FvD0AsheeXltyP/0qxdRQE36MLXD3lfs=;
        b=KraAmFgsQFA9RSetNF8A5nQ4Q01nejmquYJOQ64Rn1DNsaD3RCgqxuS/sK47WMsQRE
         mwD1suTZBE9WjkEJ0wsMsuhpolEQqy54SH1BD6WcHBUJaXD5J0ET5OuMfVT/bWpiwNk1
         /KPR4xRzlk8PyBP3HydLPdUhf+PwdMSvX3+C+Mt3k6DT1RRElB1PbjXmXQ3pOb2j70Gf
         FGVyDm+V11Qj3MpadydZkx4vkAZNWaYOAzBbAvKt9rf5ByOcn5NoohspW7B63/7PTASh
         5Y8/2i+9P8+gq9+y6xu6vdCstn+k4tVJd0jioCajQz19HjqfcLjkJz8OVdsn117WNTzE
         v5VA==
X-Forwarded-Encrypted: i=1; AJvYcCUEPOJDplTZs656cA5/W5e+pyrLfWHglELDqLdIM5qFTn7B55R4OzrjpzQbsbjh+qOdgTIOa3SwYGJ4GSAvhqza@vger.kernel.org, AJvYcCUKbZ50n/yMCl7A1xXzjBXTEFVRS9z0RHEfbo3WqzWu5yFdJadKFSPb4wjnHsYLn7tRI2n/jn6v@vger.kernel.org, AJvYcCVRtuT8P0j7Ael3o7q5bZE9hvrfuh4mAodS0SAp2f89fj/jnsjDFdhTx0I4mT9o1q8VB5nWVXpMLJWiyg3+wiheib4PXzE=@vger.kernel.org
X-Gm-Message-State: AOJu0YydTg9fGPKq2NfDifXthMaj7FRoJ5Y8gNF4JrALfxMRM4NWCgVl
	vQh1beQtSGDs8Xp+EWmU96mEgMHIO/etJg5D7Sz2HiY/tWj6kPPk
X-Google-Smtp-Source: AGHT+IEbHEnpL+z00inE3UhZTdLEnCAOL3r3r6w2MDp27aZmerm+HYqUtVcDnQIBbt5MnEAUB/Ho+A==
X-Received: by 2002:a17:906:c10f:b0:a99:4162:4e42 with SMTP id a640c23a62f3a-a994162606bmr167179366b.37.1728152579060;
        Sat, 05 Oct 2024 11:22:59 -0700 (PDT)
Received: from localhost ([2a02:168:59f0:1:b0ab:dd5e:5c82:86b0])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a993fd777e6sm85186766b.79.2024.10.05.11.22.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2024 11:22:58 -0700 (PDT)
Date: Sat, 5 Oct 2024 20:22:54 +0200
From: =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
Cc: mic@digikod.net, willemdebruijn.kernel@gmail.com,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, yusongping@huawei.com,
	artem.kuzin@huawei.com, konstantin.meskhidze@huawei.com
Subject: Re: [RFC PATCH v2 2/9] landlock: Support TCP listen access-control
Message-ID: <20241005.e820f4fae74e@gnoack.org>
References: <20240814030151.2380280-1-ivanov.mikhail1@huawei-partners.com>
 <20240814030151.2380280-3-ivanov.mikhail1@huawei-partners.com>
 <20241005.bd6123d170b4@gnoack.org>
 <47ff2457-59e2-b08e-0bb4-5d7c70be2ad1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47ff2457-59e2-b08e-0bb4-5d7c70be2ad1@huawei-partners.com>

On Sat, Oct 05, 2024 at 08:53:55PM +0300, Mikhail Ivanov wrote:
> On 10/5/2024 7:56 PM, Günther Noack wrote:
> > On Wed, Aug 14, 2024 at 11:01:44AM +0800, Mikhail Ivanov wrote:
> > > +	port = htons(inet_sk(sk)->inet_num);
> > > +	release_sock(sk);
> > > +	return check_access_socket(dom, port, LANDLOCK_ACCESS_NET_LISTEN_TCP);
> > 
> > Nit: The last two lines could just be
> > 
> >    err = check_access_socket(...);
> > 
> > and then you would only need the release_sock(sk) call in one place.
> > (And maybe rename the goto label accordingly.)
> This split was done in order to not hold socket lock while doing some
> Landlock-specific logic. It might be identical in performance to
> your suggestion, but I thought that (1) security module should have as
> little impact on network stack as possible and (2) it is more
> clear that locking is performed only for a few socket state checks which
> are not related to the access control.
> 
> I'll add this explanation with a comment if you agree that everything is
> correct.


IMHO, when you grab a lock in this function, it is clear that you'd
unconditionally want to release it before you return from the
function, and that in C, the normal way to guarantee unconditional
cleanup work would be to apply the "single exit point" rule.

That being said, the scenario is simple enough here that it's not a
big issue in my eyes.  It was more of a minor nit about having more
than one place where the lock has to be released.  Either way is fine
(and also should not require excessive comments :)).

> > > +
> > > +release_nocheck:
> > > +	release_sock(sk);
> > > +	return err;
> > > +}

–Günther
