Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EA1C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 10:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 869722065C
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 10:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgHDKc4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 06:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgHDKcz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 06:32:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B20C06174A
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 03:32:55 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k2uFH-00016Q-56; Tue, 04 Aug 2020 12:32:35 +0200
Date:   Tue, 4 Aug 2020 12:32:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     "Jose M. Guisado" <guigom@riseup.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
Subject: Re: [PATCH nft v2 1/1] src: enable output with "nft --echo --json"
 and nftables syntax
Message-ID: <20200804103235.GU13697@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Jose M. Guisado" <guigom@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <erig@erig.me>
References: <20200731000020.4230-2-guigom@riseup.net>
 <20200731092212.GA1850@salvia>
 <20200731123342.GF13697@orbyte.nwl.cc>
 <20200731125825.GA12545@salvia>
 <20200731134828.GG13697@orbyte.nwl.cc>
 <20200731173028.GA16302@salvia>
 <20200801000213.GN13697@orbyte.nwl.cc>
 <20200801192730.GA5485@salvia>
 <20200803125210.GR13697@orbyte.nwl.cc>
 <7f2e0b36-bdd4-9de6-8306-cc54e84c8688@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f2e0b36-bdd4-9de6-8306-cc54e84c8688@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Aug 04, 2020 at 12:20:05PM +0200, Jose M. Guisado wrote:
> On 3/8/20 14:52, Phil Sutter wrote:
> > On Sat, Aug 01, 2020 at 09:27:30PM +0200, Pablo Neira Ayuso wrote:
> >> We need an unified way to deal with --json --echo, whether the input
> >> is native nft or json syntax.
> > 
> > We don't need, but seems we want. We have JSON output and JSON echo for
> > a while now and code for both is distinct. I fail to see why this was OK
> > but is no longer. From my perspective, Jose simply failed to see that
> > JSON output code should be used for JSON echo if input is not JSON.
> 
> I will send a v4 for this patch honoring separate cases.
> 
> Only outputting JSON command objects when input has been native instead 
> of JSON, for the latter the behavior is kept intact and no 
> json_cmd_assoc is touched. I think that's what we are looking for right 
> now. This shouldn't interfere with firewalld, right?.

Sounds good. Unless I'm mistaken, all that's needed is to skip the call
to json_events_cb() (including the return) in netlink_echo_callback() if
input was not JSON, i.e. nft_ctx->json_root is NULL.

Cheers, Phil
