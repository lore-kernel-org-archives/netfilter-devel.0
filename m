From: Thierry Du Tre <thierry@dtsystems.be>
Subject: Re: [PATCH v4] netfilter : add NAT support for shifted portmap ranges
Date: Fri, 16 Feb 2018 12:31:26 +0100
Message-ID: <086f9ca0-140e-bc6c-55a0-21d12c4a657e@dtsystems.be>
References: <f0c9bd53-ab79-9df0-394f-5d612600ee21@dtsystems.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:40114 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965113AbeBPLb2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Feb 2018 06:31:28 -0500
Received: by mail-wm0-f54.google.com with SMTP id v10so2546525wmh.5
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Feb 2018 03:31:28 -0800 (PST)
In-Reply-To: <f0c9bd53-ab79-9df0-394f-5d612600ee21@dtsystems.be>
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Op 30/01/2018 om 14:02 schreef Thierry Du Tre:
> This is a patch proposal to support shifted ranges in portmaps.
> (i.e. tcp/udp incoming port 5000-5100 on WAN redirected to LAN 192.168.1.5:2000-2100)
> 
> Currently DNAT only works for single port or identical port ranges.
> (i.e. ports 5000-5100 on WAN interface redirected to a LAN host while original destination port is not altered)
> When different port ranges are configured, either 'random' mode should be used, or else all incoming connections are mapped onto the first port in the redirect range. (in described example WAN:5000-5100 will all be mapped to 192.168.1.5:2000)
> 
> This patch introduces a new mode indicated by flag NF_NAT_RANGE_PROTO_OFFSET which uses a base port value to calculate an offset with the destination port present in the incoming stream. That offset is then applied as index within the redirect port range (index modulo rangewidth to handle range overflow).
> 
> In described example the base port would be 5000. An incoming stream with destination port 5004 would result in an offset value 4 which means that the NAT'ed stream will be using destination port 2004.
> 
> Other possibilities include deterministic mapping of larger or multiple ranges to a smaller range : WAN:5000-5999 -> LAN:5000-5099 (maps WAN port 5*xx to port 51xx)
> 
> This patch does not change any current behavior. It just adds new NAT proto range functionality which must be selected via the specific flag when intended to use.
> 
> A patch for iptables (libipt_DNAT.c + libip6t_DNAT.c) will also be proposed which makes this functionality immediately available.

I'm wondering if I might have missed a response with more remarks.
As previous versions got some feedback (which I think to have addressed all with the latest submission), I'm hoping to get close to a definitive solution for this extension.

My next step would be to submit a patch for OpenWRT that uses this code by adding support for shifted portmaps.
