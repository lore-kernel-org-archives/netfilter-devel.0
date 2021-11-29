Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6D7C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Nov 2021 22:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234566AbhK2Wlu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbhK2Wky (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Nov 2021 17:40:54 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F1FC08E9BC
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Nov 2021 14:02:57 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mroje-00035G-RK; Mon, 29 Nov 2021 23:02:54 +0100
Date:   Mon, 29 Nov 2021 23:02:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Garver <eric@garver.life>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: nat: force port remap to prevent shadowing
 well-known ports
Message-ID: <20211129220254.GA17540@breakpoint.cc>
References: <20211129144218.2677-1-fw@strlen.de>
 <YaU2gndowxjvV+zn@egarver.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaU2gndowxjvV+zn@egarver.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eric Garver <eric@garver.life> wrote:
> On Mon, Nov 29, 2021 at 03:42:18PM +0100, Florian Westphal wrote:
> > If destination port is above 32k and source port below 16k
> > assume this might cause 'port shadowing' where a 'new' inbound
> > connection matches an existing one, e.g.
> 
> How did you arrive at 16k?

I had to pick some number.  1k is too low since some administrative
portals (or openvpn for that matter) are on ports above that.

I wanted to pick something that would not kick in for most cases.
16k just seemed like a good compromise, thats all.
