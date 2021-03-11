Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 657BEC433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3329064F8E
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 21:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKVpg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Mar 2021 16:45:36 -0500
Received: from correo.us.es ([193.147.175.20]:47624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230372AbhCKVpS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Mar 2021 16:45:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6AFCBDA38E
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 22:45:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 557EDDA78F
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 22:45:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4AB1ADA78B; Thu, 11 Mar 2021 22:45:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F27F0DA730;
        Thu, 11 Mar 2021 22:45:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 22:45:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D355442DF560;
        Thu, 11 Mar 2021 22:45:05 +0100 (CET)
Date:   Thu, 11 Mar 2021 22:45:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 00/23] netfilter: flowtable enhancements
Message-ID: <20210311214505.GA5251@salvia>
References: <20210311003604.22199-1-pablo@netfilter.org>
 <20210311124705.0af44b8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210311124705.0af44b8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 11, 2021 at 12:47:05PM -0800, Jakub Kicinski wrote:
> On Thu, 11 Mar 2021 01:35:41 +0100 Pablo Neira Ayuso wrote:
> > The following patchset augments the Netfilter flowtable fastpath to
> > support for network topologies that combine IP forwarding, bridge,
> > classic VLAN devices, bridge VLAN filtering, DSA and PPPoE. This
> > includes support for the flowtable software and hardware datapaths.
> > 
> > The following pictures provides an example scenario:
> > 
> >                         fast path!
> >                 .------------------------.
> >                /                          \
> >                |           IP forwarding  |
> >                |          /             \ \/
> >                |       br0               wan ..... eth0
> >                .       / \                         host C
> >                -> veth1  veth2  
> >                    .           switch/router
> >                    .
> >                    .
> >                  eth0
> > 		host A
> > 
> > The bridge master device 'br0' has an IP address and a DHCP server is
> > also assumed to be running to provide connectivity to host A which
> > reaches the Internet through 'br0' as default gateway. Then, packet
> > enters the IP forwarding path and Netfilter is used to NAT the packets
> > before they leave through the wan device.
> > 
> > The general idea is to accelerate forwarding by building a fast path
> > that takes packets from the ingress path of the bridge port and place
> > them in the egress path of the wan device (and vice versa). Hence,
> > skipping the classic bridge and IP stack paths.
> 
> And how did you solve the invalidation problem?

The flowtable fast datapath is entirely optional, users turn it on via
ruleset. Users also have full control on what flows are added to the
flowtable datapath and _when_ those flows are added to the flowtable
datapath, *it's highly configurable*. The main concern about the
previous caches that have were removed from the kernel (such as the
routing table cache) are that:

1) Those mechanisms were enabled by default.
2) Configurability was completely lacking, you can just enable/disable
   the cache.

If a user consider that the invalidation problem is a real concern,
then they can just opt out from adopting the flowtable solution by
now. Cache invalidation is not a requirement in the scenarios where
this is planned to be deployed at this stage.

I can extend the documentation to describe the invalidation problem in
a follow up patch and to explicit state that this is not addressed at
this stage.
