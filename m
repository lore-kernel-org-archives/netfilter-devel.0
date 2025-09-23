Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C7E1D90C8
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758648901; cv=none; b=fDpdP7r/soRIfCoE6QA4Pdhug4ER/iOLUY7Msi4RfZ71kLJ0cojLfOTtKnpqOt703LiQxNjkqptgdvnPnFFZtnyE5PIcFFAx9zqepDczcCYIwzT4HiVQxxJic0ci6+RN3vktNVJ3nIt64MEoYfnonR3w+XSSfyt3M72M5mZiyNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758648901; c=relaxed/simple;
	bh=kiHYOV5tKHdiZHaewEhed9KwrpNMOwErNX95ewTe0bM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UEViEJrU3Wdr4j7a0SQKTQ7UDGqe2zLNgElZIttEtwbHUDXxRLxNC8WlnTi1pF3sGw4aRjjLuZMJXw8T3DAQ6w915a4rqlbtvK3EcYQ3GXxUQk23GFC/V/MPRq8+k4SDdSThrXTAjyc7ynkSLwEBEEaI5kQA85OTVGsuIvvWhD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FsTv/OnG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FsTv/OnG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758648898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SeHg931zRHI47gvkNWZ7vE3F3NuZSRm6Ea8fb1/M8s0=;
	b=FsTv/OnGFfYnKtrmwXQsGDlMNsp1Lw9A/McovHcXDgaousDMPddt7poO47OtM1L7nKyesc
	smkJx1DmuN+qnT56Yd4mBl/YPQVplsOWU6Xc6TbOl+wsEFHf9njNKTgnXrbMQ7Z/AVKbAh
	QgSYO/fyfsvUu2fcV+c3c2ZpSf+Li/0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-jvqJCW5uMmeDUDoaZxYm6Q-1; Tue, 23 Sep 2025 13:34:55 -0400
X-MC-Unique: jvqJCW5uMmeDUDoaZxYm6Q-1
X-Mimecast-MFC-AGG-ID: jvqJCW5uMmeDUDoaZxYm6Q_1758648894
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b04a8ae1409so575446266b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 10:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758648894; x=1759253694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeHg931zRHI47gvkNWZ7vE3F3NuZSRm6Ea8fb1/M8s0=;
        b=RUzB4d+P3omoXQss1KOfymoA1jf/gdPQIlB0C+I42bW0fUdZc5FAiQJQJ2VR21VbVL
         r/7mgyezWmF4lFGSK8FnM0EeugORSLLOkjCvMsSztTsHLxj2102CrQIg9uvGKieFkwrD
         YTBqrsEpgdmVg4iA3bVVNe5pENeVwMnLJWejv47t1MuWQZxgiMtWSzX57khrbMKKhRdH
         mtuGDVE7FEyw+Kgdz373usq00kmGISdk4/4ltfLzbQzpDnAzRzBkhCxjWry9npheqM6P
         mm+6DmxKu8Yd+BJqLDhj71W3p69qAyocwaRt7Tyk5SAeIND7gFjWYt8eWd+9R+S8+9gG
         ZXbQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgM8gzkCM4wwACWK+ARAUqHWaEjSiJIBn+E/qJTbaKHFQIVrE/XejLPgY2JGdwEjpyPk100pd5iewWKjItO+4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4JD8tOdFXBmr/qwbnDCcimaFKvrj+6b4G00Npa3IrK9aiouy3
	nZ3skHJf9BNo0b312dbNJIJhLr6XT7oe5FEThJ659CvzNq0jy8Lc/F8LcXLwZQ0alHF+0LR3hHx
	xmdgZZuj901MmLXCLjrrZeC6y0qwbqzCkcqvb8cx4V+80S6f80ppnARcE4k/E4ntKg90gnn81BS
	5lDYuA9ErS9RSV2zjwSAqwFj2RP3U1bS6X2ENbrFlGktKq
X-Gm-Gg: ASbGncvHGZdqka3XXlqN0qy2rGq1BvHtPN1MMieLpzhvLHirajcasdj3hdUbcpXzQUl
	5ogNZoz00KgeDgHdIKWTLYE0uWkOLWpJhnaKNg/J7dj162Otk/4fX2cNPxAeAvlS+kht6O7ZQEY
	iA+C+24Cov5gi5pby7B2Q7KCm1uzQRwve+onLyCju4Xto64FuRHU55Cw==
X-Received: by 2002:a17:906:9fcd:b0:b04:20c0:b1fd with SMTP id a640c23a62f3a-b302ae300ccmr331462266b.36.1758648894492;
        Tue, 23 Sep 2025 10:34:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHq4BfWe8HxueShfdYzigmJ/VAJwF1XeJgNJ2hPk2d7C/yE2zIEX4Wl+YrY9HIBKFihHiry//0x0vN++dsU+uY=
X-Received: by 2002:a17:906:9fcd:b0:b04:20c0:b1fd with SMTP id
 a640c23a62f3a-b302ae300ccmr331460766b.36.1758648894113; Tue, 23 Sep 2025
 10:34:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922200942.1534414-1-rrobaina@redhat.com> <p4866orr-o8nn-6550-89o7-s3s12s27732q@vanv.qr>
In-Reply-To: <p4866orr-o8nn-6550-89o7-s3s12s27732q@vanv.qr>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Tue, 23 Sep 2025 14:34:42 -0300
X-Gm-Features: AS18NWBWOHf8rNDBSAWfxx9RxHlA_lLobyIxEA9zXAn2_ywMPGOuRbJS6DmvJVs
Message-ID: <CAABTaaDaOu631q+BVa+tzDJdH62+HXO-s0FT_to6VyvyLi-JCQ@mail.gmail.com>
Subject: Re: [PATCH v1] audit: include source and destination ports to NETFILTER_PKT
To: Jan Engelhardt <ej@inai.de>
Cc: audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, paul@paul-moore.com, 
	eparis@redhat.com, pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025 at 8:29=E2=80=AFPM Jan Engelhardt <ej@inai.de> wrote:
>
>
> On Monday 2025-09-22 22:09, Ricardo Robaina wrote:
>
> >NETFILTER_PKT records show both source and destination
> >addresses, in addition to the associated networking protocol.
> >However, it lacks the ports information, which is often
> >valuable for troubleshooting.
> >
> >+      switch (ih->protocol) {
> >+      case IPPROTO_TCP:
> >+              sport =3D tcp_hdr(skb)->source;
> >+              dport =3D tcp_hdr(skb)->dest;
> >+              break;
> >+      case IPPROTO_UDP:
> >+              sport =3D udp_hdr(skb)->source;
> >+              dport =3D udp_hdr(skb)->dest;
> >+      }
>
> Should be easy enough to add the cases for UDPLITE,
> SCTP and DCCP, right?
>

Thanks for reviewing this patch, Jan.

Yes, it should. I assume it=E2=80=99s safe to use udp_hdr() for the UDP-Lit=
e
case as well, right?

It seems DCCP has been retired by commit 2a63dd0edf38 (=E2=80=9Cnet: Retire
DCCP socket.=E2=80=9D). I=E2=80=99ll work on a V2, adding cases for both UD=
P-Lite and
SCTP.

