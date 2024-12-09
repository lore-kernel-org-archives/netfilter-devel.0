Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902419E97A
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2024 23:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733785439; cv=none; b=br/Qoj130t4IiHaZcX6Uxwbs2wR4aSq2r5DyDjLGWB8J77nhhPMFfbb0CiXbGbkCZeUOa4I9Vk9F9aiErkUVtZpyVlt+koZGqcLXowZrB2ha7PoF5n/ViDr/6GR3vJMKa0whrcc2oYfzRXst4B6AWV7WOJPNMfvCh/XyTLxICyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733785439; c=relaxed/simple;
	bh=t8tNqXkXj9kLWqThwBj8iBEm2ZBFUdSI7kWRrBowNkE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Z8N5eyyzGgCaQ8YbFyEOhBrWEvM3ZUOYINoW5RZjj4elWc+K1ZS1SCk2qrG64cJhcJUANHAOpmn5f7FikSgX10T/MI56ywOJ6E2lU5fyfm1S7pI/3riwNFu9akpPlct4tvZ5OBvbROuRZLrjF5xGnj8kPUF3DWZtqdiqPMHQcWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tigera.io; spf=pass smtp.mailfrom=tigera.io; dkim=pass (1024-bit key) header.d=tigera.io header.i=@tigera.io header.b=fA4TVFHQ; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tigera.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tigera.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tigera.io header.i=@tigera.io header.b="fA4TVFHQ"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-7fc41b4c78bso2898235a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Dec 2024 15:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tigera.io; s=google; t=1733785437; x=1734390237; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+VO+mwJyA7brVSWbEhimH6dd9CEWUYczY72vqBidTus=;
        b=fA4TVFHQqHQcUEOo7bJIBSkG/IVp1IttuhILXc0NtT7EDiDMuQ0OPkp2DaeeYDS3jv
         X1wRFdxMfnKxwsp905ssebpTr/BZagQvz6+msuoX0PAJgKLxYJdB0v+kDQ8uL06OHnJC
         WPjIwGMcZQoieZLJlI0ah30/xZa7bV1yzbuUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733785437; x=1734390237;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+VO+mwJyA7brVSWbEhimH6dd9CEWUYczY72vqBidTus=;
        b=A+1SeE6wKfUYUJkZ019DHdqNDLIy0Q3enHgUcN/M9MUlBRXmP58l3icaFaOyi9/lQY
         S3EP6to7GXggPSQr1nasZVPS/4oLjONIhxwswAsBBTJu1NKq3U5dhVOeB/6TpV5K5H1n
         OF9rbwNM/Pv/RUjQZVQ0lzy/eKI95nnyVbyuk5T4Kgv1XhmFIZSPAH0fvXNGqsK4nmWg
         Y8amNW1mXtNjeXLOwtIZEt3S+Bdyaxpvy4Do2g7Pi2OiZuf+4b6GOAsDGnHRSgkkRsny
         L1F34TK9r+FjbTmhgaVOMxidzNCos185vHgQ3n26WNJuEl9T4RYQ5Csg+hQ/onMpuRcd
         pHUA==
X-Gm-Message-State: AOJu0Yz0nMa7kLMbiQ0u1mmNb2cQIqHmHGkT7XL7ewJL0tFVYyo0zQ5s
	OP7fAQ63N+J9JlmPKGoIWJMk7SgiRd6PJn2nO2QLtncVagL922BJDD+Ly6EO3z5D20h4FSL+67e
	aYqy95gvNuhhlNd3ZuSYiQUOcnx/TfvYDjNOUxvOrM9UAVieTZ3E=
X-Gm-Gg: ASbGncsEBzWYTtFIdKUCUC+PgBUtFQjC9GtJxy3La8Jsyusx/999XrKSfZJjdOd45Q4
	9VmEpNrP9LfUa7jPiTeR75SHbFyaANfaIVIQ=
X-Google-Smtp-Source: AGHT+IEfLdbI0STMzzG947VupcHSkLZYqfuizpkB6V1LVzB6TfQ1jnmTCZ+kH7t6vd2EXoXWa+rwRnkzWFXIhr9NgKA=
X-Received: by 2002:a17:90b:224f:b0:2ee:d186:fe48 with SMTP id
 98e67ed59e1d1-2efcf2226bcmr3094869a91.28.1733785436759; Mon, 09 Dec 2024
 15:03:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Sridhar Mahadevan <sridhar@tigera.io>
Date: Mon, 9 Dec 2024 15:03:46 -0800
Message-ID: <CABpXueVHKRMXGQk9A6Xs=yfhx4RykFwLPuoEVEpR1Z3pLkZdpQ@mail.gmail.com>
Subject: Support for xt_bpf in nftables
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I have some policies implemented using iptables and xt_bpf. Looks like
nftables doesn't have support for xt_bpf.
Is there any plan to add this feature support to nftables in the future?


-- 

Sridhar  Mahadevan
