Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B2242049;
	Sun, 10 Aug 2025 20:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754856561; cv=none; b=VzID+G5OuyI/jVqUsxGBMZcVnCk153kSxdPfuCbXgQazAEB7+W14842jwhhV4hbNzd153cUrMH0XklOiHyApVvZ0LMtIIF5biCQWN+MXZMVRykygGO96wTKxIBL26aMXCy/U10Uq8t1kw0V8jDsQr1osihoKq05gTwPFHy3b8qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754856561; c=relaxed/simple;
	bh=TJOTMGDzepfJi/+Mv/d7FMhhFjNe7ZBrEUUAV6TOgx8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W1aaYcw3KAgI+T+Ci+vdM+xNgI6Aoe+0Uy0EOd8ZgTQEZVomlyK/au4uYN3gsIvDBLNuid9kzBN0Z/IY4nSO/UTlpYVnTAPfn1LDrJxBWlS4OjqEza8goya0iz7p3PL1QTm+rsP9znt8bYdCD8Q51wQlESK8WqcQ3L2AlYrkkNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BInkjcK7; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BInkjcK7"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3e51dc20af6so39548355ab.0;
        Sun, 10 Aug 2025 13:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754856559; x=1755461359; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TJOTMGDzepfJi/+Mv/d7FMhhFjNe7ZBrEUUAV6TOgx8=;
        b=BInkjcK7OpfK61qpYYKG4TxJcp9K+CGndlzPiFr33VcS4CMUPWqTB2mn5npJdm9LSm
         GM2bzqOs/aCSz5NakDhQrzBrmXjum27s3AtB+LUt0D+lp8CT8PlIrHq2lqqm/UMGIZ0V
         xIViWPQ5hE9d5TyK4AuLS0NF2kX2PlimnwrL1S3dXTSOtAGN+3Q8G98vtBy8takS4pzQ
         cmOoywUu1LKz3UFdvfHTSv9oiLe7k0KNxBc2ApjB47RQJfozjkUJIf/YyIbNthgfUFu/
         IAMBEErXxeQ2yfwW1ZEcC2eufKcnV1hiN+LbFZfWyMzwEMuK4TiY6qkILLA+PJxRsfQa
         MVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754856559; x=1755461359;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJOTMGDzepfJi/+Mv/d7FMhhFjNe7ZBrEUUAV6TOgx8=;
        b=CHJip2ss5qcuUPrhgClhdmHKpAUkq6uuknxwui7BkxcTSiFSjnp7jZwoU52ztg0W0t
         TAB/S18ZXe86QnsrRBlr95oKykKlfSaA3PwdgFDsTsn7JVFGnj8XxidlQbXDVrtM4suT
         wS6vTXkSnqiqQpkn+iF6BkzYzXM7WeD7iXEX/RZl3/mt9WN628rA1y/ViGUi2QrUB846
         VGDhqwhK591FuB4/ZoHJPuhzhexf/JuAp2qkMY0kASk2sE+1KJzPNeU1VF/E5RMI5i1Q
         QGyjWStRVScyL0oHuqMFwGZsKgo1p7LwzKT2qXJjKoHOVYqpLOEiUBWx9C3XNG/dBhiI
         9CXw==
X-Forwarded-Encrypted: i=1; AJvYcCU4EDmKhYbZ0oE4mbco5ULivCF5AOqFBVLHqNhV8WMICtsYQEn6d0dOxTd6+td+PDeQKYIcOWzl6qDyfBLPMdW+@vger.kernel.org, AJvYcCUws44CVyhzNj/m6uOpAfE+FLqfbNsjwBQhCXozHYaWHlps1umyrzOEpDLed6rYdhjoYn5MXMY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWlFvNRKXFJ+xwzejS1hw9TEaKQcMrxbiniEaLY8SETTH+PBwc
	eGBU52lLUToRXqvSX6UVAVwnJL0R+zn5p9jN0P2yFM2J9eXDjK13vfvmlm2CZ08CI0siq6q7xwM
	x+iXGhHiJMYzFoG4z8OuTe8llya9ua64=
X-Gm-Gg: ASbGncuD9vzaS39aKuhVyCyP0JojPMh6ZArFmUUSOYvl/hHkSq2BDAFT1jdziRrVHaW
	UlSgRrlcqpG6HyQMNpz7Yg7NRFeoVShUpm2nE0nHGfbzYU8vO8KCnohxWNMpr30062giOiOK4gf
	XDr/I12Riw+uPCaPUzW8JFnDTueKQm9KIX+DgZZOmdHZhjyIZqzWa23ic5nNJ+Fhk8Tg3xLUItP
	ombAQ==
X-Google-Smtp-Source: AGHT+IGwfDWckglxUhLCF/fClE8+DawINTnviN0EYShtXypJR3bDTibLWawRrQCoG18XLzsqTc8zZlDuFqMNhmdPZTQ=
X-Received: by 2002:a05:6e02:4803:b0:3e5:4002:e827 with SMTP id
 e9e14a558f8ab-3e54002eab1mr113519745ab.6.1754856559260; Sun, 10 Aug 2025
 13:09:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807112948.1400523-1-pablo@netfilter.org> <20250807112948.1400523-2-pablo@netfilter.org>
 <CANn89iL1=5ykpHXZtp0_J-oUbd7pJQTDL__JDaJR-JbiQDkCPQ@mail.gmail.com> <20250807182428.GN61519@horms.kernel.org>
In-Reply-To: <20250807182428.GN61519@horms.kernel.org>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Sun, 10 Aug 2025 22:08:43 +0200
X-Gm-Features: Ac12FXyr8HUMyyUALTEQ_S2ZQTqlVgmX33sF3zQE0waMH_DIswA_kutWFOWww_E
Message-ID: <CABhP=tYWMVvVoMoAzCYnPZAyCHavojy1cBBf6G-jd5=ivzm4TA@mail.gmail.com>
Subject: Re: [PATCH net 1/7] MAINTAINERS: resurrect my netfilter maintainer entry
To: Simon Horman <horms@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	netfilter-devel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org, 
	kuba@kernel.org, pabeni@redhat.com, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"

> From: Florian Westphal <fw@strlen.de>
>
> This reverts commit b5048d27872a9734d142540ea23c3e897e47e05c.
> Its been more than a year, hope my motivation lasts a bit longer than
> last time :-)

This is fantastic news !
