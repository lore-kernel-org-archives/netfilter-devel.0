Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA44CC43218
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 10:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E6FA208CA
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 10:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfD0K5q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 06:57:46 -0400
Received: from mail.us.es ([193.147.175.20]:58376 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfD0K5p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 06:57:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7ABAB6C65
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 12:57:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9984DA706
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 12:57:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AF2ABDA705; Sat, 27 Apr 2019 12:57:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B876ADA706;
        Sat, 27 Apr 2019 12:57:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 27 Apr 2019 12:57:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 982874265A32;
        Sat, 27 Apr 2019 12:57:41 +0200 (CEST)
Date:   Sat, 27 Apr 2019 12:57:41 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] netfilter: nf_tables: add netlink description
Message-ID: <20190427105741.nfxy56bkr62hupml@salvia>
References: <20190411192647.xsnhno6gcf5fen5u@salvia>
 <beb5d59393d8dbf466b0d728ca85842afb6cd039.camel@sipsolutions.net>
 <20190426164252.a2yxjxf3thotrqu3@salvia>
 <8a754fb122da038b540583708315e5782beefbd2.camel@sipsolutions.net>
 <5d2a03325b4121c2f91bc78bb0e44c3592af4220.camel@sipsolutions.net>
 <20190426180430.h5h7lqivx2qufuyi@salvia>
 <0c7f81c740a5670abfbc6249b58bbd318a24eaec.camel@sipsolutions.net>
 <20190426192054.4iedgasehywqzyx6@salvia>
 <a2e483388c096b6b4fb76db70b2068cae6279a40.camel@sipsolutions.net>
 <79a6e186763b199b3fd28ef0dc0e67b3698fea89.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79a6e186763b199b3fd28ef0dc0e67b3698fea89.camel@sipsolutions.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 09:46:33PM +0200, Johannes Berg wrote:
> On Fri, 2019-04-26 at 21:37 +0200, Johannes Berg wrote:
> 
> > You're now thinking of the "policy ID" I assigned for the wire format as
> > the object ID, but really that's not what it is. The object ID that
> > you're looking for is the attribute type of the nested attribute.
> > 
> > So if you have
> > 
> > struct nla_policy nested_policy[...] = { ... };
> > 
> > struct nla_policy policy[...] = {
> >     [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
> > };
> > 
> So if we extend this, say like this:
> 
> struct nla_policy policy[...] = {
>     [MY_ATTR] = NLA_POLICY_NESTED(nested_policy),
>     [MY_OTHER_ATTR] = NLA_POLICY_NESTED(nested_policy),
> };
> 
> then you could perhaps argue that having an object ID makes sense, and
> assigning the same object ID to MY_ATTR and MY_OTHER_ATTR would make
> sense?
> 
> Of course, my could would assign this the same (temporary) policy ID,
> but there can be no reliance on the policy ID beyond what's needed at
> runtime to map the attribute to the nested policy.
> 
> You still see at runtime that these have the same policy (since they
> have the same policy ID), but at the same time presumably there was a
> reason to have MY_ATTR and MY_OTHER_ATTR, so perhaps the semantics are
> different even if the attributes are the same, as could perhaps be
> expected if you have a SET and a CLEAR attribute (MY_ATTR and
> MY_OTHER_ATTR respectively) and the contents you give has the same
> policy, but different logic?
> 
> Basically, I just didn't consider this case to be significant enough to
> manually and assign stable IDs of some sort, when we already have them
> in the form of the attribute type.

But they all point to the same nested_policy, ie. these nested
atributes represent instances of the same object class.

I think this is meaningful to userspace in terms of providing a
description of the interface, rather than making it look.

Without the ID, it is not possible from userspace to see that MY_ATTR
and MY_OTHER_ATTR refer to the same object, right?
