Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B221B7F1
	for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2024 16:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709396452; cv=none; b=FlGJZ4MPVy70icooV6efaBPYA58wNkRBJQbZfzFcMfF8OXlUUCqCJhDNI4ofu1mKSYIwwp42Qmjxa2bSFyzF6QkmJlCo9/EHXfmat6mbirBm9tfeQlRmXDA4cemCDOVEJ2l9wO5JG/386fK+/Cro8Elc5wta05Kvko14E7Rkh3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709396452; c=relaxed/simple;
	bh=mO2458eLhYpI5ep3V+/WRmHznWUSaljp0ND1z42Qfn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pcv1EhMgqaZ400A+Jg9hp3Az6S9zhhrU8gcbyGRWSQZQlI4/QxiJGzM95ZD20Cu8ZH2fpDDUIxD3CIPqBdmeWX0w6cueeSSnckdr30Ug/fZRa6WwDm/pVRX3YMfG9CpLDMyXQhiqdeG6TyMEUCi4nxTs/aimpRurGkZyuTIgsDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VZJft6hr; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VZJft6hr"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7c7f3f66d17so150190739f.0
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Mar 2024 08:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709396449; x=1710001249; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0Obinm/Cx+XhpT5tnUS0FsKXIFncC85hmfsjXpiTG8=;
        b=VZJft6hrDZp8Lz6MhvdjECYbgqINhgFICOabKINB0F8KBClAjhdU/yAPSEYvlVS1+p
         Oz3iMV8scv8gM8laAyMY2/mJV1neKqbgft8cn+Fog3/uGGdpZ11BsT52eXELIwTkR/+y
         ZjN9pFbueiaElauFi7rsXMQJkJAeS8PKp6gmOFVao/E5NEC5BN0C092jhTt8db2Tao71
         SrIBJrnVovCtKs9GpvcjqaPFhS6K4k9geJgBeKNwBIWuRLMMwfHeMj21pZNJLsaW+6/H
         aEE2ct0vuTK4rmHzATR8O4bbS6rjEqS0D6TZhitKmeXIyMBPZmheIMxbyAoFdVJ4yuRA
         p93A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709396449; x=1710001249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/0Obinm/Cx+XhpT5tnUS0FsKXIFncC85hmfsjXpiTG8=;
        b=sE9og1zZGENWMvvlm3W93dIZBhOqRNtbvKEdvM5ZjQICaGpjNleirXdt8MTeagnEnC
         b8irXkuwZIqlGkex/rRYRBpazutY/KOjX0DcMFxHDc6s+3VJUl6V7mx0HhILtdOE0IeT
         dIhTEzH7v35vTZH6bS2QTJbVWux/ND5FqqTgZjvNtm627sh5iXqGzpb9vm6dDwj3sSuF
         KsxNcdRisM4upQn+4OHjEOGu5nDB9Z0JtbJm9/k6fyV2rrH3Y+M3q8K1R4vrbRZ86tEo
         XWzji9+avFqH5f7yvply5ViGXLVPYEYUpjvk31kj5HMDO+/W3uyJOM90YQPC9MFKuL5r
         IMnQ==
X-Gm-Message-State: AOJu0YywDJoK+39YaIPKOjG6IbSSQDe8D9oYAthJG2+y1V/aowzCu8fY
	+sALA8eGlWLfdvef4YTxPIkVNc1JhC9foxnowQIUIr598D+ccO8uSyykXvZy8RtgPy29rdCYSvX
	hLsYfu14fimdwqpoxBg5RTJGrQbMGFrN52Cs=
X-Google-Smtp-Source: AGHT+IGhitBOwbeyw/J9Z1MmWkfBBsXU6V2ufKVp3Qm0Hzcsz4NJQ5ZQV2LgEp+8zuxLYbsDIIDxJxZ01HO+YL/w2EU=
X-Received: by 2002:a05:6e02:1e0b:b0:365:b29:3fda with SMTP id
 g11-20020a056e021e0b00b003650b293fdamr6763730ila.24.1709396449705; Sat, 02
 Mar 2024 08:20:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301170731.21657-1-donald.yandt@gmail.com>
 <20240301170731.21657-3-donald.yandt@gmail.com> <ZeL3HJRhC3D8yMlR@calendula>
In-Reply-To: <ZeL3HJRhC3D8yMlR@calendula>
From: Donald Yandt <donald.yandt@gmail.com>
Date: Sat, 2 Mar 2024 11:20:38 -0500
Message-ID: <CADm=fg=TbKc8D-nzY7kA=NT7Fi_ZJ7ZLA3uJB-7+bK2-s5W3FQ@mail.gmail.com>
Subject: Re: [PATCH conntrack-tools 2/3] conntrackd: use size_t for element indices
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 2, 2024 at 4:53=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> Hi,
>
> Could you describe why these are needed?
>
> Thanks!
>

Hi Pablo,

I mentioned it briefly in the cover letter and explained why it should
be used in the commit message for version 2.
If you require any additional detail, please let me know.

Thank you

On Sat, Mar 2, 2024 at 4:53=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> Hi,
>
> Could you describe why these are needed?
>
> Thanks!
>
> On Fri, Mar 01, 2024 at 12:07:30PM -0500, Donald Yandt wrote:
> > Signed-off-by: Donald Yandt <donald.yandt@gmail.com>
> > ---
> >  src/vector.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> >
> > diff --git a/src/vector.c b/src/vector.c
> > index 7f9bc3c..ac1f5d9 100644
> > --- a/src/vector.c
> > +++ b/src/vector.c
> > @@ -23,9 +23,7 @@
> >
> >  struct vector {
> >       char *data;
> > -     unsigned int cur_elems;
> > -     unsigned int max_elems;
> > -     size_t size;
> > +     size_t cur_elems, max_elems, size;
> >  };
> >
> >  #define DEFAULT_VECTOR_MEMBERS       8
> > --
> > 2.44.0
> >
> >
