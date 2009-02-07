From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Introduce xtables_afinfo
Date: Sat, 07 Feb 2009 14:43:38 -0500
Message-ID: <1234035818.4441.36.camel@dogo.mojatatu.com>
References: <1234026339.4441.24.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902071957040.12855@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:65030 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbZBGTpb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Feb 2009 14:45:31 -0500
Received: by nf-out-0910.google.com with SMTP id d3so206626nfc.21
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Feb 2009 11:45:28 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902071957040.12855@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2009-02-07 at 20:05 +0100, Jan Engelhardt wrote:
> ess.
> 
> This afinfo thing has been a red LED beam in my eye. I just do not think
> iproute2-m_ipt should have to deal with afinfo at all.
> ..
> So I now also dealt with that and moved it according to what I 
> think is right - see latest git commit in mine; [77f48c2]

Ok, tried that looks good. I prefer the approach you have. So
discard the patch i posted.

cheers,
jamal


