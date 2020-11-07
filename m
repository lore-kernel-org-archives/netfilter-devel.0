Return-Path: <SRS0=C+nS=EN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3D68C388F7
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Nov 2020 17:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D89A208FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Nov 2020 17:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604771550;
	bh=Ek8fLm8CsziGOioX30LOA4auYUYzdOZZY0eTuGPWcfc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=YFHu6ASqCStq9ZlWEV+/+I7i5w3q09sDWMjvxU3RxMRL+NZjzhWrNMv7kV+WvSJ5l
	 jrr4eC+lob/ndBvNn4eFtG7fFHsvzXirqqptGesKfGgzDFXfFsqYxeDKC9qrG292Lu
	 XqeqzjbXqzoOLsTu9TaHgbSBP3RcT6DqgpV5P9p4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728139AbgKGRwZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Nov 2020 12:52:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726614AbgKGRwZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Nov 2020 12:52:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D209320885;
        Sat,  7 Nov 2020 17:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604771545;
        bh=Ek8fLm8CsziGOioX30LOA4auYUYzdOZZY0eTuGPWcfc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KwKf/2R51UpXegvQjPlFVDOl0p2hMluq1qw8FEBAPjkE4vlxnixWahOmH7RYJYENy
         9p9ZoMxIyXD92MbzXsbRnvANVMD/qkVK+D/15NIX2N3YiDsvv/eYZwsLzAkeQNV77h
         fHoEuI4De4klH1TaELuhV1rFgG52aJHQgokj6k08=
Date:   Sat, 7 Nov 2020 09:52:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Chancellor <natechancellor@gmail.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] netfilter: conntrack: fix -Wformat
Message-ID: <20201107095224.63c27a1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201107075550.2244055-1-ndesaulniers@google.com>
References: <20201107075550.2244055-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  6 Nov 2020 23:55:50 -0800 Nick Desaulniers wrote:
> -			   ntohs(tuple->src.u.icmp.id));
> +			   (__be16)ntohs(tuple->src.u.icmp.id));

Joe has a point, besides __be16 clearly is not the right type here,
the result of ntohs is in host order.
