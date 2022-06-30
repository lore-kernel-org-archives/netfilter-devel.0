Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35831C43334
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jun 2022 20:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiF3U42 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jun 2022 16:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiF3U41 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jun 2022 16:56:27 -0400
Received: from janet.servers.dxld.at (unknown [5.9.225.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790184477E
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2022 13:56:26 -0700 (PDT)
Received: janet.servers.dxld.at; Thu, 30 Jun 2022 22:56:23 +0200
Date:   Thu, 30 Jun 2022 22:56:20 +0200
From:   Daniel =?utf-8?Q?Gr=C3=B6ber?= <dxld@darkboxed.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] Allow resetting the include search path
Message-ID: <20220630205620.cy5qblj2zq5pwjaw@House>
References: <Yrs2nn/amfnaUDk8@salvia>
 <Yrs3kkbc4z5AMF+W@salvia>
 <20220628190101.76cmatthftrsxbja@House>
 <YryJ1NXNy5zZb5r+@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YryJ1NXNy5zZb5r+@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 29, 2022 at 07:20:20PM +0200, Pablo Neira Ayuso wrote:
> You also consider that using absolute path in includes is suboptimal?

Yeah sorry forgot to mention, using absolute paths defeats the use-case
entirely.

> > I think my patch is a much cleaner and general solution.
> 
> I might be missing anything, could you describe your use-case?

Ok so what I want to do is load an about to be deployed nftables config
without making it permanent yet as it might be buggy and cause an ssh
lockout. To prevent this I first load the temporary config with `nft -f`,
check ssh still works and only then commit the config to the final location
in /etc.

This works all fine and dandy when only one nftables.conf file is involved,
but as soon as I have includes I need to deploy the entire config directory
tree somewhere out-of-the-way.

If I use absolute paths then I'd have to put the new config in it's
permanent location immediately that defeats the purpose of this :)

If I use relative paths the success of the `nft -f` call depends on its
$PWD which as we've established would work but sucks for usability.

We have this nice search path mechanism already though, but if I just use
just the existing -I option, which appends to the search path, the existing
stuff in /etc takes precedence. Hence this patch, with it I can deploy to
say /tmp/nft.tmp/, load the config with `nft -I "" -I /tmp/nft.tmp -f ...`
and then commit if connectivity checks are successful.

--Daniel
