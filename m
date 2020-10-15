Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2E5C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 04:21:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ED5C2223F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 04:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602735709;
	bh=kHgB6WuhgzumLLhyQf5uwRbAknZdqU9j4Q1RnOJufG8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=w02plff0YBpLLwj2lPByh8bbveMnL4AfnP0zhgQKntEGQkUOJXExTCbtP0vzC84VG
	 mfyoMvhvWTthw2kS2WpzuFJ0NBOt6XdiP4rAO0SbEGj0QDT5j3qYhRyXLwFuEuFQm9
	 v+KI9+bbqDb3GPsYcDhmz1BARp6k9T6WnlpbTkDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgJOEVr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 00:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbgJOEVr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 00:21:47 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC3322210;
        Thu, 15 Oct 2020 04:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602735706;
        bh=kHgB6WuhgzumLLhyQf5uwRbAknZdqU9j4Q1RnOJufG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZnU3OUMui8tEsFbsCAtaPHIOIQY14lnkIRtXardl94zxSv+qm5UPfYUD4wIPsriXd
         jMNx/QnwN1vEkwYfuW+dD0FDLjHMwb7SjZplT3Pwal1k7e2GiChCCJ86Bbre3UGCg5
         iSPYSSrNYD/HNS3p4W7XIV2hTg6cJyC/uGSI0SZ4=
Date:   Wed, 14 Oct 2020 21:21:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: restore NF_INET_NUMHOOKS
Message-ID: <20201014212144.2f5cdfdb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014193432.3446-1-pablo@netfilter.org>
References: <20201014193432.3446-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 14 Oct 2020 21:34:32 +0200 Pablo Neira Ayuso wrote:
> This definition is used by the iptables legacy UAPI, restore it.
> 
> Fixes: d3519cb89f6d ("netfilter: nf_tables: add inet ingress support")
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Jakub: if you please can take this into net-next, it is fixing fallout
>         from the inet ingress support. Thank you.

Applied, thanks!
