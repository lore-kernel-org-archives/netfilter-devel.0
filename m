Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532621;
	b=Uh9yNNkQV+nrZQc+WiWO7y+huRrgoqU3OtuXC211Get6WMPx+3/VZMgaErGzdYOBnETU
	 RVqoDm+jxl4LBg8IfFeEM9YNGCV3MVM6iasioOjKE+eJe/zefIOg+a/3d/01Hlz002qpH
	 9j+kccXFmi7G7fWO1Ch8W4wKxpPHBOLjO1xc8qxYZXdIWwZ4XSvLZOtYZFl8RGj3lN+jW
	 P7F2V0mwwDNscDDf83VxVPvNHgWBUPgSJMCcGXyniGyz4Vv/Zadxcz48bWNyoUdbAsPJf
	 hWbfz9nnTNzawcLQoT4Vho9MiSEU9USKAuFfzdwCLcMvGtwr1ECplCVCR8WKh/JFc9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	b=rc8eK6EgfcN5gIIpaEK+Pvrjt2zmqXaJ2XmSHuXMZp8qS0zkL+N0yHkCDOL3OBRWuUF/
	 SWkN7CBAEcJSP3nc4sXwvcRTt3jnWVK4T7vkBNKL+CDuD8bJb8kQ23wfjrK0HYoVaZJ/F
	 Rkvl5+cmIRE3DfQjo40zt+dox9ulpZqesx9EXrDWnlgmXnfAwaSeXhVp6snuf3YmJ4Nvl
	 pNTKicV172vvQGCJce0IOO9rShkMrwmUGNJy5qleNLIFq0mpMgMGHaqA2Dxvrbya0Mp1i
	 Jf5Ia87aL+Ska2Ixy7eK9eNeSvp2rh7ohEtnvAiAMjrsTmIrQaDhWQGPJpGVVYOI04Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAYPUxJc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469E5606A32D;
	Fri, 13 Nov 2026 01:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EAYPUxJc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A68E1F000C4;
	Fri, 13 Nov 2026 01:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794532620;
	bh=oVTc5I6nKpBiLsItkBZmeShBR8ASpkDeEBpnWBZ++aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EAYPUxJcNB7Ws5AXXuEPGaEj51JKaHwbGafMJ0g8y9T2z6qwns4m2TSMyxAqaOFAd
	 EvuusQXsZm3IKiqMFzWVhZ6TfW7NddUfZo35H7ngEsORRN/44uyyCaFdmVWNg2kBNA
	 3BlfCb3BAD1TZWt8rpmNJeudtHmuBKe41rKkF050jsPLRbzi226AVhzZSSna8XVNan
	 4/oXbRzWX+CR0KaMq9xn11mflz12HJS3kJoA/6kByBrjZJh7Vv2RlY3QoVNv+6LUtH
	 NjwxZOiddvtcnjaqhnzIaKFxkFmyxCtXDXhl+qOqjR3TewGQFLKozpZvNRyXn2Lruf
	 RDXuj4Zf8Cweg==
From: netdev-bot+sinfo@kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: 
 Re: [PATCH net 01/15] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp_v6
Date: Fri, 13 Nov 2026 01:16:59 +0000
Message-ID: <179453261966.2168702.2891153493137589697@kernel.org>
In-Reply-To: <20261113011447.2357709-2-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
 <20261113011447.2357709-2-pablo@netfilter.org>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by LLM and not proven at runtime). If it was triggered
   please include the symptoms, like the stack trace or kernel messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
