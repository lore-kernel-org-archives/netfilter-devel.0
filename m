Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 045BBC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Apr 2022 14:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiDEOJW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Apr 2022 10:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356252AbiDELz3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 07:55:29 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBD62314E
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 04:15:25 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nbh9f-0002mY-Ik; Tue, 05 Apr 2022 13:15:23 +0200
Date:   Tue, 5 Apr 2022 13:15:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Lukas Straub <lukasstraub2@web.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: meta time broken
Message-ID: <Ykwky1PfNwYfPyRR@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Lukas Straub <lukasstraub2@web.de>, netfilter-devel@vger.kernel.org
References: <20220405011705.1257ac40@gecko>
 <20220405013128.0bb907e2@gecko>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220405013128.0bb907e2@gecko>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Lukas,

On Tue, Apr 05, 2022 at 01:31:28AM +0000, Lukas Straub wrote:
> On Tue, 5 Apr 2022 01:17:05 +0000
> Lukas Straub <lukasstraub2@web.de> wrote:
> 
> > Hello Everyone,
> > I want to set up a rule that matches as long as the current time (/time
> > of packet reception) is smaller than a given unix timestamp. However
> > the whole "meta time" expression seems to be broken. I can't get it to
> > work with either a unix timestamp or iso time. What's weird is that
> > after setting the rule and listing it again, it will always display a
> > date around 1970 instead of whatever was entered.
> > 
> > Reproducer:
> > nft "add chain inet filter prg_policy; flush chain inet filter prg_policy; add rule inet filter prg_policy meta time < $(date --date='now + 2 hours' '+%s') accept"
> > nft list chain inet filter prg_policy
> > 
> > Reproducer 2:
> > nft "add chain inet filter prg_policy; flush chain inet filter prg_policy; add rule inet filter prg_policy meta time \"2022-04-01 01:00\" - \"2022-04-10 01:00\" accept"
> > nft list chain inet filter prg_policy
> > 
> > nftables v1.0.2 (Lester Gooch)
> > Linux usbrouter 5.10.0-13-armmp #1 SMP Debian 5.10.106-1 (2022-03-17) armv7l GNU/Linux
> > 
> > Regards,
> > Lukas Straub
> > 
> 
> Hmm, after staring at the code for a bit. I could imagine it's due to
> time_t being 32 bit on my platform and nftables trying to stuff a unix
> timstamp with nanosecond resolution in it...

Thanks for the report. Can you try this patch?

------------------------8<-----------------------------
--- a/src/meta.c
+++ b/src/meta.c
@@ -405,7 +405,7 @@ static void date_type_print(const struct expr *expr, struct output_ctx *octx)
                nft_print(octx, "Error converting timestamp to printed time");
 }
 
-static time_t parse_iso_date(const char *sym)
+static uint64_t parse_iso_date(const char *sym)
 {
        struct tm tm, *cur_tm;
        time_t ts;
@@ -444,9 +444,9 @@ static struct error_record *date_type_parse(struct parse_ctx *ctx,
                                            struct expr **res)
 {
        const char *endptr = sym->identifier;
-       time_t tstamp;
+       uint64_t tstamp;
 
-       if ((tstamp = parse_iso_date(sym->identifier)) != -1)
+       if ((tstamp = parse_iso_date(sym->identifier)) != (uint64_t)-1)
                goto success;
 
        tstamp = strtoul(sym->identifier, (char **) &endptr, 10);
------------------------8<-----------------------------

Thanks, Phil
