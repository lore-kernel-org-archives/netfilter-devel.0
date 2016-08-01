From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/7] add payload set support for sub-byte sizes
Date: Mon, 1 Aug 2016 12:35:38 +0200
Message-ID: <20160801103538.GA2385@salvia>
References: <1469580196-2100-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58507 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbcHAKgm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 06:36:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1DFE01B7FA1
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 12:35:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F195100791
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 12:35:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0B371FAB50
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 12:35:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469580196-2100-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 27, 2016 at 02:43:09AM +0200, Florian Westphal wrote:
> This series adds support for setting ipv6 flowlabel and e.g.
> ecn/dscp header fields for ipv4 and ipv6 by adding the needed
> bitwise ops (and removing them during netlink decoding).

I'm hitting whitespace errors here:

        warning: 2 lines add whitespace errors

Please, amend these and other nitpicks and push these series, we can
later on refine them if needed.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
