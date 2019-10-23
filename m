Return-Path: <SRS0=QRwA=YQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1193CA9EB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 10:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9AF205ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Oct 2019 10:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403860AbfJWKR2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Oct 2019 06:17:28 -0400
Received: from correo.us.es ([193.147.175.20]:38588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390361AbfJWKR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Oct 2019 06:17:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4EF72ED5DE
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 12:17:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20B031B3277
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Oct 2019 12:17:23 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 03700A7DD2; Wed, 23 Oct 2019 12:17:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5B62DA7DCA;
        Wed, 23 Oct 2019 12:16:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 23 Oct 2019 12:16:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2831841E4801;
        Wed, 23 Oct 2019 12:16:56 +0200 (CEST)
Date:   Wed, 23 Oct 2019 12:16:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next,RFC 0/2] nf_tables encapsulation/decapsulation
 support
Message-ID: <20191023101658.onmzadkop7vqfrgj@salvia>
References: <20191022154733.8789-1-pablo@netfilter.org>
 <10ad5a64-f9cb-0ee6-2daa-5b88884fd224@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10ad5a64-f9cb-0ee6-2daa-5b88884fd224@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 23, 2019 at 11:49:57AM +0800, wenxu wrote:
> 
> On 10/22/2019 11:47 PM, Pablo Neira Ayuso wrote:
> > Hi,
> >
> > This is a RFC patchset, untested, to introduce new infrastructure to
> > specify protocol decapsulation and encapsulation actions. This patchset
> > comes with initial support for VLAN, eg.
> >
> > 1) VLAN decapsulation:
> >
> > 	... meta iif . vlan id { eth0 . 10, eth1 . 11} decap vlan
> >
> > The decapsulation is a single statement with no extra options.
> 
> Currently there is no vlan meta match expr.  So it is better to
> extend the meta expr or add new ntf_vlan_get_expr?

There's nft_payload to get the vlan information.

> > 2) VLAN encapsulation:
> >
> > 	add vlan "network0" { type push; id 100; proto 0x8100; }
> >         add vlan "network1" { type update; id 101; }
> > 	... encap vlan set ip daddr map { 192.168.0.0/24 : "network0",
> > 					  192.168.1.0/24 : "network1" }
> >
> > The idea is that the user specifies the vlan policy through object
> > definition, eg. "network0" and "network1", then it applies this policy
> > via the "encap vlan set" statement.
> >
> > This infrastructure should allow for more encapsulation protocols
> > with little work, eg. MPLS.
> 
> So the tunnel already exist in nft_tunnel also can add in this encapsulation protocols
> as ip.
> 
> like ip-route
> 
> encap ip id 100 dst 10.0.0.1?

Not sure what you mean, please, extend your coment.
