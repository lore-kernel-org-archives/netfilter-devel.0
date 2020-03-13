Return-Path: <SRS0=Dam8=46=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDDDCC4CECE
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Mar 2020 14:55:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0384206FA
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Mar 2020 14:55:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgCMOzb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:55:31 -0400
Received: from correo.us.es ([193.147.175.20]:43378 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgCMOza (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Mar 2020 10:55:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9C6AC2B1A
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2020 15:55:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA39AFC5E7
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2020 15:55:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CFBEAFC5E3; Fri, 13 Mar 2020 15:55:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6BA8DA736;
        Fri, 13 Mar 2020 15:55:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Mar 2020 15:55:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8DAC64251480;
        Fri, 13 Mar 2020 15:55:02 +0100 (CET)
Date:   Fri, 13 Mar 2020 15:55:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
Message-ID: <20200313145526.ikovaalfuy7rnkdl@salvia>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 11, 2020 at 03:05:16PM +0100, Daniel Borkmann wrote:
> On 3/11/20 12:59 PM, Lukas Wunner wrote:
> > Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> > handle_ing() under unique static key") introduced the ability to
> > classify packets on ingress.
> > 
> > Allow the same on egress.  Position the hook immediately before a packet
> > is handed to tc and then sent out on an interface, thereby mirroring the
> > ingress order.  This order allows marking packets in the netfilter
> > egress hook and subsequently using the mark in tc.  Another benefit of
> > this order is consistency with a lot of existing documentation which
> > says that egress tc is performed after netfilter hooks.
> > 
> > Egress hooks already exist for the most common protocols, such as
> > NF_INET_LOCAL_OUT or NF_ARP_OUT, and those are to be preferred because
> > they are executed earlier during packet processing.  However for more
> > exotic protocols, there is currently no provision to apply netfilter on
> > egress.  A common workaround is to enslave the interface to a bridge and
> 
> Sorry for late reply, but still NAK.

I agree Lukas use-case is very specific.

However, this is useful.

We have plans to support for NAT64 and NAT46, this is the right spot
to do this mangling. There is already support for the tunneling
infrastructure in netfilter from ingress, this spot from egress will
allow us to perform the tunneling from here. There is also no way to
drop traffic generated by dhclient, this also allow for filtering such
locally generated traffic. And many more.

Performance impact is negligible, Lukas already provided what you
asked for.

And more importantly:

I really think this patchset is _not_ interfering in your goals at all.
