From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] More extensive error checking on base chain
Date: Thu, 14 Aug 2014 20:59:43 +0200
Message-ID: <20140814185943.GA11516@salvia>
References: <1407836244-30480-1-git-send-email-ycnian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Yanchuan Nian <ycnian@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47542 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbaHNS7W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:59:22 -0400
Content-Disposition: inline
In-Reply-To: <1407836244-30480-1-git-send-email-ycnian@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 12, 2014 at 05:37:24PM +0800, Yanchuan Nian wrote:
> The evaluation of base chain isn't extensive enough. It cannot
> detect whether a chain type is supported or not in certain families.
> It also cannot deletect whether a hook is supported or not in certain
> chains. The evaluation is done by kernel, and the information is unclear.
> 
> nft> add chain arp arptable chain1 {type nat hook input priority 0 ;}
> <cli>:1:1-64: Error: Could not add chain: No such file or directory
> add chain arp arptable chain1 {type nat hook input priority 0 ;}
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> nft> add chain ip iptable chain1 {type nat hook forward priority 0 ;}
> <cli>:1:1-64: Error: Could not add chain: Operation not supported
> add chain ip iptable chain1 {type nat hook forward priority 0 ;}
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> This patch performs more extensive error checking, so the information
> is more clear.
> 
> nft> add chain arp arptable chain1 {type nat hook input priority 0 ;}
> <cli>:1:31-63: Error: invalid type name nat
> add chain arp arptable chain1 {type nat hook input priority 0 ;}
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> nft> add chain ip iptable chain1 {type nat hook forward priority 0 ;}
> <cli>:1:29-63: Error: invalid hook name forward
> add chain ip iptable chain1 {type nat hook forward priority 0 ;}
>                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I don't think this belongs to userspace.  Patrick and I have been
discussing some extension for netlink to provide better error
reporting to userspace, such as the offset to the attribute that has
caused the problem. This should provide enough context to userspace to
display more accurate error reporting.

On top of that, this is not going to help to catch the chain type
module is missing case.

Meanwhile, I have documented this here:

http://wiki.nftables.org/wiki-nftables/index.php/Troubleshooting
