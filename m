From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] extensions: libxt_addrtype: Add translation to
 nft
Date: Wed, 8 Mar 2017 10:50:36 +0100
Message-ID: <20170308095036.GA1662@salvia>
References: <20170308010614.13881-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbdCHJ7m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 04:59:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9F9FC1A20A6
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 10:50:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F353DA847
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 10:50:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03164DA7FA
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 10:50:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308010614.13881-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 02:06:14AM +0100, Phil Sutter wrote:
> Translate addrtype match into fib expression:
> 
> $ iptables-translate -A INPUT -m addrtype --src-type LOCAL
> nft add rule ip filter INPUT fib saddr type local counter
> 
> $ iptables-translate -A INPUT -m addrtype --dst-type LOCAL
> nft add rule ip filter INPUT fib daddr type local counter
> 
> $ iptables-translate -A INPUT -m addrtype ! --dst-type ANYCAST,LOCAL
> nft add rule ip filter INPUT fib daddr type != { local, anycast } counter
> 
> $ iptables-translate -A INPUT -m addrtype --limit-iface-in --dst-type ANYCAST,LOCAL
> nft add rule ip filter INPUT fib daddr . iif type { local, anycast } counter

Applied, thanks Phil.
