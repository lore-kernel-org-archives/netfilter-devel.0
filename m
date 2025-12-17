Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BBC350A28
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2025 11:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765971611; cv=none; b=k7gw1hpnlBdk4HlsXL3w8+HtoMN96TzLsJdRpZa+RllnqO0IPqNVGfW24dcQhIbOJ1j4r9q3k5847YxzhVf3JZuHn0+wt/M8/gn2ENMiZxNeZsCSMEgx0UrGXNsvWFVwyQOgUJ+24MTQL0FYsbiWJJa6t1LLwXzVFMAsGKiIYeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765971611; c=relaxed/simple;
	bh=1U/ikegZolI19iSMBScb8qYGCyxWSZzi9ToYMoe2yjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=riVZCKLKC+gjQTM2f9uT0IGGawKI5FMqhpYEMq5d5UA+6PXL8iGJXd9fr/tGVKHkbmY7CcmQZFOluDEZH3DWFQChvzx6fhHHFcRSbG4LqTjwpg+tK0T/Fp4vyKpvSzjYzydlgLLphKCTZhzY6Rv+0mWqpps5cI2IYQv9zzusdNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ma+MEC1f; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfRMzg/j; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ma+MEC1f";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfRMzg/j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765971608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nx9KS1++6SSB7P8E1Ya6NVI77CW43nTZBnj1FAdXZIo=;
	b=Ma+MEC1fiY9bClT6Ieu3d54ueQs0MGozQcZdmkP/aciU9KvMdl953VmGQwPbdwGxEYfuju
	zYN57CqPqA2eKSv5kdB4fGJAkcl8DaKBkPGLb5PYdPnD3vYokdJSrH+jWhEJs5htp5lu7Q
	2F3DMennXf7dmBtpXVyrx1vIW3OB0Wk=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353-wLnVFjuJPWCskULGPKXIgQ-1; Wed, 17 Dec 2025 06:40:07 -0500
X-MC-Unique: wLnVFjuJPWCskULGPKXIgQ-1
X-Mimecast-MFC-AGG-ID: wLnVFjuJPWCskULGPKXIgQ_1765971606
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b79f6dcde96so1195058966b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2025 03:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765971606; x=1766576406; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nx9KS1++6SSB7P8E1Ya6NVI77CW43nTZBnj1FAdXZIo=;
        b=PfRMzg/jjt5SHYV78KHDhSvtRZvlGU+SBbDIbUU/Lh+WlrbrXnjipa70RcmsXl+nwE
         fgNbBtbyD2mfzlTwYZGU8yxSFIjcPmeXADuZN3eJLhuHKwZhKodanTT3/pMxvc57j589
         XI5YUUvcq3CB7oCZ1c4yC+8VvfQe58nzF6OOAnElgkCRyu4vK46RS+04rqC3R4wd53/B
         +4WPK0ulMLz8+QJsEosX3YfdqpnjKwipOkZq3AiCGt9WSx15L83efMKiQ5rzTeDv3O5S
         t2Rsl0QCpET6btEWTZcEmTS6hvzYd4KpzDx7Gjn5kVd+fXJnP9jDsN1U1AXnrt7jxWTr
         HTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765971606; x=1766576406;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nx9KS1++6SSB7P8E1Ya6NVI77CW43nTZBnj1FAdXZIo=;
        b=AemU6Zp8G7A61lQX4ctlgHLbvhlDm0zfDOgMTE9DvXhfiNPGWjRryc7HLre6VpEO5k
         eY35OXFKBL8SaeBvzjjFFAymlmDpeLQV0oJwnYQLx7KcI88WPwcnBpMgxr+rYqM8qm7d
         Z4v5iBRgi1/poHvk1kcytdXS+gurtrOP1/mPtdR5YZpfNpk6b2ll8S6M5+MCAgoVO/u+
         5mL+rCbevZHY40MAqiAPACoSJOJ/8w7zfp25IT93fDJsI7gabMGBvdhHn2I2S1Oj9JPB
         RQceHLYTXnkYEhI0VFoabcNQ2AzOforoLWMt4OsSeIJN3zOCZ2eVT5sVV63EaP1pVlrb
         y8mQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSrYiPAT9gm9x9XJXZ+Yw5efETNSh3f0TTSK7rQfSaIomVxt/l2WDFhXdPEEHsxQ7fAyipeGV5ByhptBuUG1A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIDrIl13xF4Z444+ysZMJybo9TIUiGeBCUmoaTjrKAWBKP9vPa
	AvT1LrMPTe5KR96B+XB4zCVCDRGnKIdB4b/mwnQ4vKZyz0Z10y35qbsEfUGPuwoctHN1Eq6grzC
	6T1oSUilfqNg7BYn7ZxBZRfOIX3PwXN3EH2WPFXzXIlLv70xJLvOWD1nVqPlDfnV4x4LWdXB9+j
	oW7TpXGFlfHnOckwT+oygDz035IxHzQMnkO6iCj8QIeo6v
X-Gm-Gg: AY/fxX7tdF8TZoqLXXIvSsHFa9KiOg3pTayB7sr4Y30rkzGAPdz2ovXA3M3dw/9pjbe
	NMyZ+RgFUgqgMdbDn4cPhF1HyUrh8dsN6A8FZxI8He75M3T+Q3z15eOyZQpPsJsBHYyAiRdG2tt
	bEK7D8xuvqdPp7aculCnCQJVgSc1D0E/ZEAywo4qZU+ual+6eR74JqRjgEgddrs7lPiggF+de0/
	rcr4/gJQY+4Mqe+LRihGSM0GA==
X-Received: by 2002:a17:906:599f:b0:b80:1a97:64e4 with SMTP id a640c23a62f3a-b801a976d97mr15181366b.39.1765971606149;
        Wed, 17 Dec 2025 03:40:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQgvZFBLTmM5DCp1T/Ugk2vXHsXNq0G13zpH5cgH6CF9AJZTB72OD0VvTOytodrDludyMUO4HVickRiaZUuGE=
X-Received: by 2002:a17:906:599f:b0:b80:1a97:64e4 with SMTP id
 a640c23a62f3a-b801a976d97mr15178866b.39.1765971605695; Wed, 17 Dec 2025
 03:40:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763122537.git.rrobaina@redhat.com> <CAHC9VhR5_wHWpSXVapFhswqnUw1x0M3SCSyD76Kad8AMi8xEeA@mail.gmail.com>
 <CAHC9VhQtYSpw15JM_1Yp77E1nBCuR5xeiE_TzTVuZ2_zr2W7wQ@mail.gmail.com>
In-Reply-To: <CAHC9VhQtYSpw15JM_1Yp77E1nBCuR5xeiE_TzTVuZ2_zr2W7wQ@mail.gmail.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Wed, 17 Dec 2025 08:39:54 -0300
X-Gm-Features: AQt7F2qMl3QTmA3xsM1Taw_PuGZxuhOIdPpD10MJZzwhSr-g1vsDqMI_lT_XZX8
Message-ID: <CAABTaaDyFA+J7HLZhK9=uO_jaE=BU4pcWFa-4mOaa-u0NymgoA@mail.gmail.com>
Subject: Re: [PATCH v7 0/2] audit: improve NETFILTER_PKT records
To: Paul Moore <paul@paul-moore.com>
Cc: fw@strlen.de, audit@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, eparis@redhat.com, 
	pablo@netfilter.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 1:10=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Mon, Dec 15, 2025 at 9:07=E2=80=AFPM Paul Moore <paul@paul-moore.com> =
wrote:
> > On Fri, Nov 14, 2025 at 7:36=E2=80=AFAM Ricardo Robaina <rrobaina@redha=
t.com> wrote:
> > >
> > > Currently, NETFILTER_PKT records lack source and destination
> > > port information, which is often valuable for troubleshooting.
> > > This patch series adds ports numbers, to NETFILTER_PKT records.
> > >
> > > The first patch refactors netfilter-related code, by moving
> > > duplicated code to audit.c, by creating audit_log_nf_skb()
> > > helper function.
> > > The second one, improves the NETFILTER_PKT records, by
> > > including source and destination ports for protocols of
> > > interest.
> > >
> > > Ricardo Robaina (2):
> > >   audit: add audit_log_nf_skb helper function
> > >   audit: include source and destination ports to NETFILTER_PKT
> > >
> > >  include/linux/audit.h    |   8 ++
> > >  kernel/audit.c           | 159 +++++++++++++++++++++++++++++++++++++=
++
> > >  net/netfilter/nft_log.c  |  58 +-------------
> > >  net/netfilter/xt_AUDIT.c |  58 +-------------
> > >  4 files changed, 169 insertions(+), 114 deletions(-)
> >
> > Thanks Ricardo, both patches look good to me, I'm going to merge them
> > into audit/dev-staging just to get some very basic testing, but if I
> > can get an ACK from Florian on the patchset I'll go ahead and move the
> > patches over to audit/dev (feeds into linux-next and the next merge
> > window).
>
> I just moved these patches in audit/dev with Florian's ACK.  Thanks every=
one!
>
> --
> paul-moore.com
>

I'm happy to hear it. Thanks, Paul and Florian!

