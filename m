Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4E923C8D5
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 11:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747914683; cv=none; b=u8kmlN9G0rQ7nN++m+gAZy6foLWtM43BAARwM+SB3rVI+KMhZaxGOgzo5BUl0D5WxRfZ1krgswh1B89pYZHU2UdLFEnR3OEO871WBYhc7S0RhB7FnwvEQFiXc88psjnfis6coYQkQmf3V18zohFOjnYNL5n0zm02sXvzPPan028=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747914683; c=relaxed/simple;
	bh=kFemiVxxqMTziDmLPgh9cKtj9HQI8Nn6/bDjeFBbRiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZqnDptzD7oJYP44URHoXBCiARvWPSS7Ti5pvIZiVp8W8cB6pIolHPd99l124ZsjubFJYppDholgljKDpAlre0vtYoEto77lOnGlZ0Thm8glZZdFOdSgQqjmZrBs17aY7usTHKS+klsxi80qGZFx0UvrF2G3JiL60qFo4g8wym4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LWX+hKux; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LWX+hKux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iJ9GCJtpDlB17TBQrSHwNQF05/vO4FBDJOkvh+olyqg=; b=LWX+hKuxe7UmN9u6e/dENBKb+z
	/krOCcUHfFcOsNG9ry4/lGxYbuGhd0xXmDXFdL2lJnQPoLUTFn4MOeGTm7QfJr7tgoRegAbdWPd8s
	ltKPg1ewkpXMj9dXzca+00lUV6D5J1cuCKMywlToJNJLERNyXfp9I1sUWrlIcUfdk0reh0mmT9eI6
	yU7XOGoFfQTTsGYcgOWmi1x5Dk+ho+eHR+Cw2BTsDnt+DWHDZAlPiNn+iFxhC3koW3bwINTZQC1WV
	kqccNA/3lE08L1qe7bNlPOfOhW2fGy9JLWwMsbk94io9FczPhWQuyuha5nzU1JsIjhd1rmyi6cQUD
	l1htNstQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uI4SD-000000003xj-056J;
	Thu, 22 May 2025 13:51:17 +0200
Date: Thu, 22 May 2025 13:51:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v5 0/8] Bitwise boolean operations with variable RHS
 operands
Message-ID: <aC8PtK-7XjoHOmPD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
	Pablo Neira Ayuso <pablo@netfilter.org>
References: <20230528140058.1218669-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528140058.1218669-1-jeremy@azazel.net>

On Sun, May 28, 2023 at 03:00:50PM +0100, Jeremy Sowden wrote:
> This patch-set adds support for new bitwise boolean operations to
> nftables, and uses this to extend the types of value which can be
> assigned to packet marks and payload fields.  The original motivation
> for these changes was Kevin Darbyshire-Bryant's wish to be able to set
> the conntrack mark to a bitwise expression derived from a DSCP value:
> 
>   https://lore.kernel.org/netfilter-devel/20191203160652.44396-1-ldir@darbyshire-bryant.me.uk/#r
> 
> For example:
> 
>   nft add rule t c ct mark set ip dscp lshift 26 or 0x10
> 
> Examples like this could be implemented solely by changes to user space.
> However, other examples came up in later discussion, such as:
> 
>   nft add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
> 
> and most recently:
> 
>   nft add rule t c ct mark set ct mark or ip dscp or 0x200
> 
> which require boolean bitwise operations with two variable operands.
> 
> Hitherto, the kernel has required that AND, OR and XOR operations be
> converted in user space to mask-and-xor operations on one register and
> two immediate values.  The related kernel space patch-set, however, adds
> support for performing these operations directly on one register and an
> immediate value, or on two registers.  This patch-set extends nftables
> to make use of this functionality.
> 
> The previous version of this series also included a few small changes to
> make it easier to add debug output and changes to support the assign-
> ments which did not require binops on two registers.  The former have
> been dropped and the latter were reworked and applied by Pablo.  The
> following remain.
> 
> * Patch 1 adds support for linearizing and delinearizing the new
>   operations.
> * Patches 2-7 add support for using them in payload and mark
>   assignments.
> * Patch 8 adds tests for the new assignments.
> 
> Jeremy Sowden (8):
>   netlink: support (de)linearization of new bitwise boolean operations
>   netlink_delinearize: refactor stmt_payload_binop_postprocess
>   netlink_delinearize: add support for processing variable payload
>     statement arguments
>   evaluate: prevent nested byte-order conversions
>   evaluate: preserve existing binop properties
>   evaluate: allow binop expressions with variable right-hand operands
>   parser_json: allow RHS mark and payload expressions
>   tests: add tests for binops with variable RHS operands

Reviewed-by: Phil Sutter <phil@nwl.cc>
