Received: from out-93wp-a12.jellyfish.systems (out-93wp-a12.jellyfish.systems [104.207.68.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665444DDB24
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.207.68.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790605443; cv=none; b=XpyS/2cHOwZOSbhk6dJs72Njpd/PcLCbCT/581376UY68KsDwZFHPEGDezdMU3k/q9ufg2IndR/8gPdoUYfaKAuwxjb2wokI2627Q71esUqtyroOXzMyBcIaeRGGPQafLqEDjQmW+3UY2hrZcgb5pn1tZzGl8Ld/TeioXeJGH9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790605443; c=relaxed/simple;
	bh=72L8JT5L1OhoTOoS7iNlhMG+yrlpogfU0iryzl5yM4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHeajYC3pI5yBC8L46cmab+ZlnQD14l5WF5cvEOMLVZinkplddx9txwjqi0I8rSvaFDz2rwh2Niy+AR4RoI1ZmVoytFce064OtL+EcmgfCHcebVCgq4WgY408cQUXQQ3bOO1ofDOiGFgvu+GnZ4BUbGVa2RR/3OxRfnBBJQl6IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=GjYXGgdV reason="key not found in DNS"; arc=none smtp.client-ip=104.207.68.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="GjYXGgdV"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htk231tCbz2x9B;
	Mon, 28 Sep 2026 14:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790605132;
	bh=3bzBX/01NVwUmpAHpHukVpoBLx6jcXFgt8lB+0PA8fU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjYXGgdVPPoOSPnIBsVcds0+XLxYaaybCQ2Gyv0HR/QzvSa5lxEUQZiw78Q3b5A9Q
	 Le1afNcqAsDsc3HPC2TZBwG0YdR38GPaacmRt4LevAfq2SJJSQ6x5h5bIQWNLTf5/J
	 FNkreMYU6X8/mCT0Lyici6ohMNYiWQyBj9RK94OP8jfHG4wZmAfs59NZy4VS/AmGkX
	 QR+faf5g5W9Tes72hAgso+7HjYAneoA+4TVJFYaladymMBire+jTbZXT7GmaXYQS0f
	 gI4nFayGX39q8VR3G80G3DKvKqgD7lve7OMpm7iQ6Kwa4ft82zy0vv51z+mk2ZE4W1
	 wDxpYQo/TL3rg==
From: Rahul Chandelkar <rc@rexion.ai>
To: netdev-bot+sashiko@kernel.org
Cc: Rahul Chandelkar <rc@rexion.ai>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v4 1/4] netfilter: conntrack: add shared uint and port parsers for helpers
Date: Mon, 28 Sep 2026 14:18:50 +0000
Message-ID: <20260928141850.55015-1-rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179053062118.2160803.7576370507948039473@kernel.org>
References: <20260923120738.2844168-1-rc@rexion.ai> <179053062118.2160803.7576370507948039473@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

On Sun, 27 Sep 2026 17:37:01 +0000, netdev-bot+sashiko@kernel.org wrote:
> Could the digit-count limit be dropped, or else documented in both
> comments?

I will keep the limit and document it.  It comes from sip_strtouint(),
so dropping it would change what the SIP helper accepts.  In v5 both
parsers will get kernel-doc that states their digit limits, and
nf_ct_helper_parse_port() will reject any digit run longer than five
characters.

Thanks,
Rahul
