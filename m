Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D288BC5DF63
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 20:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA71217D7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 20:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfKFU0C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 15:26:02 -0500
Received: from correo.us.es ([193.147.175.20]:49382 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727721AbfKFU0C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 15:26:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 994582EFEA0
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 21:25:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AD6EDA72F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 21:25:57 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80700ADF4; Wed,  6 Nov 2019 21:25:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AB21DA72F;
        Wed,  6 Nov 2019 21:25:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 21:25:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 478C842EE38E;
        Wed,  6 Nov 2019 21:25:55 +0100 (CET)
Date:   Wed, 6 Nov 2019 21:25:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] doc: Drop incorrect requirement for nft configs
Message-ID: <20191106202557.wkde4zm4akcjas4j@salvia>
References: <20191105131439.31826-1-phil@nwl.cc>
 <20191106114724.mscqhcyttwm7ydos@salvia>
 <20191106141953.GR15063@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106141953.GR15063@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 06, 2019 at 03:19:53PM +0100, Phil Sutter wrote:
> On Wed, Nov 06, 2019 at 12:47:24PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Nov 05, 2019 at 02:14:39PM +0100, Phil Sutter wrote:
> > > The shebang is not needed in files to be used with --file parameter.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > 
> > Right, this is actually handled as a comment right now, not as an
> > indication of what binary the user would like to use.
> > 
> > It should be possible to implement the shebang for nft if you think
> > this is useful.
> 
> Well, it works already? If I make a config having the shebang
> executable, I can execute it directly. It's just not needed when passed
> to 'nft -f'. And in that use-case, I don't see a point in interpreting
> it, the user already chose which binary to use by calling it. :)

Indeed, forget this. Thanks.
