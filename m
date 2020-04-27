Return-Path: <SRS0=9gIA=6L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ADF0C83001
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:44:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 471CC2072A
	for <netfilter-devel@archiver.kernel.org>; Mon, 27 Apr 2020 23:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgD0XoL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 27 Apr 2020 19:44:11 -0400
Received: from correo.us.es ([193.147.175.20]:53862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgD0XoK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Apr 2020 19:44:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43530E122F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:44:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 303C6BAAB4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 01:44:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 259F9BAAA3; Tue, 28 Apr 2020 01:44:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F160D53899;
        Tue, 28 Apr 2020 01:44:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Apr 2020 01:44:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BA77B42EF9E2;
        Tue, 28 Apr 2020 01:44:06 +0200 (CEST)
Date:   Tue, 28 Apr 2020 01:44:06 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Laura Garcia <nevola@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
Message-ID: <20200427234406.GA22616@salvia>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
 <20200313145526.ikovaalfuy7rnkdl@salvia>
 <1bd50836-33c4-da44-5771-654bfb0348cc@iogearbox.net>
 <20200315132836.cj36ape6rpw33iqb@salvia>
 <CAF90-WgoteQXB9WQmeT1eOHA3GpPbwPCEvNzwKkN20WqpdHW-A@mail.gmail.com>
 <20200423160542.d3f6yef4av2gqvur@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423160542.d3f6yef4av2gqvur@wunner.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lukas,

On Thu, Apr 23, 2020 at 06:05:42PM +0200, Lukas Wunner wrote:
[...]
> Daniel submitted a revert of this series but didn't cc me:
> 
> https://lore.kernel.org/netdev/bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net/
> 
> In the ensuing discussion it turned out that the performance argument
> may be addressed by a rearrangement of sch_handle_egress() and
> nf_egress() invocations.  I could look into amending the series
> accordingly and resubmitting, though I'm currently swamped with
> other work.
> 
> The question is whether that's going to be sufficient because Daniel
> mentioned having an in-tree user as a prerequisite for accepting this
> feature, to which Pablo responded with NAT64/NAT46.  I don't have
> intentions of implementing those, but maybe someone else has.

I'd love to work on integrating that feature, there are a few
implementations outthere that might be useful for this.

However, I'm terribly biased, I'm the Netfilter maintainer.

Even though, I really think this hook is going to be very useful for
the Linux community from day one.
