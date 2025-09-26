Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7058F1D432D
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758911354; cv=none; b=BpsuTSfFpDLwwyn3E3H99ZCB45lpzdim5zzcuPYMH1pJJIIXHofwFxMK5+OnwYzbhGXOuF35horDhKd8PUPqIZKyO06y+CHTX6HGq4xX52c0S/yvxbl/19QwDzzQ1ZDYjG78SZrTHGIdLJTDfoJtRQHhLx0n6cOcOgzySz0ufvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758911354; c=relaxed/simple;
	bh=Fdtvwdou0j/HPLsynKl5haCoT9J7J98Gr4teoaFv51w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CdHSnD8QrZt9vcmn09uN0Yhvz01B4u/SZf7NQmljJbnFb7xHUQXXT302m3jG/5X5evopMCQZ0BT7DY+7q9CMLW1iwZowCEm3lZkTXxyK0Fje0l7KhsHMPJ69g0XhhIUhkYBUVsyUdvfbaP3WUZ/1yhfgcj025cDnmtQIar+KlFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AOy+C70S; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AOy+C70S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758911351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VVK5hqYxqrcHg6x0vzf6zc77p/zTjdplz2xbifw60rg=;
	b=AOy+C70SEe4vbZobWU6gZg2wNYTeOJ8perMV5y5wV74FvbJc2ltaAm69XYmz1G+Cnh6mOr
	Xci/fe8GkD63ykhQu0vAo6uVm4BmJzbgSamjziBzBu6nuaQVEju5Sn7/H2wHHe4q48kAO0
	UJLPZspVGTsPTyRy0NuF3iGCMrctLwE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-hWKdm3V1M2mjPgQ0OPg56g-1; Fri, 26 Sep 2025 14:29:10 -0400
X-MC-Unique: hWKdm3V1M2mjPgQ0OPg56g-1
X-Mimecast-MFC-AGG-ID: hWKdm3V1M2mjPgQ0OPg56g_1758911349
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b3826ab5449so82546466b.3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2025 11:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758911348; x=1759516148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VVK5hqYxqrcHg6x0vzf6zc77p/zTjdplz2xbifw60rg=;
        b=n6LzT2pFMeL0Z1YQPW+Ry/ztuq7lZMuT/K6hmC1S1uQrPb8mwI/jMjaSeq7oF7cNCc
         nRJBC0zZubqAxWaznslDSyv+6Qxr408xttYe9DFi3tkwNYk+Y+3d3bJ4u7/PhsyVFmC5
         G+Seu5nPL/jyN6SfaCAex8ym7ptMZtIVA4Oxw6ij7aLy8isGQjGbE2n4bgjNNQnG52LN
         9d7N3ipEAD4STmqpslY0qEZtu4cgJMKJLXlF/y2JfBU2NqnmMU1sKrUuogVoDJl95/Hd
         cQw2CcgJT2MWURk3OpZx+86aU8Y1XbCpFVp3sBJtgUk4/uKNYuO767bIdlOMk1pzIhJS
         iweQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOJqaLuz+e2yLaA68DisYQEKJdlPTm3zjMNiwFy+qiEnzzepIqWikD8Qdgxw7ygmYy6EXzA0H2nZT0+/xODBY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxQkOqtDLWiwAHR8BFk3wLJJnnVlMlgm4ihemcAHpBxxFhI36a
	MojKtWMJ9DQcCQOXwYI7+FGy/D03eaz1HL+7/nWBrkSwuX6npDICppnqqLLjjba3ISDCez3z0+G
	wsxaLMH66KSkXue7xXDA9746FPpCAxLRu7T4hGVL8YIzF1kSb+aoben3wTf8qVVGuBb0YRvXPjE
	MQltFuD41cLMqNqrwfn2UykxLhYRq07zFcEkVIHZ3+21UdWESAfssyyUU=
X-Gm-Gg: ASbGncvyyzz72kFdvCG2jCw2OuVYxrEPLskGUmhs2BdAEEbIT5BRKdfNbZ3ISNDg7p8
	RahmUoO1nHYRN9NE2TSjc3cxecEC9M8VqLdVgC/JUbfP/H58ox41Id+f+FvbX0q0AgOm/0tv7Vb
	HoSQyc3O+2HZWg1vby1O+L7Kx1FY57wvBOvcBylXsRLhBLwg85H+bFuw==
X-Received: by 2002:a17:907:6093:b0:b04:6a58:560b with SMTP id a640c23a62f3a-b34ba93ce11mr909046166b.39.1758911348348;
        Fri, 26 Sep 2025 11:29:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8NPueb5nCMT5DuPssEE6Gyfl/L/QQSo2uJ/kLrAnQWxWWz6E92b3DZ9NPm4ViF0aNX+BwD71pWnwRFHvSZHo=
X-Received: by 2002:a17:907:6093:b0:b04:6a58:560b with SMTP id
 a640c23a62f3a-b34ba93ce11mr909043066b.39.1758911347929; Fri, 26 Sep 2025
 11:29:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250925134156.1948142-1-rrobaina@redhat.com> <c7a8d5f64e19f529a7595f26e150826f@paul-moore.com>
In-Reply-To: <c7a8d5f64e19f529a7595f26e150826f@paul-moore.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Fri, 26 Sep 2025 15:28:55 -0300
X-Gm-Features: AS18NWDStEem2dFQRSusMMoOLIwVwIMaAYTG9PMRNMPg6ucZ8NhwQ2lffaOUJ4g
Message-ID: <CAABTaaC9tSJ2Say6RHiQ3Ffm-xo4g-Ld3r83GwUBYZ5STs-hCA@mail.gmail.com>
Subject: Re: [PATCH v2] audit: include source and destination ports to NETFILTER_PKT
To: Paul Moore <paul@paul-moore.com>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com, 
	pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, ej@inai.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for reviewing this patch, Paul! Sounds great, I'll work on the
v3 shortly.

On Thu, Sep 25, 2025 at 5:41=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Sep 25, 2025 Ricardo Robaina <rrobaina@redhat.com> wrote:
> >
> > NETFILTER_PKT records show both source and destination
> > addresses, in addition to the associated networking protocol.
> > However, it lacks the ports information, which is often
> > valuable for troubleshooting.
> >
> > This patch adds both source and destination port numbers,
> > 'sport' and 'dport' respectively, to TCP, UDP, UDP-Lite and
> > SCTP-related NETFILTER_PKT records.
> >
> >  type=3DNETFILTER_PKT ... saddr=3D127.0.0.1 daddr=3D127.0.0.1 proto=3Di=
cmp
> >  type=3DNETFILTER_PKT ... saddr=3D::1 daddr=3D::1 proto=3Dipv6-icmp
> >  type=3DNETFILTER_PKT ... daddr=3D127.0.0.1 proto=3Dudp sport=3D38173 d=
port=3D42424
> >  type=3DNETFILTER_PKT ... daddr=3D::1 proto=3Dudp sport=3D56852 dport=
=3D42424
> >  type=3DNETFILTER_PKT ... daddr=3D127.0.0.1 proto=3Dtcp sport=3D57022 d=
port=3D42424
> >  type=3DNETFILTER_PKT ... daddr=3D::1 proto=3Dtcp sport=3D50810 dport=
=3D42424
> >  type=3DNETFILTER_PKT ... daddr=3D127.0.0.1 proto=3Dsctp sport=3D54944 =
dport=3D42424
> >  type=3DNETFILTER_PKT ... daddr=3D::1 proto=3Dsctp sport=3D57963 dport=
=3D42424
> >
> > Link: https://github.com/linux-audit/audit-kernel/issues/162
> > Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
> > ---
> >  net/netfilter/xt_AUDIT.c | 42 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 41 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> > index b6a015aee0ce..9fc8a5429fa9 100644
> > --- a/net/netfilter/xt_AUDIT.c
> > +++ b/net/netfilter/xt_AUDIT.c
> > @@ -19,6 +19,7 @@
> >  #include <linux/netfilter_bridge/ebtables.h>
> >  #include <net/ipv6.h>
> >  #include <net/ip.h>
> > +#include <linux/sctp.h>
> >
> >  MODULE_LICENSE("GPL");
> >  MODULE_AUTHOR("Thomas Graf <tgraf@redhat.com>");
> > @@ -32,6 +33,7 @@ static bool audit_ip4(struct audit_buffer *ab, struct=
 sk_buff *skb)
> >  {
> >       struct iphdr _iph;
> >       const struct iphdr *ih;
> > +     __be16 dport, sport;
> >
> >       ih =3D skb_header_pointer(skb, skb_network_offset(skb), sizeof(_i=
ph), &_iph);
> >       if (!ih)
> > @@ -40,6 +42,25 @@ static bool audit_ip4(struct audit_buffer *ab, struc=
t sk_buff *skb)
> >       audit_log_format(ab, " saddr=3D%pI4 daddr=3D%pI4 proto=3D%hhu",
> >                        &ih->saddr, &ih->daddr, ih->protocol);
> >
> > +     switch (ih->protocol) {
> > +     case IPPROTO_TCP:
> > +             sport =3D tcp_hdr(skb)->source;
> > +             dport =3D tcp_hdr(skb)->dest;
> > +             break;
> > +     case IPPROTO_UDP:
> > +     case IPPROTO_UDPLITE:
> > +             sport =3D udp_hdr(skb)->source;
> > +             dport =3D udp_hdr(skb)->dest;
> > +             break;
> > +     case IPPROTO_SCTP:
> > +             sport =3D sctp_hdr(skb)->source;
> > +             dport =3D sctp_hdr(skb)->dest;
> > +     }
> > +
> > +     if (ih->protocol =3D=3D IPPROTO_TCP || ih->protocol =3D=3D IPPROT=
O_UDP ||
> > +         ih->protocol =3D=3D IPPROTO_UDPLITE || ih->protocol =3D=3D IP=
PROTO_SCTP)
> > +             audit_log_format(ab, " sport=3D%hu dport=3D%hu", ntohs(sp=
ort), ntohs(dport));
> >       return true;
> >  }
>
> Instead of having the switch statement and then doing an additional if
> statement, why not fold it all into the switch statement?  Yes, you
> would have multiple audit_log_format() calls, but they are trivial to
> cut-n-paste, and it saves the extra per-packet checking at runtime.
>
>   switch (ih->protocol) {
>   case IPPROTO_TCP:
>     audit_log_format(ab, " sport=3D...",
>                      tcp_hdr(skb)->source,
>                      tcp_hdr(skb)->dest);
>     break;
>     ...
>   }
>
> ... considering how expensive multiple audit_log_format() calls can be,
> it might even be worth considering consolidating the two calls into one:
>
>   switch (ih->protocol) {
>   case IPPROTO_TCP:
>     audit_log_format(ab, " saddr=3D...",
>                      ih->saddr,
>                      ...
>                      tcp_hdr(skb)->source,
>                      tcp_hdr(skb)->dest);
>     break;
>     ...
>   default:
>     audit_log_format(ab, " saddr=3D...",
>                      ih->saddr,
>                      ...);
>   }
>
> --
> paul-moore.com
>

