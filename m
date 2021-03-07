Return-Path: <SRS0=fhTi=IF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E5BC433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Mar 2021 15:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6BE64FF0
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Mar 2021 15:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCGPDA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Mar 2021 10:03:00 -0500
Received: from rs2.larkmoor.net ([162.211.66.16]:44138 "EHLO rs2.larkmoor.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhCGPCx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Mar 2021 10:02:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=larkmoor.net; s=larkmoor20140928;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject; bh=su/q5fZeI/wN8czVsBKz39XBbdFvQx75Bb9U0MSq6Gs=;
        b=f/SU5oa6VrCZudyrnR44xM3+tBcp2cr1SCnNCf3TyTomJu2Z2eOhbliEDyGrND0w7oM65QkWiQu/GrAjzglw64QxhxbQYE4GCRY6Czd4mgQUPy96qoNyRtmAlWS/lVQ7+hIDkturqC20xcxx/sjbierC+1h5N9lJCiRkQus0S7U=;
Received: from [10.0.0.31]
        by gw.larkmoor.net with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <fmyhr@fhmtech.com>)
        id 1lIuvl-00003j-2c; Sun, 07 Mar 2021 10:02:53 -0500
Subject: Re: [RFC PATCH] doc: use symbolic names for chain priorities
To:     Simon Ruderich <simon@ruderich.org>,
        netfilter-devel@vger.kernel.org
References: <b1320180e5617ae9910848b7fc17daf9c3edca04.1615109258.git.simon@ruderich.org>
From:   Frank Myhr <fmyhr@fhmtech.com>
Message-ID: <0a7f088c-f813-0425-8bec-d693d95a97a0@fhmtech.com>
Date:   Sun, 7 Mar 2021 10:02:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b1320180e5617ae9910848b7fc17daf9c3edca04.1615109258.git.simon@ruderich.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021/03/07 09:43, Simon Ruderich wrote:

> I don't understand how the priority option actually works. The
> documentation states that it "specifies the order in which chains
> with the same *hook* value are traversed". However, from what I
> understand it's not only relevant for the order of multiple
> custom hooks but it also maps to the priority used for the
> netfilter hooks inside the kernel (e.g. -300 which happens before
> conntrack handling in the kernel). Please correct me if this is
> wrong.
> 
> Assuming the above is more or less correct, I don't understand
> why the old rules worked:
> 
>      add chain nat prerouting { type nat hook prerouting priority 0; }
>      add chain nat postrouting { type nat hook postrouting priority 100; }
> 
> Isn't priority 0 "too late" as 0 is also used for filter? Or are
> nat and filter types completely separate and the order is only
> relevant for hooks of the same type? If so, why does postrouting
> require priority 100 (shouldn't the kernel put prerouting before
> postrouting automatically)? Or would any value greater than 0
> also work as long as it's after postrouting? And why are dstnat
> and srcnat set to -100 and 100?

Hi Simon,

Priority is only relevant _within a given hook_. So comparing priorities 
of base chains hooked to prerouting and postrouting (as in your example 
above) does not make sense. Please see:

https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains#Base_chain_priority

https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks

Hope that clears things up for you.

Best Wishes,
Frank
