Return-Path: <SRS0=aW9c=VA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A90C4646D
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D072218B8
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jul 2019 12:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1562156351;
	bh=GpARfgYUgT5olAUEuC9ccJgpBkUXS4H7tRQyYVWvS3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dGeYPUopnTyrXixLejLZgYphdYaDtw9sU+EEnWz8paZZQzdulG40ob2E2jhkGbCzU
	 rcxUvgHYH7Qrh1sCiNB5VLD8q3FU12vYh5tiJ2LjLI1aAIAskyN3hf4KGFd4gwHRf4
	 xVUohwlRCVgpNjEV6P67Ac1UrFwkuGJkvlOTdQbU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfGCMTK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jul 2019 08:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbfGCMTK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jul 2019 08:19:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F17CA218A4;
        Wed,  3 Jul 2019 12:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562156349;
        bh=GpARfgYUgT5olAUEuC9ccJgpBkUXS4H7tRQyYVWvS3M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eSzg0uUn6ek35jC7H7r+LIbYN4HyR4PzA3DQHqPUERTelLPZ0tMqk75xXE8I7zROC
         Xg5qbQLPMW+WF2krmTx/eU0aoLD/6EtjFiJoxo1djeK874bcT79GVczRzOSSJvG3ET
         TH9rpK16/n1Gfco5VsCQFAZE9kCrkUvlJ8CseqP0=
Date:   Wed, 3 Jul 2019 14:19:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: netfilter patches for -stable
Message-ID: <20190703121906.GF7784@kroah.com>
References: <20190702234321.cwqnmqhfymfg6hqh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702234321.cwqnmqhfymfg6hqh@salvia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 03, 2019 at 01:43:21AM +0200, Pablo Neira Ayuso wrote:
> Hi Greg,
> 
> Would you consider to take the following patches for -stable?
> 
> e75b3e1c9bc5 netfilter: nf_flow_table: ignore DF bit setting
> 8437a6209f76 netfilter: nft_flow_offload: set liberal tracking mode for tcp
> 91a9048f2380 netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
> 69aeb538587e netfilter: nft_flow_offload: IPCB is only valid for ipv4 family
> 
> Users report this is fixing a connection stall in:
> 
>         https://bugzilla.kernel.org/show_bug.cgi?id=203671

All now qeued up, thanks.

greg k-h
