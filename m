Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A963BD23F
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2026 09:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773220364; cv=none; b=rAVigwzNWrs7hAgEUWlqkOmetQuRRycYNAq1cWyD7opAtri5MXmG72Ia+BSLCVubp8MRQIpZrSnYfPsOJ/Y4jCG5G+T/kEFw0vJi3CxgfUFrDwHwHOoSlIkdd0yZ4QlDdY3i9q4XcVzrFw7W22xrBNNBVIJYdMhe4PyZCOWQhl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773220364; c=relaxed/simple;
	bh=1qL+ZB3twIWgKrOc6B7UuB8dAyWmI/4f9rwdw3qh9Ok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PT1YrupARBDRjveGcyUh6C+glSzG0mfsaRpOqW6lB0R4B+6e8qLYXYvvX+M05iZY0MxU11MTmLC6la0euYRLoPtWCImXb/3K8vmpeVxLndmGpyTuHfNhyRYSH4c+AsbsiOhja1KUd3VeSAOR7kpekKExfOXCWWsDRDVww3XuLYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=L0nnVXxL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="L0nnVXxL"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id E9A18602B4;
	Wed, 11 Mar 2026 10:12:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773220352;
	bh=ORXT5U9Rt/rxMTh3+qsXYHTaJU5djFrlBAb0GocM/C0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L0nnVXxLEHQgH5oZuT4nrtMAZvfuLGtyFhYFLVkdIGI+0mEiUN9S8UvfIJMB6MyM0
	 DqywGLImMhrQ38qlKl4CTQAKkDScTPVI6/JFMF/4k2GsCtKQuuByr4rXOZV2IhwJHl
	 kdiDIKsdBoWk1lQGSrN6G7VUc5HhdJ7Y0kvTFDFvdB3cuk6SFv28zLIz5VC5F69ww2
	 +TarjIYzcrS2UOkEzrQ1BhZ3tqdSN9xhS8+3T/+KoesxwBkPHTBfMPYw9ghFEwxy9J
	 UUaln1K9lVoc1dS9Jrda5WmGjGoGfhQeniLomtzEkVe4GfQcG9lbTbya6q/dBqBaEj
	 PIUZDz1ftLSCA==
Date: Wed, 11 Mar 2026 10:12:29 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: =?utf-8?B?5L6v5pyL5pyL?= <pengpeng@iscas.ac.cn>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [BUG] libnftnl: missing length validation in Geneve tunnel
 option handling
Message-ID: <abEx_WOZDgew4QDE@chamomile>
References: <7a6e072d.57068.19cda8a76e5.Coremail.pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7a6e072d.57068.19cda8a76e5.Coremail.pengpeng@iscas.ac.cn>

Hi,

On Wed, Mar 11, 2026 at 09:37:13AM +0800, 侯朋朋 wrote:
> Hi netfilter developers,
> 
> I would like to report two length-validation issues in libnftnl, both in the Geneve tunnel option handling in src/obj/tunnel.c.
> These appear to be memory-safety bugs caused by missing bounds checks in fixed-size destinations.

Please, send patches.

That is the best way you can contribute to a FOSS community-based
project like this one.

Thanks.
