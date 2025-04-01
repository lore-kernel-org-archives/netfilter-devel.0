Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C894C1FE45A
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743508669; cv=none; b=RxndG/fYadPHm12eVQSwAr5uDk+tvnE9Y/ruf9x2GCtZRT5HY5XTZR50jVvd/GHEVWb639tlNLn3iJo8QirTHaSOzPyhp4ZnDRDyNHzPLdY0dYCDtrSzRapFXOwVx1Nz+W406E7a3WW58xCPb04Me1Mma0i8YfAfzRsFzldAUHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743508669; c=relaxed/simple;
	bh=l7kYpJSyNb4LT4PNP24Ib/mZ3/rLHCzQ/AGuD9oUJk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qQM6Z8M/qgk8pXNpVlyhZtAeyIIl3g7m5T2iswgho5zAaOha92mdLXzCD7bskuvDEHE7WMTFj65TGq/4UJGQYeGg1G8W9qcoS9xsdmwaiRk6kRcQHzjkxQFdR6V7O8jKbhBunMWUHiCQQ5gEU4pCQpmqgkCwEC7eFFex8qjH3GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=G/37PlTe; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="G/37PlTe"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso5256342f8f.0
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Apr 2025 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1743508665; x=1744113465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MjzUBL0mWJbDDZlrnw5hFFgQWXS6aH/9lQwvSCFdxu0=;
        b=G/37PlTe6dVwtK9jB1BqXUvwRl+5HIqSeAa7rNxVGIkKQUhMT3dFtMPXFYxQXkv37U
         hcLg+ocC3N2ycdiJ6F66js4JvlqYZ6bQdRB7YtAITOpWmTVTXE2NSy/7QWyF6WvvMWEW
         h8N0VmWCEnfYX7W0N1U4k/L5ki0UDlSJYQAMLRiKGXWixqD9J2D2DeBoEPPBRAVhMeYR
         oDe5Q9ZidjV6wl1vRF+MPqFux1l5r0LNICOYE/4zXOR6FMVm5AzSebk9EVyAfKUF/Fub
         2zE4b87Vz8CGvhJh6+Z+sTkOK+mRKcRKg6qoMm3jchj52NISDvRCVFx67aSGWSEmNU2C
         axFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743508665; x=1744113465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MjzUBL0mWJbDDZlrnw5hFFgQWXS6aH/9lQwvSCFdxu0=;
        b=sqAvQVoYffUOdpi2EKLVlgujm5NpfGObEWPKxYil7eEraAG7h67rJI5A+Hc19fAIOx
         inplhimfgiNL9SxWb1veuieF2LetdOr3ivmlnuccyU7h0ojYAIynWH+ROJJBlKc0S/+8
         CHKWQN3uMqLibmEIJQKRPdPaZ6FVGdNvbCoTTJpX4toiPE8DQ5G/vq3tR45u9wuDjD0i
         bCzQxg+vDDhvKKxyomhlO0bh1DgiXpZuoDfwZaW2ViqfpY/u+cCMm2Je5kzdnqVGLVOQ
         GK0ojIWPPnANNDiBOmcwjHy8MOmrJq2iiuNAm85mzp8Sbj59MUyaoO7AXhkwApBM0LMd
         etOA==
X-Gm-Message-State: AOJu0YwsAFPcfmuVSe45p9LlwTtDYjKdBSmh2nWzaGRPpdRYjAjObDa6
	ZFtn87vWNek/g3P4q0UM8zmOhg8TXUCbFcFLXubnaJus8kaGTv8+TjvDpI2zRzr2Yh22oAIp1eM
	J
X-Gm-Gg: ASbGncudDrbVOEqyv9nA89QtHngrDP1b1L7RvTMjM+Ua8MJ/4qNVGQrHlb75fjlFvaF
	OiRWut8WrkzzOr0ufjbGVR2kAY6j5yS39Np5Exmm8pLfGfk+D41N9AScCE4zuEBUyIrqyh1INZf
	BieK4JxG/t9H18/hLz83Uhp9qW77n46wsfQgozOb0lYriAf9aFpc8WEvNDJC3DaXFWVlAMMz6yQ
	bHU05CzReNaa0VPIM78vYtp3j984eXauVlCsQ4Wd9U4UpT6en2Xs/OOcdLpbQ1PAOv9shSp/YPf
	XQNbfYQautuwvZ1sIJ+P6mBY2Ws86qoxvrUyqE8Z8wTHOuqgU4MykZP2rw==
X-Google-Smtp-Source: AGHT+IGf9wJpKPB8sOAif2cBapevtQFgZEdOvFtRWa5cgAStYv1CeTH/1WOTDBZFxqFzQq9JOq6DIw==
X-Received: by 2002:a05:6000:4282:b0:38d:d0ca:fbad with SMTP id ffacd0b85a97d-39c120dededmr10748348f8f.14.1743508665067;
        Tue, 01 Apr 2025 04:57:45 -0700 (PDT)
Received: from blackdock.suse.cz ([193.86.92.181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b7a42a3sm14130150f8f.91.2025.04.01.04.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 04:57:44 -0700 (PDT)
From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
To: netfilter-devel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH v3 0/3] netfilter: Make xt_cgroup independent from net_cls
Date: Tue,  1 Apr 2025 13:57:29 +0200
Message-ID: <20250401115736.1046942-1-mkoutny@suse.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes from v2 (https://lore.kernel.org/r/20250305170935.80558-1-mkoutny@suse.com):
- don't accept zero classid neither (Pablo N. A.)
- eliminate code that might rely on comparison against zero with
  !CONFIG_CGROUP_NET_CLASSID

Michal Koutný (3):
  netfilter: Make xt_cgroup independent from net_cls
  cgroup: Guard users of sock_cgroup_classid()
  cgroup: Drop sock_cgroup_classid() dummy implementation

 include/linux/cgroup-defs.h | 10 ++++------
 net/ipv4/inet_diag.c        |  2 +-
 net/netfilter/Kconfig       |  2 +-
 net/netfilter/xt_cgroup.c   | 26 ++++++++++++++++++++++++++
 4 files changed, 32 insertions(+), 8 deletions(-)


base-commit: dd83757f6e686a2188997cb58b5975f744bb7786
-- 
2.48.1

