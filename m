Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A24D7EB64DD
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 15:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjF0PpB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 11:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjF0Por (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 11:44:47 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34E4E68;
        Tue, 27 Jun 2023 08:44:45 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qEArv-00056u-Ur; Tue, 27 Jun 2023 17:44:39 +0200
Date:   Tue, 27 Jun 2023 17:44:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Daniel Xu <dxu@dxuuu.xyz>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, fw@strlen.de,
        daniel@iogearbox.net, dsahern@kernel.org
Subject: Re: [PATCH bpf-next 0/7] Support defragmenting IPv(4|6) packets in
 BPF
Message-ID: <20230627154439.GA18285@breakpoint.cc>
References: <cover.1687819413.git.dxu@dxuuu.xyz>
 <874jmthtiu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874jmthtiu.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > The basic idea is we bump a refcnt on the netfilter defrag module and
> > then run the bpf prog after the defrag module runs. This allows bpf
> > progs to transparently see full, reassembled packets. The nice thing
> > about this is that progs don't have to carry around logic to detect
> > fragments.
> 
> One high-level comment after glancing through the series: Instead of
> allocating a flag specifically for the defrag module, why not support
> loading (and holding) arbitrary netfilter modules in the UAPI?

How would that work/look like?

defrag (and conntrack) need special handling because loading these
modules has no effect on the datapath.

Traditionally, yes, loading was enough, but now with netns being
ubiquitous we don't want these to get enabled unless needed.

Ignoring bpf, this happens when user adds nftables/iptables rules
that check for conntrack state, use some form of NAT or use e.g. tproxy.

For bpf a flag during link attachment seemed like the best way
to go.

At the moment I only see two flags for this, namely
"need defrag" and "need conntrack".

For conntrack, we MIGHT be able to not need a flag but
maybe verifier could "guess" based on kfuncs used.

But for defrag, I don't think its good to add a dummy do-nothing
kfunc just for expressing the dependency on bpf prog side.
