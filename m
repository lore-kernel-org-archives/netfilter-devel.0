From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/5] net: netfilter conntrack - add per-net
	functionality for ICMP protocol
Date: Thu, 26 Mar 2009 19:34:44 +0300
Message-ID: <20090326163444.GA27855@x200.localdomain>
References: <20090326160544.519118777@openvz.org> <20090326160711.826548855@openvz.org> <49CBAA5F.5020907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
	netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:50370 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbZCZQ1X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 12:27:23 -0400
Received: by fxm2 with SMTP id 2so638323fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 09:27:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <49CBAA5F.5020907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 26, 2009 at 05:16:31PM +0100, Patrick McHardy wrote:
> Cyrill Gorcunov wrote:
>> Module specific data moved into per-net site and being allocated/freed
>> during net namespace creation/deletion. For this reason module_init/exit
>> calls added.
>
> This doesn't work. You can't have multiple module_init functions
> in one module and nf_connntrack_ivp4 already includes one.

I thought all sysctl code would be generic in sense it will be done
during L3 and L4 proto registration, so all those ifdefs will be in one
place and so on.
