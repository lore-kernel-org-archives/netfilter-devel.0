Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCDAC35280
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 20:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 256BA2166E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 20:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgEAUaS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 16:30:18 -0400
Received: from correo.us.es ([193.147.175.20]:33702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgEAUaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 16:30:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D0B8518CDC0
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 22:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF3BA6D28C
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 22:30:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BD5412067E; Fri,  1 May 2020 22:30:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE6F1BAABF;
        Fri,  1 May 2020 22:30:13 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 01 May 2020 22:30:13 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9EEC54301DE0;
        Fri,  1 May 2020 22:30:13 +0200 (CEST)
Date:   Fri, 1 May 2020 22:30:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     michael-dev <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] datatype: fix double-free resulting in
 use-after-free in datatype_free
Message-ID: <20200501203013.GA29652@salvia>
References: <20200501154819.2984-1-michael-dev@fami-braun.de>
 <20200501154819.2984-3-michael-dev@fami-braun.de>
 <20200501192703.GC13722@salvia>
 <545922fa020689faa17dae656320fe58@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545922fa020689faa17dae656320fe58@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 01, 2020 at 09:59:35PM +0200, michael-dev wrote:
> Am 01.05.2020 21:27, schrieb Pablo Neira Ayuso:
> > On Fri, May 01, 2020 at 05:48:18PM +0200, Michael Braun wrote:
> > > +	if (dtype == expr->dtype)
> > > +		return; // do not free dtype before incrementing refcnt again
> > 
> > The problem you describe (use-after-free) happens in this case, right?
> 
> The problem is more likely due to concat_expr_parse_udata not calling
> datatype_get,
> because otherwise datatype_get would be in the backtrace of ASAN.
> 
> > 
> >         datatype_set(expr, expr->dtype);
> > 
> > Or am I missing anything?
> 
> But while debugging the above output, I added assert(dtype != expr->dtype)
> here
> and that crashed. So I'm sure something like this is happening.

Right.

# nft add rule ip x y ct state new,established,related,untracked
# nft list ruleset
nft: datatype.c:1086: datatype_set: Assertion `expr->dtype != dtype' failed.
Aborted

> And the whole thing was nasty to debug, so I added this one just be sure it
> does not happen again.
> 
> As ASAN should hit on datatype_get incrementing refcnt if datatype_free had
> actually freed it,
> assert was probaby not seeing an DTYPE_F_ALLOC instance.
> But I dig not deeper here, as I felt this return is safe to add.

I'm going to apply this. I think it's safe to turn this into noop.
