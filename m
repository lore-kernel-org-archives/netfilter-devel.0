Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6959C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 10:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3C2320830
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 10:30:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbfIMKaj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 06:30:39 -0400
Received: from correo.us.es ([193.147.175.20]:54292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbfIMKaj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 06:30:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 682B8103288
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 12:30:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5886AB7FFE
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 12:30:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E2AFB7FF9; Fri, 13 Sep 2019 12:30:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50DE321FE4;
        Fri, 13 Sep 2019 12:30:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 12:30:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2EAEF42EE39A;
        Fri, 13 Sep 2019 12:30:33 +0200 (CEST)
Date:   Fri, 13 Sep 2019 12:30:34 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v3 14/18] netfilter: move nf_conntrack code to
 linux/nf_conntrack_common.h.
Message-ID: <20190913103034.bcbfycuwyjbpsaxk@salvia>
References: <20190913081318.16071-1-jeremy@azazel.net>
 <20190913081318.16071-15-jeremy@azazel.net>
 <20190913092714.tu37kmch6d3e6ypl@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913092714.tu37kmch6d3e6ypl@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 13, 2019 at 11:27:14AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 13, 2019 at 09:13:14AM +0100, Jeremy Sowden wrote:
> > diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
> > index 88d4127df863..410809c669e1 100644
> > --- a/net/netfilter/nf_conntrack_standalone.c
> > +++ b/net/netfilter/nf_conntrack_standalone.c
> > @@ -1167,7 +1167,6 @@ static int __init nf_conntrack_standalone_init(void)
> >  	if (ret < 0)
> >  		goto out_start;
> >  
> > -	BUILD_BUG_ON(SKB_NFCT_PTRMASK != NFCT_PTRMASK);
> 
> Why do you need to remove this?

All good, this has been consolidated in this patch. So I'm replying
myself.
