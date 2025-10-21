Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC3C2620F5
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761083885; cv=none; b=q1ebSGqnfGAIIAtfbt5Hy2zcnNNK/qDYjdw4XwFYBnVCoVgL2XfLjmiSrP5PcdwiZPj+RFLZl4fA3nigXqixnbZIfjb1JLU7q2VsprEv8XZsBB8W+6Umk5RFclkFewBg52zZ6py/bN5muKiFuasWvy9Nc/VMUV2dKIUImIqA0Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761083885; c=relaxed/simple;
	bh=N2yXlurf2Prcgsbi0dYGn7YFdB2y6ovD3fX5BUAkW0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NTTfgOrW2NX8L/LP+F5fabXy4GyV3WMsRXIWGAEu1m4fKhb/mRqkpExUTeBud+U2G4rX+K9/E0qqCYPYqAuDySq5UGSXSak5zBPWjer4Fduw10SeHetsJ2JWlMLq4+2STcz+h+vYjQrlD02e/jNYus93AnjH3YKto8dMN+WFPLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nI0gCyL9; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nI0gCyL9"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46b303f7469so49245575e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Oct 2025 14:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761083882; x=1761688682; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N2yXlurf2Prcgsbi0dYGn7YFdB2y6ovD3fX5BUAkW0Q=;
        b=nI0gCyL9sV+U4xH3LQ4B1yYV0Bdxd6r/hc2k/oB521y+Xq719eKinF+sNFug70YPAF
         n2CkBpegA/J5bR3HWntS5FXxB4OKXJv/L+1SXJIUWPMNjFzX+is2IpEkyBgvSUNxaMqC
         HDLs07JQusY2GTV5eNdGzaWVfiMJRbPkK73aKXsJOY3YUS0F3x5179JLm+NbjcOaSuG7
         Ubji6MJuvbSo/aZTzMD9AZB8qn6zL+xq4PuU0AL3zi5HrzsI5exWxmN3SuvzxRBVtx7v
         KRnEyI/a1hfHrYT4Mwdf6VwI3af9vhCnU/8xKgFh+jbpSAM7JVgcqI3KxTU0FhkkAZwA
         79iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761083882; x=1761688682;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N2yXlurf2Prcgsbi0dYGn7YFdB2y6ovD3fX5BUAkW0Q=;
        b=Y75+o3OuXswbn4wCGGsc+oPi1X4wx/QKuAC0I1KZvYdKNuz+84nP0GngsLX7aO7quQ
         r6uxNguvSQtwafifIgnTWugDLfGQqGjEpG6Vs2AaSJe3GMC//BuEzpvvEfnOhA3u1ees
         iZIJh0kcdrCVpbBgC/fjJ5ec4Z6d01SNJ9qetkfs/8hB0O/821XUHw+Y5EE9/9E+l1Or
         0Ze52TSZbxvgi5DHsiGXIoIZLu+jedTkFT4cysk6CmSjMLSdD005TtHuU/+ezZS1/Ejj
         5qmLjL3kzMUKzo8+fhi/4rxc6JhffvRB9rqcxR7gqepFj2AMCTh0xdxTSLlYO7b68ckz
         Gq/g==
X-Forwarded-Encrypted: i=1; AJvYcCVV5Usr0lxyJfFH8JWe////lKgeRanflM3xjFxKUEGqfWCP+jT+AOv0z/hKDMBiVQQi7GR6tQWLrfHQbkVAZVY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwW6Qds0Y750WbmTj4qsuImd+5cAGEUYxXlcDA3GTZt6vVyWWEw
	52+BykWbmIYhkv8QO5hzEW2Yd+rlj9L3jO9ocBg+M5L1Ljxb4+OqhsKT8tTAsxI+ooLGs1Ja+aL
	TDvKITuNCW0unqTjqC6HTyry1TyKqBVZPeCTyoxXLvPXf32RHUWBYTTvE
X-Gm-Gg: ASbGncv46EY8hY/7dtU2AoyZX9UoxJQo3RR59SJEVZLCFmjOfdwpCnxtmaUj2al8rnR
	Mxvoph2bQ3odM3/gx9BSa0e53Dp7A3axVmX4ViTAr1EtHDb1uiyN9n2lvh6q8d0XsogfhHuPlBS
	73QpNVxmfAKZ47kC/fwGz9pGBOcdc3znLKt/I/2FtpApB4f1LVfrnyknZvdmM9z8lLdnj6u4bF8
	M8XI8Ju7AiZSUR5RXKfTparLU2KmeWPoS9BwOQJDwk5FGd/gGowsGmSxxY=
X-Google-Smtp-Source: AGHT+IH1UkIrH3A7Vq3FiCYAPfrZUgSR8FUhVUq+T7RBWnBpmdVVkoHdf60FqZdEfpk2A18dwELh1rRhnlSVbuWUFEo=
X-Received: by 2002:a05:600c:870b:b0:471:9da:5252 with SMTP id
 5b1f17b1804b1-47117919c1cmr146804435e9.29.1761083881572; Tue, 21 Oct 2025
 14:58:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020200805.298670-1-aojea@google.com> <aPah2y2pdhIjwHBU@strlen.de>
 <CAAdXToT14bjkvCrP=tG4V4XJhhyGMfuJz+FdfTO+xJ10Z-RezA@mail.gmail.com>
 <aPay1RM9jdkEnPbM@strlen.de> <CAAdXToQs8wPYyf=GEnNnmGXVTHQM0bkDfHGqVbLhber04AyM_w@mail.gmail.com>
 <aPdkVOTuUElaFKZZ@strlen.de> <CAAdXToRzRoCX4Cvwifq9Yr7U663o4YLCh1VC=_yhAYqAUZsvUA@mail.gmail.com>
 <aPd6Ch7h6wdJa-eE@strlen.de>
In-Reply-To: <aPd6Ch7h6wdJa-eE@strlen.de>
From: Antonio Ojea <aojea@google.com>
Date: Tue, 21 Oct 2025 23:57:49 +0200
X-Gm-Features: AS18NWDPyQ7Z2HNBUUuE7tzLDT7rEHzEGykZ7ludzCwpoNsdgifNKjxIYEZK3Y4
Message-ID: <CAAdXToQ+DuBsPGQUgSCk2=f_b2222iTD4-rT=0gVuaYWT7A2HQ@mail.gmail.com>
Subject: Re: [PATCH] selftests: nft_queue: conntrack expiration requeue
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Dumazet <edumazet@google.com>, 
	netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Looks like one needs to set a label somewhere, no need for it to match.
>
> chain never { ct label set foo }
>
> makes this work for me.
> We could change this so that *checking* a label also turns on the
> extension infra.
>
> Back then i did not want to allocate the extra space for
> the extensions and i did not want to add to a new sysctl either.
>
> So I went with 'no rules that adds one, no need for ct label
> extension space allocation'.

But that does not consider the people that just use netlink to set the
labels ... from a 1k altitude , can you do a check on the first
update/create/delete label to initialize the extension?


Another question related, is it required for the label value to be
always 16 bytes?
I do not know if is the golang libraries I'm using but it seems it
does not work with other lengths
