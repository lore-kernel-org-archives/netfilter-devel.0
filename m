From: Philip Craig <philipc@snapgear.com>
Subject: Re: Fix ipt_REJECT problem with nf_bridge
Date: Fri, 13 Mar 2009 10:50:22 +1000
Message-ID: <49B9ADCE.3050702@snapgear.com>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>  <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>  <49B5FE06.1010204@snapgear.com>  <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com> <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com> <49B85FA6.9040601@snapgear.com> <alpine.LSU.2.00.0903120341520.31440@fbirervta.pbzchgretzou.qr> <49B8A5E3.7070909@snapgear.com> <alpine.LSU.2.00.0903121133590.24554@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Nir Tzachar <nir.tzachar@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:58170 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756057AbZCMAtO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:49:14 -0400
In-Reply-To: <alpine.LSU.2.00.0903121133590.24554@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> So what about the OP's observation that nskb->nf_bridge == NULL?
> Just because the incoming packet came in over a bridge does
> not mean the RST is going over one too, and that being the
> deciding factor for RTN_LOCAL or not, is it?

Agreed that the RST may not be going out a bridge.

We don't know yet whether the RST will be bridged; that's why
we are calling ip_route_me_harder().

The deciding factor for RTN_LOCAL should be whether the incoming
packet is purely bridged, because that means the RST will have
a foreign source address.  We must follow the first code path in
ip_route_me_harder() or we drop it when ip forwarding is disabled,
but if the RST has a foreign source address then it will normally
follow the second code path, so we must force the first by
specifying RTN_LOCAL.

