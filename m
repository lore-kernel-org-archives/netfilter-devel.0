Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF8838837F
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 11:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783943243; cv=pass; b=TdtEAEnqLoYO7BbnfmuOsw7Xh8848/Tu/lsrmZgoNYVqu1ApAytTNEU69Gm0gbeH33cEIqBPTfVTl2obtHP2p0Xp7ZpYKfGsHJcDWtDODOEOHZEh5/seC6FkJAgJenG1G9f+m0D+CYBlWpD8ZJBzL9F1EEzn+bKNkyqbgnEuGq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783943243; c=relaxed/simple;
	bh=FJvHgNJ+u1s3bTz5io0pb5lMjKMTaANdHOHouaUaXnA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NZALT+0xyuPFd/eLg12uJXycKpoJDCdGps/GjCVVGjhzkUq1qRwyNKVtKsdROFzlhd9POz8jr7shjPahM8d+Jd8OwTipu19bBLGlOarB2mKYPlFEtzzKP6HzflqtdyRy8+OmO7MhsquyUP1Kliq0rJh0jAmhycY6ZGy8JPaLL/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTaxJwbd; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTaxJwbd"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-66771ded50aso4888734d50.1
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 04:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783943240; cv=none;
        d=google.com; s=arc-20260327;
        b=NJpltZ0CbsWIGoPPnAM4pwXM/NuhjhERbp3Ef0l0hYffJXREALW2hP6SfK5FShDSja
         dLvTJbdRsFn8MyD/Z3tou6t9elG6DFhJf0SPDUpXOczoRlRbqSpQxq/G4HeKlKe80ish
         lG5Q1dLgpLHySYsaP0lfhFa7UD4u0jHrXfjaI0yYHvY9aZQOFgwil0fQmQ/NwaoBXhxM
         EednDFNkZ5yYSvJlJ6xzTN8//hIs4ufPQZbPeM2dsx2FdKfdrRc9ahJlG9RUdOHijaDn
         aWL8OaAIXgUBhQmxh1d6C/akfORAHZceZMaiSCisccW6bQvTVUsntA5LB4mNgZ+w/SWC
         Ldiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rdMYVzU/X8PutzF06aSzT2bUqJiTzcUYC7SD9sAf8y4=;
        fh=sWunJObW40wC9mQ4a7QrK/qy7kji+583Qr+lrn42S9U=;
        b=NxnLJl1t9Eon93qrFcEhR/KsxsAJoNTbwNAJ15nSKQ//0KvMst/S5Jkw6WDktzzVjL
         uzn3NF9fGby8NwWF7Hb3ejPwVvgGxQ+j6F7GOI3dS6OhAnqMCNcAnPsyJlTyGpjYXwX6
         Q2JNariZTBMf23aKc/ICIn9FGrb2sAOBPspSxQFaaEMYJoYJugNKj8DvdGlW5mXryfzk
         CNB6aJ0y9g7og5/UYmyPwKMbXHptrvFuWKpHNs9iYBjsK2JoiNUA/q/VgLEZdxTqkJTC
         IMsEpxaY6f2tQgYLFNkXmLiv01zRT7sXbo5wg66W/H2Bi92nkvOXnXKOM+FN9J/fClit
         ql/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783943240; x=1784548040; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rdMYVzU/X8PutzF06aSzT2bUqJiTzcUYC7SD9sAf8y4=;
        b=UTaxJwbdXXyvnbWXbScxL6sSu/Rh3Uj9ojHSsZ//Ku1QLzmASCCU8CxFSmQW4hlSwN
         d91obJoUnNiVmAnvDS5AL2nnV/Uu77pYY2F7txsdNkr0mSK1erdCinmSETb0T1SeDmVD
         n5GoK/Pf84R1pCVAkAzX70Vosv2dkp+DeWzo7znGNkz5LIRFOFq+Oeo4y7eWChKmjBTr
         nWyHe7GKtkJpQ3/M6ivxlgnOd9zrNOeMfMYKwC/fNrtzTkVKDeYa5hku7Qv5sfqYC5At
         3wj/htNwPLOjWluuASyHEML+LO5OKsytoOwOG1TUwVBReqZAqUB74WjkhOnRsKlL01Wv
         rJPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783943240; x=1784548040;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rdMYVzU/X8PutzF06aSzT2bUqJiTzcUYC7SD9sAf8y4=;
        b=R4UwFlqCLFIXb3zhuO4T8vkwQvxl3AB1xzs1Anxkf+LiefQajwBTEz0eMhEBUBmvrW
         kFIeKBsp9rAQ1oblJq3+fBwrjPg9xx5OCWIE8f2+9sK00md8sVKkqp1ugjyJQB9+GVzm
         bK+m9F15K2LVT9ILhjR7UIJEnplO+MUMMTjPGHsICAyJrUUC4UgsjDEu5iicnkJ106sD
         KM05zYhj2ddlhd9SsfEA4lRkNn4VpghyBu+f5Z8QQnJGKkTkwBMj9u6GBCzIIs6pVkss
         8fsFRIgF2yZPGFPXP8qXdHFK6zdemmPCtrG3IA8K+2kkqF6FfjIt69CXPH8JOJ78U42f
         q06g==
X-Gm-Message-State: AOJu0YxH1ZcYPXoCmAp4XM6ZgDIBzGLw2XPSJ9YlQAjPOaa1Nf7eAYtU
	bhTbBVm84z9OUqV85daO05SEuMfkboQz616AXGtxwyLGjkk+M9tBmGSdIAU9d55Bokb439DyVjN
	vXRiRT4d28xNVjaiJjUwovxm2k4iPrxuH7LewMI8=
X-Gm-Gg: AfdE7cka6A/80QOd0SFT0rmQyMn5JWDaBZGodzjhYRxHhHAf6R+ZiayjLV+pW//UKor
	EXj2N6137ocRv9ROd5rVrtkCCkaRicKdym5wDEQgBx6kECm/5P8T0Om2pNGlsP03WC5hQacrErW
	dFbTHskvNZTiOCwRIlrscl8pUKQ0f3uL/FyAIiJPBoBDUEDta6BF7MZKF+1Gn3fBf+7D0YCX5jH
	R+rLl4zYUo0uuTpJD5njMIZNnpifscQAFqBMx63E+JRYYK1kdpHS3sHLWtRUv60zVLojSYkyMU=
X-Received: by 2002:a05:690e:408b:b0:667:e33b:6043 with SMTP id
 956f58d0204a3-667e33b6a48mr4240491d50.101.1783943239994; Mon, 13 Jul 2026
 04:47:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260710075409.1360085-1-pablo@netfilter.org> <CANczwAEqpv+zALby0crkzO5tX63efo-0JrVHVJUWbNgtxsKqSA@mail.gmail.com>
 <alKvX-Q_v6ez4fV3@chamomile> <CANczwAFH_GFK+uTTcpOoogQ8LuY6MRRwe0Q76=rP=F-9bY953g@mail.gmail.com>
 <alPqs8gMuF1uJuTw@chamomile>
In-Reply-To: <alPqs8gMuF1uJuTw@chamomile>
From: Ahmed Zaki <anzaki@gmail.com>
Date: Mon, 13 Jul 2026 05:46:44 -0600
X-Gm-Features: AVVi8Cf_6SVIWlNioBCPLbAG_Wbp-B_9vNNv-4noQ8BoQuwsPpPwVWjRNi7Ly9E
Message-ID: <CANczwAHZqSMEnbVFT5YsHjLUHxmT+1vP6XSH1gcMptnNPrZGEw@mail.gmail.com>
Subject: Re: [PATCH nf,v2] netfilter: flowtable: tear down flow entries with
 stale dst from GC
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2026 at 1:27=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Sun, Jul 12, 2026 at 07:39:25AM -0600, Ahmed Zaki wrote:
> > On Sat, Jul 11, 2026 at 3:02=E2=80=AFPM Pablo Neira Ayuso <pablo@netfil=
ter.org> wrote:
> > >
.
.
.
>
> > > fa7395c02d95 netfilter: flowtable: support IPIP tunnel with direct xm=
it
> > > 6c5dcab95f4c netfilter: flowtable: IPIP tunnel hardware offload is no=
t yet support
> > > c328b90c17fc netfilter: flowtable: use dst in this direction when pus=
hing IPIP header
> > >
> > > There is also this patch which is needed:
> > >
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/2026070911=
4025.1294044-1-pablo@netfilter.org/
> > >
> > > which has been included in the last PR this Friday.
> >
> > I have some limitations so I can only test with 6.6 or 6.12. I will
> > try to trim down these patches to
> > "move dst_cache out of union and use the gc to check all entries" and
> > will let you know if I see
> > any more problems.
>
> You will have to backport the move of dst_cache out of the union.
>

yes, and I tested for a couple of hours with no issues. GC was taking
care of the
expired dst_cache.

> > The one thing I believe is still missing is to remove the if condition
> > in flow_offload_fill_route()
> > when setting  "flow_tuple->dst_cache/dst_cookie":
> >
> > - if (route->tuple[!dir].in.num_tuns) {
> >
> > We now need "flow_tuple->dst_cache/dst_cookie" for all DIRECT xmit
> > even with no tunnels
>
> How so? ->dst_cache is not available when sending packets to a port
> behind a master bridge device.

Sorry I must be missing something. I do not have a bridge in my setup. I ha=
ve a
Mediatek PPE that is offloading from one port to another and there are
no bridges:

# nft list ruleset
table ip fw4 {
    flowtable f1 {
        hook ingress priority filter
        devices =3D { eth0, eth1 }
        flags offload
    }

chain forward {
    type filter hook forward priority filter; policy accept;
    tcp dport 5201 flow add @f1
    }
}

My previous comment is that in this case, AFAIK, the "xmit_type =3D
DIRECT" and in order
to set dst_cache/cookie, the guard "if
(route->tuple[!dir].in.num_tuns)" needs to be
taken away (which I did in my 6.6 patch, let me know if you want me to
send this as ref).

Thank you.
