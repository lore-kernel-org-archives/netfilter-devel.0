Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E6918A953
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 13:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747835867; cv=none; b=quC7i7DP7sJn5FpfEcSf18mR4EwIFXDDuukjafH1ni0DWcyDiqOhI5xTKWVRVSEf/3LEVAVrVAapDjgPQlxz03K1CWl7LhZKTqVbVFwP7fcsRrlmuT0siR5uOz2gcIezLaM2qkY954dJ30evSCXfAmBaFpPaFkydjj3msf0XTAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747835867; c=relaxed/simple;
	bh=Pt/j+4Cdvn0zuW24shdNSBi/Sbn8eAsVflj8f5UgV3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O7LTu8Pu91npJnHyqxdsjNZznuT3GaR9C8XJ6fy2XortiRgx6i3vv92zXdkt0GkOYL3dBO4DvzwhvGQXrNeuGsobb/Qx2g59pCxNBy9oy3ydQOwU7XS0J1vaytLwdS0xPY5N610EY/jfKxP7M+HDnf8VeIjwN7p+uT6Eyr/iUlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CHm9zCyI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=i5hkZEUN; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CHm9zCyI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="i5hkZEUN"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3AFD5606F6; Wed, 21 May 2025 15:57:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747835862;
	bh=PnvZzUMT2w+dm7MpQk9hz/IdLh5KcO9JvuP1Kxysk70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CHm9zCyIx5kCDDQ4P144CDWi6rZMPdMMJM6tU+T0OdldPRe95JLXB9KvqndUNHCCE
	 ti0Fw0vMB3DbOUAh8MdTKxmzB1tVIz5XZ9mhQrEJpeJlrtoJStCYvZ5qR4jH0jnvKM
	 yL9LyTxZvc7Xw9K9K5FI9y/tYgESiyCxaK6f3VyhDR4cM5yiTlodHuSctd8DqVpqZh
	 6RHiG5FbdvP7TOzqE54CmNVzBl5lvFA/OLIVBRkwMMiOAaowufcTQNMzcyKr/kVvqm
	 Db9ek6FFr3WaTcJJIgSizJI3u+XTdE0e9fawwB6CjbJEMgu6azf9VBoIzu6V47ovDO
	 VP773T+Z8ViXw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AE2F0606F6;
	Wed, 21 May 2025 15:57:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747835861;
	bh=PnvZzUMT2w+dm7MpQk9hz/IdLh5KcO9JvuP1Kxysk70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5hkZEUN3JXehQfy9kge9Eub4qsDOYmPAjFF8tMjHiEq5X5OJbRuk8i4ZK2VMPk9U
	 R+5LzEZQWqTBupcq3+6OEb3OcnEskdfkCMJrhAmoRF6uBxeMtMeLkAyQgV60pquh6e
	 fZVRfTeTpn3aPi/Nrsv4lKRizHWUMOaDqoWoRpkoX5qvlobJXk2/axqsQMaXOx2Oww
	 DvQ1P/gDCaaAYIIm9oM4obPZtCyyz+ZMLft1P6oPykYWGd3+8NbT6b2CJGAIJFKum/
	 e8gPhXzKx5IL8gisT9PFnU0RhO6YJLfxdxMnYDPnmWI0hHmAd51obSpePqxHVw6W5u
	 R3CsfXokyiVpw==
Date: Wed, 21 May 2025 15:57:38 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: xtables: support arpt_mark and ipv6
 optstrip for iptables-nft only builds
Message-ID: <aC3b0l1FdHgFDzMf@calendula>
References: <20250516141216.26745-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250516141216.26745-1-fw@strlen.de>

On Fri, May 16, 2025 at 04:12:13PM +0200, Florian Westphal wrote:
> Its now possible to build a kernel that has no support for the classic
> xtables get/setsockopt interfaces and builtin tables.
> 
> In this case, we have CONFIG_IP6_NF_MANGLE=n and
> CONFIG_IP_NF_ARPTABLES=n.
> 
> For optstript, the ipv6 code is so small that we can enable it if
> netfilter ipv6 support exists. For mark, check if either classic
> arptables or NFT_ARP_COMPAT is set.

Applied to nf-next, thanks
