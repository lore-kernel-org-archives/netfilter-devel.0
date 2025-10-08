Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492E92F60A7
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Oct 2025 10:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759919888; cv=none; b=Yk9DFPtkD5JeQt5upF35/x+9+Dcamn3vvz60aoVIZ/4vyWQBiuKozbJ9P1xZr1sJQ1SjlyORlzF4nEobpFPpllVglxyLfScJ6vt+n66BML/jqN5EjqS4AGqbHAbhlVmDPZq1IxbFqZEWs98Xqz9jJRO+2xLsQG9qAxF0MhJeTSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759919888; c=relaxed/simple;
	bh=IkZVLNS5qvkZTHh7crdD/zoSGD3bRRGgRMZEnv7ZdKw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KQqDKEC5Ne+gj5KwZ7nKCDQgU2q4RDSMizwT7/fI9/GmmeI6qA/+GicVq8v8iwbht4TelQB1y1h1aKnmW25Ofl1NA8JtMoV1plcFL/HN0LSgjZtS14emv9vAIhcQP0yvXEXaRKUJK3k1cGrkjl60P+ePEp3wS88/mqtrDmjqaCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ty1d5uvR; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ty1d5uvR"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-92aee734585so277051339f.3
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Oct 2025 03:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759919886; x=1760524686; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IkZVLNS5qvkZTHh7crdD/zoSGD3bRRGgRMZEnv7ZdKw=;
        b=Ty1d5uvRWMvtEJYQv/KkuC1enNNXVmMTIxL0YGC+iI49NoQM9vm/EOZ4/8peiZ8ZNd
         p+4Nd35X/29Q+CfJCsR1RPybxspvIYmYuHLAQVF/ExDM9F7MLtJmKeXMZfze6ZqCVxCO
         I7yMDoxVs6EKuEgsqcAsTcDnGjP9Lm/nS6N+4pqOY0zZF5Ww1alvTwWsJBCMJcy5H0qw
         gvbjK8pX0GvC4K4m8dorX3qrv2F2tKh0Ops9BaVzgs1eZ4btvLfQOTAcUB1AzqcyhFJ4
         7tkicYVXYNvh2sGRwBMhFfy4vs0TgWq3M4oYMJgWaHfcNE8/JkBgmvQj4VuFl3a+LjNk
         M2zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759919886; x=1760524686;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IkZVLNS5qvkZTHh7crdD/zoSGD3bRRGgRMZEnv7ZdKw=;
        b=WhUf3cIf7KHCvpTGtRnNYPDkJErIFC6tI0TzmIi3T/vhV+YAFbuO8Exrx2BnrSTFE0
         MEIDJszwnI51qZbsDOknQB2qehK3C3JzxIIsBdK/V7y2OdjYccC2905gV1xC4z/Ssvhv
         hHFjxuAaZyUh3Wgcj9p1THIZkoliUrTt3D1iJEbGITxIqEMPrxwZmIY8D3smEzip7w1O
         jLoi66wWfIshafW2qDhL+LBclW5Ips8bBFjZ5f5XL7x4TEdzIRpZP1FA8WygfQISVv68
         RkYqPxrYW+5i8rge7KuvhDNZfP8n3l1dc1QKq4D1ra4rPc2Pdv/mKsiwdxgB28IyKfjl
         GLUQ==
X-Gm-Message-State: AOJu0YwmDjhxVUcMtKT5Xk756WYo/IKWuYNU8MapER3x2uQ976NepMZC
	sdHMXiSEdeWVSv2pDBUBAEiLU+Rf0peYTZJTwmdkqPclHlkM6UJXujPyhN4LqQAXM1c+ShK+UCm
	yPF7036W8UJRAhOMv1j2fhK/A1rRDzHg=
X-Gm-Gg: ASbGncsvN8N/D3jso5J9Ja4ooba8R8UwCYc7co2EvPlQo0J51UAexm7lrqkHixh6ZFi
	BK4XaZePao+RkJQJb7lz6f8nWzpt/jU7OWd8LdbMCirQ1GioruK6jhJGK4jPzW0BGv8rWaHbi4Z
	0yUS3pNpnGkvFlrjYUHsAkUstz0eS6AN2C5RbYn8HQ5V/8D42dgrGYyx5a6wT4oky5VLDQO6ROj
	0xVujxzcwLpLVw54GhrNmpv7oMh51KQEhgy9Bnqh06wiDwYcEXmEguYaaCGgvtSscZV5Rmv754U
	3EpzY0NO386jswFB
X-Google-Smtp-Source: AGHT+IG8ngZ8nKxsg6d9bnJPO/+aawnx8lqcUCo+Z/apSwkh4k8zKzBzcjHNdiKAzk71ZpgwA1eyGEOP5ths7er4/Go=
X-Received: by 2002:a05:6602:3f85:b0:927:bb0b:3ac5 with SMTP id
 ca18e2360f4ac-93bd19a5430mr275693439f.15.1759919886325; Wed, 08 Oct 2025
 03:38:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aOJZn0TLARyv5Ocj@strlen.de> <20251005125439.827945-1-nickgarlis@gmail.com>
 <aOY8UolnTfclgU40@strlen.de>
In-Reply-To: <aOY8UolnTfclgU40@strlen.de>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Wed, 8 Oct 2025 12:37:55 +0200
X-Gm-Features: AS18NWDdhonrQI1UaoQ2X4Uigv1PN-j8wFsolVbw5uYrDP8OOQY5GZ8Gpt_3Qew
Message-ID: <CA+jwDRmj2ZEjzByADXRQ1JGySqyHEZi9=Hr3mGCiOcM+LUgV9w@mail.gmail.com>
Subject: Re: [PATCH v3] selftests: netfilter: add nfnetlink ACK handling tests
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Content-Type: text/plain; charset="UTF-8"

Florian Westphal <fw@strlen.de> wrote:
> I will keep this on hold while the discussion wrt. ACK flag on
> batches is ongoing.

Thanks, I appreciate you taking the time for this.

> Also, checkpatch.pl reports:
>
> WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
> #59: FILE: tools/testing/selftests/net/netfilter/nfnetlink.c:1:
>
> ... and a few other nits that should be resolved too.

Apologies, I will submit a new version ASAP.
