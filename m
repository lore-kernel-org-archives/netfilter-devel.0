Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692E1C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AC092147C
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfCML1f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:27:35 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:47670 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfCML1f (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 07:27:35 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h422n-0005A4-Vz; Wed, 13 Mar 2019 12:27:34 +0100
Date:   Wed, 13 Mar 2019 12:27:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190313112733.GL4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
References: <20190311151417.17772-1-ffmancera@riseup.net>
 <20190313094424.GA11433@orbyte.nwl.cc>
 <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 11:14:04AM +0100, Fernando Fernandez Mancera wrote:
> Hi Phil,
> 
> On 3/13/19 10:44 AM, Phil Sutter wrote:
> > Hi Fernando,
> > 
> > On Mon, Mar 11, 2019 at 04:14:12PM +0100, Fernando Fernandez Mancera wrote:
> >> Add support for version fingerprint in "osf" expression. Example:
> >>
> >> table ip foo {
> >> 	chain bar {
> >> 		type filter hook input priority filter; policy accept;
> >> 		osf ttl skip name "Linux"
> >> 		osf ttl skip name version "Linux:4.20"
> >> 	}
> >> }
> > 
> > The syntax seems overly complicated to me, although I'm not really
> > familiar with OSF so may lack background knowledge. Any reason why you
> > didn't go with 'osf ttl skip name "Linux" version "4.20"' instead?
> > 
> 
> You are right, 'osf ttl skip name "Linux" version "4.20"' was my first
> thought but in compilation time the parser applies shift-reduce to the
> expression.. I decided 'osf ttl skip name version "Linux:4.20"' to avoid
> a complex workaround in the parser.

Shift/reduce warnings often require voodoo to fix, but it's not
impossible. :)

Regarding my suggestion, I see that this string is actually the
right-hand-side of a relational expression. To implement what I had in
mind you would have to turn osf expression into a statement.

> The fingerprints database syntax is "genre:version:subtype:details" so
> the nft 'osf' expression syntax is like the original one.

Can we deduce required flags from the given string on RHS? I.e. by
looking at the amount of semi-colons and the number of characters
between them? I'm assuming the syntax works like "genre::subtype" and
"genre:::details" to omit certain parts, is that correct?

> > Also with regards to your patch to json_parser, I guess you should
> > introduce an enum for flag values, something like:
> > 
> > | enum osf_flags {
> > | 	OSF_FLAG_INVALID = 0x0,
> > | 	OSF_FLAG_VERSION = 0x1
> > | };
> > | 
> > | const char *osf_flag_names[] = {
> > | 	[OSF_VERSION] = "version"
> > | };
> > 
> > What do you think?
> > 
> 
> This patch already introduces an enum for flags values, you can find it
> below. Do you think we need another one? Sorry if I am misunderstanding
> you. Thanks!

Oh, I missed that one. My concern is how the index of values in
osf_flags array defined in osf_expr_json() and osf_flag_parse() is
relevant although it doesn't seem so when only looking at the array
definition.

Cheers, Phil
