Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D066FA8
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Apr 2024 04:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712550791; cv=none; b=mrLmfcscacKI0cnszqWBf0vN8NcAnPJfxqDiba34QTUU0I6fx1YaFwqXIVEpzpKghfC4akoz/IhTSaAaarmjLToCFqGqhoXETMSRtstV8yHMm7Yvo765C3Q7gMiWXn/x200BwtpJNUDM/Wy54DPjkfoqAxSqiN9Nonm1p0s9/9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712550791; c=relaxed/simple;
	bh=a0lsZjXqbWy6dxZHNPhzSH886TYDAH/yzj0kUCJy4/Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=afhykZhubJsU1Z3sbHCsNI/lnQkqU8hPBXw0nTYrw25/FeaRElpLA+tnn12KfPylSqjBCffkOK3azhJ0jAgmNaXFeFi+ZTnudcUnOpQRfrWRrTAVwj9Eudu1TTB67UvplbQpVW8UufDxCXiYco7/Df+bQMmxZxHqt4eW/thnqxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LTaGhUnq; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LTaGhUnq"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-516dbc36918so1846034e87.0
        for <netfilter-devel@vger.kernel.org>; Sun, 07 Apr 2024 21:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712550788; x=1713155588; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=52YIpLYkrKouDWLGz9w3uHZhHTe2M3VSB1XFKRuHN9Y=;
        b=LTaGhUnqUMHcQEHQKajwfznoHRBMnaFsLtIw0mf+OfLbZ6LDIq/j4DmhuyKTiDCXMU
         OQNP3Mpw0tloJ2XfHiQa+My6QcAUw4UHeXUoxA181DZSKeiCs75V2zs0dxWj6rk13nJN
         /NVpyqhsTUEAMUVra2xDehN4XeRROQ+18uDaBKwjH2ib4IXhoJAibiptr4SFONIi7mtG
         Ewt2hRGviAHRrZKKS3cMVKJglYgemzuj2qwbbTmi0D30V5EsS+CV+CvyvjvKElKOBXyh
         k/rMQP64lq+U19MKGep/Q+MEw0lwG9Y8O4CVbFLzq7G2BvxL/7v0nrpMTBif+1ILwrCm
         VIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712550788; x=1713155588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=52YIpLYkrKouDWLGz9w3uHZhHTe2M3VSB1XFKRuHN9Y=;
        b=SD/cgOvzCXtJS8M/DYAxF8Nn599Ut0WNOCPKKjrMZI5ai9agl1iRhn2P4artD4Aimi
         4cEIFb0qoHq3QMkqZlyf3nqU9QhMwvrKzLn0g6GsjuwCnAEDcFXwqPfoEOFe18CYNwP2
         LAFdRYxo2I8v5Kyl3o/UDPjZq7dluMe2FSx3KPV/EtM/jfhCoiKxxg+Mkxn4e81K7nx8
         mPIHaNFlgZl+lUQbYBeFRhQ0cKDq921FnRuuEKAycyeEMNDWGeWiWv9e6TL1xrO9FC0Z
         fAKEIh0b2slSzNLMi+dXqxM8WZzFQaIRK0s517hqIJD8fMdKbvaKCv4yrmUxr9M1kKca
         Ms6A==
X-Gm-Message-State: AOJu0Yy85aK1LzzWOmNEerX9s0mHv7J7dIwcYjrsipihn/koVSe+trYO
	CO8tj/gp8Pk2mqfrPZd5w3YALfvuJ50FXbkO91+dDxAI52z34ufJ8DaQjJd4uaxXG01NE4PSIXe
	cu0AsTJkPu8PA2PYAeKSA2TkUTFk=
X-Google-Smtp-Source: AGHT+IEZvw4kTbB1hq6o/DIJWtkPj7OGBP0kWRnq5C0O/urmo/tuzieMdobPU+PnFbYRsOA9apcmIjciptKBMfGMRss=
X-Received: by 2002:ac2:4285:0:b0:516:d0c0:3c5 with SMTP id
 m5-20020ac24285000000b00516d0c003c5mr5181583lfh.24.1712550787802; Sun, 07 Apr
 2024 21:33:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407124755.1456-1-dinhtrason@gmail.com> <20240407171734.GA28575@breakpoint.cc>
In-Reply-To: <20240407171734.GA28575@breakpoint.cc>
From: Son Tra Dinh <dinhtrason@gmail.com>
Date: Mon, 8 Apr 2024 14:32:55 +1000
Message-ID: <CA+Xkr6hrT0QvYn3V2S7=drzCLYky-ebe3J_9k8uf-KjSV=kdFw@mail.gmail.com>
Subject: Re: [nft PATCH] dynset: avoid errouneous assert with ipv6 concat data
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Apr 2024 at 03:17, Florian Westphal <fw@strlen.de> wrote:
>
> Could you plese either extend an existing test case or add a new one for
> this?
>

Sure. I'm working on it.

> > -     sreg_data = get_register(ctx, stmt->map.data);
>
> This line is wrong, this sould be
>
>         sreg_data = get_register(ctx, stmt->map.data->key);

You're correct. Fixing the bug with your suggest is much simpler than
mine if getting registers of ipv6 concat data directly with
"get_register(ctx, stmt->map.data->key);" instead of
"get_register(ctx, stmt->map.data)"
