Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE45335F60E
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 03:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787197408; cv=none; b=hoE8Fa3elZEFubjIxkbqibNnJ/m5mBxB50iqtuWOKoTeAR07zIcLmuiZ/vEVNFi7pftHimpzH9L5Pd7kzaYtyyOxT5yWC96Ec9I7VJCCZPJlWyMEV67nqzjVhBb4SdfQU9zZxv3czka+Sri1xyQrJ4FLU/FbNx3NvqUp/EGGPy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787197408; c=relaxed/simple;
	bh=SUQUzfU153V9eAP2f4m6jjHNOdZgZOb4ZUg9by6Fk1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEPO7+fl/j0YC/imKNr7FLR/5Vk7AfbE1JEb52wCqCp9NfdHKs20D0+dwQ0YTdsdgN1Z7iQzS0eKubQNlY9l7p+7SpBFJLsTe+nECxwW7XtzBPaYiyB7gy1iZ5bAV1i9K98VhGYmMfgnBMkwji1KyU/MyidiGxPtX2oZXFaUdrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KdddVRaB; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdddVRaB"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-836c436a6b3so27177357b3.0
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Aug 2026 20:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787197406; x=1787802206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SUQUzfU153V9eAP2f4m6jjHNOdZgZOb4ZUg9by6Fk1I=;
        b=KdddVRaBHkdbDzv1+fCe2TxwckQxpPZkLNre5pUV9eVFReDiz3KBvlu3VUWYPGU2tf
         kGA36X1YMMutyJiLw9eI4bUcZyIqsD5dhn7+hbvVU2dpTi/Ixf3hCa9ysjLOTBWkweTz
         3SauJS1bQuqq0TcBKoDfEUsAL5FfwDLViwiYlGo61WzTUtvZP1o84EEqAtFDS/vCdK4C
         mXM6IErSz+55VBc5zA8Dx35W+20oB4iqyNgiWmuvSwNyA2iWyK+rJ6ivEfh7JPMfTomO
         L9nGtHkbKrmDjKa+JrSvIO8pzeiEzmZ9I6iIyS03u8rO6sgGKbQvo2uFBMn4hBPjGc4h
         mE5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787197406; x=1787802206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SUQUzfU153V9eAP2f4m6jjHNOdZgZOb4ZUg9by6Fk1I=;
        b=pP+nYgRRZhycjOI8WqiuDt8bwSPUV3i/ezR6WsPzRPtv+eFgU1iNrn777R/cjPMVug
         SGCg5CpW61xsc8mD0uaTYq3cqjNuZ6h9RfSwdqNMpt7UfWMhidpklT8fyLzru5L0uDg3
         0sIBo2H4CiV0C9Zlttk7sU/F8mDsea/OfRPNGRiBS12gOPuXyeyPniLjvDs9ybEwABPI
         L0Mcqewvo62zteJbVfw7gFDF/n4Qpuhj3AbtoZUpFAya+SUsKCV9QdDX9k4RtX0IXAux
         cQe3ANXZ4Ih4ewg6Ubts8jzu+sJQhfxGuDNt9tzYbbxP9+lX1zNNx23ufwcI6pZ4Qzvu
         Pxag==
X-Forwarded-Encrypted: i=1; AHgh+RqdDFdlN4mg3LwxjuMFUgwo9g34ZnCiV9URMdXETLjZm/pt+2gU8m+VYfLv4tpnBFWPlLuSWkpr81Nfvw4YQRo=@vger.kernel.org
X-Gm-Message-State: AFuF++mlWOJTqQR409NmL7zZhTAHA6Jjko2HMD0FZWPVSzjQMshxd4Vw
	3R63JXlo0VcNNdA/RO7xTIhcHa3/Gr2C0zIpzpuzYFmAWzszZQhJ7YQp
X-Gm-Gg: AR+sD12ogV5eAq4HGp3aeCwHW3Jl+SfBdven5tVuBVV/XBV8ndrONCaxWTUN2qqQaDr
	SHMa0puEKoXYPSsAHRADNEaWBLfVXZWTk6inSGTfcyDKlHBE0b2ykG1QO+KI+ykgIedQohrJAXV
	aRskniVRLAp+60SVUhcfiGsZ5Lpeytq3N31b9+O9zFYihA/YpOJM09XPnbBbSUsdAbeRQYEeaAz
	F1MpZx2wzETzmjbk1ZFfZiAzuZJQGm0Ch0o7y169+9EhErTMLjFiIiQd9kJbyOv5S3vaFODlqgw
	4lNGda9M6nb0Co9//mxfERNf1YQirCe40l1dwE8dDhhp6mtM3MZKy6nYwWQwpczWM34/3cpGCtJ
	RQ7ymr0Jn1QpvPLOBu24dLZO47Lf9zH5EeCS63K1nBMipyM3I4M+IOdGGnBz3mv3lGFmIYG3/5s
	/rzUcC1fhuX5Da6lH3Pd9XCmyof4c3cO+aLDR42PLrK8N335vgfCNkCYYTLuuzPXpdo38=
X-Received: by 2002:a05:690c:3387:b0:81e:89b2:91ae with SMTP id 00721157ae682-844e378f1a5mr42081877b3.21.1787197405974;
        Wed, 19 Aug 2026 20:43:25 -0700 (PDT)
Received: from mac.lan ([136.55.173.105])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66ccafd03basm2037809d50.1.2026.08.19.20.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 20:43:25 -0700 (PDT)
From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
To: xuanqiang.luo@linux.dev
Cc: AutonomousCodeSecurity@microsoft.com,
	blbllhy@gmail.com,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	enrico.pozzobon@dissecto.com,
	fw@strlen.de,
	horms@kernel.org,
	kadlec@netfilter.org,
	kees@kernel.org,
	kuba@kernel.org,
	kys@microsoft.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	phil@nwl.cc,
	sbrivio@redhat.com,
	tgopinath@linux.microsoft.com,
	xmei5@asu.edu
Subject: Re: [PATCH net] netfilter: ipset: list:set: defer ip_set_put_byindex to RCU callback
Date: Wed, 19 Aug 2026 23:43:17 -0400
Message-ID: <20260820034317.79295-1-blbllhy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <f3093e85-fd58-420b-b435-c39263c46e3c@linux.dev>
References: <f3093e85-fd58-420b-b435-c39263c46e3c@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Xuanqiang,

Thanks for the review. You're right that this effectively restores the
stale-refcount window fixed by 439cd39ea136. I was aware of that
trade-off, but focused first on preventing the kernel BUG that can be
triggered by an unprivileged user. I agree that the final fix should
address both issues.

I'll rework the fix and send a v2.

Suggestions on the preferred approach are welcome.

Thanks,
Cen
