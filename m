Return-Path: <SRS0=dQO5=BL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CAABC433DF
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Aug 2020 19:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FBE12072A
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Aug 2020 19:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgHAT1g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 1 Aug 2020 15:27:36 -0400
Received: from correo.us.es ([193.147.175.20]:37152 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgHAT1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 1 Aug 2020 15:27:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7CD24D28E9
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2020 21:27:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6FEC3DA722
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Aug 2020 21:27:33 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 655DDDA73F; Sat,  1 Aug 2020 21:27:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2431EDA73F;
        Sat,  1 Aug 2020 21:27:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Aug 2020 21:27:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 06D164265A2F;
        Sat,  1 Aug 2020 21:27:30 +0200 (CEST)
Date:   Sat, 1 Aug 2020 21:27:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200801192730.GA5485@salvia>
References: <20200730195337.3627-1-guigom@riseup.net>
 <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc>
 <20200731173028.GA16302@salvia>
 <20200801000213.GN13697@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200801000213.GN13697@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 01, 2020 at 02:02:13AM +0200, Phil Sutter wrote:
> On Fri, Jul 31, 2020 at 07:30:28PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jul 31, 2020 at 03:48:28PM +0200, Phil Sutter wrote:
> > > On Fri, Jul 31, 2020 at 02:58:25PM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Jul 31, 2020 at 02:33:42PM +0200, Phil Sutter wrote:
> > [...]
> > > The less predictable echo output behaves, the harder it is to write code
> > > that makes use of it.
> > 
> > What is it making the output less predictible? The kernel should
> > return an input that is equal to the output plus the handle. Other
> > than that, it's a bug.
> 
> In tests/py, I see 330 lines explicitly stating the expected output as
> it differs from the input ('grep "ok;" */*.t | wc -l'). Can we fix those
> bugs first before we assume what the kernel returns is identical to user
> input?

Semantically speaking those lines are equivalent, it's just that input
and the output representation differ in some scenarios because the
decompilation routine differ in the way it builds the expressions.

BTW, why do you qualify this as a bug?

> Say a script manages a rule (in JSON-equivalent) of:
> 
> | ip protocol tcp tcp dport '{ 22 - 23, 24 - 25}'
> 
> Both matches are elements in an array resembling the rule's "expr"
> attribute. Nftables drops the first match, so if the script wants to
> edit the ports in RHS of the second match, it won't find it anymore.
> Also, the two port ranges are combined into a single one, so removing
> one of the two ranges turns into a non-trivial problem.
> 
> Right now a script may apply its ruleset snippet and retrieve the
> handles by:
> 
> | rc, ruleset, err = nftables.json_cmd(ruleset)
> 
> If the returned ruleset is not identical (apart from added attributes),
> scripts will likely resort to a fire-n-forget type of usage pattern.

You mean, the user in that JSON script is comparing the input and
output strings to find the rule handle?

If so, we should explore a better way to do this, eg. expose some user
defined identifier in JSON that userspace sets on when sending the
batch to identify the object coming back from the kernel.

> > This is also saving quite a bit of code and streamlining this further:
> > 
> >  4 files changed, 49 insertions(+), 153 deletions(-)
> 
> Proudly presenting reduced code size by dropping functionality is
> cheating. Assume nobody needs the JSON interface, easily drop 5k LoC.

The existing approach ignores the kernel echo netlink message almost
entirely, it only takes the handle.

We need an unified way to deal with --json --echo, whether the input
is native nft or json syntax.

If the problem is described in the question I made above, how will
users passing native nft syntax and requesing json output will
identify the rule? They cannot make string matching comparison in that
case since there is no input JSON representation.

Thanks.
