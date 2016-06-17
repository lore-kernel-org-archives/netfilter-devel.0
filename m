From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: rfc: netfilter: Unhide FWINV macro arguments ?
Date: Fri, 17 Jun 2016 13:59:32 +0200
Message-ID: <20160617115932.GA5482@salvia>
References: <1466101259.19647.51.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60980 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbcFQL7i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 07:59:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5E2121B7F89
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:59:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 504469EBAC
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:59:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 405849EBA1
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:59:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466101259.19647.51.camel@perches.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 16, 2016 at 11:20:59AM -0700, Joe Perches wrote:
> There are several FWINV #defines with identical form
> that hide a specific structure variable and dereference
> it with a invflags member.

Right, this macro is obscure indeed.

> $ git grep "define FWINV"
> include/linux/netfilter_bridge/ebtables.h:#define FWINV(bool,invflg) ((bool) ^ !!(info->invflags & invflg))
> net/bridge/netfilter/ebtables.c:#define FWINV2(bool, invflg) ((bool) ^ !!(e->invflags & invflg))
> net/ipv4/netfilter/arp_tables.c:#define FWINV(bool, invflg) ((bool) ^ !!(arpinfo->invflags & (invflg)))
> net/ipv4/netfilter/ip_tables.c:#define FWINV(bool, invflg) ((bool) ^ !!(ipinfo->invflags & (invflg)))
> net/ipv6/netfilter/ip6_tables.c:#define FWINV(bool, invflg) ((bool) ^ !!(ip6info->invflags & (invflg)))
> net/netfilter/xt_tcpudp.c:#define FWINVTCP(bool, invflg) ((bool) ^ !!(tcpinfo->invflags & (invflg)))
> 
> It might make sense to use a new macro like:
> 
> #define INVFLAG(var, test, invflag)			\
> 	((test) ^ !!((var)->invflags & (invflag)))
> 
> and convert all the various FWINV style uses
> 
> $ git grep --name-only "\bFWINV"
> include/linux/netfilter_bridge/ebtables.h
> net/bridge/netfilter/ebt_802_3.c
> net/bridge/netfilter/ebt_arp.c
> net/bridge/netfilter/ebt_ip.c
> net/bridge/netfilter/ebt_ip6.c
> net/bridge/netfilter/ebt_stp.c
> net/bridge/netfilter/ebtables.c
> net/ipv4/netfilter/arp_tables.c
> net/ipv4/netfilter/ip_tables.c
> net/ipv6/netfilter/ip6_tables.c
> net/netfilter/xt_tcpudp.c
> 
> $ git grep "\bFWINV" | grep -v "#" | wc -l
> 65

I'll be taking a patch to sort out this. Thanks.
