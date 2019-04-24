Return-Path: <SRS0=Os8a=S2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D670FC10F11
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 14:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1283218FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Apr 2019 14:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfDXOGc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Apr 2019 10:06:32 -0400
Received: from mail.us.es ([193.147.175.20]:42982 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfDXOGc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Apr 2019 10:06:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E06B2190F67
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2019 16:06:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFE3FDA70B
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2019 16:06:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C594FDA701; Wed, 24 Apr 2019 16:06:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CDD4DA70B;
        Wed, 24 Apr 2019 16:06:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Apr 2019 16:06:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6EBEE4265A31;
        Wed, 24 Apr 2019 16:06:27 +0200 (CEST)
Date:   Wed, 24 Apr 2019 16:06:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] IPFIX output plugin
Message-ID: <20190424140627.i22ta4pfe344idjr@salvia>
References: <523542b5-d629-54d9-2a90-468a9cb3aba7@juaristi.eus>
 <20190408223030.g42guehdptu5lfxo@salvia>
 <ff9181aa-3027-f0a2-75a4-052a7792fc7c@juaristi.eus>
 <20190424140016.u66hritexbz4a6ha@salvia>
 <20190424140459.ixjqc3uj6voo254i@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190424140459.ixjqc3uj6voo254i@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 24, 2019 at 04:04:59PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 24, 2019 at 04:00:16PM +0200, Pablo Neira Ayuso wrote:
> > Hi Ander,
> > 
> > Please, don't top-post.
> > 
> > On Wed, Apr 24, 2019 at 03:39:02PM +0200, Ander Juaristi wrote:
> > > I'm following up on this. I'd say this is complete and I don't plan to
> > > introduce further significant changes. Maybe just small fixes. I attach two
> > > patches, tell me if you'd rather have them as a single patch.
> > 
> > Please, send them via git-send-mail.
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/list/
> 
> De esta manera, aparecerán aquí en patchwork :-)

Sorry about this.

I was telling Ander git-send-mail make patches show in patchwork.
Otherwise, they don't show there.

Thanks.
