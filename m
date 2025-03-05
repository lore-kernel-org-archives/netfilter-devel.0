Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FE9259C8E
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Mar 2025 21:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741210819; cv=none; b=hmwwsfm/Ga0PX8X6tUxMcLnu9XXIta05YVJSa2o0HoNwf2j5DABzfeEl5ju4AQarLD9ywgNaYrfgQMxuxS1V3J0MN2gHAA3a2XsLMD5aloDke2yAP7tnS/IdGxoQtq0LzV5dgS7ckVob4X/LKp9MK1k57KsONmLxeEd/OmoS5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741210819; c=relaxed/simple;
	bh=sONB1DFYWhHWVPvb3/qyAKp/FWwCSH4Nn5YxoiCxSVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKLt3G/y2+uZm8pBQYabf4qpzuE3HyXEzH65mkXXIKte2XckSJ9EO1VXNb7aA75LNTputzMURMUfHNJJG3A4lpqtbrA1Z3TUmobZ2EbT2QDImZQaE5vcIpDePMyg3wW8zOOkHpkFj65vO9RLmn4zEv53lXxK7m6MBRK6HldZ+MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N3upuLuJ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=N3upuLuJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N3upuLuJ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="N3upuLuJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7FE5760288; Wed,  5 Mar 2025 22:40:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741210814;
	bh=sONB1DFYWhHWVPvb3/qyAKp/FWwCSH4Nn5YxoiCxSVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N3upuLuJQbNDkkA9y6pK8tKu4qeI2ciR9fLfG5WCVYCcgyxbyLnJoXdfkz/VLTGXz
	 ob2zERI47v0O75mFBxg69Xm4Eb0LbyV5u1/g10DNJCXfp/lxxwkB1asNmtgyDasHzH
	 wJhz86nf1AyvHyXI6cscGwC8pit/GeJi4JnBzYtcMLshg06j0kg7mrYFGpuYkxygOj
	 VUWaolCcdKCwZDjeBfJtjks/2qB9X8brQuu2KSD284+cZZ/gkGOLBpcgMUJqCXNq+W
	 7jetzJdxBhLz7yBIgrn7fX+Aut7R3sYznn4MgMUmDna8Mg0eDbndvy03Cr0ZhmAUD4
	 VGT8o4KWr/FYQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 18CA260277;
	Wed,  5 Mar 2025 22:40:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741210814;
	bh=sONB1DFYWhHWVPvb3/qyAKp/FWwCSH4Nn5YxoiCxSVU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N3upuLuJQbNDkkA9y6pK8tKu4qeI2ciR9fLfG5WCVYCcgyxbyLnJoXdfkz/VLTGXz
	 ob2zERI47v0O75mFBxg69Xm4Eb0LbyV5u1/g10DNJCXfp/lxxwkB1asNmtgyDasHzH
	 wJhz86nf1AyvHyXI6cscGwC8pit/GeJi4JnBzYtcMLshg06j0kg7mrYFGpuYkxygOj
	 VUWaolCcdKCwZDjeBfJtjks/2qB9X8brQuu2KSD284+cZZ/gkGOLBpcgMUJqCXNq+W
	 7jetzJdxBhLz7yBIgrn7fX+Aut7R3sYznn4MgMUmDna8Mg0eDbndvy03Cr0ZhmAUD4
	 VGT8o4KWr/FYQ==
Date: Wed, 5 Mar 2025 22:40:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH] build: add hint for a2x error message
Message-ID: <Z8jEuve1T429eDRB@calendula>
References: <20250228185405.25448-1-jengelh@inai.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250228185405.25448-1-jengelh@inai.de>

Applied, thanks
