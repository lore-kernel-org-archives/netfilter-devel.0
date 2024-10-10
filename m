Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935A01E1325
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 20:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728592829; cv=none; b=THEGbm4qR031s6RwVGRjh5GD33/jq9AUaCpdoh9/mMfQfKzrOZQQk9ZQ50zv/gSIdVNpmgyUsw9MzgosVR21fepOllerM6iSBv4g7VgbcX4g+h4xfua1QyRXhWe3EUTZehO9knDim7I+pt94v98RPcvx8wVi6EZ4G3wtride1+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728592829; c=relaxed/simple;
	bh=zkZ6yU7DAD7YlmNJhmdip7MiifrOdjdqdbURkrcZAYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AjVyn1O+ntLoCHTTohj47evxZzpS4frnStw3nubUgmryRKp/F2aIIYZVb9NEYlQc9PxCXzf7msTmwte9xWbN5wnE8FDVRV/nlBxw88arL6OZjqm8R3+SjX6bCTB8IIPKJSmlB7S9USXCPxDtjAtyzzrNfj5rq8hTEsSs8BdUwgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at; spf=pass smtp.mailfrom=sigma-star.at; dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b=Vb26OtuE; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sigma-star.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sigma-star.at header.i=@sigma-star.at header.b="Vb26OtuE"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d51055097so461044f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2024 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sigma-star.at; s=google; t=1728592825; x=1729197625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rO42RQZBShP/lWCFh96DLSqblFSQl/8nGpu3kPW9gUQ=;
        b=Vb26OtuEA5psk8oKRqbL9ncjFN+fSdcc05gol3AShlW2GBEilMuCE6vjNCikA1j0av
         eWCcEDeJpfgjg0IYatYWao+zQpeqOYdbX1rTPuNPto9IPiRQ1i71tx1Oy1eTbnFgTVZK
         lCj63PU0FWQphuTL4NmojGHEjHrlBTCtzL0u/fkNzI7EoiDptj01HX4ejt5TpvtehKBH
         4DnXHvkq3zpeSbAl3osmghVDT1OlCL4tRuzRcehauHhq/MudRbtdgsW6ilXKiHvwNFnp
         aQsSHKcfMlRUxwQk9FOLyhUoMa2aIpkvni8hbR2vHTchk71lgYxig+asFofWr470cchd
         P0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728592825; x=1729197625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rO42RQZBShP/lWCFh96DLSqblFSQl/8nGpu3kPW9gUQ=;
        b=FQU33ynggOl6LZWnhvSPOmD3BukYvcXHcyFNrPxe3pDi4nKaXuca1bG4pMDjRmitkv
         JEUi/rdTP7qW0cq5rjkg1u3WRkZuzeuFbKIk5RGcW5WYmL+e9YI3RQ90vpVGu+7L5vGM
         wdbWbn8bOmsg4iXgQrGhspN428pnMxu6FQkQnOQSioxIdyOPkv5p3ffI3BAEZAPeAy3j
         cm48Vnv4lCghbPukWbKb5XSpEWqJ/j1UE7r0SAoMq+eHnfcDrYgRuQQ+F33Beq+/71Tz
         HVD+KpL7txVr+cK2nk3TI8/cv2KcQAO/ShmSy7aUisVpFu+hVX7+4DVEqU1jrvbJIuYc
         CelQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgLTvMDplF0TxTYfgnMrzO5Q/P7KJ+FLXVOR5TjNwpAR4bP7/kX8x1FGBhKvHHNp30JHEMmmFAZVoAAIrYewk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPYTdtgPJ4v0PUhn+iqDTDLOVoaAOOpy948HuAr1XWonT4+sNC
	6JwzLjLk8CS++tRQQFFy4tvcibdLwVEnVZ9R8E94n9qhIyAiyDkFAxWp6AIZg2U=
X-Google-Smtp-Source: AGHT+IHxYd9hOLDOuUcfxARzg6HTs3XT+7x6QJejf/5EJIDnBLsxJtYDpjq4FC6Qz2lH63Rfd81qjQ==
X-Received: by 2002:a5d:4591:0:b0:37d:498a:a233 with SMTP id ffacd0b85a97d-37d552ee198mr196344f8f.43.1728592824756;
        Thu, 10 Oct 2024 13:40:24 -0700 (PDT)
Received: from blindfold.localnet (84-115-238-31.cable.dynamic.surfer.at. [84.115.238.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6a8928sm2339875f8f.7.2024.10.10.13.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 13:40:24 -0700 (PDT)
From: Richard Weinberger <richard@sigma-star.at>
To: Paul Moore <paul@paul-moore.com>
Cc: Richard Weinberger <richard@nod.at>, upstream@sigma-star.at, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net, kadlec@netfilter.org, pablo@netfilter.org, rgb@redhat.com, upstream+net@sigma-star.at, audit@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] netfilter: Record uid and gid in xt_AUDIT
Date: Thu, 10 Oct 2024 22:40:22 +0200
Message-ID: <5924990.Vcsy2DjxtS@somecomputer>
In-Reply-To: <CAHC9VhRDZVJbhCbVkfs8NC=vAx-QdQwX_jMq51xzoTxFuxSXLg@mail.gmail.com>
References: <20241009203218.26329-1-richard@nod.at> <4370155.VQJxnDRnGh@somecomputer> <CAHC9VhRDZVJbhCbVkfs8NC=vAx-QdQwX_jMq51xzoTxFuxSXLg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Am Donnerstag, 10. Oktober 2024, 21:09:31 CEST schrieb Paul Moore:
> However, as part of that commit we also dropped a number of fields
> because it wasn't clear that anyone cared about them and if we were
> going to (re)normalize the NETFILTER_PKT record we figured it would be
> best to start small and re-add fields as needed to satisfy user
> requirements.  I'm working under the assumption that if you've taken
> the time to draft a patch and test it, you have a legitimate need :)

I'm currently exploring ways to log reliable what users/containers
create what network connections.
So, netfilter+conntrack+xt_AUDIT seemed legit to me.

Thanks,
//richard

=2D-=20
=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8B=E2=80=8Bsigma star gmbh | Eduard-Bodem=
=2DGasse 6, 6020 Innsbruck, AUT
UID/VAT Nr: ATU 66964118 | FN: 374287y


