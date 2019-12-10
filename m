Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D622C43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:21:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A21B2073B
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 11:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfLJLVn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 06:21:43 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:44200 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726915AbfLJLVm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 06:21:42 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iedaG-0005Wp-EN; Tue, 10 Dec 2019 12:21:40 +0100
Date:   Tue, 10 Dec 2019 12:21:40 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, biebl@debian.org, eric@garver.life
Subject: Re: [nft PATCH] py: load the SONAME-versioned shared object
Message-ID: <20191210112140.GA20005@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netfilter-devel@vger.kernel.org, biebl@debian.org, eric@garver.life
References: <157597564558.35612.1732679016499221966.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157597564558.35612.1732679016499221966.stgit@endurance>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Dec 10, 2019 at 12:00:45PM +0100, Arturo Borrero Gonzalez wrote:
> Instruct the python module to load the SONAME versioned shared object.
> 
> Normal end-user systems may only have available libnftables.so.1.0.0 and not
> libnftables.so which is usually only present in developer systems.
> 
> In Debian systems, for example:
> 
>  % dpkg -L libnftables1 | grep so.1
>  /usr/lib/x86_64-linux-gnu/libnftables.so.1.0.0
>  /usr/lib/x86_64-linux-gnu/libnftables.so.1
> 
>  % dpkg -L libnftables-dev | grep so
>  /usr/lib/x86_64-linux-gnu/libnftables.so
> 
> The "1" is not a magic number, is the SONAME of libnftables in the current
> version, as stated in Make_global.am.

My intention was to avoid the SONAME dependency, but you're right - it
causes more trouble than good. Who knows, maybe nftables.py does at some
point depend on a specific libntables version.

> Reported-by: Michael Biebl <biebl@debian.org>
> Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>

Feel free to push this out, Arturo.

Thanks, Phil
