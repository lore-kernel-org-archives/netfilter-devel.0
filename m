Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8161156C5B
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Jun 2024 09:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717752400; cv=none; b=K5fX+ugGDtmfeCvmP8NPwE2gPE4UnneSwVVsT+uRRWibUAykSChPJb9Mrnui8IsZT33JXjz6RmxCvIqpejpVXO3qW16lzEqMgYt5LBhFiZxADP8fNpapBYGMCiS/6swVA6EclEd7slfgLhs8iX5pYZhPTOMtOUu9IBNr/WVIiPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717752400; c=relaxed/simple;
	bh=vCe9YBcXrbrkkEU4n1P6qgUzd3O5BQ71r3zyOBwNwPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JLVnzATQ9t3Ne9tv1jpbUBhhSIxaG4ueTvTjxaH5A2/ZZMGTleOXOruQZXO4l4UteFEvEMExkqxwbJ3Y+NZEP+ZU1c1f7Yepc+PhFwUqS5NRmsXPYMaG+5kF3kI6jA8aAc+WLvYh1PNvBJHWwxiH69FFzvNCcInb+T9HRSc5pBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G9LgCpiU; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G9LgCpiU"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57a16f4b8bfso14921a12.0
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Jun 2024 02:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717752397; x=1718357197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCe9YBcXrbrkkEU4n1P6qgUzd3O5BQ71r3zyOBwNwPg=;
        b=G9LgCpiUnSvPHncQR/Jz9ZsjEaqBOed+FWYjRpSrenqPGhkThvLxG0vKhwt/e0+R8T
         QyoL5DzL03r0FWYgHi1ODLY9Z2vaJjD60Ojn3M7Ys/NtuXbTGIPQvgCu1rC/n27q/iAm
         vZzOpgqGMDv25Uxv4jaj2M9VFcWcq+1kkhyeMI9HB7MeTTd4SQmfo0iqwiJdT2+74eN4
         ZRBJ10vD0+dRC+n2ARQkWBZ+LmbLOzN1lhu5cWekOSEX/f0a9f6Ic10UaDak5X2OfQ4C
         PN39XPTliVmsKQ4jDACM1XjXPuuEp6dDNvc6sQ7f+44/Iqcdj3McxFIAbh6s468KmSZf
         kDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717752397; x=1718357197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCe9YBcXrbrkkEU4n1P6qgUzd3O5BQ71r3zyOBwNwPg=;
        b=MvVi6Pi7D2OwZcdPfSXgPV14Mdb2JkrGne7XXQFUwD9znOkDZaZG7AqQe1rIi6mGJF
         tllWn/Sy9llWJkYbsMH8gvgoKRTu0F4GF3TNo3II+/RjjvpNG2URDHcW6vBCORrv+zlj
         AZhpxuv/twxcd2gqKesKvsG/abJVp0alKV/rgqDuoVlFYk7R/HTTDCu9khts5RP3lTjT
         +Xp3mzxC54IO2j6Uo+PRwBxyOSnR0pLFXrHqeFrWungKnC81eEeF7p1fspw9EVYjzTvJ
         3PeqFSTG1ngmUG3LrNWwy9zm/eoIhT5wSzrqPpsr+UeIP92CPFR36fpRoO7wv4UHzDOt
         GBvg==
X-Forwarded-Encrypted: i=1; AJvYcCV7VnOMokf7dcjC7gQmDAK9Ih7t8p3XyvfwKn+nXLp7voha9MTuW4aehd9DQThHMHA7VVPmsNOZ8RzFxf/KJG3nzV/rz7ODdsqQoEqAltNM
X-Gm-Message-State: AOJu0YyCB4JGhd/rJZsNKKlX7k7AUuD58fD10wubm7qJikatMgEp4lXR
	ih7ceJDsydZmAYc1XEvNDOH4tB/iUxmy1VgSPY6VPYF4ibXBu+r/Nn3eEFF3oEVh/YjRvlU7r/B
	PslpUTQ4k9eYTqt+6KFyRaxPIrXD2KNyToVve
X-Google-Smtp-Source: AGHT+IEqzLsmHvscS//RfHdNiM1ZmKjMELCt9XB7BoA7j/yHy8tVO4V9PH+EC2vof2t5ju2Rp+xhYWgMAhbF/agfhr8=
X-Received: by 2002:aa7:de0e:0:b0:57c:57b3:6bb3 with SMTP id
 4fb4d7f45d1cf-57c57b37a69mr64039a12.6.1717752395829; Fri, 07 Jun 2024
 02:26:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607083205.3000-1-fw@strlen.de> <20240607083205.3000-3-fw@strlen.de>
In-Reply-To: <20240607083205.3000-3-fw@strlen.de>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 7 Jun 2024 11:26:24 +0200
Message-ID: <CANn89iJuSxe5fD7O_J0ZKXEQsyv64X1JH6un5eMZDmL43mJ+3g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: add and use __skb_get_hash_symmetric_net
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org, 
	pablo@netfilter.org, willemb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 10:36=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Similar to previous patch: apply same logic for
> __skb_get_hash_symmetric and let callers pass the netns to the dissector
> core.
>
> Existing function is turned into a wrapper to avoid adjusting all
> callers, nft_hash.c uses new function.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Eric Dumazet <edumazet@google.com>
