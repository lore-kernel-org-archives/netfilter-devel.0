Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9112C29B78E
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731658; cv=none; b=QhRq+eKl/FDUoyVOj2WAyfTpZb6VKREt1RarmxyXFHOkQtI99zWLxQsUWExx45tBlbtc1LhOelQkZFh9eqUPQbNVqXb8j5FEm1CfPAhTnAA1guE7NWHWA6VivV/lZJYWpbaqGq6sEupaMcWZ21CbEJ/2+ghBfeuBb+waNiDu9KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731658; c=relaxed/simple;
	bh=VbjaY7CX/aX+YreL/H0bvIzzKD22hy5Ed/QtbQlnN2g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSGDIXdIfF20Dw7rav7SxXdROlc8cnhEb4Pwp/xXiAaA2Q9Jve99WwqxiSyW6R8pkHzWx/iqvMNCoahQu/3IcHZK9mkHFmdUJwmR8EKgkhOxg9NbVY9PDClP8r41ltfiStKBKSKP8q5lfk6dq0NgjUZA2qpZrObN4/uYhmMMaJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kYDO90U+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ej/wgG3v; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kYDO90U+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ej/wgG3v"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id ADCD3608DD; Tue, 15 Apr 2025 17:40:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744731652;
	bh=BLs43h4iAwDGXTkU3hA37FrGrG5pFqS9zPlQfgF2f18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kYDO90U+U4mb58JAbslkQP5OkdupWESmjnHPJxhyIX4V735jh358mj8RtPa1hV7H/
	 m7SepwRIb2xQiYsuyaQuT0hWv9KEe0yazr+8rnCfcLpfpMnBdZGt+uPXylXKEt2vgm
	 agriKvs8tJa0TtalE7fFETlFggAmKkeLnnR7uLutvZK0Q+/mD4gOTYPZ/eK3Xjeere
	 3iiAquw8DuCtBrYEkAO1v/jcyk/HmgSchKIhsyvFH/67AktiM/y9yHkOSiJlkTLVTx
	 uhOgKeINBvI3r6GafPWuHTU1xq/mNjnJJMmun2bV8MY4uDYmTO/WbWT1WXV2C6ET+5
	 8nK5e2poynW6Q==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 68DE260850;
	Tue, 15 Apr 2025 17:40:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744731651;
	bh=BLs43h4iAwDGXTkU3hA37FrGrG5pFqS9zPlQfgF2f18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ej/wgG3vMrny7rXhKbDeKoZ1Ax1mymaGhaVulUFONMDxOzRSWN62SH4alsT40uuFd
	 +FDjoN8thDv7g3QvInLvXMBWH1EiHHU6uvNDsV5qyIP/WY17iG6BIb7rTMWkR0aYeI
	 Vd++gP4AxHNSmfz/ascHHce3+fIZ0wFCKKqIAs/CqZEfQ/EuCMz9/mkk8pOMiuSKQv
	 rqTYjNlDU9PNtxexjjnd47mvMqigtWGXd89XaDkwQHPJLI6VjPnWIlB5qrJDy+3Tso
	 LWX/JJvYrqHtopz/BJwvDup2LTVVwb6vEUiAn81K0drSalQjKKjK15yKbpGTF2t8CC
	 +bw1ZPXsl31rA==
Date: Tue, 15 Apr 2025 17:40:48 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xuanqiang Luo <xuanqiang.luo@linux.dev>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, davem@davemloft.net,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Subject: Re: [PATCH nf-next] netfilter: Remove redundant NFCT_ALIGN call
Message-ID: <Z_5-AFh4MGGvWNnY@calendula>
References: <20250404094751.106063-1-xuanqiang.luo@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250404094751.106063-1-xuanqiang.luo@linux.dev>

On Fri, Apr 04, 2025 at 05:47:51PM +0800, Xuanqiang Luo wrote:
> From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
> 
> The "nf_ct_tmpl_alloc" function had a redundant call to "NFCT_ALIGN" when
> aligning the pointer "p". Since "NFCT_ALIGN" always gives the same result
> for the same input.

Applied to nf-next, thanks
