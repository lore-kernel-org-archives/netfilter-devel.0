From: Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: Fix ipt_REJECT problem with nf_bridge
Date: Thu, 12 Mar 2009 14:17:36 +0200
Message-ID: <9b2db90b0903120517q665d20evc3795989b2f05c7b@mail.gmail.com>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>
	 <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>
	 <49B5FE06.1010204@snapgear.com>
	 <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com>
	 <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com>
	 <49B85FA6.9040601@snapgear.com>
	 <alpine.LSU.2.00.0903120341520.31440@fbirervta.pbzchgretzou.qr>
	 <49B8A5E3.7070909@snapgear.com>
	 <alpine.LSU.2.00.0903121133590.24554@fbirervta.pbzchgretzou.qr>
	 <9b2db90b0903120516n1f9e67ck8994c9b92bb6aa0a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:60179 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZCLMRj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:17:39 -0400
Received: by ewy25 with SMTP id 25so334289ewy.37
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2009 05:17:36 -0700 (PDT)
In-Reply-To: <9b2db90b0903120516n1f9e67ck8994c9b92bb6aa0a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> So what about the OP's observation that nskb->nf_bridge == NULL?>
> Just because the incoming packet came in over a bridge does
> not mean the RST is going over one too, and that being the
> deciding factor for RTN_LOCAL or not, is it?

Well, in my case the RST goes over the bridge also. But the main
factor is the following comment made by Philip:
>
> >We can't specify addr_type != RTN_LOCAL for the pure bridging case,
> >because that tries to route the RST as though we received it
> >from the network, which will fail if ip forwarding is disabled.
> >
>

In my settings, I have a transparent bridge which does not allow ip
forwarding. According to the comment above, this would prevent the RST
from being sent.

In any way, I will happily test any suggestions/patches after the weekend.
Cheers.
