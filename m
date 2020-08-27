Return-Path: <SRS0=Uzq3=CF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4A6EC433E1
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 14:27:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C323522B4B
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 14:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgH0O1A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbgH0OXz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Aug 2020 10:23:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5836EC061234
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 07:23:31 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kBIoB-0003MX-MO; Thu, 27 Aug 2020 16:23:19 +0200
Date:   Thu, 27 Aug 2020 16:23:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200827142319.GL23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20200823115536.16631-1-pablo@netfilter.org>
 <20200823120434.GA16617@salvia>
 <20200822184621.GH15804@breakpoint.cc>
 <20200824131104.GC23632@orbyte.nwl.cc>
 <20200826153219.GA2640@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826153219.GA2640@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Aug 26, 2020 at 05:32:19PM +0200, Pablo Neira Ayuso wrote:
[...]
> > > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200823115536.16631-1-pablo@netfilter.org/
> > 
> > Obviously this avoids the lockup. As correctly assumed by Florian,
> > firewalld startup fails instead. (The daemon keeps running, but an error
> > message is printed indicating that initial ruleset setup failed.)
> 
> Thanks for confirming, I'll apply this patch to nf.git.

Thanks!

[...]
> There several possibilities, just a few that can be explored:
> 
> * I made a quick patch to batch several netlink messages coming as
>   reply to the NLM_F_ECHO request into one single skbuff. If you look
>   at the _notify() functions in the kernel, this is currently taking
>   one single skbuff for one message which adds a bit of overhead (the
>   skbuff truesize is used for the socket buffer accounting). I'm
>   measuring here on x86_64 that each command takes 768 bytes. With a
>   quick patch I'm batching several reply netlink messages into one
>   single skbuff, now each commands takes ~120 bytes (well, size
>   depends on how many expressions you use actually). This means this
>   can handle ~3550 commands vs. the existing ~555 commands (assuming
>   very small sk_rmem_alloc 426240 as the one you're reporting).
> 
>   Even if this does not fix your problem (you refer to 72k chars, not
>   sure how many commands this is), this is probably good to have
>   anyway, this decreasing memory consumption by 85%. This will also
>   make event reporting (monitor mode) more reliable through netlink
>   (it's the same codepath).

I didn't count the number of commands, but highly doubt it was even
close to 3000.

>   Note that userspace requires no changes to support batching mode:
>   libmnl's mnl_cb_run() keeps iterating over the buffer that was
>   received until all netlink messages are consumed.
> 
>   The quick patch is incomplete, I just want to prove the saving in
>   terms of memory. I'll give it another spin and submit this for
>   review.

Highly appreciated. Put me in Cc and I'll stress-test it a bit.

> * Probably recover the cookie idea: firewalld specifies a cookie
>   that identifies the rule from userspace, so there is no need for
>   NLM_F_ECHO. Eric mentioned he would like to delete rules by cookie,
>   this should be possible by looking up for the handle from the
>   cookie to delete rules. The cookie is stored in NFTA_RULE_USERDATA
>   so this is only meaningful to userspace. No kernel changes are
>   required (this is supported for a bit of time already).
> 
>   Note: The cookie could be duplicated. Since the cookie is allocated
>   by userspace, it's up to userspace to ensure uniqueness. In case
>   cookies are duplicated, if you delete a rule by cookie then
> 
>   Rule deletion by cookie requires dumping the whole ruleset though
>   (slow). However, I think firewalld keeps a rule cache, so it uses
>   the rule handle to delete the rule instead (no need to dump the
>   cache then). Therefore, the cookie is only used to fetch the rule
>   handle.
> 
>   With the rule cookie in place, firewalld can send the batch, then
>   make a NLM_F_DUMP request after sending the batch to retrieve the
>   handle from the cookie instead of using NLM_F_ECHO. The batch send +
>   NLM_F_DUMP barely consumes 16KBytes per recvmsg() call. The send +
>   dump is not atomic though.
> 
>   Because NLM_F_ECHO is only used to get back the rule handle, right?

The discussion that led to NLM_F_ECHO was to support atomic rule handle
retrieval. A user-defined "pseudo-handle" obviously can't uphold that
promise and therefore won't be a full replacement.

Apart from that, JSON echo output in it's current form is useful for
scripts to retrieve the handle. We've had that discussion already, I
pointed out they could just do 'input = output' and know
'input["nftables"][5]["add"]["rule"]["expr"][0]["match"]["right"]' is
still present and has the expected value.

I recently found out that firewalld (e.g.) doesn't even do that, but
instead manually iterates over the list of commands it got back and
extracts handle values. Doing that without NLM_F_ECHO but with cookies
instead means to add some rules, then list ruleset and search for one's
cookies.

That aside, if nftables doesn't support cookies beyond keeping them in
place, why not just use a custom comment instead? That's even
backwards-compatible.

Cheers, Phil
