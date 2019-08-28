Return-Path: <SRS0=hqFW=WY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0FEC3A5A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AB272189D
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Aug 2019 08:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfH1ITs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Aug 2019 04:19:48 -0400
Received: from correo.us.es ([193.147.175.20]:38860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726454AbfH1ITs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Aug 2019 04:19:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7E7F5DA72F
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2019 10:19:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 119D79D626
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Aug 2019 10:19:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 053B9CF823; Wed, 28 Aug 2019 10:19:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08016B7FFB;
        Wed, 28 Aug 2019 10:19:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 28 Aug 2019 10:19:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DAEAA4265A5A;
        Wed, 28 Aug 2019 10:19:41 +0200 (CEST)
Date:   Wed, 28 Aug 2019 10:19:42 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     David Miller <davemdavemloft!net@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] netfilter: nf_tables: fib: Drop IPV6 packages if
 IPv6 is disabled on boot
Message-ID: <20190828081942.isdjcdvcqok2a6zz@salvia>
References: <20190827.141950.540994003351676048.davem@davemloft.net>
 <20190827215836.GA10942@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827215836.GA10942@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 27, 2019 at 11:58:36PM +0200, Florian Westphal wrote:
> David Miller <davemdavemloft!net> wrote:
> > From: Leonardo Bras <leonardo@linux.ibm.com>
> > Date: Tue, 27 Aug 2019 14:34:14 -0300
> > 
> > > I could reproduce this bug on a host ('ipv6.disable=1') starting a
> > > guest with a virtio-net interface with 'filterref' over a virtual
> > > bridge. It crashes the host during guest boot (just before login).
> > > 
> > > By that I could understand that a guest IPv6 network traffic
> > > (viavirtio-net) may cause this kernel panic.
> > 
> > Really this is bad and I suspected bridging to be involved somehow.
> 
> Thats a good point -- Leonardo, is the
> "net.bridge.bridge-nf-call-ip6tables" sysctl on?
> 
> As much as i'd like to send a patch to remove br_netfilter, I fear
> we can't even stop passing ipv6 packets up to netfilter if
> ipv6.disable=1 is set because users might be using ip6tables for
> bridged traffic.

If the br_netfilter module is in placed, then it's probably better to
perform this check from there.
