Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 217B6C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Jan 2021 16:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF7D864E0E
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Jan 2021 16:27:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhA3Q1b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Jan 2021 11:27:31 -0500
Received: from bmailout1.hostsharing.net ([83.223.95.100]:44735 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbhA3Q1L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Jan 2021 11:27:11 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id C1B82300371FF;
        Sat, 30 Jan 2021 17:26:29 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B71AA15646A; Sat, 30 Jan 2021 17:26:29 +0100 (CET)
Date:   Sat, 30 Jan 2021 17:26:29 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH nf-next v4 5/5] af_packet: Introduce egress hook
Message-ID: <20210130162629.GB1959@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
 <012e6863d0103d8dda1932d56427d1b5ba2b9619.1611304190.git.lukas@wunner.de>
 <CA+FuTSfuLfh3H45HnvtJPocxj+E7maGwzkgYsfktna2+cJi9zQ@mail.gmail.com>
 <20210124111432.GC1056@wunner.de>
 <CAF=yD-+BXKynYaYgg8n_R1gEtEbkRWm-8WdtrXOjdjyOj-unfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+BXKynYaYgg8n_R1gEtEbkRWm-8WdtrXOjdjyOj-unfg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jan 24, 2021 at 11:18:00AM -0500, Willem de Bruijn wrote:
> On Sun, Jan 24, 2021 at 6:14 AM Lukas Wunner <lukas@wunner.de> wrote:
> > On Fri, Jan 22, 2021 at 11:13:19AM -0500, Willem de Bruijn wrote:
> > > On Fri, Jan 22, 2021 at 4:44 AM Lukas Wunner <lukas@wunner.de> wrote:
> > > > Add egress hook for AF_PACKET sockets that have the PACKET_QDISC_BYPASS
> > > > socket option set to on, which allows packets to escape without being
> > > > filtered in the egress path.
> > > >
> > > > This patch only updates the AF_PACKET path, it does not update
> > > > dev_direct_xmit() so the XDP infrastructure has a chance to bypass
> > > > Netfilter.
> > >
> > > Isn't the point of PACKET_QDISC_BYPASS to skip steps like this?
> >
> > I suppose PACKET_QDISC_BYPASS "was introduced to bypass qdisc,
> > not to bypass everything."
> >
> > (The quote is taken from this message by Eric Dumazet:
> > https://lore.kernel.org/netfilter-devel/a9006cf7-f4ba-81b1-fca1-fd2e97939fdc@gmail.com/
> > )
> 
> I see. I don't understand the value of a short-cut fast path if we
> start chipping away at its characteristic feature.

The point is to filter traffic coming in through af_packet.
Exempting PACKET_QDISC_BYPASS from filtering would open up a
trivial security hole.

Thanks,

Lukas
