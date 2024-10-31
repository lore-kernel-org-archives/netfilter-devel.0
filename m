Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513141D0F54
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 22:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730415226; cv=none; b=DKWeRKbwJiwFiUkvEnCaq2GJ7aLwmxqm7A54i5obGdgTg1NgFWFFTnorsAxo7RfNzxVe1cXh11knekvCrZwjInWu26vEhDmCIB/V18g5WPnfaTvx6Qm+SGLcXpyGoAGjY73KkkF8kHiI9dgnro23ljQQ23m7zylDh06q1rEcbN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730415226; c=relaxed/simple;
	bh=d+KWwf0GkCHU+dO7dz7Ix9366JgUxkGbxc68is0rego=;
	h=Date:Message-ID:MIME-Version:Content-Type:From:To:Cc:Subject:
	 References:In-Reply-To; b=hP1wjz9zSjxbZzOsu0A6BiDY9mz2PI32DTZqWD4xI0pLHQKiGlBSdc0g+e8BtCXGgQVfZ1ycaH7r5+igfKocgLpgUUy2q3i8GH/lo7959gVOVd1rK2W3rH7dnvnoEfdLowS/ZDa1d53V5kJ+PBZKue8qJHJ0n4K2EYEdY4dRZwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=HwhAHJM3; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="HwhAHJM3"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7b18da94ba9so123363385a.0
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 15:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1730415219; x=1731020019; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N/1IevD7DLvIM994VGktPASZhi2RFBUm322v1qsmqeM=;
        b=HwhAHJM3tGqQd5r1l+ZE2Yf79wCAK3bP28oxsvotyurrRNEy46/9sjDN7Nb/tCOQLZ
         Hhb5QsdiXXy2BEMFk6Lw+t2y2JtNJCnArD//sJ8UCnrxT72AcDqYtpcyBDI6RN8dK+mH
         zoxp99b8QxPVllEDJA8BJTPTkD8q5gkl+qUsrgR9dWZaZxQ92Zu/YBzYenTxTk/8vMbW
         B0gzbjS9nnoepjR2aOd+BJtxlyLZH0ykx9Jq/6JPkBcEs6SBSVwK5b9xRw5oD0hqAACd
         /JYdkye1PvTHRqxEbVRUiAPQLszfIdxMuenem/A7QL0ywJOytU7XaS9PGtP5Lr70d4kO
         +N1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730415219; x=1731020019;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :mime-version:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N/1IevD7DLvIM994VGktPASZhi2RFBUm322v1qsmqeM=;
        b=HWczBIrqB4NZ9qsBx8Ss2brg+EqUfHmz61e/VO1M3C/r1xg6lfBxSPaEQZAoKFe7YY
         Xn0iGurAfTD8qPTCXVraH5C4ydh/RbcO3ZrY+orG7f01w54bRCxs+q3+/7RVoigtxRtN
         pFE0VH5jXsuY9ll23lNjHxq0rEv77+E1gYFnoTUqjcBarjDiluAUPymAAK8L+S1pFxf8
         OcTJmg0UBJTIC6FCCiqlDGN6LgrPMIMzqSupu3Ku+k0UhchGsKkfgsUCK2MjO0G5a4LY
         KqNOsi8ngiDgvMma+bCEp1Dproxoa0vdYHcnZP2fIlJHklWhZVQaV3xp8s1NNtdnqzHZ
         vJXw==
X-Forwarded-Encrypted: i=1; AJvYcCXRv1r2c6UQH+QcR7WLZB3v6uWoeu+K4lRPiSLx1zgKM0K2ioD+dnTwLqlyVC8M3EAmjcODwW/iyIRtWO44ds0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhSnRBZhgB6sJD672SLSWVPiHLxLsnALyTvkGs/caUvDkn4A5P
	6RhLWhHcKghUGRbBEE7duQHulRSRsfhpjvwAxekMAbt6SgVDvpU0wbFxqO6IOw==
X-Google-Smtp-Source: AGHT+IHejnUcO00gdkp6GIPiLQ9d5ZeTLg4Tg4eKKtHh64s2L4WuXTwedaEARJS6sJEf6l71xF95Rw==
X-Received: by 2002:a05:620a:248:b0:7a9:9f44:3f8 with SMTP id af79cd13be357-7b2f3cd68f1mr599328885a.5.1730415219210;
        Thu, 31 Oct 2024 15:53:39 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b2f39f820dsm115059585a.32.2024.10.31.15.53.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 15:53:38 -0700 (PDT)
Date: Thu, 31 Oct 2024 18:53:38 -0400
Message-ID: <68a956fa44249434dedf7d13cd949b35@paul-moore.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=UTF-8 
Content-Transfer-Encoding: 8bit 
X-Mailer: pstg-pwork:20241031_1534/pstg-lib:20241031_1459/pstg-pwork:20241031_1534
From: Paul Moore <paul@paul-moore.com>
To: Casey Schaufler <casey@schaufler-ca.com>, casey@schaufler-ca.com, linux-security-module@vger.kernel.org
Cc: jmorris@namei.org, serge@hallyn.com, keescook@chromium.org, john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp, stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org, selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org, audit@vger.kernel.org, netfilter-devel@vger.kernel.org, Todd Kjos <tkjos@google.com>
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
References: <20241023212158.18718-3-casey@schaufler-ca.com>
In-Reply-To: <20241023212158.18718-3-casey@schaufler-ca.com>

On Oct 23, 2024 Casey Schaufler <casey@schaufler-ca.com> wrote:
> 
> Replace the (secctx,seclen) pointer pair with a single
> lsm_context pointer to allow return of the LSM identifier
> along with the context and context length. This allows
> security_release_secctx() to know how to release the
> context. Callers have been modified to use or save the
> returned data from the new structure.
> 
> security_secid_to_secctx() and security_lsmproc_to_secctx()
> will now return the length value on success instead of 0.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> Cc: audit@vger.kernel.org
> Cc: netfilter-devel@vger.kernel.org
> Cc: Todd Kjos <tkjos@google.com>
> ---
>  drivers/android/binder.c                |  5 ++-
>  include/linux/lsm_hook_defs.h           |  5 ++-
>  include/linux/security.h                |  9 +++---
>  include/net/scm.h                       |  5 ++-
>  kernel/audit.c                          |  9 +++---
>  kernel/auditsc.c                        | 16 ++++------
>  net/ipv4/ip_sockglue.c                  |  4 +--
>  net/netfilter/nf_conntrack_netlink.c    |  8 ++---
>  net/netfilter/nf_conntrack_standalone.c |  4 +--
>  net/netfilter/nfnetlink_queue.c         | 27 +++++++---------
>  net/netlabel/netlabel_unlabeled.c       | 14 +++------
>  net/netlabel/netlabel_user.c            |  3 +-
>  security/apparmor/include/secid.h       |  5 ++-
>  security/apparmor/secid.c               | 26 +++++++--------
>  security/security.c                     | 34 +++++++++-----------
>  security/selinux/hooks.c                | 23 +++++++++++---
>  security/smack/smack_lsm.c              | 42 +++++++++++++++----------
>  17 files changed, 118 insertions(+), 121 deletions(-)

See my note on patch 1/5, merging into lsm/dev.

--
paul-moore.com
