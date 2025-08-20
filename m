Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4642C21C3
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 16:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755707699; cv=none; b=dT/90K1Nuuyqyb089ktOHlggQrI/Hz8PGnRt4g/Ah9EqCatmujUo0kNp1SphqU0tIm/G4uOrTzXQT6bsi1srrdQgOQuSnIHCamQ6Ph55GkOtfJkhwMDJn+ICKw0fyQ1RC1W3ovE0N5AW4GvwwiBHEOS0V/eNt9GouYhzz75joyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755707699; c=relaxed/simple;
	bh=ivJ/AKFgYlI9BpRHD+grW9QekugMuG4q2HW0Xesf9LE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tx7W9EA8e/vwao0ZjRjVVySFP+2eOgw5Cx07PHrYUCGcoBKbs9zg3tr4b40N+VP/dhhcatEluqGoPLCq1TVlyOm0CZNWxOXhOyasNad6zB2mJf1Gr4T3BsSHYZTiEzW+LwYnefhy98w/vqeZ1hR6r/eA4xz3GmZKtG0wHfz718w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rp9RYL+m; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rp9RYL+m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755707696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DW7I78a0LfaLdh/eWY75INGRE/2Kd/ycxvLu/AZX9Uw=;
	b=Rp9RYL+m9koG+le3vqSQpC7htHqZprT9uK3nzuBvqtylzwXkpOFX9fh/CBWpPpLAT9BYZy
	4ERQ86VZAl8mUoMOEZXJVTKuOqApuvo3z9a/MGPalQZjZcw44rQ+Jng9Ryz2Ev2yQQgdGp
	8qr8AMtszKgnmfmZgQnRMtx3I6NjFG4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-ZqeWSazlMceJjNG_EzwCSg-1; Wed, 20 Aug 2025 12:34:55 -0400
X-MC-Unique: ZqeWSazlMceJjNG_EzwCSg-1
X-Mimecast-MFC-AGG-ID: ZqeWSazlMceJjNG_EzwCSg_1755707694
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b9e41475edso76455f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 09:34:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755707694; x=1756312494;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DW7I78a0LfaLdh/eWY75INGRE/2Kd/ycxvLu/AZX9Uw=;
        b=XK2HV+57UkcNbDinEmW9d/rHkW9oj8MM2S2ZXKs/DhD2Egdqy3HEJbauC2i8hZd3D8
         a54iUEmIT4Af0VGKk3q1hoK2hzeomziy/eTDtGSJCjIF/Ltub4I3RFF4G5BooHe8kAE0
         9rftROuqfmqa5QvknKleH+ZYUS4g8u0ImZA4sTJ6OEXq5icyvDHpSDNlzijm1dtljpsf
         7HLSPrV8IsUZG2ZkV8YsIeknRfaLJx5fcEtlaYn4Qzaf8DmFXbGDyZMGOGUZZy8Cju/b
         2p5ZpjGML+V4QPGxntP9DrBZjJCQ94AJPAFEyrY8yHEyfNi7xL27CS4rxmTXd9Wgzy/P
         +JmA==
X-Forwarded-Encrypted: i=1; AJvYcCV8T7uHGGgSPcWTrg9vH/oHaY1f2Qm8v7AnK5ZGgA2sPPI+kJiGSUFORbRCx9lvkoQEd/gTfKYfg6Z2IVKdg2U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzxyTrzZfe9vtszW6nSTFAImWR+hjWoUX4SxeatPccUcMFJHSRy
	zRsx218tUPfIOb81mM+RH7AETY1L8OkJH+mSZvgpTTi0GCx6Y5c9l6TLN7EuOo+nAyJOKG8SNQF
	wnZX3jkCRqr2PDLCsXg6CwIoiPOKglZZy8EqE4DMqQAo2rHPUwBefFR+5VmfKCEloHtKgdg==
X-Gm-Gg: ASbGncswFrpZoh9F9rVsqlz0/Ng8pEYn+V2uKmeg8AarflDkP3pIwIM67CMhZs4Jha5
	4od/jnFbf+iLuloSEGwePVlwQAK0k9/I1/OfYLl5AR74ev8d42Ju1GJLtWS6PcREXjUo5E4Ycwc
	GrpAXdH8mVKGsvwe9hQbxIYLcwdB/PIZZWQHjmIXpoRvd7Zr8c3PsPvQDIB/JHPphcIzTLTJk6B
	OBK9MfRpSHAt5fZGAdEsBnxWlz2GkPFcLB+q+89YfGsP16et79Sba296J52pqRSL/OXroAd0CVF
	Z5+wFUiMBS9ieP80Tyhuq36eZSoPCsDWqP2UGWNj21viA0auAxQ=
X-Received: by 2002:a05:6000:3111:b0:3b8:f2f1:728c with SMTP id ffacd0b85a97d-3c32e228eefmr2437621f8f.34.1755707694059;
        Wed, 20 Aug 2025 09:34:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0wwswXfSTucWugSA4/lxjx6nG3TfbA+Xq99v3jdk6ZdW7Z9xtG0rPSe1mcfxUp2wjDwyHHQ==
X-Received: by 2002:a05:6000:3111:b0:3b8:f2f1:728c with SMTP id ffacd0b85a97d-3c32e228eefmr2437589f8f.34.1755707693643;
        Wed, 20 Aug 2025 09:34:53 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c074d439adsm8410072f8f.21.2025.08.20.09.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 09:34:53 -0700 (PDT)
Date: Wed, 20 Aug 2025 18:34:51 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 5/6] netfilter: nft_set_pipapo: Store real
 pointer, adjust later.
Message-ID: <20250820183451.6b4749d6@elisabeth>
In-Reply-To: <20250820162925.CWZJJo36@linutronix.de>
References: <20250820144738.24250-1-fw@strlen.de>
	<20250820144738.24250-6-fw@strlen.de>
	<20250820174401.5addbfc1@elisabeth>
	<20250820160114.LI90UJWx@linutronix.de>
	<20250820181536.02e50df6@elisabeth>
	<20250820162925.CWZJJo36@linutronix.de>
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

On Wed, 20 Aug 2025 18:29:25 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 2025-08-20 18:15:36 [+0200], Stefano Brivio wrote:
> > > As far as I remember the alignment code expects that the "hole" at the
> > > begin does not exceed a certain size and the lock there exceeds it.  
> > 
> > I think you're right. But again, the alignment itself should be fast,
> > that's not what I'm concerned about.  
> 
> Are we good are do you want me to do the performance check, that you
> suggested?

I think it would be good if you could give that a try (I don't have a
stable setup to run that at hand right now, sorry). It shouldn't take
long.

That's because I'm not sure how cached accesses are affected by this
(see just above in my previous email).

-- 
Stefano

