Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E601DEFE6
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2025 18:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754936897; cv=none; b=WetBuheO50S9epTJxXqMLAHEe9zUhZ7JPnCk6Hx3lG/D/LLSt7CAnq1t/ZKIM7XD9A1+8E51o6b9w4Eed2t+8ulcD2M94OWVu7legOmEdeRbJc6/poJbXeRwvgczgHrfD0gpnJdvle3yRsfZgqZiRATxmf7zPGTjwyzfe/KAaKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754936897; c=relaxed/simple;
	bh=2hNIV8GwND/zvKakbt0eh/aKwL4fXDeXmhZC/IpzRXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEjp9+ivWx2zI8rhauRMQCpUkpmnpvyjUFGBcwPodNyFHWwb5IjEZBmq8UQ/w5Rmig5qIp/m0Hsc/s8QU7djxPGjbIQE+lndoNY00bWC7MuioGBtgXeGoxP0bP8ppMqO76ARgdSzsl2QE81SJBn7yZfp3gpAKJzWogrucinoZiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=utlFqBQw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=utlFqBQw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="utlFqBQw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="utlFqBQw"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7BF2D6069C; Mon, 11 Aug 2025 20:28:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754936886;
	bh=bA3X0GZXkFc5x1bzSyi8Nzw4vZLAMekL8tLmPi3ozPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=utlFqBQwLQ5gcnRxcFgFdtbSPoE7gg8z2DFzODo+FJEbOv5+74snjt1BzneTzEDmB
	 jSyo1qUv5ILMEBoDFeZBz+Fb77NhCxJOmtYwZ1A9tURz3wTuaUpSH/1lUijE2ruFEB
	 rk2FrG0VrFk1GbKrxdT+Vk7ZC3P7fed+d0PkrXtNJ0bOethT73t67gUvL8FyiJzYHb
	 KMvtVvb+HFravwqT74EZI6LhDeR4gQroazzCudVEqrY30lfrXgVp6zAwgu0lWiBHpG
	 R5HF/i5diuce/pU5VCm+qf5UHKSO3A8f5mmdVJe39o/mVjZNUoZ48zCtVpMsJnaheU
	 u0En8gb4MdknA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DE9746069C;
	Mon, 11 Aug 2025 20:28:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754936886;
	bh=bA3X0GZXkFc5x1bzSyi8Nzw4vZLAMekL8tLmPi3ozPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=utlFqBQwLQ5gcnRxcFgFdtbSPoE7gg8z2DFzODo+FJEbOv5+74snjt1BzneTzEDmB
	 jSyo1qUv5ILMEBoDFeZBz+Fb77NhCxJOmtYwZ1A9tURz3wTuaUpSH/1lUijE2ruFEB
	 rk2FrG0VrFk1GbKrxdT+Vk7ZC3P7fed+d0PkrXtNJ0bOethT73t67gUvL8FyiJzYHb
	 KMvtVvb+HFravwqT74EZI6LhDeR4gQroazzCudVEqrY30lfrXgVp6zAwgu0lWiBHpG
	 R5HF/i5diuce/pU5VCm+qf5UHKSO3A8f5mmdVJe39o/mVjZNUoZ48zCtVpMsJnaheU
	 u0En8gb4MdknA==
Date: Mon, 11 Aug 2025 20:28:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: py: revert dccp python tests
Message-ID: <aJo2M9qb6hNvUGyX@calendula>
References: <20250811092510.5744-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250811092510.5744-1-fw@strlen.de>

On Mon, Aug 11, 2025 at 11:25:06AM +0200, Florian Westphal wrote:
> These fail for kernels with 'CONFIG_NFT_EXTHDR_DCCP is not set', remove
> the tests in anticipation of a future removal from both kernel and
> nftables.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
