Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D159AC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 11:50:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B2D2064A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 11:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfF1LuA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 07:50:00 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:54538 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726564AbfF1Lt6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 07:49:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgpO9-0002jS-39; Fri, 28 Jun 2019 13:49:57 +0200
Date:   Fri, 28 Jun 2019 13:49:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Valeri Sytnik <valeri.sytnik@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: if nfqnl_test utility (libnetfilter_queue) drops a packet the
 utility receives the packet again
Message-ID: <20190628114957.jf4n7d53ppp6mieh@breakpoint.cc>
References: <CAF1SjT56zfq9VeUwqwe+vVfB6wija76Ldpa_dhY96x_eo4JU5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1SjT56zfq9VeUwqwe+vVfB6wija76Ldpa_dhY96x_eo4JU5A@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Valeri Sytnik <valeri.sytnik@gmail.com> wrote:
> I apply NF_DROP (instead NF_ACCEPT) to some tcp packet which
> contains some specific string known to me (say, hhhhh)
> that packet comes back to the queue again but with different id.

Yes, TCP retransmits data that is not received by the peer.
