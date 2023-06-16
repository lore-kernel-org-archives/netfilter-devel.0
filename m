Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98830EB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Jun 2023 16:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjFPQW5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jun 2023 12:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbjFPQWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2023 12:22:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF918359F
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2023 09:22:38 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qACDc-0004dI-UC; Fri, 16 Jun 2023 18:22:36 +0200
Date:   Fri, 16 Jun 2023 18:22:36 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Developer Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Subject: Re: [iptables PATCH] xshared: fix memory leak in should_load_proto
Message-ID: <ZIyMTLdEV3XCIoDZ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
References: <20230529171846.10616-1-ansuelsmth@gmail.com>
 <rpro25oo-2036-33rr-4258-o15rn7665o73@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rpro25oo-2036-33rr-4258-o15rn7665o73@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Tue, May 30, 2023 at 06:11:09PM +0200, Jan Engelhardt wrote:
[...]
> After 13 years, the code I once wrote feels weird. In essence, find_proto is
> called twice, but that should not be necessary because cs->proto_used already
> tracks whether this was done.
> [e.g. use `iptables -A INPUT -p tcp --dport 25 --unrecognized` to trigger]
> 
> Could someone cross check my alternative proposal I have below?

Thanks for the fix! Patch applied with minor subject and whitespace
fixes.
