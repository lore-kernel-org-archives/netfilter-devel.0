Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F42EBA27;
	Wed, 13 Mar 2024 02:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710296681; cv=none; b=dhiMPqzV2rvCgmQ545yo/r1YI/jbZWKKrAI6hsAQCF6BZhl6zCfUIzCz187WXLTGh83bXtN+jfavb3Fn4SBaattZcThrVMbDr+YNG8wdGiHrIuaHWCMIxb5rSRHWiPuNbPVBT4ZC5zBob6j9o2FXrFLWlyzS505Q8m/Bg7gKpzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710296681; c=relaxed/simple;
	bh=KFPa00VRryx9QwPhbJbgdVn/j9tCbw0LyrIBy70kHrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mry6G1y+s2aGi1ZdN0CDI+ALFZiGFk/umDrahocLYBs5lyQghNuRU9RDzuQ9vNzcCdIt0F6sxRRPXt06yoKh/OH5lBdmWnOR5OsS4UAafrDN+D6sAKflrf38GB0kqYkqsIy7335SunGI6fNej/F9GbNfGBzrjUCZQ4C4glwJh3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSvXNAkr; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSvXNAkr"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a45cdb790dfso637714266b.3;
        Tue, 12 Mar 2024 19:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710296678; x=1710901478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=01XTEZyUtJlNsqIk7hxNBmVSkuKV7vVHLizQnlx0UeM=;
        b=kSvXNAkrGbvoGonignBcz9eJ74tEctQOD2X/fx9EP0+wJ6T6dijpxV+0zJwYtnHIcl
         DeEqBCdeRKgOncactUiERNRwYbwsOHD76JjqQl2s+b7yVfBt40aTbD6mzbvElZfLEZGA
         AB4V2kokdXnvXNvctVcQxYsQ9BDuPUEduGV2MFIzOvsul2EWVsiG8CGukE0fLP7Kb1u3
         FpK4UGStdpKZ6QcIQvBXzCUDALGzvVvlNvaMxGVSCIW5V7IoxRUtAMxn4ZU5upO+Ypaf
         E1w+6fZGzLkVsYNepDi5Ti2vA+LylXmvkWXPYBxRsSmjO1oOtu3G6rbPozIBJBE5PazK
         Dd3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710296678; x=1710901478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=01XTEZyUtJlNsqIk7hxNBmVSkuKV7vVHLizQnlx0UeM=;
        b=UtrJp8VHtYm3EWiCb+oNqnF+6wPtZs0rRD+9CYDdV+YM1j12ZpYFnkwkitifB/yR65
         c+IDj+67FVXoc+li9w/NInK0osiKUemJCLSzJy1y2wEDtx1OD49/tMic9qjhbNAStkur
         Y/FTh2dA+K0fGQBpdWm33UQEfKZ3N0OkUFigBZwLHnnTzlAaCaqVPcMCtwwwNVz/mY1I
         +wY8487+Xr8p8aVG94rFbQ7NFBRvU/shvaDFH/nvaiLNPymkN0lUPhbSaj0nrhBdcqTW
         IKFE0KWpl3YMz/v5Q7h1hxp11GqrUtQa58LKE6QhPiS4HT/D8FiZ6thPlHu6jBJwSfWl
         M7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxY1J6qyYhEslN7JjMUzsJugxJbpyI8dQQcEF7HZdXmlR+ylCdtk+nK/QQrg2WhawTe+uZoHe8IWv4xm8i9yWW5808/dxcjhWjDo611Z7IjQBdBAlfSQxSnDPNLbktV9dvKmg9FkO6
X-Gm-Message-State: AOJu0Yyv8Igp8gm+iis8VNt/DIj6LyPhr4EzRDHcQxPES9GTs6v5H0DT
	LZukdF3Js+ytxN1QWcWXmKOxTopL8xhMDr3li1QwSOiV6KY2VvmqEKFyFRBRwBXBGtKgwiq11oY
	2cBwFtN1JpTjRxt87rLtDrO5ROec=
X-Google-Smtp-Source: AGHT+IHIzSyAJgaNLMKnYuXYEtnMLdiYuLEdyEH3JIKuQT9HFR0xFAjbgb6SEtvF/Jc+ITAUnd7m7tDnLjxuBnlW3oI=
X-Received: by 2002:a17:907:9406:b0:a46:264e:6fba with SMTP id
 dk6-20020a170907940600b00a46264e6fbamr6373603ejc.34.1710296678304; Tue, 12
 Mar 2024 19:24:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240311070550.7438-1-kerneljasonxing@gmail.com> <20240312122417.GA2899@breakpoint.cc>
In-Reply-To: <20240312122417.GA2899@breakpoint.cc>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 13 Mar 2024 10:24:01 +0800
Message-ID: <CAL+tcoAyiGcGAb7aqK+jhf1BeSM8BeH1ZTbzvLVxd_vNGmSVUA@mail.gmail.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to
 reply out-of-window skb
To: Florian Westphal <fw@strlen.de>
Cc: edumazet@google.com, pablo@netfilter.org, kadlec@netfilter.org, 
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Florian,

On Tue, Mar 12, 2024 at 8:24=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
>
> Jason Xing <kerneljasonxing@gmail.com> wrote:
> > I think, even we have set DNAT policy, it would be better if the
> > whole process/behaviour adheres to the original TCP behaviour as
> > default.
>
> LGTM.
> Acked-by: Florian Westphal <fw@strlen.de>

Thanks!

I wonder if I should repost it in two weeks? BTW, what about the
status of the other two patches[1][2]? Should I repost them after
March 25th too?

[1]:  https://lore.kernel.org/netdev/20240308092915.9751-1-kerneljasonxing@=
gmail.com/
[2]: https://lore.kernel.org/netdev/20240308092915.9751-2-kerneljasonxing@g=
mail.com/
