Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A562C636CC
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Jan 2023 16:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbjAaQUE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Jan 2023 11:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbjAaQTu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Jan 2023 11:19:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC5438B7E;
        Tue, 31 Jan 2023 08:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25BDC614B3;
        Tue, 31 Jan 2023 16:19:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F7CC4339B;
        Tue, 31 Jan 2023 16:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675181952;
        bh=tDDUfSybB4HvCdA8+PCCDDKv98ZHl5nNaEpRIf5LNog=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=eohZimoqe5c87o2FNSERpD9Wcz0Eb6dmE6L8aD4q853DhPZ543yQUyamLsNbGOIVJ
         loqjlzRVV9T1zDryAZRLcUt0vcBWLNZaHKAzKFSuz71XnPekEdLPh5/p8UlXVNIdYf
         Ps+l4su6iFWYIvxwj0piAJklFl1t5zVN4/KHp9YDJ1aIoHzZac+fbwXwRk4MIumetq
         llx+RFXbt+uRaIQ52CJVTiRtG2p3mWZ60cykcCR0yIHz+uncCVtaCajK2jWo1oDI4E
         z7woI84ABbDfjLY2u594PnsUAKo/pS+TF6qn9+rrjg2GktCXRLjeggfocTVScYZM/K
         tgkzqblKLCXgA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 26B1C97281D; Tue, 31 Jan 2023 17:19:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [RFC] bpf: add bpf_link support for BPF_NETFILTER programs
In-Reply-To: <20230131141815.GA6999@breakpoint.cc>
References: <20230130150432.24924-1-fw@strlen.de> <87zg9zx6ro.fsf@toke.dk>
 <20230130180115.GB12902@breakpoint.cc>
 <20230130214442.robf7ljttx5krjth@macbook-pro-6.dhcp.thefacebook.com>
 <20230131141815.GA6999@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 31 Jan 2023 17:19:09 +0100
Message-ID: <878rhivfr6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

>> The prog will get a defition of 'struct nf_hook_state' from vmlinux.h
>> or via private 'struct nf_hook_state___flavor' with few fields defined
>> that prog wants to use. CORE will deal with offset adjustments.
>> That's a lot less kernel code. No need for asm style ctx rewrites.
>> Just see how much kernel code we already burned on *convert_ctx_access().
>> We cannot remove this tech debt due to uapi.
>> When you pass struct nf_hook_state directly none of it is needed.
>
> Ok, thanks for pointing that out.  I did not realize
> convert_ctx_access() conversions were frowned upon.
>
> I will pass a known/exposed struct then.
>
> I thought __sk_buff was required for direct packet access, I will look
> at this again.

Kartikeya implemented direct packet access for struct xdp_md passed as a
BTF ID for use in the XDP queueing RFC. You could have a look at that as
a reference for how to do this for an sk_buff as well:

https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/commit/?h=xdp-queueing-07&id=3b4f3caaf59f3b2a7b6b37dfad96b5e42347786a

It does involve a convert_ctx_access() function, though, but for the BTF
ID. Not sure if there's an easier way...

-Toke
