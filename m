Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72B5C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jun 2022 17:07:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiFFRHK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 13:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbiFFRGc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 13:06:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCFE14B2EA;
        Mon,  6 Jun 2022 09:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EA55B81A96;
        Mon,  6 Jun 2022 16:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B4CC385A9;
        Mon,  6 Jun 2022 16:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654534575;
        bh=ADSWfEoyHPIwRKBxZNv7zeLCNBzklels2wFVppoon2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GaLLBPnAjK7q0tDhGdDOfn/LQYh6vJAtc9nI2aYeIFx2wCL0bOYlTlaksYS4cepTE
         6FcgcAZm9P+CsYiVPregWTKZ5jnvCTCUArqbk+shT7RHufDISfedPUqUAIamwUoYkE
         Xyg8vBouFLO0Ot9Jks8CCDjXjtUk9ZLxZDn1LPVg=
Date:   Mon, 6 Jun 2022 18:56:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        netfilter-devel@vger.kernel.org, linux-spdx@vger.kernel.org,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: netfilter: xtables: Bring SPDX identifier back
Message-ID: <Yp4xrPVwI8g7glwr@kroah.com>
References: <87ee016cji.ffs@tglx>
 <Yp4eiv4xUhWc2VEx@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp4eiv4xUhWc2VEx@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 06, 2022 at 05:34:34PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 06, 2022 at 05:23:45PM +0200, Thomas Gleixner wrote:
> > Commit e2be04c7f995 ("License cleanup: add SPDX license identifier to
> > uapi header files with a license") added the correct SPDX identifier to
> > include/uapi/linux/netfilter/xt_IDLETIMER.h.
> > 
> > A subsequent commit removed it for no reason and reintroduced the UAPI
> > license incorrectness as the file is now missing the UAPI exception
> > again.
> > 
> > Add it back and remove the GPLv2 boilerplate while at it.
> 
> LGTM.
> 
> You handle this or I place this in the nf.git tree?

If you want to take it, that's fine with me, otherwise I can in a
spdx-specific tree that I manage.

Your choice, which ever is easier for you.

thanks,

greg k-h
