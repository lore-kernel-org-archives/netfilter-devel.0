Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CE2C43218
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 16:35:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B1BA20717
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 16:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfDYQfw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfDYQfw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 12:35:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE345C049E23;
        Thu, 25 Apr 2019 16:35:50 +0000 (UTC)
Received: from egarver.localdomain (ovpn-120-251.rdu2.redhat.com [10.10.120.251])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9575460856;
        Thu, 25 Apr 2019 16:35:48 +0000 (UTC)
Date:   Thu, 25 Apr 2019 12:35:46 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC 0/2] JSON schema for nftables.py
Message-ID: <20190425163546.zpm7tfhpolyfmtoe@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
References: <20190425140502.22761-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425140502.22761-1-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 25 Apr 2019 16:35:51 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

Thanks for working on this.

On Thu, Apr 25, 2019 at 04:05:00PM +0200, Phil Sutter wrote:
> This is an initial implementation of support for jsonschema in
> nftables.py. The goal is to have a schema definition which may be used
> by users as well as our testsuite to make sure any JSON we accept or
> generate is valid.
> 
> The added schema.json in patch 1 is very minimal for now - I have a more
> detailed version but it is not complete yet. Also it is quite large
> already, so for the sake of reviews the small one serves better.
> 
> A few aspects of the implementation I'm unsure of:
> 
> Keeping the schema in a "pure" JSON file makes things a bit complex: It
> has to be shipped as data file and loaded by the validator using
> json.load(). OTOH the content may be fed into json_verify and my editor
> provides nicer syntax highlighting. An alternative would be to name it
> schema.py, prefix the content with 'nftschema = ' and simply import it
> into nftables.py. I don't think inlining the content is a good option
> simply due to how large the file will get once definitions for all
> statements and expressions are in there.

I very much prefer the external JSON file. Other projects can then use
it to validate the JSON they generate without going through libnftables.

> Introducing that SchemaValidator class is not really required, either.
> Though squeezing everything into json_validate() method felt clumsy.
> Also I wanted to avoid the explicit schema loading mentioned above upon
> each call to json_validate(), so having an instance of a validator class
> seemed like how one is supposed to do things in an object-oriented
> language.
> 
> Note that SchemaValidator imports jsonschema upon instantiation. This
> may be a bad idea to begin with, but the intention is to not introduce a
> hard dependency on jsonschema in nftables.py. Same argument holds for
> conditional import of traceback module in nft-test.py, although
> validator errors are practically useless without it.

I agree with the optional jsonschema dependency.

traceback is part of the python standard library. No reason to make it a
conditional import unless you're worried about the cost of importing it.

> 
> Phil Sutter (2):
>   py: Implement JSON validation in nftables module
>   tests/py: Support JSON validation
> 
>  py/Makefile.am       |  2 +-
>  py/nftables.py       | 30 ++++++++++++++++++++++++++++++
>  py/schema.json       | 17 +++++++++++++++++
>  py/setup.py          |  1 +
>  tests/py/nft-test.py | 29 ++++++++++++++++++++++++++++-
>  5 files changed, 77 insertions(+), 2 deletions(-)
>  create mode 100644 py/schema.json
> 
> -- 
> 2.21.0
> 
