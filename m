Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E28C47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8BAA206CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 19:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgEET11 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 15:27:27 -0400
Received: from correo.us.es ([193.147.175.20]:60524 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgEET11 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 15:27:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 004674DE733
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:27:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E896CDA7B2
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 21:27:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DE5962132B; Tue,  5 May 2020 21:27:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0200F2135D;
        Tue,  5 May 2020 21:27:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 21:27:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D9DA042EE38E;
        Tue,  5 May 2020 21:27:23 +0200 (CEST)
Date:   Tue, 5 May 2020 21:27:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     michael-dev <michael-dev@fami-braun.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] rule: fix out of memory write if num_stmts is too low
Message-ID: <20200505192723.GA30019@salvia>
References: <20200504204858.15009-1-michael-dev@fami-braun.de>
 <20200505121756.GA8781@salvia>
 <284c0e0cba6ddfa50872e7250d8b35c7@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <284c0e0cba6ddfa50872e7250d8b35c7@fami-braun.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 05, 2020 at 03:22:07PM +0200, michael-dev wrote:
> Am 05.05.2020 14:17, schrieb Pablo Neira Ayuso:
> > On Mon, May 04, 2020 at 10:48:58PM +0200, Michael Braun wrote:
> > > Running bridge/vlan.t with ASAN, results in the following error.
> > > This patch fixes this
> > > 
> > > flush table bridge test-bridge
> > > add rule bridge test-bridge input vlan id 1 ip saddr 10.0.0.1
> > 
> > Thanks for your patch. Probably this patch instead?
> 
> That fixes the testcase for me as well.

Thanks for confirming.

> Though there are some more places that call list_add / list_add_tail on
> rule->stmts, so I'm unsure if this patch catches all similar cases, e.g:
>
> src/evaluate.c: list_add(&nstmt->list, &ctx->rule->stmts);
> src/evaluate.c: list_add(&nstmt->list, &ctx->rule->stmts);
> src/netlink_delinearize.c:      list_add_tail(&stmt->list,
> &ctx->rule->stmts);
> src/netlink_delinearize.c:              list_add_tail(&stmt->list,
> &ctx->rule->stmts);
> src/netlink_delinearize.c:              list_add_tail(&ctx->stmt->list,
> &ctx->rule->stmts);
> src/parser_json.c:              list_add_tail(&stmt->list, &rule->stmts);
> src/parser_json.c:              list_add_tail(&stmt->list, &rule->stmts);
> src/xt.c:       list_add_tail(&stmt->list, &ctx->rule->stmts);
> src/xt.c:       list_add_tail(&stmt->list, &ctx->rule->stmts);

Right, this is inconsistent. I sent a few patches for this.

BTW, did you update tests/py to run it under ASAN, a patch for this
would be great.

Thanks.
