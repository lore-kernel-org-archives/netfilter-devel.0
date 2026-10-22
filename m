Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792690058;
	b=XZ4u7/ZJUqNkhOyBUemzqgXEe4YwgxgQsdtHfsidKff79bs1EKowFZD/Yxmdm1htHvgO
	 DzAUw5j1yRiG73PMS2KoH8TSSj0QjFqppmHgGtDZtznOddB0bwMPT4k6Xi+ZbooHic7kx
	 3qt7I9lQt+EXkYfo7sG+wvl7TaiL2+hDYJmsTLltiDCLQRXHPhT9i4c6OUqoizlEOZKwD
	 jv6ZqrSOcQUzuy9dKtgs27lUIuW76OL+vtTrSYakYw9f2+22CvNzpB1kBIP7fpLYnsSni
	 /y0OtwNIwAo+V54b6R8uR279eCaOc3gkh5mMmhmiiuPeOJjtV2x4TelLhA8N1dbHKSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792690058;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	b=Y4U9ddlO4JPIBYew8u6ILrLhToGfFdd6rAaeWBcJl8JpGenNjd8MRvhzrmctnVsyOHK+
	 sFX33k7WOgpQSX0x/6FNmy0KIen64OMIaIN/M6bGKMtX2g/vXzTcP8NvvQsnxYTNC+R39
	 fw/qboQqqeHUPbmv/uLXsSi3cDFyBfJ14PLTrV3dY2w/oipetw1n0s532vsYWHtSRbfDf
	 M8YSw1AYFoK7HHv/19EGxkhJcAU+qhgWS18iGHeDw31DDT9sqf6ODMQ0V91jqKd+Fbsox
	 N/gAy32bRAzN+x4SQ+TZw+BlOaF8sVAMtByOWOQhrXU+jdxIz6yVI9AgmAmcOcX6xgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BEvJLIjI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AF8606A319;
	Thu, 22 Oct 2026 17:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BEvJLIjI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435AF1F01825;
	Thu, 22 Oct 2026 17:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792690057;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEvJLIjIOVwT2bif7I0egp3pQQAxUiRe7Vkv5TJRrvLCrh4rK3n+5fOUSLElLExdm
	 6UBUl0OS0QtAGqInWkX3SXdSQQAQXYveIQPID3cQXEQI2AdNUPG9aqK/jcds46o1bj
	 RreIO9dbzLloC6NjX3YJi46xOvVA9olM6R6w684dbKQ81XMvh9Veu/FW+4O081eWCP
	 bTjaCnTNJP4w0ZmUpeju+KyNujXzc7JcxHrSyQf2+GAZmQTDFZRF3xLQEqTdmuNGxP
	 ZJZNztVF11HG+jOlL09Oc5Y/kaOTcg7fWdlNdhZCzYCnFYVfn4EfggtWmuKOBQjVxB
	 7DEXa0LfSjskw==
From: netdev-bot+sinfo@kernel.org
To: Duc Anh Luu <luuducanh05051995@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
 phil@nwl.cc, coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix out-of-bounds read in
 ct_sip_parse_transport()
Date: Thu, 22 Oct 2026 17:27:36 +0000
Message-ID: <179269005674.3290.14063496148661788666@kernel.org>
In-Reply-To: <20261022172248.554687-1-luuducanh05051995@gmail.com>
References: <20261022172248.554687-1-luuducanh05051995@gmail.com>
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

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
