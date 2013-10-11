From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-nftables nft: Removes if_nametoindex
 ,NFT_META_OIF for outiface
Date: Fri, 11 Oct 2013 10:15:25 +0200
Message-ID: <20131011081525.GA4127@localhost>
References: <CAEyr1FRKpudN76NbA-o0MAsMy8XpPFjBwviSy4xtWB46LcCekw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37904 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601Ab3JKIPa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:15:30 -0400
Content-Disposition: inline
In-Reply-To: <CAEyr1FRKpudN76NbA-o0MAsMy8XpPFjBwviSy4xtWB46LcCekw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 11, 2013 at 11:34:04AM +0530, Anand Raj Manickam wrote:
> This patch fixes the issue where , the Rules are added for non
> existent interface and unable to delete.
> eg xtables -t nat -I POSTROUTING -o eth10.10 -j MASQUERADE , allows
> you to add the rule , where eth10.10 interface is not created.
> But will not allow to delete as the label maps to * by  if_nametoindex().

This patch doesn't apply:

patch -p1 < /tmp/anand.patch
patching file iptables/nft-shared.c
patch: **** malformed patch at line 6: *iface, int invflags)

Please, no need to split things in that many chunks per file. One
single patch file to address one thing is just fine, the repository
has to remain in consistent state between patches.

Thanks.
