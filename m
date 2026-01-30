Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B034E763
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 20:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769804617; cv=pass; b=dkXtym33fw8W/E13piMV9nYOwYhlst/M/rnvEmoUQderzXU46O+7D6JRt27NMAkLTLMDc5s9c8hp5xGfISgmIgeGTbrZXyJRntekuiV5fkj1sbZ4C/mW5wLoZ+Cn+SgvcUhHmSyO6uVdqTqbjpb8/H3qd77fxlY8zxUbBFDj0vs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769804617; c=relaxed/simple;
	bh=lCcMWU6ocUfOz04HROZ2VVNzKSBxxiz9KSgZZT4pP64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fKXBFxXaXCAYs2hhs9k8cLX79VsgvEecbwapcBoY4fulMQ3eNH0Gjdk3adCS16kb+B0DINtewrfRd/JwjoWZ9LvdU8fW+7qU6xc5IAbvYsq+XQBZ9Fhb8zEvhN9bcQXejyVEE/e9cFTTrcc9oMutZ4gtZ22hpesaK9Nbpn8wMjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hs21MMS+; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hs21MMS+"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-88a26ce6619so31509576d6.3
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Jan 2026 12:23:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769804615; cv=none;
        d=google.com; s=arc-20240605;
        b=jxdCLiash7V2cj/+UcjAGMLUqUBbksnijfIOFbSlf08s2ELBn0X02SAY7aDfdw/PLK
         dD0L3UKGSUEjrH3e8dyryGXwjUiRUy6vfnQAR0emB+eqF05Q5IcAXotebjhOiNtiMRTp
         FKuqD9d6SeNWgtTtokILzrgVorL+MO39w6mom3hwHxHRxgAQmSEuhlNnrv2kfZGVio8P
         jqnWTh7yl7jQc+lGXbJTK2B1TWUyopgB1Mq/WiSx/kIJl3gvanfSWMdp63OJTheTJAER
         z7MUmH6yjEivaC9WUK7EMjEBfDafKaQyFkypjt7sBHLUlhffL5k5uY51o1Xz4iRonZyY
         XHLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EHAWuXPjXFbXWMFCvQxp8QIuB5dPbTxYBgl3Qg+Prx0=;
        fh=bu4kEUE77R8bAuDJ45TrcB99GFfno4G7ak1GxEeyVAo=;
        b=RD8/GDRcbQQe6bZtj0U0JlncnJFnnaygC2tnRegQ7qCzDsZTIGrDfJXNtrn5LTu1/D
         Q9rp28tk3YBOH3gv2AI+/K2XSwPTK+u4Ct5SiQMw1A07QY+kbWJIBn85xicIKWPwAxUf
         N4ShmCODKCg7ownpIfZp+uAWHcFmC6cSUYqfSsK2MMfqkPXaOq2jRNJZpuKj0pej0MjB
         BVfRStdIUpabczbMmxYQcKdTuBYF3eFGg34RapuV7bKb5qNh2rpUquo30L0ISY2sGTqH
         mxHxWJGl45QsjaFFO6BtsZxnLS/q+4d84H6aGtOELPfghfHOtK4EOnVdzFxLzsZPLnqo
         +u3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769804615; x=1770409415; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHAWuXPjXFbXWMFCvQxp8QIuB5dPbTxYBgl3Qg+Prx0=;
        b=Hs21MMS+aP2rzrNGyxWBCo31avKrL59Y2mN8clIC9aDqNw5jvh6nxNQof/o2ky3F+P
         3O2Ap6YBL6UPOIfk8YbEGgcjUfDDPZH6ko82rKZcKouEpipNnABgGC5fATI98w0pS7P9
         07HHWjAZTVtGRZ2EySSYtibSK5FztS22mnmURxaZ8rBL5/CHe44dlXqeKpevMaT0HrvF
         Wbgg7eZStspOOgDMgHy0NWpn0J1saNGBDdwmnAsyrG51n9eh6BwbR0usFO+LJrfkO2C6
         KqeNyiofTnBoae1pbf+jxOyNpV2Nq+XSXNu0GY3HPMpUkHApywcgWYn/du8CymubJZLe
         JaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769804615; x=1770409415;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EHAWuXPjXFbXWMFCvQxp8QIuB5dPbTxYBgl3Qg+Prx0=;
        b=m7NxzVk9ZeeVFbyYHXCiN9GnzNrTI5yEQSEB5PuYcCIZvOVY9wOb6eTvbZMWFfOB+C
         HVy4gxqASYmDS5WYE0q9gPuH0Z2dREhwU4rxuXkWuzTODpuCbGIWdXP3fjML/rgWQuj8
         QyF718Z5aX5K/ISe7K+i7ealzbjLPTjjA26gYW5e7Np0tm3ZRApKGpeB6VTqoi2d97N4
         Dzra8Lx4C5MqHmD0Ki/YCSkFqo8xVM9v4X4ES3b0OaNe3JEomuy9jFQXcj5pYvOIUbFp
         ZmDbQU9XOEv8buKdiWAqL4kk7ioVJwJRCVPQrVYn3Fdw/Gte/ImDOqVXsPFD+9tmPfbq
         rEdw==
X-Forwarded-Encrypted: i=1; AJvYcCWF3I3GYqfIGWW2IM+MESoRuZ4mCHY3yHJy4Lm/oRXtU/SWiQo7eqWUaHOvGI2Xq091iTu2tcSUoKJs1fHkUIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiEqEUuf2jSIcOlFFaosRsK/c9sJBSUghEihIifW6VehdRnNS8
	33WCbKuaQH7woCNkaX+YqlilxL1Zz78tEHLxVYEQv6BY+hMjcKrswzI1pla5mw/+s5glqOCxTrE
	8NRcm1FJ1HFzdjY/tl0Zo06hvl3y0ejfY0rsdoOTp
X-Gm-Gg: AZuq6aKmeHFZM8wKskj6qYdL43/J/weVuT5F+22VYcPYFUm9StgidDupyUSGqoE7R5Y
	ART+0XWQyJrw9HR3G1khFvOzSucmY6DXBv5I3VhSvhvUEP1+m2k6r+cQlj0jMYN5TKoqNKeVCkn
	9tbok0qn//0iOj5C9Hw0UL5V/VAw9RTncMT0/6A7B1vqhUFqlLrlu2zs4E94xyAmLL98wNcfuN7
	8iup8xGvmbhsbbNHj0YfXJHDb+s40/Gxlmw8mViMXvu1ZwlxLHGgbvjtboJ/BTZNPjJnPs=
X-Received: by 2002:a05:6214:401b:b0:894:78e4:27d1 with SMTP id
 6a1803df08f44-894ea1792b3mr66148016d6.68.1769804614835; Fri, 30 Jan 2026
 12:23:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129105427.12494-1-fw@strlen.de> <20260130081245.6cacdde2@kernel.org>
 <aX0B1xaFGL43xxUn@strlen.de>
In-Reply-To: <aX0B1xaFGL43xxUn@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 30 Jan 2026 21:23:23 +0100
X-Gm-Features: AZwV_QgqAFMVwmSqA2GrImjNKRZiJIHf6kLxIgXO_d7ss3jbAHFtbwaIY0HOCuE
Message-ID: <CANn89iKUV07+84PVq0cHe3vMaSGNTQzhq9=xetg+_P2DmsPmQQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/7] netfilter: updates for net-next
To: Florian Westphal <fw@strlen.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, netfilter-devel@vger.kernel.org, 
	pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 30, 2026 at 8:09=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 29 Jan 2026 11:54:20 +0100 Florian Westphal wrote:
> > > v2: discard buggy nfqueue patch, no other changes.
> > >
> > > The following patchset contains Netfilter updates for *net-next*:
> > >
> > > Patches 1 to 4 add IP6IP6 tunneling acceleration to the flowtable
> > > infrastructure.  Patch 5 extends test coverage for this.
> > > From Lorenzo Bianconi.
> > >
> > > Patch 6 removes a duplicated helper from xt_time extension, we can
> > > use an existing helper for this, from Jinjie Ruan.
> > >
> > > Patch 7 adds an rhashtable to nfnetink_queue to speed up out-of-order
> > > verdict processing.  Before this list walk was required due to in-ord=
er
> > > design assumption.
> >
> > Hi Florian, some more KASAN today:
> >
> > https://netdev-ctrl.bots.linux.dev/logs/vmksft/nf-dbg/results/496421/vm=
-crash-thr0-0
>
> > [ 1144.170509][   T12] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [ 1144.170759][   T12] BUG: KASAN: slab-use-after-free in idr_for_each+=
0x1c1/0x1f0
> > [ 1144.170922][   T12] Read of size 8 at addr ff11000012a16a70 by task =
kworker/u16:0/12
> > [ 1144.171079][   T12]
> > [ 1144.171133][   T12] CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not ta=
inted 6.19.0-rc7-virtme #1 PREEMPT(full)
> > [ 1144.171137][   T12] Hardware name: Bochs Bochs, BIOS Bochs 01/01/201=
1
> > [ 1144.171139][   T12] Workqueue: netns cleanup_net
> > [ 1144.171145][   T12] Call Trace:
> > [ 1144.171147][   T12]  <TASK>
> > [ 1144.171149][   T12]  dump_stack_lvl+0x6f/0xa0
> > [ 1144.171154][   T12]  print_address_description.constprop.0+0x6e/0x30=
0
> > [ 1144.171159][   T12]  print_report+0xfc/0x1fb
> > [ 1144.171161][   T12]  ? idr_for_each+0x1c1/0x1f0
> > [ 1144.171163][   T12]  ? __virt_addr_valid+0x1da/0x430
> > [ 1144.171167][   T12]  ? idr_for_each+0x1c1/0x1f0
> > [ 1144.171168][   T12]  kasan_report+0xe8/0x120
>
> Sigh.  Doesn't ring a bell, I will have a look.

Could this be related to "netns: optimize netns cleaning by batching
unhash_nsid calls" ?
