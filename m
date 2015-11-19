From: Florian Westphal <fw@strlen.de>
Subject: Re: Extending connmark to 64 bits
Date: Thu, 19 Nov 2015 04:00:11 +0100
Message-ID: <20151119030011.GA6710@breakpoint.cc>
References: <1447802062.16644.12.camel@mattb-dl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Matt Bennett <Matt.Bennett@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:47389 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813AbbKSDAO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Nov 2015 22:00:14 -0500
Content-Disposition: inline
In-Reply-To: <1447802062.16644.12.camel@mattb-dl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Matt Bennett <Matt.Bennett@alliedtelesis.co.nz> wrote:
> Currently we have a number of router features making use of connection
> tracking. As such we now require more than the 32 bits connmark
> currently has. Our first inclination is to extend this field to 64 bits
> and update related areas of code appropriately.
> 
> The major question we have is whether there is a reason this field is 32
> bits (performance reasons or other)?

Its meant to align with skb->mark.

> If it is not possible to extend this field then perhaps there are other
> options (beyond disabling some features making use of connection
> tracking)?

Have you looked at using conntrack labels?

Its a 128bit storage area.
