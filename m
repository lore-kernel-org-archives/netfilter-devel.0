Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15610C6FD20
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Mar 2023 18:22:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbjCXSWf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjCXSWa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2023 14:22:30 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8DB20549;
        Fri, 24 Mar 2023 11:22:29 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pfm3V-0003Jh-Va; Fri, 24 Mar 2023 19:22:26 +0100
Date:   Fri, 24 Mar 2023 19:22:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, Florian Westphal <fw@strlen.de>,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC v2 bpf-next 1/3] bpf: add bpf_link support for
 BPF_NETFILTER programs
Message-ID: <20230324182225.GC1871@breakpoint.cc>
References: <20230302172757.9548-1-fw@strlen.de>
 <20230302172757.9548-2-fw@strlen.de>
 <ZAEG1gtoXl125GlW@google.com>
 <20230303002752.GA4300@breakpoint.cc>
 <20230323004123.lkdsxqqto55fs462@kashmir.localdomain>
 <CAKH8qBvw58QyazkSh2U80iVPmbMEOGY0T8dLKX5PWg4b+bxqMw@mail.gmail.com>
 <20230324173332.vt6wpjm4wqwcrdfs@kashmir.localdomain>
 <CAKH8qBtUD_Y=xwnwEmQ16rJBn7h+NQHL04YUyLAc5CGk1x1oNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKH8qBtUD_Y=xwnwEmQ16rJBn7h+NQHL04YUyLAc5CGk1x1oNg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stanislav Fomichev <sdf@google.com> wrote:
> > I'm not sure what you mean by "whole story" but netfilter kernel modules
> > register via a priority value as well. As well as the modules the kernel
> > ships. So there's that to consider.
> 
> Sorry for not being clear. What I meant here is that we'd have to
> export those existing priorities in the UAPI headers and keep those
> numbers stable. Otherwise it seems impossible to have a proper interop
> between those fixed existing priorities and new bpf modules?
> (idk if that's a real problem or I'm overthinking)

They are already in uapi and exported.
