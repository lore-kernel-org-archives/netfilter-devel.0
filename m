Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30B0125BA
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Oct 2024 08:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728288920; cv=none; b=ZeFuH2OrCYi2Pf/N9YtMj5BdZmG0S+CwtAlYd7K/vBTG1882tsm+pYMJL5DfqvcKlUzKGJvowIFA8AN3pNcGx8kCWpY4qy9bYLa3Wc/2xtRg9MadUintdVMrvsi9KxsMpx9Uxp9GkDK2m/k3NoTKLsLt5n7BdPKLeQGLkVllW5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728288920; c=relaxed/simple;
	bh=ddhHkupr2XpdYYrGa2ShFkqZ0LvC0gj0zvB/EqKAy+E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cbleRJVrQLToulNkXjJH6Kr/I0Bp0ksxmySAm8zK0eL3QiP4ZtGXFcInOdAqV/Nn/tJqPuLaE3sIy1sFBRzlD6H7zvuPyxIreR4dgx8zo3SkMff5knoDPbt/D7PJgmZS6GPnoOYJM/epclBZijHmOFAIagVyHR/t1TWu7lrTlF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VyaFJ613; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VyaFJ613"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a0c9ff90b1so13729215ab.0
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Oct 2024 01:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728288918; x=1728893718; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ddhHkupr2XpdYYrGa2ShFkqZ0LvC0gj0zvB/EqKAy+E=;
        b=VyaFJ613m0qL7/uV9UKVWiNwD7oMJkSjwSkgBdGsTL/U3opz/JvhWMOgvlmWi8Ilyr
         MyF7Jpc+d7ZuVwmZngkh9pRXj5GvRcWgjVNIffV0vzLKt2AsBRyEOcmDlHfHxxblyDxr
         y176BOJFmNzYjfZ9q9wp3KJzWttZHJu4JADTHuMWC+3Z/Vx6py/PXl5Wfhj4Wwn5k+iX
         OF8R2o/DrGJvrEyoOyCAKHv5nh6n81eBkDufgO0u/eaZ7j3N3fIdtXYeqdJleRFlHP3D
         tpo1Qwo3EmV+ZO7MX3ZnvLKy7ivmQdBDirbtIbrKCMXaLV9xthyeX0xwWsQ3UoSD95BU
         YuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728288918; x=1728893718;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ddhHkupr2XpdYYrGa2ShFkqZ0LvC0gj0zvB/EqKAy+E=;
        b=QQz6UdRexr202zo9pgI43EMzMHkuikYF2Z92Leh5Ru+/kiYBd7PdCnxSASWqF1I50h
         Y9oejUYNd0LA0PUM3GzT8G9dRsRXiEAD4dAD1cfwbF2d2TTZfMfTDAwB6PEbV8XP6MH9
         hMgi/KqPKKG8T8z+9RENZRYhr+ZGe5EGcuioaEtfrZg3uYfzDGIqm0KouyGCOSdR2M+C
         gl1GbzLyTarozk0wfrZY8gOe8r75qO5bJDCBJJ0jkQ8ZFN1IWAXFyHsq0EvWO0qNDgqz
         pSbSecf8KgXBtti52JDUwrhB0jp9B5CWECisHplj5UxUY0/uwcSi+FY5ACSCeoecZiYI
         2dIg==
X-Gm-Message-State: AOJu0YwqT+w7ok3w7AFUM0/GBc8waY+iXgcyFUIsAJcBm2JxI/mYcEiI
	liPQIY8dbolGVSDg7uK4gLCiJyWYumgx9LUTztZ2JpoQ8WejNwuW/aaXk3B7+PdCS6/HjcSnQyo
	ry9K5TT99F8OT0IVhelm1CPK5kdUgM0eo2Mg=
X-Google-Smtp-Source: AGHT+IGf78gkgz1dI4tmS1tVlsl7JiSWCog/j0AyY+qoh3H5LA+ku8v1g85dvg7QrBmsGFUF7tmaLIDBlLq2XVteN1U=
X-Received: by 2002:a05:6e02:19ce:b0:3a2:7592:2c5 with SMTP id
 e9e14a558f8ab-3a375baffe0mr87736575ab.17.1728288917785; Mon, 07 Oct 2024
 01:15:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912185832.11962-1-pablo@netfilter.org> <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
 <Zus9trdyfiTNk2NI@calendula> <CABhP=tbVrpr1MuYSubw4LKUNP=_PFap3CN9bc3M_mzo6yxeqpw@mail.gmail.com>
 <ZuwSwAqKgCB2a51-@calendula> <CABhP=tbA+m+xnDp8kQUMZE61zNwLekdnzP_5HJB7gaPzvC1OFg@mail.gmail.com>
In-Reply-To: <CABhP=tbA+m+xnDp8kQUMZE61zNwLekdnzP_5HJB7gaPzvC1OFg@mail.gmail.com>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Mon, 7 Oct 2024 09:14:41 +0100
Message-ID: <CABhP=tYLGfwmAvfU=d78trfxFqgfC05mFEkz=xOv9a8VUkfNDQ@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets
 from postrouting
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 6 Oct 2024 at 15:44, Antonio Ojea <antonio.ojea.garcia@gmail.com> wrote:
>
> >
> > It could be different scenario. I was expecting consistency in UDP packet
> > distribution is a requirement, but I understood goal at this stage is
> > to ensure packets are not dropped while dealing with clash resolution.
> >
> > I have applied Florian's patch to nf.git, thanks.
>
> Is there a workaround I can apply in the meantime? kernels fixes take
> a long time to be on users' distros and I have continuous reports
> about this problem.
>
> I was thinking that I can track the tuples in userspace and hold the
> duplicate for some time, but I'm not sure this will completely solve
> the problem and I want to consider this as a last resort.
> Is there any feature in nftables that can help? any ideas/suggestions
> I can explore?

answering myself and for reference in case someone hits the same
problem, I just special cased the DNS traffic to be processed only in
the PREROUTING hook after DNAT and skip it in POSTROUTING, this does
not seem to trigger the race problem.
