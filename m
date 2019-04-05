Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03855C4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:46:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C99772171F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 10:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfDEKqM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 06:46:12 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:53771 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbfDEKqM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 06:46:12 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hCMML-0003LR-7q; Fri, 05 Apr 2019 12:46:11 +0200
Date:   Fri, 5 Apr 2019 12:46:08 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Sam Banks <sam.banks.nz@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Typo in extensions/libxt_osf.man
Message-ID: <20190405104608.4tn7esknyb5rqhdz@salvia>
References: <CAMbLQsynsgPK_yue8BusSU6k7-NXgD2=9VaUMwPuVzR9G+ri2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbLQsynsgPK_yue8BusSU6k7-NXgD2=9VaUMwPuVzR9G+ri2w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 22, 2019 at 12:22:47PM +1300, Sam Banks wrote:
> Hi,
> 
> I was browsing the iptables-extensions man page and spotted a typo in
> the osf section. I've attached a patch which corrects it.

Applied, thanks.
