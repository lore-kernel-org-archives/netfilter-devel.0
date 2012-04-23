From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 next] netfilter: bridge: optionally set indev to vlan
Date: Tue, 24 Apr 2012 01:29:22 +0200
Message-ID: <20120423232922.GA8015@1984>
References: <1334047336-31143-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49925 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733Ab2DWX32 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:29:28 -0400
Content-Disposition: inline
In-Reply-To: <1334047336-31143-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 10, 2012 at 10:42:16AM +0200, Florian Westphal wrote:
> if net.bridge.bridge-nf-filter-vlan-tagged sysctl is enabled, bridge
> netfilter removes the vlan header temporarily and then feeds the packet
> to ip(6)tables.
> 
> When the new "bridge-nf-pass-vlan-input-device" sysctl is on
> (default off), then bridge netfilter will also set the
> in-interface to the vlan interface; if such an interface exists.
> 
> This is needed to make iptables REDIRECT target work with
> "vlan-on-top-of-bridge" setups and to allow use of "iptables -i" to
> match the vlan device name.
> 
> Also update Documentation with current brnf default settings.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Finally applied, thanks Florian.
