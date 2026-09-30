Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C124457DA
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 19:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797860; cv=none; b=JBaRQGpqWMcDiXdRta50BoZrvr8zzL/RvnMWkrXZYv2joJhM1TF8VLZSGeXxvrFaT2YmuuFRJzGDALfodPzus0Y3IEOPVfwzZOFNhBhAk4T0PUISo00DsUoqUheGK+XqTILLy4vZloJt0AESYherS/XtKSc1zSCrvcvnYptYvug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797860; c=relaxed/simple;
	bh=g8kSnvXNg0KFakuMMNxgd5z8HZ/cGn27nYQqTIEFHGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPduD7NwkEf2tQ6ouSx3+jnlw5lqwslQMi0A/tZnX3kt7np9JTYUGKdXp9CdaD4IhMSfz586zAfiuUnOipA/EgYSmS/4HeES4wkfBTxDwkXBaXLJhJnNWCKOFLQRs/RR9x52CgNyoVFMrvDvUsZKXOEZz7oa6UxeI1WTK2r6GD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hVJn29cp; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hVJn29cp"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f690df6so4148654f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2026 12:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790797854; x=1791402654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zG43L4MPOSqtW553TU6Kwtxr/jOwyLkxMDRoqbA2Niw=;
        b=hVJn29cpn3+KcOHe9SpXVCzTUo8yN2AuOuqmjhAiLUbmkPGjFAgAcGoTpn9s6P3gr4
         mPL8xwOQEhjbzymBOet/w8JSFmlicmA6aR8Elt3F0KE3Dt+gavy8Jwk2QoeBjo8NV/FV
         wjF51YRi4f+XfooLc6xkpgFjoA2sVpvA8arD3zA+m/h3diO4mPpxthhhcpKMTTg7RLUu
         pUC1OOmdKZUXXxtQtBlKsvR9NDZHz0eQdrt2/DLH1xJtou4KqgwAB6oy9ero8nwDy55w
         1PqBN48jv2E4Iw1C0dpi0rZZgAHYRbAh170N72AfmfuPZzuaFFCTthdwR1HM12r6GXZw
         2Lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790797854; x=1791402654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zG43L4MPOSqtW553TU6Kwtxr/jOwyLkxMDRoqbA2Niw=;
        b=jc6rZoCNnUWSQ6bD3Zu7PL6GaMXiZeptgYilOOFUrc7kHBrRcL3tWWYnUdqoTKLNiq
         HTH0CTn/oZoVa5r6ZqEDS1hr8g1DjskPM3JHW8izA+rBN2HbYB2bJhr4VmCWJoxZAbLY
         u9nUmhpfXkvvwnZYs/vnipv5uSX/TMb93WEwjNuMfU3c2Y6mTDddndf1ZO7abN26it06
         DJyyaFHMkhUYUcUL8EK1gq26dgYxaT6y2isjysHeLo7dkOT9NRfuZc65+Rz/bLIuPNMW
         Sn5Iw9VsSHED3Z2kENE1GL3KwQelIqw0wCSuuOzcG/rl5Pm2BKmMC7NmQJ4lGg8mp56x
         NEfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxQVgbTu7dzSb1/lNGdFOsk3ZSdTg/UbIuNMhrrHuI6ZUN0iABtm/O97f/zjQQL6wUrkqjn9dXE+qjQwqsNilY=@vger.kernel.org
X-Gm-Message-State: AFq9FYLkY2ABy8uLdgEqDivRfBhDsW79942ayeV2qCL0rW543hQsv9CL
	l9y3dO3oNCwzTXL0XSdiQCjlsNMEvY+HFw7aPjFlmu+RMs7C6t0EqvZQ
X-Gm-Gg: AYBFou0GHuqNiF8XjZrbnOiTc/HeQddUUk++ikI5y7MWo0tGPWBOI8KodJtAd5k5RZS
	2WYiQRq807EcbqjHPmlWAun9mZ5rs5OHlW8BwCKgmpIgymrvbNYacqiTQLE0/hoKnmROxfw6JsF
	OpFif2NDF4pgRPqD/0Qd+r+WCiDeI6tMln1W9ObUPo2BdF1f8tPaAsgALW71NjJzgb04H6HuigT
	7D3se3fh19rqItJCw7tPGW7R8FD52LYTmhjZmvOwnj/lwcW+fZGtPeOrA3rj4374PbRolwUG7TF
	fhjPLza4zZ7WDlokEoKSqdlc7YoMuwk99NReLu2GONly9tBVUUveu4Z+UrZgovmYD0MHGI/FBSP
	FApxgktQPg9GR2tdmEmPt6enjLFrAEztCug91t4XYekCRsAmAsP6LwWzVHtTLdIt2FjiE+O+acS
	cS4brJzdb8+5P5g0ryQTETgFijwGZ36Fq0Hc7NGaoznjEAWKGhfIE93ICswa8K5EzbAvbhsLYvP
	n9z+jkMvh/VfMXaIJZWjWNYaeOKLgc8n/Wh3RoeM1mW
X-Received: by 2002:a05:6000:98d:b0:488:83f7:6352 with SMTP id ffacd0b85a97d-48b0243dbe8mr4875486f8f.4.1790797853873;
        Wed, 30 Sep 2026 12:50:53 -0700 (PDT)
Received: from andreayoga.wind3.hub ([31.189.116.68])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b0692b5c8sm1101574f8f.29.2026.09.30.12.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 12:50:53 -0700 (PDT)
From: Andrea Parri <parri.andrea@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Cc: Andrea Parri <parri.andrea@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: br_netfilter: restore VLAN tag on refragmented IPv6 packets
Date: Wed, 30 Sep 2026 21:50:36 +0200
Message-ID: <20260930195038.64098-1-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <179061238760.31693.2318453255259270234@kernel.org>
References: <20260928161830.351199-1-parri.andrea@gmail.com> <179061238760.31693.2318453255259270234@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[ Resending with the full Cc list, which I dropped by mistake in my
  previous reply. ]

On Mon, Sep 28, 2026 at 04:19:47PM +0000, netdev-bot+sinfo@kernel.org wrote:
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - Whether the issue was actually triggered, or is only theoretical
>    (e.g. found by code inspection). If it was triggered please include
>    the symptoms, like the stack trace or error messages.

The issue was triggered, not only found by code inspection. I
reproduced it under virt-ng with a local test on a VLAN-aware bridge
with br_netfilter and IPv6 conntrack defrag enabled. The test sends a
fragmented IPv4 packet on one VLAN, then a fragmented IPv6 packet on
another VLAN that the bridge floods to several ports. The test is
available on request.

Symptoms: with the patch not applied, the refragmented IPv6 packets
leave the bridge with the wrong VLAN tag. This is the tag of the earlier
IPv4 flow when both refragmentations run on the same CPU. Otherwise the
packets go out untagged. There is no crash or warning; the only effect
is the wrong or missing tag on the wire. With the patch applied, all the
IPv6 fragments keep the correct VLAN tag.

Thanks,
  Andrea
