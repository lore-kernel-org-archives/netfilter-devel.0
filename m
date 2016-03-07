From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libipt_icmp: Add translation to nft
Date: Mon, 7 Mar 2016 17:58:53 +0100
Message-ID: <20160307165853.GA29439@salvia>
References: <20160306222442.GA20945@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com,
	outreachy-kernel@googlegroups.com
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42122 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753319AbcCGQ65 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 11:58:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 34D114B101
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 17:58:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 27EFBDA391
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 17:58:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1A7DFDA384
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 17:58:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160306222442.GA20945@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 06, 2016 at 11:24:44PM +0100, Laura Garcia Liebana wrote:
> Add translation for icmp to nftables. Not supported types in nftables
> are: any, network-unreachable, host-unreachable, protocol-unreachable,
> port-unreachable, fragmentation-needed, source-route-failed,
> network-unknown, host-unknown, network-prohibited, host-prohibited,
> TOS-network-unreachable, TOS-host-unreachable, communication-prohibited,
> host-precedence-violation, precedence-cutoff, network-redirect,
> host-redirect, TOS-network-redirect, TOS-host-redirect,
> router-advertisement, router-solicitation, ttl-zero-during-transit,
> ttl-zero-during-reassembly, ip-header-bad and required-option-missing.

Oh I see, these are actually the non-supported icmp codes at this
moment, instead of the icmp types.

All icmp types should work, if any missing, we should add them. For
icmp codes, we need a fix for the listing side of nft.

Then, please return 0 when icmp codes are specified by now, document
this in the wiki and here in the description.

Thanks.
