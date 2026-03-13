Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F833E3162
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 22:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773442552; cv=pass; b=nZM15KhPVMxcJheNBtW/zgoMSc9qHbl7h1qyc7HEQ8DFgaOHgFOPjLB4PQ4A5I0G84wpjr63RaYkINSi2jRVsCgbHMzDKlRJJ0Boyo+037Bp7RQB4/s9fgpbLwS2itPQ5TOI2CQ0VzbZmg7F1xb7bqS0wegS+O0wyNRG9qGkZRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773442552; c=relaxed/simple;
	bh=1Ty0xY5cZA829vovRzYzuYeyQoqsHZ6EMyQIZz33Oxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SUxaMbCuAjGB3RZIzWdLyEymTsUnhp4nZ0ewiUtXggGU6Vnv3vaIYzB3dAA+i//+C3YvOXvTFbNUY3E8SYVDhxoTG3v4H9Gpgyv/u2nCcYSRsV80Migf1mtNc+cwnSgNBPQnBg508HVxvoquryjFcxCtdlbTOpC/ZK8cZeicqWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com; spf=pass smtp.mailfrom=arista.com; dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b=LvQ7+Aoj; arc=pass smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=arista.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arista.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arista.com header.i=@arista.com header.b="LvQ7+Aoj"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59e5aa4ca41so2409195e87.2
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 15:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773442549; cv=none;
        d=google.com; s=arc-20240605;
        b=cB25uEX02GdFXWEdrVqPATDOlKznQGMfR2p223ReHYxVlR/TI1Uctk5dEiVMYn0IzP
         E3zMRcenc901+uaHL/X6uw4hzfHGzxWyF1O37yXWa+3bmDe/ykdstcbUyBRQ9QPoIyjr
         DBx8YeDY+WHPWodKkT82/LOSAMa8RCS4RLwrNf64I/4Af515JZQP5NMBrEuiT4LPFPAJ
         Tsxnqd5Lr412uMP7NEUaO2kHI6i8VNLWFj45ChcUmZxTYpdbdgNNh4FxYVDeiTaPon5h
         xJDnnfnzcnRLUI4KdBcZmo8lYUctDfz4KOMpXFkBIzfPZhdkzLQgX3HhMArTn5zEqgV5
         bm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W3QNx1W8EImhWG5G2h7xr/vJQj2kmarfg6d7Z6ksV9w=;
        fh=8bppaUUFf8s6PJ+nouSnppNlIzqU0D2Y37UyDA+stGo=;
        b=exGOLY0lX7FKaWsv9xLi9IMJKXe5g9D7zHbid3lug3cSV3qHv64FxPZxXev/SdpLe5
         1D0LLEZ/BFERZxz5mRroHr65XdX7XoKVvnUQS4l3FotnUELiEkii7bKbELlNvMVwmGW4
         SGpWXapENn5tIITt5GTWogi7Ene5JDsW3HxahsGyCkQlnYtAkFbHC2cNOwqWKSz2ZlJF
         JvH3M2cBcMEvKDqu0SF0if7/IJbdMEPD1K+aX3GNXjZN8ZcmMqE+7be08iCg8hFkHBsJ
         j0DUmpVtBC1BSCf56xK8UI2YsaW9dnSpkrsTKHSYAb9OQfpvdN0BBVXresaWhFGOomEM
         aqqQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1773442549; x=1774047349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W3QNx1W8EImhWG5G2h7xr/vJQj2kmarfg6d7Z6ksV9w=;
        b=LvQ7+AojIQWbWslVxV6LZp++FCtfugv49r69G25dyddJVQ9fPkxdSjNimICXT1G3RT
         yteZJtN4o43lx5JI9ETEBiPHRQUuYuVt+Y2bqPbCdA6ZSX8ic2t62emO7/JsN1LrfnP0
         GKHCPYWxD5DiwyI7H4bda8dma8dX3n+0KRrUQs5iNgQEFZSSBb8gtD2DWkdT15jp8bC0
         VufTk410tXmf+a+ZS9Z3onFFt4HURkznVec9CNUXuj9a2omod4iiPXOFMka6sbFzUrCg
         xsia3X3JlB+QfnmIuBi4pwgW5SlGehvapj4envNOBrZpXA+IOgsPpVRGRzEilcV1HeZB
         SYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773442549; x=1774047349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W3QNx1W8EImhWG5G2h7xr/vJQj2kmarfg6d7Z6ksV9w=;
        b=gf75xZKFBiCLgnbxo4DyKcTib3Otte2KuCx0gygPckkLVM7Oh9FbqBuyy92knNpajV
         mUQEP/aBCzpX75qar+88/Y5zQIO0B/F6AcjSl0wPxwVQYQui227hEFOmM5TV4UzMXwkt
         RLTLFr9RbsgUL6LO8oyqEzipdcwvrmzJOwnaCT3uQhMSiNrNPeOzLnaaTvJQW5T2rp+t
         b3ulVZVnexS4of/3w/QyRhW4Xb9ff3bu6s/hjHKzSPv5/NRurYDRvfDh0fT/4HZvQniz
         qpFFAiXXX+TF3e2QMw9tEm187F8976cHIXihjRzoum56dPnSlw688z2RZI9Fx/wf4H8m
         2I8w==
X-Forwarded-Encrypted: i=1; AJvYcCUUz11VPxEIQ99s1i8J787tUduu2XjG/tvUsRR5i4uLh+JYuXSUhJrOcVCtOmKpj+jox8m1QwzaISvGBJ7QCdo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq+cpbDiourmrQ0f6ozmn1Zz5hj0QcwBCQANcP4ju01BDOegBd
	g8HBOqKmByUJd/R97DTqnWMRrFIcZQOhoc8Zpe9vHNXQgMs7Q+V6iFG2h09qktMUYiE1rMBT9jI
	qPoeYMhxTO1HZDNW9MLJsIFe9DzUzPcGjw7BE2IFG
X-Gm-Gg: ATEYQzy/M+m88ZYWZaT6iiyYsifL54llXdedbOSQEVeGm7Uk8jlzqTA3fN1tobw6uwF
	btXHX7l65fLWR4oM8frSKBvqor7Yni8rrBSflt9dxEzfPVS38ohYvsbRgZ+ZkmJ8GJ353HYuZ4c
	4hugCkVX+a3d3MPPvKxac9ZkzZgKsBpW7hyNX3+hCk0t4CRnu8tFa2SZZtoRu084utJHyJJ0Yny
	nwi9WpbKE2rHX/o1gD1d1HfL14104lJkrLWzQj3r75MbrKySfv4ix+NM6gkY7WXlKIpdxpNYntW
	y43kEvEwSYhO+44hSTnqzXJcTmKNV//9jCkKIAB0IA==
X-Received: by 2002:ac2:41c4:0:b0:5a1:227e:2753 with SMTP id
 2adb3069b0e04-5a162705a51mr1219058e87.7.1773442549289; Fri, 13 Mar 2026
 15:55:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312223157.25083-1-panchamukhi@arista.com>
 <abNxz9T_XB-JtBCj@strlen.de> <abPVr5RtRmZeyszb@chamomile>
In-Reply-To: <abPVr5RtRmZeyszb@chamomile>
From: Prasanna Panchamukhi <panchamukhi@arista.com>
Date: Fri, 13 Mar 2026 15:55:38 -0700
X-Gm-Features: AaiRm53c8uPZmtPIEF5jDrLrZEH8Dcp_VPBm6r1Z8iuHGq0Ct2Kh-ySBjwFklDE
Message-ID: <CACqWiXBYJgM3S+QfON-fJQ=dPX3r21CVMN9rAXcxM+hi=DzydA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] netfilter: conntrack: expose
 gc_scan_interval_max via sysctl
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Phil Sutter <phil@nwl.cc>, 
	netdev@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 2:15=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Fri, Mar 13, 2026 at 03:09:19AM +0100, Florian Westphal wrote:
> > Prasanna S Panchamukhi <panchamukhi@arista.com> wrote:
> > > The conntrack garbage collection worker uses an adaptive algorithm th=
at
> > > adjusts the scan interval based on the average timeout of tracked
> > > entries.  The upper bound of this interval is hardcoded as
> > > GC_SCAN_INTERVAL_MAX (60 seconds).
> >
> > I already said that I'm not keen on this approach.
> > Its a 'we can't do any better' type "solution".
> >
> > If anything I'd be more inclined to make a change that allows to
> > more easily override the next_run computation via bpf.
>
> It is regrettable that the request for this knob appears to be
> intended to enable a potentially proprietary hardware offload
> extension, implemented through a userspace daemon and a proprietary
> SDK.
>
> It's 2026, there is plenty of infrastructure to offload the connection
> tracking upstream, such as act_ct.c and the flowtable.

Thank you Pablo, for the suggestion. We will look into adopting the
hardware offload feature soon.

Thanks,
Prasanna
