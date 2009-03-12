From: Philip Craig <philipc@snapgear.com>
Subject: Re: [PATCH]: Fix ipt_REJECT problem with nf_bridge
Date: Thu, 12 Mar 2009 11:04:38 +1000
Message-ID: <49B85FA6.9040601@snapgear.com>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>	 <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>	 <49B5FE06.1010204@snapgear.com>	 <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com> <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de
To: Nir Tzachar <nir.tzachar@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:45061 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752210AbZCLBDf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:03:35 -0400
In-Reply-To: <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nir Tzachar wrote:
> I have checked the change you proposed (checking oldskb instead of
> nskb) , and indeed it works. Should I resubmit a patch for it?

Yes please, but it will need someone that knows more about
routing internals than me to review it still.

