From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 1/5] net: netfilter conntrack - add per-net
	functionality for ICMP protocol
Date: Thu, 26 Mar 2009 20:37:44 +0300
Message-ID: <20090326173744.GG7950@localhost>
References: <20090326160544.519118777@openvz.org> <20090326160711.826548855@openvz.org> <49CBAA5F.5020907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr, Alexey Dobriyan <adobriyan@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:48853 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZCZRhO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:37:14 -0400
Received: by ti-out-0910.google.com with SMTP id i7so456764tid.23
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 10:37:11 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <49CBAA5F.5020907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Patrick McHardy - Thu, Mar 26, 2009 at 05:16:31PM +0100]
> Cyrill Gorcunov wrote:
>> Module specific data moved into per-net site and being allocated/freed
>> during net namespace creation/deletion. For this reason module_init/exit
>> calls added.
>
> This doesn't work. You can't have multiple module_init functions
> in one module and nf_connntrack_ivp4 already includes one.
>
> Please test your patches with a modular built before resubmitting.
>

Btw, the patches

	[patch 2/5] net: netfilter conntrack - add per-net functionality for SCTP protocol
	[patch 5/5] net: netfilter conntrack - add per-net functionality for UDPLITE protocol

are not affected by multiple module_init/exit issue (except general idea
Alexey mentioned)

        Cyrill
