Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0856C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A876C20679
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfDZQm7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:42:59 -0400
Received: from mail.us.es ([193.147.175.20]:55482 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726644AbfDZQm4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:42:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CBF45B6C65
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 18:42:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B72CFDA709
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 18:42:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ACF08DA707; Fri, 26 Apr 2019 18:42:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9C1A0DA702;
        Fri, 26 Apr 2019 18:42:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 18:42:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 785274265A32;
        Fri, 26 Apr 2019 18:42:52 +0200 (CEST)
Date:   Fri, 26 Apr 2019 18:42:52 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Message-ID: <20190426164252.a2yxjxf3thotrqu3@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
 <20180207013713.2432-5-pablo@netfilter.org>
 <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
 <20190411192647.xsnhno6gcf5fen5u@salvia>
 <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 12, 2019 at 01:56:22PM +0200, Johannes Berg wrote:
> > > I'd actually be happy to *just* expose the policy with all its nested
> > > elements/objects in there. That'd probably be also almost enough for
> > > you?
> > 
> > Exposing commands is also important, I know of people poking for
> > commands to see if they are available or not.
> 
> Alright, well, generic netlink already exposes the commands :-)

How are you going to relate this with the policy description?

Could you post a schema of the netlink attribute hierarchy of your
policy descriptions?

> > I think we should full description to userspace, not only policies.
> 
> I guess the way I see it, they're all pieces of the puzzle. The policy
> is good for both code in the kernel and for exposing it. The command
> list is already exposed.
> 
> What now we're missing, in a sense, is which commands take which
> attributes. This would actually *also* be a good thing for validation in
> the kernel, but I haven't really found a good way to encode it yet.
> Doing a bitmap isn't really feasible, and doing a list is difficult to
> type out.
> 
> Perhaps if we do end up going with your code generation idea then we can
> do this more easily.
> 
> > > Except we don't have an "object ID" (and obviously also that we can use
> > > the same data to actually parse/validate messages, and so don't end up
> > > with bad situations of nldesc saying one thing and the policy another.)
> > 
> > The object ID is needed by userspace, to build a flat table, and look
> > up for the nested IDs, to express the graph. We can probably place
> > this in the policy.
> 
> I don't really understand the object ID.

This object ID is a policy nest ID.

The idea is to expose an array of nest IDs (object IDs), then this array
contains the attributes that this nest contains and if there are nested
attributes, then in case of nested attributed, the nest ID that describe
this attribute.

The idea is to make it easy for userspace to build this table, and then
userspace performs lookups based on this object ID (policy nest ID).

> Say you have a top-level "filter" attribute (I'm completely making up
> things here).
> 
> Now this filter "object" can have a number of attributes, and that's
> captured by the nested policy there?
> 
> IOW - the code I wrote until now would expose
> 
> policy 0: attribute filter: nested with attrs from policy 1
> policy 1: attribute abc: NLA_U8
> policy 1: attribute xyz: NLA_U32
> 
> etc.
> 
> > This would be incomplete, since commands are an essential part too,
> > and relation of attributes with commands are also too.
> 
> Agree. Still, I think it solves much of the problem, like I said above -
> all are parts of the puzzle.
> 
> With generic netlink we have a list of commands already. That should be
> easy to add elsewhere, though generic netlink has the advantage of
> having the list of commands (and their handlers) as *data*, which I
> think is expressed *code* in rtnetlink now? But that can either be fixed
> or you just carry a separate list of commands there.
> 
> With the policy export I wrote we have the policy, and if you set it up
> properly with all the nested sub-policies for each attribute etc.
> 
> So I agree - we're missing "this command uses these attributes", but
> again I don't think the object description is actually the right
> solution here, because you *also* want to enforce that in some way.
> 
> I feel the generic netlink model where the command handlers etc. are not
> code but data is superior here because it lets us add things like that
> relatively easily, though of course we haven't actually done it now.
> 
> So basically - my main concern with this bus description stuff you've
> done here is that it duplicates all the data and needs to be maintained
> separately from what should be the same data used for enforcement.

My idea was to provide a description of netlink, then a compiler tool
that would autogenerate the policy structures and the UAPI headers from
this bus description. Yes, it sounds too futuristic to autogenerate code
in the kernel, but other projects do already.
