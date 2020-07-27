Return-Path: <SRS0=nQ4N=BG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20CFEC433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 13:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 093722075A
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Jul 2020 13:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgG0NAg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Jul 2020 09:00:36 -0400
Received: from verein.lst.de ([213.95.11.211]:43383 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728141AbgG0NAf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Jul 2020 09:00:35 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8046868C4E; Mon, 27 Jul 2020 15:00:29 +0200 (CEST)
Date:   Mon, 27 Jul 2020 15:00:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 19/26] net/ipv6: switch ipv6_flowlabel_opt to sockptr_t
Message-ID: <20200727130029.GA26393@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200723060908.50081-20-hch@lst.de> <20200727121505.GA1804864@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727121505.GA1804864@shredder>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 27, 2020 at 03:15:05PM +0300, Ido Schimmel wrote:
> I see a regression with IPv6 flowlabel that I bisected to this patch.
> When passing '-F 0' to 'ping' the flow label should be random, yet it's
> the same every time after this patch.

Can you send a reproducer?

> 
> It seems that the pointer is never advanced after the call to
> sockptr_advance() because it is passed by value and not by reference.
> Even if you were to pass it by reference I think you would later need to
> call sockptr_decrease() or something similar. Otherwise it is very
> error-prone.
> 
> Maybe adding an offset to copy_to_sockptr() and copy_from_sockptr() is
> better?

We could do that, although I wouldn't add it to the existing functions
to avoid the churns and instead add copy_to_sockptr_offset or something
like that.
