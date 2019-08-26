Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4261C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 09:28:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8154C22CED
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 09:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730877AbfHZJ2f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 05:28:35 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:36385 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730863AbfHZJ2e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 05:28:34 -0400
Received: from [47.60.32.119] (helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <pablo@gnumonks.org>)
        id 1i2BIZ-00030x-H1; Mon, 26 Aug 2019 11:28:33 +0200
Date:   Mon, 26 Aug 2019 11:28:25 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ander Juaristi <a@juaristi.eus>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] netfilter: Introduce new 64-bit helper functions
Message-ID: <20190826090346.35gz4mds253tp2zd@salvia>
References: <20190817111753.8756-1-a@juaristi.eus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190817111753.8756-1-a@juaristi.eus>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 17, 2019 at 01:17:52PM +0200, Ander Juaristi wrote:
> Introduce new helper functions to load/store 64-bit values
> onto/from registers:
> 
>  - nft_reg_store64
>  - nft_reg_load64
> 
> This commit also re-orders all these helpers from smallest
> to largest target bit size.

Applied, thanks.
