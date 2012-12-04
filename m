From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Tue, 4 Dec 2012 13:16:47 +0100
Message-ID: <20121204121647.GA30262@1984>
References: <1354472208-25759-1-git-send-email-jengelh@inai.de>
 <20121203131209.GA32300@1984>
 <alpine.LNX.2.01.1212031655050.15887@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39380 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab2LDMQ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2012 07:16:58 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212031655050.15887@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 03, 2012 at 04:58:11PM +0100, Jan Engelhardt wrote:
> On Monday 2012-12-03 14:12, Pablo Neira Ayuso wrote:
> 
> >On Sun, Dec 02, 2012 at 07:16:48PM +0100, Jan Engelhardt wrote:
> >> Link stage of libip6t_NETMAP failed since recently.
> >> 
> >>   CCLD     libip6t_NETMAP.so
> >> /usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../x86_64-suse-linux/bin/ld:
> >> cannot find -lip6tc
> >
> >Is this problem opensuse specific? Need some diagnosing information on
> >why that's happening.
> 
> This happens whenever you don't have /usr/lib(64)/libip6tc.so.
> 
> In openSUSE, iptables is split into the packages iptables, libiptc0, 
> libiptc-devel, libxtables9 and libxtables-devel, and libip6tc.so is a 
> -devel thing that is generally not installed on user's machines. (Hence 
> I spot this.) I think this should be similar in Debian.
> 
> Also, note that iptables itself is not installed while building iptables 
> itself (for obvious reasons) in most distribution build systems.

By this explanation, then I don't see why we need that -lip6tc in the
makefile.
