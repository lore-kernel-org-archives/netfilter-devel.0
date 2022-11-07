Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CBC2C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Nov 2022 08:00:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbiKGIA4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Nov 2022 03:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbiKGIAy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Nov 2022 03:00:54 -0500
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F96B13EB6
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Nov 2022 00:00:53 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 80506CC02AD;
        Mon,  7 Nov 2022 09:00:50 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon,  7 Nov 2022 09:00:48 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id E19ABCC02A9;
        Mon,  7 Nov 2022 09:00:47 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id D37A5343157; Mon,  7 Nov 2022 09:00:47 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id D1A79343156;
        Mon,  7 Nov 2022 09:00:47 +0100 (CET)
Date:   Mon, 7 Nov 2022 09:00:47 +0100 (CET)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Vishwanath Pai <vpai@akamai.com>
cc:     pablo@netfilter.org, fw@strlen.de, johunt@akamai.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Add support for new bitmask parameter
 (userspace)
In-Reply-To: <20220928182536.602688-1-vpai@akamai.com>
Message-ID: <4554f4c9-6042-3218-faa5-80eaa365614d@netfilter.org>
References: <20220928182536.602688-1-vpai@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
 
On Wed, 28 Sep 2022, Vishwanath Pai wrote:

> Add a new parameter to complement the existing 'netmask' option. The 
> main difference between netmask and bitmask is that bitmask takes any 
> arbitrary ip address as input, it does not have to be a valid netmask.
> 
> The name of the new parameter is 'bitmask'. This lets us mask out
> arbitrary bits in the ip address, for example:
> ipset create set1 hash:ip bitmask 255.128.255.0
> ipset create set2 hash:ip,port family inet6 bitmask ffff::ff80
> 
> This patchset contains userspace patches, I will submit the kernel patch
> separately.
> 
> Changes in v2 based on code review comments:
>     * Removed the changes to nf_inet_addr.h and nfproto.h, this will break on older kernels
>     * Remove bitmask option from net,net since it is redundant, update the manpage
>     * Add tests for the new bitmask param (similar to netmask tests)

Thanks for the patch, it's much better. I have a few comments only and 
will send them separatedly at the given patches. All other parts are OK.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
