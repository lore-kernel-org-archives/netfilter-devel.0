Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10132C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 17:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiK3Rxs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 12:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiK3Rxr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 12:53:47 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 711334730A
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 09:53:46 -0800 (PST)
Date:   Wed, 30 Nov 2022 18:53:43 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <eric@garver.life>
Subject: Re: [PATCH v2 nf] netfilter: conntrack: set icmpv6 redirects as
 RELATED
Message-ID: <Y4eYpwY8Wbfh8DkI@salvia>
References: <20221123121639.27624-1-fw@strlen.de>
 <Y4eTQg9Fk+9KDizU@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4eTQg9Fk+9KDizU@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 30, 2022 at 06:30:42PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 23, 2022 at 01:16:39PM +0100, Florian Westphal wrote:
> > icmp conntrack will set icmp redirects as RELATED, but icmpv6 will not
> > do this.
> > 
> > For icmpv6, only icmp errors (code <= 128) are examined for RELATED state.
> > ICMPV6 Redirects are part of neighbour discovery mechanism, those are
> > handled by marking a selected subset (e.g.  neighbour solicitations) as
> > UNTRACKED, but not REDIRECT -- they will thus be flagged as INVALID.
> > 
> > Add minimal support for REDIRECTs.  No parsing of neighbour options is
> > added for simplicity, so this will only check that we have the embeeded
> > original header (ND_OPT_REDIRECT_HDR), and then attempt to do a flow
> > lookup for this tuple.
> > 
> > Also extend the existing test case to cover redirects.
> 
> Applied to nf-next, thanks.

Florian, I am hitting this here:

net/netfilter/nf_conntrack_proto_icmpv6.c: In function ‘nf_conntrack_icmpv6_redirect’:
net/netfilter/nf_conntrack_proto_icmpv6.c:179:56: error: incompatible type for argument 6 of ‘nf_conntrack_inet_error’
  179 |                                        IPPROTO_ICMPV6, outer_daddr);
      |                                                        ^~~~~~~~~~~
      |                                                        |
      |                                                        union nf_inet_addr
In file included from net/netfilter/nf_conntrack_proto_icmpv6.c:21:
./include/net/netfilter/nf_conntrack_l4proto.h:83:49: note: expected ‘union nf_inet_addr *’ but argument is of type ‘union nf_inet_addr’
   83 |                             union nf_inet_addr *outer_daddr);
      |                             ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
net/netfilter/nf_conntrack_proto_icmpv6.c:180:1: error: control reaches end of non-void function [-Werror=return-type]
  180 | }
      | ^

