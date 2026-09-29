Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B24B4EB87D;
	Tue, 29 Sep 2026 09:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673294; cv=none; b=f23nUzny+DJ+NBFzDQlePrijU21m78qZ0bJXecvOze6lcWK+HgMQRxCGYEAxckXlKeN9XDTBqBMtfoMWhI957a9+Edb4pGg6EO65jV7M2xfuDOIwEAAd/g3uCd25O/EfU0GkUEVXGIuqKUJO99SII062bK3l1n4XM7yXELvtdQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673294; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sx+OIQVxGKWXuxTcfY6Jrf5OQB2j6HrZTrgQnSn6D9opmKOlvqvLFcavsFAuR1KlG+gihv6gwfhEVR/FtnDRcSVNuiXxifMeva4/BFO9XdfuVqPrK0ClV6C3h0z4Y+/6Rndc0eNtDpPviMeWwch+4ZMjIJllVbxfFHMEOR+fGYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jznScfmN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jznScfmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B441F000FF;
	Tue, 29 Sep 2026 09:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790673279;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jznScfmNSlB6hCGytRgKHU1xATMoqsSxMlVJbVClZ2342Hs9GEcbSQDy1EyXhL8bh
	 egpHTrMvvae1eWgitOxyymxH38Ur7KYmIgSEEJvyPtiJAkEhqj6+DikSQlNW57bH9m
	 qgWWUZZDiM4HBSEGtE1erfaAGcam5p5vokV/I6vlxpRP4cU9QqXrTR7zQbqgy//YaW
	 Dy+lguhgpM3ptSBswxHshI+rZzr3/Tx0pUJZ0pt490/Q8km1a9lh4JuLcqHzNhhp3K
	 a1Z/8ZhEecLKmZW7MpSN1y/3eViqLigLvtrDdVYkuN+WxWHAcvVufWk/qy+r4/ytg4
	 JqCdYaxlE+WcA==
From: netdev-bot+sinfo@kernel.org
To: tjdqudcks0424@naver.com
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: 
 Re: [PATCH net] netfilter: nf_conntrack_reasm: avoid truncating header offset
Date: Tue, 29 Sep 2026 09:14:38 +0000
Message-ID: <179067327860.31693.6671273269506365604@kernel.org>
In-Reply-To: <20260929090027.200041-1-tjdqudcks0424@naver.com>
References: <20260929090027.200041-1-tjdqudcks0424@naver.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
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
