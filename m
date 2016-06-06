From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_frag: Add translation to nft
Date: Mon, 6 Jun 2016 13:35:30 +0200
Message-ID: <20160606113530.GA6995@salvia>
References: <20160602165756.GA21013@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54499 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbcFFLfn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2016 07:35:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 249481EFDC5
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:35:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 116F11BA111
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:35:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 713B71BA10E
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Jun 2016 13:35:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160602165756.GA21013@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 06:57:58PM +0200, Laura Garcia Liebana wrote:
> Add translation for frag to nftables. Not supported yet in nft: fraglen,
> fragfirst and fraglast.

You can provide translations for fragfirst and fraglast.

'--fragfirst' is actually frag-off 0.
and '--fraglast' is more-fragments 1.

Note that because there is no 1:1 mapping, it doesn't mean you can
translate things.

And regarding --fraglen, if you look at
iptables/extensions/libip6t_frag.c, you'll see:

        case O_FRAGLEN:
                /*
                 * As of Linux 3.0, the kernel does not check for
                 * fraglen at all.
                 */
                if (cb->invert)
                        fraginfo->invflags |= IP6T_FRAG_INV_LEN;
                fraginfo->flags |= IP6T_FRAG_LEN;
                break;

Then, browsing:

http://lxr.free-electrons.com/source/net/ipv6/netfilter/ip6t_frag.c

shows no references to IP6T_FRAG_LEN in the kernel, so this confirms
this option was already deprecated time ago and the comment in the
iptables source code is correct.

Please, respin and send a v2 including this useful information on the
commit message so we keep this in the record.
