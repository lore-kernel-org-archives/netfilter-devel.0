Return-Path: <SRS0=e21D=3L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BBBC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 22:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E14662253D
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jan 2020 22:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgAVWuc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jan 2020 17:50:32 -0500
Received: from correo.us.es ([193.147.175.20]:48000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbgAVWuc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 17:50:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E5FC15C112
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 23:50:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 919C5DA70E
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jan 2020 23:50:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 86D20DA703; Wed, 22 Jan 2020 23:50:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 704F0DA70E;
        Wed, 22 Jan 2020 23:50:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 22 Jan 2020 23:50:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4EC8842EF9E0;
        Wed, 22 Jan 2020 23:50:28 +0100 (CET)
Date:   Wed, 22 Jan 2020 23:50:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2] netfilter: nf_tables: autoload modules from the
 abort path
Message-ID: <20200122225027.r7h622abigbvuh3t@salvia>
References: <20200122211706.150042-1-pablo@netfilter.org>
 <20200122222808.GR795@breakpoint.cc>
 <20200122224947.iucrwyxmsrtm7ppe@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122224947.iucrwyxmsrtm7ppe@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 22, 2020 at 11:49:47PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 22, 2020 at 11:28:08PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +	list_for_each_entry(req, &net->nft.module_list, list) {
> > > +		if (!strcmp(req->module, module_name) && req->done)
> > > +			return 0;
> > > +	}
> > 
> > If the module is already on this list, why does it need to be
> > added a second time?
> 
> The first time this finds no module on the list, then the module is
> added to the list and nft_request_module() returns -EAGAIN. This
> triggers abort path with autoload parameter set to true from
> nfnetlink, this sets the module done field to true.
> 
> Now, on the second path, it will find that this already tried to load

s/second path/second pass

> the module, so it does not add it again, nft_request_module() returns 0.
> Then, there is a look up to find the object that was missing. If
> module was successfully load, the object will be in place, otherwise
> -ENOENT is reported to userspace.
> 
> So the code above is just checking for the second pass after one abort
> with autoload parameter set on, not to read it again.
> 
> I can include this logic in the patch description in a v3.
> 
> > Other than that I like this idea as it avoids the entire "drop
> > transaction mutex while inside a transaction" mess.
> 
> request_module() and the transaction logic was not fitting well, after
> this there will be a well-defined location to do this.
> 
> I run the syzbot reproducer for 1 hour and no problems, not sure how
> much I have to run it more. I guess the more time the better.
> 
> Thanks.
