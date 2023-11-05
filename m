Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E79C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 16:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjKEQ5A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 11:57:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjKEQ4n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 11:56:43 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C327D7F
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 08:56:34 -0800 (PST)
Received: from [78.30.35.151] (port=35248 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qzgQG-00AATC-VK; Sun, 05 Nov 2023 17:56:31 +0100
Date:   Sun, 5 Nov 2023 17:56:27 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 1/2] json: drop handling missing json() hook in
 expr_print_json()
Message-ID: <ZUfJO/X74Q4BHOkp@calendula>
References: <20231103162937.3352069-1-thaller@redhat.com>
 <20231103162937.3352069-2-thaller@redhat.com>
 <ZUVoLKrYbqHu6Hby@orbyte.nwl.cc>
 <ff945f754eb5a12409563d0aca79a0d2e10fb157.camel@redhat.com>
 <ZUdxFhzlm42rDpC3@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZUdxFhzlm42rDpC3@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Nov 05, 2023 at 11:40:22AM +0100, Phil Sutter wrote:
> On Sat, Nov 04, 2023 at 06:28:30AM +0100, Thomas Haller wrote:
> > On Fri, 2023-11-03 at 22:37 +0100, Phil Sutter wrote:
> > > On Fri, Nov 03, 2023 at 05:25:13PM +0100, Thomas Haller wrote:
> > > [...]
> > > > +	/* The json() hooks of "symbol_expr_ops" and
> > > > "variable_expr_ops" are
> > > > +	 * known to be NULL, but for such expressions we never
> > > > expect to call
> > > > +	 * expr_print_json().
> > > > +	 *
> > > > +	 * All other expr_ops must have a json() hook.
> > > > +	 *
> > > > +	 * Unconditionally access the hook (and segfault in case
> > > > of a bug).  */
> > > > +	return expr_ops(expr)->json(expr, octx);
> > > 
> > > This does not make sense to me. You're deliberately dropping any
> > > error
> > > handling
> > 
> > Error handling for what is clearly a bug. Don't try to handle bugs.
> > Avoid bugs and fix them.
> 
> Yeah, indeed. Let's go ahead and drop all BUG() statements as well.
> Seriously, I doubt nftables users agree the software should segfault
> instead of aborting with an error message.

BUG() assertion is better than crash.

> > > and accept a segfault because "it should never happen"? All it
> > > takes is someone to add a new expression type and forget about the
> > > JSON
> > > API.
> > 
> > There will be a unit test guarding against that, once the unit test
> > basics are done.
> > 
> > Also, if you "forget" to implement the JSON hook and test it (manually)
> > only a single time, then you'll notice right away.
> 
> Actually, all it takes to notice things don't add up is running the py
> testsuite with '-j' arg after adding the obligatory "unit" tests there.
> Feel free to search the git history for late additions of .json
> callbacks. I think the message is pretty clear.
> 
> > > If you absolutely have to remove that fallback code, at least add a
> > > BUG() explaining the situation. The sysadmin looking at the segfault
> > > report in syslog won't see your comment above.
> > 
> > I am in favor of adding assertions all over the place. The project
> > doesn't use enough asserions for my taste.
> > 
> > In this case, it seems hard to mess up the condition, and you get a
> > very clear signal when you do (segfault). That makes the assert()/BUG()
> > kinda unecessary.
> 
> The clear signal being "oops, my program crashed" when it could be a
> dubious "oops, there is no JSON callback for this expression type".

This should be turned into BUG().
