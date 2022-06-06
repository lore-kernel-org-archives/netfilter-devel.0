Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B345C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  6 Jun 2022 17:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiFFRQp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 6 Jun 2022 13:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiFFRQQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Jun 2022 13:16:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26841498D3;
        Mon,  6 Jun 2022 10:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88144B81AC2;
        Mon,  6 Jun 2022 17:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9448C34115;
        Mon,  6 Jun 2022 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654535419;
        bh=xX5tSqVHfGZXOwH+hax5b3LDy48lqg6Fjv/dLY4o8BA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rityNW8O/O6qw8Me+6IeTg83Z5fPu/wxWXWOBxxSn3D4ZSCywAtQQ4LOw0U04b5x0
         3g/u+HuMchaaGRohYX5cxF+NlhsrCeYO4xZdNRgOycFysDZyN88EdiG+Mt3r4xWCsB
         8WUCNxkR5Eoq7b4pcJqWOmRk1PTo9GO3r2kOzW7o=
Date:   Mon, 6 Jun 2022 19:10:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        netfilter-devel@vger.kernel.org, linux-spdx@vger.kernel.org,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: netfilter: xtables: Bring SPDX identifier back
Message-ID: <Yp407GnFxpONk18I@kroah.com>
References: <87ee016cji.ffs@tglx>
 <Yp4eiv4xUhWc2VEx@salvia>
 <Yp4xrPVwI8g7glwr@kroah.com>
 <Yp4y19o3EnRE+f7r@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yp4y19o3EnRE+f7r@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 06, 2022 at 07:01:11PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jun 06, 2022 at 06:56:12PM +0200, Greg KH wrote:
> > On Mon, Jun 06, 2022 at 05:34:34PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Jun 06, 2022 at 05:23:45PM +0200, Thomas Gleixner wrote:
> > > > Commit e2be04c7f995 ("License cleanup: add SPDX license identifier to
> > > > uapi header files with a license") added the correct SPDX identifier to
> > > > include/uapi/linux/netfilter/xt_IDLETIMER.h.
> > > > 
> > > > A subsequent commit removed it for no reason and reintroduced the UAPI
> > > > license incorrectness as the file is now missing the UAPI exception
> > > > again.
> > > > 
> > > > Add it back and remove the GPLv2 boilerplate while at it.
> > > 
> > > LGTM.
> > > 
> > > You handle this or I place this in the nf.git tree?
> > 
> > If you want to take it, that's fine with me, otherwise I can in a
> > spdx-specific tree that I manage.
> 
> I did not know there is a specific tree for this.
> 
> > Your choice, which ever is easier for you.
> 
> please take it

Will do, thanks!

greg k-h
