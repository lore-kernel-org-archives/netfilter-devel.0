From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Tue, 01 Feb 2011 15:31:37 +0100
Message-ID: <4D481949.4040709@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43296 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1BAObj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:31:39 -0500
In-Reply-To: <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> The patch adds the IP set core support to the kernel.
> 
> The IP set core implements a netlink (nfnetlink) based protocol by which
> one can create, destroy, flush, rename, swap, list, save, restore sets,
> and add, delete, test elements from userspace. For simplicity (and backward
> compatibilty and for not to force ip(6)tables to be linked with a netlink
> library) reasons a small getsockopt-based protocol is also kept in order
> to communicate with the ip(6)tables match and target.
> 
> The netlink protocol passes all u16, etc values in network order with
> NLA_F_NET_BYTEORDER flag. The protocol enforces the proper use of the
> NLA_F_NESTED and NLA_F_NET_BYTEORDER flags.
> 
> For other kernel subsystems (netfilter match and target) the API contains
> the functions to add, delete and test elements in sets and the required calls
> to get/put refereces to the sets before those operations can be performed.
> 
> The set types (which are implemented in independent modules) are stored
> in a simple RCU protected list. A set type may have variants: for example
> without timeout or with timeout support, for IPv4 or for IPv6. The sets
> (i.e. the pointers to the sets) are stored in an array. The sets are
> identified by their index in the array, which makes possible easy and
> fast swapping of sets. The array is protected indirectly by the nfnl
> mutex from nfnetlink. The content of the sets are protected by the rwlock
> of the set.
> 
> There are functional differences between the add/del/test functions
> for the kernel and userspace:
> 
> - kernel add/del/test: works on the current packet (i.e. one element)
> - kernel test: may trigger an "add" operation  in order to fill
>   out unspecified parts of the element from the packet (like MAC address)
> - userspace add/del: works on the netlink message and thus possibly
>   on multiple elements from the IPSET_ATTR_ADT container attribute.
> - userspace add: may trigger resizing of a set
> 

Applied, thanks Jozsef.
