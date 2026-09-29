Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539643CC9EA
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 10:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790676039; cv=none; b=QlkgrfvhsaU3D11C6vPzSUBpobVsIEMzginhNPgWpqzChhLDbZTea4tRAm6eBVsefJZmll78KWD0xSjwKhLixXQ/NvZsUmlAh6c4swYIROBCLIStiY1RYGOS5fBzlUIs4eNu0sJqSO7eKfhIXUypk4QVkKP7FWouHeI9yWGCxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790676039; c=relaxed/simple;
	bh=Q4/b4dyyYTeGFCgR6nTrVkpN/ytUiUooOEHpgPaNmyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbStaIs7dquRkewfTU8DCK+EG+o8fQtiX0+4rb7ZLHZNX9X55DA19gUhI84inbCXelqrztI88AiU4M55p0dK9ZCMcIDpB2RrO+135BdxoWF/Xia00QgqG2Yb1t3MBAPmPyhDC3UMxgyFUA6dG99Zovv3N4TR1nZtki1lEP6+TGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=E0KgW/Q/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="E0KgW/Q/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790676031;
	bh=8MChdoMj9QK6pRKX4fO2e+AHsndK58ClcB9VMHW5TwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E0KgW/Q/yQ3DbDC2fFQj5BqVL7uYpFq6BpwylqX4tq0hVUxWYnxAWysQNFihiOi7r
	 ycp0nhfTjJWfGd4/OWv3ts7Ty1OPAquRHgHYbyIQFDSiWfG3SXXqcPEKc7+n+lzRmh
	 qldW9U5wtTKX20X2A+unVq1Va9ERn3rS/syi+cJMyvqluhi3TNzNjeO4uXyRDbOkmB
	 jVx3tO/lRXkBe6hLZKxiby/lTr9GdOl01CD4WGD7Uw2ewKqi9wZJtHK19dDFekaAvq
	 jmp37Rd5Xc7BeY2o+TndAsFnwKWparMzBZkfb58zCI49YJ2LPQwZQnfpO7/WIMMkaX
	 RBrxD/vyr2c1w==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 0EEED603CF;
	Tue, 29 Sep 2026 12:00:31 +0200 (CEST)
Date: Tue, 29 Sep 2026 12:00:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Netfilter Coreteam <coreteam@netfilter.org>
Subject: Re: Netfilter: match "tcp option" with the same type present
 multiple times
Message-ID: <aruMPHNdZq7U9eV9@chamomile>
References: <a391d81c-0bce-41e6-886e-a558765c6891@kernel.org>
 <arrhlKkKSSKFp4Sq@chamomile>
 <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a1e6f81d-d902-4bae-8244-ad936ef70e19@kernel.org>

On Tue, Sep 29, 2026 at 11:21:15AM +0200, Matthieu Baerts wrote:
> Hi Pablo,
> 
> Thank you for your reply!
> 
> On 28/09/2026 23:52, Pablo Neira Ayuso wrote:
> > Hi Mattieu,
> > 
> > On Mon, Sep 28, 2026 at 02:13:16PM +0200, Matthieu Baerts wrote:
> >> Hello Netfilter devs,
> >>
> >> First, thank you for maintaining Netfilter in the kernel and the
> >> userspace tools.
> >>
> >> The MPTCP selftests are switching from IPTables to NFTables, and
> >> Clashiko reported that this part of a rule wouldn't match anything:
> >>
> >>   tcp option mptcp subtype remove-addr drop
> >>
> >> When an MPTCP REMOVE_ADDR suboption (type 0x30, len >=4, subtype 0x4) is
> >> added to the TCP options, it is added after an MPTCP DSS option (type
> >> 0x30, len >= 8, subtype 0x2). In other words, there will be two MPTCP
> >> (type 30) options in the TCP options. It looks like Netfilter doesn't
> >> handle that, because it stops processing other TCP options when the
> >> expected type is found:
> >>
> >> net/netfilter/nft_exthdr.c:nft_exthdr_tcp_eval() {
> >>     ...
> >> 	for (i = sizeof(*tcph); i < tcphdr_len - 1; i += optl) {
> >> 		optl = optlen(opt, i);
> >>
> >> 		if (priv->type != opt[i])
> >> 			continue;
> >> 		...
> >> 		return;  // <== it will look at the first MPTCP option
> >> 	}
> >>     ...
> >> }
> >>
> >> It looks like it shouldn't stop if the wrong subtype is found, but the
> >> subtype is not compared there if I'm not mistaken. Should there be a fix
> >> to support this case?
> > 
> > Would it work for you if you can specify what TCP option you want to
> > match? ie.
> >  
> >     tcp option[2] mptcp subtype remove-addr drop
> >                ^
> >                |
> >                |
> >        allow to specify a match at a given tcp option
> 
> In my specific use-case, yes it would work. Some MPTCP sub-options will
> always be after another one... when the Linux stack is used.

This would require a smaller patch.

> > Or would this be too strict for your use-case and you would prefer
> > that you can match it anywhere?
> 
> I think it would make more sense to match it anywhere. For example, an
> MP_RESET can be used alone, or after an MP_FASTCLOSE. Plus some stacks
> could reorder the options as there is no imposed order.

I think this would require a MPTCP subtype parser, ie. make kernel
aware of MPTCP subtypes.

I would support both of them eventually? Starting by the one above
that allows to match at a given position which looks simpler to
support to me. Then, look into adding a MPTCP subtype parser later?

Thanks.
