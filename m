Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB901C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 10:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347155AbjKBKtq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 06:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbjKBKtm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 06:49:42 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F91E7
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 03:49:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560BCC433C8;
        Thu,  2 Nov 2023 10:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698922179;
        bh=F06E/qSqoXguczvI4wLaWEOmYvyI6n09I7fsqdUrQ4c=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Z7Lg4fqB0UOuyWSJWyJBjjFSpQrE5I30Cn0seKwSPnV2GVr9P8aIiw+u3sJQmGgDH
         9M0R0hoGA5w3kTzgvQrJy8OgA3NF10Z0DVwhFBlaKCcVPvHbB9W7GHR6Pc2WcW0Bjn
         poU8eJ2HVds3VX3OVxIH2ivRDbRSOnZ7yTar3cq3nMXCB4dpoCr74XHTgpjA6keOOL
         KJyCRdbQZERwH3u4lDcGPNCtNjEm1YpT08DQ0JtSA//19GbOdudCQfXspQAMLyU1r/
         yiWNoprxScPcnjlxlKm7hdhS1rOo9TXpdyos9PyQPXtsSd90k/Eh76ekyK/ZHyslBV
         uk1TgaGw4DDHw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 07929EE62FF; Thu,  2 Nov 2023 11:49:36 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: add flowtable map for xdp
 offload
In-Reply-To: <20231019202507.16439-1-fw@strlen.de>
References: <20231019202507.16439-1-fw@strlen.de>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 02 Nov 2023 11:49:36 +0100
Message-ID: <87il6k1lbz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> This adds a small internal mapping table so that a new bpf (xdp) kfunc
> can perform lookups in a flowtable.
>
> I have no intent to push this without nft integration of the xdp program,
> this RFC is just to get comments on the general direction because there
> is a chicken/egg issue:
>
> As-is, xdp program has access to the device pointer, but no way to do a
> lookup in a flowtable -- there is no way to obtain the needed struct
> without whacky stunts.

So IIUC correctly, this would all be controlled by userspace anyway (by
the nft binary), right? In which case, couldn't userspace also provide
the reference to the right flowtable instance, by sticking it into a bpf
map? We'd probably need some special handling on the UAPI side to insert
a flowtable pointer, but from the BPF side it could just look like a
kptr in a map that the program pulls out and passes to the lookup kfunc.
And the map would take a refcnt, making sure the table doesn't disappear
underneath the XDP program. It could even improve performance since
there would be one less hashtable lookup.

The drawback would be that this would make it harder to integrate into
other XDP data planes, as you'd need to coordinate with nft to keep the
right flowtable references alive even if nft doesn't control the XDP
program. But maybe that's doable, somehow?

[...]

> My thinking is to add a xdp-offload flag to the nft grammer only.
> Its not needed on nf uapi side and it would tell nft to attach the xdp
> flowtable forward program to the devices listed in the flowtable.
>
> Also, packet flow is altered (qdiscs is bypassed), which is a strong
> argument against default-usage.

I agree that at this point XDP has two many quirks to be something we
can turn on by default. However, I think we should support XDP data
planes that are not necessarily under the control of nft itself.
Specifically, I am planning to add an 'xdp-forward' utility to xdp-tools
which would enable a semi-automatic XDP fast path using both this and
other hooks like the fib lookup helper. So it would be nice to make the
different pieces as loosely coupled as is practical (cf what I wrote
above).

> Open questions:
>
> Do we need to support dev-in-multiple flowtables?  I would like to
> avoid this, this likely means the future "xdp" flag in nftables would
> be restricted to "inet" family.  Alternative would be to change the key to
> 'device address plus protocol family', the xdp prog could derive that from the
> packet data.

We can always start with the simple case and add more options later if
it turns out to be useful? With kfuncs we do have some flexibility in
terms of adjusting the API (although I think we should strive for
keeping it as stable as we can).

> Timeout handling.  Should the XDP program even bother to refresh the
> flowtable timeout?
>
> It might make more sense to intentionally have packets
> flow through the normal path periodically so neigh entries are up to
> date.

Hmm, I see what you mean, but I worry that this would lead to some nasty
latency blips when a flow transitions back and forth between kernel and
XDP paths. Also, there's a reordering problem as the state is changed:
the first goes through the stack, sets the flow state to active, then
gets transmitted. But while that sits in the qdisc waiting to go out on
the wire, the next packet arrives, gets handled by the XDP fastpath and
ends up overtaking the first packet on the TX side. Not sure we have a
good solution for this in general :(

-Toke
