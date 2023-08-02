Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD60DC00528
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 10:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbjHBKZq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 06:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjHBKZA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 06:25:00 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6163846BB
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 03:22:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qR8zl-00008u-LW; Wed, 02 Aug 2023 12:22:21 +0200
Date:   Wed, 2 Aug 2023 12:22:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org, debian@helgefjell.de
Subject: Re: [iptables PATCH 06/16] man: iptables.8: Trivial font fixes
Message-ID: <ZMouXeTcmQOZ17QQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        debian@helgefjell.de
References: <20230802020400.28220-1-phil@nwl.cc>
 <20230802020400.28220-7-phil@nwl.cc>
 <7n662o78-97qr-25n8-130s-prp6rp35n1r0@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7n662o78-97qr-25n8-130s-prp6rp35n1r0@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

First of all, thanks a lot for reviewing these "boring" changes. :)

On Wed, Aug 02, 2023 at 10:37:53AM +0200, Jan Engelhardt wrote:
> On Wednesday 2023-08-02 04:03, Phil Sutter wrote:
> 
> >No content changes intended, just type commands in bold and the single
> >path reference in italics.
> >
> >diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
> >index 71a6251d6b00c..5a9cec6c9eb35 100644
> >--- a/iptables/iptables.8.in
> >+++ b/iptables/iptables.8.in
> >@@ -200,7 +200,7 @@ or
> > .TP
> > \fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
> > Print all rules in the selected chain.  If no chain is selected, all
> >-chains are printed like iptables-save. Like every other iptables command,
> >+chains are printed like \fBiptables-save\fP. Like every other iptables command,
> > it applies to the specified table (filter is the default).
> 
> Lacking different markup options, I used bold for things you type verbatim
> (would use <tt></tt> in HTML or `` in MD/RST), and italics for replacables.
> 
> In that instance,
> 	...printed like iptables-save.
> was meant to indeed read like a name, i.e.
> 	...printed like iptables-save(8).
> not like a command, i.e.
> 	...printed like `iptables-save`.

I tried to stick to this paradigm, but it's confusing and I probably
lost track here and there. Even in your example above, "printed like
iptables-save", in mind I extend to "printed like the command
iptables-save does" and therefore choose bold font. I'm obviously not
the best candidate to make these choices.

> (Also note that ifff you did \fBiptables-save\fP, it would have need to be
> \fBiptables\-save\fP, because that is required for verbatim forms.)

Ah, thanks! It's misleading if output looks fine anyway.

> The same argument goes for all the rest:
> 
> >@@ -242,30 +242,30 @@ The following parameters make up a rule specification (as used in the
> > add, delete, insert, replace and append commands).
> > .TP
> > \fB\-4\fP, \fB\-\-ipv4\fP
> >-This option has no effect in iptables and iptables-restore.
> >+This option has no effect in \fBiptables\fP and \fBiptables-restore\fP.
> > If a rule using the \fB\-4\fP option is inserted with (and only with)
> >-ip6tables-restore, it will be silently ignored. Any other uses will throw an
> >+\fBip6tables-restore\fP, it will be silently ignored. Any other uses will throw an

Can you maybe clarify how to distinct between "command" and "name"? I'm
tempted to just leave things as they are instead of doing changes
randomly.

Thanks, Phil
