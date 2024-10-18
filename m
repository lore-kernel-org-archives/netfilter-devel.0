Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEA610F2
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 07:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729235188; cv=none; b=dJOq2mcsHJW1HEpEm8w8I4lM8sfiR35U6FGVlUFgvxF5EJ5+vREZhiFmGuCVjNz5tGU9nn8D4PQ+dRbVezZ3KiLJrJjdcEzbfk5wACykDjimjoYH+iotWhD/DpS/szeGkQoajd45bEPocJBLVkxBVqc3X6efp99P/ocPSEKHpA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729235188; c=relaxed/simple;
	bh=+LXYPc6hzDz1apqRx1+djjFCpV4f5yKQDtoRJZwRfQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=td8sQBNG9SrCLM1bREkFSRXKIPM9kFYXD7NTPFa42cnqH/3/zdRs9K5ih9Klj4bjj6dxBaJ3LmKEXKeQ3UgG1Dtjmr3B3UP+Ra284g9snJldiSLaosDcM2GQJKH3LS7MT0YMJCfU2KY1utXNEhSgxUC0DTVS/4e/pluBEXH78ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iQZsvUnU; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iQZsvUnU"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb5be4381dso20276601fa.2
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 00:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729235185; x=1729839985; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0sDh29tgBDN/eY+37mHiEnkCsD41OoxLIQqVYqiE06Y=;
        b=iQZsvUnUysgG3+Zmnrbp5TRbC0CZ3fHEb/lgnOGF/jnk25GYxwi2uCAnB17D1LldGf
         nixY9VIT0l4P7YQOKfsz/+NgUwv8F/YkhhQ57zM9TZMxJxdmua92yr8gB+jFmfb4Rk1I
         zjGNW0LwkXZsaXFdzgYY1lV8Yyn/mjqMg4ZtC01kMnVYaOMQwx5vLKACIYfJIk5jUwLm
         hdUnWmMtkGnql09wFJ1a48CKD9nZMz15NL3g8sRi08b6bqOhhwcxqAP0BkawJ4r0zEUf
         jeBDJ1Ryb3+/pVgLu19to+7/sppIfeDQ4SmR8HqJNh7I10oZ/bGGFfedihPfZZqn6oN6
         XFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729235185; x=1729839985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0sDh29tgBDN/eY+37mHiEnkCsD41OoxLIQqVYqiE06Y=;
        b=kPt5IOORfHqzWTCuTfNGFTYHovH9U+5IjcpsVOrG9/Bkss34FLI4YcWSDUrndEkVTU
         Af1be9jBBxzShaoE34M3sW51ICPvv57TnYn2QduOI5twIwnjEvpAioZgYZqf2qVrda4c
         zLalhfk7nSkESdvJZeSqcJsU807ZTHxOA/0uc3Ybieyh2oUVMhF2Lc8EYhGOoPRXhC80
         zjgItzPtuNzAKI4rh47Wfd8n8ZVGLBfhWbXH6kvPxu9CEE4T5xOc0dHpv9O6ZKWdhhIY
         heuQH4xm5buoO3EgRwhSvCcJUcdhEwfx3mAUhzUdRwsUFLozhLoljumleNyN45n7H1hK
         VWrw==
X-Forwarded-Encrypted: i=1; AJvYcCXuJjj/X9HuWBl0j+6Hu5PvuhXvqRgRhSqoZ7wD0f4YWfJYfGwAy47PVPf6hdyBwGMXmm6HWwiQWz1SpiEB3Xs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxhA+pdN8lN2tG9Uw/CIEpYOxemEm6dvznvCul9YFEcgK/+Tvbs
	ikS9wdGTZWAGh+KLU3CINmZm8LE/paWf5DccnOQK9oCfoOdx1U6AeVK0GXoIm5KaKKl9qEMEarT
	smUufLgj284vogrd1M9/Vgq0AWOHHqcmXMTwO
X-Google-Smtp-Source: AGHT+IEID67jPLeUKh1bY4LIIgpCPYkyWpP4dlriYtHZlSy5ZWcIWo8EO6dx3Mc7MG9Ne0bnLTtz+chQnd/X6Cdop5k=
X-Received: by 2002:a05:651c:1543:b0:2fb:65c8:b4ca with SMTP id
 38308e7fff4ca-2fb83226659mr5746961fa.40.1729235185149; Fri, 18 Oct 2024
 00:06:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+nYHL-daCTUG=G0CaAMyabf9LkUYa6HnjhUCYLoJTm2FfMdsQ@mail.gmail.com>
In-Reply-To: <CA+nYHL-daCTUG=G0CaAMyabf9LkUYa6HnjhUCYLoJTm2FfMdsQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 18 Oct 2024 09:06:12 +0200
Message-ID: <CANn89iJ4EwLU2H4CntDbufc3ZRS9-BZrO0vXGxYosx4ELq8PgA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __nf_hook_entries_try_shrink
To: Xia Chu <jiangmo9@gmail.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2024 at 9:00=E2=80=AFAM Xia Chu <jiangmo9@gmail.com> wrote:
>
> Hi,
>
> We would like to report the following bug which has been found by our mod=
ified version of syzkaller.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> description: KASAN: use-after-free Read in __nf_hook_entries_try_shrink
> affected file: net/netfilter/core.c
> kernel version: 5.8.0-rc4
> kernel commit: 0aea6d5c5be33ce94c16f9ab2f64de1f481f424b
> git tree: upstream
> kernel config: attached
> crash reproducer: attached
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> Crash log:
> BUG: KASAN: use-after-free in hooks_validate net/netfilter/core.c:177 [in=
line]
> BUG: KASAN: use-after-free in __nf_hook_entries_try_shrink+0x3c0/0x470 ne=
t/netfilter/core.c:260
> Read of size 4 at addr ffff888067fe4220 by task kworker/u4:2/126
>
> CPU: 1 PID: 126 Comm: kworker/u4:2 Tainted: G        W         5.8.0-rc4+=
 #1

This is an old version of linux, not supported.

What do you expect from us ?
