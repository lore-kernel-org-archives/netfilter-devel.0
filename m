Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B7E385529
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 07:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788765870; cv=pass; b=gsgy3nc9ZtsLw3X1dwsL2y49bRYVOeB7w0HHrViSo9HcrFd3ziP341rExknSXubZIHAgvqxO7iVdHoeJ8OY7y23/fWjSUaZL4VLEejXJ34J7jJ3ldfwHLMxBmf3qbo1+eDd85GqFDfx9xCINnlyA7A1NEPHtRBrDp+JEH2hEaL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788765870; c=relaxed/simple;
	bh=2yE2vKhYco15cq1LAqgS54dJAg4li6tJCb9pHzWm1p8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NAck0xyuH9UaMz1zeZ82ZchHSTmJ0YP5m00M4+40n8RBh1gH3+E1iZYMCAG0+p+TADhT2dAkdrysDIEq5ZYiFdyRAYtpdGYmxwRKXWbc1hr6oIYftNTCtrmhYx8K6fij5Sbti4ZOu+Kqe5gRQHJVODQ4txo8bQRtZs0zVQHOre8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S8ZiJ5Iz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=B4Uvh9Kh; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8ZiJ5Iz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="B4Uvh9Kh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788765868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2yE2vKhYco15cq1LAqgS54dJAg4li6tJCb9pHzWm1p8=;
	b=S8ZiJ5IzRswZcAlOTqhqSg8tZTG1pVm4aNsPGvgcg92Fj6H/mjYX75htO4w9cZWz6/rueM
	J+Pt5DaG4gXkI47eWEugo5Rny+0+IVyyKcLuOpXOU3YQHfb2UeZ6e4JfqFiSwOoZrllVub
	+dG8ov1Jgf97752WqpWRCpPEn3PWpuQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-80-FwYUu5UcMD6dCt5VXNaOCw-1; Mon, 07 Sep 2026 03:24:27 -0400
X-MC-Unique: FwYUu5UcMD6dCt5VXNaOCw-1
X-Mimecast-MFC-AGG-ID: FwYUu5UcMD6dCt5VXNaOCw_1788765866
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5b60bfcb6fcso1784397e87.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 00:24:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788765866; cv=none;
        d=google.com; s=arc-20260327;
        b=GQHNo186ILoz5qvPY6CGA3jg7HGaHwThgaQZYJ2cL1EM6v2PpjrYi//G29ty8hLFnw
         TnOxVcXDSedVFV0zO7nLGhTlGVeLm2CY4K0TEqmyJTekzQML29dWaIDHDJmy1PchM9WI
         Z1e+an16YFbo+XfhA0E3XSKkkw7O6Y6SNruqQqScG3VD0ANqSKz9kt1pDwykrMglgXTT
         l+6TF31pdykUh1hl0WiZ0vdapMIDhhd15X2gHy5wmGoeQ0+CBVQnKVDLcFwetAlzPpCw
         q9Fc/olkTcS7vp/Z2XxiipYbfNmYFJCS8UP7hkJeXrGTaNiA3OXnvo8WazubCLQvHcoE
         G78w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2yE2vKhYco15cq1LAqgS54dJAg4li6tJCb9pHzWm1p8=;
        fh=cEHA0S5Qe1wlFOI7kR0f3gJ+N6hJQ/ZRXA5OaB9GTMU=;
        b=gXoQyKZUEqJqvQdf84XntRGdoinZOTfK7CSEeeplB7SwThU/3vIdeWmelRr4Ym0qQZ
         O/uJSmc3uefAitPhgvNx9r9teOLcYikfZ9Trj4ZjosHFiVqeUvKhr1kUFhpvFyWn+4zr
         vWqoafncgmjvDzKWSDUop/19Tmv1dv0oqLPvQB51Ui9ewp8HGqWq/y8HLtOJ21XbNv2w
         vsqGLYS6OtakB9FKW8MNGHJAdXzyigU0X4Z/jNNdJ6/MLlZdX6eqQoXca5DlicGPnhrG
         fJ/5Ad6bmpPfhTOcGSAsOquUb/HSb7/wVvAqGNezId6c4CMvcw1VwIcuDnSOK2V7RAUv
         aOzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788765866; x=1789370666; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2yE2vKhYco15cq1LAqgS54dJAg4li6tJCb9pHzWm1p8=;
        b=B4Uvh9Kh038DoTB9gEMhPTq75k2pfy56Vh0rJgVZ914d3OJux9BdPQdPtLi9p4A0EL
         jHGN1rXi5iABqzb2dKM7HlbsASwafFzIl2UxW6/wYXe/MUcAz4wRHzI8X+Vp85oiXjPC
         oE1QHAKd2rmNwHqMT7K2TGix/eJmCbKAHYJn21tgaBs2uPScY+5pcYN4z5bm6noyzrF4
         lPSzIMP+3C3Wdr9Lk4ZQa5ayx85Jzw/vpeN514kUZn6VzyTbY7KoGw1m7fzKBDDxCNsj
         Lj5etN2/Ks74jHdzULam1Bz3jeBo8eBeUlepKaC9AcnQznMy+jbtrB8x2wzwes+pJJ/9
         eiHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788765866; x=1789370666;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2yE2vKhYco15cq1LAqgS54dJAg4li6tJCb9pHzWm1p8=;
        b=BPYeAQIxdVP4G7w9JvAGNxmGbJTotPKgDGdNr4sdfmF1hhHsc60OP4CTw4HyHdKBTH
         MlTkpr3Ng+yTRbn6R9iIExUIfzLtAGtfcgYW0mO47oKjMxDO/W5Vp650NiDUyQmxC04Z
         eJ0u7aKofTgB42ioUYKnvwdBgIcyJuxUalw3gum9jjUZhP5EYy9OlDfnjHd+0dO+guhn
         C7hiN9gXFqmmJdTtCEn6IJhEIpzkgGzJEPySgfVSCqJ8IEj3DBPtLyTwM97YoySahXka
         osrH8o+Yy00FkzbSpQQsQBlkdrpabKXCyLtJ/PyuGf3wpWyyQeza9z4rnYLAhTpJT47m
         nFWw==
X-Forwarded-Encrypted: i=1; AKwUvBzqljAesnyk5F6JsDmoG/Xk890fuEVBsSHCezCeE8gDw1dals97aj/idIjDyI8jfluWPElwunneMnVIvd+evxY=@vger.kernel.org
X-Gm-Message-State: AFuF++nmvEJwTLBqq9Wwr0Sg6MQKzULvEakrZ13E9rfIR4N2DHVm20AP
	MKHURPwi6syMHCZ/xYFy9ylodmqqUtl2yeW/Yi6Cili3kjmsFbrH4gpVRzJm+KjDn3nFq8zE+pc
	9z7QQrEaoQpgT22gw61FjpTC2PbOn1Zbb8dEqJ7jtbZA3f/uLPTKKDkCMWRUpn9AuxSogvRXn5Q
	9FNsUKX/BXnSOy+ZCF2TNu3XwDO4EKp1vyWqVFs6h0nIVJ
X-Gm-Gg: AYBFou1TR/AxgbIZKjcHo0N7Goq/gpxseuRQ75qeOHHDUNR5WGDZHsE5qXaZxdCVRJn
	4RvyVjFSsWJFMwFfArSTCwOdaFA/jirVN531gocDzp0kk+tfCCMYqiD0TP9CQpzsJ1kjbhuJDzd
	6G81y0QTy/gi8nsUtK8Idv51P7TnqPj5YtgvVIu9yyDOj+rqvpQwWWZG1t
X-Received: by 2002:a05:6512:3f0e:b0:5b5:e86f:3550 with SMTP id 2adb3069b0e04-5b616eed114mr3346348e87.9.1788765865579;
        Mon, 07 Sep 2026 00:24:25 -0700 (PDT)
X-Received: by 2002:a05:6512:3f0e:b0:5b5:e86f:3550 with SMTP id
 2adb3069b0e04-5b616eed114mr3346309e87.9.1788765865162; Mon, 07 Sep 2026
 00:24:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260903121057.80006-1-ihuguet@riseup.net> <20260903145631.GA182962@shredder>
In-Reply-To: <20260903145631.GA182962@shredder>
From: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date: Mon, 7 Sep 2026 09:24:13 +0200
X-Gm-Features: AcwNN1VwMZKu46IzJzKROmEYRy2rjJetX0BeFnxsi74O5FJcBryBFl6vpHj-5Dg
Message-ID: <CACT4oufRecaPSMTJPK3yJurmaEaMN5i_CArV-mHd=rAA4zOJEw@mail.gmail.com>
Subject: Re: [PATCH net v2] net/ipv6: don't route packets with unknown source address
To: Ido Schimmel <idosch@nvidia.com>
Cc: =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@riseup.net>, 
	David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, dcaratti@redhat.com, 
	Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, Phil Sutter <phil@nwl.cc>, 
	Daniel Borkmann <daniel@iogearbox.net>, Junseo Lim <zirajs7@gmail.com>, 
	Martin KaFai Lau <martin.lau@kernel.org>, Xuanqiang Luo <luoxuanqiang@kylinos.cn>, 
	Fernando Fernandez Mancera <fmancera@suse.de>, Leon Hwang <leon.hwang@linux.dev>, 
	Willem de Bruijn <willemb@google.com>, Kees Cook <kees@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Qi Tang <tpluszz77@gmail.com>, Joe Damato <joe@dama.to>, 
	Breno Leitao <leitao@debian.org>, Li RongQing <lirongqing@baidu.com>, 
	"open list:VRF" <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>, 
	"open list:NETFILTER" <coreteam@netfilter.org>, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 4:57=E2=80=AFPM Ido Schimmel <idosch@nvidia.com> wro=
te:
> 1. This is a behavior change, not a bug fix, and should be targeted at
> net-next without a Fixes tag.

I see it as a bug. If you remove an address or its valid_lft expires,
the expectation is that it's not used any more. Anyway, even if we
consider it a bug, it's certainly not urgent, so it's OK for me to
send it to net-next instead.

> 2. What is the motivation for this drastic change beyond RFC conformance
> and parity with IPv4? IMO, these two are not a good enough reason to
> make such a change with a huge blast radius.

IMHO conforming to RFCs is always a strong reason. But beyond that, I
think that the current behavior is wrong because, as I've said above,
keeping using an address that has been removed or expired is not OK.

It's true that it's difficult to spot all the corner cases that may be
affected by the changes, so the tradeoff of fixing vs risk of
regressions is not that clear, I understand it.

> 3. See [1] for a list of regressions that AI flagged. Even if v3 fixes
> all of them (which means a much bigger diff), I don't think such a
> change will be merged without a proper real-world motivation beyond RFC
> conformance and IPv4 parity.

I will try to address all of them; thanks.

About the real-world motivation: this comes from a customer's bug
report, who is worried about packet leaks in their production
environment. I mentioned IPv4 parity and RFC compliance because I
thought that without those arguments it would be very difficult for
the patch to be accepted.


On Fri, Sep 4, 2026 at 12:38=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
> breaks a bunch of selftests, too, FWIW
> Please make sure to mend those if you want to forge ahead as a non-fix

Sure!


On Fri, Sep 4, 2026 at 12:22=E2=80=AFPM Matthieu Baerts <matttbe@kernel.org=
> wrote:
> Just in case, do not hesitate to look at the new countainers that might
> help you running those tests locally:

I didn't know about this, thank you!

--=20
=C3=8D=C3=B1igo Huguet

