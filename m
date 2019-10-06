Return-Path: <SRS0=ECQ/=X7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04C74C10F14
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 10:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7C2E2087E
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Oct 2019 10:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfJFKiV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Oct 2019 06:38:21 -0400
Received: from correo.us.es ([193.147.175.20]:59770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbfJFKiV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Oct 2019 06:38:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0189FC366
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 12:38:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2D7EDA4CA
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 12:38:16 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 98713DA8E8; Sun,  6 Oct 2019 12:38:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95AC2DA801
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 12:38:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 06 Oct 2019 12:38:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 74040426CCBA
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Oct 2019 12:38:14 +0200 (CEST)
Date:   Sun, 6 Oct 2019 12:38:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue] BUG: src: Update UDP header length
 field after mangling
Message-ID: <20191006103816.ev5o22kmwcizm5bh@salvia>
References: <20190927125645.7869-1-duncan_roe@optusnet.com.au>
 <20191005230226.GA6119@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191005230226.GA6119@dimstar.local.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 06, 2019 at 10:02:26AM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Fri, Sep 27, 2019 at 10:56:45PM +1000, Duncan Roe wrote:
> > One would expect nfq_udp_mangle_ipv4() to take care of the length field in
> > the UDP header but it did not.
> > With this patch, it does.
> > This patch is very unlikely to adversely affect any existing userspace
> > software (that did its own length adjustment),
> > because UDP checksumming was broken
> > ---
> >  src/extra/udp.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/src/extra/udp.c b/src/extra/udp.c
> > index 8c44a66..6836230 100644
> > --- a/src/extra/udp.c
> > +++ b/src/extra/udp.c
> > @@ -140,6 +140,8 @@ nfq_udp_mangle_ipv4(struct pkt_buff *pkt,
> >  	iph = (struct iphdr *)pkt->network_header;
> >  	udph = (struct udphdr *)(pkt->network_header + iph->ihl*4);
> >
> > +	udph->len = htons(ntohs(udph->len) + rep_len - match_len);
> > +
> >  	if (!nfq_ip_mangle(pkt, iph->ihl*4 + sizeof(struct udphdr),
> >  				match_offset, match_len, rep_buffer, rep_len))
> >  		return 0;
> > --
> > 2.14.5
> >
> Please consider applying this fix. I have other patches banking up behind it.

Applied, thanks.
