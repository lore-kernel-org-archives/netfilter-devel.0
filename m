Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879425EF90
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 11:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759576154; cv=none; b=W8g2Ame86a4xhCQxHhyra6m0mwwKE1UvkujB4+voOouPfpF/IXzbqFA5nzWYhc4VqOLXviCaNfJXNSPfWFLC7Q668B/QfEPN8XpBH57qnMT5suro87Vs9MdL5rr+zyHPrNqe5YkmB1Z+a7hmxp4uD8VO4F+P/getcHJLVkIryD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759576154; c=relaxed/simple;
	bh=3yixzR1dKK4vZpkVNR2v5aTUNH2OCndR/AGhK0vlLHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G3x89mW/mBp99W71jOHWhtsXauK2eX6wO/zHvu3JwC45s2q0p0uSwefruPBdoAFF2nmXhSvifsdJIix1f1QQJyhQ3UFMuA9NmgXLPrhqDB14t9E1nchkhOVDOT3NYV8hZr7tDTcGBhdlsRtErwCmE3RD4VqbKJnBmzwnBW6yqXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NKyC8yeU; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NKyC8yeU"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-42e7ad9474fso8205405ab.0
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Oct 2025 04:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759576150; x=1760180950; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3yixzR1dKK4vZpkVNR2v5aTUNH2OCndR/AGhK0vlLHs=;
        b=NKyC8yeUnmcS4jdcnzhUJqulInZBL1sy3j1HfRBr7Qkcq7m/oyPq9IAnP3ioKcrJpd
         KcxKOTnJQ6OWsowIN07E4eddYVb+3COBAEntQYxhVolDPBw12gzOucMEVhvYyaQM1w6H
         ZsqQxlNrMvzEi2JDUoRKYHz75eYDEnUwi2mEIEmnINLcQpwsA7d0gqlQnBiDQ/uZLxWp
         VM/0icXedttgkI5hNVzpj1tBJEVcyobiD9FSE7R5KG+ny2gi4TftQYEFzoInoVDqN2fl
         AD6uxdVr6oPbg6Uen4muii3MOhIkpX8kr3z23MmMALRNcz1Uyh97uqlx23y8Y2ophUWf
         D8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759576150; x=1760180950;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3yixzR1dKK4vZpkVNR2v5aTUNH2OCndR/AGhK0vlLHs=;
        b=nktp0RH2Uo3te731p/WaHtg1MJiu+5xMurDzgcIRohncOp7jp7GrHspWcNimoVhvRA
         9aFYukxZUlezUep2w4qddFSRBk3ou0vGz+XaIfJomvDHXXq6MPIsPchfX6OyhWPkuR+Z
         zMYBZi37LqpCdw3yN+SNrFljUz/oDz6OrwEws9AfFdznCCFVbzAPTFDlV9l9wEJtGmmM
         KEngL5vu9BAOJ/60bRFl5kc0pCYobQgh7tywbk4kZcsYWHD7hGO4+Lgi82jZT4eqAZLx
         c/a+wD3qiMmwrpK2OUx1gVqKbuDV3z39t6hOCwVdC2Pqd9wxSTWv6qy+VsU7dDKWNepf
         6A2Q==
X-Gm-Message-State: AOJu0YwbSHuyxkMmhtyXVTi+m35NlJYGjMnKpA5Rpd89l+O0Urze7oAw
	ASUwEB4stYyc4XI59V3WRDy1opHJiI5cKECqaguBpqqa0LQhOs+Y3pvzUweHyiHLpBIaGLdroCW
	QVnuIukzcZZS+0GRk04jQVIknsMT+oIs=
X-Gm-Gg: ASbGncsZDI0prmiSsqss6WBxNsho1qTYfOAGJjBNPt78BXl+pge65kSnsu4e3/i5fUq
	+qmZR9aKwo662VjFjQ8fDYc4aNuzUcKk/fd4NtQLoFyChLGf3n6C64tBKYNFPhhrjksHuU5Mdy4
	UEwac4OYFT++xOgKGAbx3It0gZ+piUNKY5JK1iMRYUFTd7c/lTX0gQXA2bCfdUVaOK+LOUQtJfh
	A14g+sD7OodNwX5nW+msY/qyO6ZSN/ZuZLNNbq3qSFVdbApQqlICt1XIBwewQCJtW3DA9NmOY6r
	nHKJjowEDqyMmo59hnsaLC5Q/RZhvG1S/+rLdZ8826OdGR+Y
X-Google-Smtp-Source: AGHT+IFEeSO2fNnkkRr6BG+9pj2KSQvMFZudN+zpaodJ82cdRaSpZG09uBIgyox0D3KGGNiLeu3pp35Pl50BaZzTnNo=
X-Received: by 2002:a05:6e02:156f:b0:42e:70fd:f5ab with SMTP id
 e9e14a558f8ab-42e7ad01afcmr68043025ab.1.1759576150181; Sat, 04 Oct 2025
 04:09:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0adc0cbc-bf68-4b6a-a91a-6ec06af46c2e@suse.de> <20251004092655.237888-1-nickgarlis@gmail.com>
 <20251004092655.237888-3-nickgarlis@gmail.com> <aOD7IaLqduE9k0om@strlen.de>
In-Reply-To: <aOD7IaLqduE9k0om@strlen.de>
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
Date: Sat, 4 Oct 2025 13:08:58 +0200
X-Gm-Features: AS18NWAZjXUr6dATrF33-A-kJOSUPB54SEsEH8XAg1ZdIf1NUMNgwFKl78Qy5FE
Message-ID: <CA+jwDR=0riXXHig1wcq4BjbGDUngksrUTxdgJgD4S8PUqAvO=A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] selftests: netfilter: add nfnetlink ACK handling tests
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fmancera@suse.de
Content-Type: text/plain; charset="UTF-8"

Florian Westphal <fw@strlen.de> wrote:
> Can you drop the shell wrapper and just call unshare(CLONE_NEWNET) from the
> fixture setup function?

Yes, I can do that. However, I am wondering about cleanup both
before and after the tests, as well as ensuring that the nft_ct
module is not loaded prior to execution. Should these steps be
included in the program, or do we assume that the tests will
always run on a clean system with no modules already loaded?

Thanks for the review!
