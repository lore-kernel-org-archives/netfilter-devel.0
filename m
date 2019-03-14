Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9531C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 17:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B93402184C
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 17:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCNRe5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 13:34:57 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:50924 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfCNRe5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 13:34:57 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h4UFq-0006uq-MM; Thu, 14 Mar 2019 18:34:54 +0100
Date:   Thu, 14 Mar 2019 18:34:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190314173454.GA19244@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190313094424.GA11433@orbyte.nwl.cc>
 <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
 <20190313112733.GL4851@orbyte.nwl.cc>
 <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net>
 <20190313150634.GM4851@orbyte.nwl.cc>
 <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net>
 <20190313153455.GN4851@orbyte.nwl.cc>
 <fa72537e-adf8-29fb-6b8b-ebe30cd9bfc6@riseup.net>
 <e61257f6-4281-d450-0f41-6891a8744e96@riseup.net>
 <20190314135840.4j6b436zmaqe5akv@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314135840.4j6b436zmaqe5akv@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Mar 14, 2019 at 02:58:40PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Thu, Mar 14, 2019 at 12:14:23PM +0100, Fernando Fernandez Mancera wrote:
> > Hi,
> > 
> > I have been thinking more about this today. I don't know how access to
> > the right-hand-side string from the kernel if it is possible. Sorry if
> > the question is very dumb, but I may lack experience with the nft
> > registers and RHS data of an expression.
> 
> I think you can hide flags from json, which is what Phil suggests, I
> mean, just infer version flags from the syntax, ie. if
> "genre::version" is used, then set of the version flag.
> 
> I think Phil is not suggesting kernel changes.

Actually I'm still in the process of understanding how all this works.
What I got so far is (correct me if I'm wrong): osf expr does the
fingerprinting and returns a string which relational expr compares to
right-hand side. This new version flag defines whether osf expr adds the
version to returned string or not.

Assuming the above is correct, my suggestion of making the flag option
implicit does not quite hold, at least not without painful
postprocessing of relational statement in userspace.

Right now this all seems to me like enabling multiple comparisons within
a single relational, i.e. one for genre and the other for version.
Nftables doesn't quite do such things. E.g. matching on two TCP header
fields requires two relationals, e.g. 'tcp dport 22 tcp sport > 1024'.
Internally then, these two statements may be combined into a single
payload match if suitable.

Applying the same logic to osf expression, we would implement 'osf name
foo osf version 3.141' and add 'osf_try_merge()' routine to
'rule_postprocess()' which tries to combine the two statements.
Obviously, this is quite a bit of extra work, not sure if feasible.

Cheers, Phil
