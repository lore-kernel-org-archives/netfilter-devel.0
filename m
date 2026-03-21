Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A07E37DE97
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 14:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103126; cv=none; b=YIVLStPQdbE2d0gteXZ3dzZqvbCmZmPaZOatQsHJtWJfdzNXcMQfsysupaiB5kCD6OMR6ai6zsxSQsU+Yu6FojpDorDo899S9aMLCDZPW9vbOARJp7Sxt/HSmysXqtyexOxqxXJccI1imi58EE1mUaFCAsA2ExKKwY7t2FCmKNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103126; c=relaxed/simple;
	bh=434EW88iCH/TnSS8Uyjyzx3nfR5Rs5u9pi4TXfGR3UY=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=bCpMNRbEVQbDdK224CKZOGun8Ev6wpRw4M1hkPLVtM2HeQ6ssM7fOKodHhko3P4ykpvVZrz4zLWdxjhXHQROiP0AhRQ899l/ffUZFVR9cj/4i8pDDcDjGJ+5HPYz/4uQorqmFGKeTx5i2m/yL4IYOafAJ7vD0NoklJkxKWG1fhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EoEVd+n2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YsL3y2QE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EoEVd+n2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YsL3y2QE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774103120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NuUnMQWvpUsQlUPUFGoCoFA4alw0Y3WvPnt5+U2X1nQ=;
	b=EoEVd+n2Y5Ng3OWwfRRwBMyKi5OqFtrPLmRivCZe0QrzRZiKk6qcFpA9tZexzkJKKe9JcH
	SmK0tUyfJ5xRLxzlEQL/sCTKSfvfA6nqxpWsJfhFu3i+uoKKxk0fMvGw77fHpnuYHpF5hI
	/sdk7bZbcRedA/EjhmF2fAnMa32zSDU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-Fqv08JhgN-OE5-OCFF444A-1; Sat, 21 Mar 2026 10:25:18 -0400
X-MC-Unique: Fqv08JhgN-OE5-OCFF444A-1
X-Mimecast-MFC-AGG-ID: Fqv08JhgN-OE5-OCFF444A_1774103117
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43b4e102d77so1762468f8f.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 07:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774103117; x=1774707917; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NuUnMQWvpUsQlUPUFGoCoFA4alw0Y3WvPnt5+U2X1nQ=;
        b=YsL3y2QENLqHcB5ZtSLhY/TEipvQDqPjZPS44m9FNQ8BoROcYarYXK38BO72cq2W8k
         437sRQ8utjqHTSkvuIodLOGGJJYUwNy23+n9+DrWUAamIaUmUNF1qp8YboTmU3g0Zh9o
         H6SArLVm5jLjnASoCbj1HLcf4D4ty7qMmxrV+SjrkQwOA9y4PGoGdHPF/lxW9FCFkiUl
         F37SqiwFT/d92gQsZMdT5RPspU8HUiVi0RkDzgOZkDnjaYUA/71DlKed9cMSKGEheyle
         gynA3kzuvTSKDyAEQKBMBBkuUNVC0vEFpBI0YihFsoAaFkDZ6uSsn3GxQguAqYRfCW4I
         ftqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774103117; x=1774707917;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NuUnMQWvpUsQlUPUFGoCoFA4alw0Y3WvPnt5+U2X1nQ=;
        b=MfPWo8U3BMl1/msf348NczWhkXl9DgHGA36A7VL3siBdec/jCDTVQibbTARE0YqSvM
         IBm/o8vXjOcjYzQr2EUXZ3wOXRHiTHU/UIGxY20uIQkfMQySYiwc9xDzu9OQ3BtYnDM1
         YFqwRLcw1queRceJuxf0+8wsu9ngvEp9Cg7/DeUdAAyCZnf0/OuH21ye0v+ZDth3sC4D
         NqNYUM3k9OBCI9HQzWKdnHinava2xMEzDrUFc5z2M3Mi/5EW+CUhNmbuMrZAkzKofXEy
         Q17qXWzl0sGcAI0B0hNMJe+9wTriDm6jF9TwdHGP3FMCC2loGOA3NSpgQ87sq+0vQMCE
         STJA==
X-Gm-Message-State: AOJu0YysjKbRhvIeCo9LwIUK5cXxwnfS0MoqqIQq1uOhHatpGGZdp6ow
	QZ/izutT2Nv5kdbXkFgvfQX7c0DbdBv31y1Y/Jtpg98deqU5PxesW+Vz4vVWnt/bqpyvcrmSTMr
	NJp/117d0D+vFATA1uDefuOJfxtgZX4pV+btvU2KkUlXWnoDMuPr7mi1SW4qV3xx+HgLVBQ==
X-Gm-Gg: ATEYQzy2RG0jTXxjpDICsgYhHwmcTEjFlW/G4XcMVuYyNV8syuc0R6Cv4txfyMvJV9g
	/fYG1mOAHzp7kR5ZvZyC9t+LYk+pIyxgmokeEhsOYIuYF5l1VPuTDx477sawFnNInltRF+2ybnI
	ftBWtKf8X24TO8rlZtnqBEhiwL6oWARAROOuwpgk+foegcxw/++ILSmhKCsK70OrbtWvnW4qEhs
	lSmAiuF9NzUAS0tFSB303U+NG8z9Y/+ouG+lLiFyPPguL6RcBZRqcgrQi77/Q1RIKJQNrhow3mE
	Eh9jVX18cMI4Tv9ZZQPVbXIeVhE641oi3nucmteuFtWHSCNrWLWTRz3u/HH8vDkETHwbKOkHhf9
	CA0910JLeagaGKEE+CfItKzOHTuWJOAbt
X-Received: by 2002:a05:600c:8b6e:b0:485:3949:e5c6 with SMTP id 5b1f17b1804b1-486febb56a2mr88528615e9.3.1774103117329;
        Sat, 21 Mar 2026 07:25:17 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6e:b0:485:3949:e5c6 with SMTP id 5b1f17b1804b1-486febb56a2mr88528365e9.3.1774103116798;
        Sat, 21 Mar 2026 07:25:16 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe68ec05sm220872775e9.0.2026.03.21.07.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:25:16 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_set_pipapo: increment data in
 one step
Message-ID: <20260321152515.5bc0f77f@elisabeth>
In-Reply-To: <20260318133840.1334-1-fw@strlen.de>
References: <20260318133840.1334-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Mar 2026 15:25:15 +0100 (CET)

On Wed, 18 Mar 2026 14:38:34 +0100
Florian Westphal <fw@strlen.de> wrote:

> For unkown reason the C version increments the data pointer in two steps.

That's because before commit e807b13cb3e3 ("nft_set_pipapo: Generalise
group size for buckets") pipapo_get() contained the whole lookup
implementation with __bitmap_and(), and 'data' was used as pointer to
move between bit groups, and incremented as we went through them.

With that commit, we don't need to keep 'data' updated during the
lookup anymore, so I just replaced the initial increment, but I didn't
notice that 'data' isn't used at all before the second increment now,
and that the two increments could be merged.

> Switch to a single invocation of NFT_PIPAPO_GROUPS_PADDED_SIZE() helper,
> like the avx2 implementation.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

