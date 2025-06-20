Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4510E228C92
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 12:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750422680; cv=none; b=PmQrLnT7Hzub+L7Mitg4kQ8mFWswpUdEFRyh3C9F9V0p5hdjJVvM2G5SzRwFq+DM50iopj9w1BcmnaQqSaTDX71IeODSR7v8anNu/rda73Nj0RVonXoFaV/M0mYgMvEVU1dn6jzq3O7I6CohT5ugjxWxtEeADbS3OGkK9DjgBJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750422680; c=relaxed/simple;
	bh=5IdxfNVVi52GSN4G0e7Y82RHkr4aTziTJ8zzu+1jmec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dHsby0tZQc3WFspQ5BWyWEYyFtCNhHHpStlUpwxgmw8fpkocQqhe8ZbhFqF2TqF/Nd7nix0Ypq7TRiRFMgZKXMbYiataawG58A2WLBbVraFyPggufxgj6L+tDYSbabe4XETIwkUIEoIIRHiO1XnQHIRhlw+SDg+W3m5/VmuuWIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NERoHCgA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NERoHCgA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750422678;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5IdxfNVVi52GSN4G0e7Y82RHkr4aTziTJ8zzu+1jmec=;
	b=NERoHCgAnfgPNS0C/zq9cVJNKd+y+tN9fZEqxMUzjdoAgrPP3iPJTVDJfAjO0YWIA0+eSG
	VgJefgUd8dg/ncIYJgpLg38MpzjKCdrwqiyHUlVyMYdjMoW8ezHdGYmyHNJ21lcwKSga3O
	ldQvcRkWX4myUwd0UQhd5aY7wsbwEkY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-wkq64NOTMLmAYvxGkK_KkQ-1; Fri, 20 Jun 2025 08:31:16 -0400
X-MC-Unique: wkq64NOTMLmAYvxGkK_KkQ-1
X-Mimecast-MFC-AGG-ID: wkq64NOTMLmAYvxGkK_KkQ_1750422676
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so2505331a91.2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2025 05:31:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750422675; x=1751027475;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5IdxfNVVi52GSN4G0e7Y82RHkr4aTziTJ8zzu+1jmec=;
        b=LncF/5hdY8ZRT72A1XioCtoYIwuCX67jZscHnTk5HvjBkTJzGC/xsiY8mzwwzjJy8h
         jORh0VEEVtqu43QnZw85bt07DHdGaH4C6LwirE7oFDQoappbN5XDAo8KeM7bsfSWoQ1p
         wogGpNhugaknyBIbMGvWuHmOdO3PGOlL197k5FZx9wsHHf9woq8rsUWFjJ7wU4JYSauf
         FHO/gw08c5BJsygN8uAfwe8sMtKaIcYpiBnaCcGV4KKhGF/gSReipEReZCvykes0Unf5
         E4kz1KoyH1KxmMXym5AmQGbbsqzm16RtKAWIt3926XIPJumkUzIjfJbCqpxgJzvP8Oge
         f9jA==
X-Gm-Message-State: AOJu0YzIa9qxkx04jA8rFldOBBIi676NYXfapf+7/ntkHpqOAdBj5mPC
	h0fc+VkmubReYEt6kV42piEQrE0AH0n5PQOoSiBAa1Xme+UVTWAq8f6lTmXlpZTG5ZCT7zgakLb
	+y/uKHos1B56+P06JyXooCeb1a7NissAtwIobdRSS/f1FOvdO7xYmajV1wHjRtb8vBNHaI1IqCx
	mxGAed2KjRFxs3kJR3qVvXw6ttupOX4OPiLrkhaHBpcUx34XIyMvPUoxQ=
X-Gm-Gg: ASbGncsIqbDsbpxaDfJK88cahCNvMtb2z4Xz+N8ghs4k6LW12ONyJJIUxpUFiI4riyp
	F0Iw97fgui1FJiVgLFXj/6WcMoxkIpdOwJu1CJeHUl0VpnipMAPGwEwF8tO0P1zSDrDoi1HdbjK
	z4dURC
X-Received: by 2002:a17:90b:538d:b0:315:7ddc:4c2a with SMTP id 98e67ed59e1d1-3159d636406mr5529209a91.12.1750422675035;
        Fri, 20 Jun 2025 05:31:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkeDookdKbkgK1Hjq2YgUynwaJTeBTtERYiTkVidXEWPPjzNMJk4zc89+4k8bb59PirdvPOWydHjcWEccCgFk=
X-Received: by 2002:a17:90b:538d:b0:315:7ddc:4c2a with SMTP id
 98e67ed59e1d1-3159d636406mr5529169a91.12.1750422674610; Fri, 20 Jun 2025
 05:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617104128.27188-1-yiche@redhat.com> <aFNBzJOssxBN-ck4@strlen.de>
 <CAJsUoE0etJbdwHsHFHDnY1CkdmAXLJy7PunwQg9Me4n-AMPWmQ@mail.gmail.com>
 <aFUqWOr8nxp1eHLl@strlen.de> <CAJsUoE1ZChx7VcbZLnBpwbbkhGmfVVzomHUu7GP8xQCs00gZrw@mail.gmail.com>
In-Reply-To: <CAJsUoE1ZChx7VcbZLnBpwbbkhGmfVVzomHUu7GP8xQCs00gZrw@mail.gmail.com>
From: Yi Chen <yiche@redhat.com>
Date: Fri, 20 Jun 2025 20:30:46 +0800
X-Gm-Features: AX0GCFulNP5JCM-jiP7aI5CJGB65ooJhx0cn6ydpQF_7Y_5PVT9hpodfytQtxtk
Message-ID: <CAJsUoE3gNXhuTxWD6SV+HkRWOMkq9H7rc51Cn8UgONJ=7zsKbQ@mail.gmail.com>
Subject: Re: [PATCH] tests: shell: Add a test case to verify the limit statement.
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Using tests/shell/run-tests.sh $filename has a small drawback:
when run manually, all output is buffered and only displayed at once
after the script finishes.
I guess it's not a compelling reason, but maybe we can improve the
single test output with unbuffered mode.

nft -> $NFT:
I also noticed it.
Will send out a fix later, thanks!

