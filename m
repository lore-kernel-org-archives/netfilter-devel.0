Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5554BC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 15:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE90A22268
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602774618;
	bh=uSyzSjCAQe5VE7I4XLzVlHGN3ujRUVk1OBWtEAErJ0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=U08E3uC0DHd8awT+9PoTrl2JAGbrIVSD7Mm4kGEoiNdMrfPm36Y3GzjuvQ1+MPazd
	 j18AbMyVGOS1Q5p254C7VnSgx7lIxKqI5oSLkzyLpRiaZdmr3+nYGdhRvh/LPphXz7
	 TXtgEep9xLCQeSLYrjIiZqvQr4mk1i5DBEl0FTsI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbgJOPKQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 11:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388764AbgJOPKQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 11:10:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99C052080A;
        Thu, 15 Oct 2020 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602774615;
        bh=uSyzSjCAQe5VE7I4XLzVlHGN3ujRUVk1OBWtEAErJ0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vuUrXRpeelXzRTxBlzRP5oLunvIlkU1QmP8caWyoUdcxAZr17107iD3ookQC/PqAg
         Zs7BXvpRt6UbTq6sxwpT/yMiyFvRnVwl3Hpw5fwswx1pd4opAsEbqq83cM8+sNtwLG
         R/LL6X75HGnsdKeK8ipiiJJtRWgTNTYwsGrd//AE=
Date:   Thu, 15 Oct 2020 08:10:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 9/9] netfilter: flowtable: add vlan support
Message-ID: <20201015081013.4f059b7b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015011630.2399-10-pablo@netfilter.org>
References: <20201015011630.2399-1-pablo@netfilter.org>
        <20201015011630.2399-10-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 15 Oct 2020 03:16:30 +0200 Pablo Neira Ayuso wrote:
> Add the vlan id and proto to the flow tuple to uniquely identify flows
> from the receive path. Store the vlan id and proto to set it accordingly
> from the transmit path. This patch includes support for two VLAN headers
> (Q-in-Q).
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

20+ sparse warnings here as well - do you want to respin quickly?
