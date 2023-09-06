Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDCCEE14C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 21:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244615AbjIFVjw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 17:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbjIFVjv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 17:39:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F27619B3;
        Wed,  6 Sep 2023 14:39:44 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qe0FR-0002HV-90; Wed, 06 Sep 2023 23:39:41 +0200
Date:   Wed, 6 Sep 2023 23:39:41 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPjxnSg3/gDy25r0@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Paul Moore <paul@paul-moore.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        audit@vger.kernel.org
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula>
 <ZPiyGC+TfRgyOabJ@orbyte.nwl.cc>
 <ZPjJAicFFam5AFIq@calendula>
 <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhQ0n8Ezef8wYC7uV-MHccqHobYxoB3VYoC9TaGiFm9noQ@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Paul,

On Wed, Sep 06, 2023 at 03:56:41PM -0400, Paul Moore wrote:
> On Wed, Sep 6, 2023 at 2:46 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Sep 06, 2023 at 07:08:40PM +0200, Phil Sutter wrote:
> > [...]
> > > The last six come from the 'reset rules table t1' command. While on one
> > > hand it looks like nftables fits only three rules into a single skb,
> > > your fix seems to have a problem in that it doesn't subtract s_idx from
> > > *idx.
> >
> > Please, feel free to follow up to refine, thanks.
> 
> Forgive me if I'm wrong, but it sounds as though Phil was pointing out
> a bug and not an area of refinement, is that correct Phil?

From my point of view, yes. Though the third parameter "nentries" to
audit_log_nfcfg() is sometimes used in rather creative ways,
nf_tables_dump_obj() for instance passes the handle of the object being
reset instead of a count. So I assume whoever parses audit logs won't
rely too much upon the 'entries=NNN' part, anyway.

> If it is a bug, please submit a fix for this as soon as possible Pablo.

Thanks for your support, but I can take over, too. The number of
notifications emitted even for a small ruleset is not ideal, also. It's
just a bit sad that I ACKed the patch already and so it went out the
door. Florian, can we still put a veto there?

Cheers, Phil
