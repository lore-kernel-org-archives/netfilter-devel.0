Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539FE53AC
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 04:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712551122; cv=none; b=J3phoCdQqR5fIxjsdYwQHxA0DSCrFyS4M2RZ79A2tOzweivwVvw1JWQoqDmvf+9vNjQ4Sp2cZEsq10DkW9Q9L+IqPAV/NIjYSYrGsdZJsrI8rJJJWQQaLh28nDPDJvFJEr9o9QvdzidVZh8Bb4V7Z5Kvc34fNV7zA7C680ckBgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712551122; c=relaxed/simple;
	bh=tmPuVxZ53pZMJV6ZRhBhkk0MJm20hw2mCYsNa+aWn5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dvuU7lZDV9BDNeEq8ythRPkXS2eSJUjfWWACDlVGCrq8CWZSugy41PNtf5n/MlaILnvGLkBm6nada5lTYIq7ySS1jYHmDdJeAGEuiyZ0Waps2SZJ+qII1qFWrX01Q8D2E+p/DLfHk+ASftLZImIbnE394fCBR3eNgYwZqAhtdqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OZaDluRm; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OZaDluRm"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-516d6c1e238so2491034e87.2
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Apr 2024 21:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712551118; x=1713155918; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tmPuVxZ53pZMJV6ZRhBhkk0MJm20hw2mCYsNa+aWn5o=;
        b=OZaDluRmnUroSwN4AcA+lX5ZcWlsVCbsdqROmRTZOkNETs4OdXnwjsVWNk/NrMTRZP
         v+4IaUPJFaaPLKQVbS8AFzZPYoaej8eTKhdQAFOf88oWSzx7rouPpMlj2W4e6QU71rv5
         4q7Nf/h+l13HxXbyvgqOUOgDKeGbK7sF5fUv+uhVhUb56I1F5YF7VRReUsZelEjfUYGK
         tQLZu1uEMAmume/2jv1cfp7pqp23bVmhoeSeNLygsEL9QNdsBICDI/s6jhj4uKFcL77v
         xImo9Ve3t3jM8+pMoZt0zhd72ByOawaGMIPkY3eZLpEmZGYgoFiJx0oo23hqEltDg/wM
         P/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712551118; x=1713155918;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmPuVxZ53pZMJV6ZRhBhkk0MJm20hw2mCYsNa+aWn5o=;
        b=jpJ35se2/Oo+ca3LNrhFm2kJH86QYZx9dHsD+olEJ4Yzs4iu3Y3Xzfc0wKwry4I0+W
         uQ+n/T2LUMwrOT7My4VS8AsAcWaLh6gVU47C2c/i1VbUpZtuXqFicWgz8q+ZjJtyvNmS
         Hd00mmRjpPFTjHYm0N370a+SNWRTaMb80FmzHYOguT3VXupIy1lKvAm0e5V893uAuyyJ
         MPsIwWTwWa9E6l2Tik7vgKpwkwvfZxPAu+tKE040GumOgfxc2dfgRQC3kdS7phsM4z9T
         UGBg99uuwDoR9BewgpCrE1Y5pPLVzw6Mr2BYbhh3876b632EyPFA0Q7FwlRzgirV0gsD
         nx/g==
X-Gm-Message-State: AOJu0YzlYCylnkUjJehWs7MerSnUjywdGQyeaEM9KP/nxJWagv5DwY0E
	1W7eGXdwXw27OtqNCH4mqWhH8ExYTJ9H57v+2I1H9LfUaudxRmskg0TjsL66hu2jC00yClyxtkf
	lNqL+wTumvFdp9MHZEarROkxsSX4=
X-Google-Smtp-Source: AGHT+IH3i86WEaHiLaMPGMXHcnoT+tUM+IjOVLMqZaqKp+AB6WAoY5tBza/QviOGFlV2Dav0WsMeFZZfxLVLVkduLwk=
X-Received: by 2002:a19:6908:0:b0:513:ccda:bc86 with SMTP id
 e8-20020a196908000000b00513ccdabc86mr4404672lfc.4.1712551118309; Sun, 07 Apr
 2024 21:38:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407015846.1202-1-dinhtrason@gmail.com> <20240407171840.GB28575@breakpoint.cc>
In-Reply-To: <20240407171840.GB28575@breakpoint.cc>
From: Son Tra Dinh <dinhtrason@gmail.com>
Date: Mon, 8 Apr 2024 14:38:26 +1000
Message-ID: <CA+Xkr6jMNpXTuFBJ+yWHsZdezkVkjsLKHH8-6FwAtS1Sxqu6bg@mail.gmail.com>
Subject: Re: [nft PATCH] expr: make map lookup expression as an argument in
 vmap statement
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Apr 2024 at 03:18, Florian Westphal <fw@strlen.de> wrote:
>
> This needs at least one test case.

Thanks for reviewing the patch. I'll try to write a new test case for it.
