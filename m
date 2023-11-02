Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CF7C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347123AbjKBLHS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346098AbjKBLHR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:07:17 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCC2E7
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:07:14 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qyVXc-00072X-3z; Thu, 02 Nov 2023 12:07:12 +0100
Date:   Thu, 2 Nov 2023 12:07:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
Message-ID: <20231102110712.GG6174@breakpoint.cc>
References: <20231019202507.16439-1-fw@strlen.de>
 <87il6k1lbz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87il6k1lbz.fsf@toke.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> So IIUC correctly, this would all be controlled by userspace anyway (by
> the nft binary), right? In which case, couldn't userspace also provide
> the reference to the right flowtable instance, by sticking it into a bpf
> map? We'd probably need some special handling on the UAPI side to insert
> a flowtable pointer, but from the BPF side it could just look like a
> kptr in a map that the program pulls out and passes to the lookup kfunc.
> And the map would take a refcnt, making sure the table doesn't disappear
> underneath the XDP program. It could even improve performance since
> there would be one less hashtable lookup.

That requires kernel changes.  Not only are flowtables not refcounted
at this time, we also have no unique identifier in the uapi; only a
combination (table name, family, flowtable name, OR table name and
handle id).

Also all of netfilter userland is network namespaced, so same keys
can exist in different net namespaces.
