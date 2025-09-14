Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8D821C18C
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Sep 2025 06:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757832037; cv=none; b=llN5Nkdc1oVA1jfoJk5S/rVcLPUljJ6FQRfNjq+jg4+KStYoXljMhCGPbLjm19y4HUV1sa4vm9qKQ5iy970M6gpTzl0G5S8Dl4wyuMkgDqRvol5MHbzBMYPIEjG6YcKoDk/fc1njBCaGxhcVDibcOzQDMiMXzxOih2fHNKS+kFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757832037; c=relaxed/simple;
	bh=W9mBKKhO1nDG9kgofix3fJ5jAhsSVWPySySJxafsDg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nz25P28fMhnDd+ahsnmyhRxWCTTTgKCFU6NkcTRaIScVXUYwSObAuI++SL3nWYMu1qEVCl/1xYy+v06n1TUDDbmk4FFKnFQbLDlau19rMncl14nsixJSDZExejZ49ISSZ8ARYsLSjp1ZlOSuJry+iNvqWHx8yetKcLghx/HZ7ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZxPo1rCC; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZxPo1rCC"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3e4aeaa57b9so2766122f8f.1
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Sep 2025 23:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757832034; x=1758436834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9mBKKhO1nDG9kgofix3fJ5jAhsSVWPySySJxafsDg4=;
        b=ZxPo1rCCkZgBARQNa0334DlqqyphPP7cfa00eKMT4TNHqSX/ec5xVB/PdU7KJhJ9WX
         stjGWdo6g+CcxnV3fNWNptJMZNrLUcYXDv0lLQLhKCDllMfb3C3fFm+2BLE3VC2Mfiji
         QpdE9y97Wf5RGh9Lu1shjrLITGs9ulo3B/Or1A+byhZTgydNgLMvm9V5O3XRP1EKnp+i
         VGwg2//+0/VmBlB1bFjOZQ2NI7Sc1OkV35RgSIJJaBluhuNWUBtlJCGf3TSssnwqS4f6
         9GyGz38O3ZgJb3ToqqSB98v2R+okQjUh7jV0knzn0NPYAIMXpE5LQ/z9fvP+AXX7VZsp
         EJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757832034; x=1758436834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9mBKKhO1nDG9kgofix3fJ5jAhsSVWPySySJxafsDg4=;
        b=XobYzBNDsTYSPoG4Fp3gFyz9ul+GvtbR3U1HBObT2aIVDQKWef1T2YW6NtitosOQwv
         KF2S7HzvUrgf5r1xZ7oU+udHdPUFG9P1GZAn4RMmfP2XoViMzINp1YUuaVqmoN9oiR0l
         58/PusuuaxmBIxvMMU5KybUzOXRibbT6Il0HufNzpCAtOrMCLfBUujA1R9+LMuqNhZLf
         +UkVDFT9DIELh5e1OsGHWx3TvvfZNnxyUHVaHO0DacsZ/oKZqcHVAookqPFa2b71ikav
         JZEQs+lJ+XaWnlTrDL2MPcT/h1+AzdqT/Br5sz68Jmj2/mLzPmKs/JgUFa6Hi8QXcDr6
         AhzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnTHTUCvsj/wGNqQhIvsnr1FmEJS7TsyQifvtWQi6rTOKIh0ADfGzq4VgDKn+s8bxaGUHWun876G6mHaBStbk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFHmhMvECwcFs+JTiaGPpoDy3PLF0gzejsrcVe2hC+C0/7CFlB
	M2FeVYoAYVesIBMvvlqp1A9aLT8YSZMwMwT9JCwRv4oRqwdVsnIN0oPjQY2K6YtQLQB+iTZ+3zt
	6h4ICnVvcXU5fC0c5pnXG7rJRn8sOam0=
X-Gm-Gg: ASbGncvDSz28hd5YltmZsdFIp5cyAMzBk6nMSzjSsDCeiSCOCChYg0lbMIL/w4ckAXM
	l7MsHc7EJ8AMj6HFscyQB9jD0y9DoPLyf8gjArIFiO8UmmTkMzZLCdmB9LoTN5BFxaYL4KVc8ZV
	q8LzkFXdBQ2fIhoSzD/CJBOVmirX9VqoGf+7ETyy3Zy5yaRZtSYbU1NrZF0YWqCUgZjgZXpL8C+
	fe5cXzinrY+kFVDEV0ZYJ/PY+6kftFplaUzSw==
X-Google-Smtp-Source: AGHT+IG7BfAN8YgdMhPRHfWg9au31LmiMJ4FCAqPBRvsfgGJrVZfq2uKb4GWTOHEh/+vDSJLANy6x4rVX46AhqFQA44=
X-Received: by 2002:adf:edd1:0:b0:3e7:ff60:cace with SMTP id
 ffacd0b85a97d-3e7ff60cba5mr3742532f8f.56.1757832033848; Sat, 13 Sep 2025
 23:40:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912163043.329233-1-eladwf@gmail.com> <aMXZm_UL58OkoHlG@strlen.de>
In-Reply-To: <aMXZm_UL58OkoHlG@strlen.de>
From: Elad Yifee <eladwf@gmail.com>
Date: Sun, 14 Sep 2025 09:40:22 +0300
X-Gm-Features: AS18NWDanC3VAORRnntTzRI-0ysMkY5yJY0vhKytcbLTgHpDzFeIHXwTC1H6sDI
Message-ID: <CA+SN3sqzRMWVF5ZTW+hjsKjGfvsGzCn2qUt+uvNWAzeYD-54hw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] netfilter: flowtable: add CT metadata action
 for nft flowtables
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 13, 2025 at 11:52=E2=80=AFPM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Under what circumstances can flow->ct be NULL?
I thought it could be NULL in a few cases. I=E2=80=99ll verify this on the
inet/IPv4/IPv6 path and report back in the next spin.
In any case, the null-guard is harmless, so I kept it.

> This looks almost identical tcf_ct_flow_table_add_action_meta().
>
> Any chance to make it a common helper function? act_ct already depends
> on nf_flow_table anyway.
agreed. If there are no objections to the main idea (exporting CT
metadata on the nft flowtable path),
I=E2=80=99ll prepare a new series that factors the fill logic into a shared
helper and converts both act_ct and the nft exporter to use it

Thanks for your feedback
