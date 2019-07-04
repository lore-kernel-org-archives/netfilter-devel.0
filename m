Return-Path: <SRS0=ip/f=VB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA86CC0651F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 18:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 831B62189E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Jul 2019 18:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfGDSFr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Jul 2019 14:05:47 -0400
Received: from mail.us.es ([193.147.175.20]:43114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfGDSFq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Jul 2019 14:05:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27010FC5F0
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2019 20:05:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18B7CFB37C
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2019 20:05:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0E3F4D1929; Thu,  4 Jul 2019 20:05:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18246DA732;
        Thu,  4 Jul 2019 20:05:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 04 Jul 2019 20:05:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EC64A4265A31;
        Thu,  4 Jul 2019 20:05:40 +0200 (CEST)
Date:   Thu, 4 Jul 2019 20:05:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables v4] exthdr: doc: add support for matching IPv4
 options
Message-ID: <20190704180540.sjewig7v5lmpgmbp@salvia>
References: <20190704003052.469-1-ssuryaextr@gmail.com>
 <20190704165346.GA1628@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704165346.GA1628@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 04, 2019 at 06:53:46PM +0200, Phil Sutter wrote:
> Pablo,
> 
> On Wed, Jul 03, 2019 at 08:30:52PM -0400, Stephen Suryaputra wrote:
> > Add capability to have rules matching IPv4 options. This is developed
> > mainly to support dropping of IP packets with loose and/or strict source
> > route route options.
> 
> The applied version of this commit
> (226a0e072d5c1edeb53cb61b959b011168c5c29a) lacks include/ipopt.h. Does
> that linger in your clone somewhere? :)

My fault. Patch was not applying cleanly on top of git HEAD (probably
Stephen was a bit behind in his local tree).

I forced it a bit to apply and fix the rejected chunk, but I left
behind the header file.
