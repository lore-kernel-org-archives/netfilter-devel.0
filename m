Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5ECD1C860E
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 19:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760382699; cv=none; b=YoQ+qbw8vtg7VJbZGmulB3JeTObz08MPczeC4ODyErSXaNCdxPn8e7+wrXyJc96pIxP3e0BnQCIdyBN8WRKCDNYGJVuZZNvWrOsEpm1gKUW/zjNdUA5KD6RIfAq/xOM+6amRcf2djcJPtWNwLLXulFBRJpUE4DLHJmm2dJcFBKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760382699; c=relaxed/simple;
	bh=YnqDhTt+IrtlvAL/Hrj549WY1No/n/MTQkCaJCyZ/Ys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ejgirWQ+wLVoUu1jcGbYXipnSAD5qCQ4LcPX+X0ds1lhpwXUsM2PEERFhGkPBd1DLCLRjfipzcgyrvq2WAgoIzhtGSQKoh6lE8M5QMJfHRbsYRk/MTI12CFtDiRvGcbWmXtUEvaEJrCwuT14fGbLnhWPYX7qOyTnyyUJs1yB63w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EeDev8C+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EeDev8C+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760382696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YnqDhTt+IrtlvAL/Hrj549WY1No/n/MTQkCaJCyZ/Ys=;
	b=EeDev8C+Y/20DMPw4RzUtsJJefcaR1uWjBffIKXeCyHnCChLi1tPI5wRRx39ynxHhW7tHS
	jXOAanz9arQnexCdukHSjkHSda8vXWy3Fblf+Q2u4hP81wKNfeDmqKrvMi2U2qQ+JIc5Cj
	wq5FkFF802tJJAzWNoVfyYxEPFcuJrY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-utUzOE2DPlWPlh-wKf_zCQ-1; Mon, 13 Oct 2025 15:11:35 -0400
X-MC-Unique: utUzOE2DPlWPlh-wKf_zCQ-1
X-Mimecast-MFC-AGG-ID: utUzOE2DPlWPlh-wKf_zCQ_1760382694
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b3cbee9769fso612710366b.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 12:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760382694; x=1760987494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YnqDhTt+IrtlvAL/Hrj549WY1No/n/MTQkCaJCyZ/Ys=;
        b=YMmUOtW35Zqu6fPZq0aufVVoKaR5ZTMNbrjIbq546q1bgQZQAKVa44L4Y7gFnJ/YmR
         U5qSr5Vb3cLg45xvH4apsQFRr4ekoQFwIBvryQQ4ddebIs4MTwtVhaslCLwi8XcbnP8p
         5rQqxBWyKbOz0bHKsTE9QYvVAFkv7US1N3tV1rH5M+j0sSQp0Lq53gTQLWkSFmsMIj/b
         k1xrXZL3mH9brkGmb4o+ZiloVFdcKxYY+/eeaKGuSkpwPhipkOBO+smctY/D9QNMj9SZ
         y7iZdcXNRc8Xlp2h4uBVE2nlpGBjrRanPUmlF3NMgkxjExiM1o+FYO0qrw3PqZKTThrN
         8mCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyztebD2GeAWhLC2mBt/C8VquFl5s7Isto6FDbqhyM2CLY/6HCp/FZzO2Cr9cO3xAVxQT96I6P+4EZt6mB5PA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyirHy+TWCFf0k+cP32mr1FTkwP2hhho+EA1ksmX0TWDanr57lI
	+OKg8foaelqFcz7Ke8tXFjwZ6VFr+HlW29u4u024Ddj746o6VGJ+qTg2MhM/SEJFSSv+IpbUPPG
	WuYt4ycRD+s2b80sJlkyCMwh0HSKhy7Q4UReGc0rk3VWQHgaBaPoSVlLBvlHpY6LGjtC8BZqZPf
	1VN1Td9HtVB08WNyPc2/l+GtnxYUI9Dg5qKgI42t9fUj2j
X-Gm-Gg: ASbGnctWoG81GY4WqEOR+7EcH5I8ZIpQJ8LfRyVhlcd7J14mAJkj8k8yYgS49uKeehG
	iU6uqsok1IS2QyCpAh7voTQU7RedeCab6bSLj0I6ewl+iddd6HWZffsnmL6O0qZ4Vz2IatLmggC
	P210qnOgZQWJSse1Hj+3VmMbgz/CPp6bYsdbWV5DeKDfTuu+bGCmYXBQ==
X-Received: by 2002:a17:907:7f0b:b0:b46:31be:e8fe with SMTP id a640c23a62f3a-b50aa48c4f0mr2434553166b.11.1760382693338;
        Mon, 13 Oct 2025 12:11:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdZSlJjUKGUyEQeXbLsv9VheuVhvq3shA+CFJRXSerqAlSqVOk9p/8bvz3PxsEytGYzwrMZIP2BUftmKkR2Ws=
X-Received: by 2002:a17:907:7f0b:b0:b46:31be:e8fe with SMTP id
 a640c23a62f3a-b50aa48c4f0mr2434545466b.11.1760382692352; Mon, 13 Oct 2025
 12:11:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926193035.2158860-1-rrobaina@redhat.com> <aNfAKjRGXNUoSxQV@strlen.de>
 <CAABTaaDc_1N90BQP5mEHCoBEX5KkS=cyHV0FnY9H3deEbc7_Xw@mail.gmail.com>
 <CAHC9VhR+U3c_tH11wgQceov5aP_PwjPEX6bjCaowZ5Kcwv71rA@mail.gmail.com> <CAHC9VhR-EXz-w6QeX7NfyyO7B3KUXTnz-Jjhd=xbD9UpXnqr+w@mail.gmail.com>
In-Reply-To: <CAHC9VhR-EXz-w6QeX7NfyyO7B3KUXTnz-Jjhd=xbD9UpXnqr+w@mail.gmail.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Mon, 13 Oct 2025 16:11:20 -0300
X-Gm-Features: AS18NWBRpmVXsqMwV5PkEQwwAsDGsJpwgtFtU7bYTbHsTAe-yKFLi7W40fQv0tM
Message-ID: <CAABTaaBO2KBujB=bqvyumO2xW=JCxKP0hc87myqcLF3pbxSorA@mail.gmail.com>
Subject: Re: [PATCH v3] audit: include source and destination ports to NETFILTER_PKT
To: Paul Moore <paul@paul-moore.com>
Cc: Florian Westphal <fw@strlen.de>, audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com, 
	pablo@netfilter.org, kadlec@netfilter.org, ej@inai.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 13, 2025 at 3:51=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Mon, Oct 13, 2025 at 2:48=E2=80=AFPM Paul Moore <paul@paul-moore.com> =
wrote:
> > On Fri, Oct 3, 2025 at 11:43=E2=80=AFAM Ricardo Robaina <rrobaina@redha=
t.com> wrote:
> > > On Sat, Sep 27, 2025 at 7:45=E2=80=AFAM Florian Westphal <fw@strlen.d=
e> wrote:
> > > > Ricardo Robaina <rrobaina@redhat.com> wrote:
> >
> > ...
> >
> > > > Maybe Paul would be open to adding something like audit_log_packet(=
) to
> > > > kernel/audit.c and then have xt_AUDIT.c and nft_log.c just call the
> > > > common helper.
> > >
> > > It sounds like a good idea to me. What do you think, Paul?
> >
> > Seems like a good idea to me too.
>
> A quick follow-up to this ... when you are doing the work Ricardo,
> please do this as a two patch patchset; the first patch should
> introduce a new common function called by both audit_tg() and
> nft_log_eval_audit(), and the second patch should add new port
> information to the audit record.
>
> --
> paul-moore.com
>

Thanks for the tip, Paul! I'll work on it next week.

