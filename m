Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A58FC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDF8320656
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfDZTVA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:21:00 -0400
Received: from mail.us.es ([193.147.175.20]:35052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfDZTU7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:20:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 35C8E11ED89
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 21:20:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25A2EDA709
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 21:20:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B664DA707; Fri, 26 Apr 2019 21:20:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21FEBDA701;
        Fri, 26 Apr 2019 21:20:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 21:20:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F305F4265A31;
        Fri, 26 Apr 2019 21:20:54 +0200 (CEST)
Date:   Fri, 26 Apr 2019 21:20:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Message-ID: <20190426192054.4iedgasehywqzyx6@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
 <20180207013713.2432-5-pablo@netfilter.org>
 <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
 <20190411192647.xsnhno6gcf5fen5u@salvia>
 <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
 <20190426164252.a2yxjxf3thotrqu3@salvia>
 <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
 <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
 <20190426180430.h5h7lqivx2qufuyi@salvia>
 <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 09:14:43PM +0200, Johannes Berg wrote:
> On Fri, 2019-04-26 at 20:04 +0200, Pablo Neira Ayuso wrote:
> > On Fri, Apr 26, 2019 at 07:28:15PM +0200, Johannes Berg wrote:
> > > On Fri, 2019-04-26 at 19:17 +0200, Johannes Berg wrote:
> > > > 
> > > > Ideally, we'd add this as
> > > > 
> > > > {
> > > >   .cmd = XYZ,
> > > >   .doit = do_xyz,
> > > >   .dumpit = dump_xyz,
> > > >   .attrs = { ATTR_A, ATTR_B, ATTR_C, ATTR_D },
> > > > }
> > > > 
> > > > but of course there's no good way to express this in C, you'd have to
> > > > build an out-of-line array and point to it.
> > > 
> > > Actually, it's possibly even more complicated. After all, it is possible
> > > that you have an ATTR_N, that is nested, and that contains certain sub-
> > > attributes (ATTR_N_A, ATTR_N_B, ...) of which only some are valid for
> > > the operation X, but a different subset is valid for operation Y.
> > 
> > I solved this in my patchset through the object ID. So each command
> > points to an object ID, then such object ID comes with a list of
> > attributes.
> 
> Yeah, ok. Each object you had is basically its own policy.

Hm, not necessarily.

The object id is matching to the "root policy". Several commands may
have the same "root policy" (or as I call it "object id"). For
example, in netfilter we have commands to add and to delete rules,
both would have the same "root policy".

> I just *removed* having a separate policy for each command in
> generic netlink, as  ;-)
> 
> What really I think we should have is a common policy, but only some
> attributes are valid in some commands.
> 
> I guess you can slice this in different ways. From a "how much space
> does this consume" and "can I reuse some code across different commands"
> I think having the same policy is a good idea though.
>
> > If we use the list policies that you propose, then it's just an extra
> > enumeration to maintain for each command. And many commands will
> > likely reuse the same object ID.
> 
> A policy pointer, really.

Sort of, but it has to be stable along time for userspace, right?
Actually, it's an ID.

> The list of policies is just built internally when you dump out a policy
> with its sub-policies for nested attributes/arrays.

If we expose these to userspace, we need that these object IDs are
stable, hence the enum. So userspace results in a simple program that
just makes look ups for the object ID that contains the description of
the attributes that are available.
