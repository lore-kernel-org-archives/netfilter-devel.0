From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Wed, 25 Nov 2015 23:27:15 +0000
Message-ID: <20151125232715.GE20093@macbook.localdomain>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
 <20151125200124.GH30712@macbook.localdomain>
 <alpine.LSU.2.20.1511252341470.6198@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:62565 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752047AbbKYX1U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 18:27:20 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1511252341470.6198@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Jan Engelhardt wrote:
> 
> On Wednesday 2015-11-25 21:01, Patrick McHardy wrote:
> >On 25.11, Pablo Neira Ayuso wrote:
> >>  #define TYPE_MAX		(__TYPE_MAX - 1)
> >> diff --git a/include/proto.h b/include/proto.h
> >> index a43bf98..41af0c1 100644
> >> --- a/include/proto.h
> >> +++ b/include/proto.h
> >> @@ -176,7 +176,7 @@ enum ip_hdr_fields {
> >>  	IPHDR_INVALID,
> >>  	IPHDR_VERSION,
> >>  	IPHDR_HDRLENGTH,
> >> -	IPHDR_TOS,
> >> +	IPHDR_DSCP,
> >
> >Shouldn't we keep both?
> 
> >From what I read from RFC 2474, DSCP is the 6-bit portion.
> The 8-bit field is known as
>   (a) TOS per IPv4 RFC
>   (b) TC (Traffic Class) per IPv6 RFC 2460
>   (c) DS per RFC 2472
> 
> I would therefore recommend against IPHDR_DSCP, and instead go
> with either of IPHDR_TOS, IPHDR_DS, IPHDR_DIFFSERV, or even
> some mnemonic involving traffic class.

But we actually do refer to the 6 bit sub-field and the further 2 bit ECN
sub-field, they are seperate fields with Pablo's patch.
