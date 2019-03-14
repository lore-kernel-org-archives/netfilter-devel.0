Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11510C4360F
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 20:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E05B52082F
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 20:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfCNUHo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 16:07:44 -0400
Received: from mail.us.es ([193.147.175.20]:34932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfCNUHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 16:07:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1DD9A154E87
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 21:07:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C531DA844
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 21:07:40 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 01A37DA846; Thu, 14 Mar 2019 21:07:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8DD4DA844;
        Thu, 14 Mar 2019 21:07:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Mar 2019 21:07:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 859C14265A50;
        Thu, 14 Mar 2019 21:07:37 +0100 (CET)
Date:   Thu, 14 Mar 2019 21:07:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190314200737.erhjrhoaciclapsn@salvia>
References: <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
 <20190313112733.GL4851@orbyte.nwl.cc>
 <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net>
 <20190313150634.GM4851@orbyte.nwl.cc>
 <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net>
 <20190313153455.GN4851@orbyte.nwl.cc>
 <fa72537e-adf8-29fb-6b8b-ebe30cd9bfc6@riseup.net>
 <e61257f6-4281-d450-0f41-6891a8744e96@riseup.net>
 <20190314135840.4j6b436zmaqe5akv@salvia>
 <20190314173454.GA19244@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190314173454.GA19244@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 14, 2019 at 06:34:54PM +0100, Phil Sutter wrote:
> Hi,
> 
> On Thu, Mar 14, 2019 at 02:58:40PM +0100, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Thu, Mar 14, 2019 at 12:14:23PM +0100, Fernando Fernandez Mancera wrote:
> > > Hi,
> > > 
> > > I have been thinking more about this today. I don't know how access to
> > > the right-hand-side string from the kernel if it is possible. Sorry if
> > > the question is very dumb, but I may lack experience with the nft
> > > registers and RHS data of an expression.
> > 
> > I think you can hide flags from json, which is what Phil suggests, I
> > mean, just infer version flags from the syntax, ie. if
> > "genre::version" is used, then set of the version flag.
> > 
> > I think Phil is not suggesting kernel changes.
> 
> Actually I'm still in the process of understanding how all this works.
> What I got so far is (correct me if I'm wrong): osf expr does the
> fingerprinting and returns a string which relational expr compares to
> right-hand side. This new version flag defines whether osf expr adds the
> version to returned string or not.
> 
> Assuming the above is correct, my suggestion of making the flag option
> implicit does not quite hold, at least not without painful
> postprocessing of relational statement in userspace.
> 
> Right now this all seems to me like enabling multiple comparisons within
> a single relational, i.e. one for genre and the other for version.
> Nftables doesn't quite do such things. E.g. matching on two TCP header
> fields requires two relationals, e.g. 'tcp dport 22 tcp sport > 1024'.
> Internally then, these two statements may be combined into a single
> payload match if suitable.

The osf expression returns a string with the OS genre, and if the
version flag is set on, it appends the version to this string, ie.
genre + version.

This allows us to build maps, ie.

        meta mark set osf genre { "linux" : 0x10, "windows" : 0x20, "macos" : 0x40 }

But, with this new version, you could also do:

        meta mark set osf genre { "linux::4.0" : 0x11, "linux::3.0" : 0x12, ...}

and so on.

So I see this version thing as a extended matching.

The osf engine actually _already_ finds a precise matching, ie. genre
+ version, since the fingerprint is per genre + version. But you can
just decide to match on the genre (eg. linux).

> Applying the same logic to osf expression, we would implement 'osf name
> foo osf version 3.141' and add 'osf_try_merge()' routine to
> 'rule_postprocess()' which tries to combine the two statements.
> Obviously, this is quite a bit of extra work, not sure if feasible.

I think the discussion here is the syntax, ie.

        osf genre "Linux::4.10"

vs.

        osf genre "Linux" version "4.10"

This only requires changes to the userspace nftables side, if you
prefer this syntax, which is what I understand you would like to see,
right?

The use of the colon, which comes from the pf.os file:

512:64:0:44:M*:                 Linux:2.0:3x:Linux 2.0.3x
                                ^^^^^^^^^

Then, this allows us to match for "Linux:2.0".

Thanks!
