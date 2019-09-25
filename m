Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80F58C432C2
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 18:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF3CE21655
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 18:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="taz+4I4H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408520AbfIYSW1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 14:22:27 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:47461 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404557AbfIYSW1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 14:22:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 44A576740110;
        Wed, 25 Sep 2019 20:22:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1569435742; x=1571250143; bh=Kc9W1T00Ri
        idqTAIqbZCtIE+qyOAz1+HpqhhEjShJI4=; b=taz+4I4HD+WsFjJye26APACMh3
        ZH34qX0EaLUHNeWOGXZnsMve7QVdWNCLOs9zhBsmcCzIIoD2jKD8ZtHNeMjPNsvb
        hRcV2aCqNJ5HA7UqTcQyGnPHTi/J6GmWyBE5iUlKJI9kKzC+VGDKXXYp46gA/O6x
        AUL+drXrNphbBZKOs=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed, 25 Sep 2019 20:22:22 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id E7D3167400FF;
        Wed, 25 Sep 2019 20:22:21 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id C646B20C53; Wed, 25 Sep 2019 20:22:21 +0200 (CEST)
Date:   Wed, 25 Sep 2019 20:22:21 +0200 (CEST)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Kristian Evensen <kristian.evensen@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC] ipset: Add wildcard support to net,iface
In-Reply-To: <20190924150342.16536-1-kristian.evensen@gmail.com>
Message-ID: <alpine.DEB.2.20.1909252015320.16238@blackhole.kfki.hu>
References: <20190924150342.16536-1-kristian.evensen@gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Kristian,

On Tue, 24 Sep 2019, Kristian Evensen wrote:

> The net,iface equal functions currently compares the full interface 
> names. In several cases, wildcard (or prefix) matching is useful. For 
> example, when converting a large iptables rule-set to make use of ipset, 
> I was able to significantly reduce the number of set elements by making 
> use of wildcard matching.
> 
> Wildcard matching is enabled by setting the 
> IPSET_FLAG_IFACE_WILDCARD-flag when adding an element.  When this flag 
> is set, only the initial part of the interface name of the set element 
> is used for comparison.
> 
> I am submitting this change as an RFC, as I am not sure if my approach 
> with using a flag (or wildcard matching at all) is OK. Please note that 
> this patch is against kernel 4.14, as that is what my current devices 
> are running. A final submission will be against net-next.

I like your patch, it's a nice extension. Please submit it against the 
ipset git tree, that's the easiest for me to handle the patches. I'll 
arrange the submission to net-next.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
