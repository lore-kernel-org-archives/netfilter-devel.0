Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792578673;
	b=2sDSHkn9672LW6TL7iP/TQsdX5lxjNkH3jNLrnYleifj7wYLNNZMHrPW9mVkoRVp2o25
	 mLFH+UBXg8P6xhy3eIwkPLSRRLepLRWaXxN1s+Va6/ZfO8aio+ohUzBN37kSEayerBDmB
	 MvyJA6zknWXys83VwDZU4iRc/IZ/Ybm++atvaRLBmsw0OvUcJTF4hI1bONun2BzKy2Std
	 5hSqH8srZw6uu4HvYFihHBKmlZJYE20URai7Z2hBTVTWXab+z43Ooadr+B4kPDVAGHguI
	 ipMo+U1EBwtA9kKJsqwgRR9dKBzotlFgCM5WL7+yuXSwHDL0uKzkfKONTYpqUeWatbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792578673;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=sojF1KKVkTqJ4zpAUda3Cm7bG/ndCOTm5sVtE8EeXPQ=;
	b=uF3VhTkCW5XjTnoZwmCoQemBbDy2DM646DW+qCCE3EaHk4WCJ2hB2agvagKO+GM/IWda
	 b7vq2WVr7SkK5xYnyPiGTmAdFM4A17oUWeq1BxlhiTWpTtSDbHZ9sq/+/b7NP6c1DEnnV
	 9ezcaaNCPRg0DzCliCoGMIZRIwkGkf78QOU4oiTojoXtK+ElSnjYcQ58+QIFPWxiDXJDM
	 LAyTNOj5PDk7JmtLjDb4llXYQadrFs5X+OOE2djsS8F3LHIPtbWFtsRreoFOY10L+Nk4+
	 /Si2kixH91q3ktgxv++5226xI+T+4X9bP4aVj2NzrIiJLuW+a2DRLKAxveCtEBkUjgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CrV+TG+g;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8493C606A319
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 10:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8493C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=CrV+TG+g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792578670;
	bh=sojF1KKVkTqJ4zpAUda3Cm7bG/ndCOTm5sVtE8EeXPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CrV+TG+gICzL1lVRZCEjpSwUL99Ratp5v1qZbmn7U6M9/TG6DLvBtHkCK63lq18oB
	 CfkT44mFhf4PlkRers6H5HgSlH1WCpMBSJu3UXJrje8RnAXF8ZLMxXZi67rc/yeY/H
	 ScIzugEetxfSWl17IoK5jXvYoZUYk2UO2GCu4Bj/XXynlJb7Le9slWk8a7CELU2Bdp
	 aJjTBQiEm+UNFCScE9tjPg1ax2BhCbXv/vdsFbXYfuq8lR39seyZjlQwMajijVV/Fx
	 sGT2jrroT+LJ8LMnKP8lHMEzzYrN2OSVcO+ZMuy1fBSM8iwoj1ONoIKDEOfsTOUtmN
	 7u/7YT0b8iiCQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5AA2E60057;
	Wed, 21 Oct 2026 12:31:10 +0200 (CEST)
Date: Wed, 21 Oct 2026 12:31:08 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Balazs Gulacsi <m2gulbal@gmail.com>
Subject: Re: [iptables PATCH] extensions: libxt_conntrack: Fail on
 untranslatable state match
Message-ID: <atiUbF-5aXoKdpJk@chamomile>
References: <20261008182605.257290-1-phil@nwl.cc>
 <atiRNbVh-1ELNyDX@orbyte.nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <atiRNbVh-1ELNyDX@orbyte.nwl.cc>

Hi Phil,

On Wed, Oct 21, 2026 at 12:17:25PM +0200, Phil Sutter wrote:
> On Thu, Oct 08, 2026 at 08:23:51PM +0200, Phil Sutter wrote:
> > Iptables' conntrack match supports combined matching on ct->state bits
> > as well as the NAT bits in ct->status. The kernel extension matches if
> > any of the bits is set, i.e. '-m conntrack --ctstate NEW,DNAT' matches
> > packets in either NEW state or DNAT status or both. Therefore,
> > translating this sample match into 'ct status dnat ct state new' is
> > wrong: The nftables rule matches only if both statements match.
> > 
> > The only way to achieve this in nftables seems to be by duplicating the
> > rule which is not feasible within the xlate infrastructure. So instead
> > just abort the translation.
> > 
> > This is a partial revert of commit 1a13277f88099 ("extensions:
> > libxt_conntrack: Fix for ignored ctstates in translation") which turned
> > an incomplete translation into an incorrect one.
> > 
> > Cc: Balazs Gulacsi <m2gulbal@gmail.com>
> > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1826
> > Fixes: 26ec09bf6b9b6 ("extensions: libxt_conntrack: provide translation for DNAT and SNAT --ctstate")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Patch applied.

Thanks.

I wonder if it is worth filling the gap and expose snat and dnat
through ct state in nftables.

This will take time to propagate before we can expose it via userspace
(we have here the dilemma of exposing a feature which would be not
available in old kernel, but it would in newer ones... without having
an easy way to reject from control plane given the cmp and lookup
expressions do not have context on the acceptables values.

Such patch should be relatively small.
