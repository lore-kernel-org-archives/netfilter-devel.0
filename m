Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01F9C43334
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jul 2022 18:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiGDSDa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Jul 2022 14:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiGDSD3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Jul 2022 14:03:29 -0400
Received: from janet.servers.dxld.at (mail.servers.dxld.at [5.9.225.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4ABDFCB
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jul 2022 11:03:26 -0700 (PDT)
Received: janet.servers.dxld.at; Mon, 04 Jul 2022 20:03:09 +0200
Date:   Mon, 4 Jul 2022 20:03:04 +0200
From:   Daniel =?utf-8?Q?Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     Peter Tirsek <peter@tirsek.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] Allow resetting the include search path
Message-ID: <20220704180304.6y25nkk3bzqc3nh4@House>
References: <Yrs2nn/amfnaUDk8@salvia>
 <Yrs3kkbc4z5AMF+W@salvia>
 <20220628190101.76cmatthftrsxbja@House>
 <YryJ1NXNy5zZb5r+@salvia>
 <20220630205620.cy5qblj2zq5pwjaw@House>
 <974e8f58-f902-6cbe-08d6-81b5bfb3a710@wolfie.tirsek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <974e8f58-f902-6cbe-08d6-81b5bfb3a710@wolfie.tirsek.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 30, 2022 at 08:31:14PM -0500, Peter Tirsek wrote:
> On Thu, 30 Jun 2022, Daniel Gröber wrote:
> > This works all fine and dandy when only one nftables.conf file is involved,
> > but as soon as I have includes I need to deploy the entire config directory
> > tree somewhere out-of-the-way.
> 
> We're probably getting a little off topic for netfilter-devel, but could you
> do this using a mount namespace? For example (as root, since you indicated
> that you want to really load the actual ruleset into the main firewall):

I considered that too, but it's kind of like slicing butter with a chainsaw :)

--Daniel
