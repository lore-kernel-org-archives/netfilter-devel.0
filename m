Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C755C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 11:25:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjKBLZ3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 07:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjKBLZ2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 07:25:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B15130
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 04:25:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1B8C433C8;
        Thu,  2 Nov 2023 11:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698924325;
        bh=0K6lNY7vJk41x0UTlBlOEXgcwqyCWyUk6n6SyDpyYlk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=jO3baClmhdoYxGbIl4Qo+i2ddrbqiB8+FyCrqC09kOIpo2mvGArdCa4/vMzGc4hgf
         9zTDASYVxvtTsynTEQpkQR41pPC8IVXlhh0pyid0utWNNh9K//9rQ5NDHNX0mq1+RM
         XFg8HDyI1Bar6oO2vVUXDT5VO1QZYO8mpxJ3Ix1BGzhUGhuAipgTgsdVw9DS4mBgV5
         Rk6+iFU2pb/fwhVsHIJhrnK2zvrCEgdRUM/qWKugFRaTbDY1KBL7rkKGeZIaV/asjP
         wVo7QsIe7yqMwPJdSCj1U5p7P/Bk4NZrkXjS1GL7Z5nVBlrzYfAVLOQlYzKO15/7sq
         TcLmU5HxIixlA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 254D4EE630B; Thu,  2 Nov 2023 12:25:23 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
In-Reply-To: <20231102110712.GG6174@breakpoint.cc>
References: <20231019202507.16439-1-fw@strlen.de> <87il6k1lbz.fsf@toke.dk>
 <20231102110712.GG6174@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 02 Nov 2023 12:25:23 +0100
Message-ID: <87cyws1joc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> So IIUC correctly, this would all be controlled by userspace anyway (by
>> the nft binary), right? In which case, couldn't userspace also provide
>> the reference to the right flowtable instance, by sticking it into a bpf
>> map? We'd probably need some special handling on the UAPI side to insert
>> a flowtable pointer, but from the BPF side it could just look like a
>> kptr in a map that the program pulls out and passes to the lookup kfunc.
>> And the map would take a refcnt, making sure the table doesn't disappear
>> underneath the XDP program. It could even improve performance since
>> there would be one less hashtable lookup.
>
> That requires kernel changes.

Well, you started this thread with a kernel patch, so presumably we need
kernel changes in any case? ;)

> Not only are flowtables not refcounted at this time, we also have no
> unique identifier in the uapi; only a combination (table name, family,
> flowtable name, OR table name and handle id).

But presumably that combination is enough to uniquely identify a table,
right? So we could just use the same tuple in the map insert API.
Doesn't *have* to be a numeric unique ID. And you were talking about
adding refcnts anyway in your follow-up message?

I'm not saying it's entirely a slam dunk, but having the reference to
flowtable entries be managed out of band does add a lot of flexibility
on the BPF side; in that sense it's analogous to how BPF map references
are handled.

> Also all of netfilter userland is network namespaced, so same keys
> can exist in different net namespaces.

XDP is namespaced as well, conceptually. I.e., ifindexes are used to
refer to interfaces, and a device will be removed from a devmap if it is
moved to a different namespace, that sort of thing.

-Toke
