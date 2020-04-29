Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EA7C83000
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 15:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79C4D206B8
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 15:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="MomnpdyU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgD2PjE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgD2PjE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 11:39:04 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30671C03C1AE
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 08:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588174742;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BQaanARf5K7321K2nWvXcrf3jgRo8Dk2Su0KNPlvCOM=;
        b=MomnpdyUdOnkhAA78Z9o262mNKE7sejCnwmJTFNGZZt/SJAUgJiRvJ8Xn+znft6F+w
        mJGyurqeMwECMuO+NhNqTvW7EZcflG5VT8z7875bmMDwNT1lIgxyLaUtvEj2+tO7EvFF
        tNp9hspSzzm0OKVZ4Ov5o/JVBv9ebPZGE6o7cBxi/B18yYKEOBDiCDW88rW1bl+dTNHF
        zlxH9fOFC58P0v5zeaTGcHarTFvrbHWBOJ3XLAFOwj6Ss85Nc8NautE0OiP551vTKb+a
        1HjFhzUL1VepjXuJ1Ia3LC4bsvU6Xr+p55J5KLSshtxvnc8QqV9OwI60z6XzG+Q3m/xJ
        blIg==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpew15s8IitTOq+h3BEg=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id g05fffw3TFd1acs
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 29 Apr 2020 17:39:01 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 6776315411E;
        Wed, 29 Apr 2020 17:39:01 +0200 (CEST)
Received: from o6px4qS4yqFqYq/ES/pLrINtTWA03DvXf553SNg5Qfr5WJfZfBtnYg==
 (3kos4UfGNfY94RM0Mb3ug55phk4QZ9vc)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Wed, 29 Apr 2020 17:38:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Apr 2020 17:38:47 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issues with nft typeof
In-Reply-To: <20200428220428.GA18203@salvia>
References: <adfe176a20d9b4f9f93ed7e783309ee9@fami-braun.de>
 <20200428220428.GA18203@salvia>
User-Agent: Roundcube Webmail/1.4.2
Message-ID: <c84577d48bb4c77409482393d07008b1@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Am 29.04.2020 00:04, schrieb Pablo Neira Ayuso:
> Could you give a try to the following patch?

thanks, that fixes it for me.

Regards,
M. Braun
