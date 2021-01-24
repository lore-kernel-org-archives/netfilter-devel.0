Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54AB5C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ADEA227BF
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Jan 2021 10:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhAXKxr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Jan 2021 05:53:47 -0500
Received: from bmailout3.hostsharing.net ([176.9.242.62]:58339 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbhAXKxq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Jan 2021 05:53:46 -0500
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2021 05:53:45 EST
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 3351B100D9411;
        Sun, 24 Jan 2021 11:46:06 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 0273013BC08; Sun, 24 Jan 2021 11:46:05 +0100 (CET)
Date:   Sun, 24 Jan 2021 11:46:05 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 1/5] net: sched: Micro-optimize egress handling
Message-ID: <20210124104605.GB1056@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
 <a2a8af1622dff2bfd51d446aa8da2c1d2f6f543c.1611304190.git.lukas@wunner.de>
 <20210123192624.4cee3b7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210123192624.4cee3b7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 23, 2021 at 07:26:24PM -0800, Jakub Kicinski wrote:
> On Fri, 22 Jan 2021 09:47:01 +0100 Lukas Wunner wrote:
> > sch_handle_egress() returns either the skb or NULL to signal to its
> > caller __dev_queue_xmit() whether a packet should continue to be
> > processed.
> > 
> > The skb is always non-NULL, otherwise __dev_queue_xmit() would hit a
> > NULL pointer deref right at its top.
> > 
> > But the compiler doesn't know that.  So if sch_handle_egress() signals
> > success by returning the skb, the "if (!skb) goto out;" statement
> > results in a gratuitous NULL pointer check in the Assembler output.
> 
> Which exact compiler are we talking about it? Did you report this?
> As Eric pointed the compiler should be able to figure this out quite
> easily.

I tested with gcc 8, 9, 10.

No need to report as it's the expected behavior with
-fno-delete-null-pointer-checks, whose motivation appears
questionable though (per my preceding e-mail).

Thanks,

Lukas
