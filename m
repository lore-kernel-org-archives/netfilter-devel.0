Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AC8C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 10:38:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6074F20663
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 10:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="kRcYbh7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgEFKic (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 06:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728338AbgEFKib (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 06:38:31 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC86C061A0F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 May 2020 03:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588761508;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BoeF2Zl4oSI1mAqABBsDGllZUlV3eGECT/MZwdR852g=;
        b=kRcYbh7bWEso8pqMIZA8Yj4hJdz7Y6lUN6AZrbt1KPxDcsdl8Ia+igaq2UxWlep4Mn
        2EbxPYCNOCNx87w8xHaQWEWrClqK3JM4wrRsJaFEKHcUlpQGlJ+yUWSWwhDNQpG0oDAf
        X0G3BAS2kK/5JOLVSsQYvwcgSZnwmqPA2mngKhg0OBaN90D4y7Y+eROfdZuFPONy4V77
        KFnlmqc2aMTUNqeN0a3pqcZVmg0t0Iq8c/dPacXepbYDNRmqldpgOUnsjyjP11eJZDTK
        K11nycMFfWzkX8YAANuPDbZKaJnwhveOA/2oRNIkavWXnlLpG1VPdPLSxrLcz1JiSRIS
        3F4g==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpew15s8IitTOq+h4VmQ=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id g05fffw46AcS0wa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 6 May 2020 12:38:28 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 181B71540EA;
        Wed,  6 May 2020 12:38:28 +0200 (CEST)
Received: from 4sIHYdt22zPTOP4SdjmNfXb2/8dokteyCAqZC7Im6T4+YKPd/n4i8w==
 (nnvVT5LEcvwf9TDFJdTjzqZY9PeluXoE)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Wed, 06 May 2020 12:38:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 06 May 2020 12:38:17 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] rule: fix out of memory write if num_stmts is too low
In-Reply-To: <20200505192723.GA30019@salvia>
References: <20200504204858.15009-1-michael-dev@fami-braun.de>
 <20200505121756.GA8781@salvia>
 <284c0e0cba6ddfa50872e7250d8b35c7@fami-braun.de>
 <20200505192723.GA30019@salvia>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <904b5458697b3960f7944843964793b0@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Am 05.05.2020 21:27, schrieb Pablo Neira Ayuso:
> BTW, did you update tests/py to run it under ASAN, a patch for this
> would be great.

I was running
   ./configure CFLAGS="-g -O0 -fsanitize=address -fsanitize=undefined 
-fno-omit-frame-pointer" LDFLAGS="-lasan"
so libnftables was compiled with ASAN.

But when running the python test, it complained that libasan wasn't 
loaded as the first library, so I used
   LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libasan.so.5 ./nft-test.py -d 
bridge/vlan.t
to fix that.

Some python leaks or all leaks can be suppressed as described here: 
https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer

This doesn't really look to me like it can be patched easily into the 
python test scripts, as it might need a reconfigure/rebuild.

Regards,
M. Braun
