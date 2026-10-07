Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC2F3403EB
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Oct 2026 01:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336792; cv=none; b=ALzcj8+VEyOPzWkgPHeHm6jIxzCKTSsQMlwxIQUZPBPF9an0RaA8wfLyuxwIiulWpY73maNZ9jh6t99wZkaM/qfbHe2QcexmTsUSMhg/r2d2OOH32zrsSZEEysINtgeqXcs1AoD7hioHYmpnSzjLql81Jw49Zfkfj/xZ9Hy9Z1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336792; c=relaxed/simple;
	bh=yT4qk//tC5xJd5Q78Wf4BjrbWUdWEvx1U2HF6URaQYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KiSFR+gNnRnMh4hxOl94wS+FwNN7G14f+aT//ruYYkAR161yoCuG2VYLlZ5FDVzLNdRS1IgkAYkCZCPWi3CEY7Oq2/TpU7AVXb7tqisNlrdiywMm6Gi3dSsgrmgO+CB3CCjlqGnb8cvIky9S/FTmybpYYbaO9UV1Qw4ROsdk4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fC4jiT5R; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fC4jiT5R"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e2de97b4d2so11492705ad.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2026 18:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336790; x=1791941590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kt3VjxAsGdSe7dCl89WOHYsP0HUrLZc3A78+p+uWquA=;
        b=fC4jiT5R6+4CtccnjJz79W3VL4sYdkWB87WBVTVWsmwTdsPDvwyzlQ6Tx3G7G3ZMjT
         MXw+0hsEpLVcpuerGXlg/9zzmLv+BPJ84Pf/uLNfIRvcCsYj+lmJfg4a2tveAqaM40SE
         DNxrCQ9V7WLOHTj0RA0HNtAPZoyL/ZOWZxgZ1cHgAYX0XRn6Lylclc0oK7tjNILG7MuC
         cT4LbVN6ZbAVTRRCqThsmdzc1cZLeB4mvPPGTZF1XL3fGLWYGmfDTzeBMniZE+dpz2Xc
         zD/8eNSG+q+DRK5QPt2l/kLyG8PZtAVSsmD72VgVeed+JimrcOqxQ8mkidjRtccEskIc
         INUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336790; x=1791941590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kt3VjxAsGdSe7dCl89WOHYsP0HUrLZc3A78+p+uWquA=;
        b=ERHUz3qSMFG7+GcIQGENbzT0ioZb9znRDeZJyQZ8x+5DEgCTYvHvrwpoOWqElOQGuS
         OYafTmo0UXoX/QD6O9VFQEIDS/YEzUpgdfJvdsiURbv8cMpelTmmxbwR+ppmvj8hDnmn
         9HiaBkxibI7FJsGLaBwRH/UpfKsRncNQ6tzU3Ox5HZC8tYiNQtzUnaoyOae/sPYiLIYy
         P5Mnb/JOjbvHQ1LZT7v6OU7PBp3+quJ0NtQzveBPgBsgqe4f5VChGw/8pv49zebWpA59
         EEr5syqdJJqPNYbNtf4eZ+ResaLiXc+Hb87FPQXje/BGPEXKXFocRnqFKI307mumkxsj
         Pdhg==
X-Forwarded-Encrypted: i=1; AKwUvBz2CWum0Efhc6woJZMSQ9W+AmP4u/O6CIKXE+KIuLU9Sg5BUPjZXJkWqHK58D1XDqbMxxuv0dzmaLSuQFN2/q0=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ13z5OMcNqsmCA0rsw67WpQRjIy3EjA7e9Hzmuo5KGE1qMZOnC
	9fs+3H70F3dXiUGhANg/0+zoWUc+y4Z2GHK2A81uNO3gGx0Z3U2aQh7u
X-Gm-Gg: AYBFou3BQiuuJQIWQQDABVF+TQD9RX87e4DuU/YwraB4OcnOocIF2Vu6rmliB5qT8uT
	95eDTQKUp2InuWCiTp5v2uAPfqfwOXqwKzTTpS+F7YoM9F+Gr5x8N69K88a1YKc5hngtoTENeFr
	4lmBMgCf2vxZrQ4V/FKMCCcvBsdItjbVxCUJ6OfEBxfC288b6NVR9ZkC92GAGA/bW/p2QWmZo5h
	4O8YCzzlonuXKgv6JVdQ5f8Pemk2brSNSvWgeyb3sVLkJBXC/EJEqZRkp6f3nGdaNVbic0qHO2M
	fzCDwQv0mt74yqZQrM7KA+pF3Om/8+Eix0ljeYx2WNXWG2cnQ9DSp7Q8P3t9U+2WQiD8WWRw7o1
	0tRNlUCbD4W66ENIiNIG4reVUdVW20dwQS4tYIyl7g4IP4hXP5f0tI7la8se0IggTM3cmQQBmP1
	0uF4Jd9OwEUOC2bcToTXCi45My5pZoRbpHL645Mxnvx6CiHes9QmpVviAxgK/a+I5Z1c0g2f8Ld
	94StgL5jI8E
X-Received: by 2002:a17:903:1b24:b0:2e2:ca04:fdae with SMTP id d9443c01a7336-2e6003c35admr8419835ad.30.1791336790576;
        Tue, 06 Oct 2026 18:33:10 -0700 (PDT)
Received: from ancienth-X870E-Nova-WiFi ([125.186.72.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604852079sm2958395ad.60.2026.10.06.18.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:33:10 -0700 (PDT)
From: Daehyeon Ko <4ncienth@gmail.com>
To: netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	kuba@kernel.org
Subject: Re: [PATCH v2 net] netfilter: conntrack: reject nested ctnetlink master chains
Date: Wed,  7 Oct 2026 10:33:01 +0900
Message-ID: <20261007013301.2524415-1-4ncienth@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <179127347858.434549.11821822167265441355@kernel.org>
References: <20261001180224.1018290-1-4ncienth@gmail.com> <20261002165601.1754467-1-4ncienth@gmail.com> <179127347858.434549.11821822167265441355@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review.  All three points are valid.

The nft ct expectation object can attach its internal helper to an
unconfirmed expected child, then arm the next expectation with that child
as master.  I confirmed a bounded four-entry chain through this path, and
current net retains the same unchecked transition.  An nft helper followed
by IPCTNL_MSG_EXP_NEW can repeat in the same way.  The H.323 Q.931
call-forwarding path also propagates its helper without a depth bound.

The CT_NEW compatibility concern is valid as well.  CTA_TUPLE_MASTER was
introduced for conntrackd replication, so rejecting nested helper-created
state changes that interface.

V2 is therefore incomplete and should not be applied.  I have reworked the
replacement to make master destruction stack-safe while preserving nested
expectation semantics.

pw-bot: cr
