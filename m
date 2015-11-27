From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Fri, 27 Nov 2015 11:54:17 +0100
Message-ID: <20151127105417.GE15392@breakpoint.cc>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
 <20151127094958.GB15392@breakpoint.cc>
 <20151127095424.GF4263@macbook.localdomain>
 <20151127103428.GC15392@breakpoint.cc>
 <20151127104248.GD15392@breakpoint.cc>
 <20151127104923.GH4263@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38811 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751538AbbK0KyU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 05:54:20 -0500
Content-Disposition: inline
In-Reply-To: <20151127104923.GH4263@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> Yes, I also did that and it looks correct. I think we probably have a
> discrepancy with bit numbering:
> 
> Looking at an older patch of you:
> 
> -               [IPHDR_VERSION]         = HDR_BITFIELD("version", &integer_type, 0, 4),
> -               [IPHDR_HDRLENGTH]       = HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
> +               [IPHDR_VERSION]         = HDR_BITFIELD("version", &integer_type, 4, 4),
> +               [IPHDR_HDRLENGTH]       = HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
> 
> So you seem to assume a numbering which corresponds to how you would express
> it in C. My patch assumes numbering as used in the RFCs/IEEE standards, which
> is basically the opposite direction.

Right, there is a general problem with all sub-byte fields.

I just noticed that decoding of ip version/hdrlen doesn't work either.
(ip hdrlength 4 ip version 5).

I am sure that I tested matching on ip version/hdrlen on both
x86-64 and a MSB machine (don't recall architecture, ppc i think).
