Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 586C7C43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 18:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C7FD20B7C
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 18:30:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="DHTahOk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfDZSaC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 14:30:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46167 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfDZSaC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 14:30:02 -0400
Received: by mail-qt1-f195.google.com with SMTP id w26so5125234qto.13
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 11:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bVsuEnz9eb1rAPecZi3YdJfZvXeRPnKwGsG/VtQgvJg=;
        b=DHTahOk3x5n1t+8OKsygiaWWb+cc2kuiXgGgpHi31loXUW9TxmdMXhu5IDMsztIPzF
         wG37gMNRkEkN4DWwPGJjkSOvpjAENP/ce/GmI3pkNkLX9N5G1JifSdZOv/FBZ/qvreY+
         DdSBCvT4tTv8AcvkO53S+ybQmc7SAbRt8qwRxH3+Kn1yD9XqQFkVgUTw20RM+kJ+ieFj
         j0reCYhnapv+pwUZDjv9QrGfPz5BFelshzk020EUveZr5GumFXAUyXuxam2UgfMhn1La
         bGUBhcOc64mBgJkUMgbysoApo0YXYy+SpOs15QVb33E7R57yUPiGO4V4HPdnLSN/278V
         w3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bVsuEnz9eb1rAPecZi3YdJfZvXeRPnKwGsG/VtQgvJg=;
        b=VSUnG3cJpvBg+5db6KLNhqPFoyxey7W2rYbn5HS1R4oWBTcbTE7RA6Tq6RkXzFUwyn
         ON1rZC1qyOcc9nzj3BFxlRVZAVIKkt+zTRWX62+SclnrMlAEPPSXheSJF1IdWELhsx6K
         GWcFft0t+J6Ce5CiWlNuK15Tv9EBm2VRtIyiA4Ji+yYwpF5j6AgLGH6Kx+DNcjo/DXwn
         nkSdK7a17YJK6jYELTTwaMTvLpIWF1T+45BcU4xCn6szZG5LSEfKQicdoiRL0jx1MDec
         h01cmz2g/YRDVOw4/wHi/9q39U14Avc7RYKZz/+dau6j1fJ4zo0ic9CZ5h9MwTTrtXDh
         5z/w==
X-Gm-Message-State: APjAAAVKF6WgogLQ1AKZnadtxAhIJ7hOEQlPQnR3sNwKd4KUpHjCjPeE
        0UOZzQu8cCRuR0rKc/oVV6u/pQ==
X-Google-Smtp-Source: APXvYqwvOS3Zhh7XzMRCkCwpQFpeTLkEN0/Y2Mny09P5VnHcGafPrnIlDMBwu53t5usUF4EZ0B6gOA==
X-Received: by 2002:aed:2331:: with SMTP id h46mr15504807qtc.183.1556303400928;
        Fri, 26 Apr 2019 11:30:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o10sm112090qtg.5.2019.04.26.11.29.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Apr 2019 11:30:00 -0700 (PDT)
Date:   Fri, 26 Apr 2019 11:29:56 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, ogerlitz@mellanox.com
Subject: Re: [PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block
 callbacks from netfilter
Message-ID: <20190426112956.7bbd2b87@cakuba.netronome.com>
In-Reply-To: <20190426162836.6hy7q42b6itckzff@salvia>
References: <20190426003348.30745-1-pablo@netfilter.org>
        <20190426143258.GC2249@nanopsycho.orion>
        <20190426162836.6hy7q42b6itckzff@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 26 Apr 2019 18:28:36 +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 26, 2019 at 04:32:58PM +0200, Jiri Pirko wrote:
> > Fri, Apr 26, 2019 at 02:33:37AM CEST, pablo@netfilter.org wrote:  
> > >Hi,
> > >
> > >This patchset aims to introduce changes to reuse the existing .ndo_setup_tc
> > >netdev operations from netfilter.
> > >
> > >The idea is to move tcf_block_cb to net/core/flow_offload.c and rename
> > >it to flow_block_cb. This object provides the minimal infrastructure to
> > >set up per-block callbacks that are called to offload policies to
> > >hardware.
> > >
> > >The tcf_block object is specific for TC to share policies between
> > >ingress devices. This object has a list of tcf_block_cb objects that are
> > >called to offload the policies to hardware. In netfilter, the idea is to
> > >store the list of tcf_block_cb objects in a chain that would be bound to
> > >several devices, eg.
> > >
> > >  chain x {
> > >	type filter hook ingress devices = { eth0, eth1 } priority 0;
> > >	...
> > >  }
> > >  
> > 
> > Do you have the follow-up patchset somewhere? I'm curius about your
> > goal. Without that, it is hard to understand what you are getting at.  
> 
> Goal is to use the TC_SETUP_BLOCK logic in the existing drivers from
> netfilter. So Netfilter calls TC_SETUP_BLOCK by when a chain is set up
> to configure the driver, hence reuse your whole logic with minimal
> changes.
> 
> Currently, the tcf_block_cb_register() call assumes there's a
> tcf_block object in place and it internally invokes the tc
> .reoffload() callback. This tcf_block corresponds to the nft_chain
> object in netfilter, and I need to add my own .reoffload() callback
> for the nft_chain object. This patch uses the block_index instead from
> the driver, instead of exposing tcf_block.

block_index is non-0 only for shared blocks, right?  Did you change
that?

> This patchset updates the TC_SETUP_BLOCK path to only configure the
> block_cb objects. The registration is done from the core, by iterating
> the list of block_cb's that the driver offers in the temporary
> tc_block_offload->cb_list, and then iterate over that list and
> register them from the core.
> 
> My patchset moves the tcf_block_cb object to net/core/flow_offload.c
> (it renames it to flow_block_cb) so it can be used both by tc and
> netfilter.
> 
> Follow up patchset in netfilter calls TC_SETUP_BLOCK when the offloadi
> flag is set on. Then, it has its own version of tc_setup_cb_call(),
> which iterates over the block_cb() in this chain to reuse existing
> driver codebase.
> 
> > >Hence, this emulates the shared blocks available in TC that Jiri made.
> > >
> > >Note that the list of tcf_block_cb objects will be called to offload
> > >policies in this chain.  
> > 
> > So you are going to use chain_id (if there is anything like that) as
> > block_index during offload, right?  
> 
> Yes. But I don't need to expose this chain_index to userspace though,
> I can internally allocate it, I only need to make sure it does not
> overlap with any of the existing tc block_indexed. I can just use a
> different index space which does not overlap with the tc block index
> space.

How will the association between a block and a device work for
netfilter?
