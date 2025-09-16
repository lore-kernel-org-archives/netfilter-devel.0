Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8584F27713
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Sep 2025 22:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758061969; cv=none; b=rbLfY2eIleVLe9MOMq7+ZhOBTExraSv/TLSievy7U4wj6OkKw948BND56sPuQ8aDVFo4eEtR0pWAQSLl9h/achywjWE71O4dKFYeVsKSxyDskKhZnKG3rNPW7eJQ3gM2BuYuv5Ix4bhEEw9lqA0WZV28VXh4wHF5HVmuDUbZY9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758061969; c=relaxed/simple;
	bh=pyAS87M/YxXSeagsaozY6NHyGI9xs6GPkcMOln/KIPI=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMPKOA4zix0LOFoWWGM0rMmS9sMEwhdG0lKUM78B1h5fdvVvCEGPV+NEKTS9j+YBMnj3MWd0jPYcgWnAyaCZf6IlK0eeuNhNxn43DJ1wqdWayZggImI/BV9VPFDt6yC+tTo+mm1ibxVv+tiMEsdkTXGtdXDU/kE9a0y5uXCMmog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ogWSMZo8; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MtflAXxK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ogWSMZo8";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MtflAXxK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id BF8B7605FA; Wed, 17 Sep 2025 00:32:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758061957;
	bh=Btzp03+kHgf7rYtybQfFekYGXy7iAkabK+80qamdbhs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ogWSMZo809GObBtgWA0tatz8m+wB8gYH9mpzL02687o4JY4twAH3jWqzZf8hyeFtJ
	 9w/Cj6Bi5ZcBJFkV9luK7g0LwWxzW3hHJIz7n8NjfzCIWU+cyPRXR8jMFRLNzafZd6
	 IMihcjRLPbYuPL+xPpaXvUrpX9ypw+S/rayZYszNQ+u1Fs32NgfdDmpE0WgB1VJfS0
	 kNRI9BD10CAWIklvCOR6ifJJpnx+YW40xCNN7XSbnXq4pHaAKelIXYPQ2CMpcz7MS6
	 BEe9ofBZvRcQBmoE5fpXRPAQBFC7mdeijWMETdV22xQ3F314k55jOCQAqDcqqc+OkT
	 MkBWaTFyfOL3A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B080D605F6;
	Wed, 17 Sep 2025 00:32:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1758061956;
	bh=Btzp03+kHgf7rYtybQfFekYGXy7iAkabK+80qamdbhs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=MtflAXxKDNQys/asWcj5/IslckUkkqoBJD12H70uVeEN5WS1Mzuc6dTSvy0TVVtvq
	 uowVJFpf1QauGkUiaP913ATZDRDyWS90skfDY9KK6xKQUea/kSBO3jvNYP/UISFPCk
	 K/gc3DMwJxygC0Vak530G+icJg70HWAL8FIZOFq2KLs+3XCfULzJgbbc+/sP1IzGCM
	 n1cbWfN7ny5EEWXon9Ux/jxHJmISp/PrX0nikSMDfSbb06N302V4Z7KsTUqPVvsoSh
	 se1tFhHRlBXlKrjsgzeumDNN1idaJCQU6eE/0KZ0Rv3JeaJe3YUganZqn/egw121D9
	 UmH07RVQ3VEXw==
Date: Wed, 17 Sep 2025 00:32:34 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aMnlgsXe8ufMGoAF@calendula>
References: <20250911141503.17828-1-phil@nwl.cc>
 <aMiC3xCrX_8T8rxe@calendula>
 <aMiQSi-ASbcAE5CL@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aMiQSi-ASbcAE5CL@orbyte.nwl.cc>

Hi Phil,

On Tue, Sep 16, 2025 at 12:16:42AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Mon, Sep 15, 2025 at 11:19:27PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 11, 2025 at 04:11:45PM +0200, Phil Sutter wrote:
> > > The old code printing each field with data as u32 value is problematic
> > > in two ways:
> > > 
> > > A) Field values are printed in host byte order which may not be correct
> > >    and output for identical data will divert between machines of
> > >    different Endianness.
> > > 
> > > B) The actual data length is not clearly readable from given output.
> > > 
> > > This patch won't entirely fix for (A) given that data may be in host
> > > byte order but it solves for the common case of matching against packet
> > > data.
> > > 
> > > Fixing for (B) is crucial to see what's happening beneath the bonnet.
> > > The new output will show exactly what is used e.g. by a cmp expression.
> > 
> > Could you fix this from libnftables? ie. add print functions that have
> > access to the byteorder, so print can do accordingly.
> 
> You mean replacing nftnl_expr_fprintf() and all per-expr callbacks
> entirely? I guess this exposes lots of libnftnl internals to
> libnftables.
>
> IIRC, the last approach from 2020 was to communicate LHS byteorder to
> RHS in libnftnl internally and in addition to that annotate sets with
> element byteorder info (which is not entirely trivial due to
> concatenations of data with varying byteorder.
>
> I don't get the code in my old branches anymore, though. Maybe if I read
> up on our past mails. Or maybe we just retry from scratch with a fresh
> mind. :)

Maybe this approach?

For immediates, a new libnftnl function could help us deal with this:

-                nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld2.value, nld2.len);
+                nftnl_expr_set_imm(nle, NFTNL_EXPR_CMP_DATA, nld2.value, nld2.len, nld2.byteorder);

Then, for set elements, add a new field here:

struct nft_data_linearize {
        uint32_t        len;
        uint32_t        value[NFT_REG32_COUNT];
+       uint32_t        byteorder[NFT_REG32_COUNT];

where byteorder stores a bitmask that specifies byteorder, 0 can be
network endian and 1 host endian, the length of the bitmask length
tells us the size of this field.

Then, add nftnl_set_elem_set_imm() that takes nld.byteorder.

From libnftnl, use this bitmask from _snprintf to swap bits
accordingly.

union nftnl_data_reg would need to be modified to store this
byteorder[] array including the bitmask. This will not increase memory
consumption because only one intermediate libnftnl object is used to
generate the netlink bytecode blob at a time.

This should not be too hard to make it work for userspace -> kernel.

Would this be good enough to make tests/py happy?
