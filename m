From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_mh: Add translation to nft
Date: Tue, 19 Jan 2016 21:50:27 +0100
Message-ID: <20160119205027.GA26137@salvia>
References: <20160114174009.GA4252@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55109 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756816AbcASUuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jan 2016 15:50:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A51AD2791B3
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 21:50:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DD3CDA807
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 21:50:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47337DA795
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jan 2016 21:50:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160114174009.GA4252@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 14, 2016 at 11:10:09PM +0530, Shivani Bhardwaj wrote:
> Add translation for mobility header to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -A INPUT -p mh -j ACCEPT
> nft add rule ip6 filter INPUT ip6 nexthdr mobility-header counter accept
> 
> $ sudo ip6tables-translate -A INPUT -p mh --mh-type 1 -j ACCEPT
> nft add rule ip6 filter INPUT ip6 nexthdr mobility-header mh type 1 counter accept
> 
> $ sudo ip6tables-translate -A INPUT -p mh --mh-type 1:3 -j ACCEPT
> nft add rule ip6 filter INPUT ip6 nexthdr mobility-header mh type 1-3 counter accept

I think this translation will not work as the mobility header may not
be exactly the next header, in IPv6 you can get several extension
headers one after another.

By now I'd suggest:

... meta l4proto mobility-header mh type 1 counter

Anyway, the extension header expression needs some care, it would be
good to keep this documented in the wiki page.

While at this, it would be good if you can verify that our definition
in nftables matches rfc6275 (see nftables/src/exthdr.c), I already
detected wrong header definitions in the past.

It would be also good if you can go back to all your translations and
validate what we already got into the tree from the packet path, ie.
generate traffic that matches the rule in ip6tables and nftables. Note
sure if you made this checks.

Some of them should be easy to test, some other may take a while,
python scapy may help in some cases to forge and to inject a packet
with a specific layout.

Thanks.
