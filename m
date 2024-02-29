Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5040412E5B
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709231897; cv=none; b=fK2tv6htR4Ik27StjVyuRGWs0kqHsy5iEcmmIV0O6Cdyd962ywm/Sdisn4oco2M5fSdOkZqmogDyIXnlDEHXLqlaIk6Lv5hNRiaPIAv+Bw2SOuW6W/5PS3VtcJ+KuLlPYQdca+mQOKuZSPrKeVc8egaC7uehslQxW+g4hJixAek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709231897; c=relaxed/simple;
	bh=PgYQgIh/+KvNsPuseTkA2lB8InRhKLTlmDogJoVNi7w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DM2UhoU6u3V9/eIcHGT+Y2kiVtT2wuiMUNHF6hmN+AlR/y3scPVJli5K6tUettkkO+pHjh61XX/gMnNXk3t4eNOnyR1T2XdRJoySHvVA9dofA/psZbag9UiYjeepOppMfacNUL+O0mmxx8+il/OwaCwVLod2FG3hxjVBriNZeSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com; spf=pass smtp.mailfrom=cloudflare.com; dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b=XvAcN2El; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloudflare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare.com header.i=@cloudflare.com header.b="XvAcN2El"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a441d7c6125so163448366b.2
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 10:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1709231893; x=1709836693; darn=vger.kernel.org;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PgYQgIh/+KvNsPuseTkA2lB8InRhKLTlmDogJoVNi7w=;
        b=XvAcN2El5KxCJHnXDpi0C4b2TJv+tSE12S21f/TKBRiDIp1S41qhxgv1q0kiIbGFX5
         islZNOY973/xuEjNRFfhfLw09Vm8kFlWH4ECo175B4vgikc+GgQ/yXqQZ0WccfXwIcrz
         yIIFAjpUhCKJBWDSEumIyS+LA94m9OhXCXdVC1vfVPVcq4dBCV4sNbJZK4CMH3acieg6
         w0nO4pnSQDbEhd6ENagY0wpeHCUKwTuSqJpJ2kXLaDeCiL0wXXkZiuLR3BWcic5EEyri
         I8XPCnLYiQoQ8OUrfedLrSBA3UbbWPZITQofM33t2zWz8kWAoA4j0ELqoJ0xfXsqE2aj
         oZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709231893; x=1709836693;
        h=mime-version:user-agent:message-id:date:references:in-reply-to
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgYQgIh/+KvNsPuseTkA2lB8InRhKLTlmDogJoVNi7w=;
        b=paj9oJPZWW5DrxvR8svVjXW6vN+JGeOiYM3nYxJjLNWYGcJEvTsh1Mgc9MPylegG4m
         Pv0vaqD0yg5lCcSGSHem2W5SBpPK9xAHMKqJz+apf+WD0GcePxeSYq6MGfeCqEiiguic
         4fQepNY1RthggvdV9n1IKFkoOVGNNDfDJz56YP/4kC1SYvGo0H1IQHv614qG2oG/VM7S
         73mXAeysrSUNTkHjP12JuphIsRC3cYHTw9MGOO/MHyc/z5Xk4JnEkJs5I6MhHlJawu+A
         iSOTsFdHZ1RO7S/damCpgz/LRyATIU4UKdQ78XKH9FNpvmJQAil7l3SD9PBPeJ+U91om
         CLMA==
X-Forwarded-Encrypted: i=1; AJvYcCVZQUmxHy++HWy7T4icYUEb/78vuRdSQjYGpfnuIvy02L/RawKabtXLtn/1bnKmmLwHqe8URVhRDpVnyNmunvEUXFJQR7aVCHnuiS7B8yoj
X-Gm-Message-State: AOJu0YxylMC1GfopNsyYoeTgWZTDO4y5lUOsalnNHek49ZpFUc67jun2
	WTRjhUrkx2hXlcYthckIG0EvfRzFigFQkUDXXShkZlZGg3/b6RXTy6zJGyQg+Hs=
X-Google-Smtp-Source: AGHT+IHB+P6Jrz2R2o9akkLJe1SQR4BKVRZN+/IcYmRI4yBGEvo/TJiBaq6+e8PlRTNuZozbkAkbIg==
X-Received: by 2002:a17:906:ca49:b0:a44:1be1:66f0 with SMTP id jx9-20020a170906ca4900b00a441be166f0mr2056354ejb.57.1709231893636;
        Thu, 29 Feb 2024 10:38:13 -0800 (PST)
Received: from localhost ([2a09:bac5:4e26:15cd::22c:19])
        by smtp.gmail.com with ESMTPSA id vh4-20020a170907d38400b00a441e6669aesm932683ejc.5.2024.02.29.10.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 10:38:13 -0800 (PST)
From: Terin Stock <terin@cloudflare.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,  Terin Stock
 <terin@cloudflare.com>,  horms@verge.net.au,  kadlec@netfilter.org,
  fw@strlen.de,  netfilter-devel@vger.kernel.org,
  lvs-devel@vger.kernel.org,  kernel-team@cloudflare.com
Subject: Re: [PATCH] ipvs: generic netlink multicast event group
In-Reply-To: <ca382b0a-737c-e903-270b-7ec98549ecae@ssi.bg> (Julian Anastasov's
	message of "Thu, 29 Feb 2024 19:56:01 +0200 (EET)")
References: <20240205192828.187494-1-terin@cloudflare.com>
	<51c680c7-660a-329f-8c55-31b91c8357fd@ssi.bg> <ZeCy39VOYVB_r5bP@calendula>
	<ca382b0a-737c-e903-270b-7ec98549ecae@ssi.bg>
Date: Thu, 29 Feb 2024 18:38:12 +0000
Message-ID: <87msrjktez.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Thanks, I'll work on implementing these suggestions in a v2 patch.
