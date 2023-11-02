Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C15ACC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346098AbjKBLHh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346709AbjKBLHg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:07:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D434DE
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:07:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CE9C433C9;
        Thu,  2 Nov 2023 11:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698923254;
        bh=ad4IBj21SsqT/yjfpnkwcK7UM9JyMwO629zauw9mebw=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kkYawknj3DoYV++c6kaYgMkzYU2jb4Z0w5113uC1sGmBrr1FJwK2HPpFNNupVaPMo
         T1Dluwh8UfGX1AEfgAdI8VfCcSa25lLu+++ef33OAMqxVtdsyEOHGHdh/sPNUwUycL
         Xze8MG6i14ruBZyhfE5xHJliE9N/Jy34Hu9cWjLADVtSQHJGcOfdflZN07yHl3Qd7V
         pVegnAOke6zVA/8mCyDNgTyK0+QQ5oq+WmJExhi1G/2KGJ95Ajs9f7i3fzNL8Glody
         ggN4MxkrW5buqU3JwSkGEYcWXGUIrKD4zEWxISdjR3fG+EZWdtIIHcBtFm2STR8aGk
         2mSplEWP3FeaA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6BD54EE6306; Thu,  2 Nov 2023 12:07:31 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
In-Reply-To: <20231102105434.GF6174@breakpoint.cc>
References: <20231019202507.16439-1-fw@strlen.de> <87il6k1lbz.fsf@toke.dk>
 <20231102105434.GF6174@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 02 Nov 2023 12:07:31 +0100
Message-ID: <87fs1o1ki4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> > It might make more sense to intentionally have packets
>> > flow through the normal path periodically so neigh entries are up to
>> > date.
>>=20
>> Hmm, I see what you mean, but I worry that this would lead to some nasty
>> latency blips when a flow transitions back and forth between kernel and
>> XDP paths. Also, there's a reordering problem as the state is changed:
>> the first goes through the stack, sets the flow state to active, then
>> gets transmitted. But while that sits in the qdisc waiting to go out on
>> the wire, the next packet arrives, gets handled by the XDP fastpath and
>> ends up overtaking the first packet on the TX side. Not sure we have a
>> good solution for this in general :(
>
> From nft based flowtable offload we already had a feature request to
> bounce flows back to normal path periodially, this was because people
> wanted to make sure that long-living flows get revalidated vs. current
> netfilter ruleset and not the one that was active at flow offload time.
>
> There was a patch for it, using a new sysctl, and author never came
> back with an updated patch to handle this via the ruleset instead.

Right, if there's an existing policy knob for this it makes sense to
support it in the XDP case as well, of course.

Does HW flow offload deal with that reordering case at all, BTW? I
assume it could happen for that as well?

-Toke
