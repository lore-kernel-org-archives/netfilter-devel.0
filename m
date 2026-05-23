Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612272DA76C
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779547145; cv=none; b=kweSUutDjBvM0T8wuR4PU++P/crfRHv8t1dI+/C9BafjRzUtxMtuitM8qJY3EkmFT6iSxPL/IYkL5ooO5AackzQ8mLVYr2b97gX26aVI2dnFGbcEUKaKN9cr8+Nn6vJJa/BlR0aIOv19DASSIqyhLNmRgdcBzDqpGRFGTFafc0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779547145; c=relaxed/simple;
	bh=7JN4iIkr/ux8UGRhbN2PUVXzbVjhKyDtbsWyVlXEono=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNgPO1zWe4WRA2lxB098ItEuVZhktHEkdESHIcFeH49yKTZBVUSnhdsu/dDIsHCaEEQVoFXYIIXHyF0uURBK1J8poHPhUmYOZ9uIndOs8OgnU/pLIAeKGzRdkliFJwRA8elNXgiDs5n2+F1xUUDAOUX/HTN74/hI5DQPFvEqRc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 12C0F60849; Sat, 23 May 2026 16:39:01 +0200 (CEST)
Date: Sat, 23 May 2026 16:39:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Igor Garofano <igorgarofano@gmail.com>, security@kernel.org,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [SECURITY] nft_byteorder: incorrect u32* stride in 64-bit
 byteorder eval leading to firewall bypass
Message-ID: <ahG8BDd06vVmOTMw@strlen.de>
References: <CAOOOOYyfpwO7inyq2wXtpT0kY0s19-n4OZf2MCR62WRi7vzMMg@mail.gmail.com>
 <2026052028-grain-pencil-0d8b@gregkh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026052028-grain-pencil-0d8b@gregkh>

Greg KH <gregkh@linuxfoundation.org> wrote:
> Can you turn this into a real patch that can be applied so you get full
> credit for resolving this issue?

A patch to remove the buggy loop is queued in nf-next:testing and scheduled
for a pull request on monday.
