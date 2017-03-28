From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] extensions: libxt_TOS: Add translation to nft
Date: Tue, 28 Mar 2017 17:52:07 +0200
Message-ID: <20170328155207.GA18679@breakpoint.cc>
References: <1490715972-30517-1-git-send-email-gs051095@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gsoc2013@lists.netfilter.org, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Gargi Sharma <gs051095@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56774 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752053AbdC1Pwz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Mar 2017 11:52:55 -0400
Content-Disposition: inline
In-Reply-To: <1490715972-30517-1-git-send-email-gs051095@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gargi Sharma <gs051095@gmail.com> wrote:
> Add translation for TOS to nftables.
> 
> Examples:
> 
> $ iptables-translate -t mangle -A PREROUTING -p TCP --dport 22 -j TOS --set-tos 0x10
> nft add rule ip mangle PREROUTING tcp dport 22 counter --set-tos 0x10/0xff
> 
> $ iptables-translate -A PREROUTING -t mangle -p tcp --sport ftp-data -j TOS --set-tos 0x02/0x10
> nft add rule ip mangle PREROUTING tcp sport 20 counter --set-tos 0x02/0x10

You did not test this :-/

nft add rule ip mangle PREROUTING tcp sport 20 counter --set-tos 0x02/0x10
nft: unrecognized option '--set-tos'

besides, there is no TOS support in nftables.
Please look at xt_DSCP.c and the xlate function there.

You could rewrite -j TOS iptables rules to their corresponding dscp
eqivalent in some cases at least.
