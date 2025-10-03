Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADEC28031D
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Oct 2025 15:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759506198; cv=none; b=GsZKmuYM0A2WCJPV7a81M3KuzCsiacr5zQ3cYsqiZeHXDjPywfWyBgYTBLIlqj3sYSnHDMoUKXS/rS8WVMDKa2+8mMalIyoPOS03TvH8lSY4fwBhJZYa97Eh8JvGdn0sBMQSboWnC+da8QnZhHHSyiDGXy0JRi5RJlvJ+iOpTb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759506198; c=relaxed/simple;
	bh=zPkm8y04zTinG2pzfsV7xNelpFQ9Iy5tfKVIN/TNtTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ix9HWdm3i4VaFAvk0rJUkCQkMm5b08A6uFDdGlh0ygCip3eTAQ7wTguN6keJ0KlZcfBT5lYtAyDnAmo3+eSBDW/qOqO8H5Ie+nJFuJnNts9fs57d/kWccTjGvyeILBG/dyXsNqyw6LK9lN1Tv62msL2OlBHsE1liI48hfx9ZsBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilWvo9VT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilWvo9VT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759506196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IRGVb+/SviQn0hYEk57O03Mjd4zlMdKn1zCsmQKmvak=;
	b=ilWvo9VTVbA8knaCRGiaU7o8cd5jiHjGDLtDWfuEm5XAijzeI8SyT2FfukR7e2uMBlGSky
	eR+fgKIcjT3Vzamm3hfraJdXl6vAbcXSI9uYhRWGXi5YbATv6IwADdi9KTKyVWbmRKsnkG
	7HyQOuvFxoBEYIHn3cx7Spc2QUhKHV4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-Tz_7bmFtNLG24AEwWP7CJw-1; Fri, 03 Oct 2025 11:43:14 -0400
X-MC-Unique: Tz_7bmFtNLG24AEwWP7CJw-1
X-Mimecast-MFC-AGG-ID: Tz_7bmFtNLG24AEwWP7CJw_1759506194
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-b2d1072a9c4so184339766b.3
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Oct 2025 08:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759506193; x=1760110993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRGVb+/SviQn0hYEk57O03Mjd4zlMdKn1zCsmQKmvak=;
        b=pl5jm2rSmL60xlh642ghxVvJ1Y2Bwl0P8u58lf+bV6hEkXpbXhgG3Nmg2ZVB53vUxz
         mHU8bJtJL7mfp9jbF3KIAC5P5iuq1ZLeXL6ubKe4jtXP9k1C5bgtpKPMOYXioKx45bjk
         nZUwUvY/kP1jnFiuSpuSG0zjD5teBonnPQZqWQi4wfncQ6+kjIH9wzQCAkVq+IRbqhdL
         8ejw5QI7jRvNug5o//GBS/srDZTNE2dG/uyXt/m0Oz4jyL5zjx7rgNkr+gc5PT74pnNQ
         vsbTmS3BlYW2lCwG4Y4Zat/+nFARAsO9oa8j7Ti5OLUreE4xReFFdh2Y5o2V90eBN2Up
         643A==
X-Forwarded-Encrypted: i=1; AJvYcCUi9LY+e3FGH2pP0VxBv51WB+UPzvR3SNOGnAKaHmb4R5V9qo9a5Md6WPmo0rVAqSL7JoddReDO3IfHMUtosbc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUJWiPSwHtuT8XOUjWn2R2qSQ0l3u5mAkJc8F9UOj88eSQeghV
	SYjlppRuE+KiMH4aLGmKuJXzTFlZtcH0v50b41ZVVoEjs3MJOZxk8HEV9lLBvAGt5Jlx7F6tGve
	E8ArLajBht2T5NE0smR8/s4Pt6CyrDQ8mXPC+hPOGY+sffAfjxmNi4GFsSV6wIyNUJh12Ri9l3U
	s5+mi+BlhEVe8kBiA3ucLdcEGzb8en3B76hl2cNTRkTxDy
X-Gm-Gg: ASbGncuRe1czwvrmx/miPWF1DjReQvMVk5+/wC+C9LcNYf1/KJjyukd+chP2UEw5Z0M
	4Tme6lNlZ92wlteFO1Sz133hbwqMcFm1AEGea32pxHOl4ncWOi9DjOVVH71Ke1b2lnTa6/roA4c
	yHqeRhoFXPzOpkqDsqet9m/RWOGg==
X-Received: by 2002:a17:907:3d04:b0:b3e:c99b:c776 with SMTP id a640c23a62f3a-b49c1976ff9mr388878366b.15.1759506193424;
        Fri, 03 Oct 2025 08:43:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/hB+bqBiXabsgzDLKI0SAwaSMZqQiCYneHNLcJLgmVXqHx4mWWC5CZ27AQOqUH8EWfNPetcIXZgWFyZvMJv0=
X-Received: by 2002:a17:907:3d04:b0:b3e:c99b:c776 with SMTP id
 a640c23a62f3a-b49c1976ff9mr388875666b.15.1759506193040; Fri, 03 Oct 2025
 08:43:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926193035.2158860-1-rrobaina@redhat.com> <aNfAKjRGXNUoSxQV@strlen.de>
In-Reply-To: <aNfAKjRGXNUoSxQV@strlen.de>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Fri, 3 Oct 2025 12:43:01 -0300
X-Gm-Features: AS18NWDHnuZbdmtwFCze6OYCQYsA8lH1vWwBn3WSoJ2s7xMRYWiXLVRdHRZKXSM
Message-ID: <CAABTaaDc_1N90BQP5mEHCoBEX5KkS=cyHV0FnY9H3deEbc7_Xw@mail.gmail.com>
Subject: Re: [PATCH v3] audit: include source and destination ports to NETFILTER_PKT
To: Florian Westphal <fw@strlen.de>, paul@paul-moore.com
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com, 
	pablo@netfilter.org, kadlec@netfilter.org, ej@inai.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 7:45=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Ricardo Robaina <rrobaina@redhat.com> wrote:
> > +     case IPPROTO_TCP:
> > +             audit_log_format(ab, " saddr=3D%pI4 daddr=3D%pI4 proto=3D=
%hhu sport=3D%hu dport=3D%hu",
> > +                              &ih->saddr, &ih->daddr, ih->protocol,
> > +                              ntohs(tcp_hdr(skb)->source), ntohs(tcp_h=
dr(skb)->dest));
>
> You need to use skb_header_pointer() like elsewhere in netfilter to
> access the transport protocol header.
>
> You can have a look at nf_log_dump_tcp_header() in nf_log_syslog.c for
> a template.
>
> Also please have a look at net/netfilter/nft_log.c, in particular
> nft_log_eval_audit(): xt_AUDIT and nft audit should be kept in sync wrt.
> their formatting.
>
Thanks for reviewing this patch, Florian!
I=E2=80=99ll work on a newer version addressing your suggestions.

> Maybe Paul would be open to adding something like audit_log_packet() to
> kernel/audit.c and then have xt_AUDIT.c and nft_log.c just call the
> common helper.
>
It sounds like a good idea to me. What do you think, Paul?

