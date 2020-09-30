Return-Path: <SRS0=6DLs=DH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3BB7C47420
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 10:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7799620706
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Sep 2020 10:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbgI3KUj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Sep 2020 06:20:39 -0400
Received: from correo.us.es ([193.147.175.20]:56854 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3KUi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Sep 2020 06:20:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BA5620047
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 12:20:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6FBCDA84B
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2020 12:20:36 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3A61EBAF2; Wed, 30 Sep 2020 12:20:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 975FCDA903;
        Wed, 30 Sep 2020 12:20:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Sep 2020 12:20:32 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6F6C142EF9E3;
        Wed, 30 Sep 2020 12:20:33 +0200 (CEST)
Date:   Wed, 30 Sep 2020 12:20:33 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject quoted strings containing only
 wildcard
Message-ID: <20200930102033.GA18726@salvia>
References: <20200924170639.15842-1-phil@nwl.cc>
 <20200928081925.GZ19674@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200928081925.GZ19674@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 28, 2020 at 10:19:25AM +0200, Phil Sutter wrote:
> On Thu, Sep 24, 2020 at 07:06:39PM +0200, Phil Sutter wrote:
> > Fix for an assertion fail when trying to match against an all-wildcard
> > interface name:
> > 
> > | % nft add rule t c iifname '"*"'
> > | nft: expression.c:402: constant_expr_alloc: Assertion `(((len) + (8) - 1) / (8)) > 0' failed.
> > | zsh: abort      nft add rule t c iifname '"*"'
> > 
> > Fix this by detecting the string in expr_evaluate_string() and returning
> > an error message:
> > 
> > | % nft add rule t c iifname '"*"'
> > | Error: All-wildcard strings are not supported
> > | add rule t c iifname "*"
> > |                      ^^^
> > 
> 
> Note that all this is pretty inconsistent: The above happens only for
> quoted asterisks. Unquoted ones cause a different error (at least no
> assertion fail):
> 
> | % nft add rule t c iifname '*'
> | Error: datatype mismatch, expected network interface name, expression has type integer
> | add rule t c iifname *
> |              ~~~~~~~ ^
> 
> What puzzles me is that we have:
> 
> | wildcard_expr           :       ASTERISK
> |                         {
> |                                 struct expr *expr;
> | 
> |                                 expr = constant_expr_alloc(&@$, &integer_type,
> |                                                            BYTEORDER_HOST_ENDIAN,
> |                                                            0, NULL);
> |                                 $$ = prefix_expr_alloc(&@$, expr, 0);
> |                         }
> |                         ;
> 
> Yet when trying to use it as a prefix, it is rejected:
> 
> | % nft add rule t c ip saddr '*'
> | Error: datatype mismatch, expected IPv4 address, expression has type integer
> | add rule t c ip saddr *
> |              ~~~~~~~~ ^
> 
> So is this wildcard_expr simply broken or didn't I find correct way to use it
> yet?

This looks like some preliminary support for wildcard matching in set
elements, but my impression is that this is broken. I don't remember
to have seen any tests covering this.
