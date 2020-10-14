Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4B83C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 18:47:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 708D22222A
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 18:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgJNSrb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 14:47:31 -0400
Received: from correo.us.es ([193.147.175.20]:47784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgJNSra (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 14:47:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A68BA12BFF6
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 20:47:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9812DDA73D
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2020 20:47:28 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8DC1EDA730; Wed, 14 Oct 2020 20:47:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73BA3DA78E;
        Wed, 14 Oct 2020 20:47:26 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 20:47:26 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 539FA4301DE0;
        Wed, 14 Oct 2020 20:47:26 +0200 (CEST)
Date:   Wed, 14 Oct 2020 20:47:25 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: ingress inet support
Message-ID: <20201014184725.GA17701@salvia>
References: <20201013113857.12117-1-pablo@netfilter.org>
 <f790c9ca-a556-98d7-d371-e073cfbc10e5@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f790c9ca-a556-98d7-d371-e073cfbc10e5@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Wed, Oct 14, 2020 at 05:54:13PM +0200, Arturo Borrero Gonzalez wrote:
> On 2020-10-13 13:38, Pablo Neira Ayuso wrote:
> > Add support for inet ingress chains.
> > 
> >  table inet filter {
> >         chain ingress {
> >                 type filter hook ingress device "veth0" priority filter; policy accept;
> >         }
> > 	chain input {
> > 		type filter hook input priority filter; policy accept;
> > 	}
> > 	chain forward {
> > 		type filter hook forward priority filter; policy accept;
> > 	}
> >  }
> 
> This sound interesting, thanks.
> 
> I could see some questions coming from users:
> 
> * where are the docs on which packet/traffic sees this nft family vs netdev?
> * what are the added benefit of this nft family vs netdev?

See patch update for documentation, let me know if this addresses
these two questions. I can extend it further, let me know.

> * is the netdev family somehow deprecated?

I don't think so. The netdev family is still useful for filter packet
of any possible ethertype that are entering through a given device
(for instance ARP, 802.1q, 802.1ad among others). The only difference
between inet ingress and netdev ingress is that the sets and maps that
are defined in a given inet table can be accessed from the ingress
chain, note that it is not possible to access inet sets and maps from
the netdev ingress chain.

If your ruleset if focused on traffic filtering for IPv4 and IPv6,
then inet ingress should be enough.

The ingress netdev chain also comes with hardware offload support,
which allows you to drop packets from the NIC, which might be useful
in DoS scenarios to save CPU cycles. You only have to check if your
NIC is supported.
