Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F7DC43219
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 10:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbiKWKIx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 05:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237107AbiKWKHY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 05:07:24 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02034252AA
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 01:57:48 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1oxmVm-0008CN-OT; Wed, 23 Nov 2022 10:57:46 +0100
Date:   Wed, 23 Nov 2022 10:57:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables-nft RFC 4/5] xlate-test: extra-escape of '"' for
 replay mode
Message-ID: <Y33umrZw65PK+m3N@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221121111932.18222-1-fw@strlen.de>
 <20221121111932.18222-5-fw@strlen.de>
 <Y3zwH69RX+1XjnTM@orbyte.nwl.cc>
 <20221122160128.GA10048@breakpoint.cc>
 <Y3z3Lxwh+RQUSJfG@orbyte.nwl.cc>
 <20221123093154.GB10048@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123093154.GB10048@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 23, 2022 at 10:31:54AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Tue, Nov 22, 2022 at 05:01:28PM +0100, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > On Mon, Nov 21, 2022 at 12:19:31PM +0100, Florian Westphal wrote:
> > > > > Before, nft fails to restore some rules because it sees:
> > > > > insert rule ip filter INPUT iifname iifname ip ...
> > > > > 
> > > > > Add extra escaping for " so that the shell won't remove it and
> > > > > nft will see 'iifname "iifname"'.
> > > > 
> > > > This is fixing up the wrong side, see:
> > > 
> > > Not sure what you mean here.
> > > 
> > > The quotes ARE printed, but the shell strips them away.
> > > 
> > > > struct xt_xlate_{mt,tg}_params::escape_quotes
> > > 
> > > Ick.
> > > 
> > > > this is set if iptables-translate was called and unset if
> > > > iptables-restore-translate was called. I didn't invent this, but the
> > > > logic seems to be escape quotes when printing a command, don't when
> > > > printing a dump file content.
> > > > 
> > > > I have a patch in my queue which extends the conditional quoting to
> > > > interface names. Will submit it later today along with other fixes in
> > > > that corner.
> > > 
> > > I would prefer to rip this out, I don't think any of the tools should
> > > print '\"' instead of '"'.
> > 
> > Either way is fine with me. See how I explicitly call 'echo "<input>" |
> > nft -f -' in xlate-test.py to force evaluation by the shell - an earlier
> > version of that code would break since nft saw the escapes. So *we*
> > don't need them, but one could argue it educates users that they'll have
> > to escape the quotes if they specify them on command line.
> 
> What if we replace:
> iptables-translate  -A INPUT -j LOG --log-prefix "foo bar"
> nft add rule ip filter INPUT counter log prefix \"foo bar\"
> 
> With
> nft add rule ip filter INPUT 'counter log prefix "foo bar"'
> 
> IOW, get rid of all escaped_quotes code and change:
> 
> -       printf("%s\n", xt_xlate_rule_get(xl));
> +
> +       if (cs->restore)
> +               printf("%s\n", xt_xlate_rule_get(xl));
> +       else
> +               printf("'%s'\n", xt_xlate_rule_get(xl));
> 
> 
> ... this would always place everything rule-related printed by xtables-translate in
> single quotes while leaving iptables-restore-translate alone.
> 
> What do you think?

This looks like a very nice solution to eliminate the conditional
escaping all over the place! Obviously, it means a mass-update of all
txlate files.

Thanks, Phil
