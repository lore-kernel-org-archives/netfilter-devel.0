Return-Path: <SRS0=bANH=AA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE91C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 15:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C5F21582
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 15:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404037AbgFSPPk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jun 2020 11:15:40 -0400
Received: from correo.us.es ([193.147.175.20]:54130 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392429AbgFSPPi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jun 2020 11:15:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E34266D8C5
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2020 17:15:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4EE0DA73D
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2020 17:15:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA887DA3A1; Fri, 19 Jun 2020 17:15:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B7F8DA73D;
        Fri, 19 Jun 2020 17:15:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jun 2020 17:15:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3DF6842EE38E;
        Fri, 19 Jun 2020 17:15:31 +0200 (CEST)
Date:   Fri, 19 Jun 2020 17:15:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eugene Crosser <crosser@average.org>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: ebtables: load-on-demand extensions
Message-ID: <20200619151530.GA3894@salvia>
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org>
 <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr>
 <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
 <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
 <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874fd8a8-dfd2-f6c3-ae01-61884ca9bcff@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 19, 2020 at 03:45:57PM +0200, Eugene Crosser wrote:
> On 6/16/20 6:33 PM, Jan Engelhardt wrote:
>
> >>> Why not make a patch to publicly expose the skb's data via nft_meta?
> >>> No more custom modules, no more userspace modifications [..]
> >>
> >> For our particular use case, we are running the skb through the kernel
> >> function `skb_validate_network_len()` with custom mtu size [..]
> >
> > I find no such function in the current or past kernels. Perhaps you could post
> > the code of the module(s) you already have, and we can assess if it, or the
> > upstream ideals, can be massaged to make the code stick.
>
> I really really don't see our module being useful for anyone else! Even
> for us, it's just a stopgap measure, hopefully to be dropped after a few
> months. That said, I believe that the company will have no objections
> against publishing it. I've uploaded initial (untested) code on github
> here https://github.com/crosser/ebt-pmtud, in case anyone is interested.

I think there is a way to achieve this with nft 0.9.6 ?

commit 2a20b5bdbde8a1b510f75b1522772b07e51a77d7
Author: Michael Braun <...>
Date:   Wed May 6 11:46:23 2020 +0200

    datatype: add frag-needed (ipv4) to reject options

    This enables to send icmp frag-needed messages using reject target.

    I have a bridge with connects an gretap tunnel with some ethernet lan.
    On the gretap device I use ignore-df to avoid packets being lost without
    icmp reject to the sender of the bridged packet.

    Still I want to avoid packet fragmentation with the gretap packets.
    So I though about adding an nftables rule like this:

    nft insert rule bridge filter FORWARD \
      ip protocol tcp \
      ip length > 1400 \
      ip frag-off & 0x4000 != 0 \
      reject with icmp type frag-needed

    This would reject all tcp packets with ip dont-fragment bit set that are
    bigger than some threshold (here 1400 bytes). The sender would then receive
    ICMP unreachable - fragmentation needed and reduce its packet size (as
    defined with PMTU).
