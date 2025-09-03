Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4BB1CEAC2
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 10:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756895496; cv=none; b=K+bbDMRb/+RiWxesaFUvACctjQNyTn391stGCrqJytAHpqKC958mIq8UrVldyha6MxcC3FU/Zwqqe6lGKH4Fu5tQqVkSDPaTAuMTA8q0kys5K+xnRdlCWYU2jDfIyf2PTAAhSb2b3howKxzxfOobgnIq0aGJQMo/1sWyfXr+ays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756895496; c=relaxed/simple;
	bh=jXkReWTIRMYB2+mCrNkjCsoxZLlP5E5IPrsyTO92wOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wx+YLtBdylqme5vlvlgFTyh0k8xGv68YDOmOtuA9zQrRqU8gBru6oeF05PMsz5p4gofRXDoRWH9yXncKRGoBb+mhZAUXoAERw1wCdR9cZEnIH5ln9xr7sDRSkClPvu8O2RIp3UjgO+98P8dkpPxbcyeM+njqdxNglqAHs3nw/5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FlRA7Ct4; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OI/Y+lqY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FlRA7Ct4";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OI/Y+lqY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B04DF606FF; Wed,  3 Sep 2025 12:31:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756895483;
	bh=wSDZ7YOb205sud5aR0EC16VOilazP7E3KCamVxxIfwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FlRA7Ct4ahTYKFkS4C5Yhw4S8D1SjKPFu6GBr82GrZ872QUsmQMmATCiJ+Dd2LHit
	 3QhNQ0/v5G87aHb6ktBw+o03KEHxbRuBQDkKU8s2SvnmDJxROI1pn+NC5wtdzrmEqL
	 b2AjpIsQDWcjI6UXCDA3D1SoDKFvi+kchBsg0t6FGNXJRXuctuyuopdfMfASuYCvzb
	 EOsTzy8/BR5X4Fj1tSEezLvjMds0qJXDnzSUpx7dR50+9JiRe9/8/Ka7NuJAMRimga
	 I26lgNq4fL76D1Ote6WY6uETJdAVjQp9aOzA10cUzU0UXGWjq8VWmvedUtFAa+h2FD
	 cijT8egmWzVCA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BB34E606F0;
	Wed,  3 Sep 2025 12:31:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756895482;
	bh=wSDZ7YOb205sud5aR0EC16VOilazP7E3KCamVxxIfwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OI/Y+lqYYzwymQk6J9ozpnnTi2ok/k1MJ3/yUIQGoyD7NDarkzd6IqGqtgLTlvpu9
	 j4HCP0Ri4uUSBQ/RyBbJ9cyEDCstKfg9MNDpH754GLLDWmlZMvZDoVTEo1Ts3cPa4G
	 h5i7I8AJ9e+LqUxMsl4vKoJrG1Z5zaK6QGpXP5ovNEZPf18JE77Q+yHFArToO9uBUt
	 60IMkg/StX1k0AaAermcc0xlsUXWcFLQpE3c5kfjaOqXrJfDOjgfPa1IDN3drSzfxi
	 SEewtaesccloxS4ip6h9BMy6SRsl9OF4/Ktn032S1wluifRybQGyHWa9DhEtctyYwT
	 2bC+oMULkZuPw==
Date: Wed, 3 Sep 2025 12:31:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Nikolaos Gkarlis <nickgarlis@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
Message-ID: <aLgY-O5Oj-ZjhZJS@calendula>
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
 <20250902215433.75568-1-nickgarlis@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250902215433.75568-1-nickgarlis@gmail.com>

On Tue, Sep 02, 2025 at 11:54:33PM +0200, Nikolaos Gkarlis wrote:
> The kernel allows netlink messages that use the legacy NFT_CT_SRC and
> NFT_CT_DST keys in inet tables without an accompanying nft_meta
> expression specifying NFT_META_NFPROTO. This results in ambiguous
> conntrack expressions that cannot be reliably evaluated during packet
> processing.
> 
> When that happens, the register size calculation defaults to IPv6 (16
> bytes) regardless of the actual packet family.
> 
> This causes two issues:
> 1. For IPv4 packets, only 4 bytes contain valid address data while 12
>    bytes contain uninitialized memory during comparison.
> 2. nft userspace cannot properly display these rules ([invalid type]).
> 
> The bug is not reproducible through standard nft commands, which use
> NFT_CT_SRC_IP(6) and NFT_CT_DST_IP(6) keys when NFT_META_NFPROTO is
> not defined.
> 
> Fix by adding a pointer to the parent nft_rule in nft_expr, allowing
> iteration over preceding expressions to ensure that an nft_meta with
> NFT_META_NFPROTO has been defined.

I think it is easier to work around this from userspace by translating
NFT_CT_SRC to NFT_CT_SRC_{IPV4,IPV6} by peeking the datatype at the
rhs of the relational.

NFT_CT_{SRC,DST} only works with relational expression, they are
broken with sets, that's why NFT_CT_SRC_{IPV4,IPV6} was introduced
(which works with both relational expressions and sets).

IIRC, I removed documentation for this syntax time ago with the
expectation, it seems someone found it and it is buggy with
NFPROTO_INET as you describe.
