Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD94481255
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 10:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160440; cv=pass; b=SoeHbXCiluinRW4CdNKhPs9tnFodWa4HIRkfMXFIGKNGw6ft+8BG2kq5RzC8PKb2wWVgElGxO/oti6Ii9hLuRY4uZfgGgfRpX9ls75tHDZKMq88Q6xMiKnwac3cjmRuKoqlEDWcj9Xc8YEK/UUTBq9c7XKfHPZ9HJvQ0HG3cPkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160440; c=relaxed/simple;
	bh=msXNh2HdDF+Lcwkkg4QxTlZJD2r8Tk8OINy7Tsecn94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hQmkh44gtcMXAVK6xynGx2o0rlM+TyxDwaYHzMUPCOGg+70NDi0NQNsoK0JMd00ns27svViyjHETaIvildLd1xAIxptro9yUlKPTQc85a6Py8fLwUVD240qCoEagsIRdPg7LLF85J5PxQ7lABOFhRAxQ16qyYoDhCZ+6M0jfhKg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kQKdV6bs; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kQKdV6bs"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6063d7daaso1060831a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 03:47:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790160420; cv=none;
        d=google.com; s=arc-20260327;
        b=REnR9L+7DTT6afJtsdDWACygj5IJchcfHwyKSC6tLkevaMBmL3LGO5GCtsQo1s2wp7
         OmHtoBp/VOERDsKIsv56Kdx7mgNyaB53P4+UT7iDGh3C+Edw86hEuZZeoWrTnbW2LyEz
         nHY6cc/Q8OXPW54KKPJU/+w8pac2aR67dKvRv54NUOVv8CEsZge1KVQDmxtbeFf+zGP2
         w3l2gjlMguQkVFUP/98zhzDqeUAEhFhrD4xcAYGlilqfMpGrZynibbFwh3MJIjtWItF/
         j7kBhu+y47mXbfrGSi8HW/N2q/uQqTEWojIq6qXnuCt3Wc/Dc8a0QFxQNDcZcw+Gs0X9
         ZwiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZfsSpgY3gPhyjK/RNnQXArXZalYQBWjirqT5uOX4kmA=;
        fh=MKG75QBapuOtMXPxEWflMrpC8Xb9+a5nhb17i7+qFWc=;
        b=euiz2+6V/G/9EiJDzEehqJIRKcD43cmplJdZZ3zXXf0rDqsqR5VV4Vft3Arz2uTa55
         ANYqtUR8PExiO0ugpuXE38ubV3i+ZnRmB8ZI/1tX/PJog+fLpT7e0ADwcfvX7EQroM20
         5uFw3zthwOlw6Sov1c8HNQb7nuPyyBiQonqNXL0+FOUJZ8/ISp8i3WnBX4t0Hfs4dxox
         ijzleiqYvaFlAaT8roqfRnhjbDrt8x4S0rW9VijqWWZNT2KtpNl2+mLJdmFGMPbMJGWA
         C0Rt7v21qnLVow6d6hUjG9JKAH+cFKaf+j342rt+AyLSyMJWeli1YPaDSiVelR9i0Mfy
         dOVA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790160420; x=1790765220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZfsSpgY3gPhyjK/RNnQXArXZalYQBWjirqT5uOX4kmA=;
        b=kQKdV6bsRTYStFuf/sb79Isub1vuCfwAelGS0hl94Ce6A6jL3anYn8jCqVDqsJTyaG
         md20uE13i4YlLkvs1OweYMianRl7M3phDYCZynSXENITpM8+xExagUWdU6qAOflCu96M
         KtrC+gwjKDUCopNNle1RfezPBXB4rUI1ZPUPjjQdSgnZl5Ubzdh/DuqeUbgF+riUnb+N
         8U3HWt+lmOm68wBTDaFsA28iwbgYNLyHYKar7rSgbjnMAzwC/bmkBlrH6jbT7s8wAHQM
         6+8kegr/+Lbvei+3BtFQDE+/+lbsOiCQMJciEdE97VjC1Pb+YN3rtTMIiYao6JvSpwFf
         2yDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790160420; x=1790765220;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZfsSpgY3gPhyjK/RNnQXArXZalYQBWjirqT5uOX4kmA=;
        b=y9Oj2toS9q3d3YEfuiQl67P1DE1buO/CY1R9Sxa1DnHuhni9RWvqf+9Yeaxwwf7Jq8
         kkaRBhD9/1VfCNx2ulg453oSDccxGxvXGdULZZ1F07LBj1vzjJzl8FI9Gx2RKPqZG4TD
         e5BmxhCNC+N4EXprdqJegqxqoi1sre/rsHhU60zJdueMcQy5AqUYUc/KH3mfynGBLXXj
         yqisq8eFBIrNSF6mpoLCRYiUaJKP8N9QSo4N6THjhfszGI4uDq7ticOUYcLez2LqfnkZ
         465BPmEnv9jJBYruQ569AKJViVeKAjj9UpAMn66CFg//frFTaL8B8mYyga/ZuUHk4Zs0
         6zKQ==
X-Forwarded-Encrypted: i=1; AKwUvByYOQkND/aQnuGttuwU4SIq2LDHnD3eMIqfW/lkLFCX1CdXeILiRJpRCiSH5auuI7Oc/OJi/lTJ/n6EqV4OB2o=@vger.kernel.org
X-Gm-Message-State: AFuF++kTa85qlFSXZqAhm/apIGf+vUgac22Il3AAnV1JcYA4xcEhliJ/
	bGQIZoYmm1e5lnSnBFrYkdWV81cFlulDqqwY7Kfi7UQjQcyrjBFqDfL/h8d7+hLEDBm9poA096v
	5iiGqZxoj/vkQSFWTWHaIPgrXYwwTdX0=
X-Gm-Gg: AYBFou1Fi7IcF29uU6n5R/TEMcbeNRF+x83PXQ7yzzWM39PsfW61475Rmh2fhz7DpyF
	JoeWYmQEHkjFqpGRyOwDngvYEIPqEdnXpE0aeorlLEuJDbccYlwnMAGeFMX4XI/JehMvkNcvaSb
	bNTa/1xNlUWy1RIVHWJe69w+HD3bKdGgPubPoAQtYG5YRlByryq58CR9PoOYejJF1XQ+73J3bzA
	jcVQ7bm7DDEqoPQ68xhCSgrh7+1KBFbHngmJoj59R3pueHDHOPIN0PFdbMCjTmxil85OCACnROR
	oHLf5OOgYApCBWPRVndNo3f0G7GdJZusfy+nVwvq2Lzd31tFnnm0iw2OXLJsh+aCNuo=
X-Received: by 2002:a05:6402:1ecc:b0:6aa:734b:1a28 with SMTP id
 4fb4d7f45d1cf-6aab3b6db15mr2109299a12.34.1790160419876; Wed, 23 Sep 2026
 03:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHeizqHDqx3ue1=0QL92ef+6C63Ur+v1Z=d93smgdD5zTj_-Pw@mail.gmail.com>
 <arORyXjxvZUoEAIw@chamomile>
In-Reply-To: <arORyXjxvZUoEAIw@chamomile>
From: Subham Pal <subhampal789@gmail.com>
Date: Wed, 23 Sep 2026 16:16:48 +0530
X-Gm-Features: AclHuK8mzFXFfzSoA9WshHACP17UijNZVLSKFGyP537HiCjWWOCf0JS5ZMRW6Fw
Message-ID: <CAHeizqF--yGMCLGBEv9f7Gs=dmbZO6+DwSh7KZjpDgbNonCotA@mail.gmail.com>
Subject: Re: [PATCH net 0/2] netfilter: nf_conntrack_h323: fixes for NAT
 bypass and ASN.1 decode
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: fw@strlen.de, phil@nwl.cc, kaber@trash.net, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, 
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 2:16=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
> I understand these are correctness fixes.
> Do you have a reproducer/PoC? Do you tests for this?

Hi Pablo,

Both issues were found while testing a netfilter based linux
firewall with communicating devices from multiple vendors
(Panasonic, PeopleLink, YeaLink and Plycom).

1. For patch 1 (NAT expectation bypass)
- Environment & Setup
  Linux firewall performing NAT between internal and external
  network segment with Panasonic, PeopleLink, YeaLink
  and Polycom endpoints.
- Observation
  Call setup failing due to missing conntrack expectation from
  initial Q.931.

2. For patch 2 (Failed ASN.1 parsing)
- Environment & Setup
  The same setup but this problem happened particularly with
  Panasonic endpoint.
- Observation
  Panasonic endpoint advertises sequence extension with missing
  optional fields during call setup. Due to misaligned check for presence
  of field, I was getting H323_ERROR_BOUND error in dmesg.
