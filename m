Return-Path: <SRS0=U5qg=5O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986C6C43331
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 18:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D25E20732
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Mar 2020 18:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=thinline.cz header.i=@thinline.cz header.b="Y1CK06Ea"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728639AbgC2SXZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 14:23:25 -0400
Received: from gelf9.thinline.cz ([91.239.200.179]:41171 "EHLO
        gelf9.thinline.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgC2SXZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 14:23:25 -0400
Received: from localhost (unknown [127.0.0.1])
        by gelf9.thinline.cz (Postfix) with ESMTP id 12A8574813;
        Sun, 29 Mar 2020 18:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=thinline.cz;
        s=gelf9-201906; t=1585506203;
        bh=F3RCzA8jEE3UWftQgoZbMRIjTWQ47dMLWkoqMftaK7o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Y1CK06Eav4oIyfEEkYKPlanpUR3Z0w/WGZlpfmyw1Ow+6Iy0PYVsHGG1Uf4kKnT53
         qPGomE5MzC0fX5MO0s+jpye1c9tGfjG2f2/KDf05gwfltVpEx/2g3udUrWOi9kT6s6
         DBmyZZ8ZyhrvfrN1cF8fiv85GU8oAMEiNj2kWRqYh3dEzaqXtzbS4DxY1dnlsX9/m6
         rt2JcsChOZf97ql/E9vyj9040N1nYYxGRKgvLs9HNWj6QlyZxMFEEvEexf6Fk6FFIS
         p3DrgfHeVdQ8+3lG3m7U35ZDkfgpLN1j5K10xrVNXFYoK13FRnCcJE0rWa3rxf5TIn
         B/3ucpdgCPlUw==
X-Virus-Scanned: amavisd-new at thinline.cz
Received: from gelf9.thinline.cz ([127.0.0.1])
        by localhost (gelf9.cesky-hosting.cz [127.0.0.1]) (amavisd-new, port 10025)
        with ESMTP id C_Y51C4UNwKg; Sun, 29 Mar 2020 20:23:22 +0200 (CEST)
Received: from webmail2.cesky-hosting.cz (localhost [127.0.0.1])
        (Authenticated sender: jaroslav@thinline.cz)
        by gelf9.thinline.cz (Postfix) with ESMTPA;
        Sun, 29 Mar 2020 20:23:22 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 29 Mar 2020 20:23:22 +0200
From:   jaroslav@thinline.cz
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Suggestion: replacement for physdev-is-bridged in nft
In-Reply-To: <20200329155349.GB23604@breakpoint.cc>
References: <8b6e45ba8945b226e4c95e6e9a1cf2e4@thinline.cz>
 <20200329155349.GB23604@breakpoint.cc>
Message-ID: <90d3abe733527e18d53d53989e7ad7ca@thinline.cz>
X-Sender: jaroslav@thinline.cz
User-Agent: Roundcube Webmail/1.3.10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> rmmod br_netfilter
> 
> or set
> net.bridge.bridge-nf-call-arptables=0
> net.bridge.bridge-nf-call-iptables=0
> net.bridge.bridge-nf-call-ip6tables=0

Alright, the possibility that bridged (non-routed) packets don't need to 
go through filtering rules didn't occur to me at all

Thanks a lot for pointing it out, no physdev-is-bridged needed for me 
now.
