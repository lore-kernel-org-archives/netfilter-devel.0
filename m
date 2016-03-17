From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv7] extensions: libipt_icmp: Add translation to nft
Date: Thu, 17 Mar 2016 16:46:26 +0100
Message-ID: <20160317154626.GA10673@salvia>
References: <20160316220019.GA2952@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50333 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030505AbcCQPqe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 11:46:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E748313C0E7
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D9DD3DA8F8
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E317BDA391
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 16:46:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160316220019.GA2952@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 11:00:22PM +0100, Laura Garcia Liebana wrote:
> Add translation for icmp to nftables. Not supported icmp codes in nftables
> are: network-unreachable, host-unreachable, protocol-unreachable,
> port-unreachable, fragmentation-needed, source-route-failed,
> network-unknown, host-unknown, network-prohibited, host-prohibited,
> TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
> host-precedence-violation, precedence-cutoff, network-redirect,
> host-redirect, TOS-network-redirect, TOS-host-redirect,
> ttl-zero-during-transit, ttl-zero-during-reassembly, ip-header-bad and required-option-missing.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type echo-reply -j ACCEPT
> nft add rule ip filter INPUT icmp type echo-reply counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j ACCEPT
> nft add rule ip filter INPUT icmp type destination-unreachable counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m icmp ! --icmp-type 3 -j ACCEPT
> nft add rule ip filter INPUT icmp type != destination-unreachable counter accept

Applied, thanks Laura.
