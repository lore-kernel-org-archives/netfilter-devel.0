Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A25F1E0DE3
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756333527; cv=none; b=FQflEq2V0qOW4sQB3FnbuA1cf3uqV6BMjbWrHJ/CSln10tsIHT2Eb9FPM5i2SIg137010MmxMfu5BQdnH529WHt8yc+1tGcglFp+tZuNhHlWfcn/U1rkOrOOhV6k1gYU7fVaK4s1eo/ISV3Njl2v4eBk8H05eGI6wYQpSfDgUrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756333527; c=relaxed/simple;
	bh=ujFIaGzawLEev/OTN61yivTy6LIg1wp6tdYy13NRk3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LY23jOk543eeMnDGP0TQQBK+ThCnRfOn3NyPt114/bSx74d9bjYtSh6GL+yWhiNJxCL86hQXvpZM0+pSdUec4wR+LDtfJ8f/aqxngCXXauV4w5E34j3L5Wy1KXJdFayXOWaMmVw6or16CUl2WLB3ZQ7wIdF5MiGaVU6PoHIBf7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=flL+ITgZ; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ntEgiuq7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="flL+ITgZ";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ntEgiuq7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0FB8E6078C; Thu, 28 Aug 2025 00:25:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333525;
	bh=ujFIaGzawLEev/OTN61yivTy6LIg1wp6tdYy13NRk3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=flL+ITgZ0pC0IHgEqiOvutnctgOHUrYYDAGvXW0kIpQHuSTM1iuXx3coCI8krGORM
	 X0q51eEVx8IkGUkEM9xwCJmAvLzCYIIlZHBMmSuYZu06D8CI9h9VF7JX4sAI2HVWfO
	 EZ/JZp8soBcplCUBe1SvamuvSQn0/IazRq7/8dyzl4MkVXiQKwE02aCw5xM1stqtmT
	 kYjBExKTvzUx+/F0Xty26VEGx9vMKXscm6U2wSLruWP4Lgv7LULyJ32W34Nq17gfVr
	 UEuayIBIIQsk03O3WWSbYRIBAXi8jTcFH69ispbaP7kdVbIXHnuPKa5lbTCkLeNY0e
	 ImvkPQOh7Zliw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 97734606CC;
	Thu, 28 Aug 2025 00:25:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756333524;
	bh=ujFIaGzawLEev/OTN61yivTy6LIg1wp6tdYy13NRk3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ntEgiuq79WByg9yYeF7kPN8YQuqIvDb7A8SeoiL2YV02UKxOMbh3DLh1QSVRE3CtM
	 Xd3HBvQS1GNne+SzUwSJYKO66eDgrCghS/FVLOpn/JIpwUMN2m4VFVmJUPoTfizL4X
	 wjenrtfAcF/I5lM4qRa3AVdc7sDj5zaopSyf1JHHMbhYcNet4FbYKH7n/OD1dknDoj
	 zjPkJsPdXGeNLLdOYaDhFCKciDhCt6TWwMSlOQonqmNVE2TR4nhJGGBQ6AAFQftVcS
	 bow9QTeFhj8zSBPn3A5fwwkke+Lr18Ro3E7fIQxRWdXN+6iD5olIMejcqun8WChPQ1
	 HreEWPAtZM7JA==
Date: Thu, 28 Aug 2025 00:25:21 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, fw@strlen.de
Subject: Re: [PATCH 1/2 libnftnl v4] tunnel: rework options
Message-ID: <aK-F0VSonj0tmqpd@calendula>
References: <20250821091718.9129-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250821091718.9129-1-fmancera@suse.de>

Series applied, thanks.
