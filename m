Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BC21E51EE
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 20:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743537671; cv=none; b=K0cBjgc6A0l4ViL0wYyCKmgXgeo8nPBeV5sDW96eJCGXIpIO4qtGgThESE9sLZ3M9TD56PVSNNFpAGINjLjEtCkM4/OpE2rn5nFuaSjzp14/gTBpsQqXE6SEMsBpzo4EO2j91loySK3SK1LHfLOUzCv/DaRE/5TLh5oeb04o3FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743537671; c=relaxed/simple;
	bh=mEkuXsDcbQ1qG0Vqsa8HBBgcgJv4MAoqSi1qGtfqLh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SFI4isNGQmX+/2DpWUAGz+ju70dp1olxaNsJGT4/9Pd44BN3DuV0zpaheGkG+InxJDwz0qDwCaw5GqjJFe1aDb4Im1dFS3PWoaEbnZdW1pIlFNdmA6BxsJ2bDb58E3sqDjiGWdBjCY69+2G/6JZzW0UQ9jNXsbMWiqwZUluZaoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vGVym9Mb; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vGVym9Mb; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vGVym9Mb";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vGVym9Mb"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DEBAF605BA; Tue,  1 Apr 2025 22:01:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743537665;
	bh=x8tGhRttkFqnsOIFuZTXGofVIg79pAjf7dMM5syxwEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vGVym9MbuZ5m17P1AUho/p4QlPVsssyE182Ewv1V5ZkurTK07EaS9IdgmJcsR06D3
	 7YmNhVXQg8ZBrOXNMFHXVy/hBAY3OM+mM+2kO/7HLAt0ov/mSOtg2cEd7RsBVCmDb9
	 5ktnTV7woOEGPHkgtsbZjy0chUjf9jpedn3mGGRFHIDiL5WFbohjqyAZ3X4ONeirIw
	 U4pyosvQ8KTXCbaS57eVDGXrgaRPAiQNh2Yajl0uP2fbQfAqSEMgxFJe+egLR1ymyM
	 lLCfKtxfOv2Jzhtrz6FR896RonhKbfHOnbJsPEeQqs7Pd5A7ehFaAe97n6fNRkbOiG
	 iVtemT8W1DFCg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6376160393;
	Tue,  1 Apr 2025 22:01:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743537665;
	bh=x8tGhRttkFqnsOIFuZTXGofVIg79pAjf7dMM5syxwEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vGVym9MbuZ5m17P1AUho/p4QlPVsssyE182Ewv1V5ZkurTK07EaS9IdgmJcsR06D3
	 7YmNhVXQg8ZBrOXNMFHXVy/hBAY3OM+mM+2kO/7HLAt0ov/mSOtg2cEd7RsBVCmDb9
	 5ktnTV7woOEGPHkgtsbZjy0chUjf9jpedn3mGGRFHIDiL5WFbohjqyAZ3X4ONeirIw
	 U4pyosvQ8KTXCbaS57eVDGXrgaRPAiQNh2Yajl0uP2fbQfAqSEMgxFJe+egLR1ymyM
	 lLCfKtxfOv2Jzhtrz6FR896RonhKbfHOnbJsPEeQqs7Pd5A7ehFaAe97n6fNRkbOiG
	 iVtemT8W1DFCg==
Date: Tue, 1 Apr 2025 22:01:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] evaluate: reject: remove unused expr function
 argument
Message-ID: <Z-xF_h2N_VokvdxA@calendula>
References: <20250331124341.12151-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250331124341.12151-1-fw@strlen.de>

On Mon, Mar 31, 2025 at 02:43:33PM +0200, Florian Westphal wrote:
> stmt_evaluate_reject passes cmd->expr argument but its never used.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks!
