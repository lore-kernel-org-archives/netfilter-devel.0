Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F431DF72C
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 20:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758658305; cv=none; b=WLOnNPIic3RFYwsgpojK+LvzE+Yn7UtZnEBOvl3SUXzDdueb3IX2ORAyMEWBGzCPv+VXDFaXjZraPQzQ7EFavRduDRydG7uC7BG8Ovvrf/pbq10lZbAH5rMROimFKVHk5HPRL+NlzmerTDyJgSZHPfalobQPSCL6Yu34m/GhOdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758658305; c=relaxed/simple;
	bh=JTP+YEG1q5M0peS7PLFW88111RMYmHr0walTvZYiwtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AL+DoURdiolbkOeu7GaNtulf8HQvw70dunbLdaTaAsyHBXETiGyWKDf2axtgELZ4Aa8mDJxZ9DOdLx43D1uHV34AFo8eXAg/0ULoZy2xTgDloc5mERKB0kBaOaiAKfAO2p36BNgBTEnF+R9yMitHI+wAus3n5pLx+2sIChcChKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=FbT1835m; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="FbT1835m"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3307de086d8so5351049a91.2
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Sep 2025 13:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758658304; x=1759263104; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUa4pObT86h1jy2D2nCUjbk/1KGY1/f7404WMtXBXxs=;
        b=FbT1835mijmeaAO7VocKZXUr/Q6icQEosDqYzGJhWdi9A0CqCqjxDYES3BkFKmnjex
         x5FcFRkD3x9ARqqa8dUjPYi26bvgQ8MLdbZRXi1vd3GUgq8HA2fhmcQf3TbU0ORlyazR
         SNyzQEqw0tUjN3cZ6EpXrGA58nRfNn972erTw4sMiWe/s3j/F2BsEYGMMtPHB5ijdVES
         G82xQP1PTAOKnwPvti1P8tq/JblgcOYqgd5866I0BeEk/az/GEfwKyItp1Z2qI5jx7M1
         ZGPT/SfM7Rqt0M89mVfw2Bw/tJu+4KiDF+eUcFlYfJmJCBnaoAEqbo9bSMh4tVyPEZQ+
         85MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758658304; x=1759263104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oUa4pObT86h1jy2D2nCUjbk/1KGY1/f7404WMtXBXxs=;
        b=RZZ/KVsDzzlzWtOvxi4BhX5meZgfY2GvBnjHMaPAvIvUgV5KqEIPEYXGYi4vDFWXPu
         IOpQ39hHijWz8aLa+UDkPRTyrFV3binUZ6YFWoS+8dpPmJ7dVmcfFIm0yR5FGrSjiwcu
         x6vyh6IhXAIrFTltAdSLUs+yGwDCt+XnNn+iQc/XF2/Gtrr4Pk/glkjR8JEW1KOuGa40
         F4X1kaig0RtFubMWoaYyPx0CYrNiS5fBxv++KqkYnoLgm9UbC11Mlyjhg4C5xX04p9LH
         ejc+UDDtDEp1bWjQfBRJoN4t3g6Pxrs1tQiQFWyj5s3z3hIjCCeojQgfH+cQIJACQbQd
         mIOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwoBpi+tFmMSJN6diuriFNabf9L/l+qDXL2hWoQjIeQWZC6iOJhYSmsfifRGW1InixZ+/x+7suXbYkQ0Rd05I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWKmkVyEHfa99CLqiE9iwJKiLbDstSZesfM46Z6vQZklQVZOuy
	9cK3ihiBKhDSTfHHLKecenaCtvW5I6sD2vHIiEOwGEc6M+2bckmTv69COvkw/mMlwNn7JZ0YcGm
	RU2/2FJdNeCkkY1d65t7U2AKkHZiJu00sIkRAr5w6
X-Gm-Gg: ASbGnctcq++5Et4lrvcUcR4nZIK2CbMQC1qvMxf4b8xuHhHjvnEmKzReBiICpRKX0Q4
	Inv8PGLVrGEu7+Sq8jmVxmY76ltRmlcycRy8h5iMwnN2yb3xLWhTC1NBXOvHmmyI2dplUIsyUCy
	ghd8pRlmmUG3UazNex1mu4LWg4xkbcMz2lL9Kofu5TpfWEJAgy32s0S9/+QEKa3m+OP8iQm8c23
	ofBhU8=
X-Google-Smtp-Source: AGHT+IFfr973oj/4RM14CnqVmiX2e4PE3O74vfP5owIc23SKETKDt7jPpQDpXbNLtGzX165ba6mvtEDFXWf/gKTzrCI=
X-Received: by 2002:a17:90b:2e8d:b0:32e:d015:777b with SMTP id
 98e67ed59e1d1-332a96fd52fmr4559524a91.18.1758658303649; Tue, 23 Sep 2025
 13:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250922200942.1534414-1-rrobaina@redhat.com> <p4866orr-o8nn-6550-89o7-s3s12s27732q@vanv.qr>
 <CAABTaaDaOu631q+BVa+tzDJdH62+HXO-s0FT_to6VyvyLi-JCQ@mail.gmail.com> <aNLcbUp5518F_GWL@strlen.de>
In-Reply-To: <aNLcbUp5518F_GWL@strlen.de>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 23 Sep 2025 16:11:32 -0400
X-Gm-Features: AS18NWAxG3daqHqw7bG2TIx-RGmTbVgn4C6ruCnGJ7CCWQmmYWHkT-7bWgCbXHA
Message-ID: <CAHC9VhSJGas4uUivmOvncyTcC-UZkdqcqkVKPzDAQL8oGkSr-g@mail.gmail.com>
Subject: Re: [PATCH v1] audit: include source and destination ports to NETFILTER_PKT
To: Florian Westphal <fw@strlen.de>
Cc: Ricardo Robaina <rrobaina@redhat.com>, Jan Engelhardt <ej@inai.de>, audit@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, eparis@redhat.com, pablo@netfilter.org, 
	kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 1:44=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
> Ricardo Robaina <rrobaina@redhat.com> wrote:
> > It seems DCCP has been retired by commit 2a63dd0edf38 (=E2=80=9Cnet: Re=
tire
> > DCCP socket.=E2=80=9D). I=E2=80=99ll work on a V2, adding cases for bot=
h UDP-Lite and
> > SCTP.
>
> Thanks.  This will also need a formal ack from audit maintainers.

It's in my queue, but considering we're at -rc7 this is a few notches
down on my priority list as this isn't something I would consider for
the upcoming merge window.

--=20
paul-moore.com
