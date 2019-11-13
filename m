Return-Path: <SRS0=8p/T=ZF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2910EC432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F03C7206E3
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Nov 2019 23:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfKMXKa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Nov 2019 18:10:30 -0500
Received: from correo.us.es ([193.147.175.20]:39096 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfKMXKa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Nov 2019 18:10:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 62529EBAD1
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 00:10:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51771B8011
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2019 00:10:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4723CB8007; Thu, 14 Nov 2019 00:10:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A3D44D744;
        Thu, 14 Nov 2019 00:10:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Nov 2019 00:10:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E785642EE38E;
        Thu, 14 Nov 2019 00:10:20 +0100 (CET)
Date:   Thu, 14 Nov 2019 00:10:22 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject set references in mapping LHS
Message-ID: <20191113231022.bb7hmwqvmgm4emv7@salvia>
References: <20191031182124.11393-1-phil@nwl.cc>
 <20191112214518.tsevqoqtm5ubov3p@salvia>
 <20191112221827.GD11663@orbyte.nwl.cc>
 <20191113101050.GE11663@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113101050.GE11663@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 13, 2019 at 11:10:50AM +0100, Phil Sutter wrote:
> On Tue, Nov 12, 2019 at 11:18:27PM +0100, Phil Sutter wrote:
> > On Tue, Nov 12, 2019 at 10:45:18PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 31, 2019 at 07:21:24PM +0100, Phil Sutter wrote:
> > > > This wasn't explicitly caught before causing a program abort:
> > > > 
> > > > | BUG: invalid range expression type set reference
> > > > | nft: expression.c:1162: range_expr_value_low: Assertion `0' failed.
> > > > | zsh: abort      sudo ./install/sbin/nft add rule t c meta mark set tcp dport map '{ @s : 23 }
> > > > 
> > > > With this patch in place, the error message is way more descriptive:
> > > > 
> > > > | Error: Key can't be set reference
> > > > | add rule t c meta mark set tcp dport map { @s : 23 }
> > > > |                                            ^^
> > > 
> > > I wanted to check why the parser allow for this...
> > 
> > For set elements or LHS parts of map elements, there is set_lhs_expr.
> > The latter may be concat_rhs_expr or multiton_rhs_expr. concat_rhs_expr
> > eventually resolves into primary_rhs_expr which may be symbol_expr.
> > 
> > BTW, it seems like from parser side, set references on map element's
> > RHS are allowed as well.
> > 
> > IMHO, parser_bison.y slowly but steadily turns into a can of worms. :(
> 
> On a second look, I start wondering whether symbol_expr was a wise
> choice: This thing combines variables ('$' identifier), "unidentified"
> strings and set references (AT identifier).
> 
> With symbol_expr being listed in both primary_expr and primary_rhs_expr,
> set references are allowed about anywhere - even in concatenations or
> any binary operation.

It would be probably good to restrict set references to where it makes
sense only. This is good for the grammar and we don't need to validate
all possible invalid combinations from the evaluation step.

Would you have a look or you think it's too complicated to attack this
from the parser?
