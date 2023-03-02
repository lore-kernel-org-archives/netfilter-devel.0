Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27638C678D4
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 23:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCBXxE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 18:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCBXxD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 18:53:03 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9FDEFB0;
        Thu,  2 Mar 2023 15:53:02 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXsjM-00056o-32; Fri, 03 Mar 2023 00:53:00 +0100
Date:   Fri, 3 Mar 2023 00:53:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC v2 bpf-next 3/3] bpf: minimal support for programs
 hooked into netfilter framework
Message-ID: <20230302235300.GB9239@breakpoint.cc>
References: <20230302172757.9548-1-fw@strlen.de>
 <20230302172757.9548-4-fw@strlen.de>
 <87sfemexgf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sfemexgf.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> Florian Westphal <fw@strlen.de> writes:
> > +	case BPF_PROG_TYPE_NETFILTER:
> > +		return BTF_KFUNC_HOOK_SOCKET_FILTER;
> 
> The dynptr patch reuses the actual set between the different IDs, so
> this should probably define a new BTF_KFUNC_HOOK_NETFILTER, with an
> associated register_btf_kfunc_id_set() call?

Good point, the above was a kludge that I forgot about.

I will wait for dynptr patchset to land and will add new
BTF_KFUNC_HOOK_NETFILTER for next revision.
