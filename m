Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B300EC76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CE88205C9
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbfGPLXU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:23:20 -0400
Received: from mail.us.es ([193.147.175.20]:45306 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733200AbfGPLXU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 07:23:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 55BCAE2C55
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:23:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 459F0FF6CC
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:23:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3AB10A6DA; Tue, 16 Jul 2019 13:23:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DCF1D91F4;
        Tue, 16 Jul 2019 13:23:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 13:23:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B66784265A2F;
        Tue, 16 Jul 2019 13:23:15 +0200 (CEST)
Date:   Tue, 16 Jul 2019 13:23:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Jakub Jankowski <shasta@toxcorp.com>
Subject: Re: [PATCH nf] netfilter: conntrack: always store window size
 un-scaled
Message-ID: <20190716112315.bjgnlc4gqc6yavwl@salvia>
References: <20190711222905.22000-1-fw@strlen.de>
 <alpine.DEB.2.20.1907121249380.27973@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1907121249380.27973@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 12, 2019 at 12:50:35PM +0200, Jozsef Kadlecsik wrote:
> On Fri, 12 Jul 2019, Florian Westphal wrote:
> 
> > Jakub Jankowski reported following oddity:
> > 
> > After 3 way handshake completes, timeout of new connection is set to
> > max_retrans (300s) instead of established (5 days).
> > 
> > shortened excerpt from pcap provided:
> > 25.070622 IP (flags [DF], proto TCP (6), length 52)
> > 10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
> > 26.070462 IP (flags [DF], proto TCP (6), length 48)
> > 10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
> > 27.070449 IP (flags [DF], proto TCP (6), length 40)
> > 10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0
> > 
> > Turns out the last_win is of u16 type, but we store the scaled value:
> > 512 << 8 (== 0x20000) becomes 0 window.
> > 
> > The Fixes tag is not correct, as the bug has existed forever, but
> > without that change all that this causes might cause is to mistake a
> > window update (to-nonzero-from-zero) for a retransmit.
> > 
> > Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
> > Reported-by: Jakub Jankowski <shasta@toxcorp.com>
> > Tested-by: Jakub Jankowski <shasta@toxcorp.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks for reviewing Jozsef.
