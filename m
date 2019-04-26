Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83B1BC43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 07:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54B372077B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 07:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfDZHpr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:45:47 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:57902 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbfDZHpr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 03:45:47 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hJvYG-0003pH-Cs; Fri, 26 Apr 2019 09:45:44 +0200
Date:   Fri, 26 Apr 2019 09:45:44 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC 0/2] JSON schema for nftables.py
Message-ID: <20190426074544.GT31599@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
References: <20190425140502.22761-1-phil@nwl.cc>
 <20190425163546.zpm7tfhpolyfmtoe@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425163546.zpm7tfhpolyfmtoe@egarver.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Eric,

On Thu, Apr 25, 2019 at 12:35:46PM -0400, Eric Garver wrote:
> On Thu, Apr 25, 2019 at 04:05:00PM +0200, Phil Sutter wrote:
[...]
> > Keeping the schema in a "pure" JSON file makes things a bit complex: It
> > has to be shipped as data file and loaded by the validator using
> > json.load(). OTOH the content may be fed into json_verify and my editor
> > provides nicer syntax highlighting. An alternative would be to name it
> > schema.py, prefix the content with 'nftschema = ' and simply import it
> > into nftables.py. I don't think inlining the content is a good option
> > simply due to how large the file will get once definitions for all
> > statements and expressions are in there.
> 
> I very much prefer the external JSON file. Other projects can then use
> it to validate the JSON they generate without going through libnftables.

Valid point, although the file will be hidden in
/lib64/python2.7/site-packages/nftables/schema.json after installation.

> > Introducing that SchemaValidator class is not really required, either.
> > Though squeezing everything into json_validate() method felt clumsy.
> > Also I wanted to avoid the explicit schema loading mentioned above upon
> > each call to json_validate(), so having an instance of a validator class
> > seemed like how one is supposed to do things in an object-oriented
> > language.
> > 
> > Note that SchemaValidator imports jsonschema upon instantiation. This
> > may be a bad idea to begin with, but the intention is to not introduce a
> > hard dependency on jsonschema in nftables.py. Same argument holds for
> > conditional import of traceback module in nft-test.py, although
> > validator errors are practically useless without it.
> 
> I agree with the optional jsonschema dependency.
> 
> traceback is part of the python standard library. No reason to make it a
> conditional import unless you're worried about the cost of importing it.

Thanks for pointing this out! For the testsuite, unconditionally
importing traceback should be perfectly fine.

Thanks, Phil
