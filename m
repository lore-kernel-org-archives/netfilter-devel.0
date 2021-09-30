Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D678C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 10:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D3061267
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 10:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350033AbhI3Kk0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 06:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349928AbhI3Kk0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 06:40:26 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC48DC06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 03:38:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1mVtSa-0005e4-5v; Thu, 30 Sep 2021 12:38:40 +0200
Date:   Thu, 30 Sep 2021 12:38:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Senthil Kumar Balasubramanian <senthilb@qubercomm.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: ebtables behaving weirdly on MIPS platform
Message-ID: <20210930103840.GP32194@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Senthil Kumar Balasubramanian <senthilb@qubercomm.com>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <CA+6nuS7f=bLh56k463rJSPn7P3PvwW-kzAz2oYx2wiw24_9_Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+6nuS7f=bLh56k463rJSPn7P3PvwW-kzAz2oYx2wiw24_9_Mw@mail.gmail.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Sep 30, 2021 at 11:53:32AM +0530, Senthil Kumar Balasubramanian wrote:
> We are running OpenWRT/Tp-Link Archer A6 HW v2... (openwrt : 21.02
> ebtables v2.0.10-4)
> 
> and when we run this ebtables with nflog extension as mentioned below
> 
> ebtables -I FORWARD -o eth1 -p ip  --ip-protocol udp --ip-source-port
> 68 --nflog-group 1  --nflog-prefix "ENTRY1" -j ACCEPT
> 
> , we are running into the following issues..
> 
> Unable to update the kernel. Two possible causes:
> 1. Multiple ebtables programs were executing simultaneously. The ebtables
>    userspace tool doesn't by default support multiple ebtables programs running
>    concurrently. The ebtables option --concurrent or a tool like flock can be
>    used to support concurrent scripts that update the ebtables kernel tables.
> 2. The kernel doesn't support a certain ebtables extension, consider
>    recompiling your kernel or insmod the extension.
> 
> We have confirmed the required kernel configs are enabled and ensured
> the same with a ARM platform where the same command works..
> 
> However, dumping the data that goes to the kernel, we see a huge
> difference between MIPS and ARM..
> 
> in ARM platform
>  w_l->w:
>   0000  6e 66 6c 6f 67 00 ff b6 00 00 00 00 00 00 00 00  nflog...........
>   0010  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   0020  50 00 00 00 00 00 00 00 01 00 01 00 00 00 00 00  P...............
>   0030  45 4e 54 52 59 31 00 00 00 00 00 00 00 00 00 00  ENTRY1..........
>   0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   0070  00 00 00 00
> 
> in tplink a6 (MIPS platform)
> 
>  w_l->w:
>   0000  6e 66 6c 6f 67 00 b2 e0 69 6d 69 74 20 65 78 63    nflog...imit exc
>   0010  65 65 64 65 64 00 56 69 72 74 75 61 6c 20 74 69    eeded.Virtual ti
>   0020  00 00 00 50 65 78 70 69 00 01 00 01 50 72 6f 66     ...Pexpi....Prof
>   0030  45 4e 54 52 59 31 00 69 6d 65 72 20 65 78 70 69    ENTRY1.imer expi
>   0040  72 65 64 00 57 69 6e 64 6f 77 20 63 68 61 6e 67     red.Window chang
>   0050  65 64 00 49 2f 4f 20 70 6f 73 73 69 62 6c 65 00        ed.I/O possible.
>   0060  50 6f 77 65 72 20 66 61 69 6c 75 72 65 00 42 61       Power failure.Ba
>   0070  64 20 73 79
>               d sy
> 
> Can you please let me know what's going wrong with this?

Looks like the data structure contains garbage. Looking at ebtables
code, that seems likely as extension data structures are allocated using
malloc() and never set zero. init() function in ebt_nflog.c only
initializes prefix, group and threshold fields (which seem to be set
correctly in your MIPS dump).

I wonder how this is supposed to work, I can't find a place which zeroes
relevant data. It looks like we're missing memset() calls in
ebt_register_{match,watcher,target} functions. OTOH this seems to work
fine in most cases, so I'm likely missing something.

Cheers, Phil
