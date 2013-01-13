From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables RFC PATCH 0/6] IPv6 Support
Date: Sun, 13 Jan 2013 20:23:53 +0100
Message-ID: <20130113192353.GB16399@1984>
References: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46195 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811Ab3AMTYF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2013 14:24:05 -0500
Content-Disposition: inline
In-Reply-To: <1357828179-18664-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Tomasz,

On Thu, Jan 10, 2013 at 04:29:33PM +0200, Tomasz Bursztyka wrote:
> Hi,
> 
> Here is an attempt to get iptables-nftables supporting IPv6.  I
> haven't tested it really, so I send it more as an RFC.
> 
> Starting from xtables.c which supports only IPv4, patch 2 combines
> the support for IPv6 in it.  The family attribute provided in patch
> 1 is set then used in nft.c to use it accordingly, in patch 3.
> 
> Patch 4 finalizes it in handling the right informations for rule
> manipulations depending on the family.
> 
> Patch 5 and 6 then adds the support of IPv6 when it comes to
> respectively save and print the firewall.

Good job.

I have merged the 6 patches into one single, they all belong to the
same scope.

I have also tested this, fixed a couple of issues (regarding deletion,
xtables-save/-restore, printing IPv6 destination via xtables -6 -L -n
and spot error if `-f' is used with xtables -6, probably something
else, I forgot, you can diff you initial patch and final result).

I have pushed this into the repository:

http://1984.lsi.us.es/git/iptables-nftables/commit/?id=453ece127f96f155146eff5c2a8b30574d08335d

It would be good if you can move all specific IPv4 and IPv6 code to
nft-ipv4.c and nft-ipv6.c files respectively.

You can use a structure with callbacks like:

struct xtables_family {
        int (*add)(...);
        void (*print)(...);
        void (*print_save)(...);
        int (*parse)(...);
        int (*is_same)(...);
}

By looking at the previous patch and searching for:

switch(h->family) {
        case AF_INET:
                ...
                break;
        case AF_INET6:
                ...
                break;
}

Should help to identify the code that needs to be moved to the
specific file.

That encapsulation will help to prepare bridging and arp support.

Thanks a lot!
