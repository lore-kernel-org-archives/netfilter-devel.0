Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FC02D7DDA
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Sep 2025 08:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757578467; cv=none; b=NFe0sI+qMFJFGI6HITRitM/vDQMLKhCDK8QS3TSRjh0GpGVA6VN+QpkUoBgxuMWmbKlV5+yLOYVbPJkt/Tg5X4MOqTZnZQ4FzG3MmlshJcDFOg44gv6T5U2ygvjCmJfy3hrqUFQAPuUIlukeYOLnQ1S/TO1gUVU3RQR9MPgSvl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757578467; c=relaxed/simple;
	bh=hivCDXvwqdKvIjxiiGgQi2BRAmq8NojOxYfE2dE9A5g=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=inwCdLv/ANraysnnTqKrlw1APQFo0bFzVI6GDTY3l0NBrr3p3W91OhN84XnSLGBIW1ZcK3Syp9cf7ibThVbdvGkOnOk18QFkNkq2ocbl94CRhNxZeguQ67chuKTElCMPq0NffK+KSuXlBWdxwkLjB14C74BGfxzlnurYiexHZCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TSwZ0xxE; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TSwZ0xxE; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TSwZ0xxE";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TSwZ0xxE"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EC8CD609AE; Thu, 11 Sep 2025 10:14:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757578453;
	bh=bzzaon1JwSzpAaP24G7seJQBPqXr0wEu9CAUDU3syBs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=TSwZ0xxE+6sk4of65FeNCI9hmOkDVxEy5cBLR7wCRAojYKvkoTxL3ACFNsCEGJes4
	 AGuek0UeXjk/b0xJGxCJrjfv447qqh18P5b/G99Pt/1YOeY5CBfQSDKSwBRLE2mA4I
	 iVrUf2ibrjhF+WdtHJI2GooKTb2YQ9idikuRAQesN8HhU3JE4n6PhuuIeB2JerWVjo
	 VA6CUa09/IlPPC6+sMNVraIj1eca3G0FVs67pCN4KxteszoNvCsoPHoKkZ47oUYBTZ
	 kzeLA6/ViBRSm/qGrwdDwwtsEJPuGLc2vmqtiimBOTK64tJnS6pV6MY1y02vuZR2Fv
	 qt2SYQWoDJT5A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E5595609AA;
	Thu, 11 Sep 2025 10:14:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757578453;
	bh=bzzaon1JwSzpAaP24G7seJQBPqXr0wEu9CAUDU3syBs=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=TSwZ0xxE+6sk4of65FeNCI9hmOkDVxEy5cBLR7wCRAojYKvkoTxL3ACFNsCEGJes4
	 AGuek0UeXjk/b0xJGxCJrjfv447qqh18P5b/G99Pt/1YOeY5CBfQSDKSwBRLE2mA4I
	 iVrUf2ibrjhF+WdtHJI2GooKTb2YQ9idikuRAQesN8HhU3JE4n6PhuuIeB2JerWVjo
	 VA6CUa09/IlPPC6+sMNVraIj1eca3G0FVs67pCN4KxteszoNvCsoPHoKkZ47oUYBTZ
	 kzeLA6/ViBRSm/qGrwdDwwtsEJPuGLc2vmqtiimBOTK64tJnS6pV6MY1y02vuZR2Fv
	 qt2SYQWoDJT5A==
Date: Thu, 11 Sep 2025 10:14:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Yi Chen <yiche@redhat.com>
Subject: Re: [nft PATCH] fib: Fix for existence check on Big Endian
Message-ID: <aMKE04zkMk9Ysmn3@calendula>
References: <20250909204948.17757-1-phil@nwl.cc>
 <aMCdSDWhxCJM_kjY@calendula>
 <aMCuzr9SaA--RG3f@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="13sx2Gdqo+wihj6g"
Content-Disposition: inline
In-Reply-To: <aMCuzr9SaA--RG3f@orbyte.nwl.cc>


--13sx2Gdqo+wihj6g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Sep 10, 2025 at 12:48:46AM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Tue, Sep 09, 2025 at 11:34:00PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Sep 09, 2025 at 10:49:48PM +0200, Phil Sutter wrote:
> > > Adjust the expression size to 1B so cmp expression value is correct.
> > > Without this, the rule 'fib saddr . iif check exists' generates
> > > following byte code on BE:
> > > 
> > > |  [ fib saddr . iif oif present => reg 1 ]
> > > |  [ cmp eq reg 1 0x00000001 ]
> > > 
> > > Though with NFTA_FIB_F_PRESENT flag set, nft_fib.ko writes to the first
> > > byte of reg 1 only (using nft_reg_store8()). With this patch in place,
> > > byte code is correct:
> > > 
> > > |  [ fib saddr . iif oif present => reg 1 ]
> > > |  [ cmp eq reg 1 0x01000000 ]
> > 
> > Is this a generic issue of boolean that is using 1 bit?
> > 
> > const struct datatype boolean_type = {
> >         .type           = TYPE_BOOLEAN,
> >         .name           = "boolean",
> >         .desc           = "boolean type",
> >         .size           = 1,
> 
> Maybe, yes: I compared fib existence checks to exthdr ones in order to
> find the bug. With exthdr, we know in parser already that it is an
> existence check (see exthdr_exists_expr rule in parser_bison.y). If so,
> exthdr expression is allocated with type 1 which is (assumed to be) the
> NEXTHDR field in all extension headers. This field has
> inet_protocol_type, which is size 8b.
> 
> Via expr_ctx::len, RHS will then be adjusted to 8b size (see 'expr->len =
> masklen' in expr_evaluate_integer()).
> 
> IIRC, LHS defines the RHS size in relationals. I am not sure if we may
> sanely reverse this rule if RHS is a boolean_type.

Probably this fix is more generic, see untested patch.

--13sx2Gdqo+wihj6g
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="y.patch"

diff --git a/src/datatype.c b/src/datatype.c
index f347010f4a1a..2d39239316a6 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1581,7 +1581,7 @@ const struct datatype boolean_type = {
 	.type		= TYPE_BOOLEAN,
 	.name		= "boolean",
 	.desc		= "boolean type",
-	.size		= 1,
+	.size		= BITS_PER_BYTE,
 	.parse		= boolean_type_parse,
 	.basetype	= &integer_type,
 	.sym_tbl	= &boolean_tbl,

--13sx2Gdqo+wihj6g--
