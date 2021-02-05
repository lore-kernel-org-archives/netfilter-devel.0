Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03E5AC4332E
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 14:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A824564FC6
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 14:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhBEOCy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 09:02:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhBEN4b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 08:56:31 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE07C061786
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Feb 2021 05:55:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id AF37DCC0217;
        Fri,  5 Feb 2021 14:54:17 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  5 Feb 2021 14:54:15 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 4216CCC0239;
        Fri,  5 Feb 2021 14:54:15 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 0EE11340D5D; Fri,  5 Feb 2021 14:54:15 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 0AACE340D5C;
        Fri,  5 Feb 2021 14:54:15 +0100 (CET)
Date:   Fri, 5 Feb 2021 14:54:15 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Reindl Harald <h.reindl@thelounge.net>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update
 deleted entry
In-Reply-To: <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
Message-ID: <alpine.DEB.2.23.453.2102051448220.10405@blackhole.kfki.hu>
References: <20210205001727.2125-1-pablo@netfilter.org> <20210205001727.2125-2-pablo@netfilter.org> <69957353-7fe0-9faa-4ddd-1ac44d5386a5@thelounge.net>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Harald,

On Fri, 5 Feb 2021, Reindl Harald wrote:

> "Reap only entries which won't be updated" sounds for me like the could 
> be some optimization: i mean when you first update and then check what 
> can be reaped the recently updated entry would not match to begin with

When the entry is new and the given recent table is full we cannot update 
(add) it, unless old entries are deleted (reaped) first. So it'd require 
more additional checkings to be introduced to reverse the order of the two 
operations.

Best regards,
Jozsef
 
> Am 05.02.21 um 01:17 schrieb Pablo Neira Ayuso:
> > From: Jozsef Kadlecsik <kadlec@mail.kfki.hu>
> > 
> > When both --reap and --update flag are specified, there's a code
> > path at which the entry to be updated is reaped beforehand,
> > which then leads to kernel crash. Reap only entries which won't be
> > updated.
> > 
> > Fixes kernel bugzilla #207773.
> > 
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=207773
> > Reported-by: Reindl Harald <h.reindl@thelounge.net>
> > Fixes: 0079c5aee348 ("netfilter: xt_recent: add an entry reaper")
> > Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >   net/netfilter/xt_recent.c | 12 ++++++++++--
> >   1 file changed, 10 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
> > index 606411869698..0446307516cd 100644
> > --- a/net/netfilter/xt_recent.c
> > +++ b/net/netfilter/xt_recent.c
> > @@ -152,7 +152,8 @@ static void recent_entry_remove(struct recent_table *t,
> > struct recent_entry *e)
> >   /*
> >    * Drop entries with timestamps older then 'time'.
> >    */
> > -static void recent_entry_reap(struct recent_table *t, unsigned long time)
> > +static void recent_entry_reap(struct recent_table *t, unsigned long time,
> > +			      struct recent_entry *working, bool update)
> >   {
> >   	struct recent_entry *e;
> >   @@ -161,6 +162,12 @@ static void recent_entry_reap(struct recent_table *t,
> > unsigned long time)
> >   	 */
> >   	e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
> >   +	/*
> > +	 * Do not reap the entry which are going to be updated.
> > +	 */
> > +	if (e == working && update)
> > +		return;
> > +
> >   	/*
> >   	 * The last time stamp is the most recent.
> >   	 */
> > @@ -303,7 +310,8 @@ recent_mt(const struct sk_buff *skb, struct
> > xt_action_param *par)
> >     		/* info->seconds must be non-zero */
> >   		if (info->check_set & XT_RECENT_REAP)
> > -			recent_entry_reap(t, time);
> > +			recent_entry_reap(t, time, e,
> > +				info->check_set & XT_RECENT_UPDATE && ret);
> >   	}
> >     	if (info->check_set & XT_RECENT_SET ||
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
