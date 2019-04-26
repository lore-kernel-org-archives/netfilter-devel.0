Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA8E4C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 830872084F
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfDZTOs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:14:48 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40644 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfDZTOs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:14:48 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hK6J4-00088P-Dw; Fri, 26 Apr 2019 21:14:46 +0200
Message-ID: <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 26 Apr 2019 21:14:43 +0200
In-Reply-To: <20190426180430.h5h7lqivx2qufuyi@salvia>
References: <20180207013713.2432-1-pablo@netfilter.org>
         <20180207013713.2432-5-pablo@netfilter.org>
         <f882918e408247a4e0e8d0007feead5bbf311003.camel@sipsolutions.net>
         <20190411192647.xsnhno6gcf5fen5u@salvia>
         <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
         <20190426164252.a2yxjxf3thotrqu3@salvia>
         <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
         <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
         <20190426180430.h5h7lqivx2qufuyi@salvia>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 2019-04-26 at 20:04 +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 26, 2019 at 07:28:15PM +0200, Johannes Berg wrote:
> > On Fri, 2019-04-26 at 19:17 +0200, Johannes Berg wrote:
> > > 
> > > Ideally, we'd add this as
> > > 
> > > {
> > >   .cmd = XYZ,
> > >   .doit = do_xyz,
> > >   .dumpit = dump_xyz,
> > >   .attrs = { ATTR_A, ATTR_B, ATTR_C, ATTR_D },
> > > }
> > > 
> > > but of course there's no good way to express this in C, you'd have to
> > > build an out-of-line array and point to it.
> > 
> > Actually, it's possibly even more complicated. After all, it is possible
> > that you have an ATTR_N, that is nested, and that contains certain sub-
> > attributes (ATTR_N_A, ATTR_N_B, ...) of which only some are valid for
> > the operation X, but a different subset is valid for operation Y.
> 
> I solved this in my patchset through the object ID. So each command
> points to an object ID, then such object ID comes with a list of
> attributes.

Yeah, ok. Each object you had is basically its own policy. I just
*removed* having a separate policy for each command in generic netlink,
as  ;-)

What really I think we should have is a common policy, but only some
attributes are valid in some commands.

I guess you can slice this in different ways. From a "how much space
does this consume" and "can I reuse some code across different commands"
I think having the same policy is a good idea though.

> If we use the list policies that you propose, then it's just an extra
> enumeration to maintain for each command. And many commands will
> likely reuse the same object ID.

A policy pointer, really.

The list of policies is just built internally when you dump out a policy
with its sub-policies for nested attributes/arrays.

johannes

