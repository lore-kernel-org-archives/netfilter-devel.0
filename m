From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libxt_dscp: Add translation to nft
Date: Tue, 7 Jun 2016 00:43:33 +0200
Message-ID: <20160606224333.GA2936@salvia>
References: <20160606185101.GA1408@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51177 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbcFFWnj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 18:43:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 16080CD6F0F
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:43:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 070FE9EBA9
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:43:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 001679EBA9
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 00:43:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160606185101.GA1408@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 06, 2016 at 08:51:04PM +0200, Laura Garcia Liebana wrote:
> Add translation for dscp to nftables, for both ipv4 and ipv6.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m dscp --dscp 0x32 -j ACCEPT
> nft add rule ip filter INPUT ip dscp 0x32 counter accept
> 
> $ sudo ip6tables-translate -t filter -A INPUT -m dscp ! --dscp 0x32 -j ACCEPT
> nft add rule ip6 filter INPUT ip6 dscp != 0x32 counter accept

Applied, thanks.
