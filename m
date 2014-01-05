From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 0/6] netfilter: nf_tables: add mixed IPv4/IPv6 table
 support
Date: Sun, 5 Jan 2014 21:39:25 +0100
Message-ID: <20140105203925.GA4064@localhost>
References: <1388751378-23272-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50799 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752034AbaAEUjb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 15:39:31 -0500
Content-Disposition: inline
In-Reply-To: <1388751378-23272-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick!

On Fri, Jan 03, 2014 at 12:16:12PM +0000, Patrick McHardy wrote:
> The following patches add support for mixed IPv4/IPv6 tables to nftables.
> 
> The first patch fixes the chain type override logic so chain types override
> the AF defaults instead of the other way around. The second patch adds a
> pointer to the nf_hook_ops struct to nft_pktinfo for a later patch which
> uses ops->pf to match the actual AF of the packet instead of the dummy
> NFPROTO_INET value. The third patch changes the chain and hook registration
> logic to support multiple hook registrations. The nf_tables AF modules can
> provide a callback function to override defaults. The fourth patch finally
> adds a new "inet" family, which basically only initializes the hook
> functions to the IPv4 and IPv6 specific ones and registers a dummy filter
> chain type for NFPROTO_INET. Patches 5 and 6 add support for matching on
> the netfilter hook family and the L4 protocol number to the meta match.
> 
> With all this in place, we can create AF-specific rules and AF-independant
> rules that only match on the L4 protocol header and above in the inet table:
> 
> table inet filter {
>         chain input {
>                  type filter hook input priority 0;
>         }
> 
> 	chain forward {
>                  type filter hook forward priority 0;
>         }
> 
> 	chain output {
>                  type filter hook output priority 0;
>                  ip protocol tcp tcp dport 1234 counter packets 2 bytes 120
>                  ip6 nexthdr tcp tcp dport 1234 counter packets 2 bytes 160
>                  tcp dport 1234 counter packets 4 bytes 280
> 	}
> }
> 
> Userspace needs a bit of polishing but will most likely follow in a few
> hours.
> 
> Comments welcome.

This patchset looks pretty good, I think there is some clashing with
recent Arturo's work to set meta information, please see this patch.

http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git/commit/?id=e035b77ac7be430a5fef8c9c23f60b6b50ec81c5

But that I can manually resolve that.

We'll also need route and mangle chains for the new inet family type,
but that's also easy to add.

Let me know if I can give you a hand with the userspace patch, you can
post a tentative RFC before polishing if you like.

Thanks!
