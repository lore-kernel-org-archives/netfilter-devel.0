From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [patch 1/5] net: netfilter conntrack - add per-net
	functionality for ICMP protocol
Date: Thu, 26 Mar 2009 21:23:52 +0300
Message-ID: <20090326182352.GI7950@localhost>
References: <20090326160544.519118777@openvz.org> <20090326160711.826548855@openvz.org> <49CBAA5F.5020907@trash.net> <20090326163444.GA27855@x200.localdomain> <20090326165928.GE7950@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Alexey Dobriyan <adobriyan@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, xemul@openvz.org,
	daniel.lezcano@free.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:55288 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410AbZCZSXX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 14:23:23 -0400
Received: by ti-out-0910.google.com with SMTP id i7so465566tid.23
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 11:23:20 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20090326165928.GE7950@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Cyrill Gorcunov - Thu, Mar 26, 2009 at 07:59:28PM +0300]
| [Alexey Dobriyan - Thu, Mar 26, 2009 at 07:34:44PM +0300]
| | On Thu, Mar 26, 2009 at 05:16:31PM +0100, Patrick McHardy wrote:
| | > Cyrill Gorcunov wrote:
| | >> Module specific data moved into per-net site and being allocated/freed
| | >> during net namespace creation/deletion. For this reason module_init/exit
| | >> calls added.
| | >
| | > This doesn't work. You can't have multiple module_init functions
| | > in one module and nf_connntrack_ivp4 already includes one.
| | 
| | I thought all sysctl code would be generic in sense it will be done
| | during L3 and L4 proto registration, so all those ifdefs will be in one
| | place and so on.
| | 
| 
| It's a really good idea but it requires some logic to be changed --
| for example I would need some kind of net-namespace sysctl hook
| so sysctl tables will be static and pinned to a particular source
| file and so on. Will think about. Thanks!
| 
|         Cyrill

One more problem is that several protocols share single net-namespace
functionality and I either should add ref counter to eliminate double
initialization. I was in idea to use kref for that (since it has
all memory barriers for that) but unfortunately it doesn't has kref_test
routine.

        Cyrill
