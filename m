Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFD129B76B
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Apr 2025 15:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744731754; cv=none; b=kB2PEeBj1soYKiXDoCZPaI1qt5lwbqLf6BHMEv6cyaGUYw/LPX1fqKMe56ssIh0fgHmfXii281TvXeSok/6UZTzdAfFXEeY1nAs+hSRV2fa8KJ6NbKAlur+KTHmZ5VF2xr2KKFMuLGxrajn4AHLSNRKygH1+T7l/yhJlOUqpmu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744731754; c=relaxed/simple;
	bh=4ipfp25Hzvk9p5im0sCVx3DsSaqG1zIl9BLpfyJJAMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=incgl2ybsNNmDJ3hDlFlj5ugjeUF43BhHkZPOVb/mOdEo0+4QzoMLtxlCyAxWlG/xYoXUYAqmKmXc/l4IJmgO9w0UVlb9jP+ioyJLFdzLyX77ZXA/0XGB7tZdUEny3PZM2K6hwXxrTKdLngbv8IMFUscHOLoriHKvNhCBjg5XoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KqGYR99b; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KqGYR99b; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KqGYR99b";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KqGYR99b"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C7E49608C8; Tue, 15 Apr 2025 17:42:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744731750;
	bh=g3+HRg2gSP7MAqMjzGM4c4AMmz1ILF/56q7OY6UH3aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqGYR99bxr7V2mg0BpfZV8Ee3DuAV/iAySBVu4GaemrgNPUMn0dwvGCCMaeERCfDE
	 Dfb0A7guuFxc92PYa3x8R8XC6TNN14BXHL4scrPq8lRvejdJsNoWaWqpZjdIchzg5q
	 eT411L1BvGoHJJ65LpJG9OEaPoBFjdf1PIhtWxNmRFmjbpPCOjGn8dVzHzVnbE7dnF
	 jFPDs0R960FVkSqTzGT7naxtvuogM0YbXdUlijdmwZcaoRTGhZrEm1wowfcrJq6QXd
	 NSFdCQ5S+GS1noda91QU1Vc3BGB25W2nRiCSKVEmlWKoGitw6dFAJAzQUT3AUtSQxR
	 iAcN8hyO6pm4w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4DACC6088A;
	Tue, 15 Apr 2025 17:42:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744731750;
	bh=g3+HRg2gSP7MAqMjzGM4c4AMmz1ILF/56q7OY6UH3aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqGYR99bxr7V2mg0BpfZV8Ee3DuAV/iAySBVu4GaemrgNPUMn0dwvGCCMaeERCfDE
	 Dfb0A7guuFxc92PYa3x8R8XC6TNN14BXHL4scrPq8lRvejdJsNoWaWqpZjdIchzg5q
	 eT411L1BvGoHJJ65LpJG9OEaPoBFjdf1PIhtWxNmRFmjbpPCOjGn8dVzHzVnbE7dnF
	 jFPDs0R960FVkSqTzGT7naxtvuogM0YbXdUlijdmwZcaoRTGhZrEm1wowfcrJq6QXd
	 NSFdCQ5S+GS1noda91QU1Vc3BGB25W2nRiCSKVEmlWKoGitw6dFAJAzQUT3AUtSQxR
	 iAcN8hyO6pm4w==
Date: Tue, 15 Apr 2025 17:42:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] netfilter: nf_tables: export set count and
 backend name to userspace
Message-ID: <Z_5-YyFGxvALMU0C@calendula>
References: <20250408135556.21431-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250408135556.21431-1-fw@strlen.de>

On Tue, Apr 08, 2025 at 03:55:53PM +0200, Florian Westphal wrote:
> nf_tables picks a suitable set backend implementation (bitmap, hash,
> rbtree..) based on the userspace requirements.
> 
> Figuring out the chosen backend requires information about the set flags
> and the kernel version.  Export this to userspace so nft can include this
> information in '--debug=netlink' output.

This is not in nf-next, thanks Florian
