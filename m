Return-Path: <SRS0=/b89=ZG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416FBC432C3
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 10:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18F59206EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Nov 2019 10:52:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfKNKw0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:52:26 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:52470 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfKNKw0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 05:52:26 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iVCjh-0001mC-O1; Thu, 14 Nov 2019 11:52:25 +0100
Date:   Thu, 14 Nov 2019 11:52:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject set references in mapping LHS
Message-ID: <20191114105225.GG11663@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191031182124.11393-1-phil@nwl.cc>
 <20191112214518.tsevqoqtm5ubov3p@salvia>
 <20191112221827.GD11663@orbyte.nwl.cc>
 <20191113101050.GE11663@orbyte.nwl.cc>
 <20191113231022.bb7hmwqvmgm4emv7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113231022.bb7hmwqvmgm4emv7@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 14, 2019 at 12:10:22AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 13, 2019 at 11:10:50AM +0100, Phil Sutter wrote:
> > On Tue, Nov 12, 2019 at 11:18:27PM +0100, Phil Sutter wrote:
> > > On Tue, Nov 12, 2019 at 10:45:18PM +0100, Pablo Neira Ayuso wrote:
> > > > On Thu, Oct 31, 2019 at 07:21:24PM +0100, Phil Sutter wrote:
> > > > > This wasn't explicitly caught before causing a program abort:
> > > > > 
> > > > > | BUG: invalid range expression type set reference
> > > > > | nft: expression.c:1162: range_expr_value_low: Assertion `0' failed.
> > > > > | zsh: abort      sudo ./install/sbin/nft add rule t c meta mark set tcp dport map '{ @s : 23 }
> > > > > 
> > > > > With this patch in place, the error message is way more descriptive:
> > > > > 
> > > > > | Error: Key can't be set reference
> > > > > | add rule t c meta mark set tcp dport map { @s : 23 }
> > > > > |                                            ^^
> > > > 
> > > > I wanted to check why the parser allow for this...
> > > 
> > > For set elements or LHS parts of map elements, there is set_lhs_expr.
> > > The latter may be concat_rhs_expr or multiton_rhs_expr. concat_rhs_expr
> > > eventually resolves into primary_rhs_expr which may be symbol_expr.
> > > 
> > > BTW, it seems like from parser side, set references on map element's
> > > RHS are allowed as well.
> > > 
> > > IMHO, parser_bison.y slowly but steadily turns into a can of worms. :(
> > 
> > On a second look, I start wondering whether symbol_expr was a wise
> > choice: This thing combines variables ('$' identifier), "unidentified"
> > strings and set references (AT identifier).
> > 
> > With symbol_expr being listed in both primary_expr and primary_rhs_expr,
> > set references are allowed about anywhere - even in concatenations or
> > any binary operation.
> 
> It would be probably good to restrict set references to where it makes
> sense only. This is good for the grammar and we don't need to validate
> all possible invalid combinations from the evaluation step.

ACK!

> Would you have a look or you think it's too complicated to attack this
> from the parser?

It's not too complicated, but I sometimes feel like turning adjuster
screws on a machine I don't understand. OK, given that parser_bison.y
was initially written by Patrick, you're probably in the same situation.
:)

Cheers, Phil
