Return-Path: <SRS0=/ozj=TY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB89C072B5
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 09:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3F3E217F9
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 May 2019 09:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390220AbfEXJVy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 May 2019 05:21:54 -0400
Received: from mail.us.es ([193.147.175.20]:36796 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389887AbfEXJVy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 May 2019 05:21:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0EFF8103247
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 11:21:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F175FDA709
        for <netfilter-devel@vger.kernel.org>; Fri, 24 May 2019 11:21:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F0DD8DA704; Fri, 24 May 2019 11:21:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA239DA706;
        Fri, 24 May 2019 11:21:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 24 May 2019 11:21:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C240C40705C5;
        Fri, 24 May 2019 11:21:48 +0200 (CEST)
Date:   Fri, 24 May 2019 11:21:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, phil@nwl.cc
Subject: Re: [PATCH nft v3 1/2] jump: Introduce chain_expr in jump and goto
 statements
Message-ID: <20190524092148.wagryvqpj3l64hge@salvia>
References: <20190516204559.28910-1-ffmancera@riseup.net>
 <20190521092837.vd3egt54lvdhynqi@salvia>
 <1ff8b9ea-ce19-301f-e683-790417a179a7@riseup.net>
 <6570754e-30ab-b24b-4f4d-507a6ac74edf@riseup.net>
 <5d9f68a9-a90f-37bf-8ee7-61b7d2ccb324@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5d9f68a9-a90f-37bf-8ee7-61b7d2ccb324@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 24, 2019 at 09:29:34AM +0200, Fernando Fernandez Mancera wrote:
> On 5/24/19 9:17 AM, Fernando Fernandez Mancera wrote:
> > Hi Pablo,
> > 
> > On 5/21/19 9:38 PM, Fernando Fernandez Mancera wrote:
> >> Hi Pablo,
> >>
> >> On 5/21/19 11:28 AM, Pablo Neira Ayuso wrote:
> >>> On Thu, May 16, 2019 at 10:45:58PM +0200, Fernando Fernandez Mancera wrote:
> >>>> Now we can introduce expressions as a chain in jump and goto statements. This
> >>>> is going to be used to support variables as a chain in the following patches.
> >>>
> >>> Something is wrong with json:
> >>>
> >>> json.c: In function ‘verdict_expr_json’:
> >>> json.c:683:11: warning: assignment from incompatible pointer type
> >>> [-Wincompatible-pointer-types]
> >>>      chain = expr->chain;
> >>>            ^
> >>> parser_json.c: In function ‘json_parse_verdict_expr’:
> >>> parser_json.c:1086:8: warning: passing argument 3 of
> >>> ‘verdict_expr_alloc’ from incompatible pointer type
> >>> [-Wincompatible-pointer-types]
> >>>         chain ? xstrdup(chain) : NULL);
> >>>         ^~~~~
> >>>
> >>> Most likely --enable-json missing there.
> >>>
> >>
> >> Sorry, I am going to fix that.
> >> [...]
> > 
> > I am compiling nftables with:
> > 
> > $ ./configure --enable-json
> > $ make
> > 
> > And I am not getting any error, am I missing something? Thanks! :-)
> > 
> 
> Fixed, the option is --with-json. Why isn't it "--enable-json" as other
> features?

Cc'ing Phil.

We can just update this to accept both, either --with-json or
--enable-json.
