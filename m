Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9186FA3740
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Oct 2022 13:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236289AbiJ0NvA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 09:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiJ0Nu6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 09:50:58 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EF616021F
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2022 06:50:56 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9ECFC5C0124;
        Thu, 27 Oct 2022 09:50:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 27 Oct 2022 09:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1666878653; x=1666965053; bh=GT1wmehIgP
        NbEdpw2y2e6dF/d/3VTZsVzTiEC6avrx0=; b=w1+BRk++foYBVX+RA7CcFlWWLO
        /h1n5P7VRrjnscLrdGZvSTPPiotPF1srokSm1K17xPMW7YIrRO0RXyhpJAYc2Ivy
        HcwaG8yzcN25YIQ6RPKX1FAI3pWaBMyOcBC7U1rz6fq40gRR517Hxje52iKEuWDv
        wi7LBHx1vSmRrDo+OmzmZncGH2KXKN3bY+lA+QBFOVbIjfbkYmuDvleHvbv+VKDz
        U6j0zvg5mkasUDwxYs5kAe+0dLkz/XXw+Jhm6wmvO1oPj38r5ZwvkZcQnRY5JHbM
        x0WBBHre5FO0sv+9g8QfqcMhfjYtvTg6MSVMpuaumJsVx8MfYvxRFtqsimBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1666878653; x=1666965053; bh=GT1wmehIgPNbEdpw2y2e6dF/d/3V
        TZsVzTiEC6avrx0=; b=df8ZWNcEWrWlqXcTmuuix2einAJLW3xYsnV5kb6CdqQJ
        Bk2YrADQvgM9FIzqp5SWuyuY3NfrOC48TrWX6/ssfmQmirs8f0IcPDdDOF2sWCum
        D7BR0QiP0wEeLDrkCuMwb/h8eWj4toyRtm/HVUzydPyz23LOv34DRy92TmT0t6/3
        Em5D8n4AcM96h5zS5VXN/PqBNFHCbAUyQwqyV0Ya+yUCe7jMj4XqQYlJXPUVEr4L
        cm6e6ZnMgz26IJY68FXrT0lwHOVnZBmBArzdVPt9CIg8oda8ou5eKEELdnc0Dzlb
        XWX8pK+cgzFNzOL9/TbHzgqr9YbDERn+UDPvgx2Pkg==
X-ME-Sender: <xms:vYxaY8yENIVyHRYXrONYuyPUXX4SEa1l21F_5memI2P2K4f0W6NLyQ>
    <xme:vYxaYwTvsYKEXDw6hOkdzGWc-lXfsyvbsylnjKBhnkXdsgzMAs9jnIR_TmpbLawc4
    UauB7Z661v4LL85jA>
X-ME-Received: <xmr:vYxaY-W0kEmgA03jdYuHL2nLH_IJ9RRWOQje1XN6D-Pqghetoy4M2dGmZuH2WKQI7KBucu4kGY8BzkvZ7KIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdeggdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdefhedmnecujfgurhepfffhvfevuffkfhggtggujgesthdtredttddt
    vdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpeevuddugeeihfdtffehgffgudeggeegheetgfevhfekkeeileeu
    ieejleekiedvgfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:vYxaY6gvIvNfl_O6iX4N1ZH6okeVNcIxonZZU9C-pwCmLgsMqYSRxg>
    <xmx:vYxaY-D-ghdrm1HpWeQdtu4zINCyh_wTwo4vKtfX27hRQTbCLKQo2A>
    <xmx:vYxaY7JhKmt2QU_VcL-91bwj3pKtzHSMFzE8e_tYNTzrSctlp6oGIg>
    <xmx:vYxaY_6HoOkgdmZPTidK_fSrRmwQ3afE3swR4sjxpnbckqXeOFbk5A>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Oct 2022 09:50:51 -0400 (EDT)
Date:   Thu, 27 Oct 2022 07:50:58 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: enforce documented limit to prevent
 allocating huge memory
Message-ID: <20221027135058.kziqivpvvq7iqk67@k2>
References: <20221027131022.212948-1-kadlec@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027131022.212948-1-kadlec@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 27, 2022 at 03:10:22PM +0200, Jozsef Kadlecsik wrote:
> Daniel Xu reported that the hash:net,iface type of the ipset subsystem does
> not limit adding the same network with different interfaces to a set, which
> can lead to huge memory usage or allocation failure.
> 
> The quick reproducer is
> 
> $ ipset create ACL.IN.ALL_PERMIT hash:net,iface hashsize 1048576 timeout 0
> $ for i in $(seq 0 100); do /sbin/ipset add ACL.IN.ALL_PERMIT 0.0.0.0/0,kaf_$i timeout 0 -exist; done
> 
> The backtrace when vmalloc fails:
> 
>         [Tue Oct 25 00:13:08 2022] ipset: vmalloc error: size 1073741848, exceeds total pages
>         <...>
>         [Tue Oct 25 00:13:08 2022] Call Trace:
>         [Tue Oct 25 00:13:08 2022]  <TASK>
>         [Tue Oct 25 00:13:08 2022]  dump_stack_lvl+0x48/0x60
>         [Tue Oct 25 00:13:08 2022]  warn_alloc+0x155/0x180
>         [Tue Oct 25 00:13:08 2022]  __vmalloc_node_range+0x72a/0x760
>         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_add+0x7c0/0xb20
>         [Tue Oct 25 00:13:08 2022]  ? __kmalloc_large_node+0x4a/0x90
>         [Tue Oct 25 00:13:08 2022]  kvmalloc_node+0xa6/0xd0
>         [Tue Oct 25 00:13:08 2022]  ? hash_netiface4_resize+0x99/0x710
>         <...>
> 
> The fix is to enforce the limit documented in the ipset(8) manpage:
> 
> >  The internal restriction of the hash:net,iface set type is that the same
> >  network prefix cannot be stored with more than 64 different interfaces
> >  in a single set.
> 
> Reported-by: Daniel Xu <dxu@dxuuu.xyz>
> Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Works for me.

Tested-by: Daniel Xu <dxu@dxuuu.xyz>

Thanks,
Daniel
