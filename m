From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat_core just using l3proto_find_get
Date: Tue, 19 Feb 2008 13:22:44 +0100
Message-ID: <47BACA14.8000006@trash.net>
References: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:46656 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751624AbYBSMXQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:23:16 -0500
In-Reply-To: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi,
> 
> 
> I just noticed that nf_nat_core.c uses
> 
>         l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
> 
> in its nf_nat_init() function. Why is not it using 
> nf_ct_l3proto_module_try_get here?

There is no such function, nf_ct_l3proto_find_get() takes a
module reference.
